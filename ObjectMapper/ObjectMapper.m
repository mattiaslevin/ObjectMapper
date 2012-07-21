//
//  ObjectMapper.m
//  ObjectMapper
//
//  Created by Mattias Levin on 2011-10-02.
//  Copyright 2011 Wadpam. All rights reserved.
//

// TODO: Check memory usage
// TODO: Handle built in types (int, float etc)?
// TODO: Support mapping to Core Data object

// Future
// Add a cache to reduce reflection, if needed add a map as property to save all mappings. How much time would we save?
// Add code generation of meta data to reduce reflecton


#import "ObjectMapper.h"
#import <objc/runtime.h>
#include <sys/time.h>

// Uncomment the line below to get debug statements
//#define PRINT_DEBUG
//Debug macros
#ifdef PRINT_DEBUG
#  define DLOG(fmt, ...) NSLog( (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#  define DLOG(...)
#endif
// ALog always displays output regardless of the DEBUG setting
#define ALOG(fmt, ...) NSLog( (@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define MAP_KEY_TO_PROPERTY_PREFIX @"object_mapper_property_for_"
#define MAP_CLASS_TO_ARRAY_PREFIX @"object_mapper_class_for_"
#define MAP_KEY_TO_BLOCK_PREFIX @"object_mapper_block_for_"

// Possible parsed JSON types
typedef enum {
  Object,
  Array,
  String,
  Number,
  Null,
  Empty,
  Unkown,
} JSONType;



// NSDictionart category
@implementation NSDictionary (ObjectMapper) 

- (id)mapToClass:(id)clazz withError:(NSError**)error {
  return [[ObjectMapper mapper] mapObject:self toClass:clazz withError:error];
}

@end


// NSArray category
@implementation NSArray (ObjectMapper) 

- (id)mapToClass:(id)clazz withError:(NSError**)error {
  return [[ObjectMapper mapper] mapObject:self toClass:clazz withError:error];
}

@end


// Private stuff
@interface ObjectMapper (hidden)

- (void)map:(NSDictionary*)source toObject:(id)target error:(NSError**)error;

- (void)map:(NSArray*)source toArray:(NSMutableArray*)target withClass:(Class)clazz error:(NSError**)error;
- (void)map:(NSArray*)source toArray:(NSArray**)target withBasicType:(Class)basicType error:(NSError**)error;

- (id)mapToBasicType:(id)source error:(NSError**)error;

- (Class)classForProperty:(objc_property_t)property;
- (Class)classForArrayWithKey:(NSString*)key target:(id)target;
- (Class)classFromTypeEncoding:(NSString*)typeEncoding;
- (JSONType)jsonType:(id)source;
- (double)timestamp;
- (NSError*)parsingErrorWithDescription:(NSString*)format, ...;

+ (NSArray*)propertyNamesForClass:(Class)aClass;
+ (NSArray*)methodNamesForClass:(Class)aClass;

@end


// Implementation
@implementation ObjectMapper


// Class method for returning a mapper object
+ (id) mapper {
  return [[[ObjectMapper alloc] init] autorelease];
}


// Init methid
- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here
  }
  
  return self;
}


// Release instance variables
- (void)dealloc {
  [super dealloc];
}


// Map parsed JSON to domain objects
- (id)mapObject:(id)source toClass:(id)clazz withError:(NSError**)error {
  double startTimestamp = [self timestamp];
  #pragma unused(startTimestamp) // Supress compiler warning when logging is disabled
  
  // The root object in the graph
  id root = nil;    
  
  // Check input parameters
  if (source == nil) {
    *error = [self parsingErrorWithDescription:@"Parsed JSON is nil, not possible to do any mapping"];
    return nil;
  } else if (clazz == nil) {
    *error = [self parsingErrorWithDescription:@"Root class can not be nil"];  
    return nil;
  }
  
  switch ([self jsonType:source]) {
    case Object:
      // The parsed JSON is an object
      root = [[[clazz alloc] init] autorelease];
      [self map:source toObject:root error:error];
      break;
    case Array:
      // The parsed JSON is an array
      // Need to figure out if the content of the array are objects or basic types
      if ([source count] == 0) {
        // Empty array
        root = [NSArray array];
      } else if ([self jsonType:[source objectAtIndex:0]] == Object) {
        // The array contains objects
        root = [NSMutableArray array];
        [self map:source toArray:root withClass:clazz error:error];
      } else
        // The array contains a basic type
        [self map:source toArray:&root withBasicType:clazz error:error];                            
      break;
    case String:
    case Number:
    case Null:
    default:
      // Not allowed
      *error = [self parsingErrorWithDescription:@"Not possible to map a parsed JSON root that is a basic type. Root must be an object or array"];
      break;
  }
  
  // Measure and log how long the mapping took
  NSLog(@"Mapping time %f", [self timestamp] - startTimestamp);

  if (*error) {
    // An error was raised during the recursive mapping
    DLOG(@"Mapping failed with error %@", [*error description]);
    [*error autorelease];
    return nil;
  } else {   
    // Mapping was successful
    DLOG(@"Mapping was successful with objects = %@", root);
    return root;
  }
  
}


// Map to an object
- (void)map:(NSDictionary*)source toObject:(id)target error:(NSError**)error {
  DLOG(@"Map parsed JSON to object: %@", target);
  
  // Check that the target is not nil
  if (target == nil) {
    *error = [self parsingErrorWithDescription:@"Taget object of type %@ is nil", class_getName([target class])];
    return;
  }
  
  // Create autorelease pool
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  // Iterate over each key/value in the parsed JSON
  for (NSString *key in [source allKeys]) {
    DLOG(@"Key name: %@", key);
    
    // Check that there are no mapping errors, otherwise stop the mapping process
    if (*error)
      break;
    
    // Check if a property exist with the sane name in the target object
    objc_property_t property = class_getProperty([target class], [key cStringUsingEncoding:NSASCIIStringEncoding]);
    
    if(property == NULL) {
      // If not check if a property exists with the same name starting with "_"
      // Needed to handle key names that are also reserved words
      property = class_getProperty([target class], [[@"_" stringByAppendingString:key] cStringUsingEncoding:NSASCIIStringEncoding]);
    }
      
    // Check anotation mapping
    if (property == NULL) {
      NSString *selectorName = [MAP_KEY_TO_PROPERTY_PREFIX stringByAppendingString:key];
      if ([target respondsToSelector:NSSelectorFromString(selectorName)]) {
        DLOG(@"Found matching annotation for key %@", key);
        NSString *propertyName = [target performSelector:NSSelectorFromString(selectorName)]; 
        property = class_getProperty([target class], [propertyName cStringUsingEncoding:NSASCIIStringEncoding]);
      }
    }
      
    if (property == NULL) {
      // The property does not exist, skip mapping
      DLOG(@"Property with key name: %@ does not exists in target, skip", key);
      // Print all methods and properties for debugging purpose
      //NSArray *allMethodNames = [ObjectMapper methodNamesForClass:[target class]];
      //NSArray *allPropertyNames = [ObjectMapper propertyNamesForClass:[target class]];
      //DLOG(@"All methods names: %@", allMethodNames);
      //DLOG(@"All property names: %@", allPropertyNames);
      continue;
    }
      
    // Get the json value
    id value = [source valueForKey:key];
    
    // Get class from key name
    Class targetPropertyClazz = [self classForProperty:property];
    id targetPropertyValue = nil;
    
    // Check the type of the value
    switch ([self jsonType:value]) {
      case Object:
        DLOG(@"Value is of type object");
        
        // Create object from class
        targetPropertyValue = [[[targetPropertyClazz alloc] init] autorelease];
        if(targetPropertyValue == nil) {
          *error = [self parsingErrorWithDescription:@"Could not create object from class: %@ for key: %@", targetPropertyClazz, key];
          continue;
        }
        
        // Map newly created object
        [self map:value toObject:targetPropertyValue error:error];                
        
        break;
      case Array:
        DLOG(@"JSON value is of type array");
        
        // Need to figure out if the content of the array are objects or basic types
        if ([value count] == 0) {
          // Empty array
          targetPropertyValue = [NSArray array];
        } else if ([value count] > 0 && [self jsonType:[value objectAtIndex:0]] == Object) {
          targetPropertyValue = [NSMutableArray array];
          
          // Get the class that goes into the array
          targetPropertyClazz = [self classForArrayWithKey:key target:target];
          
          //Start mapping the objects to the array
          [self map:value toArray:targetPropertyValue withClass:targetPropertyClazz error:error];    
        } else
          // Array contain basic types
          [self map:value toArray:&targetPropertyValue withBasicType:[[value objectAtIndex:0] class] error:error];
        
        break;
      case Null:
        targetPropertyValue = nil;
        break;
      case String:
      case Number:
        DLOG(@"Value is of basic type");        
        targetPropertyValue = [self mapToBasicType:value error:error];
        if(targetPropertyValue == nil) { 
          *error = [self parsingErrorWithDescription:@"Could not create basic type for key: %@", key];
          continue;
        }        
        break;
      default:
        *error = [self parsingErrorWithDescription:@"Value is of unknown type for key: %@", key];
        continue;
    }
    
    // Check for custom converters
    NSString *selectorName = [MAP_KEY_TO_BLOCK_PREFIX stringByAppendingString:key];
    if ([target respondsToSelector:NSSelectorFromString(selectorName)]) {
      DLOG(@"Value before conversion %@", targetPropertyValue);
      id(^coverterBlock)(id) = [target performSelector:NSSelectorFromString(selectorName)];
      targetPropertyValue = coverterBlock(targetPropertyValue);
      DLOG(@"Value after conversion %@", targetPropertyValue);
    }
    
    // Set the value for the property
    // TODO: Add check for the type of the target property matching the value set?
    [target setValue:targetPropertyValue forKey:[NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding]];
  }
  
  // Drain the autorelease pool
  [pool drain];    
}


// Map to an Array, elements are objects
- (void)map:(NSArray*)source toArray:(NSMutableArray*)target withClass:(Class)clazz error:(NSError**)error {
  DLOG(@"Map parsed JSON to array with class: %@", clazz);
  
  // Check the array
  if (target == nil) {
    *error = [self parsingErrorWithDescription:@"Target array is nil"];
    return;
  }
  
  // Create one object for each element in the array
  for (id element in source) {    
    // Check that there are no mapping errors, otherwise stop
    if (*error)
      return;
    
    // Create object from the class object
    id object = [[[clazz alloc] init] autorelease];
    if(object == nil) {
      *error = [self parsingErrorWithDescription:@"Could not create object in array from class: %@", clazz];
      return;
    }
    
    // Add the object to the target array
    [target addObject:object];
    
    // Map newly created object
    [self map:element toObject:object error:error];    
  }
}


// Map to an Array, elements are basic type
- (void)map:(NSArray*)source toArray:(NSArray**)target withBasicType:(Class)basicType error:(NSError**)error {    
  DLOG(@"Map to array with basic type %@", basicType);
  // Improve performance here and just assign the array instead of each element
  *target = source;
}


// Map a basic type to an object
- (id)mapToBasicType:(id)source error:(NSError**)error {
  switch ([self jsonType:source]) {
    case String:
      DLOG(@"Basic type is a string");
      break;
    case Number:
      DLOG(@"Basic type is a Number of type %s", [source objCType]);
      break;  
    default:
      *error = [self parsingErrorWithDescription:@"JSON basic type is of unkonwn type %@", source];
      return nil;
  }
  return source;
}


// Return a class for a property
- (Class)classForProperty:(objc_property_t)property {  
  if(property != NULL) {
    // Get the class from the type encoded string
    return [self classFromTypeEncoding:[NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding]];
  } else
    return Nil;  
}


// Return a class to be used as objects in an array based on the key name
- (Class)classForArrayWithKey:(NSString*)key target:(id)target {
  NSString *selectorName = [MAP_CLASS_TO_ARRAY_PREFIX stringByAppendingString:key];
  if ([target respondsToSelector:NSSelectorFromString(selectorName)]) {
    DLOG(@"Found matching annotation for key %@", key);
    Class clazz = [target performSelector:NSSelectorFromString(selectorName)];
    if (clazz)
      return clazz;
    else
      return Nil;  
  } else {
    // If no annotation is found assume the class name is the same as the property name (with first character as capital)
    DLOG(@"No annotation found. Use the key name: %@ to constuct the class", key);
    return NSClassFromString([[[key substringWithRange:NSMakeRange(0, 1)] capitalizedString] stringByAppendingString:[key substringFromIndex:1]]);
  }
}


// Get a class from the type encoding of a variable
- (Class)classFromTypeEncoding:(NSString*)typeEncoding {
  DLOG(@"Type encoding %@", typeEncoding);
  // Build the class name
  // Find the first "
  NSRange range = [typeEncoding rangeOfString:@"\""];
  if (range.location != NSNotFound) {
    NSMutableString *clazzName = [NSMutableString stringWithString:[typeEncoding substringFromIndex:range.location + 1]];
    // Find the ending "
    range = [clazzName rangeOfString:@"\""];        
    if (range.location != NSNotFound) {
      [clazzName deleteCharactersInRange:NSMakeRange(range.location, [clazzName length] - range.location)];
      DLOG(@"Class name: %@", clazzName);
      return NSClassFromString(clazzName);
    }
  } 
  return nil;
}


// Check the class type of the parsed JSON
- (JSONType)jsonType:(id)source {  
  if([source isKindOfClass:[NSDictionary class]]) 
    return Object;
  else if ([source isKindOfClass:[NSArray class]])
    return Array;
  else if ([source isKindOfClass:[NSString class]])
    return String;
  else if ([source isKindOfClass:[NSNumber class]])
    return Number;
  else if ([source isKindOfClass:[NSNull class]])
    return Null;
  else 
    return Unkown;
}


// Get a timestamp in milliseconds
- (double)timestamp {  
  struct timeval time; 
  gettimeofday(&time, NULL); 
  return (time.tv_sec * 1000) + (time.tv_usec / 1000); 
}


// Format an error message
- (NSError*)parsingErrorWithDescription:(NSString*)format, ... {   
  // Create a formatted string from input parameters
  va_list varArgsList;
  va_start(varArgsList, format);
  NSString *formatString = [[[NSString alloc] initWithFormat:format arguments:varArgsList] autorelease];
  va_end(varArgsList);
  
  ALOG(@"Parsing error with message: %@", formatString);
  
  // Create the error and store the state
  NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
                             NSLocalizedDescriptionKey, formatString,
                             nil];
  return [[NSError errorWithDomain:@"com.wadpam.ObjectMapper.ErrorDomain" code:1 userInfo:errorInfo] retain];
}


// Debugg method for getting all properties for a class
+ (NSArray*)propertyNamesForClass:(Class)aClass {
	objc_property_t *props;
	unsigned int propsCount;
	if ((props = class_copyPropertyList(aClass, &propsCount))) {
		NSMutableArray *results = [NSMutableArray arrayWithCapacity:propsCount];
		while (propsCount--) 
			[results addObject:[NSString stringWithCString: property_getName(props[propsCount])	encoding: NSASCIIStringEncoding]];
		free(props);	
		return results;
  }
	return nil;			
}


// Debugg method for getting all methods for a class
+ (NSArray*)methodNamesForClass:(Class)aClass {
  Method *methods;
  unsigned int methodCount;
  if ((methods = class_copyMethodList(aClass, &methodCount))) {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:methodCount];
    while (methodCount--) 
			[results addObject:[NSString stringWithCString: sel_getName(method_getName(methods[methodCount])) encoding: NSASCIIStringEncoding]];
    free(methods);	
    return results;
  }
  return nil;
}


@end

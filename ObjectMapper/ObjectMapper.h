//
//  ObjectMapper.h
//  ObjectMapper
//
//  Created by Mattias Levin on 2011-10-02.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Use this macro to map a key to a property when the default naming conventions can not be used.
 */
#define MapKeyToProperty(key, property) XMapKeyToProperty(key, property)  // Force marco-expansion
#define XMapKeyToProperty(key, property) -(NSString*)object_mapper_property_for_##key {return @#property;}


/**
 Use this macro to map properties of NSArray type to the class to store in the arrray.
 */
#define MapClassToArray(clazz, property) XMapClassToArray(clazz, property)   // Force marco-expansion
#define XMapClassToArray(clazz, property) -(Class)object_mapper_class_for_##property {return [clazz class];}


/**
 Use this macro to map keys to custom converter blocks. Converter blocks will allow converting the value 
 before assigning it to the property.
 
 The block must confirm to the following definition id(^)(id), accepting the key value and returning a new
 value that will be assigned to the property.
 */
#define MapKeyToBlock(key, block) -(id(^)(id))object_mapper_block_for_##key {return block}


/**
 ObjectMapper is an Objective-C framework that map parsed JSON objects (e.g. from JSONKit) into domain 
 objects automatically.
 
 ###Why
 Most JSON parsers in Objective-C will parse your JSON and delivery either NSDictionary or NSArray as 
 the result. Turning these objects into domain objects often requires writing repetative boilerplate 
 code, manually setting your properties from the NSDictionary and NSArray. Not any longer, ObjectMapper 
 will solve this as long as you follow a few conventions when defining your domain objects.
 
 ###How does it work
 
 Turning JSON into domain objects typically involves the following steps:
 
 1. Request your JSON with a http request  
 2. Parse the response JSON using a JSON parser/decoder, e.g. JSONKit  
 3. Manually map the parsed JSON into the domain objects properties
 4. Use your newly populated domain objects to store in core data or use as your model objects
 
 The framework address step 3 above, mapping the parsed JSON into domain objects automatically, drastically 
 reducing the need to write boilerplate code.
 
 The framework will iterate over the parsed JSON objects (normally NSDictonary and NSArray) and figure 
 out what domain objects to create and what properties to set using the runtime system and reflection.
  
 ###Mapping conventions
 
 The following conventions are used for mapping key/values into domain objects:

 1. Each key/value-pair in the NSDictionary will be mapped to a property with the same name in the domain object  
 2. If the key is a reserved word in Objective-C, add “_” in front of the property name in the domain   
 object to get around any compiler errors  
 3. Use the macro `MapKeyToProperty to map a key to an arbitrary property name
 4. If a matching property can not be found in the domain object at this point, it will be ignored  
 
 If the property is a class, a new instance of that class will be created and assigned to the property and the
 mapping process will continue.
 
 If the property is an array, a new instance of NSArray will be created and assigned to the property. Since it 
 is not possible to find out the type of the object to put in the array just by inspecting the property, the 
 developer need to help the mapper by annotating the property with the `MapKeyToProperty` marco. The mapper
 will use this macro to figure out what class should go into the array. A new instance of this class is 
 created for each item in the list and added to the array and the mapping proccess will continue.
  
 The process steps described above will continue recursevly until the complete object graph has been 
 created.
 
 ###Annotations
 
 The framework use macros to help the mapper when the normal conversions are not enough.
  
 - `MapKeyToProperty(key, property)` - Map a key/value to an arbitrary property
 - `MapClassToArray(clazz, property)`- Tell the mapper what class to put in a NSArray property
 
 Use these macros in the @implementation section of your domain objects just above the properties @synthesize statement.
 
    @implementation Person
 
    MapKeyToProperty(name, personName)
    @synthesize personName;
 
    MapClassToArray(NSString, phoneNumbers)
    @synthesize phoneNumbers;
 
    @end
 
 The example above will map the key `name` to the domain object property `personName`. It also tells the mapper that 
 the NSArray property `phoneNumbers` should contain NSString objects.
 
 ###Custom converters

 The framwork support executing custom converter blocks before assigning a value to a property. This is useful for 
 converting the value type into a different property type or performing calculations on the value before assigning 
 it to the property. 
 
 The converter block must confirm to the definition `id(^)(id)`, accepting a key value and returning a new value 
 that will be assigned to the property. 
 
 Use the macro below to annotate your property with a converter block.
  
 - `MapKeyToBlock(key, block)`
 
 Use this macro in the @implementation section of your domain objects just above the properties @synthesize statement.
 
    @implementation Dates
 
    MapKeyToBlock(dateFromUnixTimestamp, ^(NSNumber* timestamp) {
      return [NSDate dateWithTimeIntervalSince1970:timestamp];
    };)
    @synthesize dateFromUnixTimestamp;

    @end  
 
 The example above will convert a unix timestamp into an NSDate before assigning it to the property.
 */
@interface ObjectMapper : NSObject 


/**
 Create and return a new mapper object.
 @return A new ObjectMapper
 */
+ (id)mapper;


/**
 Map a NSDictionary or NSArray returned from a JSON parser into a domain object. 
 
 Properties in the target domain object will be populated from the attriubtes in the parsed JSON.
 @param source The parsed JSON that will be used as input to populate the target domain object. Either a NSDictionary or NSArray.
 @param clazz The target domain object
 @param error An optional error object
 @return A populated domain error or nil of the mapping fails
 */
- (id)mapObject:(id)source toClass:(id)clazz withError:(NSError**)error;


@end


/**
 A NSDictonary category for mapping parsed JSON dictionary into domain objects.
 */
@interface NSDictionary (ObjectMapper) 

/**
 Map a NSDictionary into a domain object
 @param clazz The target domain object
 @param error An optional error object
 @return A populated domain error or nil of the mapping fails
 */
- (id)mapToClass:(id)clazz withError:(NSError**)error;

@end


/**
 A NSArray category for mapping parsed JSON array into domain objects.
 */
@interface NSArray (ObjectMapper) 

/**
 Map a NSArray into a domain object
 @param clazz The target domain object
 @param error An optional error object
 @return A populated domain error or nil of the mapping fails
 */
- (id)mapToClass:(id)clazz withError:(NSError**)error;

@end


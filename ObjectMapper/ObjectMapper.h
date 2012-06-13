//
//  ObjectMapper.h
//  ObjectMapper
//
//  Created by Mattias Levin on 2011-10-02.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Use this macro to annotate a key name to a domain object properties name when the default
 naming conventions can not be followed.
 */
#define ANNOTATE_PROPERTY_FOR_KEY(property, key) XANNOTATE_PROPERTY_FOR_KEY(property, key)  // Force marco-expansion
#define XANNOTATE_PROPERTY_FOR_KEY(property, key) -(NSString*)orm_property_for_key_##key {return @#property;}


/**
 Use this macro to annotate properties of NSArray type with the type of object to store in the arrray.
 */
#define ANNOTATE_CLASS_FOR_ARRAY(clazz, property) XANNOTATE_CLASS_FOR_ARRAY(clazz, property)   // Force marco-expansion
#define XANNOTATE_CLASS_FOR_ARRAY(clazz, property) -(Class)orm_class_for_array_##property {return [clazz class];}


/**
 JsonORM is an Objective-C framework that map parsed JSON objects (e.g. from JSONKit) into domain 
 objects automatically.
 
 ###How it works
 
 Turning JSON into domain objects typically involves the following steps:
 
 1. Request your JSON with a http request  
 2. Parse the response JSON using a JSON parser/decoder, e.g. JSONKit  
 3. Manually map the parsed JSON into domain objects  
 4. Use your newly populated domain objects to store in core data or as your model objects
 
 The framework address step 3 above mapping the parsed JSON into domain objects automatically, drastically 
 reducing the need to write boilerplate code.
 
 The framework will iterate over the parsed JSON objects (normally NSDictonary and NSArray) and figure 
 out what domain objects to create and what properties to set using the runtime system and reflection.
  
 ###Mapping conventions
 
 The following conventions are used for mapping key/values into domain objects:

 1. Each key/value-pair in the NSDictionary will be mapped to a property with the same name in the domain object  
 2. If the key is a reserved word in Objective-C, add “_” in front of the property name in the domain   
 object to get around any compiler errors  
 3. Use the macro ANNOTATE_PROPERTY_FOR_KEY to map a key to an arbitrary property name
 4. If a matching property can not be found in the domain object at this point, it will be ignored  
 
 If the property is a class, a new instance of that class will be created and assigned to the property and the
 mapping process will continue.
 
 If the property is an array, a new instance of NSArray will be created and assigned to the property. Since it 
 is not possible to find out the type of the object to put in the array just by inspecting the property, the 
 developer need to help the mapper by annotating the property with the ANNOTATE_CLASS_FOR_ARRAY marco. The mapper
 will use this macro to figure out the class that should go into the array. A new instance of this class is 
 created for each item in the list and added to the array and the mapping proccess will continue.
  
 The process steps described above will continue recursevly until the complete object graph has been 
 created.
 
 ###Annotations
 
 The framework use macros to help the mapper when the normal conversions are not enough.
  
 - `ANNOTATE_PROPERTY_FOR_KEY(property, key)` - Use this annotation to map a key/value to an arbitrary property name
 - `ANNOTATE_CLASS_FOR_ARRAY(clazz, property)`- Tell the mapper what class to put in a NSArray property
 
 Use these macros in the @implementation section of your domain objects just above the properties @synthesize statement.
 
    @implementation Person
 
    ANNOTATE_PROPERTY_FOR_KEY(personName, name)
    @synthesize personName;
 
    ANNOTATE_CLASS_FOR_ARRAY(NSString, phoneNumbers)
    @synthesize phoneNumbers;
 
    @end
 
 The example above will map the key `street` to the domain object property `myStreet`. It also tells the mapper that the 
 NSArray property `phoneNumbers` should contain NSString.


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


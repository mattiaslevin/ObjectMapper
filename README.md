#JsonORM

JsonORM is an Objective-C framework that maps parsed JSON (e.g. from JSONKit) into domain objects automatically.

###Why

Most JSON parsers in Objective-C will parse your JSON and delivery either NSDictionary or NSArray as the end result. Turning these objects into domain objects often requires writing repetative boilerplate code, manually setting your properties from the NSDictionary. Not any longer, JsonORM will solve this as long as you follow a few conventions when defining your domain objects.

##How it works

Turning JSON into domain objects typically involves the following steps:
 
1. Request your JSON with a http request  
2. Parse the response JSON using a JSON parser/decoder, e.g. JSONKit  
3. Manually map the parsed JSON into domain objects  
4. Use your newly populated domain objects to store in core data or as your model objects

The framework address step 3 above mapping the parsed JSON into domain objects automatically, drastically reducing the need to write boilerplate code.

[!!] So far the framework has been tested using the JSONKit parser.
 
The framework will iterate over the parsed JSON objects (normally NSDictonary and NSArray) and figure out what domain objects to create and what properties to set using the runtime system and reflection.


###Mapping conventions

The following conventions are used for mapping key/values into domain objects:

1. Each key/value-pair in the NSDictionary will be mapped to a property with the same name in the domain object  
2. If the key is a reserved word in Objective-C, add “_” in front of the property name in the domain object to get around any compiler errors  
3. Use the macro ANNOTATE_PROPERTY_FOR_KEY to map a key to an arbitrary property name
4. If a matching property can not be found in the domain object at this point, it will be ignored  
 
If the property is a class, a new instance of that class will be created and assigned to the property and the mapping process will continue.
 
If the property is an array, a new instance of NSArray will be created and assigned to the property. Since it is not possible to find out the type of the object to put in the array just by inspecting the property, the developer need to help the mapper by annotating the property with the ANNOTATE_CLASS_FOR_ARRAY marco. The mapper will use this macro to figure out the class that should go into the array. A new instance of this class is created for each item in the list and added to the array and the mapping proccess will continue.
  
The process steps described above will continue recursevly until the complete object graph has been created.
 
###Annotations
 
The framework use macros to help the mapper when the normal conversions are not enough.

<table border="1">
<tr>
<th>Macro</th>
<th>Description</th>
</tr>
<tr>
<td>ANNOTATE_PROPERTY_FOR_KEY(property, key)</td>
<td>Use this annotation to map a key/value to an arbitrary property name</td>
</tr>
<tr>
<td>ANNOTATE_CLASS_FOR_ARRAY(clazz, property)</td>
<td>Tell the mapper what class to put in a NSArray property</td>
</tr>
</table>

Use these macros in the @implementation section of your domain objects just above the properties @synthesize statement.
 
    @implementation Person
 
    ANNOTATE_PROPERTY_FOR_KEY(personName, name)
    @synthesize personName;
 
    ANNOTATE_CLASS_FOR_ARRAY(NSString, phoneNumbers)
    @synthesize phoneNumbers;
 
    @end
 
The example above will map the key `name` to the domain object property `personName`. It also tells the mapper that the 
NSArray property `phoneNumbers` should contain NSString.


##Code examples

The code examples below demonstrate how to map incoming JSON to a Peron domain object.

Person.h:

    @interface Person : NSObject

    @property (retain) NSString *personName;
    @property (retain) NSNumber *age;
    @property BOOL male;
    @property (retina) Address *address;    

    @end
    
Person.m:
    
	@implementation Person
	
	ANNOTATE_PROPERTY_FOR_KEY(personName, name)
	@synthesize personName;
	@synthesize age;
	@synthesize male;
	@synthesize address;

	@end

Address.h:

    @interface Address : NSObject

    @property (retain) NSString *street;
    @property (retain) NSString *city;

    @end
    
Address.m

	@implementation Address
	
	@synthesize street;
	@synthesize city;

	@end

Incoming JSON:

    {
    "name":"mattias",
    "age":35,
    "male":true,
    "address": 
        {
        "street":"Drottningtorget"
        "city":"Malmö"
        }
    }

Parse JSON and map to domain objects:

    //Get your JSON data
    NSData *jsonData = ...

    //Parse it using JSONKit
    id parsedJSON = [jsonData objectFromJSONData];

    //Automatically map to domain objects
    JSONMapper *mapper = [JSONMapper mapper];
    NSError *error;
    Person *person = [mapper mapParsedJSON:parsedJSON toRootClass:[Person class] error:&error];

Finally an example how to map to a NSArray using annotation:

MyContacts.h:

    @interface MyContacts : NSObject 
    
    @property (retain) NSArray *contacts;

    @end
    
MyContacts.m:
	
	@implementation MyContacts
	
	ANNOTATE_CLASS_FOR_ARRAY(Persons, contacts)
	@synthesize contacts;

	@end

Incoming JSON:

    {
    "contacts":[
             	  {"name":"mattias", "age":35, ... },
             	  {"name":"kalle", "age":27, ...}
               ]
    }

If no macro had been provided the mapper would have tried to create a domain object of type Contacts (the same name as the property name with first character capitalized).

##Interface

The interface for performing the mapping is very simple:

    // Get a mapper instance
    + (id)mapper;
    // Map parsed JSON to domain objects with root class
	- (id)mapObject:(id)source toClass:(id)clazz withError:(NSError **)error;
	
There is also a convenience NSDictionary and NSArray category:
	
    // Map parsed JSON to domain objects with root class
	- (id)mapToClass:(id)clazz withError:(NSError**)error;

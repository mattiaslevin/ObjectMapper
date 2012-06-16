//
//  ObjectMapperTest.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectMapperTest.h"
#import "ObjectMapper.h"
#import "JSONKit.h"
#import "ObjectWithBasicTypes.h"
#import "AnnotatedObjectWithBasicTypes.h"
#import "ObjectWithObjectTypes.h"
#import "ObjectWithArrayTypes.h"
#import "ObjectWithSomeNilValues.h"
#import "ObjectWithMissingObject.h"
#import "RuntimeReporter.h"
#import "ObjectWithBuiltInTypes.h"


@implementation ObjectMapperTest

@synthesize testDataPath;


- (void)setUp
{
  [super setUp];
  
  //set the path to all test data fils containg JSON
  NSFileManager *fm = [NSFileManager defaultManager];
  //NSLog(@"Current path %@", [fm currentDirectoryPath]);    
  self.testDataPath = [[fm currentDirectoryPath] stringByAppendingPathComponent:@"ObjectMapperTests"];
  
}


- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}


- (void)testObjectWithBasicTypes {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypes.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values  
  STAssertTrue([domainObject.string isEqualToString:@"stringValue"], @"The string property have the wrong value");
  STAssertTrue([domainObject.integer integerValue] == 12345, @"The integer property have the wrong value");
  STAssertTrue([domainObject._decimal floatValue] == 12.345f, @"The _decimal property have the wrong value");
  STAssertTrue(domainObject.boolean == YES, @"The boolean property have the wrong value");
}


- (void)testAnnotatedObjectWithBasicTypes {
  // Get test data
  NSDictionary *parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypes.json"];
  
  // Map JSON
  NSError *error = nil;
  AnnotatedObjectWithBasicTypes *domainObject = [parsedJSON mapToClass:[AnnotatedObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values
  STAssertTrue([domainObject.stringWithADifferentName isEqualToString:@"stringValue"], 
               @"The stringWithADifferentName does not contain the correct value");
  STAssertTrue([domainObject.integerWithADifferentName integerValue] == 12345, 
               @"The integerWithADifferentName does not contain the correct value");
  STAssertTrue([domainObject._decimal floatValue] == 12.345f, @"The _decimal property have the wrong value");
  STAssertTrue(domainObject.boolean == YES, @"The boolean property have the wrong value");
}



- (void)testObjectWithBasicTypesMissingProperties {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypesMissingProperties.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values
  STAssertTrue([domainObject.string isEqualToString:@"stringValue"], @"The string property have the wrong value");
  STAssertTrue([domainObject.integer integerValue] == 12345, @"The integer property have the wrong value");
  STAssertTrue([domainObject._decimal floatValue] == 12.345f, @"The _decimal property have the wrong value");
  STAssertTrue(domainObject.boolean == YES, @"The boolean property have the wrong value");
}


- (void)testObjectWithBasicTypesMissingJSONAttribute {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypesMissingJSONAttribute.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values
  STAssertTrue(domainObject.string == nil, @"The string property should be nil");
  STAssertTrue([domainObject.integer integerValue] == 12345, @"The integer property have the wrong value");
  STAssertTrue([domainObject._decimal floatValue] == 12.345f, @"The _decimal property have the wrong value");
  STAssertTrue(domainObject.boolean == YES, @"The boolean property have the wrong value");
}


- (void)testObjectWithObjectTypes {  
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithObjectTypes.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithObjectTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithObjectTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values
  STAssertTrue([domainObject.object1 isKindOfClass:[ObjectWithBasicTypes class]], @"Object1 is of the wrong type");
  STAssertNotNil(domainObject.object1, @"Object1 should not be nil");
  STAssertTrue([domainObject.object1.string isEqualToString:@"stringValue"], @"The string property in object1 have the wrong value");
  
  STAssertTrue([domainObject.object2 isKindOfClass:[ObjectWithBasicTypes class]], @"Object2 is of the wrong type");
  STAssertNotNil(domainObject.object2, @"Object2 should not be nil");
  STAssertTrue([domainObject.object2.string isEqualToString:@"stringValue2"], 
               @"The string property in object2 have the wrong value");
  STAssertTrue(domainObject.object2.boolean == NO, @"The boolean property object2 have the wrong value");
}


- (void)testObjectWithArrayTypes {  
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithArrayTypes.json"];
  
  //Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithArrayTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithArrayTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  //Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values
  STAssertTrue([domainObject.arrayOfStrings count] == 3, @"The arrayOfStrings did not contain 3 strings");
  STAssertTrue([[domainObject.arrayOfStrings objectAtIndex:0] isEqualToString:@"stringValue1"], 
               @"The first element in the arrayOfStrings have the wrong value");
  STAssertTrue([[domainObject.arrayOfStrings objectAtIndex:1] isEqualToString:@"stringValue2"], 
               @"The second element in the arrayOfStrings have the wrong value");
  STAssertTrue([[domainObject.arrayOfStrings objectAtIndex:2] isEqualToString:@"stringValue3"], 
               @"The third element in the arrayOfStrings have the wrong value");
  STAssertTrue([domainObject.arrayOfIntegers count] == 3, @"The arrayOfIntegers did not contain 3 integers");
  STAssertTrue([[domainObject.arrayOfIntegers objectAtIndex:2] integerValue]== 3, 
               @"The third element in the arrayOfIntegers have the wrong value");
  STAssertTrue([domainObject.arrayOfDecimals count] == 3, @"The arrayOfDecimals did not contain 3 decimals");
  STAssertTrue([[domainObject.arrayOfDecimals objectAtIndex:2] floatValue] == 3.3f, 
               @"The third element in the arrayOfDecimals have the wrong value");
  STAssertTrue([domainObject.arrayOfBools count] == 3, @"The arrayOfBools did not contain 3 booleans");
  STAssertTrue([[domainObject.arrayOfBools objectAtIndex:2] boolValue] == YES, 
               @"The third element in the arrayOfBools have the wrong value");
  STAssertTrue([domainObject.arrayOfObjects count] == 2, @"The arrayOfObjects did not contain 2 objects");
  STAssertTrue([[domainObject.arrayOfObjects objectAtIndex:0] isKindOfClass:[ObjectWithBasicTypes class]], 
               @"The first element in the arrayOfObjects contains the wrong type");
  STAssertTrue([((ObjectWithBasicTypes*)[domainObject.arrayOfObjects objectAtIndex:1]).string isEqualToString:@"stringValue1"], 
               @"The string parameter in the second element in the arrayOfObjects contains the wrong value");
}


- (void)testObjectWithSomeNullValues {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithSomeNullValues.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithSomeNilValues *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithSomeNilValues class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  // Check individual property values  
  STAssertTrue([domainObject.string isEqualToString:@"stringValue"], @"The string property have the wrong value");
  STAssertTrue([domainObject.integer integerValue] == 12345, @"The integer property have the wrong value");
  STAssertTrue([domainObject._decimal floatValue] == 12.345f, @"The _decimal property have the wrong value");
  STAssertTrue(domainObject.boolean == YES, @"The boolean property have the wrong value");
  
  STAssertNil(domainObject.stringNil, @"The stringNil property have the wrong value");
  STAssertNil(domainObject.integerNil, @"The integerNil property have the wrong value");
  STAssertNil(domainObject.decimalNil, @"The _decimalNil property have the wrong value");
  
  STAssertTrue([domainObject.arrayOfStrings count] == 3, @"The arrayOfStrings should contain 3 items");
  STAssertNil(domainObject.arrayOfStringsNil, @"The arrayOfStringsNil property have the wrong value");
  
  STAssertTrue([domainObject.object isKindOfClass:[ObjectWithBasicTypes class]], 
               @"The object property copntains the wrong type");
  STAssertNil(domainObject.objectNil, @"The objectNil property have the wrong value");
}



- (void)testArrayWithObjectTypes {    
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ArrayWithObjectTypes.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSArray *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"Error object is not nil");  
  STAssertTrue([domainObject isKindOfClass:[NSArray class]], @"The returned domain object is the wrong type");
  // Check individual property values  
  STAssertTrue([domainObject count] == 2, @"The returned array does not contain 2 elements");
  ObjectWithBasicTypes *basicObject = [domainObject objectAtIndex:0];
  STAssertTrue([basicObject.string isEqualToString:@"stringValue"], 
               @"The first object in the array have wrong string value");
  STAssertTrue([basicObject.integer integerValue] == 12345, @"The first object in the array have wrong integer value");
  
  basicObject = [domainObject objectAtIndex:1];
  STAssertTrue([basicObject.string isEqualToString:@"stringValue2"], 
               @"The second object in the array have wrong string value");
  STAssertTrue([basicObject.integer integerValue] == 123456, @"The second object in the array have wrong integer value");
}


- (void)testArrayWithStringTypes {
  // Get test data
  NSString *json = @"[\"string1\", \"string2\", \"string3\", \"string4\"]";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSArray *domainObject = [mapper mapObject:parsedJSON toClass:[NSString class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  STAssertTrue(([domainObject count] == 4), @"The domain object should contain 4 strings");
  STAssertTrue([[domainObject objectAtIndex:0] isKindOfClass:[NSString class]], 
               @"The first element of the array if of wrong type");
  STAssertTrue([[domainObject objectAtIndex:1] isEqualToString:@"string2"], 
               @"The second element on the array contains wrong value");
}


- (void)testArrayWithIntegerTypes {
  // Get test data
  NSString *json = @"[111, 222, 333, 444]";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSArray *domainObject = [mapper mapObject:parsedJSON toClass:[NSNumber class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  STAssertTrue(([domainObject count] == 4), @"The domain object should contain 4 integers");
  STAssertTrue([[domainObject objectAtIndex:0] isKindOfClass:[NSNumber class]], 
               @"The first element of the array if of wrong type");
  STAssertTrue([[domainObject objectAtIndex:1] integerValue] == 222, 
               @"The second element on the array contains wrong value");
}


- (void)testBuiltInTypes {
  // Get test data
  NSString *json = @"{\"anInteger\":11, \"aDouble\":12.23, \"aBoolean\":false}";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBuiltInTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBuiltInTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
  STAssertTrue(domainObject.anInteger == 11, @"The integer contains wrong value");
  STAssertTrue(domainObject.aDouble == 12.23, @"The double contains wrong value");
  STAssertFalse(domainObject.aBoolean, @"The boolean contains wrong value");
}



- (void)testEmptyArray {
  // Get test data
  NSString *json = @"[]";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSArray *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  //Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertTrue(([domainObject count] == 0), @"The domain array should be empty");
  STAssertNil(error, @"NSError object was returned");
}



- (void)testString {  
  // Get test data
  NSString *json = @"\"onlyAStingValue\"";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSString *domainObject = [mapper mapObject:parsedJSON toClass:[NSString class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");  
}


- (void)testInteger {  
  // Get test data
  NSString *json = @"123";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSString *domainObject = [mapper mapObject:parsedJSON toClass:[NSNumber class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");
}


- (void)testObjectIsNil {  
  // Get test data
  NSString *json = @"null";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");  
}


- (void)testArrayIsNil {  
  // Get test data
  NSString *json = @"null";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithArrayTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");
}


- (void)testStringIsNil {
  // Get test data
  NSString *json = @"null";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[NSString class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");
}


-(void) testRootClassIsNil {
  //Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypes.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:nil withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  NSLog(@"Error description: %@", [error description]);

  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned");   
}


-(void) testTargetDomainMissing {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithMissingObject.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithMissingObject *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithMissingObject class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  NSLog(@"Error description: %@", [error description]);

  // Check the result
  STAssertNil(domainObject, @"Domain object is not nil");
  STAssertNotNil(error, @"Error object is nil");  
}  





//- (void) testClassMethods
//{
//    NSString *clazzName = @"ObjectWithArrayTypes";
//    
//    NSArray *methods = [RuntimeReporter methodNamesForClassNamed:clazzName];
//    
//    for (id method in methods) {
//        NSLog(@"Method name: %@", method);
//    }
//    
//    NSArray *poperties = [RuntimeReporter propertyNamesForClassNamed:clazzName];
//    
//    for (id property in poperties) {
//        NSLog(@"Property name: %@", property);
//    }
//    
//}


- (id)parsedJsonFromFileWithName:(NSString*)fileName {
  //Read the JSON test data from file
  NSError *error;
  NSData *jsonData = [NSData dataWithContentsOfFile:[self.testDataPath stringByAppendingPathComponent:fileName]
                                            options:NSDataReadingUncached 
                                              error:&error];
  STAssertFalse([jsonData length] == 0, @"Test data not possible to read");
  
  //Parse JSON
  id parsedJSON = [jsonData objectFromJSONData];
  NSLog(@"Parsed JSON: %@", parsedJSON);
  STAssertFalse(parsedJSON == nil, @"JSON parsing failed");
  
  return parsedJSON;
}


@end

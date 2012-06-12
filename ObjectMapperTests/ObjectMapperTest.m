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
#import "ObjectWithSomeNullValues.h"
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
}


- (void)testAnnotatedObjectWithBasicTypes {
  // Get test data
  NSDictionary *parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithBasicTypes.json"];
  
  // Map JSON
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [parsedJSON mapToClass:[AnnotatedObjectWithBasicTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
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
}


- (void)testObjectWithObjectTypes {  
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithObjectTypes.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithObjectTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
}


- (void)testObjectWithArrayTypes {  
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithArrayTypes.json"];
  
  NSArray *methods = [RuntimeReporter methodNamesForClass:[ObjectWithArrayTypes class]];
  NSLog(@"Methods %@", methods);
                    
  
  //Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithArrayTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  //Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
}


- (void)testObjectWithSomeNullValues {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithSomeNullValues.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithSomeNullValues class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");  
}


//
- (void)testArrayWithObjectTypes {    
    // Get test data
    id parsedJSON = [self parsedJsonFromFileWithName:@"ArrayWithObjectTypes.json"];
    
    // Map JSON
    ObjectMapper *mapper = [ObjectMapper mapper];
    NSError *error = nil;
    ObjectWithBasicTypes *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBasicTypes class] withError:&error];
    
    NSLog(@"Mapped object: %@", domainObject);
    
    // Check the result
    STAssertNotNil(domainObject, @"Domain object is nil");
    STAssertNil(error, @"Error object is not nil");    
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
  STAssertTrue(([domainObject count] == 4), @"The domain object should contain 4 strings");
  STAssertNil(error, @"NSError object was returned");
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
  STAssertTrue(([domainObject count] == 4), @"The domain object should contain 4 integers");
  STAssertNil(error, @"NSError object was returned");
}


- (void)testBuiltInTypes {
  // Get test data
  NSString *json = @"{\"anInteger\":11, \"aDouble\":12.23, \"aBoolean\":false}";
  id parsedJSON = [json objectFromJSONString];
  NSLog(@"Parsed JONS: %@", parsedJSON);
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  NSArray *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithBuiltInTypes class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNotNil(domainObject, @"Domain object is nil");
  STAssertNil(error, @"NSError object was returned");
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
  
  // Check the result
  STAssertNil(domainObject, @"Domain object should be nil");
  STAssertNotNil(error, @"NSError object should be returned"); 
  NSLog(@"Error description: %@", [error description]);

}


-(void) testTargetDomainMissing {
  // Get test data
  id parsedJSON = [self parsedJsonFromFileWithName:@"ObjectWithMissingObject.json"];
  
  // Map JSON
  ObjectMapper *mapper = [ObjectMapper mapper];
  NSError *error = nil;
  ObjectWithMissingObject *domainObject = [mapper mapObject:parsedJSON toClass:[ObjectWithMissingObject class] withError:&error];
  
  NSLog(@"Mapped object: %@", domainObject);
  
  // Check the result
  STAssertNil(domainObject, @"Domain object is not nil");
  STAssertNotNil(error, @"Error object is nil");    
  // NSLog(@"Error description: %@", [error description]); TODO
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

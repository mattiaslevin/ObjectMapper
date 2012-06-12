//
//  ObjectMapperTest.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ObjectMapperTest : SenTestCase {
    NSString *testDataPath;
}

- (id)parsedJsonFromFileWithName:(NSString*)fileName;

@property (retain)  NSString *testDataPath;

@end

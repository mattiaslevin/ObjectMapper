//
//  ObjectWithArrayTypes.h
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectWithBasicTypes.h"
#import "ObjectMapper.h"

@interface ObjectWithArrayTypes : NSObject {
    
    
    NSArray *arrayOfStrings;
    NSArray *arrayOfIntegers;
    NSArray *arrayOfDecimals;
    NSArray *arrayOfBool;    
    NSArray *arrayOfObjects;
    
}

@property (retain) NSArray *arrayOfStrings;
@property (retain) NSArray *arrayOfIntegers;
@property (retain) NSArray *arrayOfDecimals;
@property (retain) NSArray *arrayOfBools;
@property (retain) NSArray *arrayOfObjects; 

@end




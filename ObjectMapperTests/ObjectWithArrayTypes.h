//
//  ObjectWithArrayTypes.h
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectWithBasicTypes.h"
#import "ObjectMapper.h"

@interface ObjectWithArrayTypes : NSObject

@property (nonatomic, retain) NSArray *arrayOfStrings;
@property (nonatomic, retain) NSArray *arrayOfIntegers;
@property (nonatomic, retain) NSArray *arrayOfDecimals;
@property (nonatomic, retain) NSArray *arrayOfBools;
@property (nonatomic, retain) NSArray *arrayOfObjects; 

@end




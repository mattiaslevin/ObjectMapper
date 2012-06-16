//
//  ObjectWithMissingObject.h
//
//  Created by Mattias Levin on 2011-10-10.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectMapper.h"
#import "ObjectWithBasicTypes.h"

@interface ObjectWithMissingObject : NSObject 

@property (nonatomic, retain) NSArray *arrayOfStrings;
@property (nonatomic, retain) NSArray *arrayOfIntegers;
@property (nonatomic, retain) NSArray *arrayOfDecimals;
@property (nonatomic, retain) NSArray *arrayOfBools;

@property (nonatomic, retain) NSArray *arrayOfObjects; 
@property (nonatomic, retain) NSArray *arrayOfMissingObjects;

@end




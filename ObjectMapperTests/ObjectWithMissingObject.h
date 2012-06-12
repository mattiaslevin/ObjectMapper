//
//  ObjectWithMissingObject.h
//
//  Created by Mattias Levin on 2011-10-10.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectMapper.h"
#import "ObjectWithBasicTypes.h"

@interface ObjectWithMissingObject : NSObject {

NSArray *arrayOfStrings;
NSArray *arrayOfIntegers;
NSArray *arrayOfDecimals;
NSArray *arrayOfBools;    
NSArray *arrayOfObjects;
NSArray *arrayOfMissingObjects;

}

@property (retain) NSArray *arrayOfStrings;
@property (retain) NSArray *arrayOfIntegers;
@property (retain) NSArray *arrayOfDecimals;
@property (retain) NSArray *arrayOfBools;

@property (retain) NSArray *arrayOfObjects; 
@property (retain) NSArray *arrayOfMissingObjects;

@end




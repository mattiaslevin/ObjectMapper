//
//  ObjectWithSomeNullValues.h
//
//  Created by Mattias Levin on 2011-10-09.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectWithBasicTypes;

@interface ObjectWithSomeNullValues : NSObject {
    
    //Basic types
    NSString *string;
    NSNumber *integer;
    NSNumber *_decimal;
    BOOL boolean;    
    NSString *stringNul;
    NSNumber *integerNull;
    NSNumber *decimalNull;
    
    //Arrays
    NSArray *arrayOfStrings;    
    NSArray *arrayNullOfStrings;
    
    //Objects
    ObjectWithBasicTypes *object;
    ObjectWithBasicTypes *objectNull;
    
}


@property (retain) NSString *string;
@property (retain) NSNumber *integer;
@property (retain) NSNumber *_decimal;
@property BOOL boolean;
@property (retain) NSString *stringNull;
@property (retain) NSNumber *integerNull;
@property (retain) NSNumber *decimalNull;

@property (retain) NSArray *arrayOfStrings;    
@property (retain) NSArray *arrayNullOfStrings;

@property (retain) ObjectWithBasicTypes *object;
@property (retain) ObjectWithBasicTypes *objectNull;


@end


    

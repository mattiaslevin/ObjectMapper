//
//  ObjectWithSomeNullValues.h
//
//  Created by Mattias Levin on 2011-10-09.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectWithBasicTypes;

@interface ObjectWithSomeNilValues : NSObject

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSNumber *integer;
@property (nonatomic, retain) NSNumber *_decimal;
@property (nonatomic) BOOL boolean;
@property (nonatomic, retain) NSString *stringNil;
@property (nonatomic, retain) NSNumber *integerNil;
@property (nonatomic, retain) NSNumber *decimalNil;

@property (nonatomic, retain) NSArray *arrayOfStrings;    
@property (nonatomic, retain) NSArray *arrayOfStringsNil;

@property (nonatomic, retain) ObjectWithBasicTypes *object;
@property (nonatomic, retain) ObjectWithBasicTypes *objectNil;

@end


    

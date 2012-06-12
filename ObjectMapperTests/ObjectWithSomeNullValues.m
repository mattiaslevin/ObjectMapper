//
//  ObjectWithSomeNullValues.m
//
//  Created by Mattias Levin on 2011-10-09.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithSomeNullValues.h"

@implementation ObjectWithSomeNullValues


@synthesize string;
@synthesize integer;
@synthesize _decimal;
@synthesize boolean;
@synthesize stringNull;
@synthesize integerNull;
@synthesize decimalNull;

@synthesize arrayOfStrings;
@synthesize arrayNullOfStrings;

@synthesize object;
@synthesize objectNull;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    
    [string release];
    [integer release];
    [_decimal release];
    [stringNull release];
    [integerNull release];
    [decimalNull release];
    
    [arrayOfStrings release];
    [arrayNullOfStrings release];
    
    [object release];
    [objectNull release];
    
    [super dealloc];
}

@end

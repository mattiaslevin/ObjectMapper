//
//  ObjectWithArrayTypes.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithArrayTypes.h"

@implementation ObjectWithArrayTypes


@synthesize arrayOfStrings;
@synthesize arrayOfIntegers;
@synthesize arrayOfDecimals;
@synthesize arrayOfBools;

ANNOTATE_CLASS_FOR_ARRAY(ObjectWithBasicTypes, arrayOfObjects)
@synthesize arrayOfObjects;


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
    [arrayOfStrings release];
    [arrayOfIntegers release];
    [arrayOfDecimals release];
    [arrayOfBools release];
    [arrayOfObjects release];
    
    [super dealloc];
}

@end


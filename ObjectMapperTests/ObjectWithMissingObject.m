//
//  ObjectWithMissingObject.m
//
//  Created by Mattias Levin on 2011-10-10.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithMissingObject.h"

@implementation ObjectWithMissingObject

@synthesize arrayOfStrings;
@synthesize arrayOfIntegers;
@synthesize arrayOfDecimals;
@synthesize arrayOfBools;
ANNOTATE_CLASS_FOR_ARRAY(ObjectWithBasicTypes, arrayOfObjects)
@synthesize arrayOfObjects;
@synthesize arrayOfMissingObjects;

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
    [arrayOfMissingObjects release];
    
    [super dealloc];
}
@end




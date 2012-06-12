//
//  ObjectWithObjectTypes.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithObjectTypes.h"

@implementation ObjectWithObjectTypes


@synthesize object1;
@synthesize object2;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void) dealloc
{
    
    [object1 release];
    [object2 release];
    
    [super dealloc];
}

@end

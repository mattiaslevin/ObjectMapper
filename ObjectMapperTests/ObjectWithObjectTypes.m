//
//  ObjectWithObjectTypes.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithObjectTypes.h"

@implementation ObjectWithObjectTypes


@synthesize object1 = object1_;
@synthesize object2 = object2_;


- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (void) dealloc {
  self.object1 = nil;
  self.object2 = nil;
  [super dealloc];
}

@end

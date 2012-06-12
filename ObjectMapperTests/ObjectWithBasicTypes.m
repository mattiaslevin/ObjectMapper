//
//  ObjectWithBasicTypes.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithBasicTypes.h"

@implementation ObjectWithBasicTypes

@synthesize string;
@synthesize integer;
@synthesize _decimal;
@synthesize boolean;

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (NSString*)description {
  return [NSString stringWithFormat:@"string=%@, integer=%@, decimal=%@, boolean=%d", 
          self.string, 
          self.integer,
          self._decimal,
          self.boolean];                                                                                                
}


- (void) dealloc {  
  [string release];
  [integer release];
  [_decimal release];
  
  [super dealloc];
}

@end

//
//  AnnotatedObjectWithBasicTypes.m
//
//  Created by Mattias Levin on 6/9/12.
//  Copyright (c) 2012 Wadpam. All rights reserved.
//

#import "AnnotatedObjectWithBasicTypes.h"

#define INTEGER integerWithADifferentName

@implementation AnnotatedObjectWithBasicTypes 


MapKeyToProperty(string, stringWithADifferentName)
@synthesize stringWithADifferentName = stringWithADifferentName_;

MapKeyToProperty(integer, INTEGER)
@synthesize integerWithADifferentName = integerWithADifferentName_;

@synthesize _decimal = _decimal_;
@synthesize boolean = boolean_;


- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (NSString*)description {
  return [NSString stringWithFormat:@"stringWithADifferentName=%@, integerWithADifferentName=%@, decimal=%@, boolean=%d", 
          self.stringWithADifferentName, 
          self.integerWithADifferentName,
          self._decimal,
          self.boolean];                                                                                                
}


- (void) dealloc {  
  self.stringWithADifferentName = nil;
  self.integerWithADifferentName = nil;
  self._decimal = nil;
  [super dealloc];
}

@end

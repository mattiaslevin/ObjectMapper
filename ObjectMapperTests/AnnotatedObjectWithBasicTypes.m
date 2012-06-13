//
//  AnnotatedObjectWithBasicTypes.m
//
//  Created by Mattias Levin on 6/9/12.
//  Copyright (c) 2012 Wadpam. All rights reserved.
//

#import "AnnotatedObjectWithBasicTypes.h"

#define INTEGER integerWithADifferentName

@implementation AnnotatedObjectWithBasicTypes 


ANNOTATE_PROPERTY_FOR_KEY(stringWithADifferentName, string)
@synthesize stringWithADifferentName;
ANNOTATE_PROPERTY_FOR_KEY(INTEGER, integer)
@synthesize integerWithADifferentName;
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
  return [NSString stringWithFormat:@"stringWithADifferentName=%@, integerWithADifferentName=%@, decimal=%@, boolean=%d", 
          self.stringWithADifferentName, 
          self.integerWithADifferentName,
          self._decimal,
          self.boolean];                                                                                                
}


- (void) dealloc {  
  [stringWithADifferentName release];
  [integerWithADifferentName release];
  [_decimal release];
  
  [super dealloc];
}

@end

//
//  ObjectWithBuiltInTypes.m
//
//  Created by Mattias Levin on 2011-10-23.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithBuiltInTypes.h"

@implementation ObjectWithBuiltInTypes

@synthesize anInteger = anInteger_;
@synthesize aDouble = aDouble_;
@synthesize aBoolean = aBoolean_;

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (NSString*)description {
  return [NSString stringWithFormat:@"Int: %d Double: %f Bool: %d", self.anInteger, self.aDouble, self.aBoolean];
}

@end

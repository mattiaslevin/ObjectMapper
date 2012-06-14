//
//  ObjectWithSomeNullValues.m
//
//  Created by Mattias Levin on 2011-10-09.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithSomeNilValues.h"

@implementation ObjectWithSomeNilValues


@synthesize string = string_;
@synthesize integer = integer_;
@synthesize _decimal = _decimal_;
@synthesize boolean = boolean_;
@synthesize stringNil = stringNil_;
@synthesize integerNil = integerNil_;
@synthesize decimalNil = decimalNil_;

@synthesize arrayOfStrings = arrayOfStrings_;
@synthesize arrayOfStringsNil = arrayOfStringsNil_;

@synthesize object = object_;
@synthesize objectNil = objectNil_;


- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (void)dealloc {
  self.string = nil;
  self.integer = nil;
  self._decimal = nil;
  self.stringNil = nil;
  self.integerNil = nil;
  self.decimalNil = nil;
  
  self.arrayOfStrings = nil;
  self.arrayOfStringsNil = nil;
  
  self.object = nil;
  self.objectNil = nil;
  
  [super dealloc];
}

@end

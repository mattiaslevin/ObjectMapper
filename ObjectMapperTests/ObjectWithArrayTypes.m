//
//  ObjectWithArrayTypes.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithArrayTypes.h"

@implementation ObjectWithArrayTypes


@synthesize arrayOfStrings = arrayOfStrings_;
@synthesize arrayOfIntegers = arrayOfIntegers_;
@synthesize arrayOfDecimals = arrayOfDecimals_;
@synthesize arrayOfBools = arrayOfBools_;

MAP_CLASS_TO_ARRAY(ObjectWithBasicTypes, arrayOfObjects)
@synthesize arrayOfObjects = arrayOfObjects_;


- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (void)dealloc {
  self.arrayOfStrings = nil;
  self.arrayOfIntegers = nil;
  self.arrayOfDecimals = nil;
  self.arrayOfBools = nil;
  self.arrayOfObjects = nil;
  [super dealloc];
}


@end


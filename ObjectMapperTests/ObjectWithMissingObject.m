//
//  ObjectWithMissingObject.m
//
//  Created by Mattias Levin on 2011-10-10.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithMissingObject.h"

@implementation ObjectWithMissingObject

@synthesize arrayOfStrings = arrayOfStrings_;
@synthesize arrayOfIntegers = arrayOfIntegers_;
@synthesize arrayOfDecimals = arrayOfDecimals_;
@synthesize arrayOfBools = arrayOfBools_;
MAP_CLASS_TO_ARRAY(ObjectWithBasicTypes, arrayOfObjects)
@synthesize arrayOfObjects = arrayOfObjects_;
@synthesize arrayOfMissingObjects = arrayOfMissingObjects_;


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
  self.self.arrayOfBools = nil;
  self.arrayOfObjects = nil;
  self.arrayOfMissingObjects = nil;
  
  [super dealloc];
}
@end




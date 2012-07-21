//
//  ObjectWithDate8601.m
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import "ObjectWithDateISO8601.h"
#import "SimpleDateConverter.h"

@implementation ObjectWithDateISO8601

@synthesize string = string_;
@synthesize integer = integer_;
@synthesize _decimal = _decimal_;
@synthesize boolean = boolean_;

MapUnixTimestampToDate(date1)
@synthesize date1 = date1_;

MapISO8601ToDate(date2)
@synthesize date2 = date2_;

MapISO8601ToDate(date3)
@synthesize date3 = date3_;

MapISO8601ToDate(date4)
@synthesize date4 = date4_;

MapISO8601ToDate(date5)
@synthesize date5 = date5_;

MapISO8601ToDate(date6)
@synthesize date6 = date6_;

MapISO8601ToDate(date7)
@synthesize date7 = date7_;

MapNETDateToDate(date8)
@synthesize date8 = date8_;

MapNETDateToDate(date9)
@synthesize date9 = date9_;

MapNETDateToDate(date10)
@synthesize date10 = date10_;


- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}


- (NSString*)description {
  return [NSString stringWithFormat:@"string=%@, integer=%@, decimal=%@, boolean=%d date1=%@ date2=%@ date3=%@ date4=%@ date5=%@ date6=% date7=%@ date8=%@ date9=%@ date10=%",
          self.string, 
          self.integer,
          self._decimal,
          self.boolean,
          self.date1,
          self.date2,
          self.date3,
          self.date4,
          self.date5,
          self.date6,
          self.date7,
          self.date8,
          self.date9,
          self.date10];                                                                                                
}


- (void) dealloc {  
  self.string = nil;
  self.integer = nil;
  self._decimal = nil;
  self.date1 = nil;
  self.date2 = nil;
  self.date3 = nil;
  self.date4 = nil;  
  self.date5 = nil;
  self.date6 = nil;
  self.date7 = nil;
  self.date8 = nil;  
  self.date9 = nil;
  self.date10 = nil;
  [super dealloc];
}

@end

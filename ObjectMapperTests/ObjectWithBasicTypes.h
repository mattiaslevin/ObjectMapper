//
//  ObjectWithBasicTypes.h
//
//  Created by Mattias Levin on 2011-10-08.
//  Copyright 2011 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectWithBasicTypes : NSObject

@property (retain) NSString *string;
@property (retain) NSNumber *integer;
@property (retain) NSNumber *_decimal;
@property BOOL boolean;

@end

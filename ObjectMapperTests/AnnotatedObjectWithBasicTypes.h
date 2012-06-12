//
//  AnnotatedObjectWithBasicTypes.h
//
//  Created by Mattias Levin on 6/9/12.
//  Copyright (c) 2012 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectMapper.h"

@interface AnnotatedObjectWithBasicTypes : NSObject

@property (retain) NSString *stringWithADifferentName;
@property (retain) NSNumber *integer;
@property (retain) NSNumber *_decimal;
@property BOOL boolean;

@end

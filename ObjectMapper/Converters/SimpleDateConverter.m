//
//  SimpleDateConverter.m
//  ObjectMapper
//
//  Created by Mattias Levin on 7/17/12.
//  Copyright (c) 2012 Wadpam. All rights reserved.
//

#import "SimpleDateConverter.h"


@interface SimpleDateConverter  ()
+ (double)secondsOffsetFromUTC:(NSString*)TZD;
@end


@implementation SimpleDateConverter


// Convert a UNIX timestamp to NSDate
+ (NSDate*)dateFromUNIXTimestamp:(NSNumber*)timestamp {
  //NSLog(@"Convert from unix timestamp %@", timestamp);
  
  // Convert to string
  NSString *timestampString = [timestamp stringValue];
  
  // Check if UNIX time
  NSError *error = nil;
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^-?\\d+$" 
                                                                              options:0 
                                                                                error:&error];
  NSTextCheckingResult *match = [expression firstMatchInString:timestampString 
                                                       options:0 
                                                         range:NSMakeRange(0, [timestampString length])];
  if (match) {
    return [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
  } else
    return nil;
}


// Convert a ISO8601 time into NSDate.
+ (NSDate*)dateFromISO8601:(NSString*)dateString {
  //NSLog(@"Convert from ISO8601 date %@", dateString);
  
  // Check if ISO8601
  NSError *error = nil;
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^([\\d-]+T[\\d:]+)((Z)|([\\+-]\\d{2})|([\\+-]\\d{2}:?\\d{2}))?$" 
                                                                              options:0 
                                                                                error:&error];
  NSTextCheckingResult *match = [expression firstMatchInString:dateString 
                                                       options:0 
                                                         range:NSMakeRange(0, [dateString length])];
  if (match) {
        static NSDateFormatter *ISO8601Formatter = nil;
    // Create date formatter
    if (!ISO8601Formatter) {
      ISO8601Formatter = [[NSDateFormatter alloc] init];
      ISO8601Formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";  
    }
    
    // Get the time zone offset
    if (!NSEqualRanges([match rangeAtIndex:2], NSMakeRange(NSNotFound, 0))) {
      //NSLog(@"ISO8601 date match. Time zone part %@", [dateString substringWithRange:[match rangeAtIndex:2]]);
      double offset = [SimpleDateConverter secondsOffsetFromUTC:[dateString substringWithRange:[match rangeAtIndex:2]]];
      //NSLog(@"Seconds offset from UTC %f", offset);
      ISO8601Formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:offset];
    } else 
      ISO8601Formatter.timeZone = [NSTimeZone localTimeZone];
    
    return [ISO8601Formatter dateFromString:[dateString substringWithRange:[match rangeAtIndex:1]]];    
  
  } else
    return nil;
}


// Convert a .NET date, e.g. "\/Date(1310669017000)\/", into a NSDate
+ (NSDate*)dateFromNETDate:(NSString*)dateString {
  //NSLog(@"Convert from .NET date %@", dateString);

  // Check if .NET date format
  NSError *error = nil;
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^\\/Date\\((-?\\d+?)((Z)|([\\+-]\\d{2})|([\\+-]\\d{2}:?\\d{2}))?\\)\\/$" 
                                                                              options:0 
                                                                                error:&error];
  NSTextCheckingResult *match = [expression firstMatchInString:dateString 
                                                       options:0 
                                                         range:NSMakeRange(0, [dateString length])];
  if (match) {    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dateString substringWithRange:[match rangeAtIndex:1]] doubleValue]];
    
    // Get the time zone offset
    double offset = 0;
    if (!NSEqualRanges([match rangeAtIndex:2], NSMakeRange(NSNotFound, 0))) {
      //NSLog(@".NET date match. Time zone part %@", [dateString substringWithRange:[match rangeAtIndex:2]]);
      offset = [self secondsOffsetFromUTC:[dateString substringWithRange:[match rangeAtIndex:2]]];
      //NSLog(@"Seconds offset from UTC %f", offset);
    }
    
    return [NSDate dateWithTimeInterval:offset sinceDate:date];
  } else
    return nil;
}
  

// Return the time zone offset in seconds based on the TZD (Time Zone Designator)
// The following formats are stupport Z, +/-[hh], +/-[hhmm], +/-[hh:mm]
+ (double)secondsOffsetFromUTC:(NSString*)TZD {
  
  // If no time zone designator is provided or nill, ansume local time
  if ([TZD length] == 0 || TZD == nil) {
    NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
    return [localTimeZone secondsFromGMT];
  }
  
  // If already UTC offset (Z) return 0
  if ([TZD isEqualToString:@"Z"])
    return 0;
  
  // Calculate the offset in seconds
  double offsetFromUTC = 0;
  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^([\\+-]\\d{2}):?(\\d{2})?$" options:0 error:nil];
  NSTextCheckingResult *match = [expression firstMatchInString:TZD options:0 range:NSMakeRange(0, [TZD length])];
  if (match) {
    // Hours part to seconds
    offsetFromUTC = [[TZD substringWithRange:[match rangeAtIndex:1]] doubleValue] * 60 * 60;
    
    // Minutes part to seconds
    if (!NSEqualRanges([match rangeAtIndex:2], NSMakeRange(NSNotFound, 0)))
      offsetFromUTC = (fabs(offsetFromUTC) + [[TZD substringWithRange:[match rangeAtIndex:2]] doubleValue] * 60) * (offsetFromUTC < 0 ? -1 : 1);
  }
  return offsetFromUTC;  
}


@end

//
//  SimpleDateConverter.h
//  ObjectMapper
//
//  Created by Mattias Levin on 7/17/12.
//  Copyright (c) 2012 Wadpam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectMapper.h"

/**
 The SimpleDateConverter is an ObjectMapper customer converter turning JSON dates into NSDate.
 
 The JSON standard does not specify any format for date representation and several different variants exits.
 The converter support UNIX timestamp, ISO8601 (partly, see below) and .NET timestamp.
  
 - `1310669017000` - UNIX time double (seconds since 00:00:00 UTC January 1 1970)     
 - `"2011-07-14T19:43:37"` - ISO8601 no timezone    
 - `"2011-07-14T19:43:37Z"` - ISO8601 with UTC timezome   
 - `"2011-07-14T19:43:37+01"` - ISO8601 with UTC+1 timezome   
 - `"2011-07-14T19:43:37+0100"` - ISO8601 with UTC+1 timezone   
 - `"2011-07-14T19:43:37+01:00"` - ISO8601 with UTC-1 timezone   
 - `"\/Date(1310669017000)\/"` - .NET timestamp (seconds since January 1, 1970)   
 - `"\/Date(1310669017000+0100)\/"` - .NET timestamp with UTC+1 timezone   
 
 Use the macros below to annotate your properties.

 - `MapUnixTimestampToDate(key)` - Use this annotation to convert a unix timestamp into a NSDate
 - `MapISO8601ToDate(key)` - Use this annotation to convert a ISO8601 date into a NSDate
 - `MapNETDateToDate(key)` - Use this annotation to convert a .NET timestamp into a NSDate
 
 Use these macros in the @implementation section of your domain objects just above the properties @synthesize statement.
 
    @implementation Dates
 
    MapUnixTimestampToDate(dateFromUnixTimestamp)
    @synthesize dateFromUnixTimestamp;
 
    MapISO8601ToDate(dateFromISO8601Timestamp)
    @synthesize dateFromISO8601Timestamp;
 
    MapNETDateToDate(dateFromNETDate)
    @synthesize dateFromNETDate;
 
    @end
 
 If support for another date format is needed either implement a custome converter or let the application
 layer parse the value into a NSDate representation.
  */
@interface SimpleDateConverter : NSObject


/**
 Convert a unix timestamp, e.g. `1310669017000`, into NSDate
 */
#define MapUnixTimestampToDate(key) MapKeyToBlock(key, ^(id timestamp) { return [SimpleDateConverter dateFromUNIXTimestamp:timestamp]; };)


/**
 Convert a ISO8601 date into NSDate.
 
 Only a subset of of the ISO8601 is supported.
 
 - `"2011-07-14T19:43:37"` - ISO8601 no timezone    
 - `"2011-07-14T19:43:37Z"` - ISO8601 with UTC timezome   
 - `"2011-07-14T19:43:37+01"` - ISO8601 with UTC+1 timezome   
 - `"2011-07-14T19:43:37+0100"` - ISO8601 with UTC+1 timezone   
 - `"2011-07-14T19:43:37+01:00"` - ISO8601 with UTC-1 timezone   
 */
#define MapISO8601ToDate(key) MapKeyToBlock(key, ^(id dateString) { return [SimpleDateConverter dateFromISO8601:dateString]; };)


/**
 Convert a .NET timestamp into NSDate.
 
 The following formats are supported
 
 - `"\/Date(1310669017000)\/"` - .NET timestamp (seconds since January 1, 1970)   
 - `"\/Date(1310669017000+0100)\/"` - .NET timestamp with UTC+1 timezone     
 */
#define MapNETDateToDate(key) MapKeyToBlock(key, ^(id dateString) { return [SimpleDateConverter dateFromNETDate:dateString]; };)


/**
 Convert a UNIX timestamp to a NSDate.
 @param timestamp A UNIX timestamp
 @return The converted NSDate
 */
+ (NSDate*)dateFromUNIXTimestamp:(NSNumber*)timestamp;

/**
 Convert an ISO8601 date string to a NSDate.
 @param dateString An ISO8601 date string
 @return The converted NSDate
 */
+ (NSDate*)dateFromISO8601:(NSString*)dateString;   

/**
 Convert a .NET timestamp to a NSDate.
 @param dateString A .NET date timestamp
 @return The converted NSDate
 */
+ (NSDate*)dateFromNETDate:(NSString*)dateString;   


@end

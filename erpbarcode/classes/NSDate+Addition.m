//
//  NSDate+Addition.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 30..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

+ (NSString*)TodayStringWithDashNColon
{
	NSDate* date = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)TodayString
{
	NSDate* date = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
	[dateFormatter setDateFormat:@"yyyyMMdd"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)TodayStringWithDash
{
	NSDate* date = [NSDate date];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)TimeString
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HHmmss"];
//    [dateFormatter setDateFormat:@"hhmmss"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)DateTimeString
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)YearString
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}

+ (NSString*)MonthString
{
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM"];
	NSString* retVal = [dateFormatter stringFromDate:date];
	return retVal;
}
@end

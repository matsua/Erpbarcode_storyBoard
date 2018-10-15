//
//  NSDate+Addition.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 30..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)
+ (NSString*)TodayStringWithDashNColon;
+ (NSString*)TodayString;
+ (NSString*)TimeString;
+ (NSString*)DateTimeString;
+ (NSString*)YearString;
+ (NSString*)MonthString;
+ (NSString*)TodayStringWithDash;
@end

//
//  Util.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scrollTouch.h"

@interface Util : NSObject
+ (void)udSetObject:(id)object forKey:(NSString *)key;
+ (void)udSetBool:(BOOL)boolValue forKey:(NSString *)key; //BOOL 값 넣는다.

+ (id)udObjectForKey:(NSString *)key;
+ (BOOL)udBoolForKey:(NSString *)key; //BOOL값 가져온다.
+ (void)udRemoveObject:(NSString *)key;
+ (void)udArchiveSetObject:(id)object forKey:(NSString *)key;
+ (id)udArchiveObjectForKey:(NSString *)key;


+ (id) defaultMessage:(NSDictionary*)headerDic body:(NSDictionary*)bodyDic;
+ (id) defaultLoginHeader:(NSString*)telNo;
+ (id) defaultHeader;
+ (id) noneMessageBody:(NSDictionary*)paramDic;
+ (id) singleMessageBody:(NSDictionary*)paramDic;
+ (id) singleListMessageBody:(NSArray *)paramDicList;
+ (id) doubleMessageBody:(NSDictionary*)paramDic subParam:(NSArray*)subParamList;

+ (int)mainVersionNumber;
+ (float)deltaY:(float)original;
//navi button
+ (id) makeLeftNaviButton:(NSString*)fileName;
+ (id) makeRightNaviButton:(NSString*)fileName;
+ (void)playSoundWithMessage:(NSString*)message isError:(BOOL)isError;
+ (void)playSoundWithFileName:(NSString*)fileName fileFormat:(NSString*)fileFormat;
+ (void)setScrollTouch:(scrollTouch*)sv Label:(UILabel*)label withString:(NSString*)string;
+ (NSString*)loadSetupInfoFromPlist:(NSString*)key;
+ (BOOL)writeSetupInfoToPlist:(NSString*)key value:(NSString*)value;
+ (NSString*)getTitleWithServerNVersion;

+ (NSString*)barcodeMatchVal:(int)type barcode:(NSString*)barcode;
@end

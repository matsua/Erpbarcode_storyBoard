//
//  WorkUtil.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 14..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkUtil : NSObject
+ (NSString*) processCheckFccStatus:(NSString*)status desc:(NSString*)desc submt:(NSString*)submt;
+ (NSString*) processIMRCheckFccStatus:(NSString*)status desc:(NSString*)desc submt:(NSString*)submt injuryBarcode:(NSString*)injuryBarcode;
+ (NSString*) getWorkName:(NSString*)workCode;
+ (NSString*) getWorkCode:(NSString*)workName;
+ (NSString*) getPartTypeFullName:(NSString*)partType device:(NSString*)deviceType;
+ (NSString*) getPartTypeName:(NSString*)partCode device:(NSString*)deviceCode;
+ (NSString*) getPartTypeCode:(NSString*)partTypeName;
+ (NSString*) getPartTypeFullNameForShortName:(NSString*)partTypeShortName;
+ (NSString*) getDeviceCode:(NSString*)devTypeName;
+ (NSString*) getDeviceTypeName:(NSString*)deviceCode;
+ (NSString*) getPartNodeString:(NSString*)partName;
+ (NSString*) getFacilityStatusName:(NSString*)statusCode;
+ (NSString*) getFacilityStatusCode:(NSString*)statusName;
+ (NSMutableDictionary*) getMaterial:(NSString*)barcode;
+ (int) getParentIndex:(NSString*)upperBarcode fccList:(NSArray*)fccList;
+ (NSString*) getParentPartName:(NSArray*)fccList;
+ (NSIndexSet*) getSelectedGridIndexes:(NSArray*)fccList;
+ (int) getNoticeIndex:(NSString*)title noticeList:(NSArray*)noticeList;
+ (int) getLocIndex:(NSString*)locCode fccList:(NSArray*)fccList;
+ (int) getBarcodeIndex:(NSString*)barcode fccList:(NSArray*)fccList;
+ (int) getSendOrgIndex:(NSString*)orgCode fccList:(NSArray*)fccList;
+ (int) getGbicIndex:(NSString*)barcode fccList:(NSArray*)fccList;
+ (NSIndexSet*) getReverseParentIndexes:(NSArray*)fccList;
+ (int) getReverseParentIndex:(NSArray*)fccList;
+ (NSString*) getScanTypeOfBarcode:(NSString*)upperBarcode fccList:(NSArray*)fccList;
+ (int) getChildBarcodeIndex:(NSString*)barcode fccList:(NSArray*)fccList;
+ (NSIndexSet*) getChildBarcodeIndexes:(NSString*)barcode fccList:(NSArray*)fccList;
+ (NSArray*) getSpotScanList:(NSArray*)fccList;
+ (NSArray*) getSpotAddList:(NSArray*)fccList;
+ (NSArray*) getSpotDBList:(NSArray*)fccList;
+ (int) getRealCount:(NSArray*)fccList;
+ (NSIndexSet*) getScanIndexes:(NSArray*)fccList;
+ (int) getUpperIndex:(NSString*)partTypeName selectedIndex:(int)selectedIndex fccList:(NSArray*)fccList isCheckUU:(BOOL)isCheckUU compareLevel:(BOOL)isCompBelow;
+ (int) getUpperIndex:(NSString*)partTypeName selectedIndex:(int)selectedIndex limitIndex:(int)limitIndex fccList:(NSArray*)fccList isCheckUU:(BOOL)isCheckUU compareLevel:(BOOL)isCompBelow;
+ (NSMutableDictionary*)getItemFromFccList:(NSString*)barcode fccList:(NSArray*)fccList;
+ (void)setChild:(NSDictionary*)child fccList:(NSArray*)fccList;
+ (void)setParent:(NSMutableDictionary*)parent fccList:(NSArray*)fccList;
+ (void) getChildIndexesOfCurrentIndex:(NSInteger)index fccList:(NSArray*)fccList childSet:(NSMutableIndexSet*)childSet isContainSelf:(BOOL)isContainSelf;
+ (void) getChildOrgesOfCurrentIndex:(NSInteger)index orgList:(NSArray*)orgList childSet:(NSMutableIndexSet*)childSet isContainSelf:(BOOL)isContainSelf;
+ (void) deleteBarcodeIndex:(NSInteger)index fccList:(NSMutableArray*)fccList;
+ (void)moveSource:(NSString*)source toTarget:(NSString*)target fccList:(NSMutableArray*)fccList;
+ (void)moveObjectBarcode:(NSString*)objBarcode belowTargetBarcode:(NSString*)tarBarcode inFccList:(NSMutableArray*)fccList isUserDeviceId:(BOOL)isUseDeviceId;
+ (void)moveObject:(NSDictionary*)object BelowTarget:(NSDictionary*)target InFccList:(NSMutableArray*)fccList isUseDeviceId:(BOOL)isUseDeviceId;
+ (void) moveIndexSet:(NSIndexSet*)movedIndexSet BelowTarget:(NSDictionary*)targetItem InList:(NSMutableArray*)fccList isUseDeviceId:(BOOL)isUseDeviceId;
+ (NSDictionary*) getLastNodeByItem:(NSDictionary*)item InFccList:(NSArray*)fccList;
+ (NSDictionary*)getChild:(NSString*)barcode InFccList:(NSArray*)fccList;
+ (NSDictionary*)getParent:(NSDictionary*)childDic fccList:(NSArray*)fccList;
+ (NSString*)nodeValidateSourceType:(NSString*)sourceType TargetType:(NSString*)targetType isCheckSu:(BOOL)isChkSu;
+ (void)updateParent:(NSString*)parentBarcode withModifyParent:(NSString*)modifiedBarcode fccList:(NSArray*)fccList;
+ (NSString*)makeHierarchyOfAddedData:(NSMutableDictionary*)sapDic selRow:(NSInteger*) selRow isMakeHierachy:(BOOL) isMakeHierachy isCheckUU:(BOOL) isCheckUU isRemake:(BOOL)isRemake fccList:(NSMutableArray*)fccList job:(NSString*)job;
+ (void)modifySelectedInfo:(NSDictionary*)oldDic newInfo:(NSDictionary*)newDic fccList:(NSMutableArray*)fccList;
+ (NSIndexSet*)getRootFacs:(NSArray*)fccList;
+ (NSArray*)getBarcodeInfoInPDA:(NSString*)barcode errorMessage:(NSString*)errMsg;
+ (NSString*)getFullNameOfLoc:(NSString*)address;
+ (NSString*)messageChkValidateFccItem:(NSString*)fccBarcode;
@end

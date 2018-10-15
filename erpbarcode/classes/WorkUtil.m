//
//  WorkUtil.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 14..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "WorkUtil.h"
#import "OutIntoViewController.h"
#import "Constant.h"

@implementation WorkUtil

+ (NSString*) getWorkName:(NSString*)workCode
{
    NSDictionary* mapWorkName = [Util udObjectForKey:MAP_WORK_NAME];
    if (mapWorkName.count)
        return [mapWorkName objectForKey:workCode];
    else
        return @"";
}

+ (NSString*) getWorkCode:(NSString*)workName
{
    NSDictionary* mapWorkCode = [Util udObjectForKey:MAP_WORK_CD];
    if (mapWorkCode.count)
       return [mapWorkCode objectForKey:workName];
    else
        return @"";
}

+ (NSString*) getPartTypeName:(NSString*)partCode device:(NSString*)deviceCode
{
     NSDictionary* dic = [Util udObjectForKey:MAP_PART_TYPE];
    if ([dic count]){
        if ([deviceCode isEqualToString:@"30"])
            //return @"N/A" ;
            return @"E" ;
        else {
            NSString* typeName = [dic objectForKey:partCode];
            if (!typeName)
                return @"";
            else
                return typeName;
        }
    }
    else
        return @"";
}

+ (NSString*) getPartTypeFullName:(NSString*)partType device:(NSString*)deviceType
{
    if ([deviceType isEqualToString:@"30"])
        return @"Equipment";
//        return @"N/A";
    else if ([partType isEqualToString:@"10"])
        return @"Rack";
    else if ([partType isEqualToString:@"20"])
        return @"Shelf";
    else if ([partType isEqualToString:@"30"])
        return @"Unit";
    else
        return @"";
}

+ (NSString*) getPartTypeCode:(NSString*)partTypeName
{
    NSString* codeValue = @"";
    if ([partTypeName isEqualToString:@"R"])
        codeValue = @"10";
    else if ([partTypeName isEqualToString:@"S"])
        codeValue = @"20";
    else if ([partTypeName isEqualToString:@"U"])
        codeValue = @"30";
    else if ([partTypeName isEqualToString:@"E"])
        codeValue = @"";
    return codeValue;
}

+ (NSString*) getPartTypeFullNameForShortName:(NSString*)partTypeShortName
{
    NSDictionary* partNameDic = [Util udObjectForKey:MAP_PART_NAME];
    NSString* partFullName = [partNameDic objectForKey:partTypeShortName];
    
    return  partFullName;
}


+ (NSString*) getDeviceCode:(NSString*)devTypeName
{
    NSString* codeValue = @"";
    if ([devTypeName isEqualToString:@"대표물품"])
        codeValue = @"10";
    else if ([devTypeName isEqualToString:@"조립품"])
        codeValue = @"20";
    else if ([devTypeName isEqualToString:@"단품"])
        codeValue = @"30";
    else if ([devTypeName isEqualToString:@"부품"])
        codeValue = @"40";
    else if ([devTypeName isEqualToString:@"케이블"])
        codeValue = @"50";
    

    return codeValue;
}

+ (NSString*) getDeviceTypeName:(NSString*)deviceCode
{
    if (deviceCode.length !=2)
        return @"";
    NSDictionary* dic = [Util udObjectForKey:MAP_DEVICE_TYPE];
    if ([dic count])
        return [dic objectForKey:deviceCode];
    else
        return @"";
    
}

+ (NSString*) getPartNodeString:(NSString*)partName
{
    if (partName.length !=1)
        return @"";
    NSDictionary* dic = [Util udObjectForKey:MAP_PART_NAME];
    if ([dic count])
        return [dic objectForKey:partName];
    else
        return @"";
    
}


+ (NSString*) getFacilityStatusName:(NSString*)statusCode
{
    
    if (statusCode.length != 4)
        return @"";
    NSDictionary* dic = [Util udObjectForKey:MAP_FACILITY_NAME];
    if ([dic count])
        return [dic objectForKey:statusCode];
    else
        return @"";
    
}

+ (NSString*) getFacilityStatusCode:(NSString*)statusName
{
    NSDictionary* dic = [Util udObjectForKey:MAP_FACILITY_TYPE];
    if ([dic count])
        return [dic objectForKey:statusName];
    else
        return @"";
}

+ (NSMutableDictionary*) getMaterial:(NSString*)barcode
{
    NSString* MATNR = @"";
    NSString* BISMT = @"";
    
    NSRange range = [barcode rangeOfString:@"9"];
    
    if (barcode.length == 16 && ![barcode hasPrefix:@"K"])
    {
        MATNR = [barcode substringToIndex:8];
    }
    else if (barcode.length == 18)
    {
        BISMT = [barcode substringToIndex:10];
    }
    else if (barcode.length == 17)
    {
        if ([[barcode substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"9"])
        {
            MATNR = @"K";
            MATNR = [MATNR stringByAppendingString:[barcode substringWithRange:NSMakeRange(4,7)]];
        }
        else{
            MATNR = [barcode substringToIndex:8];
        }
    }
    else if (barcode.length >= 16 && barcode.length <=18 && range.location != NSNotFound)
    {
        MATNR = @"K";
        MATNR = [MATNR stringByAppendingString:[barcode substringWithRange:NSMakeRange(range.location,7)]];
    }
//    NSLog(@" MATNR[%@] BISMT[%@]",MATNR,BISMT);
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:MATNR,@"matnr",BISMT,@"bismt",nil];
}

// 설비종류(partTypeName)와 현재 선택된 셀번호를 이용해서 상위(parent or HEQUNR)를 찾아 index를 리턴한다.
// isCheckUU - UU 버튼이 YES라면 U - U가 가능하므로 이를 참조하여 상위를 찾는다.
// isCompBelow - selectedIndex기준으로 계속 상위를 찾아서 비교할 것인지(YES),
// 아니면 selectedIndex가 유효한 상위인지 비교할 것인지(NO)
+ (int) getUpperIndex:(NSString*)partTypeName selectedIndex:(int)selectedIndex limitIndex:(int)limitIndex fccList:(NSArray*)fccList isCheckUU:(BOOL)isCheckUU compareLevel:(BOOL)isCompBelow
{
    //상위 - 하위
    //D-R *   x
    //U-U - U x
    //R-S * x
    //D-S * x
    //D-E * x
    //R||S - U * x
    
    NSPredicate *predicate;
    
    // UU 버튼이 선택되었다면 U밑으로 U가 들어갈 수 있다.
    if (isCheckUU && [partTypeName isEqualToString:@"U"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='U'"];
    }
    // UU 버튼이 선택되지 않았다면 U는 S or R 밑으로 들어갈 수 있다.
    else if ([partTypeName isEqualToString:@"U"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME == 'S' OR PART_NAME='R'"];
    }
    // S는 R또는 D밑으로 가능
    else if ([partTypeName isEqualToString:@"S"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='R' OR PART_NAME='D'"];
    }
    // R은 D밑으로 가능
    else if ([partTypeName isEqualToString:@"R"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='D'"];
    }
    // E는 D밑으로 가능
    else if ([partTypeName isEqualToString:@"E"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='D'"];
    }
    // D는 L밑으로 가능
    else if ([partTypeName isEqualToString:@"D"])
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='L'"];
    
    int index = (int)[fccList indexOfObjectWithOptions:NSEnumerationReverse passingTest:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                     if (isCompBelow && idx <= selectedIndex && idx >= limitIndex){

                         return [predicate evaluateWithObject:obj];
                     }
                     if (!isCompBelow && idx == selectedIndex){
                         return [predicate evaluateWithObject:obj];
                     }

                     return NO;
                 }];
    
    return index;
}

+ (int) getUpperIndex:(NSString*)partTypeName selectedIndex:(int)selectedIndex  fccList:(NSArray*)fccList isCheckUU:(BOOL)isCheckUU compareLevel:(BOOL)isCompBelow
{
    //상위 - 하위
    //D-R *   x
    //U-U - U x
    //R-S * x
    //D-S * x
    //D-E * x
    //R||S - U * x
    
    NSPredicate *predicate;
    
    if (isCheckUU && [partTypeName isEqualToString:@"U"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='U'"];
    }
    else if ([partTypeName isEqualToString:@"U"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME == 'S' OR PART_NAME='R'"];
    }
    else if ([partTypeName isEqualToString:@"S"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='R' OR PART_NAME='D'"];
    }
    else if ([partTypeName isEqualToString:@"R"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='D'"];
    }
    else if ([partTypeName isEqualToString:@"E"]){
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='D'"];
    }else if ([partTypeName isEqualToString:@"D"])
        predicate = [NSPredicate predicateWithFormat:@"PART_NAME='L'"];
    
    int index = (int)[fccList indexOfObjectWithOptions:NSEnumerationReverse passingTest:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                     if (isCompBelow && idx <= selectedIndex){
                         return [predicate evaluateWithObject:obj];
                     }
                     if (!isCompBelow && idx == selectedIndex){
                         return [predicate evaluateWithObject:obj];
                     }
                     return NO;
                 }];
    
    return index;
}

+ (NSString*) processIMRCheckFccStatus:(NSString*)status desc:(NSString*)desc submt:(NSString*)submt injuryBarcode:(NSString*)injuryBarcode
{
    NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSString* message = @"";
    
    // 인스토어마킹완료 :: 납품취소 0021, 사용중지 0260, 불용요청 0210, 불용확정 0240,  인계완료 0050, 인수예정 0040, 시설등록완료 0045 무조건 오류 처리 :matsu 15.10.29
    if([JOB_GUBUN isEqualToString:@"인스토어마킹완료"]){
        if([status isEqualToString:@"0021"] ||
           [status isEqualToString:@"0260"] ||
           [status isEqualToString:@"0210"] ||
           [status isEqualToString:@"0240"] ||
           [status isEqualToString:@"0050"] ||
           [status isEqualToString:@"0040"] ||
           [status isEqualToString:@"0045"]){
            message = [NSString stringWithFormat:@"구바코드('%@')의\n\r설비상태가 '%@' 진행중입니다.\n\r해당 작업완료 or취소 후,\n\r인스토어마킹 프로세스\n\r진행 가능합니다.", injuryBarcode, desc];
            return message;
        }
    }
    return message;
}


+ (NSString*) processCheckFccStatus:(NSString*)status desc:(NSString*)desc submt:(NSString*)submt
{
    
     /*
     "0020", "납품입고" -> 불가
     "0021", "납품취소" -> 불가
     "0040", "인수예정" -> 불가
     "0045", "시설등록완료" -> 불가
     "0050", "인계완료" -> 불가
     "0060", "운용"
     "0070", "미운용"
     "0080", "탈장"
     "0100", "유휴"
     "0110", "예비"
     "0120", "고장" -> 불가
     "0130", "수리의뢰" -> 불가
     "0140", "이동중" -> 불가
     "0160", "수리완료송부" -> 불가 by 김소연 -> 가능 by 정진우
     "0170", "개조의뢰" -> 불가
     "0171", "개조완료송부"
     "0190", "철거확정"
     "0200", "불용대기"
     "0210", "불용요청" -> 불가
     "0230", "불용반려"
     "0240", "불용확정"-> 불가
     "0260", "사용중지" -> 불가
     "0270", "출고중" -> 불가 by 김소연 -> 가능 by 정진우
     "0081", "분실위험"
     
     // 추가 - request by 김두영 2012.06.04
     "0041", "인계작업취소"
     "0042", "인수거부"
     "0046", "시설등록취소"
     
     // 삭제대상
     "0010", "투입(출고)"
     "0030", "교체요청"
     "0090", "실장중"
     "0150", "수리진행"
     "0180", "철거중" -> 이런 상태값도 있나요? 삭제대상 상태입니다.(철거확정 상태값 존재합니다.)
     "0220", "불용품"
     "0250", "손망실" -> 이런 상태값도 있나요? 삭제대상 상태입니다.(손망실은 불용사유 중 하나일 뿐, 불용 관련 상태값은 불용대기,불용요청,불용확정 중 하나일 뿐입니다.)
     * **/
    
    NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSString* message;
    
    BOOL isError = NO;
    
    // 설비정보조회, 장치바코드하위설비조회는 설비상태와 관계 없이 모두 가능하므로 그냥 리턴한다.
    if ([JOB_GUBUN isEqualToString:@"설비정보"] ||
        [JOB_GUBUN isEqualToString:@"장치바코드하위설비조회"]
        ){
        return @"";
    }
    // 불용확정, 사용중지, 납품취소 무조건 오류 처리
    else if (
        [status isEqualToString:@"0240"] ||
        [status isEqualToString:@"0260"] ||
        [status isEqualToString:@"0021"]
        )
    {
        if ([status isEqualToString:@"0240"]){
            NSArray* gbicUselessList = [Util udObjectForKey:GBIC_USELESS_LIST];
            int index = (int)[gbicUselessList indexOfObject:submt];
            if (index != -1){
                message = [NSString stringWithFormat:@"광모듈(GBIC) 설비 '%@' (은)는\n바코드 비관리 대상으로 결정되어\n'불용확정' 상태로\n변경되었습니다.",submt];
                return message;
            }
        }
        message = [NSString stringWithFormat:@"설비의 상태가 '%@'인 설비는\n스캔 하실 수 없습니다.",desc];
        return message;
    }
    // 0140 - 이동중
    // DR-2015-29749 바코드시스템 내 팝업 메시지 내용 변경 요청 by 조석호 과장
    else if ([status isEqualToString:@"0140"] && [JOB_GUBUN isEqualToString:@"인스토어마킹완료"]){
        message = [NSString stringWithFormat:@"상태가 '%@'인 설비가 존재합니다.\n '%@'상태 설비는 인스토어마킹\n 완료후 '송부취소(팀간)'\n 또는 '접수(팀간)'\n SCAN을 수행하시기 바랍니다.", desc, desc];
        return message;
    }
    
    else if ([status isEqualToString:@"0140"] && ![JOB_GUBUN isEqualToString:@"접수(팀간)"] && ![JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        message = [NSString stringWithFormat:@"설비의 상태가 '%@'인 설비는\n'접수(팀간)' 또는 '송부취소(팀간)'\n메뉴를 사용하시기 바랍니다.", desc];
        return message;
    }
//    "0120", "고장"
//    "0130", "수리의뢰"
//    "0140", "이동중"
//    "0160", "수리완료송부"
//    "0170", "개조의뢰"
//    "0171", "개조완료송부"
//    "0200", "불용대기"
//    "0210", "불용요청"
    else if ([JOB_GUBUN isEqualToString:@"인계"] ||
             [JOB_GUBUN isEqualToString:@"시설등록"]){
        if (
            [status isEqualToString:@"0120"] ||
            [status isEqualToString:@"0130"] ||
            [status isEqualToString:@"0140"] ||
            [status isEqualToString:@"0160"] ||
            [status isEqualToString:@"0170"] ||
            [status isEqualToString:@"0171"] ||
            [status isEqualToString:@"0200"] ||
            [status isEqualToString:@"0210"]
            )
        {
            isError = YES;
        }
    }
//    "0020", "납품입고"
//    "0040", "인수예정"
//    "0045", "시설등록완료"
//    "0050", "인계완료"
//    "0120", "고장"
//    "0130", "수리의뢰"
//    "0140", "이동중"
//    "0160", "수리완료송부"
//    "0170", "개조의뢰"
//    "0171", "개조완료송부"
//    "0210", "불용요청"
    else if ([JOB_GUBUN isEqualToString:@"고장등록"]){
        if (
            [status isEqualToString:@"0020"] ||
            [status isEqualToString:@"0040"] ||
            [status isEqualToString:@"0045"] ||
            [status isEqualToString:@"0050"] ||
            [status isEqualToString:@"0120"] ||
            [status isEqualToString:@"0130"] ||
            [status isEqualToString:@"0140"] ||
            [status isEqualToString:@"0160"] ||
            [status isEqualToString:@"0170"] ||
            [status isEqualToString:@"0171"] ||
            [status isEqualToString:@"0210"]
            )
        {
            isError = YES;
        }
    }
//    "0120", "고장"
    else if ([JOB_GUBUN isEqualToString:@"고장등록취소"]){
        if (![status isEqualToString:@"0120"])
            isError = YES;
    }
//    "0020", "납품입고"
//    "0040", "인수예정"
//    "0120", "고장"
//    "0130", "수리의뢰"
//    "0140", "이동중"
//    "0170", "개조의뢰"
//    "0190", "철거확정"
//    "0210", "불용요청"
    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
        if (
            [status isEqualToString:@"0020"] ||
            [status isEqualToString:@"0040"] ||
            [status isEqualToString:@"0120"] ||
            [status isEqualToString:@"0130"] ||
            [status isEqualToString:@"0140"] ||
            [status isEqualToString:@"0170"] ||
            [status isEqualToString:@"0190"] ||
            [status isEqualToString:@"0210"]
            )
        {
            isError = YES;
        }
    }
//    "0130", "수리의뢰"
    else if ([JOB_GUBUN isEqualToString:@"수리의뢰취소"]){
        if (![status isEqualToString:@"0130"])
            isError = YES;
    }
//    "0170", "개조의뢰"
    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]){
        if (![status isEqualToString:@"0170"])
            isError = YES;
    }
//    "0020", "납품입고"
//    "0040", "인수예정"
//    "0045", "시설등록완료"
//    "0050", "인계완료"
//    "0120", "고장"
//    "0140", "이동중"
//    "0210", "불용요청"
    else if ([JOB_GUBUN isEqualToString:@"철거"]){
        if (
            [status isEqualToString:@"0020"] ||
            [status isEqualToString:@"0120"] ||
            [status isEqualToString:@"0140"] ||
            [status isEqualToString:@"0210"] ||
            [status isEqualToString:@"0040"] ||
            [status isEqualToString:@"0045"] ||
            [status isEqualToString:@"0050"]
            )
        {
            isError = YES;
        }
    }
//    "0060", "운용"
//    "0190", "철거확정"
//    "0210", "불용요청" -> 불가
    else if ([JOB_GUBUN isEqualToString:@"배송출고"]){
        if (
            [status isEqualToString:@"0060"] ||
            [status isEqualToString:@"0190"] ||
            [status isEqualToString:@"0210"]
        )
        {
            isError = YES;
        }
    }
//    "0020", "납품입고"
//    "0040", "인수예정"
//    "0041", "인계작업취소"
//    "0050", "인계완료"
//    "0120", "고장"
//    "0130", "수리의뢰"
//    "0140", "이동중"
//    "0160", "수리완료송부"
//    "0170", "개조의뢰"
//    "0250", "손망실"
    else if ([JOB_GUBUN isEqualToString:@"설비상태변경"]){
        if ([status isEqualToString:@"0020"] ||
            [status isEqualToString:@"0040"] ||
            [status isEqualToString:@"0041"] ||
            [status isEqualToString:@"0050"] ||
            [status isEqualToString:@"0120"] ||
            [status isEqualToString:@"0130"] ||
            [status isEqualToString:@"0140"] ||
            [status isEqualToString:@"0160"] ||
            [status isEqualToString:@"0170"] ||
            [status isEqualToString:@"0250"]){
            isError = YES;
        }
    }
//    "0140", "이동중"
    else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        if (![status isEqualToString:@"0140"])
            isError = YES;
    }
    
    if (isError){
        message = [NSString stringWithFormat:@"설비의 상태가 '%@'인 설비는\n'%@' 작업을\n하실 수 없습니다.",desc,JOB_GUBUN];
        return message;
    }
    
    return @"";
}

// 리스트에서 해당 위치바코드의 인덱스를 찾아 리턴(위치 바코드는 ZEQUIPLP임.)
+ (int) getLocIndex:(NSString*)locCode fccList:(NSArray*)fccList
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ZEQUIPLP == %@", locCode];
    NSUInteger index = [fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

+ (int) getNoticeIndex:(NSString*)title noticeList:(NSArray*)noticeList
{
    if (!title.length) return -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    NSUInteger index = [noticeList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
    }];

    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

// 바코드를 이용하여 리스트안의 인덱스를 리턴한다.(SAP)
+ (int) getBarcodeIndex:(NSString*)barcode fccList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"EQUNR CONTAINS %@", barcode];
    NSUInteger index = [fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

//송부조직코드값으로 인덱스 찾기
+ (int) getSendOrgIndex:(NSString*)orgCode fccList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SKOSTL == %@", orgCode];
    NSUInteger index = [fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

+ (int) getGbicIndex:(NSString*)barcode fccList:(NSArray*)fccList
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBMT == %@", barcode];
    NSUInteger index = [fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

// 아래에서 위로 찾아 상위(HEQUNR)이 없는 설비의 index 리스트를 리턴한다.
+ (NSIndexSet*) getReverseParentIndexes:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HEQUNR.length == 0"];
    NSIndexSet* indexSet = [fccList  indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    
    return indexSet;
}

// 아래에서 위로 찾아 상위(HEQUNR)이 없는 설비의 index를 리턴한다.
+ (int) getReverseParentIndex:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HEQUNR.length == 0"];
    NSUInteger index = [fccList indexOfObjectWithOptions:NSEnumerationReverse passingTest:^(id obj, NSUInteger idx, BOOL *stop)
     {
         return [predicate evaluateWithObject:obj];
     }];
    
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}

+ (int) getParentIndex:(NSString*)upperBarcode fccList:(NSArray*)fccList
{
    if (!upperBarcode.length) return -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"EQUNR == %@",upperBarcode];
    NSUInteger uiIndex = [fccList indexOfObjectWithOptions:NSEnumerationReverse passingTest:^(id obj, NSUInteger idx, BOOL *stop)
    {
         return [predicate evaluateWithObject:obj];        
    }];
    
    if(uiIndex == NSNotFound)
        uiIndex = -1;
    
    return (int)uiIndex;
}

// 리스트에서 해당 바코드를 찾아 SCANTYPE을 리턴
+ (NSString*) getScanTypeOfBarcode:(NSString*)upperBarcode fccList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"EQUNR == %@", upperBarcode];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];
    if (filteredArray.count){
        NSDictionary* dic = [filteredArray lastObject];
        return [dic objectForKey:@"SCANTYPE"];
    }
    else
        return @""; //상위바코드 없음
}

// 스캔한 설비 중 가장 앞쪽에 있는 설비의 PART_NAME을 리턴한다.
+ (NSString*) getParentPartName:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SCANTYPE != '0'"];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];
    if (filteredArray.count){
        NSDictionary* dic = [filteredArray objectAtIndex:0];

        return [dic objectForKey:@"PART_NAME"];
    }
    else
        return @"";
}

+ (int) getRealCount:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ORG_CHECK BEGINSWITH 'Y'"];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];

    return (int)[filteredArray count];
}

+ (NSArray*) getSpotScanList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SCANTYPE != '0'"];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];

    return filteredArray;
}

+ (NSArray*) getSpotAddList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SCANTYPE == '5' or SCANTYPE == '6'"];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];

    return filteredArray;
}


+ (NSArray*) getSpotDBList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SCANTYPE == '0' or SCANTYPE == '4' or SCANTYPE == '9'"];
    NSArray* filteredArray = [fccList filteredArrayUsingPredicate:predicate];

    return filteredArray;
}

// 스캔한 설비리스트 인덱스 셋을 리턴한다.
+ (NSIndexSet*) getScanIndexes:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SCANTYPE == '1' or SCANTYPE == '2' or SCANTYPE == '3'"];
    NSIndexSet* indexSet = [fccList  indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];

    return indexSet;
}

// 그리드뷰에서 체크박스에 선택된 항목들의 indexSet을 리턴하낟.
+ (NSIndexSet*) getSelectedGridIndexes:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IS_SELECTED == 1"];
    NSIndexSet* indexSet = [fccList  indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
        
    }];
    return indexSet;
}

// 리스트에서 해당 설비의 하위(child)설비 indexSet을 리턴하낟.
+ (int) getChildBarcodeIndex:(NSString*)barcode fccList:(NSArray*)fccList
{
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HEQUNR == %@", barcode];
    NSUInteger index = [fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    
    if(index == NSNotFound)
        index = -1;
    
    return (int)index;
}


+ (NSIndexSet*) getChildBarcodeIndexes:(NSString*)barcode fccList:(NSArray*)fccList
{
    if (!barcode.length)
        return nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HEQUNR == %@", barcode];
    NSIndexSet* indexSet = [fccList  indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    return indexSet;
}

// 바코드를 이용하여 해당 info(Dictionary*)를 리턴한다.
+ (NSDictionary*)getItemFromFccList:(NSString*)barcode fccList:(NSArray*)fccList
{
    int index = [WorkUtil getBarcodeIndex:barcode fccList:fccList];
    
    if (index == -1)
        return nil;
    else
        return [fccList objectAtIndex:index];
}

// 현재 노드의 HEQUNR과 바코드(EQUNR)가 같은 경우 현재노드의 바코드를 찾은 노드의 CHILD로 설정한다.
+ (void)setChild:(NSDictionary*)child fccList:(NSArray*)fccList
{
    for(NSDictionary* dic in fccList){
        NSString* parentBarcode = [dic objectForKey:@"EQUNR"];
        NSString* parentOfChildBarcode = [child objectForKey:@"HEQUNR"];
        
        if ([parentBarcode isEqualToString:parentOfChildBarcode]){// && [[dic objectForKey:@"CHILD"] isEqualToString:@""]){
            [dic setValue:[child objectForKey:@"EQUNR"] forKey:@"CHILD"];
            [dic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            return;
        }
    }
}

+ (void)setParent:(NSMutableDictionary*)parent fccList:(NSMutableArray*)fccList
{
    for(NSDictionary* dic in fccList){
        NSString* parentOfDic = [dic objectForKey:@"HEQUNR"];
        NSString* barcode = [parent objectForKey:@"EQUNR"];
        
        if ([parentOfDic isEqualToString:barcode]){
            [parent setValue:[dic objectForKey:@"EQUNR"] forKey:@"CHILD"];
            [parent setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            NSInteger pIndex = [fccList indexOfObject:parent];
            NSInteger cIndex = [fccList indexOfObject:dic];
            
            if (pIndex > cIndex){
                NSMutableDictionary* tmpDic = [parent mutableCopy];
                [fccList replaceObjectAtIndex:pIndex withObject:[dic mutableCopy]];
                [fccList replaceObjectAtIndex:cIndex withObject:tmpDic];
            }

            return;
        }
    }
}

// 바코드 삭제하기 위해서 사용한다.
+ (void) deleteBarcodeIndex:(NSInteger)index fccList:(NSMutableArray*)fccList
{
    NSMutableIndexSet* deletedIndexes = [NSMutableIndexSet indexSet];
    
    // 해당 index의 child set을 indexSet으로 얻어온다.
    [WorkUtil getChildIndexesOfCurrentIndex:index fccList:fccList childSet:deletedIndexes isContainSelf:YES];
    NSDictionary* delFirstDic = [fccList objectAtIndex:index];
    NSMutableDictionary* parentDic = (NSMutableDictionary*)[WorkUtil getParent:delFirstDic fccList:fccList];
    
    // 리스트에서 삭제한다.
    [fccList removeObjectsAtIndexes:deletedIndexes];
    
    // 삭제한 후에 parent의 CHILD설정을 다시 해주어야 한다.
    NSDictionary* childDic = [WorkUtil getChild:[parentDic objectForKey:@"EQUNR"] InFccList:fccList];
    if (childDic){
        [parentDic setObject:[childDic objectForKey:@"EQUNR"] forKey:@"CHILD"];
        [parentDic setObject:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
    }else{
        [parentDic setObject:@"" forKey:@"CHILD"];
        [parentDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
    }
}

// source를 target밑으로 이동한다.  이 때 source하위(child)에 있는 모든 설비가 함께 이동한다.
+ (void)moveSource:(NSString*)source toTarget:(NSString*)target fccList:(NSMutableArray*)fccList
{
    int srcIndex = [WorkUtil getBarcodeIndex:source fccList:fccList];
    if (srcIndex == -1)
        return;
    
    // 이동한 후에 기존의 Parent의 상하관계를 다시 설정해주기 위해 이동전에 Parent를 얻어놓는다
    NSDictionary* sourceDic = [fccList objectAtIndex:srcIndex];
    NSString* parentOfObjBarcode = [sourceDic objectForKey:@"HEQUNR"];
    NSMutableDictionary* parentOfObjDic = nil;
    if (parentOfObjBarcode.length){
        parentOfObjDic = [fccList objectAtIndex:[WorkUtil getBarcodeIndex:parentOfObjBarcode fccList:fccList]];
    }
    
    // 실제로 source를 target 하위로 이동한다.
    [WorkUtil moveObjectBarcode:source belowTargetBarcode:target inFccList:fccList isUserDeviceId:NO];
    
    if (parentOfObjDic != nil){
        // 이동전의 parent 의 상하관계 설정
        int childOfParentIndex = [WorkUtil getChildBarcodeIndex:parentOfObjBarcode fccList:fccList];
        if (childOfParentIndex != -1){
            NSDictionary* childOfParentDic = [fccList objectAtIndex:childOfParentIndex];
            NSString* childOfParentBarcode = [childOfParentDic objectForKey:@"EQUNR"];
            
            // 이동 후에도 child가 존재하면 parent의 CHILD값을 변경해주고, exposeStatus도 변경
            // 없다면 CHILD를 ""로 exposeStatus도 변경
            [parentOfObjDic setObject:childOfParentBarcode forKey:@"CHILD"];
            [parentOfObjDic setObject:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
        }
        else {
            [parentOfObjDic setObject:@"" forKey:@"CHILD"];
            [parentOfObjDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        }
    }
}


+ (void)moveObjectBarcode:(NSString*)objBarcode belowTargetBarcode:(NSString*)tarBarcode inFccList:(NSMutableArray*)fccList isUserDeviceId:(BOOL)isUseDeviceId
{
    int objIndex = [WorkUtil getBarcodeIndex:objBarcode fccList:fccList];
    int tarIndex = [WorkUtil getBarcodeIndex:tarBarcode fccList:fccList];
    
    if (objIndex == -1 || tarIndex == -1)
        return;
    
    NSDictionary* objectDic = [fccList objectAtIndex:objIndex];
    NSDictionary* targetDic = [fccList objectAtIndex:tarIndex];

    
    [WorkUtil moveObject:objectDic BelowTarget:targetDic InFccList:fccList isUseDeviceId:isUseDeviceId];
}


+ (void)moveObject:(NSDictionary*)object BelowTarget:(NSDictionary*)target InFccList:(NSMutableArray*)fccList isUseDeviceId:(BOOL)isUseDeviceId
{

    NSMutableIndexSet* movedIndexSet = [NSMutableIndexSet indexSet];
    NSMutableIndexSet* childIndexSet = [NSMutableIndexSet indexSet];
    [WorkUtil getChildIndexesOfCurrentIndex:[fccList indexOfObject:object] fccList:fccList childSet:movedIndexSet isContainSelf:YES];
    [WorkUtil getChildIndexesOfCurrentIndex:[fccList indexOfObject:target] fccList:fccList childSet:childIndexSet isContainSelf:NO];
    
    NSDictionary* parentOfObject = [WorkUtil getParent:object fccList:fccList];
    
    if (parentOfObject != nil){
        NSDictionary* lastNode = [WorkUtil getLastNodeByItem:parentOfObject InFccList:fccList];
        int index = (int)[fccList indexOfObject:lastNode];
        if ((int)[childIndexSet count] == 1){
            [parentOfObject setValue:@"" forKey:@"CHILD"];
            [parentOfObject setValue:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        }else{
            // parent(target)의 CHILD가 object로 설정되어 있는 경우
            if ([[parentOfObject objectForKey:@"CHILD"] isEqualToString:[[fccList objectAtIndex:index] objectForKey:@"EQUNR"]]){
               int newIndex = (int)[fccList indexOfObject:object] + (int)[movedIndexSet count];
                NSDictionary* newChildDic = nil;
                if (newIndex < (int)[fccList count])
                    newChildDic = [fccList objectAtIndex:newIndex];
                // 다음에 있는 항목의 parent가 target의 자식이 맞다면 CHILD설정을 해준다.  아니라면 CHILD를 ""로 설정한다.
                if (newChildDic != nil && [[newChildDic objectForKey:@"HEQUNR"] isEqualToString:[parentOfObject objectForKey:@"EQUNR"]]){
                    NSLog(@"newChildDic [%@]", newChildDic);
                    [parentOfObject setValue:[newChildDic objectForKey:@"EQUNR"] forKey:@"CHILD"];
                }else {
                    [parentOfObject setValue:@"" forKey:@"CHILD"];
                    [parentOfObject setValue:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
                }
            }
        }
    }
    
    BOOL isModifyTarget = NO;
    // target은 mutableCopy를 통해 받은 것이므로 리스트에 있는 dic의 주소를 갖고 있지 않다.
    // 그래서 parent와 target이 같은 경우(같은 상위항목의 하위로 이동할 경우)
    // target을 대치해 주어야 한다.
    if ([[target objectForKey:@"EQUNR"] isEqualToString:[parentOfObject objectForKey:@"EQUNR"]])
        target = parentOfObject;


    if(target == [WorkUtil getLastNodeByItem:target InFccList:fccList])
        isModifyTarget = YES;

    [WorkUtil moveIndexSet:movedIndexSet BelowTarget:target InList:fccList isUseDeviceId:isUseDeviceId];
    
    if (isModifyTarget){
        int index = [WorkUtil getBarcodeIndex:[target objectForKey:@"EQUNR"] fccList:fccList];
        NSMutableDictionary* newDic = [target mutableCopy];
        [newDic setValue:[object objectForKey:@"EQUNR"] forKey:@"CHILD"];
        [newDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
        [fccList replaceObjectAtIndex:index withObject:newDic];
    }
}

// index하위의 노드들의 NSIndexSet을 리턴한다.
// isContainSelf == YES - 자신을 index set에 포함시킨다. else if NO - 자신을 index set에 포함시키지 않는다.
// recursive method로 하위의 하위의 하위.....  이런 식으로 계속 찾는다.
+ (void) getChildIndexesOfCurrentIndex:(NSInteger)index fccList:(NSArray*)fccList childSet:(NSMutableIndexSet*)childSet isContainSelf:(BOOL)isContainSelf
{
    // 자신을 포함한다면(isContainSelf == YES) indexSet에 추가한다.
    if (isContainSelf)
        [childSet addIndex:index];
    
    NSDictionary* selectedNode = [fccList objectAtIndex:index];
    NSString* pBarcode = [selectedNode objectForKey:@"EQUNR"];
    
    for (int i = (int)index + 1; i < (int)[fccList count]; i++){
        NSDictionary* dic = [fccList objectAtIndex:i];
        NSString* cBarcode = [dic objectForKey:@"HEQUNR"];
        
        if ([pBarcode isEqualToString:cBarcode])
            [WorkUtil getChildIndexesOfCurrentIndex:i fccList:fccList childSet:childSet isContainSelf:YES];
    }
}

+ (void) getChildOrgesOfCurrentIndex:(NSInteger)index orgList:(NSArray*)orgList childSet:(NSMutableIndexSet*)childSet isContainSelf:(BOOL)isContainSelf
{
    if (isContainSelf)
        [childSet addIndex:index];
    
    NSDictionary* selectedNode = [orgList objectAtIndex:index];
    NSString* pBarcode = [selectedNode objectForKey:@"orgCode"];
    
    for (int i = (int)index + 1; i < (int)[orgList count]; i++){
        NSDictionary* dic = [orgList objectAtIndex:i];
        NSString* cBarcode = [dic objectForKey:@"parentOrgCode"];
        
        if ([pBarcode isEqualToString:cBarcode])
            [WorkUtil getChildOrgesOfCurrentIndex:i orgList:orgList childSet:childSet isContainSelf:YES];
    }
}

// movedIndexSet에 있는 item들을 targetItem하위로 이동시킨다.
// isUseDeviceId - 인계, 인수, 시설등록에서는 deviceId가 상위 바코드의 키역할을 하기때문에 필요하다.
+ (void) moveIndexSet:(NSIndexSet*)movedIndexSet BelowTarget:(NSDictionary*)targetItem InList:(NSMutableArray*)fccList isUseDeviceId:(BOOL)isUseDeviceId
{
    NSMutableArray* movedArray = [NSMutableArray array];
    NSMutableIndexSet* copyIndexSet = [movedIndexSet mutableCopy];
    
    NSString* targetBarcode = [targetItem objectForKey:@"EQUNR"];
    NSString* ancestor = [targetItem objectForKey:@"ANCESTOR"];
    NSString* deviceId = @"";

    if (isUseDeviceId)
        deviceId = [targetItem objectForKey:@"deviceId"];
    int level = [[targetItem objectForKey:@"LEVEL"] intValue];
    
    
    // indexSet을 이용하여 이동하려고 하는 item들의 리스트를 구성함
    while([copyIndexSet count] > 0){
        NSInteger index = [copyIndexSet firstIndex];
        NSString* strLevel = [NSString stringWithFormat:@"%d", ++level];
        NSDictionary* objectDic = [fccList objectAtIndex:index];
        NSMutableDictionary* dic = [objectDic mutableCopy];
        
        // 우선 수정한 Key값들을 삭제한다
        if ([copyIndexSet count] == [movedIndexSet count]){ // 이동하는 노드들의 최상위 노드인 경우 부모 노드명을 변경해준다.
            [dic setValue:targetBarcode forKey:@"HEQUNR"];
        }
        if (isUseDeviceId)
            [dic removeObjectForKey:@"deviceId"];
        
        [dic setValue:strLevel forKey:@"LEVEL"];
        [dic setValue:ancestor forKey:@"ANCESTOR"];
        if (isUseDeviceId)
            [dic setObject:deviceId forKey:@"deviceId"];

        [movedArray addObject:dic];
        [copyIndexSet removeIndex:index];
    }
    [fccList removeObjectsAtIndexes:movedIndexSet];
    
    // 옮기고자 하는 targetItem 하위에 있는 리스트를 조회하여 가장 아래쪽에 추가하도록 함
    NSDictionary* lastNode = [WorkUtil getLastNodeByItem:targetItem InFccList:fccList];
    NSInteger parentIndex = [fccList indexOfObject:lastNode];

    
    for(NSDictionary* dic in movedArray){
        parentIndex++;
        [fccList insertObject:dic atIndex:parentIndex];
    }
}

// 해당 아이템에 하위 리스트 중 가장 마지막 아이템을 리턴한다.
// 가장 아래쪽으로 추가하기 위해 사용된다.
// recursive method임.
+ (NSDictionary*) getLastNodeByItem:(NSDictionary*)item InFccList:(NSArray*)fccList
{
    NSString* barcode = [item objectForKey:@"EQUNR"];
    NSIndexSet* indexset = [WorkUtil getChildBarcodeIndexes:barcode fccList:fccList];
    NSDictionary* lastTop;
    if (indexset.count){
        lastTop = [fccList objectAtIndex:[indexset lastIndex]];
    }else
        return item;
    
    NSString* childBarcode = [lastTop objectForKey:@"CHILD"];
    
    if (childBarcode.length){
        return [WorkUtil getLastNodeByItem:lastTop InFccList:fccList];
    }else{
        NSDictionary* parentDic = lastTop;

        while(YES){
            NSDictionary* childDic = nil;
            if (childBarcode.length)
                childDic = [WorkUtil getItemFromFccList:childBarcode fccList:fccList];
            if (childDic != nil){
                parentDic = childDic;
                childBarcode = [childDic objectForKey:@"CHILD"];
            }else
                return parentDic;
        }
    }
    
    return nil;
}

// 해당바코드의 바로 아래에 있는 child item을 리턴한다.
+ (NSDictionary*)getChild:(NSString*)barcode InFccList:(NSArray*)fccList
{
    for(NSDictionary* dic in fccList){
        if ([[dic objectForKey:@"HEQUNR"] isEqualToString:barcode])
            return dic;
    }
    
    return nil;
}

// 해당 childDic의  parentDic을 리턴한다.
+ (NSDictionary*)getParent:(NSDictionary*)childDic fccList:(NSArray*)fccList
{
    for(NSDictionary* dic in fccList){
        if ([[childDic objectForKey:@"HEQUNR"] isEqualToString:[dic objectForKey:@"EQUNR"]])
            return dic;
    }
    
    return nil;
}

// 이동가능 여부를 체크하여 오류 메세지를 리턴한다.
// ""을 리턴하면 성공, 그 외의 스트링을 리턴하면 실패임
+ (NSString*)nodeValidateSourceType:(NSString*)sourceType TargetType:(NSString*)targetType isCheckSu:(BOOL)isChkSu
{
    NSString* message = @"";
    if([targetType isEqualToString:@"L"]){
        message = [NSString stringWithFormat:@"'%@' 바코드의 하위에\n '%@' 바코드를 \n이동하실 수 없습니다.",
                   [WorkUtil getPartTypeFullNameForShortName:targetType],
                   [WorkUtil getPartTypeFullNameForShortName:sourceType]];
    }else if ([targetType isEqualToString:@"D"]){
        if([sourceType isEqualToString:@"L"] || [sourceType isEqualToString:@"D"] ||
           [sourceType isEqualToString:@"U"]){
            message = [NSString stringWithFormat:@"'%@' 바코드의 하위에\n '%@' 바코드를 \n이동하실 수 없습니다.",
                       [WorkUtil getPartTypeFullNameForShortName:targetType],
                       [WorkUtil getPartTypeFullNameForShortName:sourceType]];
        }
    }else if ([targetType isEqualToString:@"R"]){
        if ([sourceType isEqualToString:@"L"] || [sourceType isEqualToString:@"D"] ||
            [sourceType isEqualToString:@"R"] || [sourceType isEqualToString:@"E"]){
            message = [NSString stringWithFormat:@"'%@' 바코드의 하위에\n '%@' 바코드를 \n이동하실 수 없습니다.",
                       [WorkUtil getPartTypeFullNameForShortName:targetType],
                       [WorkUtil getPartTypeFullNameForShortName:sourceType]];
        }
    }else if ([targetType isEqualToString:@"S"]){
        if ([sourceType isEqualToString:@"L"] || [sourceType isEqualToString:@"D"] ||
            [sourceType isEqualToString:@"R"] || [sourceType isEqualToString:@"S"] ||
            [sourceType isEqualToString:@"E"]){
            message = [NSString stringWithFormat:@"'%@' 바코드의 하위에\n '%@' 바코드를 \n이동하실 수 없습니다.",
                       [WorkUtil getPartTypeFullNameForShortName:targetType],
                       [WorkUtil getPartTypeFullNameForShortName:sourceType]];
        }
    }else if ([targetType isEqualToString:@"U"]){
        if ([sourceType isEqualToString:@"L"] || [sourceType isEqualToString:@"D"] ||
            [sourceType isEqualToString:@"R"] || [sourceType isEqualToString:@"S"] ||
            [sourceType isEqualToString:@"E"] || (!isChkSu && [sourceType isEqualToString:@"U"])){
            message = [NSString stringWithFormat:@"'%@' 바코드의 하위에 '%@' 바코드를 \n이동하실 수 없습니다.",
                       [WorkUtil getPartTypeFullNameForShortName:targetType],
                       [WorkUtil getPartTypeFullNameForShortName:sourceType]];
        }
    }else if ([targetType isEqualToString:@"E"]){
        if ([sourceType isEqualToString:@"L"] || [sourceType isEqualToString:@"D"] ||
            [sourceType isEqualToString:@"R"] || [sourceType isEqualToString:@"S"] ||
            [sourceType isEqualToString:@"E"]){ // R-E-U, E-E, S-E 허용
            message = [NSString stringWithFormat:@"'%@' 바코드의 하위에 '%@' 바코드를 \n이동하실 수 없습니다.",
                       [WorkUtil getPartTypeFullNameForShortName:targetType],
                       [WorkUtil getPartTypeFullNameForShortName:sourceType]];
        }
    }
    
    return message;
}

// parent(HEQUNR)의 바코드를 modifiedBarcode로 변경한다.
+ (void)updateParent:(NSString*)parentBarcode withModifyParent:(NSString*)modifiedBarcode fccList:(NSMutableArray*)fccList
{
    for (NSInteger index = 0; index < (int)fccList.count; index++){
        NSDictionary* dic = [fccList objectAtIndex:index];
    
        if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"] ||
            [[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"])
            continue;
        
        if([[dic objectForKey:@"HEQUNR"] isEqualToString:parentBarcode]){
            NSMutableDictionary* newDic = [dic mutableCopy];
            [newDic setObject:modifiedBarcode forKey:@"HEQUNR"];
            [fccList replaceObjectAtIndex:index withObject:newDic];
        }
    }
}

// tree view의 상하 구조를 만들어 insert 하는 method
// sapDic - insert하고자 하는 정보
// selRow - 현재 선택된 index (이 인덱스를 기준으로 서치한다.)
// isMakeHierachy - 상하 구조를 만들지 않고, 병렬 처리 여부를 결정
// isCheckUU - UU 버튼이 선택되었다면  U가 U의 parent가 될 수 있음을 의미한다.
// isRemake - 구조를 다시 만들것인지 서버로부터 받은 상하 구조를 그대로 이용할 것인지 여부
// job - 현재 작업
+ (NSString*)makeHierarchyOfAddedData:(NSMutableDictionary*)sapDic selRow:(NSInteger*) selRow isMakeHierachy:(BOOL) isMakeHierachy isCheckUU:(BOOL) isCheckUU isRemake:(BOOL)isRemake fccList:(NSMutableArray*)fccList job:(NSString*)job
{
    NSString* errMsg = @"";
    NSString* partTypeName = [sapDic objectForKey:@"PART_NAME"];
    NSDictionary* selItemDic;
    NSString* selpartTypeName;
    BOOL isHaveLoc = NO;    // 인계, 인수, 시설등록인 경우 위치바코드가 최상위로 잡히기 때문에 예외처리가 필요하다.
    
    if (fccList.count){
        if (*selRow >= 0)
        {
            selItemDic = [fccList objectAtIndex:*selRow];
            selpartTypeName = [selItemDic objectForKey:@"PART_NAME"];
        }
    }
    
    // 인계, 인수, 시설등록은 위치를 Root로 하는 구조로, 다른 경우와 다르므로...
    if ([job isEqualToString:@"인계"] ||
          [job isEqualToString:@"인수"] ||
          [job isEqualToString:@"시설등록"])
        isHaveLoc = YES;
    
    if (isHaveLoc && fccList.count){
        if ([[selItemDic objectForKey:@"PART_NAME"] isEqualToString:@"D"] &&
            [[sapDic objectForKey:@"PART_NAME"] isEqualToString:@"U"])
        {
            errMsg = @"장치바코드의 하위에\nUnit 설비바코드를\n스캔하실 수\n없습니다.";
            return errMsg;
        }
    }
    
    BOOL compBelow = YES;
    
    int upperIndex = -1;
    if ([job isEqualToString:@"현장점검(창고/실)"] || [job isEqualToString:@"현장점검(베이)"]){
        upperIndex = [WorkUtil getBarcodeIndex:[sapDic objectForKey:@"HEQUNR"] fccList:fccList];
    }
    else if (!isRemake){
        upperIndex = [WorkUtil getBarcodeIndex:[sapDic objectForKey:@"HEQUNR"] fccList:fccList];
    }
    else{
        int limitIndex = 0;
        if (fccList.count &&  *selRow >= 0){
            NSDictionary* selDic = [fccList objectAtIndex:*selRow];
            limitIndex = [WorkUtil getBarcodeIndex:[selDic objectForKey:@"ANCESTOR"] fccList:fccList];
            if (limitIndex == -1)
                limitIndex = 0;
        }

        if (selpartTypeName.length && [selpartTypeName isEqualToString:@"U"]){
            upperIndex = [WorkUtil getUpperIndex:partTypeName selectedIndex:(int)*selRow limitIndex:limitIndex fccList:fccList isCheckUU:isCheckUU compareLevel:compBelow];
        }
        else {
            upperIndex = [WorkUtil getUpperIndex:partTypeName selectedIndex:(int)*selRow limitIndex:limitIndex fccList:fccList isCheckUU:NO compareLevel:compBelow];
        }
    }
    
    if (isMakeHierachy && ![job isEqualToString:@"임대단말실사"] && upperIndex != -1){ //하위트리로 추가
        NSMutableDictionary* upperDic = [fccList objectAtIndex:upperIndex];
        NSString* upperBarcode = [upperDic objectForKey:@"HEQUNR"];
        NSString* ancestorBarcode = [upperDic objectForKey:@"ANCESTOR"];
        NSInteger lastNode;
        
        // 하위 목록의 가장 끝 부분에 추가하기 위해 마지막 노드를 서치해둔다.
        NSDictionary* lastDic = [WorkUtil getLastNodeByItem:[fccList objectAtIndex:upperIndex] InFccList:fccList];
        lastNode = [fccList indexOfObject:lastDic];
        
        
        //자식 트리를 가지는 걸로 부모트리 업데이트
        [upperDic setObject:[sapDic objectForKey:@"EQUNR"] forKey:@"CHILD"]; //트리에서 자식 바코드
        int upperLevel = [[upperDic objectForKey:@"LEVEL"] intValue];
        
        [sapDic setObject:[NSString stringWithFormat:@"%d",upperLevel+1] forKey:@"LEVEL"];
        [sapDic setObject:[upperDic objectForKey:@"EQUNR"] forKey:@"HEQUNR"]; //상위바코드 설정
        if(isHaveLoc){
            NSString* barcode = [sapDic objectForKey:@"EQUNR"];
            
            if ([partTypeName isEqualToString:@"D"])
                [sapDic setObject:barcode forKey:@"ANCESTOR"];
            else
                [sapDic setObject:ancestorBarcode forKey:@"ANCESTOR"];
            
        }else{
            if (upperLevel == 1) //최상위 level = 1
                [sapDic setObject:[upperDic objectForKey:@"EQUNR"] forKey:@"ANCESTOR"]; //조상바코드 설정
            
            else if ([upperBarcode isEqualToString:ancestorBarcode]
                     )
                [sapDic setObject:upperBarcode forKey:@"ANCESTOR"];
            else
                [sapDic setObject:ancestorBarcode forKey:@"ANCESTOR"];
        }
        
        [upperDic setObject:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
        [sapDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        [sapDic setObject:@"" forKey:@"CHILD"]; //트리에서 자식 바코드
        
        if ([partTypeName isEqualToString:@"D"] || [partTypeName isEqualToString:@"L"]){
            [fccList addObject:sapDic];
            *selRow = fccList.count - 1;
        }else{
            [fccList insertObject:sapDic atIndex:lastNode+1];
            *selRow = lastNode+1;
        }

    }
    else{ //루트로 추가
        if (isHaveLoc && [partTypeName isEqualToString:@"U"]){
            errMsg = @"Unit은 Rack 또는 Shelf 하위에\n 스캔하세요.";
            return errMsg;
        }
        [sapDic setObject:@"1" forKey:@"LEVEL"];
        [sapDic setObject:@"" forKey:@"HEQUNR"]; //상위바코드 설정
        [sapDic setObject:[sapDic objectForKey:@"EQUNR"] forKey:@"ANCESTOR"]; //조상바코드 설정
        [sapDic setObject:[NSNumber numberWithInteger:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        [sapDic setObject:@"" forKey:@"CHILD"]; //트리에서 자식 가지고 있는지 여부
        [fccList addObject:sapDic];
        *selRow = fccList.count - 1;
    }
    
    return errMsg;
}

+ (void)modifySelectedInfo:(NSDictionary*)oldDic newInfo:(NSDictionary*)newDic fccList:(NSMutableArray*)fccList
{
    NSString* parentBarcode = [oldDic objectForKey:@"HEQUNR"];
    int pIndex = [WorkUtil getBarcodeIndex:parentBarcode fccList:fccList];
    
    // 기존 oldDic의 CHILD를 변경해주기 위함
    NSMutableDictionary* parentDic = [[fccList objectAtIndex:pIndex] mutableCopy];
    if ([[parentDic objectForKey:@"CHILD"] isEqualToString:[oldDic objectForKey:@"EQUNR"]]){
        [parentDic setObject:[newDic objectForKey:@"EQUNR"] forKey:@"CHILD"];
        [fccList replaceObjectAtIndex:pIndex withObject:parentDic];
    }
    
    [WorkUtil updateParent:[oldDic objectForKey:@"EQUNR"] withModifyParent:[newDic objectForKey:@"EQUNR"] fccList:fccList];
    
    int index = [WorkUtil getBarcodeIndex:[oldDic objectForKey:@"EQUNR"] fccList:fccList];
    [fccList replaceObjectAtIndex:index withObject:newDic];
}

+ (NSIndexSet*)getRootFacs:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HEQUNR == ''"];
    NSIndexSet* indexSet = [fccList  indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        return [predicate evaluateWithObject:obj];
        
    }];
    return indexSet;
}

+ (NSArray*)getBarcodeInfoInPDA:(NSString*)barcode errorMessage:(NSString*)errMsg
{
    NSString* MATNR = @"";
    NSString* bismt = @"";
    
    NSMutableDictionary* material = [WorkUtil getMaterial:barcode];

    MATNR = [material objectForKey:@"matnr"];
    bismt = [material objectForKey:@"bismt"];
    
    NSArray* goodsList = [[DBManager sharedInstance] getGoodsSearchByMATNR:MATNR MAKTX:@"" BISMT:bismt PDA_FLAG:YES ERROR_MSG:errMsg];
    

    if (goodsList == nil || goodsList.count == 0)   return nil;
    
    NSDictionary* dic = [goodsList objectAtIndex:0];
    NSString* partType = [dic objectForKey:@"COMPTYPE"];
    NSString* devType = [dic objectForKey:@"ZMATGB"];
    NSString* mtart = [dic objectForKey:@"MTART"];
    NSString* barcd = [dic objectForKey:@"BARCD"];
    
    if ([devType isEqualToString:@"40"] && [partType isEqualToString:@"40"]){
        errMsg = @"부품종류가 존재하지 않습니다.\n 기준 정보 관리자(MDM)에게\n문의하세요.";
        return nil;
    }
    
    if (![mtart isEqualToString:@"ERSA"] || ![barcd isEqualToString:@"Y"]){
        errMsg = @"처리할 수 없는 바코드입니다.\n(SAP 상의 자재유형이 'ERSA'가 아니거나 바코드라벨링이 'Y'가 아님)";
        return nil;
    }
    
    return goodsList;
}

+ (NSString*)getFullNameOfLoc:(NSString*)address
{
    NSString* locFullName = address;
    
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"[토지]" withString:@""];
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"[일반]" withString:@""];
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"[건물]" withString:@""];
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"[비건물]" withString:@""];
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"[나대지]" withString:@""];
    locFullName = [locFullName stringByReplacingOccurrencesOfString:@"상가주택" withString:@""];
    
    NSArray* addList = [locFullName componentsSeparatedByString:@" "];
    if (addList.count > 3){
        locFullName = [NSString stringWithFormat:@"%@ %@ %@ %@", addList[0], addList[1], addList[2], addList[3]];
    }
    else if (addList.count > 2){
        locFullName = [NSString stringWithFormat:@"%@ %@ %@", addList[0], addList[1], addList[2]];
    }
    
    return locFullName;
}

+ (NSString*)messageChkValidateFccItem:(NSString*)fccBarcode
{
    NSDictionary* dic = [WorkUtil getMaterial:fccBarcode];
    
    NSString* bismt = [dic objectForKey:@"bismt"];
    NSString* matnr = [dic objectForKey:@"matnr"];
    
    NSString* errMessage = @"";
    if (bismt.length == 0 &&  matnr.length == 0)
    {
        if (fccBarcode.length)
            errMessage = [NSString stringWithFormat:@"%@는 처리할수 없는 바코드입니다.",fccBarcode];
        else
            errMessage = [NSString stringWithFormat:@"처리할수 없는 바코드입니다."];
        
        return errMessage;
    }
    
    return errMessage;
}

@end

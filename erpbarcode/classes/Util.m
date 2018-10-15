//
//  Util.m
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Util.h"

@implementation Util
/**
 HTTP request에 PPM HTTP 헤더를 추가한다.
 @param req http request object
 @returns
 @exception
 */

// 유저 디폴트에 저장한다.
+ (void)udSetObject:(id)object forKey:(NSString *)key  {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:object forKey:key];
    [ud synchronize];
}

+ (void)udSetBool:(BOOL)boolValue forKey:(NSString *)key {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:boolValue forKey:key];
    [ud synchronize];
}

// 유저 디폴트에 아카이브로 저장한다.
+ (void)udArchiveSetObject:(id)object forKey:(NSString *)key  {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
    [ud synchronize];
}

+ (void)udRemoveObject:(NSString *)key  {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}


// 유저 디폴트에서 로드한다.
+ (id)udObjectForKey:(NSString *)key {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id returnValue = [ud objectForKey:key];
    
    return returnValue;
}

+ (BOOL)udBoolForKey:(NSString *)key {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL returnValue = [ud boolForKey:key];
    
    return returnValue;
}

// 유저 디폴트에서 아카이브 객체를 로드한다.
+ (id)udArchiveObjectForKey:(NSString *)key {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id returnValue = [ud objectForKey:key];
    NSData* data = [NSKeyedUnarchiver unarchiveObjectWithData:returnValue];
    
    
    return data;
}

+ (int)mainVersionNumber{
    return [[[UIDevice currentDevice] systemVersion] intValue];
}

+ (float)deltaY:(float)original{
    if ([self mainVersionNumber] <= 6) return original;
    else return original+20.0;
}

//http body assembly

+ (id) defaultMessage:(NSDictionary*)headerDic body:(NSDictionary*)bodyDic
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:headerDic forKey:@"header"];
    [dic setObject:bodyDic forKey:@"body"];
    [dic setObject:@"IOS" forKey:@"call"];
    [dic setObject:@"1" forKey:@"jobSeq"];
    [dic setObject:@"" forKey:@"operatorId"];
    [dic setObject:@"" forKey:@"runProgramId"];
    [dic setObject:[NSMutableDictionary dictionary] forKey:@"sysRegisterDate"];
    [dic setObject:[NSMutableDictionary dictionary] forKey:@"sysUpdateDate"];
    NSMutableDictionary* rootDic = [NSMutableDictionary dictionary];
    
    //finally http body
    [rootDic setObject:dic forKey:@"message"];
    return rootDic;
        
}

+ (id) defaultLoginHeader:(NSString*)telNo
{

    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"" forKey:@"userId"];
    [dic setObject:@"" forKey:@"userPasswd"];
    [dic setObject:@"" forKey:@"userName"];
    [dic setObject:telNo forKey:@"telNo"];
    [dic setObject:@"" forKey:@"userCellPhoneNo"];
    [dic setObject:@"" forKey:@"orgId"];
    [dic setObject:@"" forKey:@"orgName"];
    [dic setObject:@"" forKey:@"orgTypeCode"];
    [dic setObject:@"" forKey:@"currentPageNo"];
    [dic setObject:@"" forKey:@"currentPageCount"];
    [dic setObject:@"N" forKey:@"pageUseYN"];
    [dic setObject:@"" forKey:@"sessionId"];
    [dic setObject:@"" forKey:@"orgCode"];
    return dic;
}


+ (id) defaultHeader
{
    NSDictionary* userDic = [Util udObjectForKey:USER_INFO];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([userDic count]){
        [dic setObject:[userDic objectForKey:@"userCellPhoneNo"] forKey:@"telNo"];
        [dic setObject:[userDic objectForKey:@"userCellPhoneNo"] forKey:@"userCellPhoneNo"];
        [dic setObject:[userDic objectForKey:@"orgId"] forKey:@"orgId"];
        [dic setObject:[userDic objectForKey:@"sessionId"] forKey:@"sessionId"];
        [dic setObject:[userDic objectForKey:@"orgTypeCode"] forKey:@"orgTypeCode"];
        [dic setObject:[userDic objectForKey:@"orgCode"] forKey:@"orgCode"];
        if ([Util udObjectForKey:READ_BUFFER])
            [dic setObject:[Util udObjectForKey:READ_BUFFER] forKey:@"job_equnr"];
        else
            [dic setObject:@"" forKey:@"job_equnr"];
        [dic setObject:@""  forKey:@"userPasswd"];
        [dic setObject:[userDic objectForKey:@"userId"] forKey:@"userId"];
        [dic setObject:[userDic objectForKey:@"userName"] forKey:@"userName"];
        [dic setObject:[userDic objectForKey:@"orgName"] forKey:@"orgName"];
        
        // DR-2014-37505 접수,송부취소 1000건만 불러오기....
        NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
        if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] || [JOB_GUBUN isEqualToString:@"접수(팀간)"]) {
            [dic setObject:@"Y" forKey:@"pageUseYN"];
            [dic setObject:@"1" forKey:@"currentPageNo"];
            [dic setObject:@"1000"  forKey:@"currentPageCount"];        // 최대 1000개만 불러오게....
        } else {
            [dic setObject:@"N" forKey:@"pageUseYN"];
            [dic setObject:@"" forKey:@"currentPageNo"];
            [dic setObject:@""  forKey:@"currentPageCount"];
        }
        return dic;

    }
    else{
        [dic setObject:@"" forKey:@"telNo"];
        [dic setObject:@"" forKey:@"userCellPhoneNo"];
        [dic setObject:@"" forKey:@"orgId"];
        [dic setObject:@"" forKey:@"sessionId"];
        [dic setObject:@"" forKey:@"orgTypeCode"];
        [dic setObject:@"" forKey:@"orgCode"];
        [dic setObject:@"" forKey:@"job_equnr"];
        [dic setObject:@""  forKey:@"userPasswd"];
        [dic setObject:@"" forKey:@"userId"];
        [dic setObject:@"" forKey:@"userName"];
        [dic setObject:@"" forKey:@"orgName"];
        
        [dic setObject:@"N" forKey:@"pageUseYN"];
        [dic setObject:@"" forKey:@"currentPageNo"];
        [dic setObject:@""  forKey:@"currentPageCount"];
        return dic;
    }

}

+ (id) noneMessageBody:(NSDictionary*)paramDic
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:paramDic forKey:@"param"];//dictionary
    [dic setObject:[NSMutableArray array] forKey:@"paramList"];//array
    [dic setObject:[NSMutableArray array] forKey:@"subParamList"];//array
    return dic;
}

+ (id) singleMessageBody:(NSDictionary*)paramDic
{
    
    NSMutableArray *paramListArray = [NSMutableArray array];
    [paramListArray addObject:paramDic];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSMutableDictionary dictionary] forKey:@"param"];//dictionary
    [dic setObject:paramListArray forKey:@"paramList"];//array
    [dic setObject:[NSMutableArray array] forKey:@"subParamList"];//array
    return dic;

}

+ (id) singleListMessageBody:(NSArray *)paramDicList
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSMutableDictionary dictionary] forKey:@"param"];//dictionary
    [dic setObject:paramDicList forKey:@"paramList"];//array
    [dic setObject:[NSMutableArray array] forKey:@"subParamList"];//array
    
    return dic;
}


+ (id) doubleMessageBody:(NSDictionary*)paramDic subParam:(NSArray*)subParamList
{
    
    NSMutableArray *paramListArray = [NSMutableArray array];
    if ([paramDic count])
        [paramListArray addObject:paramDic];
    
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSMutableDictionary dictionary] forKey:@"param"];//dictionary
    [dic setObject:paramListArray forKey:@"paramList"];//array
    [dic setObject:subParamList forKey:@"subParamList"];//array
    return dic;
}

+ (id) makeLeftNaviButton:(NSString*)fileName
{
    //왼쪽 버튼 구성
    UIImage* imgBar;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        imgBar = [[UIImage imageNamed:@"navigation_back"]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else{
        imgBar = [UIImage imageNamed:@"navigation_back"];
    }

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:imgBar forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.frame = CGRectMake(10,7,30,30);
    return leftBtn;


}

+ (id) makeRightNaviButton:(NSString*)fileName
{
    UIImage *rightimage = [UIImage imageNamed:fileName];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:rightimage forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    rightBtn.frame = CGRectMake(267,7,44,29);
    return rightBtn;
}

+ (void)playSoundWithMessage:(NSString*)message isError:(BOOL)isError
{
    if([message rangeOfString:@"중복 스캔"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_DUPLICATION fileFormat:EXT_WAVE];
    else if (isError)
        [Util playSoundWithFileName:SOUND_ALERT fileFormat:EXT_WAVE];
    else if([message rangeOfString:@"6개월"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_CERT_SUCC fileFormat:EXT_WAVE];
    else if ([message rangeOfString:@"스캔하지 않은 하위 설비"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_SCANBELOW fileFormat:EXT_WAVE];
    else if ([message rangeOfString:@"전송하시겠습니까"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_SEND_QUESTION fileFormat:EXT_WAVE];
    else if ([message rangeOfString:@"스캔이 원칙"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_SCAN fileFormat:EXT_WAVE];
    else if ([message rangeOfString:@"존재하지 않는 설비"].location != NSNotFound)
        [Util playSoundWithFileName:SOUND_NOT_EXIST fileFormat:EXT_WAVE];
    else
        [Util playSoundWithFileName:SOUND_ASTERISK fileFormat:EXT_WAVE];
}


+ (void)playSoundWithFileName:(NSString*)fileName fileFormat:(NSString*)fileFormat
{
    if (![[Util udObjectForKey:SOUND_ON_OFF] boolValue])
        return;
    
    NSURL* fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileFormat];
    
    if (fileURL != nil){
        SystemSoundID theSoundId;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundId);
        
        if(error == kAudioServicesNoError)
            AudioServicesPlaySystemSound(theSoundId);
    }
}

+ (void)setScrollTouch:(scrollTouch*)sv Label:(UILabel*)label withString:(NSString*)string
{
    label.text = string;
    CGFloat Length = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(9999, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
    
    sv.contentSize = CGSizeMake(Length + 20, sv.frame.size.height);
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, Length, label.frame.size.height);
}

// 환경 설정 관련 사항을 저장하는 plist포맷의 화일을 읽고, 쓰는
+ (NSString*)loadSetupInfoFromPlist:(NSString*)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setupInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"setupInfo" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
        [Util writeSetupInfoToPlist:@"SOUND" value:@"1"];
        [Util writeSetupInfoToPlist:@"SOFT_KEYBOARD" value:@"1"];
    }
    
    // plist 읽어옴.
    NSString* info = @"";
    NSDictionary* infoDic = [NSDictionary dictionaryWithContentsOfFile:path];
    info = [infoDic objectForKey:key];
    
    return info;
}

+ (BOOL)writeSetupInfoToPlist:(NSString*)key value:(NSString*)value
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setupInfo.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"setupInfo" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
    }
    
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    plistDict[key] = value;
    
    BOOL retVal = NO;
    retVal = [plistDict writeToFile: path atomically:YES];
    
    return retVal;
}

+ (NSString*)getTitleWithServerNVersion
{
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* title = [NSString stringWithFormat:@"[운영 V%@]", version];
    
    if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"]){
        title = [NSString stringWithFormat:@" [QA V%@]", version];
    }
    
    return title;
}

//    [type] 1:위치바코드 2:설비바코드 3:장치바코드
+ (NSString*)barcodeMatchVal:(int)type barcode:(NSString*)barcode
{
    NSString* message = @"";
    NSString *expression = @"[a-zA-Z0-9]";
    NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:barcode options:0 range:NSMakeRange(0, [barcode length])];
    if (numberOfMatches < [barcode length]){
        return message = @"조회할수 없는 바코드 입니다.";
    }
    
    if(type == 1){
        if(barcode.length != 11 && barcode.length != 14 && barcode.length != 17 && barcode.length != 21){
            return message = @"처리할 수 없는 위치바코드입니다.";
        }
        //베이 위치코드를 스캔하면 베이로는 입고(팀내) 할수 없습니다.”
        if ([JOB_GUBUN isEqualToString:@"입고(팀내)"] || [JOB_GUBUN isEqualToString:@"접수(팀간)"] || [JOB_GUBUN isEqualToString:@"납품입고"] || [JOB_GUBUN isEqualToString:@"부외실물등록요청"] ||
            [JOB_GUBUN isEqualToString:@"수리완료"] || [JOB_GUBUN isEqualToString:@"개조개량완료"] || [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"] || [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
            [JOB_GUBUN isEqualToString:@"수리의뢰취소"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"] || [JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
            if (barcode.length > 17 && ![barcode hasPrefix:@"VS"] && ![[barcode substringFromIndex:17] isEqualToString:@"0000"]){
                return message = [NSString stringWithFormat:@"'베이' 위치로는 '%@'\n작업을 하실 수 없습니다.",JOB_GUBUN];
            }
        }
        
        //가상창고 위치바코드 사용 안됨.
        if([JOB_GUBUN isEqualToString:@"철거"] || [JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"] || [JOB_GUBUN isEqualToString:@"시설등록"]){
            if ([barcode hasPrefix:@"VS"]){
                return message = @"가상창고 위치바코드는\n 스캔하실 수 없습니다.";
            }
        }
        
        // 베이위치 또는 P위치로 송부취소(팀간) 불가 처리 - DR-2013-57935 : 송부취소(팀간) 시 위치코드 스캔 추가 - request by 김희선 : 2014.06.11 - modify by 류성호 : 2014.06.16
        if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]) {
            if ([barcode hasPrefix:@"P"] || (barcode.length > 17 && ![[barcode substringFromIndex:17] isEqualToString:@"0000"])){
                return message =[NSString stringWithFormat:@"'베이' 또는 'P' 위치로는\n'%@'\n작업을 하실 수 없습니다.", JOB_GUBUN];
            }
        }
    }else if(type == 2){
        if (barcode.length < 16 || barcode.length > 18){
            return message = @"처리할 수 없는 설비바코드입니다.";
        }
    }else{
        if (barcode.length != 9){
            return message = @"처리할 수 없는 장치바코드입니다.";
        }
    }
 
    return message;
}

@end

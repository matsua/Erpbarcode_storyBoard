//
//  ERPRequestManager.m
//  erpbarcode
//
//  Created by 박수임 on 14. 1. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ERPRequestManager.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"

@implementation ERPRequestManager

@synthesize reqKind;
@synthesize theConnection;
@synthesize receivedData;
@synthesize sendCount;
@synthesize textDataList;
@synthesize imageDataList;

@synthesize delegate;

- (id)init
{
    self = [super init];
    
    if (self){
        theConnection = nil;
        receivedData = nil;
        textDataList = nil;
        imageDataList = nil;
    }
    
    return self;
}

- (void)setTextDataKey:(NSString*)key Value:(NSString*)value
{
    if (textDataList == nil)
        textDataList = [NSMutableArray array];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:key forKey:@"key"];
    [dic setObject:value forKey:@"value"];
    [textDataList addObject:dic];
}


- (void)setImageDataKey:(NSString*)key data:(NSData*)data filename:(NSString*)filename contentType:(NSString*)contentType
{
    if (imageDataList == nil)
        imageDataList = [NSMutableArray array];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:key forKey:@"key"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:filename forKey:@"filename"];
    [dic setObject:contentType forKey:@"contenttype"];
    [imageDataList addObject:dic];
}

#pragma request method
// 동기로 서버에 전송한다.(text 데이타전송)
- (void)sychronousConnectToServer:(NSString*)urlInfo withData:(NSDictionary*)bodyDic
{
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    NSString* postString = [rootDic JSONString];
    
    NSLog(@"postString >> %@", postString);
    NSLog(@"urlInfo >> %@", urlInfo);
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@?securityYN=N&call=IOS", [Util udObjectForKey:BARCODE_SERVER], urlInfo];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:requestUrl]];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = 120;
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    [self processResponseDatas:result];
}


// 호출 전에 textDataList와 imageDataList를 만들어주어야 한다.
- (void)sychronousSendTextNImageConnectToServer:(NSString*)urlInfo
{
    // 필요한 데이타 리스트가 만들어 지지 않은 경우 리턴한다.
    if (textDataList == nil || imageDataList == nil)
        return;
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@?securityYN=N&call=IOS", [Util udObjectForKey:BARCODE_SERVER], urlInfo];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:requestUrl]];
	[request setURL:[NSURL URLWithString:requestUrl]];
	[request setHTTPMethod:@"POST"];
    request.timeoutInterval = 60;
    
	NSString *boundary = @"0xKhTmLbOuNdArY";  // important!!!
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	   
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSDictionary*dic in textDataList){
        NSString* key = [dic objectForKey:@"key"];
        NSString* value = [dic objectForKey:@"value"];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    for (NSDictionary*dic in imageDataList){
        NSString* key = [dic objectForKey:@"key"];
        NSData* data = [dic objectForKey:@"data"];
        NSString* filename = [dic objectForKey:@"filename"];
        NSString* contentType = [dic objectForKey:@"contenttype"];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",contentType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	   

    [request setHTTPBody:body];
    
	NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [self processResponseDatas:result];
}

// 비동기로 서버에 text데이타 전송
- (void)asychronousConnectToServer:(NSString*)urlInfo withData:(NSDictionary*)bodyDic
{
    NSString* postString = [bodyDic JSONString];
    
    NSLog(@"postString >> %@", postString);
    NSLog(@"urlInfo >> %@", urlInfo);
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@?securityYN=N&call=IOS", [Util udObjectForKey:BARCODE_SERVER], urlInfo];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:requestUrl]];
    request.timeoutInterval = 120;
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    theConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(theConnection)
    {
        NSLog(@"Connection Successful");
    }
    else
    {
        receivedData = nil;
        NSLog(@"Connection could not be made");
    }
}
// gbic data 를 request한다.
- (void)requestGbicList
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"" forKey:@"itemCd"];
    
    [self asychronousConnectToServer:API_GBIC_LIST withData:paramDic];
}


// 위치바코드 정보를 request한다.
- (void)requestLocCode:(NSString*)locBarcode
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:locBarcode forKey:@"LOC_CODE"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_LOC_CHECK withData:rootDic];
}

// 위치바코드 주소정보를 request한다.
- (void)requestAddrInfo:(NSString*)locBarcode
{
    NSString* locBarcodeSubString = [locBarcode substringToIndex:11];
 
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:locBarcodeSubString forKey:@"locationCode"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_LOC_ADDR withData:rootDic];
}

// 초기접속 비번변경을 request한다.
- (void)requestPasswordChange:(NSString*)password
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:password forKey:@"userPassword"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [self asychronousConnectToServer:API_CHANGE_PASSWORD withData:rootDic];
}

- (void)requestAuthLocation:(NSString*)locBarcode
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:locBarcode forKey:@"I_ZLOCCODE"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_LOC_AUTH_CHECK withData:rootDic];
}

- (void)requestWBS:(NSString*)locBarcode
{
    NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:locBarcode forKey:@"I_LOCCODE"];
    if (![JOB_GUBUN isEqualToString:@"철거"] && ![JOB_GUBUN isEqualToString:@"다중철거"] )
        [paramDic setObject:@"1" forKey:@"I_WORKCAT"];
    
    NSLog(@"ParamList [%@", paramDic);
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    if ([JOB_GUBUN isEqualToString:@"철거"] || [JOB_GUBUN isEqualToString:@"다중철거"])
        [self asychronousConnectToServer:API_SEARCH_REMOVAL_WBS withData:rootDic];
    else
        [self asychronousConnectToServer:API_SEARCH_WBS withData:rootDic];
}

- (void)requestMultiInfoWithDeviceCode:(NSString*)deviceBarcode
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:deviceBarcode forKey:@"SOURCE_CODE"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];

    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_MULTI_INFO withData:rootDic];
}

- (void)requestSAPInfo:(NSString*)fccBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID orgCode:(NSString*)orgCode isAsynch:(BOOL)isAsynch
{
    NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if ([JOB_GUBUN isEqualToString:@"인계"] ||
        [JOB_GUBUN isEqualToString:@"시설등록"] ||
        [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
        [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"] ||
        [JOB_GUBUN isEqualToString:@"개조개량완료"] ||
        [JOB_GUBUN isEqualToString:@"S/N변경"])
        [paramDic setObject:@"" forKey:@"I_FLAG"];
    else if ([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"] ||
             [JOB_GUBUN isEqualToString:@"현장점검(베이)"]){
        if (locCode.length)
            [paramDic setObject:@"H" forKey:@"I_FLAG"];
    }
    else if (![JOB_GUBUN isEqualToString:@"납품취소"])
        [paramDic setObject:@"H" forKey:@"I_FLAG"];
    
    if (
        [JOB_GUBUN isEqualToString:@"설비정보"] ||
        [JOB_GUBUN isEqualToString:@"장치바코드하위설비조회"]
        ){
        if (fccBarcode.length == 21)
            [paramDic setObject:fccBarcode forKey:@"I_ZEQUIPLP"];
        if (fccBarcode.length == 9){
            [paramDic setObject:fccBarcode forKey:@"I_ZEQUIPGC"];
            if (locCode.length)
                [paramDic setObject:locCode forKey:@"I_ZEQUIPLP"];
        }
        else {
            [paramDic setObject:fccBarcode forKey:@"I_EQUNR"];
        }
    }
    else {
        if ([fccBarcode length])
            [paramDic setObject:fccBarcode forKey:@"I_EQUNR"];
        if ([locCode length])
            [paramDic setObject:locCode forKey:@"I_ZEQUIPLP"];
        if ([deviceID length])
            [paramDic setObject:deviceID forKey:@"I_ZEQUIPGC"];
    }
    
    if ([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"] ||
        [JOB_GUBUN isEqualToString:@"현장점검(베이)"]){
        if (orgCode.length)
            [paramDic setObject:orgCode forKey:@"I_ZKOSTL"];
    }
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];

    NSString* detailUrl = API_FAC_INQUERY;  // 실장 납품취소 제외한 나머지
    
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"])
        detailUrl = API_FAC_INQUERY_MM;
    else if ([JOB_GUBUN isEqualToString:@"납품취소"])
        detailUrl = API_BUYOUT_CANCEL_LIST;
    else if ([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"] || [JOB_GUBUN isEqualToString:@"현장점검(베이)"])
        detailUrl = API_SPOT_CHECK_FACILITY;

    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    if (isAsynch)
        [self asychronousConnectToServer:detailUrl withData:rootDic];
    else
        [self sychronousConnectToServer:detailUrl withData:rootDic];
}

- (void)requestFccItemInfo:(NSString*)bismt matnr:(NSString*)matnr maktx:(NSString*)maktx maktxEnable:(BOOL)flag
{
    //real
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if ([bismt length])
        [paramDic setObject:bismt forKey:@"bismt"]; //기존 자재번호
    else
        [paramDic setObject:@"" forKey:@"bismt"]; //기존 자재번호
    
    if ([matnr length])
        [paramDic setObject:matnr forKey:@"matnr"];// 설비 바코드
    else
        [paramDic setObject:@"" forKey:@"matnr"];// 설비 바코드
    
    if (flag){
        if ([maktx length])
            [paramDic setObject:maktx forKey:@"maktx"];// 물품 코드명
        else
            [paramDic setObject:@"" forKey:@"maktx"];// 물품 코드명
    }
    
    NSLog(@"postString [%@]", paramDic);
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_ITEM_INFO withData:rootDic];
}

- (void)requestSearchRootOrgCode:(NSString*)rootOrgCode
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:rootOrgCode forKey:@"parentOrgCode"];
    
//    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
//
//    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_TREE_SEARCH_ORG withData:paramDic];
}

- (void)requestSaveLocation:(NSDictionary*)plant
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if (plant != nil && plant.count){
        [paramDic setObject:[plant objectForKey:@"PLANT"] forKey:@"PLANT"];
    }else
        [paramDic setObject:@"" forKey:@"PLANT"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_GET_SAVE_LOCATION withData:rootDic];
}

- (void)requestPlantForUserOrg:(NSString*)userOrgCode
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:userOrgCode forKey:@"KOSTL"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_GET_PLANT withData:rootDic];
}

- (void)requestGetLocSpotCheck:(NSString*)deviceId
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:deviceId forKey:@"I_DEVICE_IDGC"];
    
    NSLog(@"postData [%@]",paramDic);
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [self asychronousConnectToServer:API_GETLOC_SPOTCHECK withData:rootDic];
}

#pragma process after response
// 서버로 부터 받은 response data를 처리해 필요한 method를 호출한다.
- (void)processResponseDatas:(NSData*)data
{
    NSError* error;
    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!responseDic && error && [error.domain isEqualToString:NSCocoaErrorDomain] && (error.code == NSPropertyListReadCorruptError)) {
        // Encoding issue, try Latin-1
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        if (jsonString) {
            // Need to re-encode as UTF8 to parse, thanks Apple
            responseDic = [NSJSONSerialization JSONObjectWithData:
                           [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]
                                                          options:0 error:&error];
        }
    }
        
    if (![responseDic count])
    {
        [delegate processRequest:nil PID:reqKind Status:-1];
        return;
    }
    
    NSDictionary*   messageDic = [responseDic objectForKey:@"message"];
    NSDictionary*   headerDic = [messageDic objectForKey:@"header"];
    NSDictionary*   bodyDic = [messageDic objectForKey:@"body"];
    
    NSArray*        resultList ;
    if (reqKind == TAKEOVER_REQUEST_RESCAN_YN)
       resultList = [bodyDic objectForKey:@"subResult"];
    else
        resultList = [bodyDic objectForKey:@"result"]; //array 형식
    
    int statusCode = [[headerDic objectForKey:@"status"] intValue];
    NSLog(@"statusCode [%d]",statusCode);
    
    if (statusCode == -1 || statusCode == 0 || statusCode == 2){ //실패 : -1은 왜 실패 처리 안 하나? 2014.02.26 수정 류성호
        NSLog(@"실패!");
        NSArray* array = [NSArray arrayWithObject:headerDic];
        [delegate processRequest:array PID:reqKind Status:statusCode];
        return;
    }
    
    if (reqKind == REQUEST_LOC_COD ){
        [self processResponseLoc:resultList];
    }
    else if(reqKind == REQUEST_LOC_ADD){
        [self processResponseLocAdd:resultList];
    }
    else if(reqKind == REQUEST_PASSWORD_CHANGE){
        [self processResponsePasswordChange:resultList];
    }
    else if (reqKind == REQUEST_WBS){
        [self processResponseWBS:resultList];
    }
    else if (reqKind == REQUEST_SAP_FCC_COD){
        [self processResponseSAPInfo:resultList];
    }
    else if (reqKind == TAKEOVER_REQUEST_RESCAN){
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSArray* makeList = nil;
        if ([[dic objectForKey:@"E_RSLT"] isEqualToString:@"S"]){
//            NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n%d-%@",sendCount,statusCode,[dic objectForKey:@"E_MESG"]];
            makeList = [NSArray arrayWithObject:dic];
        }
        [delegate processRequest:makeList PID:reqKind Status:1];
    }
    else if (reqKind == REQUEST_MULTI_INFO){
        [self processMultiInfo:resultList];
    }
    else if (reqKind == REQUEST_LOGIN){
        NSArray* array = [NSArray arrayWithObject:headerDic];
        [self processLoginResponse:array];
//        [delegate processRequest:array PID:reqKind Status:1];
    }
    else if (reqKind == REQUEST_GET_NOTICE){
        [self processGetNoticeResponse:resultList];
    }
    else{
        [delegate processRequest:resultList PID:reqKind Status:1];
    }
}


- (void)processResponseLoc:(NSArray*)resultList
{
    if ([resultList count]){
        NSMutableArray* locResultList = [NSMutableArray array];
        
        //recode 갯수 1개 정보
        for (NSDictionary* dic in resultList) {
            NSMutableDictionary* locDic = [NSMutableDictionary dictionary];
            
            [locDic setObject:[dic objectForKey:@"completeLocationCode"] forKey:@"completeLocationCode"];
            [locDic setObject:[dic objectForKey:@"locationShortName"] forKey:@"locationShortName"];
            [locDic setObject:[dic objectForKey:@"locationFullName"] forKey:@"locationFullName"];
            [locDic setObject:[dic objectForKey:@"roomTypeCode"] forKey:@"roomTypeCode"];
            [locDic setObject:[dic objectForKey:@"roomTypeName"] forKey:@"roomTypeName"];
            [locDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
            [locDic setObject:[dic objectForKey:@"operationSystemCode"] forKey:@"operationSystemCode"];
            [locDic setObject:[dic objectForKey:@"zkostl"] forKey:@"zkostl"];
            [locDic setObject:[dic objectForKey:@"zktext"] forKey:@"zktext"];
            [locResultList addObject:locDic];
        }
        
        [delegate processRequest:locResultList PID:REQUEST_LOC_COD Status:1];
    }
}

//  matsua : 주소조회추가
- (void)processResponseLocAdd:(NSArray*)resultList
{
    NSMutableArray* locResultList = [NSMutableArray array];
    if ([resultList count]){
        
        for (NSDictionary* dic in resultList) {
            NSMutableDictionary* locDic = [NSMutableDictionary dictionary];
            
            [locDic setObject:[dic objectForKey:@"legalDongName"] forKey:@"legalDongName"];
            [locDic setObject:[dic objectForKey:@"addressTypeName"] forKey:@"addressTypeName"];
            [locDic setObject:[dic objectForKey:@"bunji"] forKey:@"bunji"];
            [locDic setObject:[dic objectForKey:@"ho"] forKey:@"ho"];
            [locDic setObject:[dic objectForKey:@"detailAddress"] forKey:@"detailAddress"];
            [locDic setObject:[dic objectForKey:@"roadName"] forKey:@"roadName"];
            [locDic setObject:[dic objectForKey:@"buildingMainNo"] forKey:@"buildingMainNo"];
            [locDic setObject:[dic objectForKey:@"buildingSubNo"] forKey:@"buildingSubNo"];
            [locResultList addObject:locDic];
        }
    }
    [delegate processRequest:locResultList PID:REQUEST_LOC_ADD Status:1];
}

- (void)processResponsePasswordChange:(NSArray*)resultList
{
    [delegate processRequest:resultList PID:REQUEST_PASSWORD_CHANGE Status:1];
}

- (void)processResponseWBS:(NSArray*)resultList
{
    if ([resultList count]){
        NSMutableArray* wbsResultList = [NSMutableArray array];
        
        NSString* JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
        for (NSDictionary* dic in resultList){
            NSMutableDictionary* wbsDic = [NSMutableDictionary dictionary];

            if ([JOB_GUBUN isEqualToString:@"철거"]){
                [wbsDic setObject:[dic objectForKey:@"NAME1"] forKey:@"NAME1"];
                [wbsDic setObject:[dic objectForKey:@"POSID"] forKey:@"POSID"];
                [wbsDic setObject:[dic objectForKey:@"POST1"] forKey:@"POST1"];
            }else{
                [wbsDic setObject:[dic objectForKey:@"STATUS"] forKey:@"STATUS"];
                [wbsDic setObject:[dic objectForKey:@"NAME1"] forKey:@"NAME1"];
                [wbsDic setObject:[dic objectForKey:@"POSID"] forKey:@"POSID"];
                [wbsDic setObject:[dic objectForKey:@"ZPJT_CODET"] forKey:@"ZPJT_CODET"];
                [wbsDic setObject:[dic objectForKey:@"POST1"] forKey:@"POST1"];
                [wbsDic setObject:[dic objectForKey:@"KOSTL_STATUS"] forKey:@"KOSTL_STATUS"];
            }
            [wbsResultList addObject:wbsDic];
        }
        [delegate processRequest:wbsResultList PID:REQUEST_WBS Status:1];
    }else{
        [delegate processRequest:nil PID:REQUEST_WBS Status:1];
    }
}

- (void)processMultiInfo:(NSArray*)resultList
{
    if (resultList.count){
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
        
        [newDic setObject:[dic objectForKey:@"operationSystemToken"] forKey:@"operationSystemToken"];
        [newDic setObject:[dic objectForKey:@"standardServiceCode"] forKey:@"standardServiceCode"];
        [newDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
        [newDic setObject:[dic objectForKey:@"deviceName"] forKey:@"deviceName"];
        [newDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
        [newDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
        [newDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
        [newDic setObject:[dic objectForKey:@"locationShortName"] forKey:@"locationShortName"];
        [newDic setObject:[dic objectForKey:@"deviceStatusName"] forKey:@"deviceStatusName"];
        [newDic setObject:[dic objectForKey:@"operationSystemCode"] forKey:@"operationSystemCode"];
        
        NSArray* newList = [NSArray arrayWithObject:newDic];
        [delegate processRequest:newList PID:REQUEST_MULTI_INFO Status:1];
    }
}

- (void)processResponseSAPInfo:(NSArray*)resultList
{
    NSMutableArray* sapList = [NSMutableArray array];
    if ([resultList count]){
        
        for (NSDictionary* dic in resultList){
            NSMutableDictionary* sapInfoDic = [NSMutableDictionary dictionary];
            
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"DEVICEGB"] forKey:@"DEVICEGB"];     //X
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"DEVICEGC"] forKey:@"DEVICEGC"];
            [sapInfoDic setObject:[dic objectForKey:@"EQKTX"] forKey:@"EQKTX"];
            [sapInfoDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];//설비바코드
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"HEQKTX"] forKey:@"HEQKTX"];           //X
            [sapInfoDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];//상위바코드
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"LEVEL"] forKey:@"LEVEL"];             //X
            [sapInfoDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapInfoDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [sapInfoDic setObject:[dic objectForKey:@"ZANLN1"] forKey:@"ZANLN1"];
            [sapInfoDic setObject:[dic objectForKey:@"ZDESC"] forKey:@"ZDESC"];
            [sapInfoDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
            [sapInfoDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
            [sapInfoDic setObject:[dic objectForKey:@"ZKEQUI"] forKey:@"ZKEQUI"];
            [sapInfoDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"]; //설비의 운용조직
            [sapInfoDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];
            [sapInfoDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapInfoDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapInfoDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [sapInfoDic setObject:[dic objectForKey:@"O_DATA_C"] forKey:@"O_DATA_C"];
            [sapInfoDic setObject:[dic objectForKey:@"ZPS_PNR"] forKey:@"ZPS_PNR"];
            if([dic objectForKey:@"GWLEN_O"] != nil) [sapInfoDic setObject:[dic objectForKey:@"GWLEN_O"] forKey:@"GWLEN_O"];
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"SERGE"] forKey:@"SERGE"];         //X
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapInfoDic setObject:[dic objectForKey:@"ZSETUP"] forKey:@"ZSETUP"]; // 셋업공사비      //X
            if([dic objectForKey:@"HOST_YN"] != nil){
                [sapInfoDic setObject:[dic objectForKey:@"HOST_YN"] forKey:@"HOST_YN"];
                [sapInfoDic setObject:[dic objectForKey:@"USG_YN"] forKey:@"USG_YN"];
            }
            NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];

            //새롭게 만들어준 키값            
            if ([partTypeName length])
                [sapInfoDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [sapInfoDic setObject:@"" forKey:@"PART_NAME"];
            
            [sapList addObject:sapInfoDic];
        }
    }
    [delegate processRequest:sapList PID:REQUEST_SAP_FCC_COD Status:1];
}

- (void)processLoginResponse:(NSArray*)resultList
{
    //버전체크
    //confirmationYn=N 본인인증프로세스 필요
    //info["orgId"].Equals("C000001") "KT 조직이 '케이티'인 경우\n로그인 하실 수 없습니다.\nIDMS에서 조직 정보를 변경하신 후\n사용하시기 바랍니다.\n문의처 : ISC(1588-3391)"
    NSDictionary* userInfoDic = [resultList objectAtIndex:0];
    
    //사용자 로그인정보 저장
    NSMutableDictionary* userDic = [NSMutableDictionary dictionary];
    [userDic setObject:[userInfoDic objectForKey:@"userId"] forKey:@"userId"];
    [userDic setObject:[userInfoDic objectForKey:@"userName"] forKey:@"userName"];
    [userDic setObject:[userInfoDic objectForKey:@"userCellPhoneNo"] forKey:@"userCellPhoneNo"];
    [userDic setObject:[userInfoDic objectForKey:@"orgId"] forKey:@"orgId"];
    [userDic setObject:[userInfoDic objectForKey:@"orgName"] forKey:@"orgName"];
    [userDic setObject:[userInfoDic objectForKey:@"orgCode"] forKey:@"orgCode"];
    [userDic setObject:[userInfoDic objectForKey:@"orgTypeCode"] forKey:@"orgTypeCode"];
    [userDic setObject:[userInfoDic objectForKey:@"sessionId"] forKey:@"sessionId"];
    [userDic setObject:[userInfoDic objectForKey:@"empNumber"] forKey:@"empNumber"];
    [userDic setObject:[userInfoDic objectForKey:@"confirmationYn"] forKey:@"confirmationYn"];
    [userDic setObject:[userInfoDic objectForKey:@"passwdUpdateYn"] forKey:@"passwdUpdateYn"];
    [userDic setObject:[userInfoDic objectForKey:@"centerId"] forKey:@"centerId"];
    [userDic setObject:[userInfoDic objectForKey:@"summaryOrg"] forKey:@"summaryOrg"];
    [userDic setObject:[userInfoDic objectForKey:@"centerName"] forKey:@"centerName"];
    
    if ([[userInfoDic objectForKey:@"orgId"] isEqualToString:@"C000001"]) {
        [delegate processRequest:nil PID:REQUEST_LOGIN_FAIL Status:3];
        return;
    }
    
    [Util udSetObject:userDic forKey:USER_INFO];
    
    //세션아이디 저장
    [Util udSetObject:[userInfoDic objectForKey:@"sessionId"] forKey:USER_SESSIONID];
    //로그인여부 저장
    [Util udSetObject:@"Y" forKey:USER_LOGIN_YN];
    
    [delegate processRequest:nil PID:REQUEST_LOGIN Status:1];
}

- (void)processGetNoticeResponse:(NSArray*)resultList
{
    if (resultList.count) //공지사항 있음
    {
        //        NSLog(@"resultList [%@]",resultList);
        
        NSMutableArray* noticeList = [NSMutableArray array];
        for (NSDictionary* dic in resultList)
        {
            NSString* message = [dic objectForKey:@"description"];
            message = [message stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
            message = [message stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
            message = [message stringByReplacingOccurrencesOfString:@"&#44;" withString:@","];
            message = [message stringByReplacingOccurrencesOfString:@"&lt;p&gt;&#xA;\t" withString:@""];
            message = [message stringByReplacingOccurrencesOfString:@"&lt;/p&gt;&#xA;" withString:@""];
            message = [message stringByReplacingOccurrencesOfString:@"&lt;br /&gt;&#xA;" withString:@"\n"];
            message = [message stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            message = [message stringByReplacingOccurrencesOfString:@"&amp;quot;" withString:@"\""];
            message = [message stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@" "];
            
            NSMutableDictionary* noticeDic = [NSMutableDictionary dictionary];
            [noticeDic setObject:message forKey:@"description"];
            [noticeDic setObject:[dic objectForKey:@"boardSequence"] forKey:@"boardSequence"];
            [noticeDic setObject:[dic objectForKey:@"title"] forKey:@"title"];
            [noticeDic setObject:[NSNumber numberWithInt:SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            [noticeDic setObject:@"1" forKey:@"level"];
            [noticeDic setObject:[NSDate TodayString] forKey:@"date"];
            [noticeList addObject:noticeDic];
        }
        
        [delegate processRequest:noticeList PID:REQUEST_GET_NOTICE Status:1];
    }
    else {
        [delegate processRequest:Nil PID:REQUEST_GET_NOTICE Status:1];
    }
}

#pragma HTTP delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (receivedData == nil){
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData appendData:data];
//    NSLog(@"Receiving data... Length: %d", [receivedData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    theConnection = nil;
    receivedData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    NSMutableDictionary* headerDic = [NSMutableDictionary dictionary];
    [headerDic setObject:[NSString stringWithFormat:@"%@", [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]] forKey:@"detail"];
    NSArray* resultList = [NSArray arrayWithObject:headerDic];
    
    [delegate processRequest:resultList PID:reqKind Status:0];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
//    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);

    [self processResponseDatas:receivedData];
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    theConnection = nil;
    receivedData = nil;
}


@end

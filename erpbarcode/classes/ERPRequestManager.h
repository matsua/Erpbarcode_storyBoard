//
//  ERPRequestManager.h
//  erpbarcode
//
//  Created by 박수임 on 14. 1. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USE_ERPREQUEST_MANAGER  1

typedef enum {
    REQUEST_LOGICAL_LOC,
    REQUEST_LOC_COD,
    REQUEST_OTD,
    REQUEST_LOC_ADD,
    REQUEST_PASSWORD_CHANGE,
    REQUEST_WBS,
    REQUEST_MULTI_INFO,
    REQUEST_MULTI_INFO_SYNCH,
    REQUEST_MULTI_INFO_FULL,
    REQUEST_SUB_MULTI_INFO,
    TAKEOVER_REQUEST_CHECK_VALIDATE_DEVICEID,
    REQUEST_SAP_FCC_COD,
    REQUEST_SAP_FCC_BREAK_COD,
    REQUEST_DETAIL_SAP_FCC,
    REQUEST_REPAIR_HISTORY,
    REQUEST_REVISION_SAP_FCC,
    REQUEST_ITEM_FCC_COD,
    REQUEST_UPPER_SAP_FCC_COD,
    REQUEST_MOVE_SEARCH,
    REQUEST_STATUS_CHECK,
    REQUEST_SEND,
    REQUEST_SEARCH_ORG,
    REQUEST_SEARCH_ORG_NAME,
    REQUEST_FAULT_IMAGE_UPLOAD,
    TAKEOVER_REQUEST_RESCAN_YN,
    TAKEOVER_REQUEST_RESCAN,
    TAKEOVER_REQUEST_SEARCH,
    TAKEOVER_REQUEST_SEND_RESCAN,
    TAKEOVER_REQUEST_LIST,
    IM_REQUEST_SEARCH,
    IM_REQUEST_ITEM_STATUS,
    IM_REQUEST_SEARCH_ASSET,
    IM_REQUEST_COMPLETE_SCAN_SEARCH,
    REQUEST_PRODUCT_SURVEY_LIST,
    REQUEST_PRODUCT_SURVEY_SCAN_LIST,
    REQUEST_SAVE_LOCATION,
    REQUEST_GET_DOC_NO,
    REQUEST_GET_PLANT,
    REQUEST_GET_REPAIR_RECEIPT,
    REQUEST_GET_REPAIR_RECEIPT_IM,
    REQUEST_REMODEL_LIST,
    REQUEST_SEND_REPAIR_IM,
    REQUEST_GETLOC_SPOTCHECK,
    REQUEST_SPOT_SERIAL,
    REQUEST_GBIC_LIST,
    REQUEST_VERSION,
    REQUEST_LOGIN,
    REQUEST_SET_USER_INFO,
    REQUEST_LOGOUT,
    REQUEST_LOGIN_FAIL,
    REQUEST_GET_NOTICE,
    REQUEST_LOGIN_MAKE_CERTIFICATION,
    REQUEST_LOGIN_SEND_CERTIFICATION,
    REQUEST_MATNR_INFO,
    REQUEST_MULT_MATNR_INFO,
    REQUEST_BC_TRA_ST,
    REQUEST_PBLS_WHY,
    REQUEST_INS_DEL,
    REQUEST_LABEL_TP,
    REQUEST_SEARCH_INS_BARCODE,
    REQUEST_CANCEL_INS_BARCODE,
    REQUEST_GENERATE_INS_BARCODE,
    REQUEST_REPUBLISH_INS_BARCODE,
    REQUEST_PRINT_INS_BARCODE,
    REQUEST_PRINT_SM_BARCODE,
    REQUEST_SEARCH_LOC_BARCODE,
    REQUEST_SEARCH_PO_NO_BARCODE,
    REQUEST_SEARCH_DEVICE_BARCODE,
    REQUEST_SEARCH_SEARCH_USER_BARCODE,
    REQUEST_SIDO_LOC_BARCODE,
    REQUEST_SIGOON_LOC_BARCODE_FALSE,
    REQUEST_SIGOON_LOC_BARCODE_TRUE,
    REQUEST_DONG_LOC_BARCODE,
    REQUEST_AUTH_CODE,
    REQUEST_AUTH_COF,
    REQUEST_PWD_UPDATE,
    REQUEST_DATA_NULL
}requestOfKind;

@protocol IProcessRequest <NSObject>
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status;
@end

@interface ERPRequestManager : NSObject

@property(assign,nonatomic) requestOfKind reqKind;
@property(strong,nonatomic) NSURLConnection* theConnection;
@property(strong,nonatomic) NSMutableData* receivedData;
@property(assign,nonatomic) NSInteger sendCount;
@property(strong,nonatomic) NSMutableArray* textDataList;
@property(strong,nonatomic) NSMutableArray* imageDataList;

@property(strong, nonatomic) id <IProcessRequest> delegate;
@property(assign, nonatomic) BOOL changePassword;

- (void)setTextDataKey:(NSString*)key Value:(NSString*)value;
- (void)setImageDataKey:(NSString*)key data:(NSData*)data filename:(NSString*)filename contentType:(NSString*)contentType;
- (void)sychronousConnectToServer:(NSString*)urlInfo withData:(NSDictionary*)bodyDic;
- (void)sychronousSendTextNImageConnectToServer:(NSString*)urlInfo;
- (void)asychronousConnectToServer:(NSString*)urlInfo withData:(NSDictionary*)bodyDic;
- (void)requestGbicList;
- (void)requestLocCode:(NSString*)locBarcode;
- (void)requestAddrInfo:(NSString*)locBarcode;
- (void)requestPasswordChange:(NSString*)password;
- (void)requestAuthLocation:(NSString*)locBarcode;
- (void)requestWBS:(NSString*)locBarcode;
- (void)requestMultiInfoWithDeviceCode:(NSString*)deviceBarcode;
- (void)requestSAPInfo:(NSString*)fccBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID orgCode:(NSString*)orgCode isAsynch:(BOOL)isAsynch;
- (void)requestFccItemInfo:(NSString*)bismt matnr:(NSString*)matnr maktx:(NSString*)maktx maktxEnable:(BOOL)flag;
- (void)requestSearchRootOrgCode:(NSString*)rootOrgCode;
- (void)requestSaveLocation:(NSDictionary*)plant;
- (void)requestPlantForUserOrg:(NSString*)userOrgCode;
- (void)requestGetLocSpotCheck:(NSString*)deviceId;


@end

//
//  Constant.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//


#ifndef erpbarcode_Constant_h
#define erpbarcode_Constant_h

//공용 매크로
#define PHONE_SCREEN_HEIGHT   CGRectGetHeight([UIScreen mainScreen].bounds)
#define PHONE_SCREEN_WIDTH    CGRectGetWidth([UIScreen mainScreen].bounds)

// DeviceOrientation (가로인지 세로인지 판단)
#define isDevicePortrait() \
([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait \
|| [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown)

#define isDeviceLandscape() \
([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft \
|| [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)

// DeviceType (폰인지 패드인지 판단)
#define isDevicePhone() \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define isDevicePad() \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// 4인치 판단
#define IS_4_INCH() \
(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(320, 568)))


// 5,5S
#define IS_5_MODEL() \
(PHONE_SCREEN_HEIGHT == 568)

//6, 6S, 7, 8
#define IS_6_MODEL() \
(PHONE_SCREEN_HEIGHT == 667)

//6+, 6S+, 7+, 8+
#define IS_6_PLUS_MODEL() \
(PHONE_SCREEN_HEIGHT == 736)

//X인지 판단
#define IS_IPHONE_X() \
(PHONE_SCREEN_HEIGHT == 812)

// iOS 4점대 판단
#define IS_iOS4() \
([[UIDevice currentDevice].systemVersion doubleValue] < 5.0)

// iOS 6점대 판단
#define IS_iOS6() \
([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)

// 컬러값
#define UIColorFromRGB(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:(alphaValue)]

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RADIAN(D) D * 3.14159265 / 180
#define COLOR_SCAN1  [UIColor colorWithRed:203/255.0 green:249/255.0 blue:181/255.0 alpha:1]

// 테스트 위해 필요
#define _MAKE_FUNC_

//접속할 서버 정의
//#define __QA_SERVER__
//#define __DEVEL_SERVER__
//#define __REAL_SERVER__

// Http url
//#if defined(__QA_SERVER__)
//    #define BARCODE_SERVER          @"http://nbaseqa.kt.com"
//#elif defined(__REAL_SERVER__)
//    #define BARCODE_SERVER          @"http://erpbarcodepda.kt.com/nbase"
//#elif defined(__DEVEL_SERVER__)
//    #define BARCODE_SERVER          @"http://nbasedev.kt.com"
//#endif

//constant
#define     MAX_SEND_COUNT          3000
typedef enum {
    SUB_NO_CATEGORIES,          // sub category가 없음을 의미.
    SUB_CATEGORIES_NO_EXPOSE,   // sub category를 가지고 있으나, 화면상에는 표시하고 있지 않은 상태
    SUB_CATEGORIES_EXPOSED      // sub category를 가지고 있으며, 화면상에 이미 표시하고 있는 상태
} SubCategoryInfo;


// URL info
#define API_LOGIN                   @"/user/pda/login.json"
#define API_USER_DEV                @"/user/setLoginDevInfo.json"        //로그인 기기정보 저장
#define API_LOGOUT                  @"/user/pda/logout.json"
#define API_VERSION                 @"/pda/program/download/info/get.json" //버전체크
#define API_TIME                    @"/server/time/get.do"
#define API_USER_AUTH               @"/user/confirmation/no/make.json"
#define API_LOC_CHECK               @"/based/location/info/get.json"
#define API_LOC_AUTH_CHECK          @"/based/location/user/check/get.json"  //물류센터 전용 위치바코드 권한 체크 ( 출고는 제외 )-ZMMO_LOCATION_USER_CHECK
#define API_LOC_ADDR                @"/based/location/load/addr/get.json"     // 위치바코드 주소명 조회
#define API_GET_NOTICE              @"/board/pda/notice/list/get.json"
#define API_SEND_OUTINTO            @"/operation/enter/stock/exec.json"     //팀내(입고)
#define API_SEND_BUYOUT_INTO        @"/delivery/enter/stock/exec.json"                     // 납품입고
#define API_SEND_BUYOUT_CANCEL      @"/operation/deliver/facility/status/mod.json"        // 납품취소
#define API_BUYOUT_CANCEL_LIST      @"/operation/deliver/facility/list/get.json"           // 납품취소 리스트
#define API_BUYOUT_CHECK            @"/operation/deliver/facility/status/check/get.json"   //납품취소 OTD Validation - ZMMO_CHECK_GR_CANCEL
#define API_ITEM_INFO               @"/based/item/info/list/pda/get.json"
#define API_MATNR_INFO              @"/based/item/interface/list/pda/get.json"  //물품정보
#define API_FAC_INQUERY             @"/operation/facility/list/get.json"    //설비정보 문의              // ZPMN_EQUI_DETAIL_DISP(설비정보)
#define API_FAC_INQUERY_MM          @"/operation/facility/mm/list/get.json"
#define API_FAC_INQUERY_DETAIL      @"/operation/facility/detail/list/get.json" //설비정보 상세
#define API_MULTI_INFO              @"/deviceId/info/by/pda/get.json"       //위치ID&장비ID
#define API_SEND_DELIVERY           @"/operation/movement/release/exec.json" //출고(팀내)
#define API_SEND_UNMOUNT            @"/operation/unmount/exec.json"  //탈장
#define API_SEND_MOUNT              @"/operation/mount/facility/reg.json" //실장
#define API_TREE_SEARCH_ORG         @"/based/organization/list/get.json"    //조직 검색
#define API_NAME_SEARCH_ORG         @"/based/organization/autocomplete/list/get.json"    //조직 검색
#define API_SEND_DEVICE_NEW         @"/movement/scan/dept/movement/send.json"             //팀간(송부)
#define API_SEND_DEVICE_CANCEL      @"/movement/scan/cancel/dept/movement/send.json"             //송부취소(팀간)
#define API_SEND_SPOTCHECK          @"/operation/spot/check/reg.json"  //현장점검 전송
#define API_SPOT_SERIAL             @"/operation/manage/spot/check/by/pda/get.json"
#define API_MOVE_SEARCH             @"/movement/request/dept/movement/list/get.json"             //부서간 이동할 리스트 조회
#define API_SEND_RECEIPT_NEW        @"/movement/scan/receipt/dept/movement/send.json"            //팀간(접수) 신규
#define API_GETLOC_SPOTCHECK        @"/operation/spot/check/devid/loc/list/get.json" // 현장점검 장치아이디 하위 설비의 위치코드 리스트 가져오기
#define API_LOGICAL_LOC             @"/based/location/storage/list/pda/get.json"     // 논리위치바코드(창고위치) 조회
#define API_FAC_CHANGE_STATUS       @"/operation/facility/status/modify.json"    // 설비상태변경
#define API_DEVICEID_BELOW_FAC_LIST  @"/operation/devid/low/fac/list/get.json"   //장치바코드 하위 설비 중 운용이면서 유닛 제외 리스트 가져오기
#define API_SUBMIT_REMOVAL_SCAN     @"/movement/remolish/reg.json" //철거
#define API_SEARCH_REMOVAL_WBS      @"/based/wbs/wbsRemolish/get.json" //철거시 WBS요청
#define API_SEARCH_WBS              @"/based/wbs/list/get.json"         // WBS
#define API_SEND_DELIVERY_MM        @"/operation/movement/release/otd/exec.json"
#define API_SEARCH_TRANSPER_SCAN    @"/construction/before/transition/list/get.json"    //인계
#define API_SEARCH_ARGUMENT_SCAN    @"/construction/after/transition/list/get.json"     // 인수
#define API_SEARCH_INST_CONF_SCAN   @"/construction/after/transition/list/get.json"     // 시설등록조회
#define API_SEARCH_INST_CONF_WBS    @"/construction/install/confirm/wbs/get.json"       // 시설등록 WBS조회
#define API_SEARCH_ARGUMENT_SCAN_CONFIRM    @"/construction/argument/list/get.json"      // 인수확정조회
#define API_SEARCH_INSTOREMARKING   @"/barcode/facility/info/instore/get.json"      // 인스토어마킹
#define API_SEARCH_IM_COMPLETESCAN  @"/barcode/generation/new/get.json" //인스토어마킹 완료 스캔 조회
#define API_SEARCH_ITEMINFO         @"/based/item/info/list/pda/get.json"
#define API_SEARCH_ASSET            @"/based/asset/classification/list/by/pda/get.json"
#define API_SUBMIT_TRANSFER_SCAN    @"/construction/before/transition/execute.json"    // 인계요청
#define API_SUBMIT_TRANSFER_SCAN_DELETE     @"/construction/delete/transition/execute.json" // 인계자료삭제
#define API_SUBMIT_ARGUMENT_SCAN_SENDMAIL   @"/construction/request/rescan/by/pda/trs.json" // 인수스캔 재스캔 요청
#define API_SUBMIT_ARGUMENT_SCAN    @"/construction/after/transition/execute.json"  //인수스캔
#define API_SUBMIT_ARGUMENT_SCAN_CONFIRM    @"/construction/save/argument/decision/reg.json"    // 인수, 시설등록 확정 전송
#define API_SUBMIT_INST_CONF_SCAN   @"/construction/install/confirm/reg.json"       // 시설등록
#define API_SUBMIT_ARGUMENT_SCAN_SENDMAIL    @"/construction/request/rescan/by/pda/trs.json" //인수스캔 재스캔요청 - ZPMN_TAKEOVER_COM    M
#define API_SUBMIT_INSTOREMARKING   @"/barcode/generation/request/reg.json"     //인스토어마킹 완료스캔
#define API_SUBMIT_IM_COMPLETSCAN   @"/barcode/generation/complete/scan/reg.json"
#define API_SEND_FAILURE_REG        @"/repair/oos/reg.json"  //고장등록
#define API_SEND_FAILURE_REG_CANCEL @"/repair/oos/cancel.json" //고장등록 취소
#define API_GET_REPAIR_HISTORY      @"/repair/history/list/get.json" //고장이력조회
#define API_SEND_REPAIR_REG_CANCEL  @"/repair/request/document/cancel.json" //수리의뢰 취소
#define API_GET_FAILURE_LIST        @"/repair/request/document/list/get.json" // 고장정보조회 - ZPMN_REPAIR_EQUIP_DETAIL
#define API_SEND_REMODEL_NEW        @"/construction/convert/instructions/request/scan/reg.json" //개조개량의뢰/개조개량의뢰취소 스캔전송
#define API_GET_REMODEL_LIST        @"/construction/convert/instructions/request/scan/barcode/info/get.json" //개조개량 의뢰스캔 _ 바코드 정보
#define API_REMODEL_COMPLETE_LIST   @"/construction/convert/instructions/finsh/scan/barcode/info/get.json" //개조개량 완료스캔 _ 바코드 정보
#define API_SEND_REVISE_DONE        @"/construction/convert/instructions/complete/scan/pda/reg.json"  //개조개량 완료 NEW - 즉시 실장
#define API_SEND_REPAIR_INSTALL     @"/operation/install/facility/reg.json" //수리완료 즉시 실장
#define API_SEND_REPAIR_DONE        @"/operation/repair/facility/reg.json"  //수리완료
#define API_SEND_REPAIR_IM          @"/barcode/generation/complete/scan/reg.json" //수리완료접수_인스토어마킹접수
#define API_PRODUCT_SURVEY_SCAN_LIST @"/survey/detail/list/get.json" // 상품단말실사 스캔 리스트 얻기 최초호출
#define API_PRODUCT_SURVEY_LIST     @"/survey/list/get.json" // 상품단말실사 물품 얻기 // 상품단말 재고실사 자재마스터 리스트 조회 (조회버튼 클릭시 호출)
#define API_SEND_PRODUCT_SURVEY     @"/survey/reg.json" // 상품단말실사전송
#define API_SEND_INVENTORY_SURVEY   @"/movement/physical/count/reg.json" //임대단말실사 전송
#define API_GET_PLANT               @"/movement/plant/search/list/get.json" // 플랜트 얻기
#define API_GET_SAVE_LOCATION       @"/movement/lgort/search/list/get.json" // 저장위치 얻기
#define API_GET_DOC_NO              @"/survey/doc/no/list/get.json"  // 실사문서 얻기
#define API_SEND_RENT_PRODUCT       @"/movement/physical/count/reg.json"  // 임대단말실사전송
#define API_GET_REPAIR_RECEIPT_IM   @"/operation/repair/barcode/get.json" //수리완료접수_인스토어마킹조회
#define API_GET_REPAIR_RECEIPT      @"/operation/repair/facility/get.json" //수리완료접수_조회
#define LOGIN_MAKE_CERTIFICATION    @"/user/confirmation/no/make.json"   // 본인인증
#define LOGIN_SEND_CERTIFICATION    @"/user/confirmation/date/mod.json"     // 인증 정보 전송
#define FAILURE_PICTURE_UPLOAD      @"/fac/file/upload.up"      // 고장등록 사진 upload
#define API_SN_CHANGE_STATUS        @"/operation/serial/number/mod.json"    // S/N변경
#define API_CHANGE_PASSWORD         @"/operation/passwd/mod.json"     // 비밀번호 변경
#define API_SPOT_CHECK_FACILITY     @"/operation/facility/listSpotCheck/get.json" //현장점검 위치 설비조회
#define API_GBIC_LIST               @"/based/item/gbic/list/get.json" //gbic_list
#define API_FAC_BREAKDOWN           @"/repair/control/breakdown/get.json" //고장 설비정보

#define API_PRT_BC_TRA_ST           @"/based/code/cache/list/type/BC_TRA_ST/get.json" //프린트연동 추가 - 진행상태
#define API_PRT_PBLS_WHY            @"/based/code/cache/list/type/PBLS_WHY/get.json"  //프린트연동 추가 - 요청사유
#define API_PRT_INS_DEL             @"/based/code/cache/list/type/INS_DEL/get.json"   //프린트연동 추가 - 요청취소사유
#define API_PRT_LABEL_TP            @"/based/code/cache/list/type/LABEL_TP/REF_VAL2/Y/get.json"  //프린트연동 추가 - 라벨용지

#define API_PRT_INS_SEARCH          @"/barcode/generation/list/get.json"  //인스토어마킹관리 - 조회
#define API_PRT_INS_CANCEL          @"/barcode/generation/remove.json"    //인스토어마킹관리 - 요청취소
#define API_PRT_INS_GENERATE        @"/barcode/generation/generate.json"  //인스토어마킹관리 - 발행
#define API_PRT_INS_REPUBLISH       @"/barcode/generation/republish.json" //인스토어마킹관리 - 재발행
#define API_PRT_INS_STATUS_MOD      @"/barcode/generation/status/publish/mod.json" //인스토어마킹관리 - 출력

#define API_PRT_LOC_SIDO            @"/based/location/list/addr/sido/get.json" //프린트연동 추가 - 시/도 조회
#define API_PRT_LOC_SIGOON          @"/based/location/list/addr/siGoon/get.json" //프린트연동 추가 - 시/군 조회
#define API_PRT_LOC_DONG            @"/based/location/autocomplete/legal/dong/list/get.json" //프린트연동 추가 - 읍/면/동 조회
#define API_PRT_LOC_SEARCH          @"/based/location/info/list/get.json"  //위치바코드관리 - 조회

#define API_PRT_SM_PO_NO_SEARCH     @"/barcode/sourcemarking/list/po/no/get.json"  //소스마킹 - 조회
#define API_PRT_SM_PRINT_YN         @"/barcode/generation/status/publish/mod.json"  //소스마킹 - 프린트완료 상태값 변경

#define API_PRT_DEVICEID_SEARCH     @"/deviceId/list/get.json"  //장치바코드 - 조회
#define API_PRT_USER_SEARCH         @"/pda/user/list/get.json"  //장치바코드 - 사용자조회

#define API_USER_AUTH_REQ           @"/user/password/confirmation/no/make.json"             //비밀번호 초기화 - 인증번호 요청
#define API_USER_AUTH_CFM           @"/user/checkCertificationNumber.json"                  //비밀번호 초기화 - 인증번호 확인
#define API_USER_PWD_UPDATE         @"/user/password/by/user/executePasswordUpdate.json"    //비밀번호 초기화 - 비밀번호 저장

#define API_SEND_FORM_MAKE          @"/operation/mount/facility/formMake.json"  //형상구성
#define API_SEND_FORM_CLEAR         @"/operation/mount/facility/formClear.json" //형상해제

#define API_BASE_MANAGEMENT         @"/base/smart/management.json"    //BASE OA,OE - 불용요청, 신규등록, 관리자 변경, 재물조사, 납품확인, 대여등록, 대여반납
#define API_BASE_ITEM_SEARCH        @"/base/smart/itemSearch.json"    //BASE OA - OA연식조회, BASE OE - 비품연식조회

//NSUserDefault Access Keyword
#define USER_INFO           @"USER_INFO"            //로그인시 사용자정보 dictionary 형식
                                                    /* userId"        
                                                     userName"      
                                                     userCellPhoneNo
                                                     orgId"
                                                     orgName"
                                                     orgTypeCode"
                                                     sessionId"
                                                     empNumber"
                                                     */
#define USER_SESSIONID          @"USER_SESSIONID"
#define USER_LOGIN_YN           @"USER_LOGIN_YN"
#define USER_ID                 @"USER_ID"
#define USER_PW                 @"USER_PW"
#define USER_WORK_MODE          @"USER_WORK_MODE" //Y: N:
#define USER_OFFLINE            @"USER_OFFLINE"
#define MAP_QWERTY              @"MAP_QWERTY"
#define MAP_DECRPT              @"MAP_DECRPT"
#define MAP_ENCRPT              @"MAP_ENCRPT"
#define MAP_PART_NAME           @"MAP_PART_NAME"
#define MAP_PART_TYPE           @"MAP_PART_TYPE"
#define MAP_WORK_NAME           @"MAP_WORK_NAME" //key: workcd
#define MAP_WORK_CD             @"MAP_WORK_CD"   //key: workname
#define MAP_FACILITY_NAME       @"MAP_FACILITY_NAME" //key: statusCode
#define MAP_FACILITY_TYPE       @"MAP_FACILITY_TYPE" //key: statusName
#define MAP_DEVICE_TYPE         @"MAP_DEVICE_TYPE"
#define USER_WORK_NAME          @"USER_WORK_NAME"
#define LIST_SAP                @"LIST_SAP"          //사용자가 요청한 설비 리스트
#define COMPLETE_LOC_CODE       @"COMPLETE_LOC_CODE"
#define WORK_FCC_SAP_LIST       @"WORK_FCC_SAP_LIST"
#define LIST_ORG                @"LIST_ORG"          //전체 조직도 리스트
#define EAI_MATNR_CDATE         @"EAI_MATNR_CDATE"   //물품정보 생성일자
#define GBIC_USELESS_LIST       @"GBIC_USELESS_LIST"  //gbic 불용확정 리스트
#define IS_ALERT_COMPLETE       @"IS_ALERT_COMPLETE"  //alert 완료 여부
#define READ_BUFFER             @"READ_BUFFER"        //바코드 수신 정보
#define IS_DATA_MODIFIED        @"IS_DATA_MODIFIED" //최초 데이터 수신이후 데이터 변경여부
#define USER_WORK_ID            @"USER_WORK_ID"     //작업관리 아이디
#define USER_DELTA              @"USER_DELTA"   //위도,경도,diff 값 저장
#define BARCODE_SERVER          @"BARCODE_SERVER"   // 접속할 서버 url 저장
#define BARCODE_SERVER_ID       @"BARCODE_SERVER_ID"    // QA or REAL
#define SOUND_ON_OFF            @"SOUND_ON_OFF"     // 사운드 설정
#define SOFT_KEYBOARD_ON_OFF    @"SOFT_KEYBOARD_ON_OFF" // 소프트 키보드 설정
#define INPUT_MODE              @"INPUT_MODE" // 키보드 입력모드

//Alert 공통 메세지 정의
#define OFFLINE_MESSAGE         @"'음영지역작업' 중입니다."
#define OFFLINE_SEND_MESSAGE    @"'음영지역작업' 중에는\n '전송' 하실 수 없습니다.\n1. 먼저 '저장' 하신 후\n2. 네트워크 접속으로 로그인 하시고\n3. '저장' 하신 자료를 불러와서\n4. '전송' 하시기 바랍니다."
#define NOT_CHANGE_SEND_MESSAGE @"기존에 전송한 자료와 동일하거나\n전송 할 자료가 존재하지 않습니다.\n전송할 자료를 추가하거나\n변경하신 후 다시 전송하세요."
#define MESSAGE_CANT_SEND_OFFLINE       @"'음영지역작업' 중에는\n'전송' 하실 수 없습니다.\n1. 먼저 '저장' 하신 후\n2. 네트워크 접속으로 로그인 하시고\n3. '저장' 하신 자료를 불러와서\n4. '전송' 하시기 바랍니다."
#define MESSAGE_OFFLINE         @"'음영지역작업' 중입니다."

//Notification
#define RCV_BARCODE_NOTI        @"RCV_BARCODE_NOTI"
//FinishCommand()가 수행됨을 알리는 Notification
#define RCV_CMDFINISH_NOTI      @"RCV_CMDFINISH_NOTI" 
// 작업관리 종료 시점을 알려줌
#define RCV_END_JOB             @"RCV_END_JOB"



// Sound관련 화일 정의
#define EXT_WAVE                @"wav"
#define SOUND_DUPLICATION       @"duplication"      // 중복 스캔
#define SOUND_ALERT             @"alert"            // error
#define SOUND_ASTERISK          @"asterisk"         // 띠리리~
#define SOUND_BARCODE           @"barcode"
#define SOUND_ERROR             @"error"
#define SOUND_MB_BARCODE        @"MB_Barcode"
#define SOUND_STANDARD          @"standard"
#define SOUND_NOTIFY            @"notify"
#define SOUND_JUNG              @"jung"
#define SOUND_SCAN              @"scan"             // 스캔이 원칙
#define SOUND_SCANBELOW         @"scanbelow"        // 스캔하지 않은 하위 설비
#define SOUND_SEND_QUESTION     @"sendquestion"     // 전송하시겠습니까
#define SOUND_CERT_SUCC         @"certificationSuccess" // 6개월(인증되었습니다)
#define SOUND_NOT_EXIST         @"sound_notexists"  // 존재하지 않는 설비바코드입니다.

#define NEW_QA_VERSION_URL      @"https://nbaseqa.kt.com/nbase/m/init.do"  // 새버전 다운로드 받을 주소
#define NEW_VERSION_URL         @"https://erpbarcode.kt.com/m"  // 새버전 다운로드 받을 주소

// Add by sesang
#define API_CONSISTENCY_CONUT   @"/deviceId/consistency/get.json"    // 사용자 조직의 장치 ID 정합성 작업 대상 수량 조회

#define API_CHECK_CONSISTENCY   @"/deviceId/checkLocDevInfo/get.json" // 장치&위치 스캔 시 정합성 체크

#endif

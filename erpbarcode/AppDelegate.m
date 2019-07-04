//
//  AppDelegate.m
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WorkDataViewController.h"
#import "MainMenuViewController.h"
#import "LoadingView.h"
#import "ERPAlert.h"

// iXShield
#import "iX.h"

KDCReader *kdcReader;

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize loadingView;
@synthesize loadingInterval;

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController* vc = [[LoginViewController alloc] init];
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];*/
    
    //KoamTac KDC - 바코드 스캐너 연결
    //scanner
    kdcReader = [[KDCReader alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kdcConnectionChanged:) name:kdcConnectionChangedNotification object:nil];
    [kdcReader Connect];   // Connect to KDC
    
    // Sound, 소프트키보드 설정(plist 화일로부터 설정 읽어서...)
    [Util udSetBool:[[Util loadSetupInfoFromPlist:@"SOUND"] boolValue]forKey:SOUND_ON_OFF];
    [Util udSetBool:[[Util loadSetupInfoFromPlist:@"SOFT_KEYBOARD"] boolValue]forKey:SOFT_KEYBOARD_ON_OFF];
    
    // Local DB 를 사용하는데 있어서 기본적으로 필요한 초기화 작업이 이루어지도록 함.
    [DBManager sharedInstance];
    
    //[self customizeAppearance];
    //map table create
    [self initializeMapTable];
    
    [self startIntroView];
    
#if DEBUG
    //  iXShield 개발시에 사용하는 옵션으로 상용 배포시에 필히 삭제하여야 한다.
    ix_set_debug();
#else
    ix_not_use_update();
    [self systemCheck];
#endif

    return YES;
}

#pragma mark - Method for ixShield API Call
#pragma mark 1. 시스템 체크 진행
- (void) systemCheck {

    struct ix_detected_pattern *patternInfo;
    int ret = ix_sysCheckStart(&patternInfo);

    if (ret != 1) {
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle:@"안내"
                                                        message:[NSString stringWithFormat:@"[error code : %d]시스템 체크 오류 \n ERP Barcode 를 \n사용하실수 없습니다.",ret]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                              otherButtonTitles:nil];
        [alert setTag:33333];
        [alert show];
    }else {
        NSString *jbCode = [NSString stringWithUTF8String:patternInfo->pattern_type_id];
        AlertViewController *alert = nil;

        if ([jbCode isEqualToString:@"0000"]) {
            [self integrityCheck];
        }else {
            // Error code Check and App Exit.
            alert = [[AlertViewController alloc] initWithTitle:@"안내"
                                               message:@"[Jail break] 감지 되었습니다. \n ERP Barcode 를 \n사용하실수 없습니다."
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                     otherButtonTitles:nil];
            [alert setTag:33333];
            [alert show];
        }
    }
}

#pragma mark 2. 무결성 검사 진행
- (void) integrityCheck {

    struct ix_init_info *initInfo = calloc(sizeof(struct ix_init_info), 1); // 초기값 및 옵션 셋팅
    struct ix_verify_info verifyInfo; //결과 값

    initInfo->integrity_type = IX_INTEGRITY_LOCAL;
    int ret = ix_integrityCheck(initInfo, &verifyInfo);

    NSString *verifyResult = [NSString stringWithCString:verifyInfo.verify_result encoding:NSUTF8StringEncoding];
    NSString *verifyData   = [NSString stringWithCString:verifyInfo.verify_data encoding:NSUTF8StringEncoding];

    if (ret != 1) { // 1이 아닐 결우 오류.
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle:@"안내"
                                                        message:[NSString stringWithFormat:@"[error code : %d\n%@]\n시스템 체크 오류 \n ERP Barcode 를 \n사용하실수 없습니다.",ret, verifyData]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                              otherButtonTitles:nil];
        [alert setTag:33333];
        [alert show];
        return;
    } else {
        if(![verifyResult isEqualToString:@"VERIFY_SUCC"]) {
            AlertViewController *alert = [[AlertViewController alloc] initWithTitle:@"MERP"
                                               message:[NSString stringWithFormat:@"[error code : %d\n%@]\n시스템 체크 오류 \n ERP Barcode 를 \n사용하실수 없습니다.",ret, verifyData]
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                     otherButtonTitles:nil];
            
            [alert setTag:33333];
            [alert show];
        } else {
            [self fakeGpsCheck];
        }
    
    }
}

#pragma mark 3. fake GPS를 사용할 경우
- (void) fakeGpsCheck {
    AlertViewController *alert = nil;

    if (ix_check_fakegps() == 1) {
        alert = [[AlertViewController alloc] initWithTitle:@"안내"
                                           message:@"[Fake Gps]\n감지 되었습니다.\nERP Barcode를 \n이용할수 없습니다."
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                 otherButtonTitles:nil];
        [alert setTag:33333];
        [alert show];
    }else {
        [self debuggerCheck];
    }
}

#pragma mark 4. 안티 디버깅
- (void) debuggerCheck {
    AlertViewController *alert = nil;

    if (ix_runAntiDebugger() == 1) {
        alert = [[AlertViewController alloc] initWithTitle:@"안내"
                                           message:@"[Debugger]\n감지 되었습니다.\nERP Barcode를 \n이용할수 없습니다."
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"확인", nil)
                                 otherButtonTitles:nil];
        [alert setTag:33333];
        [alert show];
    }
}

// 초기화면 띄워줌
-(void)loadingView:(NSTimer *)timer
{
    if(loadingInterval > 0) {
        loadingInterval -= 1;
    }
    else {
        [timer invalidate];
        [self stopIntroView];
    }
}

- (void)startIntroView
{
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0,PHONE_SCREEN_WIDTH, PHONE_SCREEN_HEIGHT)];
    [self.window addSubview:loadingView];
    [loadingView startLoading];
    
    loadingInterval = 1;
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(loadingView:)
                                   userInfo:nil
                                    repeats:YES];
    [self.window makeKeyAndVisible];
}

- (void)stopIntroView
{
    [loadingView stopLoading];
}

- (void)initializeMapTable
{
    //decrypt map table allocation
    NSMutableDictionary* decryptDic = [NSMutableDictionary dictionary];
    [decryptDic setObject:@"A" forKey:@"Q"];
    [decryptDic setObject:@"B" forKey:@"I"];
    [decryptDic setObject:@"C" forKey:@"Z"];
    [decryptDic setObject:@"D" forKey:@"R"];
    [decryptDic setObject:@"E" forKey:@"D"];
    [decryptDic setObject:@"F" forKey:@"G"];
    [decryptDic setObject:@"G" forKey:@"X"];
    [decryptDic setObject:@"H" forKey:@"S"];
    [decryptDic setObject:@"I" forKey:@"N"];
    [decryptDic setObject:@"J" forKey:@"C"];
    [decryptDic setObject:@"K" forKey:@"F"];
    [decryptDic setObject:@"L" forKey:@"J"];
    [decryptDic setObject:@"M" forKey:@"T"];
    [decryptDic setObject:@"N" forKey:@"L"];
    [decryptDic setObject:@"O" forKey:@"H"];
    [decryptDic setObject:@"P" forKey:@"P"];
    [decryptDic setObject:@"Q" forKey:@"Y"];
    [decryptDic setObject:@"R" forKey:@"O"];
    [decryptDic setObject:@"S" forKey:@"U"];
    [decryptDic setObject:@"T" forKey:@"A"];
    [decryptDic setObject:@"U" forKey:@"E"];
    [decryptDic setObject:@"V" forKey:@"M"];
    [decryptDic setObject:@"W" forKey:@"K"];
    [decryptDic setObject:@"X" forKey:@"B"];
    [decryptDic setObject:@"Y" forKey:@"W"];
    [decryptDic setObject:@"Z" forKey:@"V"];
    [decryptDic setObject:@"1" forKey:@"4"];
    [decryptDic setObject:@"2" forKey:@"1"];
    [decryptDic setObject:@"3" forKey:@"5"];
    [decryptDic setObject:@"4" forKey:@"2"];
    [decryptDic setObject:@"5" forKey:@"3"];
    [decryptDic setObject:@"6" forKey:@"0"];
    [decryptDic setObject:@"7" forKey:@"6"];
    [decryptDic setObject:@"8" forKey:@"9"];
    [decryptDic setObject:@"9" forKey:@"8"];
    [decryptDic setObject:@"0" forKey:@"7"];
    
    [Util udSetObject:decryptDic forKey:MAP_DECRPT];
    
    //decrypt map table allocation
    NSMutableDictionary* encryptDic = [NSMutableDictionary dictionary];
    [encryptDic setObject:@"Q" forKey:@"A"];
    [encryptDic setObject:@"I" forKey:@"B"];
    [encryptDic setObject:@"Z" forKey:@"C"];
    [encryptDic setObject:@"R" forKey:@"D"];
    [encryptDic setObject:@"D" forKey:@"E"];
    [encryptDic setObject:@"G" forKey:@"F"];
    [encryptDic setObject:@"X" forKey:@"G"];
    [encryptDic setObject:@"S" forKey:@"H"];
    [encryptDic setObject:@"N" forKey:@"I"];
    [encryptDic setObject:@"C" forKey:@"J"];
    [encryptDic setObject:@"F" forKey:@"K"];
    [encryptDic setObject:@"J" forKey:@"L"];
    [encryptDic setObject:@"T" forKey:@"M"];
    [encryptDic setObject:@"L" forKey:@"N"];
    [encryptDic setObject:@"H" forKey:@"Q"];
    [encryptDic setObject:@"P" forKey:@"P"];
    [encryptDic setObject:@"Y" forKey:@"Q"];
    [encryptDic setObject:@"O" forKey:@"R"];
    [encryptDic setObject:@"U" forKey:@"S"];
    [encryptDic setObject:@"A" forKey:@"T"];
    [encryptDic setObject:@"E" forKey:@"U"];
    [encryptDic setObject:@"M" forKey:@"V"];
    [encryptDic setObject:@"K" forKey:@"W"];
    [encryptDic setObject:@"B" forKey:@"X"];
    [encryptDic setObject:@"W" forKey:@"Y"];
    [encryptDic setObject:@"V" forKey:@"Z"];
    [encryptDic setObject:@"4" forKey:@"1"];
    [encryptDic setObject:@"1" forKey:@"2"];
    [encryptDic setObject:@"5" forKey:@"3"];
    [encryptDic setObject:@"2" forKey:@"4"];
    [encryptDic setObject:@"3" forKey:@"5"];
    [encryptDic setObject:@"0" forKey:@"6"];
    [encryptDic setObject:@"6" forKey:@"7"];
    [encryptDic setObject:@"9" forKey:@"8"];
    [encryptDic setObject:@"8" forKey:@"9"];
    [encryptDic setObject:@"7" forKey:@"0"];
    
    [Util udSetObject:encryptDic forKey:MAP_ENCRPT];
    
    NSMutableDictionary* qwertyDic = [NSMutableDictionary dictionary];
    [qwertyDic setObject:@"A" forKey:@"ㅁ"];
    [qwertyDic setObject:@"B" forKey:@"ㅠ"];
    [qwertyDic setObject:@"C" forKey:@"ㅊ"];
    [qwertyDic setObject:@"D" forKey:@"ㅇ"];
    [qwertyDic setObject:@"E" forKey:@"ㄸ"];
    [qwertyDic setObject:@"E" forKey:@"ㄷ"];
    [qwertyDic setObject:@"F" forKey:@"ㄹ"];
    [qwertyDic setObject:@"G" forKey:@"ㅎ"];
    [qwertyDic setObject:@"H" forKey:@"ㅗ"];
    [qwertyDic setObject:@"I" forKey:@"ㅑ"];
    [qwertyDic setObject:@"J" forKey:@"ㅓ"];
    [qwertyDic setObject:@"K" forKey:@"ㅏ"];
    [qwertyDic setObject:@"L" forKey:@"ㅣ"];
    [qwertyDic setObject:@"M" forKey:@"ㅡ"];
    [qwertyDic setObject:@"N" forKey:@"ㅜ"];
    [qwertyDic setObject:@"O" forKey:@"ㅐ"];
    [qwertyDic setObject:@"O" forKey:@"ㅒ"];
    [qwertyDic setObject:@"P" forKey:@"ㅔ"];
    [qwertyDic setObject:@"P" forKey:@"ㅖ"];
    [qwertyDic setObject:@"Q" forKey:@"ㅂ"];
    [qwertyDic setObject:@"Q" forKey:@"ㅃ"];
    [qwertyDic setObject:@"R" forKey:@"ㄱ"];
    [qwertyDic setObject:@"R" forKey:@"ㄲ"];
    [qwertyDic setObject:@"S" forKey:@"ㄴ"];
    [qwertyDic setObject:@"T" forKey:@"ㅅ"];
    [qwertyDic setObject:@"T" forKey:@"ㅆ"];
    [qwertyDic setObject:@"U" forKey:@"ㅕ"];
    [qwertyDic setObject:@"V" forKey:@"ㅍ"];
    [qwertyDic setObject:@"W" forKey:@"ㅈ"];
    [qwertyDic setObject:@"W" forKey:@"ㅉ"];
    [qwertyDic setObject:@"X" forKey:@"ㅌ"];
    [qwertyDic setObject:@"Y" forKey:@"ㅛ"];
    [qwertyDic setObject:@"Z" forKey:@"ㅋ"];
    [Util udSetObject:qwertyDic forKey:MAP_QWERTY];
    
    //map table allocation
    NSMutableDictionary* partTypeDic = [NSMutableDictionary dictionary];
    [partTypeDic setObject:@"R"  forKey:@"10"];
    [partTypeDic setObject:@"S"  forKey:@"20"];
    [partTypeDic setObject:@"U"  forKey:@"30"];
    [partTypeDic setObject:@"N"  forKey:@"40"]; //N/A
    [Util udSetObject:partTypeDic forKey:MAP_PART_TYPE];
    
    NSMutableDictionary* partNameDic = [NSMutableDictionary dictionary];
    [partNameDic setObject:@"위치"    forKey:@"L"];
    [partNameDic setObject:@"장치"    forKey:@"D"];
    [partNameDic setObject:@"Rack"   forKey:@"R"];
    [partNameDic setObject:@"Shelf"  forKey:@"S"];
    [partNameDic setObject:@"Unit"   forKey:@"U"];
    [partNameDic setObject:@"Equipment"  forKey:@"E"];
    [Util udSetObject:partNameDic forKey:MAP_PART_NAME];
    
    //map table allocation
    NSMutableDictionary* deviceTypeDic = [NSMutableDictionary dictionary];
    [deviceTypeDic setObject:@"대표물품"  forKey:@"10"];
    [deviceTypeDic setObject:@"조립품"        forKey:@"20"];
    [deviceTypeDic setObject:@"단품"       forKey:@"30"];
    [deviceTypeDic setObject:@"부품"            forKey:@"40"];
    [deviceTypeDic setObject:@"케이블"           forKey:@"50"];
    [Util udSetObject:deviceTypeDic forKey:MAP_DEVICE_TYPE];
    
    NSMutableDictionary* workNameDic = [NSMutableDictionary dictionary];
    [workNameDic setObject:@"납품입고"          forKey:@"00"];
    [workNameDic setObject:@"납품취소"          forKey:@"01"];
    [workNameDic setObject:@"배송출고"          forKey:@"02"];
    [workNameDic setObject:@"인계"             forKey:@"03"];
    [workNameDic setObject:@"인수"             forKey:@"04"];
    [workNameDic setObject:@"시설등록"          forKey:@"05"];
    [workNameDic setObject:@"입고(팀내)"        forKey:@"10"];
    [workNameDic setObject:@"출고(팀내)"        forKey:@"11"];
    [workNameDic setObject:@"실장"             forKey:@"12"];
    [workNameDic setObject:@"탈장"             forKey:@"13"];
    [workNameDic setObject:@"송부(팀간)"        forKey:@"14"];
    [workNameDic setObject:@"송부취소(팀간)"     forKey:@"15"];
    [workNameDic setObject:@"접수(팀간)"        forKey:@"16"];
    [workNameDic setObject:@"형상구성(창고내)"        forKey:@"17"];
    [workNameDic setObject:@"형상해제(창고내)"        forKey:@"18"];
    [workNameDic setObject:@"바코드대체요청"      forKey:@"20"];
    [workNameDic setObject:@"부외실물등록요청"     forKey:@"21"];
    [workNameDic setObject:@"인스토어마킹완료"     forKey:@"22"];
    [workNameDic setObject:@"고장등록"           forKey:@"30"];
    [workNameDic setObject:@"고장등록취소"        forKey:@"31"];
    [workNameDic setObject:@"수리의뢰취소"        forKey:@"32"];
    [workNameDic setObject:@"수리완료"           forKey:@"33"];
    [workNameDic setObject:@"개조개량의뢰"        forKey:@"34"];
    [workNameDic setObject:@"개조개량의뢰취소"     forKey:@"35"];
    [workNameDic setObject:@"개조개량완료"        forKey:@"36"];
    [workNameDic setObject:@"철거"              forKey:@"40"];
    [workNameDic setObject:@"설비상태변경"        forKey:@"50"];
    [workNameDic setObject:@"S/N변경"          forKey:@"51"];
    [workNameDic setObject:@"현장점검(창고/실)"    forKey:@"60"];
    [workNameDic setObject:@"현장점검(베이)"      forKey:@"61"];
    [workNameDic setObject:@"상품단말실사"        forKey:@"62"];
    [workNameDic setObject:@"임대단말실사"        forKey:@"63"];
    [workNameDic setObject:@"물품정보"           forKey:@"70"];
    [workNameDic setObject:@"설비정보"           forKey:@"71"];
    [workNameDic setObject:@"장치바코드정보"       forKey:@"72"];
    [workNameDic setObject:@"위치정보"            forKey:@"73"];
    [workNameDic setObject:@"고장정보"        forKey:@"74"];
    [workNameDic setObject:@"고장수리이력"        forKey:@"75"];
    [workNameDic setObject:@"위치바코드"        forKey:@"80"];
    [workNameDic setObject:@"신규등록[OA]"        forKey:@"100"];
    [workNameDic setObject:@"관리자변경[OA]"        forKey:@"101"];
    [workNameDic setObject:@"불용요청[OA]"        forKey:@"103"];
    [workNameDic setObject:@"연식조회[OA]"        forKey:@"104"];
    [workNameDic setObject:@"납품확인[OA]"        forKey:@"105"];
    [workNameDic setObject:@"대여등록[OA]"        forKey:@"106"];
    [workNameDic setObject:@"대여반납[OA]"        forKey:@"107"];
    [workNameDic setObject:@"신규등록[OE]"        forKey:@"110"];
    [workNameDic setObject:@"관리자변경[OE]"        forKey:@"111"];
    [workNameDic setObject:@"불용요청[OE]"        forKey:@"113"];
    [workNameDic setObject:@"비품연식조회[OE]"        forKey:@"114"];
    [workNameDic setObject:@"납품확인[OE]"        forKey:@"115"];
    [workNameDic setObject:@"대여등록[OE]"        forKey:@"116"];
    [workNameDic setObject:@"대여반납[OE]"        forKey:@"117"];
    [Util udSetObject:workNameDic forKey:MAP_WORK_NAME];
    
    NSMutableDictionary* workCodeDic = [NSMutableDictionary dictionary];
    [workCodeDic setObject:@"00"   forKey:@"납품입고"];
    [workCodeDic setObject:@"01"   forKey:@"납품취소"];
    [workCodeDic setObject:@"02"   forKey:@"배송출고"];
    [workCodeDic setObject:@"03"   forKey:@"인계"];
    [workCodeDic setObject:@"04"   forKey:@"인수"];
    [workCodeDic setObject:@"05"   forKey:@"시설등록"];
    [workCodeDic setObject:@"10"   forKey:@"입고(팀내)"];
    [workCodeDic setObject:@"11"   forKey:@"출고(팀내)"];
    [workCodeDic setObject:@"12"   forKey:@"실장"];
    [workCodeDic setObject:@"13"   forKey:@"탈장"];
    [workCodeDic setObject:@"14"   forKey:@"송부(팀간)"];
    [workCodeDic setObject:@"15"   forKey:@"송부취소(팀간)"];
    [workCodeDic setObject:@"16"   forKey:@"접수(팀간)"];
    [workCodeDic setObject:@"17"        forKey:@"형상구성(창고내)"];
    [workCodeDic setObject:@"18"        forKey:@"형상해제(창고내)"];
    [workCodeDic setObject:@"20"   forKey:@"바코드대체요청"];
    [workCodeDic setObject:@"21"   forKey:@"부외실물등록요청"];
    [workCodeDic setObject:@"22"   forKey:@"인스토어마킹완료"];
    [workCodeDic setObject:@"30"   forKey:@"고장등록"];
    [workCodeDic setObject:@"31"   forKey:@"고장등록취소"];
    [workCodeDic setObject:@"32"   forKey:@"수리의뢰취소"];
    [workCodeDic setObject:@"33"   forKey:@"수리완료"];
    [workCodeDic setObject:@"34"   forKey:@"개조개량의뢰"];
    [workCodeDic setObject:@"35"   forKey:@"개조개량의뢰취소"];
    [workCodeDic setObject:@"36"   forKey:@"개조개량완료"];
    [workCodeDic setObject:@"40"   forKey:@"철거"];
    [workCodeDic setObject:@"50"   forKey:@"설비상태변경"];
    [workCodeDic setObject:@"51"   forKey:@"S/N변경"];
    [workCodeDic setObject:@"60"   forKey:@"현장점검(창고/실)"];
    [workCodeDic setObject:@"61"   forKey:@"현장점검(베이)"];
    [workCodeDic setObject:@"62"   forKey:@"상품단말실사"];
    [workCodeDic setObject:@"63"   forKey:@"임대단말실사"];
    [workCodeDic setObject:@"70"   forKey:@"물품정보"];
    [workCodeDic setObject:@"71"   forKey:@"설비정보"];
    [workCodeDic setObject:@"72"   forKey:@"장치바코드정보"];
    [workCodeDic setObject:@"73"   forKey:@"위치정보"];
    [workCodeDic setObject:@"74"   forKey:@"고장정보"];
    [workCodeDic setObject:@"75"   forKey:@"고장수리이력"];
    [workCodeDic setObject:@"80"   forKey:@"위치바코드"];
    [workCodeDic setObject:@"100"   forKey:@"신규등록[OA]"];
    [workCodeDic setObject:@"101"   forKey:@"관리자변경[OA]"];
    [workCodeDic setObject:@"103"   forKey:@"불용요청[OA]"];
    [workCodeDic setObject:@"104"   forKey:@"연식조회[OA]"];
    [workCodeDic setObject:@"105"   forKey:@"납품확인[OA]"];
    [workCodeDic setObject:@"106"   forKey:@"대여등록[OA]"];
    [workCodeDic setObject:@"107"   forKey:@"대여반납[OA]"];
    [workCodeDic setObject:@"110"   forKey:@"신규등록[OE]"];
    [workCodeDic setObject:@"111"   forKey:@"관리자변경[OE]"];
    [workCodeDic setObject:@"113"   forKey:@"불용요청[OE]"];
    [workCodeDic setObject:@"114"   forKey:@"비품연식조회[OE]"];
    [workCodeDic setObject:@"115"   forKey:@"납품확인[OE]"];
    [workCodeDic setObject:@"116"   forKey:@"대여등록[OE]"];
    [workCodeDic setObject:@"117"   forKey:@"대여반납[OE]"];
    [Util udSetObject:workCodeDic forKey:MAP_WORK_CD];
    
    //map table allocation
    NSMutableDictionary* facilityNameDic = [NSMutableDictionary dictionary];
    [facilityNameDic setObject:@"납품입고"      forKey:@"0020"];
    [facilityNameDic setObject:@"납품취소"      forKey:@"0021"];
    [facilityNameDic setObject:@"인수예정"      forKey:@"0040"];
    [facilityNameDic setObject:@"인계작업취소"   forKey:@"0041"];
    [facilityNameDic setObject:@"인수거부"      forKey:@"0042"];
    [facilityNameDic setObject:@"시설등록완료"   forKey:@"0045"];
    [facilityNameDic setObject:@"시설등록취소"   forKey:@"0046"];
    [facilityNameDic setObject:@"인계완료"      forKey:@"0050"];
    [facilityNameDic setObject:@"운용"         forKey:@"0060"];
    [facilityNameDic setObject:@"미운용"        forKey:@"0070"];
    [facilityNameDic setObject:@"탈장"         forKey:@"0080"];
    [facilityNameDic setObject:@"분실위험"      forKey:@"0081"];
    [facilityNameDic setObject:@"유휴"        forKey:@"0100"];
    [facilityNameDic setObject:@"예비"        forKey:@"0110"];
    [facilityNameDic setObject:@"고장"        forKey:@"0120"];
    [facilityNameDic setObject:@"수리의뢰"     forKey:@"0130"];
    [facilityNameDic setObject:@"이동중"       forKey:@"0140"];
    [facilityNameDic setObject:@"수리완료송부"  forKey:@"0160"];
    [facilityNameDic setObject:@"개조의뢰"      forKey:@"0170"];
    [facilityNameDic setObject:@"개조완료송부"  forKey:@"0171"];
    [facilityNameDic setObject:@"철거확정"      forKey:@"0190"];
    [facilityNameDic setObject:@"불용대기"      forKey:@"0200"];
    [facilityNameDic setObject:@"불용요청"      forKey:@"0210"];
    [facilityNameDic setObject:@"불용확정"      forKey:@"0240"];
    [facilityNameDic setObject:@"사용중지"      forKey:@"0260"];
    [facilityNameDic setObject:@"출고중"       forKey:@"0270"];
    [facilityNameDic setObject:@"설비마스터 없음"       forKey:@""];
    [Util udSetObject:facilityNameDic forKey:MAP_FACILITY_NAME];
    
    //map table allocation
    NSMutableDictionary* facilityTypeDic = [NSMutableDictionary dictionary];
    [facilityTypeDic setObject:@"0020"      forKey:@"납품입고"];
    [facilityTypeDic setObject:@"0021"      forKey:@"납품취소"];
    [facilityTypeDic setObject:@"0040"      forKey:@"인수예정"];
    [facilityTypeDic setObject:@"0041"      forKey:@"인계작업취소"];
    [facilityTypeDic setObject:@"0042"      forKey:@"인수거부"];
    [facilityTypeDic setObject:@"0045"      forKey:@"시설등록완료"];
    [facilityTypeDic setObject:@"0046"      forKey:@"시설등록취소"];
    [facilityTypeDic setObject:@"0050"      forKey:@"인계완료"];
    [facilityTypeDic setObject:@"0060"      forKey:@"운용"];
    [facilityTypeDic setObject:@"0070"      forKey:@"미운용"];
    [facilityTypeDic setObject:@"0080"      forKey:@"탈장"];
    [facilityTypeDic setObject:@"0081"      forKey:@"분실위험"];
    [facilityTypeDic setObject:@"0100"      forKey:@"유휴"];
    [facilityTypeDic setObject:@"0110"      forKey:@"예비"];
    [facilityTypeDic setObject:@"0120"      forKey:@"고장"];
    [facilityTypeDic setObject:@"0130"      forKey:@"수리의뢰"];
    [facilityTypeDic setObject:@"0140"      forKey:@"이동중"];
    [facilityTypeDic setObject:@"0160"      forKey:@"수리완료송부"];
    [facilityTypeDic setObject:@"0170"      forKey:@"개조의뢰"];
    [facilityTypeDic setObject:@"0171"      forKey:@"개조완료송부"];
    [facilityTypeDic setObject:@"0190"      forKey:@"철거확정"];
    [facilityTypeDic setObject:@"0200"      forKey:@"불용대기"];
    [facilityTypeDic setObject:@"0210"      forKey:@"불용요청"];
    [facilityTypeDic setObject:@"0240"      forKey:@"불용확정"];
    [facilityTypeDic setObject:@"0260"      forKey:@"사용중지"];
    [facilityTypeDic setObject:@"0270"      forKey:@"출고중"];
    [Util udSetObject:facilityTypeDic forKey:MAP_FACILITY_TYPE];
    
    //gbic 불용확정 리스트 가져오기
    NSString* path = [[NSBundle mainBundle] pathForResource:@"gbic_0240"
                                                     ofType:@"txt"];
    
    NSString* contents = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    NSArray* gbic0240List = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray* gbicUselessList = [NSMutableArray array];
    for (NSString* barcode in gbic0240List)
    {
        if (barcode.length)
            [gbicUselessList addObject:barcode];
    }
    [Util udSetObject:gbicUselessList forKey:GBIC_USELESS_LIST];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    LoginViewController* vc = [[LoginViewController alloc] init];
    [vc requestUserLogout];
    
    ix_dealloc();
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            abort();
        }
    }
}

#pragma mark - Access Macro
+(id)sharedInstance
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app;
}

#pragma mark - Appearance
-(void)customizeAppearance{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bg_ps"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"erpbarcode" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"erpbarcode.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma User define Method
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - UIAlertViewDelegate
- (void)clickedButtonAtIndex:(NSInteger)buttonIndex alertView:(AlertViewController*)alertView
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 444){ //종료
        exit(0);
    }else if(alertView.tag == 33333){  //ixShield NoPass
        exit(0);
    }else if(alertView.tag == 22222){ ////ixShield Pass
        
    }
}


//************************************************************************
//
//  Notification from KDCReader when connection has been changed
//
//************************************************************************
- (void)kdcConnectionChanged:(NSNotification *)notification
{
    KDCReader *kReader = (KDCReader *)[notification object];
    if ([kReader IsKDCConnected])
        NSLog(@"kReader isConnected!!");
    
    else
        NSLog(@"kReader isFinished!!");
}

- (BOOL)getKdcIsConnected
{
    return [kdcReader IsKDCConnected];
}

- (uint8_t *)getKdcFirmwareVersion
{
    return [kdcReader GetFirmwareVersion];
}

- (uint8_t *)getKdcSerialNumber
{
    return [kdcReader GetSerialNumber];
}

- (uint8_t *)getKdcModelName
{
    return [kdcReader GetModelName];
}

- (uint8_t *)getKdcBluetoothMacAddress
{
    return [kdcReader GetBluetoothMacAddress];
}

- (uint8_t *)getKdcBluetoothFirmwareVersion
{
    return [kdcReader GetBluetoothFirmwareVersion];
}

- (int)getKdcBatteryCapacity
{
    return [kdcReader GetBatteryCapacity];
}

@end

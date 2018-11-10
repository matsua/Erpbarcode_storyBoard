//
//  MainMenuViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "WorkDataViewController.h"
#import "OutIntoViewController.h"
#import "BuyOutIntoViewController.h"
#import "TakeOverNRegEquipViewController.h"
#import "RevisionViewController.h"
#import "SpotCheckViewController.h"
#import "IMRequestViewController.h"
#import "EtcEquipmentViewController.h"
#import "CompleteScanViewController.h"
#import "DeviceInfoViewController.h"
#import "FccInfoViewController.h"
#import "LocInfoViewController.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"

#import "BarcodeViewController.h"
#import "BaseViewController.h"


#define VIEW1_POS_Y  20
#define VIEW2_POS_Y  191
#define VIEW3_POS_Y  295
#define VIEW4_POS_Y  399

// 테스트로 입력해보는 것임
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize preview;
@synthesize subMenuView;
@synthesize subMenuLayout;
@synthesize setupInfoList;
@synthesize menuList;
@synthesize subMenuList;
@synthesize indicatorView;
@synthesize prevMainMenuTag;
@synthesize prevButton;
@synthesize isAlreadyOpen;
@synthesize selectedMenu;
@synthesize isOffLine;
@synthesize isQA;
@synthesize currentOpenedMainMenu;

@synthesize viewMainMenu1;
@synthesize viewMainMenu2;
@synthesize viewMainMenu3;
@synthesize viewMainMenu4;
@synthesize viewSubMenu;
@synthesize lblVersion;
@synthesize lblServer;
@synthesize lblUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.tabBar invalidateIntrinsicContentSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    if(preview && [preview isEqualToString:@"LOGIN"]){
        [self setLoginMsg];
    }
    
    // Refresh myView and/or main view
    [self.view layoutIfNeeded];
    
    
    //font test : matsua
//    for(NSString *familyName in [UIFont familyNames])
//        NSLog(@"%@ : [ %@ ]",familyName,
//              [[UIFont fontNamesForFamilyName:familyName] description]);
    
    // Do any additional setup after loading the view from its nib.
    // menulist.plist로부터 menuList(NSArray*)를 생성한다.
    menuList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menulist" ofType:@"plist"]];
    prevMainMenuTag = -1;
    selectedMenu = -1;
    prevButton = nil;
    
    // 접속서버와 버전정보 표시
    if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"]){
        isQA = YES;
        lblServer.text = @"QA";
        lblVersion.textColor = RGB(114, 105, 101);
        lblServer.textColor = RGB(114, 105, 101);
    }
    else{
        isQA = NO;
        lblServer.text = @"운영";
        lblVersion.textColor = [UIColor blueColor];
        lblServer.textColor = [UIColor blueColor];
    }
    
    //DR-2015-35863 바코드 시스템 로그인 정보 display(PDA, APP)
    NSString* version = [NSString stringWithFormat:@"Version %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    lblVersion.text = version;
    
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    NSString *userName = [userinfo objectForKey:@"userName"];
    userName = [NSString stringWithFormat:@"%@님 환영합니다.",[userName stringByReplacingCharactersInRange:NSMakeRange(userName.length - 1,1) withString:@"*"]];
    lblUserName.text = userName;
    
    //조직 검색 호출
    isOffLine = [[Util udObjectForKey:USER_OFFLINE] boolValue];
    
    //음영지역 아닐때만 호출 - 유저디폴트에 저장할 조직도 구성을 위해
    if (!isOffLine && [Util udObjectForKey:LIST_ORG] == nil)
        [self requestSearchOrg:@"000001"];
    
    // 현재 위치정보를 요청함
    //    ERPLocationManager* locMgr = [ERPLocationManager getInstance];
    //    [locMgr getMyPosition];
    
    //base menu tab hidden - matsua - ing
    //viewMainMenu4.hidden = YES;
    
//    [self.viewMainSubMenu1 setHidden:YES];
//    [self.viewMainSubMenu2 setHidden:YES];
//    [self.viewMainSubMenu3 setHidden:YES];
//    [self.viewMainSubMenu4 setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLoginMsg{
    NSDictionary* userDic = [Util udObjectForKey:USER_INFO];
    if(![[userDic objectForKey:@"orgTypeCode"] isEqualToString:@"INS_USER"] && ![[userDic objectForKey:@"passwdUpdateYn"] isEqualToString:@"Y"] && ![[userDic objectForKey:@"confirmationYn"] isEqualToString:@"N"]){
        NSString *summaryOrgName = [userDic objectForKey:@"summaryOrg"];
        NSString *centerName = [userDic objectForKey:@"centerName"];
        if(summaryOrgName == NULL) summaryOrgName = @"";
        if(centerName == NULL) centerName = @"";
        
        preview = @"";
        
        NSString* message = [NSString stringWithFormat:@"귀하의 KT 조직은\n'%@'\n이며 유지보수 센터는\n'%@'입니다.",summaryOrgName,centerName];
        [[ERPAlert getInstance] showMessage:message tag:0666 title1:@"닫기" title2:@"" isError:NO isCheckComplete:YES delegate:nil];
    }
}


#pragma  User define Action
- (IBAction)touchSubMemu:(id)sender {
    int nTag = [sender tag] % 10;
    
    NSString* message;
    
    //foler animation close
    AppDelegate *app = [AppDelegate sharedInstance];
    UINavigationController * controller = (UINavigationController*)app.window.rootViewController;
    
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    
    switch (currentOpenedMainMenu) {
        case 0: //납품/인계인수
            if (nTag == 0){ // 납품입고
                [Util udSetObject:@"납품입고" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //납품취소
                [Util udSetObject:@"납품취소" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 2){ //배송출고
                [Util udSetObject:@"배송출고" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 3){
                [Util udSetObject:@"인계" forKey:USER_WORK_NAME];
                [self pushViewController:@"TakeOverNRegEquip" viewName:@"TakeOverNRegEquipViewController" animated:YES];
                //TakeOverNRegEquipViewController* vc = [[TakeOverNRegEquipViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 4){
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"인수"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                [Util udSetObject:@"인수" forKey:USER_WORK_NAME];
                [self pushViewController:@"TakeOverNRegEquip" viewName:@"TakeOverNRegEquipViewController" animated:YES];
                //TakeOverNRegEquipViewController* vc = [[TakeOverNRegEquipViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 5){
                [Util udSetObject:@"시설등록" forKey:USER_WORK_NAME];
                [self pushViewController:@"TakeOverNRegEquip" viewName:@"TakeOverNRegEquipViewController" animated:YES];
                //TakeOverNRegEquipViewController* vc = [[TakeOverNRegEquipViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
        case 1: //유동관리
            if (nTag == 0){ //입고(팀내)
                [Util udSetObject:@"입고(팀내)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //출고(팀내)
                [Util udSetObject:@"출고(팀내)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 2){ //실장
                [Util udSetObject:@"실장" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 3){ //탈장
                [Util udSetObject:@"탈장" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 4){ //송부(팀간)
                [Util udSetObject:@"송부(팀간)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 5){ //송부취소(팀간)
                [Util udSetObject:@"송부취소(팀간)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 6){ //접수(팀간)
                [Util udSetObject:@"접수(팀간)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if(nTag == 7){ //형상구성(창고내)
                [Util udSetObject:@"형상구성(창고내)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if(nTag == 8){ //형상해제(창고내)
                [Util udSetObject:@"형상해제(창고내)" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
        case 2: // 인스토어마킹
            if (nTag == 0){ //바코드대체요청
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"바코드대체요청"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                // TODO :
                [Util udSetObject:@"바코드대체요청" forKey:USER_WORK_NAME];
                IMRequestViewController* vc = [[IMRequestViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 1){   // 부외실물등록요청
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"부외실물등록요청"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"부외실물등록요청" forKey:USER_WORK_NAME];
                EtcEquipmentViewController* vc = [[EtcEquipmentViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 2){   // 인스토어마킹완료
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"인스토어마킹완료"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"인스토어마킹완료" forKey:USER_WORK_NAME];
                CompleteScanViewController* vc = [[CompleteScanViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if(nTag == 3){ //인스토어마킹관리
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"인스토어마킹완료"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"인스토어마킹관리" forKey:USER_WORK_NAME];
                [self pushViewController:@"Barcode" viewName:@"BarcodeViewController1" animated:YES];
                //BarcodeViewController* vc = [[BarcodeViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
        case 3: //수리/개조개량
            if (nTag == 0){ //고장등록
                [Util udSetObject:@"고장등록" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //고장등록취소
                [Util udSetObject:@"고장등록취소" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 2){ //수리의뢰취소
                [Util udSetObject:@"수리의뢰취소" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 3){ //수리완료
                [Util udSetObject:@"수리완료" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 4){ //개조개량의뢰
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                [Util udSetObject:@"개조개량의뢰" forKey:USER_WORK_NAME];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 5){ //개조개량의뢰취소
                [Util udSetObject:@"개조개량의뢰취소" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 6){ //개조개량완료
                [Util udSetObject:@"개조개량완료" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
            
        case 5:
            if (nTag == 0){ //설비상태변경
                [Util udSetObject:@"설비상태변경" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //S/N변경
                [Util udSetObject:@"S/N변경" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController" animated:YES];
                //RevisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            
            break;
            
        case 6:
            if (nTag == 0){ //현장점검(창고/실)
                [Util udSetObject:@"현장점검(창고/실)" forKey:USER_WORK_NAME];
                [self pushViewController:@"SpotCheck" viewName:@"SpotCheckViewController" animated:YES];
                //SpotCheckViewController* vc = [[SpotCheckViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //현장점검(베이)
                [Util udSetObject:@"현장점검(베이)" forKey:USER_WORK_NAME];
                [self pushViewController:@"SpotCheck" viewName:@"SpotCheckViewController" animated:YES];
                //SpotCheckViewController* vc = [[SpotCheckViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 2){ //상품단말실사
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"상품단말실사"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"상품단말실사" forKey:USER_WORK_NAME];
                [self pushViewController:@"Revision" viewName:@"RevisionViewController8" animated:YES];
                //evisionViewController* vc = [[RevisionViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 3){ //임대단말실사
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"임대단말실사"];
                    
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"임대단말실사" forKey:USER_WORK_NAME];
                [self pushViewController:@"BuyOutInto" viewName:@"BuyOutIntoViewController" animated:YES];
                //BuyOutIntoViewController* vc = [[BuyOutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            
            break;
            
        case 7://정보조회 도우미
            if (nTag == 0){ //물품정보
                [Util udSetObject:@"물품정보" forKey:USER_WORK_NAME];
                [self pushViewController:@"Info" viewName:@"GoodsInfoViewController" animated:YES];
                //GoodsInfoViewController* vc = [[GoodsInfoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //설비정보
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"설비정보"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                [Util udSetObject:@"설비정보" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 2){ //장치바코드정보
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"장치바코드정보"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"장치바코드정보" forKey:USER_WORK_NAME];
                [self pushViewController:@"Info" viewName:@"DeviceInfoViewController" animated:YES];
                //DeviceInfoViewController* vc = [[DeviceInfoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 3){ //위치정보
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"장치바코드정보"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"위치정보" forKey:USER_WORK_NAME];
                [self pushViewController:@"Info" viewName:@"DeviceInfoViewController" animated:YES];
                //LocInfoViewController* vc = [[LocInfoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 4){ //고장정보
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"고장정보"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                [Util udSetObject:@"고장수리이력" forKey:USER_WORK_NAME];
                [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
                //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
        case 8://바코드관리
            if (nTag == 0){ //위치바코드
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"위치바코드"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                [Util udSetObject:@"위치바코드" forKey:USER_WORK_NAME];
                [self pushViewController:@"Barcode" viewName:@"BarcodeViewController2" animated:YES];
                //BarcodeViewController* vc = [[BarcodeViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            else if (nTag == 1){ //소스마킹
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"위치바코드"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                [Util udSetObject:@"장치바코드" forKey:USER_WORK_NAME];
                [self pushViewController:@"Barcode" viewName:@"BarcodeViewController3" animated:YES];
                //BarcodeViewController* vc = [[BarcodeViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }else if (nTag == 2){ //장치바코드
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"위치바코드"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                
                [Util udSetObject:@"소스마킹" forKey:USER_WORK_NAME];
                [self pushViewController:@"Barcode" viewName:@"BarcodeViewController4" animated:YES];
                //BarcodeViewController* vc = [[BarcodeViewController alloc] init];
                //[controller pushViewController:vc animated:YES];
            }
            break;
            
        case 9://BaseOa
            if (nTag == 0){ //신규등록
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"신규등록"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                // TODO :
                [Util udSetObject:@"신규등록[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 1){ //관리자변경
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"관리자변경"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                // TODO :
                [Util udSetObject:@"관리자변경[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 2){ //재물조사
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"재물조사"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"재물조사[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 3){ //불용요청
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"불용요청"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"불용요청[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 4){ //OA연식조회
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"OA연식조회"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"연식조회[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 5){ //납품확인
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"납품확인"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"납품확인[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 6){ //대여등록
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"대여등록"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"대여등록[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 7){ //대여반납
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"대여반납"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"대여반납[OA]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }
            break;
            
        case 10://BaseOe
            if (nTag == 0){ //신규등록
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"신규등록"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                // TODO :
                [Util udSetObject:@"신규등록[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 1){ //관리자변경
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"관리자변경"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return;
                }
                // TODO :
                [Util udSetObject:@"관리자변경[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 2){ //재물조사
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"재물조사"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"재물조사[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 3){ //불용요청
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"불용요청"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"불용요청[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 4){ //비품연식조회
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"비품연식조회"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"비품연식조회[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 5){ //납품확인
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"납품확인"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"납품확인[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 6){ //대여등록
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"대여등록"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"대여등록[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }else if (nTag == 7){ //대여반납
                if (isOffLine) {
                    message = [NSString stringWithFormat:@"'음역지역작업' 중에는\n '%@' 작업을\n하실 수 없습니다.",@"대여반납"];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    return;
                }
                // TODO :
                [Util udSetObject:@"대여반납[OE]" forKey:USER_WORK_NAME];
                BaseViewController* vc = [[BaseViewController alloc] init];
                [controller pushViewController:vc animated:YES];
            }
            break;
            
        case 11://설정
            if (nTag == 0){ //종료
                [Util udSetObject:@"종료" forKey:USER_WORK_NAME];
                exit(0);
            }
            break;
    }
}

- (IBAction)touchMainMenu:(id)sender {
    selectedMenu = [sender tag];
    NSInteger line = selectedMenu/3 + 1;    // 몇 번째 줄에 있는 메인메뉴인지 계산
    UIView* mainView = nil;
    
    currentOpenedMainMenu = selectedMenu;
    if (selectedMenu == 4){
        // 열려있는 다른 메인메뉴가 있다면 닫아준다.
        if (isAlreadyOpen)
            [self MenuCloseWithAnimation:NO];
        // 서브메뉴 오픈이 아니고, 바로 실행(철거, 설비상태 변경)
        [self doMainMenu:@"철거"];
    }
    //    else if (selectedMenu == 5){
    //        if (isAlreadyOpen)
    //            [self MenuCloseWithAnimation:NO];
    //        [self doMainMenu:@"설비상태변경"];
    //    }
    else{
        // 선택한 메인메뉴의 superview를 셋팅한다.
        if (selectedMenu == 0 || selectedMenu == 1 || selectedMenu == 2)
            mainView = viewMainMenu1;
        else if (selectedMenu == 3 || selectedMenu == 4 || selectedMenu == 5)
            mainView = viewMainMenu2;
        else if (selectedMenu == 6 || selectedMenu == 7 || selectedMenu == 8)
            mainView = viewMainMenu3;
        else
            mainView = viewMainMenu4;
        
        // 열려있는 메인메뉴가 없을 경우 선택한 메인메뉴 오픈
        if (!isAlreadyOpen){
            [self MenuOpenLine:line LineView:mainView selBtn:(UIButton*)sender];
            prevButton = (UIButton*)sender;
            prevMainMenuTag = selectedMenu;
        }
        // 이전에 선택한 메뉴와 현재 선택한 메뉴가 같다면 그냥 닫아준다.
        else if (prevMainMenuTag == selectedMenu)
            [self MenuCloseWithAnimation:YES];
        // 이전과 현재 선택이 다르다면 이전에 오픈되어있던 것은 닫아주고, 새로 선택한 메뉴를 열어준다.
        else{
            [self MenuCloseWithAnimation:NO];
            [self MenuOpenLine:line LineView:mainView selBtn:(UIButton*)sender];
            // 현재 선택한 버튼과 메뉴번호를 prevButton와 prevMainMenuTag에 각각 저장한다(다음번 처리에서는 이전 선택이 되기 때문)
            prevButton = (UIButton*)sender;
            prevMainMenuTag = selectedMenu;
        }
    }
}

#pragma mark - UIAlertViewDelegate
-(void) clickedButtonAtIndex:(NSInteger)buttonIndex alertView:(AlertViewController*)alertView;
// (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){ // 종료
        if (buttonIndex == 1)   return;
        
        LoginViewController* vc = [[LoginViewController alloc] init];
        [vc requestUserLogout];
        exit(0);
    }else if(alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

// 작업관리
- (IBAction)touchMangeWork:(id)sender {
    
    [self pushViewController:@"Main" viewName:@"WorkDataViewController" animated:YES];
    //WorkDataViewController* vc = [[WorkDataViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

// 설비정보조회
- (IBAction)touchFccInfo:(id)sender {
    //AppDelegate *app = [AppDelegate sharedInstance];
    //UINavigationController * controller = (UINavigationController*)app.window.rootViewController;
    
    [Util udSetObject:@"설비정보" forKey:USER_WORK_NAME];
    [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
    //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
    //[controller pushViewController:vc animated:YES];
}

// 환경설정
- (IBAction)touchSetup:(id)sender {
    [self pushViewController:@"Main" viewName:@"SettingViewController" animated:YES];
    //SettingViewController* vc = [[SettingViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

// 종료
- (IBAction)touchExit:(id)sender {
    NSString* message = @"종료하시겠습니까?";
    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
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

// 철거, 설비상태변경은 서브메뉴 없이 바로 실행
- (void)doMainMenu:(NSString*)job_gubun
{
    AppDelegate* app = [AppDelegate sharedInstance];
    UINavigationController * controller = (UINavigationController*)app.window.rootViewController;
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    
    [Util udSetObject:job_gubun forKey:USER_WORK_NAME];
    [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
    //OutIntoViewController* vc = [[OutIntoViewController alloc] init];
    //[controller pushViewController:vc animated:YES];
    
    return;
}

// 서브메뉴를 구성을 한다.
- (float)arrangeMenu
{
    int count = (int)self.subMenuView.subviews.count;
    for(int i= count - 1; i>=0; i--) {
        [self.subMenuView.subviews[i] removeFromSuperview];
    }
    
    CGRect rect = self.subMenuView.frame;
    
    float rate = rect.size.width / 320;
    float width = 90 * rate;
    float height = 35 * rate;
    float gap = (rect.size.width - (width * 3)) / 4;
    float y = 0;
    
    for (NSInteger i=0; i < subMenuList.count/2; i++){
        // 하나의 메뉴가 두개의 아이템(서브메뉴이름, 이미지 이름)을 갖고 있으므로
        NSInteger fileIndex = (2*i)+1;
        
        // 서브메뉴의 이름
        NSString* menuString = [subMenuList objectAtIndex:i];
        
        // 해당 메뉴의 이미지파일 이름
        NSString* fileName = [subMenuList objectAtIndex:fileIndex];
        
        CGRect frame = CGRectMake(gap + (gap + width) * (i % 3), gap + (gap + height) * (i / 3), width, height);
        UIButton* btn = [[UIButton alloc]initWithFrame:frame];
        [btn setBackgroundImage:[UIImage imageNamed:@"common_button_bg_gray.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"common_button_bg_red.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(touchSubMemu:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [subMenuView addSubview:btn];
        
        frame.origin.y += 12 * rate;
        frame.size.height = 11 * rate;
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:frame];
        [imgView setImage:[UIImage imageNamed:fileName]];
        [self.subMenuView addSubview:imgView];
        
        y = btn.frame.origin.y + btn.frame.size.height + gap;
    }
    return y;
    
    //olleh - font
//    for (NSInteger i=0; i < subMenuList.count; i++){
//        NSString* menuString = [subMenuList objectAtIndex:i];
//        UIButton * btn = (UIButton*)[viewSubMenu viewWithTag:10+i];
//        [btn setTitle:menuString forState:UIControlStateNormal];
//        btn.hidden = NO;
//        NSLog(@"nemu : %@", menuString);
//    }
//
//    for (NSInteger i = 0 ;i < 9 ; i++)
//    {
//        if (i <= [subMenuList count] - 1)
//            continue;
//        else {
//            UIButton * btn = (UIButton*)[viewSubMenu viewWithTag:10+i];
//            btn.hidden = YES;
//        }
//    }
    
    //1. array갯수 만큼 동적으로 버튼 생성(menulist.plist를 참조하여 메뉴를 구성한다.)
    // menulist.plist구성
    // =>title(메인메뉴이름), count(하위 서브메뉴의 갯수), submenu
    // submenu 구성
    // => 서브메뉴 이름, 이미지이름
//    for (NSInteger i=0; i < subMenuList.count/2; i++){
//        // 하나의 메뉴가 두개의 아이템(서브메뉴이름, 이미지 이름)을 갖고 있으므로
//        NSInteger fileIndex = (2*i)+1;
//
//        // 서브메뉴의 이름
//        NSString* menuString = [subMenuList objectAtIndex:i];
//
//        // 해당 메뉴의 이미지파일 이름
//        NSString* fileName = [subMenuList objectAtIndex:fileIndex];
//
//        // 각 버튼은 tag값을 통해서 접근한다.
//        UIButton * btn = (UIButton*)[viewSubMenu viewWithTag:10+i];
//        UIImageView* imgView = (UIImageView*)[viewSubMenu viewWithTag:20+i];
//        [imgView setImage:[UIImage imageNamed:fileName]];
//        [btn setTitle:menuString forState:UIControlStateNormal];
//        btn.hidden = NO;
//        imgView.hidden = NO;
//    }
//
//    // submenu의 갯수만큼의 버튼을 제외한 나머지는 모두 감춰준다.
//    for (NSInteger i = 0 ;i < 9 ; i++)
//    {
//        if (i <= [subMenuList count]/2-1)
//            continue;
//        else {
//            UIButton * btn = (UIButton*)[viewSubMenu viewWithTag:10+i];
//            UIImageView* imgView = (UIImageView*)[viewSubMenu viewWithTag:20+i];
//            btn.hidden = YES;
//            imgView.hidden = YES;
//        }
//    }
    
    
}


- (void)MenuOpenLine:(NSInteger)line LineView:(UIView*)mainView selBtn:(UIButton*)button
{
    [button setSelected:YES];
    //self.subMenuView.hidden = NO;
    //self.subMenuLayout.constant = 0;
    
    // 메인메뉴의 열리는 방향(위/아래)
    MenuMoveDirection direction = MENU_MOVE_DOWN;
    // 선택한 메인메뉴의 서브메뉴리스트를 subMenuList에 저장
    NSDictionary* menuDic = [menuList objectAtIndex:selectedMenu];
    subMenuList = [menuDic objectForKey:@"submenu"];
    
    float rate = self.view.frame.size.width / 320;
    bool expandUp = NO;
    self.subMenuView = self.viewMainSubMenu1;
    self.subMenuLayout = self.lcSubMenu1;
    if (line == 2) {
        self.subMenuView = self.viewMainSubMenu2;
        self.subMenuLayout = self.lcSubMenu2;
    }
    else if (line == 3) {
        self.subMenuView = self.viewMainSubMenu3;
        self.subMenuLayout = self.lcSubMenu3;
    }
    else if (line == 4) {
        CGRect frame = self.viewMainSubMenu4.frame;
        if (frame.origin.y + 150 * rate > self.view.frame.size.height - self.tabBar.frame.size.height) {
            self.subMenuView = self.viewMainSubMenu3;
            self.subMenuLayout = self.lcSubMenu3;
            expandUp = YES;
        } else {
            self.subMenuView = self.viewMainSubMenu4;
            self.subMenuLayout = self.lcSubMenu4;
        }
    }
    float y = [self arrangeMenu];
    self.subMenuLayout.constant = y;
    if (expandUp) self.lcMenu.constant = -y;
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    isAlreadyOpen = YES;
    
//    CGRect rect = viewMainMenu1.bounds;
//    NSLog(@"\nLineView %f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//    // 열리는 크기를 계산하는 과정
//    //olleh - font
//    NSInteger subMenuLineCount = subMenuList.count / 3;
//    if(subMenuList.count % 3 == 0){
//        subMenuLineCount = subMenuList.count / 3 - 1;
//    }
//
//    NSInteger subMenuLineCount = subMenuList.count / 7;
//    NSInteger posY = 0;
//    NSInteger movePos1 = VIEW1_POS_Y;
//    NSInteger movePos2 = VIEW2_POS_Y;
//    NSInteger movePos3 = VIEW3_POS_Y;
//    NSInteger movePos4 = VIEW4_POS_Y;
//    NSInteger moveSize = (40 * subMenuLineCount) + 55;
//
//    // 두번째 메인메뉴 선택시 4인치가 아니면 위로 열리고, 4인치이면 아래로 열린다(크기 차에 따른 하단부의 공간문제 때문)
//    if (line == 2 && !IS_4_INCH())
//        direction = MENU_MOVE_UP;
//    else if (line == 3 && !IS_4_INCH())
//        direction = MENU_MOVE_UP;
//    else if (line == 4)
//        direction = MENU_MOVE_UP;
//
//    // 원래 뷰의 위치 지정
//    switch (line) {
//        case 1:
//            posY = VIEW2_POS_Y - 1;
//            movePos2 = VIEW2_POS_Y + moveSize;
//            movePos3 = VIEW3_POS_Y + moveSize;
//            movePos4 = VIEW4_POS_Y + moveSize;
//            break;
//        case 2:
//            if (direction == MENU_MOVE_UP){
//                posY = VIEW3_POS_Y - 1 - moveSize;
//                movePos1 = VIEW1_POS_Y - moveSize;
//                movePos2 = VIEW2_POS_Y - moveSize;
//            }else{
//                posY = VIEW3_POS_Y - 1;
//                movePos3 = VIEW3_POS_Y + moveSize;
//                movePos4 = VIEW4_POS_Y + moveSize;
//            }
//            break;
//        case 3:
//            if (direction == MENU_MOVE_UP){
//                posY = VIEW4_POS_Y -1 - moveSize;
//                movePos1 = VIEW1_POS_Y - moveSize;
//                movePos2 = VIEW2_POS_Y - moveSize;
//                movePos3 = VIEW3_POS_Y - moveSize;
//            }else{
//                posY = VIEW4_POS_Y - 1;
//                movePos4 = VIEW4_POS_Y + moveSize;
//            }
//            break;
//        case 4:
//            posY = VIEW4_POS_Y -1 - moveSize;
//            movePos1 = VIEW1_POS_Y - moveSize;
//            movePos2 = VIEW2_POS_Y - moveSize;
//            movePos3 = VIEW3_POS_Y - moveSize;
//            break;
//        default:
//            break;
//    }
//
//    // 서브메뉴를 구성한다.
//    [self arrangeMenu];
//    //olleh - font
////    viewSubMenu.frame = CGRectMake(0, posY, 320, 0);
////    if ([subMenuList count] <= 3)
////        viewSubMenu.frame = CGRectMake(0, posY, 320, 55);
////    else if ([subMenuList count] > 3 && [subMenuList count] <=6)
////        viewSubMenu.frame = CGRectMake(0, posY, 320, 95);
////    else
////        viewSubMenu.frame = CGRectMake(0, posY, 320, 135);
//
//    CGRect frame = self.view.frame;
//    viewSubMenu.frame = CGRectMake(0, posY, frame.size.width, 0);
//    if ([subMenuList count]/2 <= 3)
//        viewSubMenu.frame = CGRectMake(0, posY, frame.size.width, 55);
//    else if ([subMenuList count]/2 > 3 && [subMenuList count]/2 <=6)
//        viewSubMenu.frame = CGRectMake(0, posY, frame.size.width, 95);
//    else
//        viewSubMenu.frame = CGRectMake(0, posY, frame.size.width, 135);
//
//    // 에니메이션 효과로 나태나도록 한다.
//    viewSubMenu.hidden = YES;
//    [self.view insertSubview:viewSubMenu aboveSubview:mainView];
//
//    CGRect frameView1 = viewMainMenu1.frame;
//    CGRect frameView2 = viewMainMenu2.frame;
//    CGRect frameView3 = viewMainMenu3.frame;
//    CGRect frameView4 = viewMainMenu4.frame;
//
//    // 이동 위치를 설정
//    frameView1.origin.y = movePos1;
//    frameView2.origin.y = movePos2;
//    frameView3.origin.y = movePos3;
//    frameView4.origin.y = movePos4;
//
//    [UIView animateWithDuration:0.3f
//                          delay:0.0f
//                        options:UIViewContentModeScaleToFill |UIViewContentModeScaleAspectFit
//                     animations:^{
//                         viewMainMenu1.frame = frameView1;
//                         viewMainMenu2.frame = frameView2;
//                         viewMainMenu3.frame = frameView3;
//                         viewMainMenu4.frame = frameView4;
//                     }
//                     completion:^(BOOL finished){
//                         viewSubMenu.hidden = NO;
//                     }];

    // 메인메뉴가 열렸다고 표시함
    //isAlreadyOpen = YES;
}

// 메인메뉴를 닫아준다
- (void)MenuCloseWithAnimation:(BOOL)isAnimation
{
    self.subMenuLayout.constant = 0;
    self.lcMenu.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewContentModeScaleToFill |UIViewContentModeScaleAspectFit
                     animations:^{
                         
                         //[self.subMenuView setHidden:YES];
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    [prevButton setSelected:NO];
    
//    if (!isAnimation) {
//        [self.subMenuView setHidden:YES];
//        [prevButton setSelected:NO];
//    } else {
//        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//                            options:UIViewContentModeScaleToFill |UIViewContentModeScaleAspectFit
//                         animations:^{
//                             [self.subMenuView setHidden:YES];
//                         }
//                         completion:^(BOOL finished){
//                             [prevButton setSelected:NO];
//                         }];
//    }
    
    
    
//    [viewSubMenu removeFromSuperview];
//
//    CGRect frameView1 = viewMainMenu1.frame;
//    CGRect frameView2 = viewMainMenu2.frame;
//    CGRect frameView3 = viewMainMenu3.frame;
//    CGRect frameView4 = viewMainMenu4.frame;
//
//    if (isAnimation){
//        // 에니메이션을 설정함
//        [UIView beginAnimations: nil context: NULL];
//        [UIView setAnimationDuration: 0.5];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    }
//
//    // 이동 위치를 설정
//    frameView1.origin.y = VIEW1_POS_Y;
//    frameView2.origin.y = VIEW2_POS_Y;
//    frameView3.origin.y = VIEW3_POS_Y;
//    frameView4.origin.y = VIEW4_POS_Y;
//
//    // 뷰에 적용함
//    viewMainMenu1.frame = frameView1;
//    viewMainMenu2.frame = frameView2;
//    viewMainMenu3.frame = frameView3;
//    viewMainMenu4.frame = frameView4;
//
//    if (isAnimation){
//        // 에니메이션을 시작함
//        [UIView commitAnimations];
//    }
//
    isAlreadyOpen = NO;
    prevMainMenuTag = -1;
    prevButton = nil;
}

#pragma mark - Http Request method
- (void) requestSearchOrg:(NSString*)rootOrgCode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEARCH_ORG;
    
    if (![indicatorView isAnimating])
    {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.frame = CGRectMake(PHONE_SCREEN_WIDTH/2-30, PHONE_SCREEN_HEIGHT/2-30, 60.0f, 60.0f);
        indicatorView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        indicatorView.layer.cornerRadius = 10.0f;
        indicatorView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:indicatorView];
        self.view.userInteractionEnabled = NO;
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [indicatorView startAnimating];
    }
    
    [requestMgr requestSearchRootOrgCode:rootOrgCode];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    if (indicatorView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
        self.view.userInteractionEnabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (pid == REQUEST_SAP_FCC_COD){
                if ([message hasPrefix:@"데이터가 존재하지 않습니다."])
                    message = @"하위 설비가 존재하지 않습니다.";
            }
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
        return;
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
        
        return;
    }
    
    if (pid == REQUEST_SEARCH_ORG){
        [self processSearchOrg:resultList];
    }
}

- (void)processSearchOrg:(NSArray*)resultList
{
    NSMutableArray* orgList = [NSMutableArray array];
    
    if(resultList.count){
        BOOL isTFT = NO;
        for (NSDictionary* dic in resultList){
            NSMutableDictionary* orgDic = [NSMutableDictionary dictionary];
            NSString* orgCode = [dic objectForKey:@"orgCode"];
            NSArray* filterArray = [orgCode componentsSeparatedByString:@"@"];
            NSString* orgName = [dic objectForKey:@"orgName"];
            
            [orgDic setObject:[filterArray objectAtIndex:0] forKey:@"orgCode"];
            [orgDic setObject:[dic objectForKey:@"orgName"] forKey:@"orgName"];
            [orgDic setObject:[dic objectForKey:@"parentOrgCode"] forKey:@"parentOrgCode"];
            [orgDic setObject:[dic objectForKey:@"costCenter"] forKey:@"costCenter"];
            [orgDic setObject:[dic objectForKey:@"orgLevel"] forKey:@"orgLevel"];
            [orgDic setObject:[NSNumber numberWithInteger:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [orgList addObject:orgDic];
            
            if ([orgName rangeOfString:@"TFT"].length > 0)
                isTFT = YES;
        }
        
        //최상의 루트 추가
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:@"000001" forKey:@"orgCode"];
        [dic setObject:@"주식회사 케이티" forKey:@"orgName"];
        [dic setObject:@"" forKey:@"parentOrgCode"];
        [dic setObject:@"C000001" forKey:@"costCenter"];
        [dic setObject:@"1" forKey:@"orgLevel"];
        [dic setObject:[NSNumber numberWithInteger:SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
        if (isTFT)
            [dic setObject:@"1" forKey:@"HAS_TFT"];
        else
            [dic setObject:@"0" forKey:@"HAS_TFT"];
        
        [orgList insertObject:dic atIndex:0];
        
        // 조직도 userDefault에 저장
        [Util udSetObject:orgList forKey:LIST_ORG];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if(item.tag == 0) {
        
        [self pushViewController:@"Main" viewName:@"WorkDataViewController" animated:YES];
    }
    else if(item.tag == 1) {
        
        [Util udSetObject:@"설비정보" forKey:USER_WORK_NAME];
        [self goOutIntoView:[Util udObjectForKey:USER_WORK_NAME]];
    }
    else if(item.tag == 2) {
       
        [self pushViewController:@"Main" viewName:@"SettingViewController" animated:YES];

    }
    else if(item.tag == 3) {
        
        NSString* message = @"종료하시겠습니까?";
        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
    }
}
@end


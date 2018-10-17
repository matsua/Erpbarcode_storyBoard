//
//  LoginViewController.m
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "NoticeViewController.h"
#import "AppDelegate.h"
#import "NSDate+Addition.h"
#import "NSData+AESAdditions.h"
#import "SelfCertificationViewController.h"
#import "ChangePasswordViewController.h"
#import "ResetPasswordController.h"
#import "PersonalInfoAgreeController.h"

#define AESSecretKey @"<ERPBarcode>"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgLaunch;
@property (strong, nonatomic) IBOutlet UITextField* textID;
@property (strong, nonatomic) IBOutlet UITextField* textPW;
@property (nonatomic,strong) IBOutlet UIButton* btnOffLine;
@property (strong, nonatomic) IBOutlet UILabel *lblOffLine;

@property (nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property (assign, nonatomic) NSInteger touchCount;
@property (strong, nonatomic) NSArray* noticeResultList;
@property (assign, nonatomic) BOOL isQA;
@property (assign, nonatomic) BOOL isOffLine;
@property (assign, nonatomic) BOOL passwordChange;
@property (assign, nonatomic) BOOL isDuplicateLoginPass;
@property (assign, nonatomic) BOOL is_auth_need;

- (NSString*) encryptString:(NSString*)plaintext withKey:(NSString*)key;
- (NSString*) decryptString:(NSString*)ciphertext withKey:(NSString*)key;

@end

@implementation LoginViewController
@synthesize imgLaunch;
@synthesize indicatorView;
@synthesize textID;
@synthesize textPW;
@synthesize btnOffLine;
@synthesize lblOffLine;
@synthesize touchCount;
@synthesize isQA;
@synthesize isOffLine;
@synthesize passwordChange;
@synthesize noticeResultList;
@synthesize isDuplicateLoginPass;
@synthesize is_auth_need;

///////////////////////////////////////////////////////////////////////
// ** 로그인 과정
// 1. 아이디, 패스워드 인증
// 2. 버전체크 => 업데이트 있으면 status = 1 없으면 status = 0 or 2 메시지로 체크
// 3. 공지사항 체크
// 4. 본인인증 체크
// 5. 보인인증이 필요하면 본인인증 요청하고, 필요 없으면 메인화면으로 이동한다.
//
// 6. 3개월 주기로 비밀번호 재설정  2016.12 월 추가 요구사항
// 7. 매접속시 개인인증으로 변경 2017.09.27
///////////////////////////////////////////////////////////////////////
#pragma mark - ViewLife Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define LAUNCHIMAGE
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"로그인";
    // 테스트 커밋
    // 이전 로그인한 id/pw를 textfield에 표시한다.
    NSString* userid = [Util udObjectForKey:USER_ID];
    if (userid.length){
        textID.text = userid;
    }
    
    // QA와 Real 서버 전환을 위함
    touchCount = 0;
    isQA = NO;
    
    //중복 로그인 패스 구분값.
    isDuplicateLoginPass = NO;
    
    //개인인증 여부
    is_auth_need = NO;
    
    // 음영지역 작업 여부 저장
    [Util udSetObject:[NSNumber numberWithBool:btnOffLine.selected] forKey:USER_OFFLINE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


#pragma mark - User Define Method
- (void) showIndicator
{
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
}

- (void) hideIndicator
{
    if (indicatorView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
        self.view.userInteractionEnabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
}

- (void) doAfterLogin
{
    NSDictionary* userDic = [Util udObjectForKey:USER_INFO];
    NSString* is_passwdUd_need = [userDic objectForKey:@"passwdUpdateYn"];
    NSString *agree1 = [Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE1"];
    NSString *agree3 = [Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE3"];
    
    if([[userDic objectForKey:@"confirmationYn"] isEqualToString:@"Y"]){
        is_auth_need = YES;
    }
    
    if(agree1 == nil){
        [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE1" value:@"0"];
        [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE2" value:@"0"];
        agree1 = [Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE1"];
    }
    
    if(agree3 == nil){
        [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE3" value:@"0"];
        [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE4" value:@"0"];
        agree3 = [Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE3"];
    }
    
    if (!is_auth_need){ //개인인증
        SelfCertificationViewController* view = [[SelfCertificationViewController alloc] init];
        view.certificationDelegate = self;
        [self.navigationController pushViewController:view animated:NO];
    }else if([agree1 isEqualToString:@"0"] || [agree3 isEqualToString:@"0"]){ //약관 동의
        PersonalInfoAgreeController* view = [[PersonalInfoAgreeController alloc] init];
        view.agreeDeligate = self;
        [self.navigationController pushViewController:view animated:NO];
    }else if ([is_passwdUd_need isEqualToString:@"Y"]){ //패스워드 재설정 필요
        ResetPasswordController* view = [[ResetPasswordController alloc] init];
        view.gb = @"update";
        [self.navigationController pushViewController:view animated:NO];
    }else if(noticeResultList != nil && noticeResultList.count){
        NSString* strSqlQuery = [NSString stringWithFormat:SELECT_GET_NOTICE_ITEM,[NSDate TodayString]];
        NSArray* dbNoticeList = [[DBManager sharedInstance] executeSelectQuery:strSqlQuery];
        if (!dbNoticeList.count){ //최초 접속한 경우나 체크안했을 경우는 무조건 공지 띄운다.
            NoticeViewController* view = [[NoticeViewController alloc] init];
            view.noticeDeligate = self;
            view.noticeList = noticeResultList;
            [self.navigationController pushViewController:view animated:NO];
        }else{
            [self startServiceMenu];
        }
    }else{
        [self startServiceMenu];
    }
}

//메인화면 이동
-(void)startServiceMenu{
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* nc = [sb instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
    
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = nc;
    
//    MainMenuViewController* view = [[MainMenuViewController alloc] init];
//    view.preview = @"LOGIN";
//    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:view];
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.window.rootViewController = navi;
}

#pragma INoticeConfirm delegate -- call by NoticeViewController
- (void)noticeConfirm{
    [self startServiceMenu];
}

#pragma IUserAgree delegate -- call by PersonalInfoAgreeController
- (void)userAgree:(BOOL)agree{
    if(agree){
        [self doAfterLogin];
    }
}

#pragma ICertificationInfo delegate -- call by SelfCertificationViewController
- (void)certificationInfo:(BOOL)certification{
    if(certification){
        NSDictionary* userDic = [Util udObjectForKey:USER_INFO];
        NSMutableDictionary* tempUserDic = [NSMutableDictionary dictionary];
        [tempUserDic setObject:[userDic objectForKey:@"userId"] forKey:@"userId"];
        [tempUserDic setObject:[userDic objectForKey:@"userName"] forKey:@"userName"];
        [tempUserDic setObject:[userDic objectForKey:@"userCellPhoneNo"] forKey:@"userCellPhoneNo"];
        [tempUserDic setObject:[userDic objectForKey:@"orgId"] forKey:@"orgId"];
        [tempUserDic setObject:[userDic objectForKey:@"orgName"] forKey:@"orgName"];
        [tempUserDic setObject:[userDic objectForKey:@"orgCode"] forKey:@"orgCode"];
        [tempUserDic setObject:[userDic objectForKey:@"orgTypeCode"] forKey:@"orgTypeCode"];
        [tempUserDic setObject:[userDic objectForKey:@"sessionId"] forKey:@"sessionId"];
        [tempUserDic setObject:[userDic objectForKey:@"empNumber"] forKey:@"empNumber"];
        [tempUserDic setObject:@"Y" forKey:@"confirmationYn"];
        [tempUserDic setObject:[userDic objectForKey:@"passwdUpdateYn"] forKey:@"passwdUpdateYn"];
        [tempUserDic setObject:[userDic objectForKey:@"centerId"] forKey:@"centerId"];
        [tempUserDic setObject:[userDic objectForKey:@"summaryOrg"] forKey:@"summaryOrg"];
        [tempUserDic setObject:[userDic objectForKey:@"centerName"] forKey:@"centerName"];
        
        [Util udSetObject:tempUserDic forKey:USER_INFO];
        is_auth_need = YES;
        [self doAfterLogin];
    }else{
        textPW.text = @"";
        [self requestUserLogout];
    }
}

// 로그인한 id가 이전 로그인 기록에 있는지 체크, 없으면 insert 있으면 update하기 위해서...
- (BOOL)isExistInDBUSerId:(NSString*)userId
{
    NSString* strQuery = [NSString stringWithFormat:@"SELECT COUNT(USER_ID) FROM USER_INFO_LIST WHERE USER_ID = '%@'", [self encryptString:userId withKey:AESSecretKey]];
    
    int count = [[DBManager sharedInstance] countSelectQuery:strQuery];
    if (count <= 0)
        return NO;
    
    return  YES;
}

// 인증된 id와 사용자 정보를 DB에 저장한다.
// 음영지역 로그인시 DB를 참조하여 인증한다.
- (BOOL) saveUserInfoToDB
{
    BOOL isSucc = NO;
    
    sqlite3 *dbObject = [[DBManager sharedInstance] getDatabaseObject];
    
    char* errorMessage;
    sqlite3_exec(dbObject, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
    
    sqlite3_stmt* stmt;
    
    const char *sqlQuery;
    NSDictionary* userInfoDic = [Util udObjectForKey:USER_INFO];
    if(userInfoDic == nil)
        return NO;
    
    NSString *userPasswd = [self encryptString:[Util udObjectForKey:USER_PW] withKey:AESSecretKey];
    if ([userPasswd isKindOfClass:[NSNull class]])
        return NO;
    
    NSString* userId = [self encryptString:[userInfoDic objectForKey:@"userId"] withKey:AESSecretKey];
    if ([userId isKindOfClass:[NSNull class]])
        return NO;
    
    NSString* userName = [self encryptString:[userInfoDic objectForKey:@"userName"] withKey:AESSecretKey];
    if ([userName isKindOfClass:[NSNull class]])
        userName = @"";
    
    NSString* telno = [self encryptString:[userInfoDic objectForKey:@"userCellPhoneNo"] withKey:AESSecretKey];
    if ([telno isKindOfClass:[NSNull class]])
        telno = @"";
    
    NSString* orgCode = [self encryptString:[userInfoDic objectForKey:@"userCellPhoneNo"] withKey:AESSecretKey];
    if ([orgCode isKindOfClass:[NSNull class]])
        orgCode = @"";
    
    NSString* orgName = [self encryptString:[userInfoDic objectForKey:@"orgName"] withKey:AESSecretKey];
    if ([orgName isKindOfClass:[NSNull class]])
        orgName = @"";
    
    NSString* cdate = [NSDate DateTimeString];
    
    // 이전 로그인 히스토리에 있는지 체크하여 업데이트할 것인지 인서트할것인지 결정
    if ([self isExistInDBUSerId:[self encryptString:[Util udObjectForKey:USER_ID] withKey:AESSecretKey]]){
        NSString* strQuery = [NSString stringWithFormat:UPDATE_USER_INFO_LIST, userId, userName, userPasswd, orgCode, orgName, telno, cdate, [self encryptString:[Util udObjectForKey:USER_ID] withKey:AESSecretKey]];
        sqlQuery = [strQuery UTF8String];
    }
    else{
        NSString* strQuery = [NSString stringWithFormat:INSERT_USER_INFO_LIST, userId, userName, userPasswd, orgCode, orgName, telno, cdate];
        
        sqlQuery = [strQuery UTF8String];
    }
    
    
    int sqlReturn = sqlite3_prepare_v2(dbObject, sqlQuery, (int)strlen(sqlQuery), &stmt, NULL);
    
    
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: '%s'.", sqlite3_errmsg(dbObject));
    }
    
    if (sqlite3_step(stmt) != SQLITE_DONE)
    {
        NSLog(@"failed to sqlite3_step - error : %d\n dic[%@]", sqlite3_step(stmt),userInfoDic);
        isSucc = NO;
    }
    else
    {
        sqlite3_reset(stmt);
        isSucc = YES;
    }
    sqlite3_exec(dbObject, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    sqlite3_finalize(stmt);
    
    return isSucc;
}

#pragma mark - User Action Method
- (IBAction)touchedCheckButton:(id)sender //음영지역
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    isOffLine = btn.selected;
    
    if (btn.selected){
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:nil
                           message:@"'음영지역작업'은 음영지역에서\n스캔한 바코드를 저장한 후\n네트워크 접속을 통하여\n저장한 자료를 불러와서\n전송하는 기능입니다.\n계속하시겠습니까?"
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"예",@"아니오",nil];
        av.tag = 100;
        [av show];
        [Util playSoundWithMessage:@"'음영지역작업'은 음영지역에서\n스캔한 바코드를 저장한 후\n네트워크 접속을 통하여\n저장한 자료를 불러와서\n전송하는 기능입니다.\n계속하시겠습니까?" isError:NO];
    }else{
        [Util udSetObject:[NSNumber numberWithBool:btnOffLine.selected] forKey:USER_OFFLINE];
    }
}

- (IBAction)touchedLogin:(id)sender
{
    [textID resignFirstResponder];
    [textPW resignFirstResponder];
    passwordChange = NO;
    
    textPW.text = @"qkzhem@1";
    
    if([textID.text length] > 0 && [textPW.text isEqualToString:@"1234!"]){
        passwordChange = YES;
    }
    
    if ([textID.text length] == 0 ){
        NSString* message = @"아이디를 입력하세요.";
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:nil
                           message:message
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [av show];
        [Util playSoundWithMessage:message isError:YES];
    }
    else if ([textPW.text length] == 0 ){
        NSString* message = @"비밀번호를 입력하세요.";
        
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:nil
                           message:message
                           delegate:nil
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [av show];
        [Util playSoundWithMessage:message isError:YES];
    }else {
        //음영지역일때 db에서 체크
        //"'음영지역작업' 으로 로그인 할 수 있는 계정이 아닙니다."
        if (isOffLine){
            BOOL isLoginOk = NO;
            NSString* userId = textID.text;
            NSString* passwd = textPW.text;
            
            // 해당 아이디가 이전에 로그인한 히스토리가 있다면 그 패스워드와 비교하여 인증한다.
            NSString* strQuery = [NSString stringWithFormat:@"%@ WHERE USER_ID = '%@'", SELECT_USER_INFO_LIST, [self encryptString:userId withKey:AESSecretKey]];
            NSArray* userInfoList = [[DBManager sharedInstance] executeSelectQuery:strQuery];
            if (userInfoList != nil && userInfoList.count){
                NSDictionary* userInfoDic = [userInfoList objectAtIndex:0];
                
                if (userInfoDic != nil &&
                    [[userInfoDic objectForKey:@"USER_PASSWD"] isEqualToString:[self encryptString:passwd withKey:AESSecretKey]]){
                    //사용자 로그인정보 저장
                    NSString* userName = @"";
                    if (![[userInfoDic objectForKey:@"USER_NAME"] isKindOfClass:[NSNull class]])
                        userName = [userInfoDic objectForKey:@"USER_NAME"];
                    
                    NSString* telNo = @"";
                    if (![[userInfoDic objectForKey:@"TEL_NO"] isKindOfClass:[NSNull class]])
                        telNo = [userInfoDic objectForKey:@"TEL_NO"];
                    
                    NSString* orgCode = @"";
                    if (![[userInfoDic objectForKey:@"ORG_CODE"] isKindOfClass:[NSNull class]])
                        orgCode = [userInfoDic objectForKey:@"ORG_CODE"];
                    
                    NSString* orgName = @"";
                    if (![[userInfoDic objectForKey:@"ORG_NAME"] isKindOfClass:[NSNull class]])
                        orgName = [userInfoDic objectForKey:@"ORG_NAME"];
                    
                    NSMutableDictionary* newInfoDic = [NSMutableDictionary dictionary];
                    [newInfoDic setObject:userId forKey:@"userId"];
                    [newInfoDic setObject:[self decryptString:userName withKey:AESSecretKey] forKey:@"userName"];
                    [newInfoDic setObject:[self decryptString:telNo withKey:AESSecretKey] forKey:@"userCellPhoneNo"];
                    [newInfoDic setObject:[self decryptString:orgCode withKey:AESSecretKey]  forKey:@"orgId"];
                    [newInfoDic setObject:[self decryptString:orgName withKey:AESSecretKey]  forKey:@"orgName"];
                    [newInfoDic setObject:@"" forKey:@"orgCode"];
                    [newInfoDic setObject:@"" forKey:@"orgTypeCode"];
                    [newInfoDic setObject:@"" forKey:@"sessionId"];
                    [newInfoDic setObject:@"" forKey:@"empNumber"];
                    [newInfoDic setObject:@"" forKey:@"confirmationYn"];
                    
                    [Util udSetObject:newInfoDic forKey:USER_INFO];
                    
                    //아이디,패스워드 저장
                    [Util udSetObject:passwd forKey:USER_PW];
                    [Util udSetObject:userId forKey:USER_ID];
                    
                    [Util udSetObject:@"https://erpbarcodepda.kt.com/nbase" forKey:BARCODE_SERVER];
                    [Util udSetObject:@"REAL" forKey:BARCODE_SERVER_ID];
                    
                    //메인화면 이동
                    NSLog(@"=====userDic USER_PASSWD %@, USER_ID %@, userName %@, userCellPhoneNo %@, orgId %@, orgName %@, orgCode %@, orgTypeCode %@, sessionId %@, empNumber %@, confirmationYn %@",
                          [userInfoDic objectForKey:@"USER_PASSWD"],
                          [userInfoDic objectForKey:@"userId"],
                          [userInfoDic objectForKey:@"userName"],
                          [userInfoDic objectForKey:@"userCellPhoneNo"],
                          [userInfoDic objectForKey:@"orgId"],
                          [userInfoDic objectForKey:@"orgName"],
                          [userInfoDic objectForKey:@"orgCode"],
                          [userInfoDic objectForKey:@"orgTypeCode"],
                          [userInfoDic objectForKey:@"sessionId"],
                          [userInfoDic objectForKey:@"empNumber"],
                          [userInfoDic objectForKey:@"confirmationYn"]);
                    
                    MainMenuViewController* vc = [[MainMenuViewController alloc] init];
                    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
                    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    appDelegate.window.rootViewController = navi;
                    
                    isLoginOk = YES;
                }
            }
            if (!isLoginOk)
            {
                NSString* message = @"'음영지역작업' 으로 로그인 할 수 있는 계정이 아닙니다.";
                UIAlertView* av = [[UIAlertView alloc]
                                   initWithTitle:nil
                                   message:message
                                   delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"닫기", nil];
                [av show];
                [Util playSoundWithMessage:message isError:YES];
            }
        }else{  // 음영지역 작업이 아닌경우 서버로부터 인증 요구
            if (isQA){
                [Util udSetObject:@"https://nbaseqa.kt.com/nbase" forKey:BARCODE_SERVER];
                [Util udSetObject:@"QA" forKey:BARCODE_SERVER_ID];
            }else{
                [Util udSetObject:@"https://erpbarcodepda.kt.com/nbase" forKey:BARCODE_SERVER];
                [Util udSetObject:@"REAL" forKey:BARCODE_SERVER_ID];
            }
            
            [Util udSetObject:@"0" forKey:INPUT_MODE];
            [self requestUserLogin];
        }
    }
}

// 운영서버와 QA서버 전환을 위한 이벤트 처리
- (IBAction)touchBackground:(id)sender
{
    [textID resignFirstResponder];
    [textPW resignFirstResponder];

    touchCount++;
    NSString* message = nil;
    if (touchCount == 5){
        if (isQA){
            isQA = NO;
            message = @"운영서버로 전환되었습니다.";
        }else{
            isQA = YES;
            message = @"QA서버로 전환되었습니다.";
        }
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:message
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [av show];
        [Util playSoundWithMessage:message isError:NO];

        touchCount = 0;
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    // "'음영지역작업'은 음영지역에서\n스캔한 바코드를 저장한 후\n네트워크 접속을 통하여\n저장한 자료를 불러와서\n전송하는 기능입니다.\n계속하시겠습니까?"
    if (alertView.tag == 100){
        if (buttonIndex == 0){ //음영지역 작업 계속
        }else{
            btnOffLine.selected = NO;
        }
        //userDefault에 저장
        isOffLine = btnOffLine.selected;
        [Util udSetObject:[NSNumber numberWithBool:btnOffLine.selected] forKey:USER_OFFLINE];
    }
    else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            //logout 처리
            [self requestUserLogout];
            LoginViewController* vc = [[LoginViewController alloc] init];
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:vc];
            AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = navi;
        }
    }
    else if(alertView.tag == 9999){
        if (buttonIndex == 0){
            if(isDuplicateLoginPass){
                [self requestUserLogout];
            }
        }
    }
    else if(alertView.tag == 4477){
        [self doAfterLogin];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Http Request Method
-(void) requestVersion
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_VERSION;
    
    [self performSelector:@selector(showIndicator) withObject:nil afterDelay:NO];
    
    NSString* devVersionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"KDC350" forKey:@"MODEL_ID"];
    [paramDic setObject:@"I" forKey:@"PGM_ID"];
    [paramDic setObject:devVersionNumber forKey:@"VERSION"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_VERSION withData:rootDic];
}

- (void)requestUserLogin
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOGIN;
    requestMgr.changePassword = passwordChange;
    
    [self performSelector:@selector(showIndicator) withObject:nil afterDelay:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:textID.text forKey:@"userId"];
    [paramDic setObject:textPW.text forKey:@"userPassword"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_LOGIN withData:rootDic];
}

- (void)requestSetUserInfo
{
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = [identifierForVendor UUIDString];
    NSString *osVer = [UIDevice currentDevice].systemVersion;
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SET_USER_INFO;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:textID.text forKey:@"userId"];
    [paramDic setObject:@"" forKey:@"userPassword"];
    [paramDic setObject:uuid forKey:@"loginDevId"];
    [paramDic setObject:[NSString stringWithFormat:@"IOS %@",osVer] forKey:@"loginDev"];
    [paramDic setObject:@"" forKey:@"loginDevNumber"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_USER_DEV withData:rootDic];
}

- (void)requestUserLogout
{
    NSString *userId = [[Util udObjectForKey:USER_INFO] objectForKey:@"userId"];
    if([userId isEqualToString:@""] || userId == nil){
        userId = textID.text;
    }
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOGOUT;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:userId forKey:@"userId"];
    
    NSDictionary* bodyDic = [Util noneMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_LOGOUT withData:bodyDic];
}

- (void)requestGetNotice
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GET_NOTICE;
    noticeResultList = [[NSArray alloc] init];
    
    [self performSelector:@selector(showIndicator) withObject:nil afterDelay:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:textID.text forKey:@"userId"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_GET_NOTICE withData:rootDic];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (![message hasPrefix:@"현재 버전이 최신"] && ![message hasPrefix:@"버젼이 낮아 접속하실 수 없습니다"] && [message rangeOfString:@"현재 접속중"].length < 1){
                UIAlertView* av = [[UIAlertView alloc]
                                   initWithTitle:@"알림"
                                   message:message
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"닫기", nil];
                [av show];
                [Util playSoundWithMessage:message isError:YES];
            }
            
            if([message rangeOfString:@"현재 접속중"].length > 0){
                if([message rangeOfString:@"/"].length > 0){
                    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
                    NSString *uuid = [identifierForVendor UUIDString];
                    NSArray *messagesArr = [message componentsSeparatedByString:@"/"];
                    if([messagesArr[1]isEqualToString:uuid] || [messagesArr[1]isEqualToString:@""] || [messagesArr[1]isEqualToString:@"null"]){
                        message = @"비정상 종료 기록이 있습니다. \n\r로그아웃을 진행합니다. \n\r재로그인 해주세요.";
                        isDuplicateLoginPass = YES;
                    }else{
                        message = messagesArr[0];
                        isDuplicateLoginPass = NO;
                    }
                }
                
                UIAlertView* av = [[UIAlertView alloc]
                                   initWithTitle:@"알림"
                                   message:message
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"확인", nil];
                av.tag = 9999;
                [av show];
                
            }
        }
        
        // 공지사항 요청
        if (pid == REQUEST_VERSION)
            [self requestGetNotice];
        
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:message
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"예",@"아니오" ,nil];
        av.tag = 2000;
        [av show];
        [Util playSoundWithMessage:message isError:YES];
    }
    else if (status == 3){
        NSString* message = @"KT 조직이 '케이티'인 경우\n로그인 하실 수 없습니다.\nIDMS에서 조직 정보를 변경하신 후\n사용하시기 바랍니다.\n문의처 : ISC(1588-3391)";
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:message
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        av.tag = 3000;
        [av show];
        [Util playSoundWithMessage:message isError:YES];
    }
    else{
        if(passwordChange){
            ChangePasswordViewController *modalView = [[ChangePasswordViewController alloc] init];
            [self presentViewController:modalView animated:YES completion:nil];
            passwordChange = false;
            return;
        }
        
        if (pid == REQUEST_VERSION){
            [self processVersionResponse:resultList];
        }
        else if (pid == REQUEST_LOGIN){
            [self requestSetUserInfo];
        }else if(pid == REQUEST_SET_USER_INFO){
            [self processLoginResponse];
        }else if (pid == REQUEST_GET_NOTICE){
            noticeResultList = resultList;
            [self doAfterLogin];
        }else if(pid == REQUEST_LOGOUT && isDuplicateLoginPass){
            isDuplicateLoginPass = NO;
        }
    }
}

- (void)processVersionResponse:(NSArray*)resultList
{
    if (resultList.count){
        NSString* message = @"프로그램이 변경되어 설치 페이지로 이동합니다.";
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:message
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"이동",nil];
        [Util playSoundWithMessage:message isError:NO];
        [av show];
        
        [Util udSetBool:NO forKey:IS_ALERT_COMPLETE];
        
        //버튼 누르기전까지 지연.
        while (![Util udBoolForKey:IS_ALERT_COMPLETE])
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        
        // 설치 프로그램이 있는 URL로 이동한다.
        if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NEW_QA_VERSION_URL]];
        else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NEW_VERSION_URL]];
        
        [self requestUserLogout];
    }
}

- (void)processLoginResponse
{
    //아이디 저장
    [Util udSetObject:textID.text forKey:USER_ID];
    [Util udSetObject:textPW.text forKey:USER_PW];
    
    //user_info_list db에 저장
    //1. user_id db에 있는지 체크 replace or insert
    if([self saveUserInfoToDB])
        NSLog(@"사용자 정보를 DB에 저장하였습니다.");
    else
        NSLog(@"사용자 정보를 DB에 저장하는데 실패 하였습니다.");
    
    // 버전 체크
    [self requestVersion];
}

-(IBAction)resetPassword:(id)sender
{
    ResetPasswordController* modalView = [[ResetPasswordController alloc] init];
    [self.navigationController pushViewController:modalView animated:NO];
}

- (NSString*) encryptString:(NSString*)plaintext withKey:(NSString*)key {
    NSData *temp = [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    return [temp base64EncodedStringWithOptions:0];
}
- (NSString*) decryptString:(NSString*)ciphertext withKey:(NSString*)key {
    NSData *temp = [[NSData alloc] initWithBase64EncodedString:ciphertext options:0];
    return [[NSString alloc] initWithData:[temp AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
}

@end

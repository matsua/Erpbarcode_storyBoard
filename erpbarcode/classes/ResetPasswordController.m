//
//  ResetPasswordController.m
//  erpbarcode
//
//  Created by matsua on 2016. 6. 9..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import "ResetPasswordController.h"
#import "ERPRequestManager.h"

@interface ResetPasswordController ()
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property(nonatomic,strong) IBOutlet UIView *inputView;
@property(nonatomic,strong) IBOutlet UIView *passwordView;
@property(nonatomic,strong) IBOutlet UIView *commentView;
@property(nonatomic,strong) IBOutlet UITextField* userId;
@property(nonatomic,strong) IBOutlet UITextField* userPhoneNum;
@property(nonatomic,strong) IBOutlet UITextField* userEmail;
@property(nonatomic,strong) IBOutlet UITextField* userAuth;
@property(nonatomic,strong) IBOutlet UITextField* password;
@property(nonatomic,strong) IBOutlet UITextField* confirmPassword;
@property(nonatomic,strong) IBOutlet UILabel* lblTimer;
@property(nonatomic,assign) BOOL isRequesting;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,assign) int timeCount;
@property(nonatomic,strong) NSString *certificationNum;

@end

@implementation ResetPasswordController
@synthesize inputView;
@synthesize passwordView;
@synthesize commentView;
@synthesize indicatorView;
@synthesize userId;
@synthesize userPhoneNum;
@synthesize userEmail;
@synthesize userAuth;
@synthesize password;
@synthesize confirmPassword;
@synthesize lblTimer;
@synthesize isRequesting;
@synthesize timeCount;
@synthesize timer;
@synthesize certificationNum;

@synthesize gb;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    if(gb){
        self.title = @"비빌번호 변경";
        passwordView.hidden = NO;
        passwordView.frame = CGRectMake(inputView.frame.origin.x, inputView.frame.origin.y, passwordView.frame.size.width, passwordView.frame.size.height);
        
        inputView.hidden = YES;
        commentView.hidden = YES;
        
        UIAlertView* am = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:@"3개월 이상 동일한 패스워드를 사용 중입니다.\n패스워드를 변경 하셔야 시스템 이용이 가능 합니다."
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [am show];
        return;
    }else{
        self.title = @"비빌번호 초기화";
    }
    
    [self infoInit];
}

-(void)infoInit
{
    userId.text = @"";
    userPhoneNum.text = @"";
    userEmail.text = @"";
    userAuth.text = @"";
    lblTimer.text = @"";
    password.text = @"";
    confirmPassword.text = @"";
    certificationNum = @"";
    
    passwordView.hidden = YES;
    commentView.frame = CGRectMake(commentView.frame.origin.x, inputView.frame.origin.y + inputView.frame.size.height, commentView.frame.size.width, commentView.frame.size.height);
}

#pragma mark -  User Define Action
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)startTimer
{
    userAuth.enabled = YES;
    isRequesting = YES;
    timeCount = 180;
    timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(setTimer) userInfo:nil repeats:YES];
}

-(void)setTimer{
    timeCount--;
    
    if (timeCount < 0){
        userAuth.enabled = NO;
        [timer invalidate];
        timer = nil;
        [self infoInit];
        isRequesting = NO;
        
        UIAlertView* am = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:@"인증번호를 전송하였습니다.\n3분 이내로 입력해주세요."
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [am show];
        return;
    }
    
    NSString* timeString = [NSString stringWithFormat:@"%d초", timeCount];
    lblTimer.text = timeString;
}

#pragma mark - IBAction
-(IBAction)closeModal:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)reqAuthNum:(id)sender
{
    NSString *msg = @"";
    if(userId.text.length < 1) msg = [NSString stringWithFormat:@"%@사용자ID", msg];
    if(msg.length > 0) msg = [NSString stringWithFormat:@"%@,", msg];
    if(userPhoneNum.text.length < 1) msg = [NSString stringWithFormat:@"%@ 휴대전화번호", msg];
    if(msg.length > 0) msg = [NSString stringWithFormat:@"%@,", msg];
    if(userEmail.text.length < 1) msg = [NSString stringWithFormat:@"%@ 사용자Email", msg];
    
    if(msg.length > 0){
        msg = [NSString stringWithFormat:@"%@은 필수 입력 정보 입니다.", msg];
        
        UIAlertView* am = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:msg
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [am show];
        return;
    }
    
    [self requestAuthCode];
}

-(IBAction)confirmAuthNum:(id)sender
{
    NSString *msg = @"";
    if(userId.text.length < 1) msg = [NSString stringWithFormat:@"%@사용자ID", msg];
    if(msg.length > 0) msg = [NSString stringWithFormat:@"%@,", msg];
    if(userAuth.text.length < 1) msg = [NSString stringWithFormat:@"%@ 인증번호", msg];
    
    if(msg.length > 0){
        msg = [NSString stringWithFormat:@"%@는 필수 입력 정보 입니다.", msg];
        
        UIAlertView* am = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:msg
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [am show];
        return;
    }
    
    [self confirmAuthCode];
}

-(IBAction)savePassword:(id)sender
{
    BOOL noCharValue = NO;
    BOOL noSpace = NO;
    BOOL noId = NO;
    BOOL noNext = NO;
    
    //비밀번호, 비밀번호 확인 미일치
    if(![password.text isEqualToString:confirmPassword.text]){
        [self setMsg:YES noCharValue:NO noSpace:NO noId:NO noNext:NO];
        return;
    }
    
    //8자리 이상 영문 + 특문 + 숫자
    NSRange range1 = [password.text rangeOfString:@"[a-zA-Z]" options:NSRegularExpressionSearch];
    NSRange range2 = [password.text rangeOfString:@"[!@#$%^*+=-]" options:NSRegularExpressionSearch];
    NSRange range3 = [password.text rangeOfString:@"[0-9]" options:NSRegularExpressionSearch];
    
    if(password.text.length < 8 ||  range1.length < 1 || range2.length < 1 || range3.length < 1)
        noCharValue = YES;
    
    int sameText = 0;
    int sameChar = 0;
    int bChar = -10;
    int cChar = -10;
    
    for(int i = 0; i < password.text.length; i++){
        //공백 불가
        if([[password.text substringToIndex:i] isEqualToString:@" "]){
            noSpace = YES;
        }
        
        // ID와 동일 문자가 4개이상 겹침 불가
        for(int j = 0; j < userId.text.length; j++){
            if([[password.text substringToIndex:i] isEqualToString:[userId.text substringToIndex:j]]){
                sameText++;
                if(sameText > 3)
                    noId = YES;
                
            }
        }
        
        //숫자 또는 문자 4자리이상 연속/중복 불가(ex - 1234, abcd, 1111)
        cChar = [password.text characterAtIndex:i];
        if(bChar == -10){
            bChar = cChar;
        }else{
            if((bChar - cChar) == 1 || (bChar - cChar) == -1 || bChar == cChar)
                sameChar++;
            else
                sameChar = 0;
            
            bChar = cChar;
            
            if(sameChar > 2)
                noNext = YES;
            
        }
    }

    if(!noCharValue && !noSpace && !noId && !noNext){
        [self savePassword];
    }else{
        [self setMsg:NO noCharValue:noCharValue noSpace:noSpace noId:noId noNext:noNext];
    }
}

-(void)setMsg :(BOOL)noMatch noCharValue:(BOOL)noCharValue noSpace:(BOOL)noSpace noId:(BOOL)noId noNext:(BOOL)noNext {
    NSString *msg = @"";
    
    if(noMatch){
        msg = @"비밀번호와 비밀번호 확인이 상이합니다";
    }
    
    if(noCharValue){
        msg = @"비밀번호는 특수문자+숫자+영문 조합 8자 이상 입력하셔야 합니다.\n";
    }
    
    if(noSpace){
        msg = [NSString stringWithFormat:@"%@비밀번호는 공백입력이 불가 합니다.\n", msg];
    }
    
    if(noId){
        msg = [NSString stringWithFormat:@"%@비밀번호는 ID와 동일 문자가 4개이상 입력 불가 합니다.\n", msg];
    }
    
    if(noNext){
        msg = [NSString stringWithFormat:@"%@숫자 또는 문자 4자리이상 연속/중복 입력 불가 합니다.\n", msg];
    }
    
    if(msg.length > 0){
        UIAlertView* am = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:msg
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"닫기", nil];
        [am show];
    }
}

-(IBAction)close:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - 인증번호 요청
-(void)requestAuthCode{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_AUTH_CODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:userId.text forKey:@"userId"];
    [paramDic setObject:userPhoneNum.text forKey:@"phoneNo"];
    [paramDic setObject:userEmail.text forKey:@"email"];
    
    [Util udSetObject:@"http://erpbarcodepda.kt.com/nbase" forKey:BARCODE_SERVER];
    [Util udSetObject:@"REAL" forKey:BARCODE_SERVER_ID];
    
//    [Util udSetObject:@"https://nbaseqa.kt.com/nbase" forKey:BARCODE_SERVER];
//    [Util udSetObject:@"QA" forKey:BARCODE_SERVER_ID];
    
    [requestMgr asychronousConnectToServer:API_USER_AUTH_REQ withData:paramDic];
}

#pragma mark - 인증번호 확인
-(void)confirmAuthCode{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_AUTH_COF;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:userId.text forKey:@"userId"];
    [paramDic setObject:userAuth.text forKey:@"userInputCertificationNumber"];
    [paramDic setObject:certificationNum forKey:@"createFromServerCertificationNumber"];
    [requestMgr asychronousConnectToServer:API_USER_AUTH_CFM withData:paramDic];
}

#pragma mark - 비밀번호 저장
-(void)savePassword{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PWD_UPDATE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if(gb){
        [paramDic setObject:[[Util udObjectForKey:USER_INFO] objectForKey:@"userId"] forKey:@"userId"];
        [paramDic setObject:@"Y" forKey:@"passwdUpdateYn"];
    }else{
        [paramDic setObject:userId.text forKey:@"userId"];
    }
    
    [paramDic setObject:password.text forKey:@"userPassword"];
    [requestMgr asychronousConnectToServer:API_USER_PWD_UPDATE withData:paramDic];
}

#pragma  mark - IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    NSString* message = @"";
    
    if (status == 0 || status == 2){
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        message = [headerDic objectForKey:@"detail"];
    }else{
        if(pid == REQUEST_AUTH_CODE){
            certificationNum = [[resultList objectAtIndex:0] objectForKey:@"certificationResult"];
            message = @"인증번호를 전송하였습니다.\n3분 이내로 입력해주세요.";
          [self startTimer];
        }else if(pid == REQUEST_AUTH_COF){
            [timer invalidate];
            timer = nil;
            passwordView.hidden = NO;
            commentView.frame = CGRectMake(commentView.frame.origin.x, inputView.frame.origin.y + inputView.frame.size.height + passwordView.frame.size.height, commentView.frame.size.width, commentView.frame.size.height);
            return;
        }else if(pid == REQUEST_PWD_UPDATE){
            message = @"비밀번호를 변경하였습니다.\n변경한 비밀번호로 로그인하시기 바랍니다.";
        }
    }
    
    UIAlertView* am = [[UIAlertView alloc]
                       initWithTitle:@"알림"
                       message:message
                       delegate:self
                       cancelButtonTitle:nil
                       otherButtonTitles:@"닫기", nil];
    [am show];
}



#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
@end

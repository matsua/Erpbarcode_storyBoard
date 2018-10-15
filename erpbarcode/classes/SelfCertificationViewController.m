//
//  SelfCertificationViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 12. 19..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "SelfCertificationViewController.h"
#import "NoticeViewController.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"

@interface SelfCertificationViewController ()

@end

@implementation SelfCertificationViewController

@synthesize certificationDelegate;

@synthesize lblMessage;
@synthesize lblPhoneNo;
@synthesize txtCertNo;
@synthesize btnSendCertNo;
@synthesize lblSecond;
@synthesize btnSend;
@synthesize btnClose;

@synthesize indicatorView;

@synthesize isConfirmation;
@synthesize isExit;
@synthesize isRequesting;
@synthesize userInfoDic;
@synthesize certificationNumber;
@synthesize timeCount;
@synthesize timer;



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
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchClose:)];
    self.title = @"개인인증";
    
    // 타이머가 종료되었는지...
    isExit = NO;
    // 인증번호 요청중인지...
    isRequesting = NO;
    
    //인증이 완료 되었는지
    isConfirmation = NO;
    
    txtCertNo.enabled = NO;
    userInfoDic = [Util udObjectForKey:USER_INFO];
    
    NSString* phoneNo = [userInfoDic objectForKey:@"userCellPhoneNo"];
    NSString* name = [userInfoDic objectForKey:@"userName"];
    
    name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length - 1,1) withString:@"*"];
    phoneNo = [phoneNo stringByReplacingCharactersInRange:NSMakeRange(5,3) withString:@"***"];
    
    
    lblMessage.text = [NSString stringWithFormat:@"'%@'님은\nKT ERP Barcode System 접속을 위하여\n본인인증을 하셔야 합니다.", name];
    lblPhoneNo.text = phoneNo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  User Define Action
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)touchSendCertNo:(id)sender {
    if (isRequesting){
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:@"새로운 인증번호를 재발송 했습니다."
                           delegate:self
                           cancelButtonTitle:Nil
                           otherButtonTitles:@"닫기", nil];
        [av show];
    }
    
    isExit = NO;
    isRequesting = YES;
    [self requestCertificationNo];
}

- (IBAction)touchSend:(id)sender {
    if (certificationNumber.length && [txtCertNo.text isEqualToString:certificationNumber]){
        [self requestSuccessCert];
    }else{
        NSString* name = [userInfoDic objectForKey:@"userName"];
        name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length - 1,1) withString:@"*"];
        
        NSString* message = [NSString stringWithFormat:@"'%@'님의 휴대전화\n\'%@'로\n전송 받은 인증번호를\n정확히 입력하세요.", name, lblPhoneNo.text];
        [self showMessage:message isError:YES];
    }
}

- (IBAction)touchClose:(id)sender {
    isExit = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [certificationDelegate certificationInfo:isConfirmation];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

#pragma user define method
- (void)showMessage:(NSString*)message isError:(BOOL)isError
{
    if (![Util udBoolForKey:IS_ALERT_COMPLETE])
        [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    //userDefault에 넣는다.
    [Util udSetBool:NO forKey:IS_ALERT_COMPLETE];
    
    UIAlertView* av = [[UIAlertView alloc]
                       initWithTitle:@"알림"
                       message:message
                       delegate:self
                       cancelButtonTitle:Nil
                       otherButtonTitles:@"닫기", nil];
    [av show];
    [Util playSoundWithMessage:message isError:isError];
    
    //버튼 누르기전까지 지연.
    while (![Util udBoolForKey:IS_ALERT_COMPLETE])
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];

    if (![Util udBoolForKey:IS_ALERT_COMPLETE])
        [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];

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

// 1초마다 시간을 찍는다. 제한시간(180초)안에 인증번호를 입력해야 함
- (void)printTimer
{
    if (isExit){
        [timer invalidate];
        lblSecond.text = @"";
        return;
    }
    timeCount--;
    
    if (timeCount < 0){
        [timer invalidate];
        txtCertNo.text = @"";
        txtCertNo.enabled = NO;
        isExit = YES;
        isRequesting = NO;
        txtCertNo.enabled = NO;
        return;
    }
    NSString* timeString = [NSString stringWithFormat:@"%d초", timeCount];
    lblSecond.text = timeString;
}

- (void)startTimer
{
    if(timer != nil)
    {
        [timer invalidate];
    }
    self.timeCount = 180;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(printTimer) userInfo:nil repeats:YES];
}

#pragma mark - Http Request Method
- (void)requestCertificationNo
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOGIN_MAKE_CERTIFICATION;
    
    [self performSelector:@selector(showIndicator) withObject:nil afterDelay:NO];
        
    NSDictionary* bodyDic = [NSDictionary dictionary];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:LOGIN_MAKE_CERTIFICATION withData:rootDic];
}

- (void)requestSuccessCert
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOGIN_SEND_CERTIFICATION;
    
    [self performSelector:@selector(showIndicator) withObject:nil afterDelay:NO];
    
    NSDictionary* bodyDic = [NSDictionary dictionary];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:LOGIN_SEND_CERTIFICATION withData:rootDic];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (status == 0 || status == 2){ //실패

        [timer invalidate];
        isExit = YES;
        isRequesting = NO;
        
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        NSString* messageHeader = [headerDic objectForKey:@"detail"];
        NSLog(@"messageHeader :: %@", messageHeader);
        
        NSString* message = @"";
        if (pid == REQUEST_LOGIN_MAKE_CERTIFICATION){
            message = @"인증번호생성 중\n오류가 발생하였습니다.\n잠시 후 다시 시도하세요";
        }else if (pid == REQUEST_LOGIN_SEND_CERTIFICATION){
            message = @"인증 정보 전송 중 오류가 발생하였습니다.\n잠시 후 다시 실행하세요.";
        }
        if ([message length] ){
            UIAlertView* av = [[UIAlertView alloc]
                               initWithTitle:@"알림"
                               message:message
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"닫기", nil];
            [av show];
            [Util playSoundWithMessage:message isError:YES];
        }
        
        return;
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
        
        return;
    }
    
    if (pid == REQUEST_LOGIN_MAKE_CERTIFICATION){
        if ([resultList count]){
            txtCertNo.enabled = YES;
            NSDictionary* dic = [resultList objectAtIndex:0];
            certificationNumber = [dic objectForKey:@"certificationResult"];
            txtCertNo.text = @"";
            [self startTimer];
        }
    }else if (pid == REQUEST_LOGIN_SEND_CERTIFICATION){
        NSString* message = @"인증되었습니다.\n 1일1회 본인 인증 절차를 진행하오니\n업무에 참고하시기 바랍니다.";
        isConfirmation = YES;
        isExit = YES;
        [self showMessage:message isError:NO];
        [self returnDelegate];
    }
}

-(void)returnDelegate{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [certificationDelegate certificationInfo:isConfirmation];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if(newLength == 6 || returnKey){
        NSString* text = [NSString stringWithFormat:@"%@%@", textField.text, string];
        textField.text = text;
        [textField resignFirstResponder];
    }
    
    
    return newLength < 6 || returnKey;
}

@end

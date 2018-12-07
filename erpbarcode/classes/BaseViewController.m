//
//  BaseViewController.m
//  erpbarcode
//
//  Created by matsua on 16. 12. 06..
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import "AppDelegate.h"
#import "ERPAlert.h"
#import "BaseViewController.h"
#import "ScanViewController.h"

@interface BaseViewController ()

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,assign) NSString *bsnGb;
@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,strong) IBOutlet UIView* orgView;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property(nonatomic,strong) IBOutlet UIView *locCodeView;
@property(nonatomic,strong) IBOutlet UIView *facCodeView;
@property(nonatomic,strong) IBOutlet UITextField *locCode;
@property(nonatomic,strong) IBOutlet UITextField *facCode;
@property(nonatomic,strong) NSString *bsnNo;
@property(nonatomic,assign) NSInteger nSelected;
@property(nonatomic,strong) IBOutlet UIWebView *resultWebView;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,assign) int scanBtnTag;

@end

@implementation BaseViewController
@synthesize indicatorView;
@synthesize workDic;
@synthesize dbWorkDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize orgView;
@synthesize lblOrperationInfo;
@synthesize locCodeView;
@synthesize facCodeView;
@synthesize locCode;
@synthesize facCode;
@synthesize bsnNo;
@synthesize bsnGb;
@synthesize nSelected;
@synthesize resultWebView;
@synthesize isOperationFinished;
@synthesize JOB_GUBUN;
@synthesize scanBtnTag;

#pragma mark - View LifeCycle

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
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    bsnGb = @"OA";
    if([JOB_GUBUN rangeOfString:@"OA"].location == NSNotFound){
        bsnGb = @"OE";
    }
    
    [self makeDummyInputViewForTextField];
    [self layoutChangeSubview];
    
}

- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        locCode.inputView = dummyView;
        facCode.inputView = dummyView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //위치바코드
        if(barcode.length != 11 && barcode.length != 14 && barcode.length != 17 && barcode.length != 21){
            [self showMessage:@"처리할 수 없는 위치바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
            locCode.text = @"";
            [locCode becomeFirstResponder];
            return YES;
        }
    }
    else if (tag == 200){ //200 설비 바코드
        if (barcode.length < 16 || barcode.length > 18){
            [self showMessage:@"처리할 수 없는 설비바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
            facCode.text = @"";
            [facCode becomeFirstResponder];
            return YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kdcBarcodeDataArrived:) name:kdcBarcodeDataArrivedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kdcBarcodeDataArrivedNotification object:nil];
}

- (IBAction)scan:(id)sender
{
    scanBtnTag = (int)[sender tag];
    
    NSLog(@"ScanViewController :: scan");

    ScanViewController* scanView = (ScanViewController*)[self instantiateViewController:@"Base" viewName:@"ScanViewController"];
    scanView.delegate = self;
    [self presentViewController:scanView animated:YES completion:nil];
}

#pragma mark - protocol method
-(void)setScanBarcode:(NSString *)barcode withResult:(BOOL)result
{
    NSLog(@"barcode == %@", barcode);
    
    if(scanBtnTag == 0){
        locCode.text = barcode;
    }else{
        facCode.text = barcode;
    }
    
}

-(IBAction)requestBtn:(id)sender{
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    facCode.text = @"001Z00358100000917";
//    locCode.text = @"P10028416";
    
    if([JOB_GUBUN hasPrefix:@"신규등록"] || [JOB_GUBUN hasPrefix:@"관리자변경"] || [JOB_GUBUN hasPrefix:@"재물조사"] ||
       [JOB_GUBUN hasPrefix:@"납품확인"] || [JOB_GUBUN hasPrefix:@"대여등록"] || [JOB_GUBUN hasPrefix:@"대여반납"]){
        if(!locCode.text){
            AlertViewController *alert = [[AlertViewController alloc] initWithTitle:nil message:@"위치바코드가 존재하지 않습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    if(!facCode.text){
        AlertViewController *alert = [[AlertViewController alloc] initWithTitle:nil message:@"설비바코드가 존재하지 않습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if([JOB_GUBUN hasPrefix:@"신규등록"] || [JOB_GUBUN hasPrefix:@"관리자변경"] || [JOB_GUBUN hasPrefix:@"재물조사"] ||
       [JOB_GUBUN hasPrefix:@"납품확인"] || [JOB_GUBUN hasPrefix:@"대여등록"] || [JOB_GUBUN hasPrefix:@"대여반납"] || [JOB_GUBUN hasPrefix:@"불용요청"]){
        [self requestManagement];
    }
    
    if([JOB_GUBUN hasPrefix:@"연식조회"] || [JOB_GUBUN hasPrefix:@"비품연식조회"]){
        [self requestItemSearch];
    }
}

#pragma mark - Http Request Method
- (void)requestManagement
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BASE_MANAGEMENT;
    
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:bsnNo forKey:@"com"];                   //업무번호
    [paramDic setObject:facCode.text forKey:@"bcId"];   //설비바코드
    if(locCode.text){
        [paramDic setObject:locCode.text forKey:@"sdId"];   //위치바코드
    }
    
    [paramDic setObject:bsnGb forKey:@"facType"];                  //OA, OE 구분
    [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];                  //사용자아이디
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_BASE_MANAGEMENT withData:rootDic];
}

- (void)requestItemSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BASE_ITEM_SEARCH;
    
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:bsnNo forKey:@"com"];                   //업무번호
    [paramDic setObject:facCode.text forKey:@"bcId"];  //설비바코드
    
    [paramDic setObject:bsnGb forKey:@"facType"];                  //OA, OE 구분
    [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];                  //사용자아이디
    
//    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
//    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
//    [requestMgr asychronousConnectToServer:API_BASE_ITEM_SEARCH withData:rootDic];
    [requestMgr asychronousConnectToServer:API_BASE_ITEM_SEARCH withData:paramDic];
    
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    //test : matsua
    if (resultList != nil){
         NSLog(@"Result List [%@]", resultList);
        
    }
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // 실패 시 필요한 메시지를 뿌려주고, 적당한 처리를 한다.
        [self processFailRequest:pid Message:message Status:status];
        
        return;
    }else if (status == -1){ //세션종료
        [self processEndSession:pid];
        
        return;
    }
    
    if (pid == REQUEST_BASE_MANAGEMENT || pid == REQUEST_BASE_ITEM_SEARCH){
        [self processResponseSearch:resultList];
    }else isOperationFinished = YES;
}

- (void)processResponseSearch:(NSArray*)responseList
{
    if (responseList.count){
        //TODO.
    }
    
    isOperationFinished = YES;
}

-(void)layoutChangeSubview{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"orgId"],[dic objectForKey:@"orgName"]];
    
    bsnNo = @"";
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    if([JOB_GUBUN rangeOfString:@"신규등록"].location != NSNotFound)
        bsnNo = @"0501";
    else if([JOB_GUBUN rangeOfString:@"관리자변경"].location != NSNotFound)
        bsnNo = @"0504";
    else if([JOB_GUBUN rangeOfString:@"재물조사"].location != NSNotFound)
        bsnNo = @"0601";
    else if([JOB_GUBUN rangeOfString:@"불용요청"].location != NSNotFound){
         bsnNo = @"0505";
        locCodeView.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"연식조회"].location != NSNotFound){
        bsnNo = @"0602";
        locCodeView.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"납품확인"].location != NSNotFound)
        bsnNo = @"0512";
    else if([JOB_GUBUN rangeOfString:@"대여등록"].location != NSNotFound)
        bsnNo = @"0513";
    else if([JOB_GUBUN rangeOfString:@"대여반납"].location != NSNotFound)
        bsnNo = @"0503";
}

#pragma mark - KSCAN Notification
-(void)kdcBarcodeDataArrived:(NSNotification*)noti
{
    KDCReader *kReader = (KDCReader *)[noti object];
    NSString* barcode = (NSString*)[kReader GetBarcodeData];
    UIResponder *firstResponder = [self findFirstResponder];
    if([firstResponder isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)firstResponder;
        textField.text = barcode;
        [self processShouldReturn:barcode tag:textField.tag];
    }
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

- (void) fccBecameFirstResponder
{
    if (![facCode isFirstResponder])
        [facCode becomeFirstResponder];
}

- (void) locBecameFirstResponder
{
    if (![locCode isFirstResponder])
        [locCode becomeFirstResponder];
}

- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message Status:(NSInteger)status
{
    if(pid == REQUEST_BASE_MANAGEMENT || pid == REQUEST_BASE_ITEM_SEARCH){
        locCode.text = @"";
        facCode.text = @"";
        
        if (message.length){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
        isOperationFinished = YES;
    }
}

- (void) processEndSession:(requestOfKind)pid
{
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
    
    isOperationFinished = YES;
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

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
@property(nonatomic,strong) IBOutlet UIView* requestView;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property(nonatomic,strong) IBOutlet UIView *locCodeView;
@property(nonatomic,strong) IBOutlet UIView *facCodeView;
@property(nonatomic,strong) IBOutlet UIView *snCodeView;
@property(nonatomic,strong) IBOutlet UITextField *locCode;
@property(nonatomic,strong) IBOutlet UITextField *facCode;
@property(nonatomic,strong) IBOutlet UITextField *snCode;
@property(nonatomic,strong) IBOutlet UIButton *requestBtn;
@property(nonatomic,strong) IBOutlet UIButton *sendBtn;
@property(nonatomic,strong) NSString *bsnNo;
@property(nonatomic,assign) NSInteger nSelected;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,assign) int scanBtnTag;
@property(nonatomic,strong) IBOutlet UILabel* stat;
@property(nonatomic,strong) IBOutlet UILabel* regDate;
@property(nonatomic,strong) IBOutlet UILabel* standNm;
@property(nonatomic,strong) IBOutlet UILabel* stand;
@property(nonatomic,strong) IBOutlet UILabel* equip;
@property(nonatomic,strong) IBOutlet UILabel* productRegDate;
@property(nonatomic,strong) IBOutlet UILabel* itemNm;
@property(nonatomic,strong) IBOutlet UILabel* sn;
@property(nonatomic,strong) IBOutlet UILabel* mnf;

@end

@implementation BaseViewController
@synthesize indicatorView;
@synthesize workDic;
@synthesize dbWorkDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize requestView;
@synthesize lblOrperationInfo;
@synthesize locCodeView;
@synthesize facCodeView;
@synthesize snCodeView;
@synthesize locCode;
@synthesize facCode;
@synthesize snCode;
@synthesize requestBtn;
@synthesize sendBtn;
@synthesize bsnNo;
@synthesize bsnGb;
@synthesize nSelected;
@synthesize isOperationFinished;
@synthesize JOB_GUBUN;
@synthesize scanBtnTag;
@synthesize stat;
@synthesize regDate;
@synthesize standNm;
@synthesize stand;
@synthesize equip;
@synthesize productRegDate;
@synthesize itemNm;
@synthesize sn;
@synthesize mnf;

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
        snCodeView.hidden = YES;
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
        if(barcode.length > 10){
            [self showMessage:@"처리할 수 없는 위치바코드입니다." tag:-1 title1:@"확인" title2:nil isError:YES];
            locCode.text = @"";
            [locCode becomeFirstResponder];
            return YES;
        }
    }
    else if (tag == 200){ //설비 바코드
        if (barcode.length != 17 && barcode.length != 18){
            [self showMessage:@"처리할 수 없는 설비바코드입니다." tag:-1 title1:@"확인" title2:nil isError:YES];
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
    }else if(scanBtnTag == 1){
        facCode.text = barcode;
    }else{
        snCode.text = barcode;
    }
    
}

-(IBAction)requestBtn:(id)sender{
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    if([JOB_GUBUN hasPrefix:@"신규등록"] || [JOB_GUBUN hasPrefix:@"관리자변경"] || [JOB_GUBUN hasPrefix:@"재물조사"] ||
       [JOB_GUBUN hasPrefix:@"납품확인"] || [JOB_GUBUN hasPrefix:@"대여등록"] || [JOB_GUBUN hasPrefix:@"대여반납"]){
        if(locCode.text.length == 0){
            [self showMessage:@"위치바코드가 존재하지 않습니다." tag:-1 title1:@"확인" title2:nil isError:YES];
            return;
        }
    }
    
    if(facCode.text.length == 0){
        [self showMessage:@"설비바코드가 존재하지 않습니다." tag:-1 title1:@"확인" title2:nil isError:YES];
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
    
    NSString *snCodeStr = @"";
    if(!snCodeView.isHidden && snCode.text.length > 0){
        snCodeStr = snCode.text;                              //S/N바코드
    }
    
    [paramDic setObject:bsnNo forKey:@"com"];                                           //업무번호
    [paramDic setObject:facCode.text forKey:@"bcId"];                                   //설비바코드
    if(locCode.text){
        [paramDic setObject:locCode.text forKey:@"sdId"];                               //위치바코드
    }
    if(!snCodeView.isHidden){
        [paramDic setObject:snCodeStr forKey:@"serge"];                               //S/N바코드
    }
    [paramDic setObject:bsnGb forKey:@"facType"];                                       //OA, OE 구분
    [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];            //사용자아이디
    
    [requestMgr asychronousConnectToServer:API_BASE_MANAGEMENT withData:paramDic];
}

- (void)requestItemSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BASE_ITEM_SEARCH;
    
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:bsnNo forKey:@"com"];                                   //업무번호
    [paramDic setObject:facCode.text forKey:@"bcId"];                           //설비바코드
    [paramDic setObject:bsnGb forKey:@"facType"];                               //OA, OE 구분
    [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];    //사용자아이디
    
    [requestMgr asychronousConnectToServer:API_BASE_ITEM_SEARCH withData:paramDic];
    
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    if (resultList != nil){
        if([resultList count] == 0){
            [self showMessage:@"조회된 결과값이 없습니다." tag:-1 title1:@"확인" title2:nil isError:YES];
            return;
        }
    }
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        NSString* message = [headerDic objectForKey:@"detail"];
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self processFailRequest:pid Message:message Status:status];
        return;
    }else if (status == -1){ //세션종료
        [self processEndSession:pid];
        
        return;
    }
    
    //정상응답
    if (pid == REQUEST_BASE_ITEM_SEARCH){
        [self processResponseSearch:resultList];
    }else if(pid == REQUEST_BASE_MANAGEMENT){
        [self processResponseManagement:resultList];
    }else isOperationFinished = YES;
}

- (void)processResponseManagement:(NSArray*)responseList
{
    isOperationFinished = YES;
    
    if (responseList.count){
        NSDictionary* dic = [responseList objectAtIndex:0];
        if([[dic objectForKey:@"T_ERR_TYPE"]isEqualToString:@"E"]){
            NSString *message = [dic objectForKey:@"T_MESS"];
            [self showMessage:message tag:0 title1:@"확인" title2:@""];
            return;
        }else{
            [self showMessage:@"정상처리 되었습니다." tag:0 title1:@"확인" title2:@""];
        }
    }
}

- (void)processResponseSearch:(NSArray*)responseList
{
    if (responseList.count){
        NSDictionary* dic = [responseList objectAtIndex:0];
        [stat setText:[dic objectForKey:@"STAT"]];
        [regDate setText:[dic objectForKey:@"REGDATE"]];
        [standNm setText:[dic objectForKey:@"STANDNAME"]];
        [stand setText:[dic objectForKey:@"STAND"]];
        [equip setText:[dic objectForKey:@"EQUIP"]];
        [productRegDate setText:[dic objectForKey:@"PRODUCTREGDATE"]];
        [itemNm setText:[dic objectForKey:@"ITEMNM"]];
        [sn setText:[dic objectForKey:@"SN"]];
        [mnf setText:[dic objectForKey:@"MNF"]];
    }
    
    isOperationFinished = YES;
}

-(void)layoutChangeSubview{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    bsnNo = @"";
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    if([JOB_GUBUN rangeOfString:@"납품확인"].location == NSNotFound){
        snCodeView.hidden = YES;
    }
    
    if([JOB_GUBUN rangeOfString:@"신규등록"].location != NSNotFound){
        bsnNo = @"0501";
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"관리자변경"].location != NSNotFound){
        bsnNo = @"0504";
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"불용요청"].location != NSNotFound){
         bsnNo = @"0505";
        locCodeView.hidden = YES;
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"연식조회"].location != NSNotFound){
        bsnNo = @"0602";
        locCodeView.hidden = YES;
        sendBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"납품확인"].location != NSNotFound){
        bsnNo = @"0512";
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"대여등록"].location != NSNotFound){
        bsnNo = @"0513";
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    else if([JOB_GUBUN rangeOfString:@"대여반납"].location != NSNotFound){
        bsnNo = @"0503";
        requestView.hidden = YES;
        requestBtn.hidden = YES;
    }
    
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

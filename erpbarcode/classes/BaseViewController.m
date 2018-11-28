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
#import "ZBarReaderViewController.h"

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
@property(nonatomic,strong) NSString *strLocBarCode;
@property(nonatomic,strong) IBOutlet UITextField *facCode;
@property(nonatomic,strong) NSString *strFacBarCode;
@property(nonatomic,strong) NSString *bsnNo;
@property(nonatomic,assign) NSInteger nSelected;
@property(nonatomic,strong) IBOutlet UIWebView *resultWebView;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) BOOL isDataSaved;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,assign) BOOL isOffLine;

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
@synthesize strLocBarCode;
@synthesize facCode;
@synthesize strFacBarCode;
@synthesize bsnNo;
@synthesize bsnGb;
@synthesize nSelected;
@synthesize resultWebView;
@synthesize isOperationFinished;
@synthesize isDataSaved;
@synthesize JOB_GUBUN;
@synthesize isOffLine;

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
    
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];
    
    [self workDataInit];
    
    [self makeDummyInputViewForTextField];
    
    [self layoutChangeSubview];
    
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"])
    {
//        dbWorkDic = [NSMutableDictionary dictionary];
    }else{
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
}

- (void) workDataInit
{
    isDataSaved = NO;
    
    //작업관리 초기화
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    //offline 여부
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
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

- (IBAction) touchSaveBtn:(id)sender
{
    if([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        isDataSaved = YES;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

#pragma mark - DB Method

- (void)processWorkData
{
    if (dbWorkDic.count){
        NSData* taskData = [dbWorkDic objectForKey:@"TASK"];
        if (taskData.bytes > 0){
            fetchTaskList = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
            NSLog(@"fetchTaskList [%@]",fetchTaskList);
        }
        
        if (fetchTaskList.count)
            [self waitForGCD];
    }
}

- (BOOL)saveToWorkDB
{
    NSString* workId = @"";
    
    if ([dbWorkDic count])
        workId = [NSString stringWithFormat:@"%@", [dbWorkDic objectForKey:@"ID"]];
    
    NSMutableDictionary* workData = [NSMutableDictionary dictionary];
    
    [workData setObject:workDic forKey:@"WORKDIC"];
    [workData setObject:taskList forKey:@"TASKLIST"];
    
    BOOL retValue = [[DBManager sharedInstance] saveWorkData:workData ToWorkDBWithId:workId];
    
    if(![workId length]){
        workId = [NSString stringWithFormat:@"%d", [[DBManager sharedInstance] countSelectQuery:SELECT_LAST_ID_FROM_WORK_INFO]];
    }
    [workData setObject:workId forKey:@"ID"];
    
    dbWorkDic = [workData copy];
    
    return retValue;
}

-(void)waitForGCD
{
    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        // 작업이 완료될 때까지 다음 TASK진행을 기다려준다.  이때 작업의 완료 여부를 결정하는 Bool 변수
        isOperationFinished = NO;
        
        // TASK에 따른 작업 실행
        if ([task isEqualToString:@"L"]) //위치
        {
            locCode.text = strLocBarCode = value;
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            facCode.text = strFacBarCode = value;
            isOperationFinished = YES;
        }
        else
            isOperationFinished = YES;
        
        // 현재 작업이 완료될때까지 기다린다.
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
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
        strLocBarCode = barcode;
        
        if(barcode.length != 11 && barcode.length != 14 && barcode.length != 17 && barcode.length != 21){
            [self showMessage:@"처리할 수 없는 위치바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
            locCode.text = strLocBarCode = @"";
            [locCode becomeFirstResponder];
            return YES;
        }
        
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"L" forKey:@"TASK"];
        [taskDic setObject:strLocBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else if (tag == 200){ //200 설비 바코드
        strFacBarCode = barcode;
        
        if (barcode.length < 16 || barcode.length > 18){
            [self showMessage:@"처리할 수 없는 설비바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
            facCode.text = strFacBarCode = @"";
            [facCode becomeFirstResponder];
            return YES;
        }
        
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFacBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
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
    NSLog(@"ScanViewController :: scan");
    nSelected = [sender tag];
    ZBarReaderViewController *barcodeReaderController = [[ZBarReaderViewController alloc] init];
    barcodeReaderController.readerDelegate = self;
    [self presentViewController:barcodeReaderController animated:YES completion:nil];
}

#pragma mark - ZBarReaderController methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> scanResults = [info objectForKey:ZBarReaderControllerResults];
    
    NSString *result;
    ZBarSymbol *symbol;
    
    for (symbol in scanResults)
    {
        result = [symbol.data copy];
        break;
    }
    
    if(nSelected == 0){
        [locCode setText:result];
    }else{
        [facCode setText:result];
    }
    
    NSLog(@"Result : %@", result);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"ScanViewController :: imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)requestBtn:(id)sender{
    //TEST CODE : matsua
    locCode.text = strLocBarCode = @"P10064962";
    facCode.text = strFacBarCode = @"001Z00345300002812";
    
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
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
       [JOB_GUBUN hasPrefix:@"납품확인"] || [JOB_GUBUN hasPrefix:@"대여등록"] || [JOB_GUBUN hasPrefix:@"대여반납"]){
        [self requestManagement];
    }
    
    if([JOB_GUBUN hasPrefix:@"연식조회"] || [JOB_GUBUN hasPrefix:@"비품연식조회"] || [JOB_GUBUN hasPrefix:@"불용요청"]){
        [self requestItemSearch];
    }
}

#pragma mark - Http Request Method
- (void)requestManagement
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BASE_MANAGEMENT;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:bsnNo forKey:@"COM"];                   //업무번호
    [paramDic setObject:strFacBarCode forKey:@"BCID"];  //설비바코드
    [paramDic setObject:strLocBarCode forKey:@"SDID"];  //위치바코드
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_BASE_MANAGEMENT withData:rootDic];
}

- (void)requestItemSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BASE_ITEM_SEARCH;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:bsnNo forKey:@"COM"];                   //업무번호
    [paramDic setObject:strFacBarCode forKey:@"BCID"];  //설비바코드
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_BASE_ITEM_SEARCH withData:rootDic];
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
        // 전송한 후에는 작업관리에 그 결과를 저장한다.  실패시 에러나 워닝을 저장한다.
        if (pid == REQUEST_SEND){
            if (status == 0)
                [workDic setObject:@"E" forKey:@"TRANSACT_YN"];
            else if (status == 2)
                [workDic setObject:@"W" forKey:@"TRANSACT_YN"];
            [workDic setObject:message forKey:@"TRANSACT_MSG"];
            [self saveToWorkDB];
            
            // DB에 작업관리를 저장했으므로 본 화면에서 백버튼으로 나가도 문제 없음을 의미한다.
            isDataSaved = YES;
        }
        
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
    
    if([JOB_GUBUN isEqualToString:@"불용요청[OA]"] || [JOB_GUBUN isEqualToString:@"불용요청[OE]"] || [JOB_GUBUN isEqualToString:@"비품연식조회[OE]"] || [JOB_GUBUN isEqualToString:@"연식조회[OA]"]){
        locCodeView.hidden = YES;
    }
    
    if([JOB_GUBUN isEqualToString:@"신규등록[OA]"] || [JOB_GUBUN isEqualToString:@"신규등록[OE]"]) bsnNo = @"0501";
    else if([JOB_GUBUN isEqualToString:@"관리자변경[OA]"] || [JOB_GUBUN isEqualToString:@"관리자변경[OE]"]) bsnNo = @"0504";
    else if([JOB_GUBUN isEqualToString:@"재물조사[OA]"] || [JOB_GUBUN isEqualToString:@"재물조사[OE]"]) bsnNo = @"0601";
    else if([JOB_GUBUN isEqualToString:@"불용요청[OA]"] || [JOB_GUBUN isEqualToString:@"불용요청[OE]"]) bsnNo = @"0505";
    else if([JOB_GUBUN isEqualToString:@"연식조회[OA]"] || [JOB_GUBUN isEqualToString:@"비품연식조회[OE]"]) bsnNo = @"0602";
    else if([JOB_GUBUN isEqualToString:@"납품확인[OA]"] || [JOB_GUBUN isEqualToString:@"납품확인[OE]"]) bsnNo = @"0512";
    else if([JOB_GUBUN isEqualToString:@"대여등록[OA]"] || [JOB_GUBUN isEqualToString:@"대여등록[OE]"]) bsnNo = @"0513";
    else if([JOB_GUBUN isEqualToString:@"대여반납[OA]"] || [JOB_GUBUN isEqualToString:@"대여반납[OE]"]) bsnNo = @"0503";

    isDataSaved = NO;
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
        locCode.text = strLocBarCode = @"";
        facCode.text = strFacBarCode = @"";
        
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

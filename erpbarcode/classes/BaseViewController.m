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
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSString *url = @"";
    
    //TEST CODE : matsua
    NSString *userId = @"91186176";
    strLocBarCode = locCode.text;
    strFacBarCode = @"001Z00911318010012";
    
    if([bsnGb isEqualToString:@"OA"]){//OA
        if([JOB_GUBUN isEqualToString:@"불용요청[OA]"]){//불용요청
            url = [NSString stringWithFormat:API_BASE_OA_WORK_LIST_HALF, bsnNo, userId, strFacBarCode];
        }else if([JOB_GUBUN isEqualToString:@"연식조회[OA]"]){//OA연식조회
            url = [NSString stringWithFormat:API_BASE_OA_ITEM_SEARCH, bsnNo, userId, strFacBarCode];
        }else{//신규등록, 관리자 변경, 재물조사, 납품확인, 대여등록, 대여반납
            url = [NSString stringWithFormat:API_BASE_OA_WORK_LIST, bsnNo, userId, strLocBarCode, strFacBarCode];
        }
    }else{//OE
        if([JOB_GUBUN isEqualToString:@"불용요청[OE]"]){//불용요청
            url = [NSString stringWithFormat:API_BASE_OE_WORK_LIST_HALF, bsnNo, userId, strFacBarCode];
        }else if([JOB_GUBUN isEqualToString:@"비품연식조회[OE]"] ){//비품연식조회
            url = [NSString stringWithFormat:API_BASE_OE_ITEM_SEARCH, bsnNo, userId, strFacBarCode];
        }else{//신규등록, 관리자 변경, 재물조사, 납품확인, 대여등록, 대여반납
            url = [NSString stringWithFormat:API_BASE_OE_WORK_LIST, bsnNo, userId, strLocBarCode, strFacBarCode];
        }
    }
    
    NSLog(@"url=======%@", url);
    
    NSURL *resultWebUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *resultWebUrlRequest = [[NSURLRequest alloc] initWithURL:resultWebUrl];
    [resultWebView loadRequest:resultWebUrlRequest];
}

-(void)layoutChangeSubview{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"orgId"],[dic objectForKey:@"orgName"]];
    
    bsnNo = @"";
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    if([JOB_GUBUN isEqualToString:@"불용요청[OA]"] || [JOB_GUBUN isEqualToString:@"불용요청[OE]"] || [JOB_GUBUN isEqualToString:@"비품연식조회[OE]"] || [JOB_GUBUN isEqualToString:@"연식조회[OA]"]){
        CGRect locviewFrame = CGRectMake(locCodeView.frame.origin.x, locCodeView.frame.size.height, locCodeView.frame.size.width, locCodeView.frame.size.height);
        locCodeView.hidden = YES;
        facCodeView.frame = locviewFrame;
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

@end

//
//  SpotCheckViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 21..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "SpotCheckViewController.h"
#import "LocListViewController.h"
#import "FccInfoViewController.h"
#import "OrgSearchViewController.h"
#import "CommonCell.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "AppDelegate.h"
#import "ERPAlert.h"
#import "AddInfoViewController.h"

@interface SpotCheckViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property(nonatomic,strong) IBOutlet UITextField* txtDeviceCode;
@property(nonatomic,strong) IBOutlet UITextField* txtLocCode;
@property(nonatomic,strong) IBOutlet UITextField* txtFacCode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocName;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceID;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocName;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollDeviceInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceInfo;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UIButton* btnReal;
@property(nonatomic,strong) IBOutlet UIButton* btnUpper;
@property (strong, nonatomic) IBOutlet UILabel *lblUpper;
@property(nonatomic,strong) IBOutlet UIButton* btnDept;
@property(nonatomic,strong) IBOutlet UIButton* btnLoc;
@property(nonatomic,strong) IBOutlet UIButton* btnLocDialog;
@property (strong, nonatomic) IBOutlet UILabel *lblDevice;
@property(nonatomic,strong) IBOutlet UIButton* btnDevice;
@property(nonatomic,strong) IBOutlet UILabel* lblPartType;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property(nonatomic,strong) IBOutlet UILabel* lblCount;
@property(nonatomic,strong) IBOutlet UILabel* lblScanCount;
@property(nonatomic,strong) IBOutlet UILabel* lblPercent;
@property(nonatomic,strong) IBOutlet UIView* fccBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* fccInfoView;
@property(nonatomic,strong) IBOutlet UIView* remainView;
@property(nonatomic,strong) IBOutlet UIView* receivedOrgView;
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,strong) NSString* strLocBarCode;
@property(nonatomic,strong) NSString* strFccBarCode;
@property(nonatomic,strong) NSString* strDecryptFccBarCode;
@property(nonatomic,strong) NSString* strDecryptLocBarCode;
@property(nonatomic,strong) NSString* strDecryptDeviceBarCode;
@property(nonatomic,strong) NSString* strDeviceID;
@property(nonatomic,strong) NSString* strLocID;
@property(nonatomic,strong) NSString* strCheckValue;
@property(nonatomic,strong) NSString* strSpotSerial;
@property(nonatomic,strong) NSString* strUserOrgCode;
@property(nonatomic,strong) NSString* strUserOrgName;
@property(nonatomic,strong) NSDictionary* receivedOrgDic;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) NSMutableArray* locResultList;
@property(nonatomic,strong) NSMutableArray* fccResultList;
@property(nonatomic,strong) NSMutableArray* originalSAPList;
@property(nonatomic,strong) NSMutableArray* fccSAPList;
@property(nonatomic,strong) NSMutableArray* gbicList;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) NSDictionary* receivedLocDic;
@property(nonatomic,assign) int sendCount;
@property(nonatomic,assign) BOOL isWireless;
@property(nonatomic,assign) BOOL isVirtualFlag;
@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,assign) BOOL isReceivedLoc;
@property(nonatomic,assign) BOOL isFirstGetFccList; // 설비코드 스캔없이 위치바코드 스캔에 의해서 불려지는 경우 YES 아닌 경우는  NO
@property(nonatomic,assign) BOOL isOffLine;
@property(nonatomic,assign) BOOL isOrgProceed; //창고(실에서) vs로 시작할때 조직다를시 계속할건지 여부
@property(nonatomic,assign) BOOL isDataSaved;   // 저장했는지 여부..  초기화 하면 NO 저장하면 YES
@property(nonatomic,strong) NSString* oldRack;
@property(nonatomic,strong) NSString* oldShelf;
@property(nonatomic,strong) NSString* oldUnit;
@property(nonatomic,strong) NSString* strScanValue;
@property(nonatomic,strong) NSArray* goodsList;
@property(nonatomic,strong) UILongPressGestureRecognizer* longPressGesture;
@property(nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,strong) NSString* sendResult;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) NSInteger dbTotalCount;
@property(nonatomic,assign) NSInteger dbRackCount;
@property(nonatomic,assign) NSInteger dbSehlfCount;
@property(nonatomic,assign) NSInteger dbUnitCount;
@property(nonatomic,assign) NSInteger dbEquipCount;

@property(assign, nonatomic)int pwSendType;
@property(nonatomic,strong) NSString* deviceLocCd;
@property(nonatomic,strong) NSString* deviceLocNm;

@property(nonatomic,strong) NSDictionary* spotLocDic;

@property(nonatomic,assign) BOOL isHiddenList; //1500건 이상일때 sap에서 목록을 내려주지 않는다.
@property(nonatomic,assign) BOOL isHiddenListChild;
@property(nonatomic,strong) NSMutableArray* originalHiddenSAPList;
@property(nonatomic,assign) NSInteger nHiddenSelectedRow;
@property(nonatomic,assign) NSInteger nHiddenTotalCount;

@end

@implementation SpotCheckViewController
#pragma mark - ViewLife Cycle
@synthesize _scrollView;
@synthesize isFirstGetFccList;
@synthesize lblPartType;
@synthesize receivedLocDic;
@synthesize strSpotSerial;
@synthesize nSelectedRow;
@synthesize gbicList;
@synthesize btnLocDialog;
@synthesize txtDeviceCode;
@synthesize txtLocCode;
@synthesize txtFacCode;
@synthesize _tableView;
@synthesize JOB_GUBUN;
@synthesize indicatorView;
@synthesize scrollLocName;
@synthesize lblLocName;
@synthesize lblDeviceID;
@synthesize strLocID;
@synthesize strCheckValue;
@synthesize lblOrperationInfo;
@synthesize scrollDeviceInfo;
@synthesize lblDeviceInfo;
@synthesize locResultList;
@synthesize fccResultList;
@synthesize originalSAPList;
@synthesize fccSAPList;
@synthesize strLocBarCode;
@synthesize strFccBarCode;
@synthesize strDecryptFccBarCode;
@synthesize strDecryptLocBarCode;
@synthesize strDecryptDeviceBarCode;
@synthesize strDeviceID;
@synthesize isWireless;
@synthesize oldRack;
@synthesize oldShelf;
@synthesize oldUnit;
@synthesize isVirtualFlag;
@synthesize isOffLine;
@synthesize strScanValue;
@synthesize goodsList;
@synthesize btnReal;
@synthesize btnUpper;
@synthesize lblUpper;
@synthesize btnDept;
@synthesize btnLoc;
@synthesize btnDevice;
@synthesize lblDevice;
@synthesize btnSave;
@synthesize isReceivedLoc;
@synthesize receivedOrgDic;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize fccBarcodeView;
@synthesize fccInfoView;
@synthesize receivedOrgView;
@synthesize remainView;
@synthesize lblCount;
@synthesize lblScanCount;
@synthesize sendCount;
@synthesize longPressGesture;
@synthesize tapGesture;
@synthesize lblPercent;
@synthesize workDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize dbWorkDic;
@synthesize isOperationFinished;
@synthesize isOrgProceed;
@synthesize dbTotalCount;
@synthesize dbRackCount;
@synthesize dbSehlfCount;
@synthesize dbUnitCount;
@synthesize dbEquipCount;
@synthesize isFirst;
@synthesize isDataSaved;

@synthesize deviceLocCd;
@synthesize deviceLocNm;
@synthesize pwSendType;
@synthesize spotLocDic;

@synthesize isHiddenList;
@synthesize isHiddenListChild;
@synthesize originalHiddenSAPList;
@synthesize nHiddenSelectedRow;
@synthesize nHiddenTotalCount;

#pragma mark - ViewLife Cycle
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

    if ([JOB_GUBUN isEqualToString:@"설비정보"] && ![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kdcBarcodeDataArrived:) name:kdcBarcodeDataArrivedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kdcBarcodeDataArrivedNotification object:nil];
}

- (void) dealloc
{
    [_tableView removeGestureRecognizer:longPressGesture];
    [_tableView removeGestureRecognizer:tapGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    [self makeDummyInputViewForTextField];
    
    isOffLine = [[Util udObjectForKey:USER_OFFLINE] boolValue];
    
    if(!isOffLine){
        [self requestGbicList];
    }
    
    [self layoutSubViews];
}

-(void)setView{
    //작업관리 초기화
    isDataSaved = NO;
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
    originalSAPList = [NSMutableArray array];
    fccSAPList = [[NSMutableArray alloc] init];
    
    isFirst = YES;
    
    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];
    
    //히든 데이터 초기화
    [self hiddenDataInit];
    
    if (!isOffLine)
        [self requestSpotSerial];
    
    [self showCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) layoutControl
{
    if (!fccBarcodeView.hidden && !txtDeviceCode.text.length)
        [txtDeviceCode becomeFirstResponder];
    else if (!txtLocCode.text.length)
        [txtLocCode becomeFirstResponder];
    else if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

- (void) setLocBecomeFirstResponder
{
    if (![txtDeviceCode isFirstResponder])
        [txtDeviceCode becomeFirstResponder];
}

- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtLocCode.inputView = dummyView;
        txtDeviceCode.inputView = dummyView;
        txtFacCode.inputView = dummyView;
    }
}

-(void) layoutSubViews
{
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    
    UIView* countView = [[UIView alloc] initWithFrame:CGRectMake(0,  PHONE_SCREEN_HEIGHT - 44 - 45, 320, 45)];
    countView.backgroundColor = [UIColor clearColor];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 300, 15)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor brownColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:lblCount];
    
    lblScanCount = [[UILabel alloc] initWithFrame:CGRectMake(20,15, 300, 15)];
    lblScanCount.backgroundColor = [UIColor clearColor];
    lblScanCount.textColor = [UIColor blueColor];
    lblScanCount.font = [UIFont systemFontOfSize:14];
    lblScanCount.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:lblScanCount];
    
    lblPercent = [[UILabel alloc] initWithFrame:CGRectMake(20,30, 300, 15)];
    lblPercent.backgroundColor = [UIColor clearColor];
    lblPercent.textColor = [UIColor brownColor];
    lblPercent.font = [UIFont systemFontOfSize:14];
    lblPercent.textAlignment = NSTextAlignmentCenter;
    [countView addSubview:lblPercent];
    
    
    [self.view addSubview:countView];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    if ([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"])
        isVirtualFlag = YES;
    else
        isVirtualFlag = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locDataReceived:)
                                                 name:@"locSelectedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orgDataReceived:)
                                                 name:@"spotOrgSelectedNotification"
                                               object:nil];
    
    //long press gesture add
    longPressGesture = [[UILongPressGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(handleLongPress:)];
    longPressGesture.cancelsTouchesInView = NO;
    longPressGesture.minimumPressDuration = 1.0f;//seconds
    longPressGesture.delegate = self;
    [_tableView addGestureRecognizer:longPressGesture];
    
    //single tap gesture add
    tapGesture =[[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(handleSingleTap:)];
    
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [_tableView addGestureRecognizer:tapGesture];
    
    
    
    if ([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"]){
        fccBarcodeView.hidden = YES;
        fccInfoView.hidden = YES;
        btnLocDialog.hidden = YES;
        remainView.frame = CGRectMake(0, 27, 320, 155); //3번째 라인
        
        if (IS_4_INCH())
            _tableView.frame = CGRectMake(0, 183, 320, countView.frame.origin.y - 183 - countView.frame.size.height - 50);
        else
            _tableView.frame = CGRectMake(0, 183, 320, countView.frame.origin.y - 183);
        
        //        NSLog(@"tableView frame size [%@]",NSStringFromCGSize(_tableView.frame.size));
        //        NSLog(@"tableView bound size [%@]",NSStringFromCGSize(_tableView.bounds.size));
        
        btnUpper.enabled = NO;
        lblUpper.textColor = RGB(120, 120, 96);
        
        btnDevice.enabled = NO;
        lblDevice.textColor = RGB(120, 120, 96);
        
        
        [txtLocCode becomeFirstResponder];
    }
    else {
        [txtDeviceCode becomeFirstResponder];
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
    
    if ([txtLocCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
    
    if ([txtDeviceCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}


-(void)setWorkData
{
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
    {
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - DB Method

- (void)processWorkData
{
    if (!receivedOrgView.hidden){
        NSData* orgData = [dbWorkDic objectForKey:@"ORGCODE"];
        if (orgData.bytes > 0){
            NSDictionary* orgDic = [NSKeyedUnarchiver unarchiveObjectWithData:orgData];
            if(orgDic.count){
                lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[orgDic objectForKey:@"costCenter"],[orgDic objectForKey:@"orgName"]];
                receivedOrgDic = orgDic;
            }
        }
    }
    
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
    
    if (receivedOrgDic != nil)
        [workData setObject:receivedOrgDic forKey:@"ORGDIC"];
    
    BOOL retValue = [[DBManager sharedInstance] saveWorkData:workData ToWorkDBWithId:workId];
    
    if(![workId length]){
        workId = [NSString stringWithFormat:@"%d", [[DBManager sharedInstance] countSelectQuery:SELECT_LAST_ID_FROM_WORK_INFO]];
    }
    [workData setObject:workId forKey:@"ID"];
    
    dbWorkDic = [workData copy];
    
    return retValue;
}

#pragma mark - GCD
-(void) waitForGCD
{
    isOperationFinished = NO;
    
    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        if ([task isEqualToString:@"L"]) //위치
        {
            txtLocCode.text = strLocBarCode = strDecryptLocBarCode = value;
            originalSAPList = [NSMutableArray array];
            fccSAPList = [NSMutableArray array];
            [_tableView reloadData];
            [self showCount];
            
            if (isOffLine)
                [self setOfflineLocCd:value];
            else
                [self requestLocCode:value];
        }
        else if ([task isEqualToString:@"D"]) //장치아이디
        {
            txtDeviceCode.text = strDeviceID = strDecryptDeviceBarCode = value;
            if (isOffLine)
                [self setOffLineDeviceCd:value];
            else
                [self requestDeviceCode:value];
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            if (!isOrgProceed)  break;
            
            txtFacCode.text = value;
            strFccBarCode = txtFacCode.text;
            [self processFacCode];
        }
        else if ([task isEqualToString:@"CANCEL"]) //스캔취소
        {
            nSelectedRow = [value intValue];
            [self touchScanCancelBtn];
        }
        else{
            isOrgProceed = value;
            isOperationFinished = YES;
        }
        
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        isOperationFinished = NO;
        
    }
    [self layoutControl];
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    isDataSaved = YES;
}


#pragma mark - Notification Event
- (void) locDataReceived:(NSNotification *)notification
{
    receivedLocDic = [notification object];
    if (receivedLocDic.count){
        
        if (txtFacCode.text.length){
            strFccBarCode = @"";
            txtFacCode.text = @"";
        }
        if (originalSAPList.count){
            originalSAPList = [NSMutableArray array];
            fccSAPList = [NSMutableArray array];
            
            [_tableView reloadData];
        }
        
        strLocBarCode =  [receivedLocDic objectForKey:@"ZEQUIPLP"];
        strDecryptLocBarCode = strLocBarCode;
        txtLocCode.text = strLocBarCode;
        [self requestLocCode:strLocBarCode];
    }
    
}

- (void) orgDataReceived:(NSNotification *)notification
{
    receivedOrgDic = [notification object];
    if (receivedOrgDic.count)
        strUserOrgCode = [receivedOrgDic objectForKey:@"costCenter"];
        lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[receivedOrgDic objectForKey:@"costCenter"],[receivedOrgDic objectForKey:@"orgName"]];
    
    //작업관리 추가
    [workDic setObject:receivedOrgDic forKey:@"ORGCODE"];
}

#pragma mark - handle gesture

- (void) handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (fccSAPList.count){
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            CGPoint p = [gestureRecognizer locationInView:_tableView];
            NSIndexPath* indexPath = [_tableView indexPathForRowAtPoint:p];
            if(indexPath){
                NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
                if(dic.count){
                    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
                    vc.paramBarcode = [dic objectForKey:@"EQUNR"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

- (void) handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (fccSAPList.count){
        CGPoint p = [gestureRecognizer locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        if (indexPath){
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - UserDefine Method
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //장치 디바이스
        strDecryptDeviceBarCode = barcode;
        strDeviceID = strDecryptDeviceBarCode;
        
        NSString* message = [Util barcodeMatchVal:3 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDecryptDeviceBarCode = strDeviceID = txtDeviceCode.text = @"";
            [self performSelector:@selector(deviceBecameFirstResponder) withObject:nil afterDelay:NO];
            return YES;
        }
        
        if (isOffLine)
            [self setOffLineDeviceCd:strDeviceID];
        else
            [self requestDeviceCode:strDeviceID];
        
    }
    else if (tag == 200){ //위치
        strDecryptLocBarCode = barcode;
        
        strLocBarCode = strDecryptLocBarCode;
        
        if (!isVirtualFlag && !strDecryptDeviceBarCode.length && !fccBarcodeView.hidden){
            [self performSelectorOnMainThread:@selector(deviceBecameFirstResponder) withObject:nil waitUntilDone:NO];
            NSString* message = @"장치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtLocCode.text = @"";
            strDecryptLocBarCode = @"";
            return NO;
        }
        
        NSString* message = [Util barcodeMatchVal:1 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDecryptLocBarCode = strLocBarCode = txtLocCode.text = @"";
            [self performSelector:@selector(locBecameFirstResponder) withObject:nil afterDelay:NO];
            return YES;
        }
        
        if (txtFacCode.text.length){
            strFccBarCode = @"";
            txtFacCode.text = @"";
        }
        
        originalSAPList = [NSMutableArray array];
        fccSAPList = [NSMutableArray array];
        [_tableView reloadData];
        [self showCount];
        
        //음영지역 아닐경우에만 호출
        if (!isOffLine)
            [self requestLocCode:strLocBarCode];
        else
            [self setOfflineLocCd:strLocBarCode];
    }
    else if (tag == 300) { //300 설비 바코드
        
        strDecryptFccBarCode = barcode;
        strFccBarCode = strDecryptFccBarCode;
        
        if (!isVirtualFlag){
            if (!strDecryptLocBarCode.length ||!strDecryptDeviceBarCode.length){
                [self performSelectorOnMainThread:@selector(deviceBecameFirstResponder) withObject:nil waitUntilDone:NO];
                [self showMessage:@"현장점검할 위치와 장치바코드를\n.스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
                return NO;
                
            }
        }
        //먼저 위치 바코드 체크
        if(!txtLocCode.text.length){
            [self performSelectorOnMainThread:@selector(locBecameFirstResponder) withObject:nil waitUntilDone:NO];
            [self showMessage:@"먼저 위치바코드를 스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
            strFccBarCode = strDecryptFccBarCode = txtFacCode.text = @"";
            lblPartType.text = @"";
            
            return NO;
        }
        
//        if (strFccBarCode.length < 16 || strFccBarCode.length > 18)
//        {
//            [self showMessage: @"처리할 수 없는 설비바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
//            return NO;
//        }
        
        NSString* message = [Util barcodeMatchVal:2 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strFccBarCode = strDecryptFccBarCode = txtFacCode.text = @"";
            [txtFacCode becomeFirstResponder];
            return YES;
        }
        
        [self processFacCode];
    }
    
    return YES;
}

- (void)setOfflineLocCd:(NSString*)barcode
{
    [Util setScrollTouch:scrollLocName Label:lblLocName withString:MESSAGE_OFFLINE];
    
    // 작업관리 추가
    [workDic setObject:txtLocCode.text forKey:@"LOC_CD"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"L" forKey:@"TASK"];
    [taskDic setObject:barcode forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

- (void)setOffLineDeviceCd:(NSString*)barcode
{
    [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:MESSAGE_OFFLINE];
    
    // 작업관리
    [workDic setObject:barcode forKey:@"DEVICE_ID"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"D" forKey:@"TASK"];
    [taskDic setObject:barcode forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

- (void)setOfflineFacCd:(NSString*)barcode
{
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSString* errorMessage = @"";
    NSArray* goodsListInDB = [WorkUtil getBarcodeInfoInPDA:barcode errorMessage:errorMessage];
    
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (goodsListInDB == nil ){
        if(errorMessage.length){
            [self showMessage:errorMessage tag:-1 title1:@"닫기" title2:@"" isError:YES];
            isOperationFinished = YES;
            
            return;
        }
    }
    if(goodsListInDB == nil || (goodsList != nil && goodsList.count <= 0)){
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isOperationFinished = YES;
        return;
    }
    
    if ([goodsListInDB count]){
        for (NSDictionary* dic in goodsListInDB) {
            if ([dic objectForKey:@"MAKTX"] == nil){
                NSString* message = @"물품마스터를 업데이트 하세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
                return;
            }
            
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* compType = [dic objectForKey:@"COMPTYPE"];
            if ([compType isKindOfClass:[NSNull class]])
                compType = @"";
            NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
            [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
            [sapDic setObject:@"설비마스터 없음" forKey:@"ZPSTATU"];
            [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
            [sapDic setObject:@"" forKey:@"ZEQUIPGC"];
            [sapDic setObject:@"" forKey:@"HEQUNR"];
            [sapDic setObject:@"" forKey:@"ZPPART"];
            [sapDic setObject:@"1" forKey:@"LEVEL"];    // 무조건 level을 1로...  계층구조 아님.
            [sapDic setObject:@"" forKey:@"ZKOSTL"];
            [sapDic setObject:@"" forKey:@"ZKTEXT"];
            [sapDic setObject:@"6" forKey:@"SCANTYPE"];
            [sapDic setObject:@"N/N/N/N/N" forKey:@"ORG_CHECK"];
            [sapDic setObject:@"N" forKey:@"MASTER"];
            [sapDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [sapDic setObject:@"" forKey:@"CHILD"];
            [sapDic setObject:@"" forKey:@"ANCESTOR"];
            [originalSAPList addObject:sapDic];
        }
        
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        [self reloadTableWithRefresh:NO];
        nSelectedRow = fccSAPList.count -1;
        
        [_tableView reloadData];
        [self showCount];
        [self scrollToIndex:nSelectedRow];
        
        //일치율 보여주기 위해 선택할 셀 선택
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0] ];
        
        //working task add
        if (strFccBarCode.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"F" forKey:@"TASK"];
            [taskDic setObject:strFccBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
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

- (void) deviceBecameFirstResponder
{
    if (![txtDeviceCode isFirstResponder])
        [txtDeviceCode becomeFirstResponder];
}

- (void) locBecameFirstResponder
{
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}

- (void) showScanCount
{
    int shelfCount = 0;
    int rackCount = 0;
    int unitCount = 0;
    int equipCount = 0;
    int totalCount = 0;
    NSString* formatString = nil;
    
    
    for(NSDictionary* dic in originalSAPList)
    {
        NSString* partName = [dic objectForKey:@"PART_NAME"];
        if ([partName isEqualToString:@"R"])
            rackCount++;
        else if ([partName isEqualToString:@"S"])
            shelfCount++;
        else if ([partName isEqualToString:@"U"])
            unitCount++;
        else if ([partName isEqualToString:@"E"])
            equipCount++;
    }
    
    totalCount =  rackCount + shelfCount + unitCount + equipCount;
    formatString = [NSString stringWithFormat:@"R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount,shelfCount,unitCount,equipCount,totalCount];
    lblCount.text = formatString;
    
}

- (void) showCount
{
    int shelfCount2 = 0;
    int rackCount2 = 0;
    int unitCount2 = 0;
    int equipCount2 = 0;
    int totalCount2 = 0;
    int okCount = 0;
    int addCount = 0;
    
    NSString* formatString;
    
    if (originalSAPList.count){
        if (isFirst){
            dbRackCount = 0;
            dbSehlfCount = 0;
            dbUnitCount = 0;
            dbEquipCount = 0;
            dbTotalCount = 0;
            NSArray* spotDBList = [WorkUtil getSpotDBList:originalSAPList];
            
            for(NSDictionary* dic in spotDBList)
            {
                NSString* partName = [dic objectForKey:@"PART_NAME"];
                if ([partName isEqualToString:@"R"])
                    dbRackCount++;
                else if ([partName isEqualToString:@"S"])
                    dbSehlfCount++;
                else if ([partName isEqualToString:@"U"])
                    dbUnitCount++;
                else if ([partName isEqualToString:@"E"])
                    dbEquipCount++;
                
            }
            //DB count
            dbTotalCount =  dbRackCount + dbSehlfCount + dbUnitCount + dbEquipCount;
        }
        
        NSArray* spotScanList = [WorkUtil getSpotScanList:originalSAPList];
        for(NSDictionary* dic in spotScanList)
        {
            NSString* partName = [dic objectForKey:@"PART_NAME"];
            addCount++;
            if ([partName isEqualToString:@"R"])
                rackCount2++;
            else if ([partName isEqualToString:@"S"])
                shelfCount2++;
            else if ([partName isEqualToString:@"U"])
                unitCount2++;
            else if ([partName isEqualToString:@"E"])
                equipCount2++;
            
        }
        okCount = [WorkUtil getRealCount:originalSAPList];
        
        NSArray* spotAddList = [WorkUtil getSpotAddList:originalSAPList];
        addCount = (int)[spotAddList count];
    }
    
    
    formatString = [NSString stringWithFormat:@"DB:R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",(int)dbRackCount,(int)dbSehlfCount,(int)dbUnitCount,(int)dbEquipCount,(int)dbTotalCount];
    lblCount.text = formatString;
    
    //Scan count
    totalCount2 =  rackCount2 + shelfCount2 + unitCount2 + equipCount2;
    formatString = [NSString stringWithFormat:@"스캔:R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount2,shelfCount2,unitCount2,equipCount2,totalCount2];
    lblScanCount.text = formatString;
    
    float percent = 0.00f;
    
    if (originalSAPList.count){
        percent = (1.0 * okCount / (dbTotalCount + addCount)) * 100;
    }
    
    if(isHiddenList){
        percent = (1.0 * okCount / nHiddenTotalCount) * 100;
    }
    
    if (percent < 50.0f)
        lblPercent.textColor = [UIColor redColor];
    else if (percent < 80.0f)
        lblPercent.textColor = [UIColor purpleColor];
    else if (percent < 90.0f)
        lblPercent.textColor = RGB(65,105,225); //royal blue
    else  if(percent < 100.0f)
        lblPercent.textColor = [UIColor blueColor];
    
    lblPercent.text = [NSString stringWithFormat:@"실물일치율:%0.2f%%",percent];
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (_tableView.contentSize.height > _tableView.bounds.size.height) {
        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
    }
    
    [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

- (void)scrollToIndex:(NSInteger)index
{
    CGFloat yOffset = 0;
    
    if (index >= 0){
        if (_tableView.contentSize.height > _tableView.frame.size.height) {
            NSArray* visibleCells = _tableView.visibleCells;
            CommonCell* firstcell = [visibleCells firstObject];
            CommonCell* lastcell = [visibleCells lastObject];
            
            if (lastcell && firstcell){
                NSIndexPath* lastPath = [_tableView indexPathForCell:lastcell];
                NSIndexPath* firstPath = [_tableView indexPathForCell:firstcell];
                
                if (index == 0) yOffset = 0.0f;
                else if ( index >= firstPath.row && index <= lastPath.row)
                    return;
                else if (index <= lastPath.row)
                    yOffset =  (lastcell.bounds.size.height * index);
                else{
                    if (index == fccSAPList.count - 1)
                        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
                    else
                        yOffset =  _tableView.bounds.size.height + lastcell.bounds.size.height * (index - lastPath.row);
                }
            }
        }
        [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}

-(int) getGoodsFromDB:(NSString*)barcode
{
    NSDictionary* dic = [WorkUtil getMaterial:barcode];
    
    NSString* bismt = [dic objectForKey:@"bismt"];
    NSString* matnr = [dic objectForKey:@"matnr"];
    
    if (bismt.length == 0 &&  matnr.length == 0)
    {
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
        
        NSString* errMessage = [NSString stringWithFormat:@"%@는 처리할수 없는 바코드입니다.",strFccBarCode];
        [self showMessage:errMessage tag:-1 title1:@"닫기" title2:nil];
        
        
        return -1;
    }
    NSString* sql = nil;
    
    sql = SELECT_ITEM_BY_GOODS;
    if (matnr.length && bismt.length){
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE MATNR = '%@' AND BISMT = '%@'",matnr,bismt]];
    }
    else if (matnr.length)
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE MATNR = '%@'",matnr]];
    
    else if (bismt.length)
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@"WHERE BISMT = '%@'",bismt]];
    
    
    NSArray* dbDataList = [[DBManager sharedInstance] executeSelectQuery:sql];
    if (dbDataList.count)
        goodsList = [NSArray arrayWithArray:dbDataList];
    return (int)[dbDataList count];
}


- (void) processFacCode
{
    if (originalSAPList.count){
        
        NSString* scanValue = nil;
        NSString* checkValue = nil;
        
        BOOL isReal; // 존재하는 설비인지 여부 - 존재하지 않으면 무조건 실물 불일치
        
        int index = [WorkUtil getBarcodeIndex:strFccBarCode fccList:originalSAPList];
        
        if ( index != -1){ //기존 테이블에서 존재하면
            
            NSMutableDictionary* nodeDic = [originalSAPList objectAtIndex:index];
            
            scanValue = [nodeDic objectForKey:@"SCANTYPE"]; //최초스캔타입
            
            NSString* barcode = [nodeDic objectForKey:@"EQUNR"];
            NSString* upperbarcode = [nodeDic objectForKey:@"HEQUNR"];
            NSString* orgCode = [nodeDic objectForKey:@"ZKOSTL"];
            NSString* locCode = [nodeDic objectForKey:@"ZEQUIPLP"];
            NSString* deviceCode = [nodeDic objectForKey:@"ZEQUIPGC"];
            
            NSDictionary* duplicateDic = [originalSAPList objectAtIndex:index];
            NSString* sapbarcode;
            if (strFccBarCode.length){
                sapbarcode = [duplicateDic objectForKey:@"EQUNR"];
                if (![strFccBarCode isEqualToString:sapbarcode]){
                    if ([sapbarcode rangeOfString:strFccBarCode].location != NSNotFound){
                        strFccBarCode = sapbarcode;
                        txtFacCode.text = strFccBarCode;
                    }
                }
            }
            
            // 최초 또는 설비상태 또는 광모듈 스캔시 1로 셋팅
            if (
                [scanValue isEqualToString:@"0"] ||
                [scanValue isEqualToString:@"4"] ||
                [scanValue isEqualToString:@"9"]
                ){
                
                isReal = YES;
                
                //실물일치
                if (
                    isReal &&
                    [barcode isEqualToString:strFccBarCode]
                    ){
                    checkValue = @"Y";
                    btnReal.selected = YES;
                }
                else {
                    checkValue = @"N";
                    btnReal.selected = NO;
                }
                
                //상위일치 - 창고/실 점검시 무조건 N
                if (
                    !isVirtualFlag &&
                    [upperbarcode isEqualToString:upperbarcode]
                    )
                {
                    checkValue = [checkValue stringByAppendingString:@"/Y"];
                    btnUpper.selected = YES;
                }
                else {
                    checkValue = [checkValue stringByAppendingString:@"/N"];
                    btnUpper.selected = NO;
                }
                
                // 부서일치
                if ([orgCode isEqualToString:strUserOrgCode]
                    )
                {
                    checkValue = [checkValue stringByAppendingString:@"/Y"];
                    btnDept.selected = YES;
                }
                else {
                    checkValue = [checkValue stringByAppendingString:@"/N"];
                    btnDept.selected = NO;
                }
                
                // 위치일치
                // 스캔한 위치바코드와 설비의 위치바코드가 동일할 때
                if ([locCode isEqualToString:strLocBarCode]
                    )
                {
                    checkValue = [checkValue stringByAppendingString:@"/Y"];
                    btnLoc.selected = YES;
                }
                else {
                    checkValue = [checkValue stringByAppendingString:@"/N"];
                    btnLoc.selected = NO;
                }
                // 장치일치 - 창고/실 점검시 무조건 N
                if (
                    !isVirtualFlag &&
                    [deviceCode isEqualToString:strDeviceID]
                    )
                {
                    checkValue = [checkValue stringByAppendingString:@"/Y"];
                    btnDevice.selected = YES;
                }
                else {
                    checkValue = [checkValue stringByAppendingString:@"/N"];
                    btnDevice.selected = NO;
                }
                
                NSLog(@"checkValue [%@]",checkValue);
                
                [nodeDic setObject:checkValue forKey:@"ORG_CHECK"];
                [nodeDic setObject:@"1" forKey:@"SCANTYPE"];
                nSelectedRow = index;
                [originalSAPList replaceObjectAtIndex:index withObject:nodeDic];
                
                NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
                [taskDic setObject:@"F" forKey:@"TASK"];
                [taskDic setObject:strFccBarCode forKey:@"VALUE"];
                [taskList addObject:taskDic];
                
                [self reloadTableWithRefresh:YES];
                [self scrollToIndex:nSelectedRow];
                
                //데이터 변경
                [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
                isDataSaved = NO;
                    
            }
            else { //scanvalue = 5 | 6
                // 5 - 설비마스터 존재
                // 6 - 물품마스터 존재
                // 없는 설비 추가 후 또 스캔시
                // 해당위치 장치에 없는 설비바코드입니다.
                //Public.SoundPlay(Public.사운드종류.정진우팀장님);
                //NSString* message = @"중복 스캔입니다.";
            
                NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",txtFacCode.text];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                nSelectedRow = index;
                [self reloadTableWithRefresh:YES];
                [self scrollToIndex:nSelectedRow];
                isOperationFinished = YES;
                return;
            }
            isOperationFinished = YES;
            
        }
        else{
            //테이블 행 추가
            if (!isOffLine)
                [self requestSAPInfo:strFccBarCode orgCode:@"" locCode:@"" deviceID:@""];
            else
                [self setOfflineFacCd:strFccBarCode];
            
            //데이터 변경
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
        }
        
    }
    else{
        if (!isOffLine)
            [self requestSAPInfo:strFccBarCode orgCode:@"" locCode:@"" deviceID:@""];
        else
            [self setOfflineFacCd:strFccBarCode];
        //데이터 변경
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    
    
}

- (void)reOrderList:(NSMutableArray*)list
{
    for (int childIndex=0; childIndex < list.count; childIndex++){
        NSDictionary* dic = [list objectAtIndex:childIndex];
        int parentIndex = [WorkUtil getBarcodeIndex:[dic objectForKey:@"HEQUNR"] fccList:list];
        if (parentIndex == -1 )
            continue;
        
        if (parentIndex > childIndex){
            NSDictionary* parentDic = [list objectAtIndex:parentIndex];
            NSDictionary* tmpDic = [parentDic mutableCopy];
            [list removeObject:parentDic];
            [list insertObject:tmpDic atIndex:childIndex];
        }
    }
}

- (void) reloadTableWithRefresh:(BOOL)isRefresh
{
    fccSAPList = [NSMutableArray array];
    for(int index = 0; index < originalSAPList.count; ){
        NSDictionary* dic = [originalSAPList objectAtIndex:index];
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        SubCategoryInfo category = [[dic objectForKey:@"exposeStatus"] intValue];
        
        if (category == SUB_CATEGORIES_NO_EXPOSE){
            NSString* selancestor = [dic objectForKey:@"ANCESTOR"];
            NSMutableIndexSet * childIndexSet = [NSMutableIndexSet indexSet];
            if (!selancestor.length) //최상위 레벨일 경우 ancestor 존재하지 않는다.
                selancestor = barcode;
            [WorkUtil getChildIndexesOfCurrentIndex:index fccList:originalSAPList childSet:childIndexSet isContainSelf:NO];
            index += [childIndexSet count];
        }
        index++;
        [fccSAPList addObject:dic];
    }
    
    if (isRefresh){
        [_tableView reloadData];
        [self showCount];
    }
}

- (void) reloadHiddenTableWithRefresh:(NSDictionary*)addList
{
    nHiddenSelectedRow = originalHiddenSAPList.count - 1;
    
    NSMutableArray *originalHiddenTempList = [NSMutableArray array];
    NSMutableArray *originalHiddenChildList = [NSMutableArray array];
    
    for(int index = 0; index < originalHiddenSAPList.count; index++){
        if([[[originalHiddenSAPList objectAtIndex:index] objectForKey:@"HEQUNR"] isEqualToString:[addList objectForKey:@"EQUNR"]]){
            [originalHiddenChildList addObject:[originalSAPList objectAtIndex:index]];
        }else{
            [originalHiddenTempList addObject:[originalSAPList objectAtIndex:index]];
        }
        
        if(index == originalHiddenSAPList.count - 1){
            nHiddenSelectedRow = originalHiddenTempList.count - 1;
            for(int index = 0; index < originalHiddenChildList.count; index++){
                [[originalHiddenChildList objectAtIndex:index] setValue:[addList objectForKey:@"EQUNR"] forKey:@"ANCESTOR"];
                [[originalHiddenChildList objectAtIndex:index] setValue:[addList objectForKey:@"EQUNR"] forKey:@"HEQUNR"];
                [[originalHiddenChildList objectAtIndex:index] setValue:[NSString stringWithFormat:@"%d", [[addList objectForKey:@"LEVEL"] intValue] + 1] forKey:@"LEVEL"];
                if(index == 0){
                    [[originalHiddenTempList objectAtIndex:nHiddenSelectedRow] setValue:[[originalHiddenChildList objectAtIndex:originalHiddenChildList.count - 1] objectForKey:@"EQUNR"] forKey:@"CHILD"];
                    [[originalHiddenTempList objectAtIndex:nHiddenSelectedRow] setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
                }
                [originalHiddenTempList addObject:[originalHiddenChildList objectAtIndex:index]];
            }
        }
    }
    
    nSelectedRow = nHiddenSelectedRow;
    originalSAPList = originalHiddenTempList;
    [_tableView reloadData];
    [self showCount];
}

- (NSArray*)remakeList:(NSArray*)result
{
    NSMutableArray *tempRemakeList = [[NSMutableArray alloc] init];
    tempRemakeList = [result mutableCopy];
    
    NSSortDescriptor *levelSorter = [[NSSortDescriptor alloc] initWithKey:@"LEVEL" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [tempRemakeList sortUsingDescriptors:[NSArray arrayWithObject:levelSorter]];
    
    return [tempRemakeList copy];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}


- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - UserInterface Action
- (IBAction) touchSaveBtn:(id)sender
{
    if([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        isDataSaved = YES;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void) touchTreeBtn:(id)sender
{
    int nTag = (int)[sender tag];
    
    //이전 셀
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
    cell.lblTreeData.textColor = [UIColor blackColor];
    
    nSelectedRow = nTag;
    NSMutableDictionary* selItemDic = [fccSAPList objectAtIndex:nTag];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
        
    }
    else{
        if (cellStatus == SUB_CATEGORIES_EXPOSED){ //delete (collapse)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_NO_EXPOSE] forKey:@"exposeStatus"];
            [self reloadTableWithRefresh:YES];
        }
        else { //insert (expand)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            [self reloadTableWithRefresh:YES];
        }
    }
}


- (IBAction) touchInitBtn
{
    isFirst = YES;
    //작업관리 초기화
    dbWorkDic = [NSMutableDictionary dictionary];
    isDataSaved = NO;
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    
    //offline 여부
    isOffLine = [[Util udObjectForKey:USER_OFFLINE] boolValue];
    
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
    //textfield 초기화
    txtLocCode.text = strLocBarCode = strDecryptLocBarCode = @"";
    txtFacCode.text = strFccBarCode = strDecryptFccBarCode = @"";
    txtDeviceCode.text = strDeviceID = strDecryptDeviceBarCode = @"";
    lblDeviceID.text = @"";
    lblPartType.text = @"";
    
    
    btnReal.selected = NO;
    btnDept.selected = NO;
    btnDevice.selected = NO;
    btnUpper.selected = NO;
    btnLoc.selected = NO;
    
    dbRackCount = 0;
    dbSehlfCount = 0;
    dbUnitCount = 0;
    dbEquipCount = 0;
    dbTotalCount = 0;
    
    if (!scrollLocName.hidden){
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
    }
    if (!scrollDeviceInfo.hidden){
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
    }
    
    //table초기화
    originalSAPList = [NSMutableArray array];
    fccSAPList = [NSMutableArray array];
    
    nSelectedRow = -1;
    [_tableView reloadData];
    
    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //히든데이터 초기화
    [self hiddenDataInit];
    
    [self showCount];
}


- (IBAction) touchOrgBtn:(id)sender
{
    //음영지역 아닐때만 호출
    if (isOffLine){
        NSString* message = @"'음영지역작업' 중에는\n조직을 선택할 수 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    
    OrgSearchViewController* vc = [[OrgSearchViewController alloc] init];
    vc.Sender = self;
    vc.isSearchMode = NO;
    [self.navigationController pushViewController:vc animated:NO];
}


- (IBAction)touchScanCancelBtn
{
    if (fccSAPList.count){
        if (fccSAPList.count -1 >= nSelectedRow){
            //추가한것은 삭제후.
            NSDictionary* subDic = [fccSAPList objectAtIndex:nSelectedRow];
            NSMutableDictionary* dic = [originalSAPList objectAtIndex:[WorkUtil getBarcodeIndex:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList]];
            NSInteger index = [originalSAPList indexOfObject:dic];
            NSString* scanValue = [dic objectForKey:@"SCANTYPE"];
            if (
                [scanValue isEqualToString:@"5"] ||
                [scanValue isEqualToString:@"6"] ||
                isHiddenList
                ){ //삭제
                [originalSAPList removeObjectAtIndex:index];
                
                if(isHiddenList)
                    [originalHiddenSAPList removeObjectAtIndex:index];
                
                [self reloadTableWithRefresh:NO];
                if (index < fccSAPList.count){
                    nSelectedRow = index;
                }
                else{
                    nSelectedRow = fccSAPList.count - 1;
                }
                
                if(!isHiddenList){
                    nSelectedRow = index - 1;
                }
                
                txtFacCode.text = [[fccSAPList objectAtIndex:nSelectedRow] objectForKey:@"EQUNR"];
            }
            else {
                [dic setObject:@"0" forKey:@"SCANTYPE"];
                [dic setObject:@"N/N/N/N/N" forKey:@"ORG_CHECK"];
                btnReal.selected = NO;
                btnDept.selected = NO;
                btnLoc.selected = NO;
                btnDevice.selected = NO;
                btnUpper.selected = NO;
            }
            [self reloadTableWithRefresh:YES];
            [self showCount];
            [self scrollToIndex:nSelectedRow];
            
            //작업관리 추가
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"CANCEL" forKey:@"TASK"];
            [taskDic setObject:[NSString stringWithFormat:@"%d",(int)nSelectedRow] forKey:@"VALUE"];
            [taskList addObject:taskDic];
            
        }
        if (originalSAPList.count <= 0)
            isFirstGetFccList = YES;    // 삭제 후 리스트에 아무것도 없는 경우에느 최초 리스트 갖고 올 때와 같이 처리한다.
    }
    else {
        NSString* message = @"선택된 항목이 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    
    isOperationFinished = YES;
}

- (IBAction) touchLocBtn:(id)sender
{
    if (!strDeviceID.length){
        NSString* message = @"장치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        [self performSelector:@selector(deviceBecameFirstResponder) withObject:nil afterDelay:NO];
    }
    else {
        [self requestDeviceCode:strDeviceID];
    }
}

- (void) touchBackBtn:(id)sender
{
    if (!isDataSaved && [Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }else{
        [txtFacCode resignFirstResponder];
        [txtLocCode resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction) touchSendBtn:(id)sender
{
    NSString* orgName = nil;
    if (receivedOrgDic.count)
        orgName = [receivedOrgDic objectForKey:@"orgName"];
    else
        orgName = strUserOrgName;
    
    int count = 0;
    for (NSDictionary* dic in originalSAPList)
    {
        if (isVirtualFlag && [[dic objectForKey:@"SCANTYPE"] isEqualToString:@"0"])
            continue;
        count++;
    }
    
    if(count == 0){
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
        [self showMessage:@"전송할 설비바코드가\n존재하지 않습니다." tag:-1 title1:@"닫기" title2:@"" isError:YES];
        return;
    }
    
    NSString* message = [NSString stringWithFormat:@"점검한 운용조직은\n'%@'\n입니다.\n\n전송하시겠습니까?",orgName];
    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
}

- (IBAction)touchBackground:(id)sender
{
    [txtLocCode resignFirstResponder];
    [txtFacCode resignFirstResponder];
}


#pragma mark - UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){
        if (buttonIndex == 0){ //전송
            [self requestSend];
        }
    }
    else if (alertView.tag == 200){ //현장점검 운용조직 다를때 계속 진행여부
        NSMutableDictionary* taskdic = [NSMutableDictionary dictionary];
        [taskdic setObject:@"CHANGE" forKey:@"TASK"];
        
        if (buttonIndex == 0){ //조직변경 sapList 직접변경
            [taskdic setObject:@"Y" forKey:@"VALUE"];
            // 선택값 저장
            isOrgProceed = YES;
        }
        else { //조직변경 안함
            [taskdic setObject:@"N" forKey:@"VALUE"];
            strLocBarCode = txtLocCode.text = strDecryptLocBarCode = @"";
            isOrgProceed = NO;
        }
        [taskList addObject:taskdic];
        [self processLocListAfter];
        
    }else if (alertView.tag == 1100){
        if (buttonIndex == 0){
            [txtFacCode resignFirstResponder];
            [txtLocCode resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }else if (alertView.tag == 999){
        if (isVirtualFlag){
            if (![txtLocCode isFirstResponder])
                [txtLocCode becomeFirstResponder];
        }
        else {
            if (![txtDeviceCode isFirstResponder])
                [txtDeviceCode becomeFirstResponder];
        }
    }else if(alertView.tag == 55){
        [self setWorkData];
    }
    
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
}

#pragma mark - Http Request Method
- (void)requestDeviceCode:(NSString*)deviceBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULTI_INFO;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestMultiInfoWithDeviceCode:deviceBarcode];
}

- (void)requestLocCodeByDeviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GETLOC_SPOTCHECK;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestGetLocSpotCheck:strDeviceID];
}

- (void)requestSpotSerial
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SPOT_SERIAL;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SPOT_SERIAL withData:rootDic];
}

- (void)requestGbicList
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GBIC_LIST;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestGbicList];
}

- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLocCode:locBarcode];
}

- (void) requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    
    NSDictionary* UserDic = [Util udObjectForKey:USER_INFO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
    
    //위도,경도 헤더에 추가
    // GPS 위치조회 하지 않는 방법으로 변경. 16.11.22
//    if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
//        [ERPLocationManager getInstance].locationDic != nil){
//        NSDictionary* deltaDic = [ERPLocationManager getInstance].locationDic;
//        
//        NSString* longitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LONGTITUDE"] floatValue]];
//        NSString* latitude =  [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LATITUDE"] floatValue]];
//        
//        [paramDic setObject:longitude forKey:@"LONGTITUDE"];
//        [paramDic setObject:latitude forKey:@"LATITUDE"];
//        
//        NSString* locFucllName = [[locResultList objectAtIndex:0] objectForKey:@"locationFullName"];
//        locFucllName = [WorkUtil getFullNameOfLoc:locFucllName];
//        
//        double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:locFucllName];
//        [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
//    }else{
//        [paramDic setObject:@"" forKey:@"LONGTITUDE"];
//        [paramDic setObject:@"" forKey:@"LATITUDE"];
//        [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
//        
//    }
    
    [paramDic setObject:@"0020" forKey:@"WORKID"];
    [paramDic setObject:@"0800" forKey:@"PRCID"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"dateString : %@", dateString );
    
    [paramDic setObject:dateString forKey:@"REQ_DATE"];
    
    //subParam 조립
    sendCount = 0;
    NSMutableArray* subParamList = [NSMutableArray array];
    
    for (NSDictionary* dic in originalSAPList)
    {
        NSString* scanValue = [dic objectForKey:@"SCANTYPE"];
        
        if (isVirtualFlag && [scanValue isEqualToString:@"0"])
            continue;
        NSMutableDictionary *subParamDic = [[NSMutableDictionary alloc] init];
        [subParamDic setObject:[dic objectForKey:@"LEVEL"] forKey:@"ZLEVEL"];
        
        NSString* partTypeName = [dic objectForKey:@"PART_NAME"];
        if ([partTypeName isEqualToString:@"E"])
            [subParamDic setObject:@"30" forKey:@"DEVTYPE"];
        else
            [subParamDic setObject:@"40" forKey:@"DEVTYPE"];
        NSString* status = nil;
        
//        status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
        status = [dic objectForKey:@"ZPSTATU"]; //설비상태코드(ZPSTATU)
        
        //현정점검 설비마스터 없음 일때에만 getFacilityStatusName 2017 02 24
        if([JOB_GUBUN isEqualToString:@"현장점검(창고/실)"]||[JOB_GUBUN isEqualToString:@"현장점검(베이)"]){ //2017 05 25
            if([status isEqualToString:@"설비마스터 없음"]){
                status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
                NSLog(@"status!!!!!!! %@", status);
            }
        }
        
        NSString* partType = [dic objectForKey:@"ZPPART"];
        if (partType.length)
            [subParamDic setObject:partType forKey:@"PARTTYPE"];
        else
            [subParamDic setObject:@"" forKey:@"PARTTYPE"];
        
        [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EXBARCODE"];
        [subParamDic setObject:status forKey:@"ZPSTATU"];
        [subParamDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUI"];
        if (!strDeviceID.length)
            [subParamDic setObject:@"" forKey:@"DEVICEID"];
        else
            [subParamDic setObject:strDeviceID forKey:@"DEVICEID"];
        
        [subParamDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
        
        // 조직변경 했으면 변경한 코스트센터를 보낸다......
        NSString* orgId = nil;
        if (receivedOrgDic.count)
            orgId = [receivedOrgDic objectForKey:@"costCenter"];
        else
            orgId = [UserDic objectForKey:@"orgId"];

        //[subParamDic setObject:[UserDic objectForKey:@"orgId"] forKey:@"ZKOSTL"];
        [subParamDic setObject:orgId forKey:@"ZKOSTL"];
        
        if (
            [scanValue isEqualToString:@"5"] ||
            [scanValue isEqualToString:@"6"]
            )
            [subParamDic setObject:@"2" forKey:@"SCAN"];
        else if (
                 [scanValue isEqualToString:@"4"] ||
                 [scanValue isEqualToString:@"9"]
                 )
            [subParamDic setObject:@"1" forKey:@"SCAN"];
        else
            [subParamDic setObject:scanValue forKey:@"SCAN"];
        
        NSString* checkValue = [dic objectForKey:@"ORG_CHECK"];
        if (checkValue.length){
            NSArray* checkList = [checkValue componentsSeparatedByString:@"/"];
            if (checkList.count == 5){
                [subParamDic setObject:[checkList objectAtIndex:0] forKey:@"ZEQUIPCB"]; //실물
                [subParamDic setObject:[checkList objectAtIndex:1] forKey:@"ZEQUIPCM"]; //상위
                [subParamDic setObject:[checkList objectAtIndex:2] forKey:@"ZEQUIPCF"]; //조직
                [subParamDic setObject:[checkList objectAtIndex:3] forKey:@"ZEQUIPCN"]; //위치
                [subParamDic setObject:[checkList objectAtIndex:4] forKey:@"ZEQUIPCU"]; //장치
            }
            else {
                [subParamDic setObject:@"N" forKey:@"ZEQUIPCB"]; //실물
                [subParamDic setObject:@"N" forKey:@"ZEQUIPCM"]; //상위
                [subParamDic setObject:@"N" forKey:@"ZEQUIPCF"]; //조직
                [subParamDic setObject:@"N" forKey:@"ZEQUIPCN"]; //위치
                [subParamDic setObject:@"N" forKey:@"ZEQUIPCU"]; //장치
            }
        }
        
        [subParamDic setObject:[dic objectForKey:@"MASTER"] forKey:@"ZEQUIPCR"]; //설비마스터 존재여부
        if (strSpotSerial.length)
            [subParamDic setObject:strSpotSerial forKey:@"SUBDEVICEID"]; //spot serial
        else
            [subParamDic setObject:@"" forKey:@"SUBDEVICEID"]; //spot serial
        
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SEND_SPOTCHECK withData:rootDic];
}

- (void)requestFccInfo:(NSString*)fccBarcode
{
    NSString* errMessage = [WorkUtil messageChkValidateFccItem:fccBarcode];
    
    if (errMessage.length){
        [self showMessage:errMessage tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_ITEM_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSDictionary* dic = [WorkUtil getMaterial:fccBarcode];
    
    NSString* bismt = [dic objectForKey:@"bismt"];
    NSString* matnr = [dic objectForKey:@"matnr"];
    
    [requestMgr requestFccItemInfo:bismt matnr:matnr maktx:@"" maktxEnable:NO];
}

- (void)requestSAPInfo:(NSString*)fccBarcode orgCode:(NSString*)orgCode locCode:(NSString*)locCode deviceID:(NSString*)deviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSAPInfo:fccBarcode locCode:locCode deviceID:deviceID  orgCode:orgCode isAsynch:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([[UITextInputMode currentInputMode].primaryLanguage hasPrefix:@"ko"]){
        NSString* convertString = [NSString HanToEngBarcode:string];
        textField.text = [textField.text stringByAppendingString:convertString];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fccSAPList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCell *cell = (CommonCell*)[tableView dequeueReusableCellWithIdentifier:@"CommonCell"];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
        for (id object in nib)
        {
            if ([object isMemberOfClass:[CommonCell class]])
            {
                cell = object;
                
                break;
            }
        }
    }
    
    NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
    
    NSString* scanType = nil;
    NSString* partTypeName = nil;
    
    
    if ([fccSAPList count]){
        
        partTypeName = [dic objectForKey:@"PART_NAME"];
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        NSString* status = nil;
        
        if ([[dic objectForKey:@"ZPSTATU"] length] != 4) //설비마스터 없음
            status = [dic objectForKey:@"ZPSTATU"]; //설비상태코드(ZPSTATU)
        else
            status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
        
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        if (barcodeName== nil)
            barcodeName = @"";
        else
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        NSString* locID = [dic objectForKey:@"ZEQUIPLP"]; //위치코드
        scanType = [dic objectForKey:@"SCANTYPE"];
        NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
        NSString* orgName = [dic objectForKey:@"ZKTEXT"];
        NSString* checkOrg =[dic objectForKey:@"ORG_CHECK"];
        NSString* level =[dic objectForKey:@"LEVEL"];
        NSString* parentBarcode = [dic objectForKey:@"HEQUNR"];
        NSString* deviceID = [dic objectForKey:@"ZEQUIPGC"];
        
        NSString* formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@_%@:%@",partTypeName,barcode,status,barcodeName,parentBarcode,locID,deviceID,scanType,orgCode,orgName,checkOrg];
        CGFloat textLength = [formatString sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
        
        if (level.length)
            cell.indentationLevel = [level integerValue];
        else
            cell.indentationLevel = 1;
        
        [cell setIndentationWidth:10.0f];
        
        cell.scrollView.contentSize = CGSizeMake(textLength + 40, COMMON_CELL_HEIGHT);
        
        cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength+cell.indentationLevel*cell.indentationWidth, cell.lblTreeData.frame.size.height);
        
        cell.lblTreeData.text = formatString;
        
    }
    if (nSelectedRow == indexPath.row){
        cell.lblTreeData.textColor = [UIColor blueColor];
        lblPartType.text = [dic objectForKey:@"PART_NAME"];
    }else
        cell.lblTreeData.textColor = [UIColor blackColor];
    
    cell.nScanType = [scanType integerValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hasSubNode = YES;
    
    if (
        [scanType isEqualToString:@"1"] ||
        [scanType isEqualToString:@"4"] ||
        [scanType isEqualToString:@"9"]
        )
        cell.lblBackground.backgroundColor = COLOR_SCAN1;
    else if ([scanType isEqualToString:@"5"])
        cell.lblBackground.backgroundColor = RGB(255,182,193);
    else if ([scanType isEqualToString:@"6"])
        cell.lblBackground.backgroundColor = [UIColor redColor];
    
    if (nSelectedRow == indexPath.row)
        cell.lblTreeData.textColor = [UIColor blueColor];
    else
        cell.lblTreeData.textColor = [UIColor blackColor];
    
    if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_NO_CATEGORIES){
        cell.btnTree.hidden = YES;
        cell.hasSubNode = NO;
    }
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_NO_EXPOSE){
        cell.btnTree.hidden = NO;
        cell.btnTree.tag = indexPath.row;
        [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_EXPOSED){
        cell.btnTree.hidden = NO;
        cell.btnTree.tag = indexPath.row;
        [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCell* cell =(CommonCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableViewArg didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (fccSAPList.count){
        NSMutableDictionary* selItemDic = [fccSAPList objectAtIndex:indexPath.row];
        NSString* checkValue = [selItemDic objectForKey:@"ORG_CHECK"];
        
        txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
        
        [txtFacCode becomeFirstResponder];
        lblPartType.text = [selItemDic objectForKey:@"PART_NAME"];
        
        NSArray* checkList = [checkValue componentsSeparatedByString:@"/"];
        NSLog(@"checkValue [%@]",checkValue);
        NSString* tokenString = nil;
        
        if (checkList.count == 5){
            //실물
            tokenString = [checkList objectAtIndex:0];
            btnReal.selected = ([tokenString isEqualToString:@"Y"])  ? YES:NO;
            //상위
            tokenString = [checkList objectAtIndex:1];
            btnUpper.selected = ([tokenString isEqualToString:@"Y"]) ? YES:NO;
            //부서
            tokenString = [checkList objectAtIndex:2];
            btnDept.selected = ([tokenString isEqualToString:@"Y"])  ? YES:NO;
            //위치
            tokenString = [checkList objectAtIndex:3];
            btnLoc.selected = ([tokenString isEqualToString:@"Y"])   ? YES:NO;
            //장치
            tokenString = [checkList objectAtIndex:4];
            btnDevice.selected = ([tokenString isEqualToString:@"Y"])   ? YES:NO;
        }
        
    }
    
    nSelectedRow = indexPath.row;
    [_tableView reloadData];
    
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blueColor];
    
    [tableViewArg deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    if (status == 0 || status == 2){ //실패
        
        isOperationFinished = YES;
        
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if(pid == REQUEST_SAP_FCC_COD && [JOB_GUBUN hasPrefix:@"현장점검"]){
            if([headerDic objectForKey:@"totalCount"] != nil && [[headerDic objectForKey:@"totalCount"] intValue] > 0){
                isHiddenList = YES;
                isHiddenListChild = YES;
                nHiddenTotalCount = [[headerDic objectForKey:@"totalCount"] integerValue];
            }
            
            NSDictionary* headerDic = [resultList objectAtIndex:0];
            NSString* message = [headerDic objectForKey:@"detail"];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        if (pid == REQUEST_SAP_FCC_COD && strFccBarCode.length){
            [self requestFccInfo:strFccBarCode];
            return;
        }
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
        if (pid == REQUEST_SEND){
            if (status == 0)
                [workDic setObject:@"E" forKey:@"TRANSACT_YN"];
            else if (status == 2)
                [workDic setObject:@"W" forKey:@"TRANSACT_YN"];
            [workDic setObject:message forKey:@"TRANSACT_MSG"];
            [self saveToWorkDB];
            isDataSaved = YES;
        }
        if (strFccBarCode.length) {
            [self processFailRequest:pid Message:message];
        }
        
        return;
    }else if (status == -1){ //세션종료
        [self processEndSession:pid];
        isOperationFinished = YES;
        
        return;
    }
    
    NSLog(@"processRequest => %u", pid);
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == REQUEST_MULTI_INFO){
        if (resultList)
            [self processDeviceBarcode:[resultList objectAtIndex:0]];
        else
            [self processDeviceBarcode:nil];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPInfoResponse:resultList];
    }else if (pid == REQUEST_ITEM_FCC_COD){
        [self processFccItemInfoResponse:resultList];
    }else if (pid == REQUEST_GETLOC_SPOTCHECK){
        [self processGetLocSpotCheckResponse:resultList];
    }else if (pid == REQUEST_SPOT_SERIAL){
        [self processSpopSerialResponse:resultList];
    }else if (pid == REQUEST_GBIC_LIST){
        [self processGbicListResponse:resultList];
    }else if (pid == REQUEST_SEND){
        [self processSendResponse:resultList statusCode:status];
    }
    else isOperationFinished = YES;
}

- (void)processDeviceBarcode:(NSDictionary*)deviceInfo
{
    [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:[NSString stringWithFormat:@"%@/%@",[deviceInfo objectForKey:@"itemCode"],[deviceInfo objectForKey:@"itemName"]]];
    
    NSString* osToken = [deviceInfo objectForKey:@"operationSystemToken"];
    NSString* standardServiceCode = [deviceInfo objectForKey:@"standardServiceCode"];
    strLocID = [deviceInfo objectForKey:@"operationSystemCode"];
    deviceLocCd = [deviceInfo objectForKey:@"locationCode"];
    deviceLocNm = [deviceInfo objectForKey:@"locationShortName"];
    
    if (strLocID.length)
        lblDeviceID.text = strLocID;
    
    if (
        [osToken isEqualToString:@"04"] ||
        [osToken isEqualToString:@"08"] ||
        [osToken isEqualToString:@"09"] ||
        [osToken isEqualToString:@"10"] ||
        [osToken isEqualToString:@"69"] ||
        [osToken isEqualToString:@"79"] ||
        [osToken isEqualToString:@"89"] ||
        [osToken isEqualToString:@"99"]
        )
        isWireless = YES; // 무선 장비아이디 스캔 구분
    else
        isWireless = NO;
    
    if ( [osToken isEqualToString:@"02"] && ![standardServiceCode length]){
        NSString* message = [NSString stringWithFormat:@"장치아이디 %@는\n운용시스템 구분자가 'ITAM'이며 \n IT표준서비스코드가 '없음'이므로\n스캔이 불가합니다.\n전사기준정보관리시스템(MDM)에\n문의하세요",strDeviceID];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        strDecryptDeviceBarCode = @"";
        
        return;
    }
    
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"])
        [self requestLocCodeByDeviceID];
    else
        isOperationFinished = YES;
}


- (void)processGetLocSpotCheckResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSMutableArray* locList = [NSMutableArray array];
        //첫번째 행이 데이터 없는게 존재해서 스킵처리
        for (NSDictionary* dic in resultList)
        {
            NSString* locCode = [dic objectForKey:@"ZEQUIPLP"];
            if (!locCode.length)
                continue;
            // 무선 장비아이디 또는 장치바코드 스캔시 설비가 많으므로 현장점검(창고/실)로 유도
            if (isWireless){ //무선일때 1개만 처리
                [self performSelectorOnMainThread:@selector(setLocBecomeFirstResponder) withObject:nil waitUntilDone:NO];
                
                NSString* message = @"'가상창고/실' 위치 점검은\n'현장점검(창고/실)'\n메뉴를 사용하시기 바랍니다";
                [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
                return;
            }
            [locList addObject:dic];
        }
        LocListViewController* vc = [[LocListViewController alloc] init];
        vc.locList = locList;
        vc.sender = self;
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    else {
        NSString* message = @"조회된 위치코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        if (!isVirtualFlag)
            [self performSelectorOnMainThread:@selector(deviceBecameFirstResponder) withObject:nil waitUntilDone:NO];
        
        return;
    }
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}


- (void)processSpopSerialResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        strSpotSerial = [dic objectForKey:@"SERIAL"];
        // 자체점검 ( 000000001 ) 이 아니면 워닝 메세지 출력
        if (![strSpotSerial isEqualToString:@"000000001"]){
            NSString* message = @"본사 점검 기간입니다.\n점검 결과는 평가에 반영됩니다.\n신중히 진행하시기 바랍니다.";
            [self showMessage:message tag:55 title1:@"닫기" title2:nil];
            return;
        }
    }
    
    [self setWorkData];
}

- (void)processGbicListResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        gbicList = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in resultList)
        {
            [gbicList addObject:[dic objectForKey:@"itemCode"]];
        }
    }
    
    [self setView];
}

- (void)processLocList:(NSArray*)resultList
{
    if ([resultList count]){
        isFirstGetFccList = NO;
        spotLocDic = nil;
        spotLocDic = [resultList objectAtIndex:0];
        
        if(strLocBarCode.length < 10){
            strLocBarCode = [spotLocDic objectForKey:@"completeLocationCode"];
            txtLocCode.text = strLocBarCode;
        }
        
        // 2.	운용조직과 스캔한 가상창고 위치바코드의 조직정보가 상이한 경우 [운용조직과 스캔한 창고의 조직정보가 상이합니다. 진행하시겠습니까?] Y이면 진행,
        // N면 위치바코드 필드 초기화하여 진행 불가 - request by 정진우 2013.06.05
        if (isVirtualFlag && [strLocBarCode hasPrefix:@"VS"]){ //창고/실
            NSString* zkostl = [spotLocDic objectForKey:@"zkostl"];
            NSString* zktext = [spotLocDic objectForKey:@"zktext"];
            if (![strUserOrgCode isEqualToString:zkostl]){
                NSString* message = [NSString stringWithFormat:@"운용조직\n(%@) 정보와\n스캔한 가상창고의 조직\n(%@) 정보가\n상이합니다.\n진행하시겠습니까?",strUserOrgName,zktext];
                [self showMessage:message tag:200 title1:@"예" title2:@"아니오"];
                return;
            }
            else {
                isOrgProceed = YES;
            }
        }
        else{
            isOrgProceed = YES;
        }
        
        [self processLocListAfter];
    }
}

- (void)processLocListAfter
{
    if (isOrgProceed){
        if (isVirtualFlag){
            if ( strLocBarCode.length > 17 &&
                ![strLocBarCode hasPrefix:@"VS"] &&
                ![[strLocBarCode substringFromIndex:17] isEqualToString:@"0000"]
                ){
                NSString* message = @"'베이' 점검은 '현장점검(베이)'\n메뉴를 사용하시기 바랍니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                txtLocCode.text = strLocBarCode = strDecryptLocBarCode = @"";
                [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
                
                return;
            }
            
            [Util setScrollTouch:scrollLocName Label:lblLocName withString:[spotLocDic objectForKey:@"locationShortName"]];
            
            if (strDeviceID.length)
                [workDic setObject:strDeviceID forKey:@"DEVICE_ID"];
            
            //조직설정
            if (receivedOrgDic.count){
                [self requestSAPInfo:@"" orgCode:[receivedOrgDic objectForKey:@"costCenter"] locCode:strLocBarCode deviceID:strDeviceID];
            }
            else {
                [self hiddenDataInit];
                if (![strLocBarCode hasPrefix:@"VS"])
                    [self requestSAPInfo:@"" orgCode:strUserOrgCode locCode:strLocBarCode deviceID:strDeviceID];                    
                else
                    [self requestSAPInfo:@"" orgCode:@"" locCode:strLocBarCode deviceID:strDeviceID];
            }
        }
        else { //베이
            [Util setScrollTouch:scrollLocName Label:lblLocName withString:[spotLocDic objectForKey:@"locationShortName"]];
            
            [self requestSAPInfo:@"" orgCode:@"" locCode:strLocBarCode deviceID:strDeviceID];
        }
        
        //working task add
        if (strDeviceID.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"D" forKey:@"TASK"];
            [taskDic setObject:strDeviceID forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        if (strLocBarCode.length){
            //작업관리 추가
            [workDic setObject:strLocBarCode forKey:@"LOC_CD"];
            //working task add
            NSMutableDictionary*taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"L" forKey:@"TASK"];
            [taskDic setObject:strLocBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }else{
        isOperationFinished = YES;
    }
}

- (void)processSendResponse:(NSArray*)resultList statusCode:(NSInteger)statusCode
{
    /*
     "E_RSLT": "S",
     "E_MESG": "전송하신 Data가 정상 처리되었습니다.",
     "EAI_RTCD": "",
     "EAI_MSG": ""
     */
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSString* result = [dic objectForKey:@"E_RSLT"];
        NSString* message = [dic objectForKey:@"E_MESG"];
        
        [workDic setObject:result forKey:@"TRANSACT_YN"];
        if (message.length)
            [workDic setObject:message forKey:@"TRANSACT_MSG"];
        [self saveToWorkDB];
        isDataSaved = YES;
        
        if ([result isEqualToString:@"S"]){
            NSString* print_message = [NSString stringWithFormat:@"# 전송건수 : %d건\n%d-%@",sendCount,(int)statusCode, message];
            [self showMessage:print_message tag:999 title1:@"닫기" title2:nil];
            
            [self touchInitBtn];
        }
    }
}

- (void)processFccItemInfoResponse:(NSArray *)resultList
{
    if ([resultList count]){
        //데이터 1개
        for (NSDictionary* dic in resultList) {
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* compType = [dic objectForKey:@"COMPTYPE"];
            if ([compType isKindOfClass:[NSNull class]])
                compType = @"";
            NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
            [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
            [sapDic setObject:@"설비마스터 없음" forKey:@"ZPSTATU"];
            [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
            [sapDic setObject:@"" forKey:@"HEQUNR"];
            [sapDic setObject:@"" forKey:@"ZPPART"];
            [sapDic setObject:@"1" forKey:@"LEVEL"];    // 무조건 level을 1로...  계층구조 아님.
            [sapDic setObject:@"" forKey:@"ZKOSTL"];
            [sapDic setObject:@"" forKey:@"ZKTEXT"];
            [sapDic setObject:@"6" forKey:@"SCANTYPE"];
            [sapDic setObject:@"N/N/N/N/N" forKey:@"ORG_CHECK"];
            [sapDic setObject:@"N" forKey:@"MASTER"];
            [sapDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [sapDic setObject:@"" forKey:@"CHILD"];
            [sapDic setObject:@"" forKey:@"ANCESTOR"];
            [originalSAPList addObject:sapDic];
        }
        
        [Util playSoundWithFileName:SOUND_JUNG fileFormat:EXT_WAVE];
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        [self reloadTableWithRefresh:NO];
        nSelectedRow = fccSAPList.count -1;
        [_tableView reloadData];
        [self showCount];
        [self scrollToIndex:nSelectedRow];
        
        //일치율 보여주기 위해 선택할 셀 선택
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0] ];
        
        //working task add
        if (strFccBarCode.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"F" forKey:@"TASK"];
            [taskDic setObject:strFccBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
}

- (void)processSAPInfoResponse:(NSArray*)resultList
{
    isHiddenListChild = NO;
    if ([resultList count]){
        // 유효성 체크 - 현장점검에서는 필요없나?
        
        resultList = [self remakeList:resultList];
        
        
        if (strFccBarCode.length){
            NSDictionary* firstDic = [resultList objectAtIndex:0];
            //장비상태 체크
            NSString* status = [firstDic objectForKey:@"ZPSTATU"];
            NSString* desc = [firstDic objectForKey:@"ZDESC"];
            NSString* submt = [firstDic objectForKey:@"SUBMT"];
            
            NSString* errorMessage = [WorkUtil processCheckFccStatus:status desc:desc submt:submt];
            if (errorMessage.length){
                [self showMessage:errorMessage tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                return;
            }
        }
        
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        
        BOOL isEmptyList = YES;
        if (originalSAPList.count)
            isEmptyList = NO;
        
        if(isHiddenList){
            isEmptyList = YES;
            NSDictionary* hiddenFccDic = [resultList objectAtIndex:0];
            NSString* zequiplp = [hiddenFccDic objectForKey:@"ZEQUIPLP"];
            if(![txtLocCode.text isEqualToString:zequiplp])
                isEmptyList = NO;
            else
                isHiddenListChild = YES;
        }
        
        for (NSDictionary* dic in resultList) {
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            if (isEmptyList){
                NSString* barcode = [dic objectForKey:@"EQUNR"];
                if (strFccBarCode.length && ![strFccBarCode isEqualToString:barcode]){
                    if ([barcode rangeOfString:strFccBarCode].location != NSNotFound){
                        strFccBarCode = barcode;
                        txtFacCode.text = strFccBarCode;
                    }
                }
            }
            
            NSString* zpstatu = [dic objectForKey:@"ZPSTATU"];
            NSString* maktx = [dic objectForKey:@"MAKTX"];
            NSString* equnr = [dic objectForKey:@"EQUNR"];
            NSString* submt = [dic objectForKey:@"SUBMT"];
            NSString* zkostl = [dic objectForKey:@"ZKOSTL"];
            NSString* locCode = [dic objectForKey:@"ZEQUIPLP"];
            NSString* deviceCode = [dic objectForKey:@"ZEQUIPGC"];
            NSString* upperBarcode = [dic objectForKey:@"HEQUNR"];
            
            NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            NSString* scanValue = nil;
            
            
            if (!isEmptyList)
                scanValue = @"5";
            else if (isFirstGetFccList){
                scanValue = @"5";
                isFirstGetFccList = NO;
            }
            else
                scanValue = @"0";
            
            //- 현장점검 메뉴에서 점검 대상 위치와 장치를 스캔했을때 "dummy, 사용중지,불용확정, 납품취소" 설비를 제외하고 점검 대상으로 호출
            if (
                [zpstatu isEqualToString:@"0021"] || // 납품취소
                [zpstatu isEqualToString:@"0240"] || // 불용확정
                [zpstatu isEqualToString:@"0260"]    // 사용중지
                ){
                continue;
            }
            
            strCheckValue = @"N/N/N/N/N";
            
            //scanvalue 4|9 자동스캔
            if (isEmptyList &&
                ([zpstatu isEqualToString:@"0130"] ||
                 [zpstatu isEqualToString:@"0140"] ||
                 [zpstatu isEqualToString:@"0160"] ||
                 [zpstatu isEqualToString:@"0170"] ||
                 [zpstatu isEqualToString:@"0171"] ||
                 [zpstatu isEqualToString:@"0270"])
                ){
                scanValue = @"4";
            }else if (!isEmptyList){
                int index = (int)[gbicList indexOfObject:submt];
                if(index == NSNotFound){
                    index = -1;
                }
                //운용중인 광모듈만 자동스캔
                if([zpstatu isEqualToString:@"0060"]){
                    if (gbicList != nil && index != -1){
                        NSLog(@"광모듈 %@",submt);
                        scanValue = @"9";
                    }
                }
            }
            
            if (isEmptyList){
//                if(!isVirtualFlag){ //베이
                // 광모듈이면 스캔한 것 처럼 표시
                int index = (int)[gbicList indexOfObject:submt];
                if(index == NSNotFound){
                    index = -1;
                }
                //운용중인 광모듈만 자동스캔
                if([zpstatu isEqualToString:@"0060"]){
                    if (gbicList != nil && index != -1){
                        NSLog(@"광모듈 %@",submt);
                        scanValue = @"9";
                    }
                }
                
//                }
                if ([scanValue isEqualToString:@"4"] || [scanValue isEqualToString:@"9"]) //
                {
                    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
                    if ([zkostl isEqualToString:[dic objectForKey:@"orgId"]])
                        strCheckValue = [NSString stringWithFormat:@"Y/Y/Y/Y/Y"];
                    else
                        strCheckValue = [NSString stringWithFormat:@"Y/Y/N/Y/Y"];
                }
            }else if (!isEmptyList){
                if (isVirtualFlag){
                    if ([scanValue isEqualToString:@"4"] || [scanValue isEqualToString:@"9"])
                    {
                        NSDictionary* dic = [Util udObjectForKey:USER_INFO];
                        if ([zkostl isEqualToString:[dic objectForKey:@"orgId"]]){
                            btnDept.selected = YES;
                            strCheckValue = [NSString stringWithFormat:@"Y/Y/N/Y/N"];
                        }
                        else{
                            btnDept.selected = NO;
                            strCheckValue = [NSString stringWithFormat:@"Y/Y/N/Y/N"];
                        }
                        
                    }
                }
                else {
                    if ([scanValue isEqualToString:@"4"] || [scanValue isEqualToString:@"9"])
                    {
                        NSDictionary* dic = [Util udObjectForKey:USER_INFO];
                        if ([zkostl isEqualToString:[dic objectForKey:@"orgId"]]){
                            btnDept.selected = YES;
                            strCheckValue = [NSString stringWithFormat:@"Y/Y/Y/Y/Y"];
                        }
                        else{
                            btnDept.selected = NO;
                            strCheckValue = [NSString stringWithFormat:@"Y/Y/N/Y/Y"];
                        }
                        
                    }
                }
                
                if ([scanValue isEqualToString:@"5"] || [scanValue isEqualToString:@"6"])
                {
                    if (nSelectedRow < 0)
                        nSelectedRow = 0;
                    
                    int index = -1;
                    if([originalSAPList count]){
                        NSDictionary* subDic = [originalSAPList objectAtIndex:nSelectedRow];
                        index = [WorkUtil getBarcodeIndex:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList];
                    }
                    
                    if (index != -1){
                        NSDictionary* selItemDic  = [fccSAPList objectAtIndex:index];
                        NSString* selUpperBarcode = [selItemDic objectForKey:@"HEQUNR"];
                        
                        //실물일치 (기존에 없는거 추가하므로 무조건 N)
                        strCheckValue = @"N";
                        
                        //상위일치 - 창고/실 점검시 무조건 N
                        if (
                            !isVirtualFlag &&
                            [upperBarcode isEqualToString:selUpperBarcode]
                            )
                        {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/Y"];
                        }
                        else {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/N"];
                        }
                        
                        // 부서일치
                        if ([zkostl isEqualToString:strUserOrgCode]
                            )
                        {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/Y"];
                        }
                        else {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/N"];
                        }
                        
                        // 위치일치
                        // 스캔한 위치바코드와 설비의 위치바코드가 동일할 때
                        if ([locCode isEqualToString:strLocBarCode]
                            )
                        {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/Y"];
                        }
                        else {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/N"];
                        }
                        
                        // 장치일치 - 창고/실 점검시 무조건 N
                        if (
                            !isVirtualFlag &&
                            [deviceCode isEqualToString:strDeviceID]
                            )
                        {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/Y"];
                        }
                        else {
                            strCheckValue = [strCheckValue stringByAppendingString:@"/N"];
                        }
                        
                        [Util playSoundWithFileName:SOUND_JUNG fileFormat:EXT_WAVE];
                    }
                }
            }
            
            
            if (!maktx.length && [equnr hasPrefix:@"Z00"]){
                maktx = @"가상쉘프";
                partTypeName = @"S";
            }
            
            [sapDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];
            [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapDic setObject:maktx forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"ZDESC"] forKey:@"ZDESC"];
            [sapDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];//상위바코드
            [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [sapDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];//운용조직
            [sapDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];//운용조직명
            [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"]; //물품코드
            [sapDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"]; //위치코드
            [sapDic setObject:deviceCode forKey:@"ZEQUIPGC"];
            //새롭게 만들어준 키값
            if ([partTypeName length])
                [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [sapDic setObject:@"" forKey:@"PART_NAME"];
            
            [sapDic setObject:scanValue forKey:@"SCANTYPE"]; //상위 설비
            [sapDic setObject:strCheckValue forKey:@"ORG_CHECK"]; //조직 체크값
            [sapDic setObject:@"Y" forKey:@"MASTER"];
            
            [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:YES isCheckUU:NO isRemake:YES fccList:originalSAPList job:JOB_GUBUN];

            if(isHiddenList){
                [originalHiddenSAPList addObject:[resultList objectAtIndex:0]];
                if([[[resultList objectAtIndex:0] objectForKey:@"HEQUNR"] isEqualToString:@""])
                    [self reloadHiddenTableWithRefresh:[resultList objectAtIndex:0]];
            }
            
        }   // for loop
        //                                nSelectedRow = -1;
        [self reloadTableWithRefresh:YES];
        [self scrollToIndex:nSelectedRow];
        
        if (isFirst){
            isFirst = NO;
        }
        //working task add
        if (strFccBarCode.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"F" forKey:@"TASK"];
            [taskDic setObject:strFccBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        
        if(isHiddenList){
            [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
            if(isHiddenListChild){
                [self processFacCode];
            }
        }
    }
    else {
        NSString* message = @"조회된 점검 대상 설비가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if (pid == REQUEST_LOC_COD)
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
    
    if (pid == REQUEST_LOC_COD || pid == REQUEST_OTD){
        if (!isVirtualFlag) //베이일 경우
        {
            [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
            
            [self performSelectorOnMainThread:@selector(deviceBecameFirstResponder) withObject:nil waitUntilDone:NO];
        }
        strDecryptLocBarCode = @"";
    }else if (pid == REQUEST_MULTI_INFO){
        lblDeviceID.text = @"";
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
        txtDeviceCode.text = @"";
        strDecryptDeviceBarCode = @"";
    }else if (pid == REQUEST_SAP_FCC_COD){
        NSString* message = @"존재하지 않는 설비바코드입니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return;
    }
    
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
    
    isOperationFinished = YES;
}

- (void) processEndSession:(requestOfKind)pid
{ 
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
    
    isOperationFinished = YES;
}

// matsua: 주소정보조회 팝업 추가
- (IBAction) locInfoBtnAction:(id)sender{
    pwSendType = (int)[sender tag];
    NSString *wpSendParam, *wpSendParamLayer = @"";
    
    if(pwSendType == 0){
        wpSendParam = txtLocCode.text;
        wpSendParamLayer = txtLocCode.text;
    }
    else{
        wpSendParam = deviceLocCd;
        wpSendParamLayer = txtDeviceCode.text;
    }
    
    if(wpSendParamLayer.length < 1){
        return;
    }
    
    [self.view endEditing:YES];
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] init];
    modalView.delegate = self;
    
    [modalView openModal:wpSendParam];
}

#pragma popRequest delegate -- call by AddInfoViewController
- (void)popRequest:(NSString *)locAddrBd locAddrLoad:(NSString *)locAddrLoad{
    
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(!locAddrBd.length && !locAddrLoad.length){
        [self showMessage:@"위치정보가 없습니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] initWithNibName:@"AddInfoViewController" bundle:nil];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    NSString *modalViewCode, *modalViewText = @"";
    
    if(pwSendType == 0){
        modalViewCode = txtLocCode.text;
        modalViewText = lblLocName.text;
    }
    else{
        modalViewCode = deviceLocCd;
        modalViewText = deviceLocNm;
    }
    
    modalView.locCd = modalViewCode;
    modalView.locNm = modalViewText;
    modalView.locNmBd = locAddrBd;
    modalView.locNmLoad = locAddrLoad;
    
    [self presentViewController:modalView animated:NO completion:nil];
    modalView.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        modalView.view.alpha = 1;
    }];
}

-(void) hiddenDataInit{
    originalHiddenSAPList = [NSMutableArray array];
    isHiddenList = NO;
    isHiddenListChild = NO;
    nHiddenSelectedRow = 0;
    nHiddenTotalCount = 0;
}

-(void)testSetting{
    isHiddenList = YES;
    isHiddenListChild = YES;
    nHiddenTotalCount = 1500;
    nHiddenSelectedRow = 0;
}


@end


//
//  TakeOverNRegEquipViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 17..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "objc/runtime.h"
#import "TakeOverNRegEquipViewController.h"
#import "FccInfoViewController.h"
#import "CommonCell.h"
#import "WBSListViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "ERPRequestManager.h"
#import "ERPAlert.h"
#import "AddInfoViewController.h"


@interface TakeOverNRegEquipViewController ()

@end

@implementation TakeOverNRegEquipViewController

@synthesize dbWorkDic;
@synthesize workDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize isOperationFinished;
@synthesize isDataSaved;
@synthesize isOffLine;
@synthesize isSlectedWBS;
@synthesize isMultiDevice;

@synthesize JOB_GUBUN;
@synthesize longPressGesture;
@synthesize tapGesture;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize strUserId;
@synthesize strMoveBarCode;
@synthesize strFccBarCode;
@synthesize strLocBarCode;
@synthesize strCompleteLocBarCode;
@synthesize strDeviceID;
@synthesize strWBSNo;
@synthesize strDocNo;
@synthesize nSelectedRow;
@synthesize deviceCount;
@synthesize strSelectedFac;


@synthesize fccMoveList;
@synthesize locResultList;
@synthesize wbsResultList;
@synthesize fccResultList;
@synthesize rescanList;
@synthesize listDeviceId;
@synthesize subFacList;
@synthesize fullTableList;
@synthesize tableList;
@synthesize validateYNList;


@synthesize isOrgChanged;
@synthesize isFirst;
@synthesize isRescan;
@synthesize isWorkStep;
@synthesize sendCount;
@synthesize isModifyMode;
@synthesize isMoveMode;
@synthesize isChange;
@synthesize isSuccDeviceScan;

@synthesize indicatorView;


@synthesize lblCount;
@synthesize lblCount2;

@synthesize _scrollView;
@synthesize orgView;
@synthesize lblOperationInfo;
@synthesize locBarcodeView;
@synthesize txtLocCode;
@synthesize locNameView;
@synthesize scrollLocName;
@synthesize lblLocName;
@synthesize fccBarcodeView;
@synthesize lblPartType;
@synthesize txtFacCode;
@synthesize uuView;
@synthesize btnUU;
@synthesize btnDetailFccInfo;
@synthesize deviceIDView;
@synthesize lblDeviceIdTitle;
@synthesize txtDeviceID;
@synthesize lblDeviceID;
@synthesize deviceINfoView;
@synthesize scrollDeviceInfo;
@synthesize lblDeviceInfo;
@synthesize wbsView;
@synthesize lblWBSNo;
@synthesize btnChangeWBS;
@synthesize _tableView;
@synthesize btnReScanReq;
@synthesize btnMove;
@synthesize btnModify;
@synthesize btnDel;
@synthesize btnRegDecision;
@synthesize btnClear;
@synthesize btnSave;
@synthesize btnSend;
@synthesize messageView;
@synthesize buttonView;
@synthesize lblMessage;

@synthesize deviceLocCd;
@synthesize deviceLocNm;
@synthesize pwSendType;

static const char* key1000 = "key1000";
static const char* keynew800 = "keynew800";
static const char* keyold800 = "keyold800";
static const char* keyObj1300 = "keyObj1300";
static const char* keyTar1300 = "keyTar1300";
static BOOL diagStat = NO; //alertView에서 <예> 인 경우에 실행해야 할 메소드의 결과를 리턴해주기 위해서

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    // text field에서 키입력을 받지 않도록 하기 위해서(scaner를 기본 입력으로 잡을 경우)
    [self makeDummyInputViewForTextField];
    
    isFirst = YES;
    messageView.hidden = YES;
    self.isSendFlag = NO;
    isWorkStep = NO;
    isRescan = NO;
    isModifyMode = NO;
    isMoveMode = NO;
    isChange = NO;
    strDocNo = @"";
    
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];
    
    // 초기화면 설정
    [self layoutSubView];
    
    //작업관리 초기화
    [self workDataInit];
    
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    strUserId = [dic objectForKey:@"userId"];
    
    lblOperationInfo.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    //long press gesture add
    longPressGesture =[[UILongPressGestureRecognizer alloc]
                       initWithTarget:self
                       action:@selector(handleLongPress:)];
    longPressGesture.cancelsTouchesInView = NO;
    longPressGesture.minimumPressDuration = 1.0f;//seconds
    longPressGesture.delegate = self;
    [self._tableView addGestureRecognizer:longPressGesture];
    
    //single tap gesture add
    tapGesture =[[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(handleSingleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self._tableView addGestureRecognizer:tapGesture];
    
    // view들의 초기값을 설정한다.
    [self initViews];
    
    [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
    {
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
    
    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    UITouch* touch =[[event allTouches] anyObject];
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

- (void) dealloc
{
    [self.view removeGestureRecognizer:longPressGesture];
    [self.view removeGestureRecognizer:tapGesture];
}

#pragma work management method
- (void) workDataInit
{
    isDataSaved = NO;
    //작업관리 초기화
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
}

// 바코드 삭제하기 위해서 사용한다.
- (void) deleteBarcode:(NSString*)barcode
{
    int index = [WorkUtil getBarcodeIndex:barcode fccList:fullTableList];
    if (index != -1){
        
        [WorkUtil deleteBarcodeIndex:index fccList:fullTableList];
        
        [self reloadTableWithRefresh:NO];
        if (fullTableList.count)
            nSelectedRow = tableList.count - 1;
        else
            nSelectedRow = 0;
        
        [_tableView reloadData];
        
        isChange = YES;
        
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"DELETE" forKey:@"TASK"];
        [taskDic setObject:barcode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    
    isOperationFinished = YES;
}

- (void)moveSource:(NSString*)source toTarget:(NSString*)target
{
    [WorkUtil moveSource:source toTarget:target fccList:fullTableList];
    
    [self reloadTableWithRefresh:NO];
    nSelectedRow = [WorkUtil getBarcodeIndex:source fccList:fullTableList];
    [_tableView reloadData];
    [self showCount];
    isChange = YES;
    
    //작업관리 추가
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"MOVE" forKey:@"TASK"];
    [taskDic setObject:source forKey:@"SOURCE"];
    [taskDic setObject:target forKey:@"TARGET"];
    [taskList addObject:taskDic];
    
    isOperationFinished = YES;
}

#pragma mark - DB Method
- (void)processWorkData
{
    if (dbWorkDic.count){
        //스캔필수추가
        NSData* taskData = [dbWorkDic objectForKey:@"TASK"];
        if (taskData.bytes > 0){
            fetchTaskList = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
        }
        
        if (fetchTaskList.count)
            [self waitForGCD];
    }
}

- (BOOL)saveToWorkDB
{
    BOOL isNew = NO;
    NSString* workId = @"";
    
    if (![dbWorkDic count])
        isNew = YES;
    else
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

#pragma mark - GCD
-(void) waitForGCD
{
    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        
        isOperationFinished = NO;
        if ([task isEqualToString:@"L"]) //위치
        {
            [self initWhenLocBarcode];
            txtLocCode.text = strLocBarCode =value;
            
            if ([[dic objectForKey:@"WBS"] isEqualToString:@"Y"])
                isSlectedWBS = YES;
            else
                isSlectedWBS = NO;
            
            if (isOffLine)
                [self setOfflineLocCd:value];
            else
                [self requestLocCode:value];
        }
        else if ([task isEqualToString:@"WBS"]){    // WBS설정
            lblWBSNo.text = value;
            strWBSNo = value;
            
            // WBS 설정하는 부분에서 저장을 하는데, 작업관리로 실행 할 떄는 WBS설정부분의 코드를 실행 하지 않으므로 여기서 작업 저장 해준다.
            [workDic setObject:value forKey:@"WBS"];
            
            //WBS를 TASK로 저장한다.
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"WBS" forKey:@"TASK"];
            [taskDic setObject:value forKey:@"VALUE"];
            [taskList addObject:taskDic];
            
            [self search];
            
            if (txtDeviceID.enabled && [txtDeviceID.text isEqualToString:@""] && ![txtDeviceID isFirstResponder])
                [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
            else
                [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
        }
        else if ([task isEqualToString:@"D"]) //장치아이디
        {
            txtDeviceID.text = strDeviceID = value;
            if (isOffLine)
                [self setOfflineDeviceCd:value];
            else
                [self requestDeviceCode:value];
        }
        else if ([task isEqualToString:@"UU_YN"]){  // UU버튼 클릭
            if ([value isEqualToString:@"Y"])
                btnUU.selected = YES;
            else
                btnUU.selected = NO;
            isOperationFinished = YES;
            
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"UU_YN" forKey:@"TASK"];
            [taskDic setObject:(btnUU.selected)? @"Y":@"N" forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            strFccBarCode = value;
            
            txtFacCode.text = value;
            
            [self processCheckScan:strFccBarCode];
        }
        else if ([task isEqualToString:@"DELETE"]) //셀 삭제
        {
            [self deleteBarcode:value];
        }
        else if ([task isEqualToString:@"MODIFY"])  // 수정
        {
            nSelectedRow = [value integerValue];
            isModifyMode = YES;
            isChange = YES;
            
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"MODIFY_CANCEL"])
        {
            isModifyMode = NO;
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"MOVE"]) //이동
        {
            NSString* source = [dic objectForKey:@"SOURCE"];
            NSString* target = [dic objectForKey:@"TARGET"];
            
            [self moveSource:source toTarget:target];
        }
        else
            isOperationFinished = YES;
        
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
    }
    
    [self layoutControl];
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    isDataSaved = YES;
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

#pragma mark - User Define Method
- (void) showCount
{
    int DeviceCount = 0;
    int shelfCount = 0;
    int rackCount = 0;
    int unitCount = 0;
    int equipCount = 0;
    int totalCount = 0;
    NSString* formatString = nil;
    
    
    if (fullTableList.count){
        for(NSDictionary* dic in fullTableList)
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
            else if ([partName isEqualToString:@"D"])
                DeviceCount++;
        }
    }
    NSString* strTitle = @"";
    if ([JOB_GUBUN isEqualToString:@"인수"])
        strTitle = @"[인계]";
    totalCount =  rackCount + shelfCount + unitCount + equipCount + DeviceCount;
    formatString = [NSString stringWithFormat:@"%@ D(%d) R(%d) S(%d) U(%d) E(%d) TOTAL:%d건", strTitle, DeviceCount, rackCount,shelfCount,unitCount,equipCount,totalCount];
    lblCount.text = formatString;
    
    if ([JOB_GUBUN isEqualToString:@"인수"]){
        int DeviceCount2 = 0;
        int shelfCount2 = 0;
        int rackCount2 = 0;
        int unitCount2 = 0;
        int equipCount2 = 0;
        int totalCount2 = 0;
        NSString* formatString2 = nil;
        
        if (fullTableList.count){
            for(NSDictionary* dic in fullTableList)
            {
                NSString* scanType = [dic objectForKey:@"SCANTYPE"];
                NSString* partName = [dic objectForKey:@"PART_NAME"];
                if ([scanType isEqualToString:@""] || ![scanType isEqualToString:@"0"]){
                    if ([partName isEqualToString:@"R"])
                        rackCount2++;
                    else if ([partName isEqualToString:@"S"])
                        shelfCount2++;
                    else if ([partName isEqualToString:@"U"])
                        unitCount2++;
                    else if ([partName isEqualToString:@"E"])
                        equipCount2++;
                    else if ([partName isEqualToString:@"D"])
                        DeviceCount2++;
                }
            }
            
        }
        totalCount2 =  rackCount2 + shelfCount2 + unitCount2 + equipCount2 + DeviceCount2;
        formatString2 = [NSString stringWithFormat:@"[인수] D(%d) R(%d) S(%d) U(%d) E(%d) TOTAL:%d건", DeviceCount2, rackCount2,shelfCount2,unitCount2,equipCount2,totalCount2];
        lblCount2.text = formatString2;
    }
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
                    if (index == tableList.count - 1)
                        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
                    else
                        yOffset =  _tableView.bounds.size.height + lastcell.bounds.size.height * (index - lastPath.row);
                }
            }
        }
        [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //위치바코드
        if ([barcode length]){
            [self initWhenLocBarcode];
            strLocBarCode = barcode;
            
//            if(barcode.length != 11 && barcode.length != 14 && barcode.length != 17 && barcode.length != 21){
//                NSString* message = @"처리할 수 없는 위치바코드입니다.";
//                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//                
//                txtLocCode.text = strLocBarCode = @"";
//                [txtLocCode becomeFirstResponder];
//                
//                return YES;
//            }
//            
//            if (
//                [JOB_GUBUN isEqualToString:@"인계"] ||
//                [JOB_GUBUN isEqualToString:@"인수"] ||
//                [JOB_GUBUN isEqualToString:@"시설등록"] ){
//                if ([barcode hasPrefix:@"VS"]){
//                    NSString* message = @"가상창고 위치바코드는\n 스캔하실 수 없습니다.";
//                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
//                    
//                    strLocBarCode = barcode;
//                    [txtLocCode becomeFirstResponder];
//                    
//                    return NO;
//                }
//            }
//            NSString* strDecryptLocBarCode = barcode;
//            
//            if ([barcode isEqualToString:strDecryptLocBarCode])
//                strLocBarCode = strDecryptLocBarCode;
//            else{
//                if ([barcode hasPrefix:@"+"]){
//                    strLocBarCode = strDecryptLocBarCode;
//                    barcode = strDecryptLocBarCode;
//                }
//                else
//                    strLocBarCode = barcode;
//            }
            
            NSString* message = [Util barcodeMatchVal:1 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                txtLocCode.text = strLocBarCode = @"";
                [txtLocCode becomeFirstResponder];
                return YES;
            }
            
            if (!isOffLine)
                [self requestLocCode:strLocBarCode];
            else{
                [self setOfflineLocCd:strLocBarCode];
            }
        }
        else {
            [self showMessage:@"위치바코드를 스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return NO;
        }
    }
    else if (tag == 200){ //200 설비 바코드
        if(![JOB_GUBUN isEqualToString:@"시설등록"] && lblLocName.text.length == 0){
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            [txtLocCode becomeFirstResponder];
            txtDeviceID.text = strDeviceID = @"";
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
            
        }
        
        if (![JOB_GUBUN isEqualToString:@"시설등록"] && [lblWBSNo.text length] <= 0){
            NSString* message = @"WBS 번호를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            [txtLocCode becomeFirstResponder];
            txtDeviceID.text = strDeviceID = @"";
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
        }
        
        if (!lblLocName.text.length){
            [self showMessage:@"위치바코드를 스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            [txtLocCode becomeFirstResponder];
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
        }
        if (fullTableList.count < 2){
            NSString* message = @"장치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            [txtDeviceID becomeFirstResponder];
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
        }
        if (([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"시설등록"])
            && (fullTableList.count - 2) >= 900){
            NSString* message = @"처리할 수 있는 설비 개수를\n 넘었습니다.\n 공사담당자께 문의하시기\n 바랍니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
            
        }
        if (self.nSelectedRow == 0){
            NSString* message = @"위치바코드의 하위에 설비를\n 추가할 수 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            txtFacCode.text = strFccBarCode = @"";
            lblPartType.text = @"";
            return NO;
        }
        //////////////////////
        if (barcode.length){
            strFccBarCode = barcode;
//            NSString* strDecryptFccBarCode = barcode;
//            NSLog(@"strDecryptFccBarCode: [%@]",strDecryptFccBarCode);
//            
//            if ([barcode isEqualToString:strDecryptFccBarCode])
//                strFccBarCode = strDecryptFccBarCode;
//            else{
//                if ([barcode hasPrefix:@"+"]){
//                    strFccBarCode = strDecryptFccBarCode;
//                    barcode = strDecryptFccBarCode;
//                }
//                else
//                    strFccBarCode = barcode;
//            }
//            
//            if (strFccBarCode.length < 16 || strFccBarCode.length > 18)
//            {
//                NSString* message = @"처리할 수 없는 설비바코드입니다.";
//                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//                txtFacCode.text = strFccBarCode = lblPartType.text = @"";
//                return NO;
//            }
            
            NSString* message = [Util barcodeMatchVal:2 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                txtFacCode.text = strFccBarCode = lblPartType.text = @"";
                [txtFacCode becomeFirstResponder];
                return YES;
            }
            
            if (strFccBarCode.length)
                [self processCheckScan:strFccBarCode];
        }
    }
    else if (tag == 300){ //300 장치 바코드
        strDeviceID = barcode;
        
        if(![JOB_GUBUN isEqualToString:@"시설등록"] && lblLocName.text.length == 0){
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            [txtLocCode becomeFirstResponder];
            txtDeviceID.text = strDeviceID = @"";
            return NO;
            
        }
        
        if (!isOffLine && [JOB_GUBUN isEqualToString:@"인수"]) return NO;
        
        if (!isOffLine && ![JOB_GUBUN isEqualToString:@"시설등록"] && [lblWBSNo.text length] <= 0){
            NSString* message = @"WBS 번호를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtDeviceID.text = strDeviceID = @"";
            [txtLocCode becomeFirstResponder];
            
            return NO;
        }
        
        if (!lblLocName.text.length || ![fullTableList count]){
            [self showMessage:@"위치바코드를 스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
            [txtLocCode becomeFirstResponder];
            strDeviceID = txtDeviceID.text = @"";
            
            return NO;
        }
        
        if([txtDeviceID.text isEqualToString:@""]){
            NSString* message = @"장치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            [txtDeviceID becomeFirstResponder];
            
            return NO;
            
        }
        
//        if (txtDeviceID.text.length != 9)
//        {
//            NSString* message = @"처리할 수 없는 장치바코드입니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            [txtDeviceID becomeFirstResponder];
//            return YES;
//        }
        
        NSString* message = [Util barcodeMatchVal:3 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            txtDeviceID.text = strDeviceID = @"";
            [txtDeviceID becomeFirstResponder];
            return YES;
        }
        
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
        
        if (!isOffLine)
            [self requestDeviceCode:strDeviceID];
        else{
            [self setOfflineDeviceCd:strDeviceID];
        }
    }
    
    return YES;
}

////////////////////////////////////////////
// 음영지역 작업
- (void)setOfflineLocCd:(NSString*)barcode
{
    [Util setScrollTouch:scrollLocName Label:lblLocName withString:MESSAGE_OFFLINE];
    if (!wbsView.hidden)    lblWBSNo.text = lblLocName.text;
    strCompleteLocBarCode = barcode;
    
    // 작업관리 추가
    [workDic setObject:txtLocCode.text forKey:@"LOC_CD"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"L" forKey:@"TASK"];
    [taskDic setObject:barcode forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    [self afterSearch];
    
    isOperationFinished = YES;
}

- (void)setOfflineDeviceCd:(NSString*)barcode
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:strDeviceID forKey:@"deviceId"];
    [dic setObject:@"" forKey:@"deviceStatusName"];
    [dic setObject:@"" forKey:@"locationCode"];
    [dic setObject:@"음영지역작업" forKey:@"deviceName"];
    [dic setObject:@"" forKey:@"itemCode"];
    [dic setObject:@"" forKey:@"itemName"];
    
    //물품명
    [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:[NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"itemCode"],[dic objectForKey:@"itemName"]]];
    
    // tableList에 추가할 제목필드 만들기
    NSString* title = [NSString stringWithFormat:@"D:%@:%@:%@:%@:R:%@:%@", [dic objectForKey:@"deviceId"], [dic objectForKey:@"deviceName"], [dic objectForKey:@"itemCode"], [dic objectForKey:@"itemName"], [dic objectForKey:@"locationCode"], [dic objectForKey:@"deviceStatusName"]];
    isSuccDeviceScan = NO;
    [self addDeviceToTableTitle:title Info:dic Parent:strCompleteLocBarCode];
    if (isSuccDeviceScan){
        if (barcode.length){
            txtDeviceID.text = barcode;
            strDeviceID = txtDeviceID.text;
        }
        
        strDeviceID = [dic objectForKey:@"deviceId"];
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    }else{
        [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
    }
    
    // 작업관리
    [workDic setObject:txtDeviceID.text forKey:@"DEVICE_ID"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"D" forKey:@"TASK"];
    [taskDic setObject:txtDeviceID.text forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    [self scrollToIndex:nSelectedRow];
    self.isSendFlag = NO;
    isOperationFinished = YES;
    
}

- (void)setOfflineFacCd:(NSString*)barcode
{
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSString* errorMessage = @"";
    NSArray* goodsList = [WorkUtil getBarcodeInfoInPDA:barcode errorMessage:errorMessage];
    
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (goodsList == nil ){
        if(errorMessage.length){
            [self showMessage:errorMessage tag:-1 title1:@"닫기" title2:@"" isError:YES];
            isOperationFinished = YES;
            
            return;
        }
    }
    
    if(goodsList == nil || (goodsList != nil && goodsList.count <= 0)){
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isOperationFinished = YES;
        return;
    }
    
    if ([goodsList count]){
        for(NSDictionary* dic in goodsList){
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* compType;
            if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
                compType = @"";
            else
                compType = [dic objectForKey:@"COMPTYPE"];
            NSString* barcodeName = [dic objectForKey:@"MAKTX"];
            if (barcodeName== nil)
                barcodeName = @"";
            else
                barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
            NSString* thisBarcode = strFccBarCode;
            NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
            NSString* statusName = [WorkUtil getFacilityStatusName:@""];
            NSString* ZKOSTL = @"";
            NSString* ZKTEXT = @"";
            NSString* deviceTypeName =  [WorkUtil getDeviceTypeName:[sapDic objectForKey:@"ZMATGB"]]; //디바이스코드(ZPGUBUN)
            NSString* deviceID = @"";//[sapDic objectForKey:@"ZEQUIPGC"];
            NSString* checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@", ZKOSTL, ZKTEXT];
            NSString* scanType;
            
            if (isModifyMode)   // 수정을 위해 스캔한 경우
                scanType = @"1";
            else                // 무조건 추가
                scanType = @"2";
            NSString* wbsNo = @"";
            
            NSString* title = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@::", partTypeName, thisBarcode, statusName, barcodeName, deviceTypeName, deviceID, scanType, checkOrgValue, wbsNo];
            
            self.isSendFlag = YES;
            
            if (![self checkFacInfo:sapDic]){
                isOperationFinished = YES;
                return;
            }
            
            NSMutableDictionary* sapInfoDic = [NSMutableDictionary dictionary];
            [sapInfoDic setObject:deviceID forKey:@"DEVICEID"];
            [sapInfoDic setObject:wbsNo forKey:@"POSID"];
            [sapInfoDic setObject:@"" forKey:@"SHELFID"];
            [sapInfoDic setObject:thisBarcode forKey:@"UNITID"];
            [sapInfoDic setObject:barcodeName forKey:@"EQKTX"];
            [sapInfoDic setObject:partTypeName forKey:@"PART_NAME"];
            [sapInfoDic setObject:@"" forKey:@"HEQUNR"];
            [sapInfoDic setObject:@"" forKey:@"ZPSTATU"];
            [sapInfoDic setObject:scanType forKey:@"SCANTYPE"];
            [sapInfoDic setObject:@"" forKey:@"CHECKORGVALUE"];
            [sapInfoDic setObject:[dic objectForKey:@"COMPTYPE"] forKey:@"PARTTYPE"];
            [sapInfoDic setObject:statusName forKey:@"deviceStatusName"];
            [sapInfoDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"DEVTYPE"];
            [sapInfoDic setObject:@"" forKey:@"LOCCODE"];
            
            if (!isModifyMode){
                //working task add
                NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
                [taskDic setObject:@"F" forKey:@"TASK"];
                [taskDic setObject:strFccBarCode forKey:@"VALUE"];
                [taskList addObject:taskDic];
            }
            
            self.isSendFlag = YES;
            [self addFacToTableWithTitle:title Info:sapInfoDic isRemake:YES];
            lblPartType.text = partTypeName;
            isChange = YES;
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
        }
    }
    
    [self scrollToIndex:nSelectedRow];
    isOperationFinished = YES;
}
////////////////////////////////////////////

- (void)makeDummyInputViewForTextField
{
    // QA가 아닌 경우에는 키입력을 받지 않는다.
    // QA인 경우 환경설정에서 소프트키를 활성화한 경우에는 키 입력을 받는다.
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtLocCode.inputView = dummyView;
        txtDeviceID.inputView = dummyView;
        txtFacCode.inputView = dummyView;
    }
}

- (void) layoutSubView
{
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    CGRect lblCountRect;
    if ([JOB_GUBUN isEqualToString:@"인수"]){
        lblCountRect = CGRectMake(0, PHONE_SCREEN_HEIGHT - 44 - 40, 320, 20);
    }else
        lblCountRect = CGRectMake(0, PHONE_SCREEN_HEIGHT - 44 - 20, 320, 20);
    
    lblCount = [[UILabel alloc] initWithFrame:lblCountRect];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];
    
    if ([JOB_GUBUN isEqualToString:@"인수"]){
        lblCount2 = [[UILabel alloc] initWithFrame:CGRectMake(0,  PHONE_SCREEN_HEIGHT - 44 - 20, 320, 20)];
        lblCount2.backgroundColor = [UIColor clearColor];
        lblCount2.textColor = [UIColor blueColor];
        lblCount2.font = [UIFont systemFontOfSize:14];
        lblCount2.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:lblCount2];
        
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - 20);
    }
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        btnReScanReq.hidden = YES;
        btnRegDecision.hidden = YES;
        CGRect rect = btnClear.frame;
        rect.origin.x += 40;
        btnClear.frame = rect;
        rect = btnMove.frame;
        rect.origin.x += 40;
        btnMove.frame = rect;
        rect = btnModify.frame;
        rect.origin.x += 40;
        btnModify.frame = rect;
        rect = btnDel.frame;
        rect.origin.x += 40;
        btnDel.frame = rect;
        rect = btnSave.frame;
        rect.origin.x += 40;
        btnSave.frame = rect;
        rect = btnSend.frame;
        rect.origin.x += 40;
        btnSend.frame = rect;
    }else if ([JOB_GUBUN isEqualToString:@"인수"]){
        lblDeviceIdTitle.textColor = [UIColor lightGrayColor];
        txtDeviceID.enabled = NO;
        uuView.hidden = YES;
        CGRect rect = btnClear.frame;
        rect.origin.x = 90;
        btnClear.frame = rect;
        btnReScanReq.hidden = NO;
        btnRegDecision.hidden = NO;
        [btnRegDecision setImage:[UIImage imageNamed:@"button_insu"] forState:UIControlStateNormal];
        [btnRegDecision setImage:[UIImage imageNamed:@"button_insu_up"] forState:UIControlStateHighlighted];
        btnRegDecision.enabled = NO;
        btnMove.hidden = YES;
        btnModify.hidden = YES;
        btnDel.hidden = YES;
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        btnRegDecision.hidden = NO;
        [btnRegDecision setImage:[UIImage imageNamed:@"button_confirm"] forState:UIControlStateNormal];
        [btnRegDecision setImage:[UIImage imageNamed:@"button_confirm_up"] forState:UIControlStateHighlighted];
        btnRegDecision.enabled = NO;
        btnReScanReq.hidden = YES;
        btnMove.hidden = NO;
        btnModify.hidden = NO;
        btnDel.hidden = NO;
        wbsView.hidden = YES;
        deviceIDView.frame = CGRectMake(deviceIDView.frame.origin.x, 86, deviceIDView.frame.size.width, deviceIDView.frame.size.height);
        deviceINfoView.frame = CGRectMake(deviceINfoView.frame.origin.x, 121, deviceINfoView.frame.size.width, deviceINfoView.frame.size.height);
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 145, fccBarcodeView.frame.size.width, fccBarcodeView.frame.size.height);
        buttonView.frame = CGRectMake(0, 181, 320, 37);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, 220, _tableView.frame.size.width, _tableView.frame.size.height + 20);
    }
}

- (void)search
{
    isWorkStep = NO;
    isRescan = NO;
    strDocNo = @"";
    
    if ([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"]){
        // rescan 여부 조회
        [self requestRescanYN:strCompleteLocBarCode WBSNo:strWBSNo];
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        [self requestSearch];
    }
}

- (void)afterSearch
{
    if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        btnSend.enabled = NO;
        btnReScanReq.enabled = NO;
        btnMove.enabled = NO;
        btnModify.enabled = NO;
        btnDel.enabled = NO;
        btnChangeWBS.enabled = NO;
        if (fullTableList.count)
            btnRegDecision.enabled = YES;
        else
            btnRegDecision.enabled = NO;
    }
    
    if (fullTableList.count == 0 && (isOffLine || ![JOB_GUBUN isEqualToString:@"인수"])){
        fullTableList = [NSMutableArray array];
        tableList = [NSMutableArray array];
        [_tableView reloadData];
        [self showCount];
        
        [self addLocToTableWithLocBarcode:strCompleteLocBarCode];
        
        if (![txtDeviceID.text isEqualToString:@""]){
            [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
            
            [self requestDeviceCode:strDeviceID];
        }
    }
    btnClear.enabled = YES;
    btnMove.enabled = YES;
    btnModify.enabled = YES;
    btnDel.enabled = YES;
    btnSend.enabled = YES;
    if (btnUU.selected)
        btnUU.selected = NO;
    
    if (([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"시설등록"]) && isWorkStep){
        NSString* message = @"인수확인이 진행중 입니다. 변경이 불가능 합니다. 변경이 필요한 경우 인수담당자가 재스캔 요청이 있는 경우만 가능 합니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        btnClear.enabled = NO;
        btnMove.enabled = NO;
        btnModify.enabled = NO;
        btnDel.enabled = NO;
        btnSend.enabled = NO;
    }
    
    if (txtDeviceID.enabled && [txtDeviceID.text isEqualToString:@""] && ![txtDeviceID isFirstResponder])
        [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
    else
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

- (void) layoutControl
{
    if (txtLocCode.text.length && ![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
    else if (txtDeviceID.enabled && txtDeviceID.text.length && ![txtDeviceID isFirstResponder])
        [txtDeviceID becomeFirstResponder];
    else if (![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

- (void)setLocFirstResponder
{
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}

- (void)setDeviceFirstResponder
{
    if (txtDeviceID.enabled && ![txtDeviceID isFirstResponder])
        [txtDeviceID becomeFirstResponder];
}

- (void)setFacFirstResponder
{
    if (![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

- (void)setWorkStepFlage:(NSArray*)list
{
    NSDictionary* tmpDic = [list objectAtIndex:0];
    strDocNo = [tmpDic objectForKey:@"DOCNO"];
    for (NSDictionary* dic in list){
        NSString* rescan_req = [dic objectForKey:@"RESCAN_REQ"];
        NSString* workstep = [dic objectForKey:@"WORKSTEP"];
        
        if (rescan_req != nil && ![rescan_req isEqualToString:@""])
            isRescan = YES;
        if (workstep != nil &&
            ([workstep isEqualToString:@"02"] || [workstep isEqualToString:@"03"]))
            isWorkStep = YES;
    }
}

- (BOOL)checkFacInfo:(NSDictionary*)facInfo
{
    NSDictionary* parentDic = [WorkUtil getParent:facInfo fccList:fullTableList];
    
    if ([fullTableList count] > 900){
        NSString* message = @"처리할 수 있는 설비 개수를\n 넘었습니다.\n 공사담당자께 문의하시기\n 바랍니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        return NO;
    }
    
    if (parentDic != nil && [[parentDic objectForKey:@"PART_NAME"] isEqualToString:@"L"]){
        NSString* message = @"위치바코드의 하위에 설비를\n 추가할 수 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return NO;
    }
    
    NSString* devType = [facInfo objectForKey:@"ZPGUBUN"];
    NSString* partType = [facInfo objectForKey:@"ZPPART"];
    NSString* partTypeName = [WorkUtil getPartTypeName:partType device:devType];
    
    if (parentDic != nil && [[parentDic objectForKey:@"PART_NAME"] isEqualToString:@"D"] &&
        [partTypeName isEqualToString:@"U"]){
        NSString* message = @"장치바코드 하위에\nUnit 설비바코드를\n스캔하실 수\n없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return NO;
    }
    
    return YES;
}

- (void) replaceTitleNScanType:(NSInteger)scanType SelectedRow:(NSInteger)row Info:(NSDictionary*)dic
{
    NSString* title = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%d:%@:%@",
                       [dic objectForKey:@"PART_NAME"], [dic objectForKey:@"EQUNR"],
                       [dic objectForKey:@"deviceStatusName"], [dic objectForKey:@"barcodeName"],
                       [WorkUtil getDeviceTypeName:[dic objectForKey:@"devType"]],
                       [dic objectForKey:@"deviceId"], (int)scanType,
                       [dic objectForKey:@"checkOrgValue"],[dic objectForKey:@"posId"]];
    [dic setValue:[NSString stringWithFormat:@"%d", (int)scanType] forKey:@"SCANTYPE"];
    [dic setValue:title forKey:@"title"];
    NSInteger index = [fullTableList indexOfObject:[WorkUtil getItemFromFccList:[dic objectForKey:@"EQUNR"] fccList:fullTableList]];
    [fullTableList replaceObjectAtIndex:index withObject:dic];
    [self reloadTableWithRefresh:YES];
    [self scrollToIndex:nSelectedRow];
    
    self.isSendFlag = YES;
}

- (BOOL) processCheckScan:(NSString*)barcode
{
    if ([JOB_GUBUN isEqualToString:@"인수"]){
        NSString* scanType = @"";
        
        // 이미 존재하는 바코드 일 경우 해당 바코드 스캔처리
        int index = [self containBarcode:strFccBarCode inFccList:fullTableList];
        if (index != -1){
            NSDictionary* duplicateDic = [fullTableList objectAtIndex:index];
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
            
            NSDictionary* dic = [tableList objectAtIndex:index];
            NSDictionary* parentDic = [WorkUtil getParent:dic fccList:fullTableList];
            scanType = [dic objectForKey:@"SCANTYPE"];
            if (![scanType isEqualToString:@"1"]){
                if(parentDic != nil &&
                   (![[parentDic objectForKey:@"deviceType"] isEqualToString:@"D"] && [[parentDic objectForKey:@"SCANTYPE"] isEqualToString:@"0"])) {
                    if ([JOB_GUBUN isEqualToString:@"인수"]){
                        NSString* message = @"스캔하신 형상이 인계스캔과\n 상이합니다.";
                        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                        
                        scanType = @"4";
                    }
                }
            }
            if(![scanType isEqualToString:@"0"]){
                NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",barcode];
                if (![[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            }
            if ([scanType isEqualToString:@"0"])
                [self replaceTitleNScanType:1 SelectedRow:index Info:dic];
            else if ([scanType isEqualToString:@"4"])
                [self replaceTitleNScanType:4 SelectedRow:index Info:dic];
            
            // 작업관리
            if (!isModifyMode){
                //working task add
                NSMutableDictionary* taskDic2 = [NSMutableDictionary dictionary];
                [taskDic2 setObject:@"F" forKey:@"TASK"];
                [taskDic2 setObject:strFccBarCode forKey:@"VALUE"];
                [taskList addObject:taskDic2];
            }
            isChange = YES;
            isOperationFinished = YES;
        }else{
            NSString* message = [NSString stringWithFormat:@"'%@' 대상인 설비바코드가\n존재하지 않습니다.", JOB_GUBUN];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return NO;
        }
        
        return YES;
    }
    
    // 인계, 시설등록인 경우
    if (tableList.count > 2){
        int index = [self containBarcode:strFccBarCode inFccList:fullTableList];
        
        if (index != -1){
            NSDictionary* duplicateDic = [fullTableList objectAtIndex:index];
            NSString* sapbarcode;
            if (strFccBarCode.length){
                sapbarcode = [duplicateDic objectForKey:@"EQUNR"];
                if (![strFccBarCode isEqualToString:sapbarcode]){
                    if ([sapbarcode rangeOfString:strFccBarCode].location != NSNotFound){
                        strFccBarCode = sapbarcode;
                        txtFacCode.text = strFccBarCode;
                        barcode = sapbarcode;
                    }
                }
            }
            
            [self tableView:_tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
            nSelectedRow = index;
            [self scrollToIndex:index];
            [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
            
            NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",barcode];
            if (![[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            isOperationFinished = YES;
            
            return NO;
        }
        else if (!isOffLine) //테이블에 바코드 존재하지 않음 행 추가
            [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
    }
    else if (!isOffLine)
        [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
    
    if (isOffLine){
        [self setOfflineFacCd:strFccBarCode];
    }
    
    return YES;
}

- (void)addLocToTableWithLocBarcode:(NSString*)locBarcode
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:strCompleteLocBarCode forKey:@"locCode"];
    [dic setObject:@"" forKey:@"deviceId"];
    [dic setObject:@"" forKey:@"barcodeName"];
    [dic setObject:@"" forKey:@"posId"];
    [dic setObject:strCompleteLocBarCode forKey:@"EQUNR"];
    [dic setObject:@"" forKey:@"shelf"];
    [dic setObject:@"" forKey:@"partType"];
    [dic setObject:@"L" forKey:@"PART_NAME"];
    [dic setObject:@"" forKey:@"devType"];
    [dic setObject:@"" forKey:@"itemCode"];
    [dic setObject:@"" forKey:@"itemName"];
    [dic setObject:@"" forKey:@"SCANTYPE"];
    [dic setObject:@"" forKey:@"deviceStatusName"];
    [dic setObject:@"" forKey:@"checkOrgValue"];
    [dic setObject:[NSString stringWithFormat:@"L:%@", locBarcode] forKey:@"title"];
    
    NSString* errMsg = @"";
    errMsg = [WorkUtil makeHierarchyOfAddedData:dic selRow:&nSelectedRow isMakeHierachy:YES isCheckUU:btnUU.selected isRemake:YES fccList:fullTableList job:JOB_GUBUN];
    
    [self reloadTableWithRefresh:YES];
    [self scrollToIndex:nSelectedRow];
}

- (void)addDeviceToTableTitle:(NSString*)title Info:(NSDictionary*)infoDic Parent:(NSString*)parent
{
    NSString* deviceId = [infoDic objectForKey:@"deviceId"];
    NSInteger index = [self isExistInListOfBarcode:deviceId];
    if (index >= 0){
        [self tableView:_tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
        nSelectedRow = index;
        [self scrollToIndex:index];
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
        
        NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",deviceId];
        if (![[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        return;
    }
    
    NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
    
    [newDic setObject:@"D" forKey:@"PART_NAME"];
    [newDic setObject:@"" forKey:@"partType"];
    [newDic setObject:deviceId forKey:@"EQUNR"];
    [newDic setObject:[infoDic objectForKey:@"deviceStatusName"] forKey:@"deviceStatusName"];
    [newDic setObject:@"" forKey:@"devType"];
    [newDic setObject:[infoDic objectForKey:@"locationCode"] forKey:@"locCode"];
    [newDic setObject:deviceId forKey:@"deviceId"];
    [newDic setObject:[infoDic objectForKey:@"deviceName"] forKey:@"barcodeName"];
    [newDic setObject:@"" forKey:@"posId"];
    [newDic setObject:@"" forKey:@"shelf"];
    [newDic setObject:[infoDic objectForKey:@"itemCode"] forKey:@"itemCode"];
    [newDic setObject:[infoDic objectForKey:@"itemName"] forKey:@"itemName"];
    [newDic setObject:parent forKey:@"HEQUNR"];
    [newDic setObject:@"" forKey:@"SCANTYPE"];
    [newDic setObject:@"" forKey:@"checkOrgValue"];
    [newDic setObject:title forKey:@"title"];
    
    isSuccDeviceScan = YES;
    if (isModifyMode){
        NSDictionary* oldDic = [tableList objectAtIndex:nSelectedRow];
        
        // 트리구조를 맞춰주기 위해 설정하는 부분임
        [newDic setObject:[oldDic objectForKey:@"ANCESTOR"] forKey:@"ANCESTOR"];
        [newDic setObject:[oldDic objectForKey:@"LEVEL"] forKey:@"LEVEL"];
        [newDic setObject:[oldDic objectForKey:@"CHILD"] forKey:@"CHILD"];
        [newDic setObject:[oldDic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];
        [newDic setObject:[oldDic objectForKey:@"exposeStatus"] forKey:@"exposeStatus"];
        
        if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"]){
            [WorkUtil modifySelectedInfo:oldDic newInfo:newDic fccList:fullTableList];
            [self reloadTableWithRefresh:YES];
            isModifyMode = NO;
        }else{
            NSString* message = [NSString stringWithFormat:@"장치ID '%@'\n (%@)를\n 장치ID '%@'\n (%@)\n (으)로 수정하시겠습니까?", [oldDic objectForKey:@"deviceId"], [oldDic objectForKey:@"barcodeName"], [newDic objectForKey:@"deviceId"], [newDic objectForKey:@"barcodeName"]];
            NSLog(@"Set AsscoatedDic 800 [%@]", newDic);
            objc_setAssociatedObject(tableList, &keynew800, newDic, OBJC_ASSOCIATION_COPY);
            objc_setAssociatedObject(tableList, &keyold800, oldDic, OBJC_ASSOCIATION_RETAIN);
            
            [self showMessage:message tag:800 title1:@"예" title2:@"아니오"];
        }
    }else{
        [newDic setObject:deviceId forKey:@"ANCESTOR"];
        [newDic setObject:@"2" forKey:@"LEVEL"];
        [newDic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        [WorkUtil setChild:newDic fccList:fullTableList];
        [fullTableList addObject:newDic];
        nSelectedRow = fullTableList.count - 1;
        [self reloadTableWithRefresh:YES];
        [self scrollToIndex:nSelectedRow];
    }
}

- (void)addFacToTableWithTitle:(NSString*)title Info:(NSDictionary*)facInfo isRemake:(BOOL)isRemake
{
    NSString* barcode = [facInfo objectForKey:@"UNITID"];
    NSString* POSID = [facInfo objectForKey:@"POSID"];
    NSString* barcodeName = [facInfo objectForKey:@"EQKTX"];
    [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[facInfo objectForKey:@"PART_NAME"] forKey:@"PART_NAME"];
    [dic setObject:[facInfo objectForKey:@"PARTTYPE"] forKey:@"partType"];
    [dic setObject:barcode forKey:@"EQUNR"];
    [dic setObject:[facInfo objectForKey:@"ZPSTATU"] forKey:@"deviceStatusName"];
    [dic setObject:[facInfo objectForKey:@"DEVTYPE"] forKey:@"devType"];
    [dic setObject:[facInfo objectForKey:@"LOCCODE"] forKey:@"locCode"];
    [dic setObject:[facInfo objectForKey:@"DEVICEID"] forKey:@"deviceId"];
    [dic setObject:barcodeName forKey:@"barcodeName"];
    [dic setObject:POSID forKey:@"posId"];
    [dic setObject:@"" forKey:@"itemCode"];
    [dic setObject:@"" forKey:@"itemName"];
    [dic setObject:[facInfo objectForKey:@"SCANTYPE"] forKey:@"SCANTYPE"];
    [dic setObject:[facInfo objectForKey:@"CHECKORGVALUE"] forKey:@"checkOrgValue"];
    [dic setObject:title forKey:@"title"];
    // 계층구조를 새로 만들어줄 필요가 없이 서버에서 형상지어서 넘어오는 경우는 계층구조를 만들기 위해 필요한 필드들을 넣어 주어야 한다.
    if (!isRemake){
        [dic setObject:[facInfo objectForKey:@"DEVICEID"] forKey:@"ANCESTOR"];
        [dic setObject:[facInfo objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];
        [dic setObject:[facInfo objectForKey:@"LEVEL"] forKey:@"LEVEL"];
        [dic setObject:@"" forKey:@"CHILD"];
        [dic setObject:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
    }
    
    if (isModifyMode){  // 수정버튼을 클릭한 후 수정할 항목을 스캔한 경우
        NSDictionary* oldDic = [tableList objectAtIndex:nSelectedRow];
        
        if (![[oldDic objectForKey:@"PART_NAME"] isEqualToString:[dic objectForKey:@"PART_NAME"]]){
            NSString* message = @"다른 종류의 바코드로 수정하실 수 없습니다.\n \n 같은 종류의 바코드를 다시 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        NSString* alertTitle = [NSString stringWithFormat:@"%@:%@:%@:%@",
                                [dic objectForKey:@"partType"], [dic objectForKey:@"EQUNR"],
                                [dic objectForKey:@"PART_NAME"],
                                [WorkUtil getDeviceTypeName:[dic objectForKey:@"devType"]]];
        NSString* message = [NSString stringWithFormat:@"원본바코드:%@\n 수정바코드:%@로 수정하시겠습니까?", [oldDic objectForKey:@"title"], alertTitle];
        // 트리구조를 맞춰주기 위해 설정하는 부분임
        [dic setObject:[oldDic objectForKey:@"ANCESTOR"] forKey:@"ANCESTOR"];
        [dic setObject:[oldDic objectForKey:@"LEVEL"] forKey:@"LEVEL"];
        [dic setObject:[oldDic objectForKey:@"CHILD"] forKey:@"CHILD"];
        [dic setObject:[oldDic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];
        [dic setObject:[oldDic objectForKey:@"exposeStatus"] forKey:@"exposeStatus"];
        
        if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"]){
            [WorkUtil modifySelectedInfo:oldDic newInfo:dic fccList:fullTableList];
            [self reloadTableWithRefresh:YES];
            isModifyMode = NO;
        }else{
            objc_setAssociatedObject(tableList, &keynew800, dic, OBJC_ASSOCIATION_COPY);
            objc_setAssociatedObject(tableList, &keyold800, oldDic, OBJC_ASSOCIATION_RETAIN);
            
            
            [self showMessage:message tag:800 title1:@"예" title2:@"아니오"];
        }
    }else{
        NSInteger index = [self isExistInListOfBarcode:strFccBarCode];
        
        if (index >= 0){
            [self tableView:_tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
            nSelectedRow = index;
            [self scrollToIndex:index];
            [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
            
            NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",strFccBarCode];
            if (![[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"])
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            return;
        }
        NSString* errMsg = @"";
        errMsg = [WorkUtil makeHierarchyOfAddedData:dic selRow:&nSelectedRow isMakeHierachy:YES isCheckUU:btnUU.selected isRemake:isRemake fccList:fullTableList job:JOB_GUBUN];
        
        if (errMsg.length){
            [self showMessage:errMsg tag:-1 title1:@"닫기" title2:@"" isError:YES];
        }
        
        [self reloadTableWithRefresh:YES];
        [self scrollToIndex:nSelectedRow];
    }
    self.isSendFlag =  YES;
}

// 해당 바코드의 레벨을 리턴한다.
- (NSInteger)getLevel:(NSString*)barcode
{
    if ([barcode isEqualToString:@""])
        return 2;
    
    NSDictionary* dic = [self getThisBarcodeInfo:barcode];
    if (dic != nil){
        return [[dic objectForKey:@"LEVEL"] integerValue];
    }
    
    return 2;
}

- (BOOL) validateDeviceId
{
    if(validateYNList.count > 0){
        [validateYNList removeAllObjects];
    }
    if (validateYNList == nil)
        validateYNList = [NSMutableArray array];
    
    for(NSDictionary* dic in fullTableList){
        if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"])
            continue;
        
        if (![[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"])
            continue;
        
        NSString* status = [dic objectForKey:@"deviceStatusName"];
        NSString* locCode = [dic objectForKey:@"locCode"];
        NSString* deviceId = [dic objectForKey:@"deviceId"];
        
        if (![status isEqualToString:@"운용"])            continue;
        
        if ([[locCode substringToIndex:11] isEqualToString:[strCompleteLocBarCode substringToIndex:11]])
            continue;
        
        self.isValidateDeviceId = NO;
        
        objc_setAssociatedObject(tableList, &key1000, dic, OBJC_ASSOCIATION_RETAIN);
        diagStat = NO;
        
        NSString* message = [NSString stringWithFormat:@"장치ID(%@) 는\n 다른 위치(%@)에서\n 운용 중인 장치ID 입니다.\n SET 이동인 경우만 처리 가능합니다.\n 진행하시겠습니까?", deviceId, [locCode substringToIndex:11]];
        [self showMessage:message tag:1000 title1:@"예" title2:@"아니오"];
        
        if (!diagStat)
            return diagStat;
    }
    
    return YES;
}



- (NSInteger)isExistInListOfBarcode:(NSString*)barcode
{
    for(NSInteger index = 0; index < fullTableList.count; index++){
        NSDictionary* dic = [fullTableList objectAtIndex:index];
        if ([[dic objectForKey:@"EQUNR"] isEqualToString:barcode])
            return index;
    }
    
    return -1;
}

- (int)containBarcode:(NSString*)barcode inFccList:(NSArray*)fccList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"EQUNR CONTAINS %@", barcode];
    int index = (int)[fccList  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [predicate evaluateWithObject:obj];
    }];
    
    if(index == NSNotFound){
        index = -1;
    }
    return index;
}

- (NSDictionary*)getThisBarcodeInfo:(NSString*)barcode
{
    for(NSDictionary* dic in fullTableList){
        if ([[dic objectForKey:@"EQUNR"] isEqualToString:barcode])
            return dic;
    }
    
    return nil;
}

- (void)initViews
{
    isFirst = YES;
    self.isSendFlag = NO;
    
    //textfield 초기화
    txtLocCode.text = strLocBarCode = strCompleteLocBarCode = @"";
    [self initWhenLocBarcode];
    
    //위치바코드 포커싱
    if (!locBarcodeView.hidden){
        [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    }
    else if (!fccBarcodeView.hidden){
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    }
}

- (void)initWhenLocBarcode
{
    ////////////////// 화면 초기화 ///////////////////
    //textfield 초기화
    txtFacCode.text = strFccBarCode = strMoveBarCode = @"";
    txtDeviceID.text = strDeviceID  = @"";
    lblDeviceID.text = @"";
    lblWBSNo.text = @"";
    lblPartType.text = @"";
    
    btnChangeWBS.hidden = YES;
    isModifyMode = NO;
    isMoveMode = NO;
    isChange = NO;
    messageView.hidden = YES;
    
    btnUU.selected = NO;
    btnRegDecision.enabled = NO;
    
    if (!locNameView.hidden){
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
    }
    if(!deviceINfoView.hidden)
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
    
    fullTableList = [NSMutableArray array];
    tableList = [NSMutableArray array];
    [_tableView reloadData];
    [self showCount];
    ///////////////////////////////////////////////
    [self workDataInit];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
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


#pragma mark - handle gesture
-(void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (tableList.count){
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            CGPoint p = [gestureRecognizer locationInView:_tableView];
            NSIndexPath* indexPath = [_tableView indexPathForRowAtPoint:p];
            if(indexPath){
                NSDictionary* dic = [tableList objectAtIndex:indexPath.row];
                if(dic.count){
                    if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"] ||
                        [[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"])
                        return;
                    
                    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
                    vc.paramBarcode = [dic objectForKey:@"EQUNR"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
        
    }
}


-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (tableList.count){
        CGPoint p = [gestureRecognizer locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        if (indexPath){
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma user definded action

- (void) touchBackBtn:(id)sender
{
    if (isChange && !isDataSaved){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }else{
        [txtFacCode resignFirstResponder];
        [txtLocCode resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)touchBackground:(id)sender {
    [txtLocCode resignFirstResponder];
    [txtFacCode resignFirstResponder];
}

- (IBAction)touchFccInfoBtn:(id)sender {
    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
    if (tableList.count){
        NSDictionary* selItemdic = [tableList objectAtIndex:nSelectedRow];
        if (strFccBarCode.length)
            vc.paramBarcode = [selItemdic objectForKey:@"EQUNR"]; //설비조회 화면시.
        else
            vc.paramBarcode = [selItemdic objectForKey:@"BARCODE"];
        
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchInitBtn:(id)sender {
    [self initViews];
    //작업관리 초기화
    dbWorkDic = [NSMutableDictionary dictionary];
    
    [self workDataInit];
    
    [self showCount];
}

- (IBAction)touchReScanReqBtn:(id)sender {
    if (isOffLine){
        NSString* message = MESSAGE_CANT_SEND_OFFLINE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    
    if (fullTableList.count < 3){
        NSString* message = @"전송할 설비바코드가\n 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    [self requestSendRescan];
}

- (IBAction)touchMoveBtn:(id)sender {
    if (!isMoveMode){
        if (nSelectedRow < 1){
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        NSDictionary* dic = [tableList objectAtIndex:nSelectedRow];
        NSString* devTypeName = [dic objectForKey:@"PART_NAME"];
        if ([devTypeName isEqualToString:@"L"]){
            NSString* message = @"위치바코드는 이동할 수 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        lblMessage.text = @"이동할 상위 개체를 선택하세요.";
        isMoveMode = YES;
        messageView.hidden = NO;
        self.isSendFlag = YES;
        messageView.frame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height);
        
        [txtLocCode resignFirstResponder];
        [txtDeviceID resignFirstResponder];
        [txtFacCode resignFirstResponder];
    }
}

- (IBAction)touchDelBtn:(id)sender {
    self.isSendFlag = YES;
    if (tableList.count){
        if (tableList.count -1 >= nSelectedRow){
            NSDictionary* dic = [tableList objectAtIndex:nSelectedRow];
            NSString* devTypeName = [dic objectForKey:@"PART_NAME"];
            if ([devTypeName isEqualToString:@"L"]){
                NSString* message = @"위치바코드는 삭제할 수 없습니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
            
            int index = [WorkUtil getBarcodeIndex:[dic objectForKey:@"EQUNR"] fccList:fullTableList];
            
            NSMutableIndexSet* deletedIndexes = [NSMutableIndexSet indexSet];
            [WorkUtil getChildIndexesOfCurrentIndex:index fccList:fullTableList childSet:deletedIndexes isContainSelf:YES];
            NSString* message = nil;
            if (deletedIndexes.count < 2)
                message = @"삭제하시겠습니까?";
            else
                message = @"선택된 항목의 하위 설비를 포함하여\n삭제됩니다.\n삭제하시겠습니까?";
            
            [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
        }else{
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
    }
    else {
        NSString* message = @"선택된 항목이 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    
}

- (IBAction)touchSaveBtn:(id)sender {
    if([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        isDataSaved = YES;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (IBAction)touchSendBtn:(id)sender {
    if (isOffLine){
        NSString* message = MESSAGE_CANT_SEND_OFFLINE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    
    if(!isChange){
        NSString* message = NOT_CHANGE_SEND_MESSAGE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    if (!locBarcodeView.hidden && !lblLocName.text.length){
        NSString* message = @"위치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return;
    }
    
    if ([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"]){
        if (lblWBSNo.text.length <= 0){
            NSString* message = @"WBS 번호가 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return ;
            
        }
    }
    
    
    if (fullTableList.count < 3 || !self.isSendFlag){
        NSString* message = NOT_CHANGE_SEND_MESSAGE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    if (fullTableList.count < 2){
        NSString* message = @"장치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return ;
    }
    
    if (![self validateDeviceId])  return;
    
    NSString* message = @"전송하시겠습니까?";
    [self showMessage:message tag:300 title1:@"예" title2:@"아니오"];
}

- (IBAction)touchRegDecisionBtn:(id)sender {
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    
//    if(![strUserId hasPrefix:@"1"] || strUserId.length != 8){
//        if ([JOB_GUBUN isEqualToString:@"인수"]){
//            NSString* message = @"KT 내부 직원만 '인수확정'이\n 가능합니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//        }
//        else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
//            NSString* message = @"KT 내부 직원만 '등록확정'이\n 가능합니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//        }
//        
//        return;
//    }
    
    if (lblWBSNo.text.length == 0 && [JOB_GUBUN isEqualToString:@"인수"]){
        NSString* message = @"WBS 번호가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    
    NSMutableArray* dataList = [NSMutableArray array];
    for(NSDictionary* dic in fullTableList){
        if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"]){
            NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
            [newDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
            [newDic setObject:@"" forKey:@"POSID"];
            [dataList addObject:newDic];
        }
    }
    
    ArgumentConfirmViewController* vc = [[ArgumentConfirmViewController alloc] init];
    vc.delegate = self;
    vc.POSID = strWBSNo;
    vc.loccd = strCompleteLocBarCode;
    vc.JOB_GUBUN = JOB_GUBUN;
    vc.infoList = dataList;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchUUBtn:(id)sender {
    btnUU.selected = !btnUU.selected;
    
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"UU_YN" forKey:@"TASK"];
    [taskDic setObject:(btnUU.selected)? @"Y":@"N" forKey:@"VALUE"];
    [taskList addObject:taskDic];
}

- (IBAction)touchChangeWBSBtn:(id)sender {
    isChange = YES;
    self.isSendFlag = YES;
    
    WBSListViewController* vc = [[WBSListViewController alloc] init];
    vc.delegate = self;
    vc.wbsList = wbsResultList;
    vc.JOB_GUBUN = JOB_GUBUN;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)touchModifyBtn:(id)sender {
    if (!isModifyMode){
        if (nSelectedRow < 1){
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        NSDictionary* selectedDic = [tableList objectAtIndex:nSelectedRow];
        if([[selectedDic objectForKey:@"PART_NAME"] isEqualToString:@"L"]){
            NSString* message = @"위치바코드는 수정할 수 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        lblMessage.text = @"수정할 개체를 스캔하세요";
        isModifyMode = YES;
        messageView.hidden = NO;
        self.isSendFlag = YES;
        messageView.frame = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y, buttonView.frame.size.width, buttonView.frame.size.height);
        
        // 선택 row의 색을 빨강으로 변경해준다.
        CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
        cell.lblTreeData.textColor = [UIColor redColor];
        
        if ([[selectedDic objectForKey:@"PART_NAME"] isEqualToString:@"D"]){
            [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
        }else{
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
        }
        
        
        // 작업관리
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"MODIFY" forKey:@"TASK"];
        [taskDic setObject:[NSString stringWithFormat:@"%d", (int)nSelectedRow] forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
}

- (IBAction)touchCancel:(id)sender {
    if (isModifyMode){
        isModifyMode = NO;
        messageView.hidden = YES;
        btnModify.enabled = YES;
        
        // 선택 row의 색을 파랑으로 변경해준다.
        CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
        cell.lblTreeData.textColor = [UIColor blueColor];
        
        // 작업관리
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"MODIFY_CANCEL" forKey:@"TASK"];
        [taskList addObject:taskDic];
        
    }
    if (isMoveMode){
        isMoveMode = NO;
        messageView.hidden = YES;
        btnMove.enabled = YES;
    }
    [txtFacCode becomeFirstResponder];
}

- (void) touchTreeBtn:(id)sender
{
    int nTag = (int)[sender tag];
    nSelectedRow = nTag;
    NSDictionary* selItemDic = [tableList objectAtIndex:nTag];
    int index = [WorkUtil getBarcodeIndex:[selItemDic objectForKey:@"EQUNR"] fccList:fullTableList];
    NSString* status;
    
    
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
        
    }
    else{
        if (cellStatus == SUB_CATEGORIES_EXPOSED)
            status = [NSString stringWithFormat:@"%d", SUB_CATEGORIES_NO_EXPOSE];
        else
            status = [NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED];
        
        NSMutableDictionary* itemInFullListDic = [selItemDic mutableCopy];
        
        [itemInFullListDic setObject:status forKey:@"exposeStatus"];
        [fullTableList replaceObjectAtIndex:index withObject:itemInFullListDic];
        [self reloadTableWithRefresh:YES];
    }
}



- (void) reloadTableWithRefresh:(BOOL)isRefresh
{
    tableList = [NSMutableArray array];
    for(int index = 0; index < fullTableList.count; ){
        NSDictionary* dic = [fullTableList objectAtIndex:index];
        SubCategoryInfo category = [[dic objectForKey:@"exposeStatus"] intValue];
        
        if (category == SUB_CATEGORIES_NO_EXPOSE){
            NSMutableIndexSet * childIndexSet = [NSMutableIndexSet indexSet];
            
            if (![[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"]){
                [WorkUtil getChildIndexesOfCurrentIndex:index fccList:fullTableList childSet:childIndexSet isContainSelf:NO];
                index += [childIndexSet count];
            }else{  // 위치바코드일 경우 모든 아이템을 감추면 된다.
                
                [tableList addObject:dic];
                break;
            }
        }
        index++;
        [tableList addObject:dic];
    }
    
    btnUU.selected = NO;
    
    if (isRefresh){
        [_tableView reloadData];
        [self showCount];
    }
}

#pragma mark - protocol method
- (void)setWBSNo:(NSString*)wbsNo withResult:(BOOL)result;
{
    if (result){
        lblWBSNo.text = wbsNo;
        strWBSNo = wbsNo;
    }
    // 작업관리
    [workDic setObject:wbsNo forKey:@"WBS"];
    
    //WBS를 TASK로 저장한다.
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"WBS" forKey:@"TASK"];
    [taskDic setObject:wbsNo forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    if (!isOffLine){
        [self search];
        if (txtDeviceID.enabled && [txtDeviceID.text isEqualToString:@""] && ![txtDeviceID isFirstResponder])
            [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
        else
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    }else{
        [self afterSearch];
    }
}

- (void)cancelSelectWBSNo
{
    strWBSNo = @"";
    txtDeviceID.text = @"";
    lblDeviceID.text = @"";
    strDeviceID = @"";
    if (btnUU.selected)
        btnUU.selected = NO;
    
    
    [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    
    NSString* message = @"WBS 번호를 선택하세요.";
    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    return;
}

- (void)EndArgumentConfirmIsSend:(BOOL)isSend
{
    if (isSend){
        [self initViews];
        [self showCount];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)  {    // ERP에 저장된 인계스캔 Data 전체가삭제 됩니다. 정말 삭제 하시겠습니까?
        if (buttonIndex == 1)
            [self requestSearch];
        else
            [self requestRescan];
    }
    else if (alertView.tag == 200){ // 재스캔 요청이 들어왔습니다.  정확히 스캔 하시기 바랍니다.
        // 기존 Data가 존재 합니다. 기존 Data를 삭제 후 신규 Scan하시겠습니까?
        if (buttonIndex == 1){
            [self requestSearch];
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
        }else {
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            
            NSString* message = @"ERP에 저장된 인계스캔 Data 전체가\n 삭제 됩니다.\n 정말 삭제 하시겠습니까?";
            [self showMessage:message tag:100 title1:@"예" title2:@"아니오" isError:NO];
        }
    }
    else if (alertView.tag == 300){ // 전송
        if (buttonIndex == 0)
            [self requestSend];
    }else if (alertView.tag == 600){ // 삭제하시겠습니까?
        if (buttonIndex == 0){
            NSMutableIndexSet* deletedIndexes = [NSMutableIndexSet indexSet];
            [WorkUtil getChildIndexesOfCurrentIndex:nSelectedRow fccList:fullTableList childSet:deletedIndexes isContainSelf:YES];
            
            NSDictionary* delFirstDic = [fullTableList objectAtIndex:[deletedIndexes firstIndex]];
            
            [self deleteBarcode:[delFirstDic objectForKey:@"EQUNR"]];
            
            //작업관리에 추가
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"DELETE" forKey:@"TASK"];
            [taskDic setObject:[delFirstDic objectForKey:@"EQUNR"] forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    else if (alertView.tag == 700){
        [self requestChkValidateDeviceId:strDeviceID];
    }
    else if (alertView.tag == 800){ //  DeviceId 수정하시겠습니까?
        if (buttonIndex == 1){
            isSuccDeviceScan = NO;
            isModifyMode = NO;
            messageView.hidden = YES;
        }else{
            NSDictionary* newDic = objc_getAssociatedObject(tableList,&keynew800);
            NSDictionary* oldDic = objc_getAssociatedObject(tableList, &keyold800);
            [WorkUtil modifySelectedInfo:oldDic newInfo:newDic fccList:fullTableList];
            
            [self reloadTableWithRefresh:YES];
            isModifyMode = NO;
            messageView.hidden = YES;
        };
        [txtFacCode becomeFirstResponder];
    }else if (alertView.tag == 1000){
        if (buttonIndex == 1){  // 아니오
            diagStat = NO;
        } else if (buttonIndex == 0) {  // 예
            NSDictionary* associatedDic = objc_getAssociatedObject(tableList,&key1000);
            NSString* deviceId = [associatedDic objectForKey:@"deviceId"];
            [self requestChkValidateDeviceId:deviceId];
        }
        
    }else if (alertView.tag == 1100){
        if (buttonIndex == 0){
            [txtFacCode resignFirstResponder];
            [txtLocCode resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 1300){   // 이동하겠습니까?
        if (buttonIndex == 1){
            isMoveMode = NO;
            messageView.hidden = YES;
        }else{
            NSDictionary* objDic = objc_getAssociatedObject(tableList,&keyObj1300);
            NSDictionary* tarDic = objc_getAssociatedObject(tableList, &keyTar1300);
            NSString* objectBarcode = [objDic objectForKey:@"EQUNR"];
            NSString* objPartType = [objDic objectForKey:@"PART_NAME"];
            NSString* tarPartType = [tarDic objectForKey:@"PART_NAME"];
            NSString* message = [WorkUtil nodeValidateSourceType:objPartType TargetType:tarPartType isCheckSu:btnUU.selected];
            
            // 메세지가 ""이 아니면 오류임.  오류 메시지를 띄워준다.
            if (![message isEqualToString:@""]){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                nSelectedRow = [WorkUtil getBarcodeIndex:objectBarcode fccList:fullTableList];
                [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
                
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:nSelectedRow inSection:0]] withRowAnimation:NO];
            }else{
                [self moveSource:[objDic objectForKey:@"EQUNR"] toTarget:[tarDic objectForKey:@"EQUNR"]];
            }
            isMoveMode = NO;
            messageView.hidden = YES;
            isChange = YES;
        }
        [txtFacCode becomeFirstResponder];
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
}


#pragma mark - Http Request Method
- (void)requestAuthLocation:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_OTD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestAuthLocation:locBarcode];
}

- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLocCode:locBarcode];
}

- (void)requestWBSCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_WBS;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestWBS:locBarcode];
}


- (void)requestDeviceCode:(NSString*)deviceBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULTI_INFO;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    isMultiDevice = NO;
    [requestMgr requestMultiInfoWithDeviceCode:deviceBarcode];
}

- (void)requestSAPInfo:(NSString*)fccBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSAPInfo:fccBarcode locCode:locCode deviceID:deviceID  orgCode:@"" isAsynch:YES];
}

// 재스캔요청인지, 인수확인 진행 중인지 체크
- (void)requestRescanYN:(NSString*)locCode WBSNo:(NSString*)wbsNo
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_RESCAN_YN;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:wbsNo forKey:@"I_POSID"];
    [paramDic setObject:locCode forKey:@"I_LOCCODE"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_SEARCH_TRANSPER_SCAN withData:bodyDic];
}

// 재스캔요청
- (void)requestRescan
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_RESCAN;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* subParamList = [NSMutableArray array];
    NSDictionary* bodyDic = nil;
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        [paramDic setObject:@"0002" forKey:@"WORKID"];
        [paramDic setObject:@"0540" forKey:@"PRCID"];
        [paramDic setObject:strWBSNo forKey:@"POSID"];
        
        
        sendCount = 0;
        
        for (NSDictionary* dic in rescanList)
        {
            NSMutableDictionary *subParamDic = [[NSMutableDictionary alloc] init];
            
            [subParamDic setObject:strCompleteLocBarCode forKey:@"LOCCODE"];
            [subParamDic setObject:[dic objectForKey:@"DOCNO"] forKey:@"DOCNO"];
            [subParamDic setObject:[dic objectForKey:@"POSID"] forKey:@"POSID"];
            [subParamDic setObject:[dic objectForKey:@"DEVICEID"] forKey:@"DEVICEID"];
            [subParamDic setObject:strUserId forKey:@"S_WORKID"];
            
            [subParamList addObject:subParamDic];
            sendCount++;
        }
    }
    
    bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    
    [requestMgr sychronousConnectToServer:API_SUBMIT_TRANSFER_SCAN_DELETE withData:bodyDic];
}

- (void)requestSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_SEARCH;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        [paramDic setObject:strWBSNo forKey:@"I_POSID"];
        [paramDic setObject:strCompleteLocBarCode forKey:@"I_LOCCODE"];
    }else if ([JOB_GUBUN isEqualToString:@"인수"]){
        [paramDic setObject:@"1" forKey:@"I_DATA_C"];
        [paramDic setObject:strWBSNo forKey:@"I_POSID"];
        [paramDic setObject:strCompleteLocBarCode forKey:@"I_LOCCODE"];
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        [paramDic setObject:@"" forKey:@"I_POSID"];
        [paramDic setObject:strCompleteLocBarCode forKey:@"I_LOCCODE"];
        [paramDic setObject:@"2" forKey:@"I_DATA_C"];
    }
    
    bodyDic = [Util singleMessageBody:paramDic];
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        [requestMgr sychronousConnectToServer:API_SEARCH_TRANSPER_SCAN withData:bodyDic];
    }else if ([JOB_GUBUN isEqualToString:@"인수"]){
        [requestMgr sychronousConnectToServer:API_SEARCH_ARGUMENT_SCAN withData:bodyDic];
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        [requestMgr sychronousConnectToServer:API_SEARCH_INST_CONF_SCAN withData:bodyDic];
    }
}

- (void)requestSendRescan
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_SEND_RESCAN;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:strCompleteLocBarCode forKey:@"LOCCODE"];
    [paramDic setObject:strWBSNo forKey:@"POSID"];
    [paramDic setObject:strDocNo forKey:@"DOCNO"];
    [paramDic setObject:txtDeviceID.text forKey:@"DEVICEID"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SUBMIT_ARGUMENT_SCAN_SENDMAIL withData:rootDic];
}

- (void)requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* subParamList = [NSMutableArray array];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        [paramDic setObject:@"0002" forKey:@"WORKID"];
        [paramDic setObject:@"0510" forKey:@"PRCID"];
        [paramDic setObject:strWBSNo forKey:@"POSID"];
    }else if ([JOB_GUBUN isEqualToString:@"인수"]){
        [paramDic setObject:@"0003" forKey:@"WORKID"];
        [paramDic setObject:@"0520" forKey:@"PRCID"];
        [paramDic setObject:strWBSNo forKey:@"POSID"];
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        [paramDic setObject:@"0003" forKey:@"WORKID"];
        [paramDic setObject:@"0525" forKey:@"PRCID"];
    }
    [paramDic setObject:@"" forKey:@"LOEVM"];
    
#if 0
    // 인계, 인수, 시설등록 전송 시 헤더에 위도, 경도, 거리차 적용 - 큐에이일 경우에만.
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
//        
//        locFucllName = [WorkUtil getFullNameOfLoc:locFucllName];
//        
//        double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:locFucllName];
//        [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
//    }else{
//        [paramDic setObject:@"" forKey:@"LONGTITUDE"];
//        [paramDic setObject:@"" forKey:@"LATITUDE"];
//        [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
//    }
#endif
    
    // 인계, 시설등록일 경우 기존에 불러온 데이타 있으면 우선 삭제 flag : DFLAG-3 로 불러온 WBS번호와 장치아이디 기준으로 전송
    if (![JOB_GUBUN isEqualToString:@"인수"]){
        for(NSDictionary* dic in listDeviceId){
            NSString* deviceId = [dic objectForKey:@"DEVICEID"];
            NSString* wbsNo = [dic objectForKey:@"POSID"];
            NSMutableDictionary* subParamDic = [NSMutableDictionary dictionary];
            
            [subParamDic setObject:@"3" forKey:@"DFLAG"];
            [subParamDic setObject:strCompleteLocBarCode forKey:@"LOCCODE"];
            [subParamDic setObject:deviceId forKey:@"DEVICEID"];
            [subParamDic setObject:wbsNo forKey:@"POSID"];
            
            [subParamList addObject:subParamDic];
        }
    }
    
    sendCount = 0;
    int scanCount_DEVICEID = 0;
    NSString* deviceID_this = @"";
    NSString* deviceId_old = @"-1";
    for(NSDictionary* dic in fullTableList){
        if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"])
            continue;
        
        if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"]){
            deviceID_this = [dic objectForKey:@"deviceId"];
            continue;
        }
        
        if ([JOB_GUBUN isEqualToString:@"인수"]){
            if (![deviceID_this isEqualToString:deviceId_old]){
                if(![deviceId_old isEqualToString:@"-1"] &&
                   scanCount_DEVICEID == 0){
                    NSString* message = [NSString stringWithFormat:@"장치바코드 '%@'\n 하위의 설비를 하나 이상\n 스캔하셔야 합니다.", deviceId_old];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    
                    NSInteger index = [self isExistInListOfBarcode:deviceId_old];
                    
                    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
                    
                    return;
                }
                
                scanCount_DEVICEID = 0;
                deviceId_old = deviceID_this;
            }
            NSString* scanType = [dic objectForKey:@"SCANTYPE"];
            if ([scanType isEqualToString:@"0"])    continue;
            
            scanCount_DEVICEID++;
        }
        NSMutableDictionary* subParamDic = [NSMutableDictionary dictionary];
        
        [subParamDic setObject:@"1" forKey:@"DFLAG"];
        [subParamDic setObject:strCompleteLocBarCode forKey:@"LOCCODE"];
        [subParamDic setObject:deviceID_this forKey:@"DEVICEID"];
        
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        if ([barcode length] < 16){
            NSString* message = [NSString stringWithFormat:@"'%@'는 처리할 수 없는\n 설비바코드 입니다.", barcode];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtFacCode.text = strFccBarCode = lblPartType.text = @"";
            [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
            return;
        }
        
        NSDictionary* parentDic = [WorkUtil getParent:dic fccList:fullTableList];
        NSString* parType_Parent_this = [parentDic objectForKey:@"PART_NAME"];
        if([parType_Parent_this isEqualToString:@"L"] || [parType_Parent_this isEqualToString:@"D"]){
            [subParamDic setObject:@"" forKey:@"SHELF"];
            [subParamDic setObject:barcode forKey:@"UNIT"];
        }else{
            [subParamDic setObject:[parentDic objectForKey:@"EQUNR"] forKey:@"SHELF"];
            [subParamDic setObject:barcode forKey:@"UNIT"];
        }
        
        NSString* partTypeCode =  [dic objectForKey:@"partType"];
        NSString* devTypeCode = [dic objectForKey:@"devType"];
        
        [subParamDic setObject:partTypeCode forKey:@"PARTTYPE"];
        [subParamDic setObject:devTypeCode forKey:@"DEVTYPE"];
        
        if ([JOB_GUBUN isEqualToString:@"시설등록"]){
            NSString* wbsno = [dic objectForKey:@"posId"];
            [subParamDic setObject:wbsno forKey:@"POSID"];
        }
        
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    if (sendCount == 0){
        NSString* message = @"전송할 자료가 존재하지 않습니다.\n 전송할 설비바코드를 하나 이상\n 스캔하셔야 합니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
        return;
    }
    bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    if ([JOB_GUBUN isEqualToString:@"인계"]){
        [requestMgr asychronousConnectToServer:API_SUBMIT_TRANSFER_SCAN withData:rootDic];
    }else if ([JOB_GUBUN isEqualToString:@"인수"]){
        if(scanCount_DEVICEID == 0){
            NSString* message = [NSString stringWithFormat:@"장치바코드 '%@'\n 하위의 설비를 하나 이상\n 스캔하셔야 합니다.", deviceID_this];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
            return;
        }
        [requestMgr asychronousConnectToServer:API_SUBMIT_ARGUMENT_SCAN withData:rootDic];
    }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
        [requestMgr asychronousConnectToServer:API_SUBMIT_INST_CONF_SCAN withData:rootDic];
    }
}

- (void)requestMultiInfoWithDeviceId:(NSString*)deviceId
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULTI_INFO;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:deviceId forKey:@"SOURCE_CODE"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    isMultiDevice = YES;
    
    [requestMgr sychronousConnectToServer:API_MULTI_INFO withData:bodyDic];
}


- (void)requestChkValidateDeviceId:(NSString*)deviceId
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_CHECK_VALIDATE_DEVICEID;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:deviceId forKey:@"I_ZEQUIPGC"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_DEVICEID_BELOW_FAC_LIST withData:bodyDic];
    
}

- (BOOL)checkExistWithDevideId:(NSString*)deviceId FccId:(NSString*)fccId InChildSet:(NSIndexSet*)childSet
{
    NSMutableIndexSet* mis = [childSet mutableCopy];
    
    while(mis.count){
        NSInteger index = [mis firstIndex];
        NSDictionary* dic = [fullTableList objectAtIndex:index];
        NSString* deviceIdInSet = [dic objectForKey:@"deviceId"];
        NSString* fccIdInSet = [dic objectForKey:@"EQUNR"];
        
        if ([deviceId isEqualToString:deviceIdInSet] &&
            [fccId isEqualToString:fccIdInSet])
            return YES;
        
        [mis removeIndex:index];
    }
    
    return NO;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if ([string isEqualToString:@"\n"]){
        NSLog(@"newline char range [%@] string[%@]",NSStringFromRange(range),string);
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
    return [tableList count];
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
    NSDictionary* dic = [tableList objectAtIndex:indexPath.row];
    NSString* title = [dic objectForKey:@"title"];
    NSInteger level = [[dic objectForKey:@"LEVEL"] integerValue];
    NSString* partTypeName = [dic objectForKey:@"PART_NAME"];
    
    cell.indentationLevel = level;
    
    [cell setIndentationWidth:10.0f];
    
    
    CGFloat textLength = [title sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
    
    cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength+cell.indentationLevel*cell.indentationWidth, cell.lblTreeData.frame.size.height);
    cell.lblTreeData.text = title;
    cell.scrollView.contentSize = CGSizeMake(textLength+cell.indentationLevel*cell.indentationWidth + 30, COMMON_CELL_HEIGHT);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (nSelectedRow == indexPath.row){
        cell.lblTreeData.textColor = [UIColor blueColor];
        lblPartType.text = partTypeName;
    }else
        cell.lblTreeData.textColor = [UIColor blackColor];
    
    NSString* scanType = [dic objectForKey:@"SCANTYPE"];
    if ([partTypeName isEqualToString:@"L"])
        cell.lblBackground.backgroundColor = RGB(255, 255, 173);
    else if ([partTypeName isEqualToString:@"D"])
        cell.lblBackground.backgroundColor = COLOR_SCAN1;
    else if ([scanType isEqualToString:@"4"])
        cell.lblBackground.backgroundColor = RGB(255,182,193);
    else if (![scanType isEqualToString:@"0"])
        cell.lblBackground.backgroundColor = COLOR_SCAN1;
    
    
    cell.hasSubNode = YES;
    ///////// Tree View표현을 위한 코드
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
    ////////////
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCell* cell =(CommonCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
    cell.lblTreeData.textColor = [UIColor blackColor];
    
    if(isMoveMode){
        NSDictionary* objectDic = [tableList objectAtIndex:nSelectedRow];
        NSDictionary* objectInFullDic = [WorkUtil getItemFromFccList:[objectDic objectForKey:@"EQUNR"] fccList:fullTableList];
        
        nSelectedRow = indexPath.row;
        NSDictionary* targetDic = [tableList objectAtIndex:nSelectedRow];
        NSDictionary* targetInFullDic = [WorkUtil getItemFromFccList:[targetDic objectForKey:@"EQUNR"] fccList:fullTableList];
        
        
        objc_setAssociatedObject(tableList, &keyObj1300, objectInFullDic, OBJC_ASSOCIATION_COPY);
        objc_setAssociatedObject(tableList, &keyTar1300, targetInFullDic, OBJC_ASSOCIATION_COPY);
        
        
        NSString* message = [NSString stringWithFormat:@"'%@:%@'의 하위로 이동하시겠습니까?",
                             [targetDic objectForKey:@"PART_NAME"],
                             [targetDic objectForKey:@"EQUNR"]];
        [self showMessage:message tag:1300 title1:@"예" title2:@"아니오"];
        
        return;
    }
    
    nSelectedRow = indexPath.row;
    NSDictionary* dic = [tableList objectAtIndex:indexPath.row];
    
    if(isModifyMode){
        cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
        cell.lblTreeData.textColor = [UIColor redColor];
    }else{
        cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
        cell.lblTreeData.textColor = [UIColor blueColor];
    }
    
    NSString* devTypeName = [dic objectForKey:@"PART_NAME"];
    if ([devTypeName isEqualToString:@"D"]){
        if (isModifyMode)
            [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
        else
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
        txtDeviceID.text = [dic objectForKey:@"deviceId"];
        
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:[NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"itemCode"],[dic objectForKey:@"itemName"]]];
    }else if (![devTypeName isEqualToString:@"L"] && ![devTypeName isEqualToString:@"D"]){
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
        txtFacCode.text = [dic objectForKey:@"EQUNR"];
        strFccBarCode = txtFacCode.text;
        lblPartType.text = [dic objectForKey:@"PART_NAME"];
    }
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        if (pid == REQUEST_SEND){
            if (status == 0)
                [workDic setObject:@"E" forKey:@"TRANSACT_YN"];
            else if (status == 2)
                [workDic setObject:@"W" forKey:@"TRANSACT_YN"];
            
            [workDic setObject:message forKey:@"TRANSACT_MSG"];
            [self saveToWorkDB];
            isDataSaved = YES;
        }
        
        if (pid == TAKEOVER_REQUEST_CHECK_VALIDATE_DEVICEID){
            diagStat = NO;
        }
        [self processFailRequest:pid Message:message];
        
        return;
    }else if (status == -1){ //세션종료
        if (pid == TAKEOVER_REQUEST_CHECK_VALIDATE_DEVICEID){
            diagStat = NO;
        }
        
        return;
    }
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == REQUEST_OTD){
        [self processOTDResponse];
    }else if (pid == REQUEST_WBS){
        [self processWBSList:resultList];
    }else if (pid == REQUEST_MULTI_INFO){
        if (resultList)
            [self processDeviceBarcode:[resultList objectAtIndex:0]];
        else
            [self processDeviceBarcode:nil];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_RESCAN_YN){
        [self processRescanYNResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_RESCAN){
        [self processRescanResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_SEARCH){
        [self processSearchResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_SEND_RESCAN){
        [self processSendRescanResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_CHECK_VALIDATE_DEVICEID){
        [self processCheckValidateDeviceIdResponse:resultList];
    }else if (pid == REQUEST_SEND){
        [self processSendResponse:resultList];
    }else
        isOperationFinished = YES;
}

- (void)processLocList:(NSArray*)locList
{
    NSDictionary* dic = [locList objectAtIndex:0];
    [Util setScrollTouch:scrollLocName Label:lblLocName withString:[dic objectForKey:@"locationShortName"]];
    
    strCompleteLocBarCode = [dic objectForKey:@"completeLocationCode"];
    strLocBarCode = strCompleteLocBarCode;
    
    NSString* operationSystemCode = [dic objectForKey:@"operationSystemCode"];
    
    if (txtLocCode.text.length == 9) {//장치바코드
        txtDeviceID.text = txtLocCode.text;
        txtLocCode.text = strCompleteLocBarCode;
        strDeviceID = txtDeviceID.text;
        lblDeviceID.text = operationSystemCode;
    }
    else if (txtLocCode.text.length <= 10) {
        txtLocCode.text = strCompleteLocBarCode;
    }
    
    [self requestAuthLocation:strCompleteLocBarCode];
}

- (void)processOTDResponse
{
    // 작업관리 추가
    [workDic setObject:txtLocCode.text forKey:@"LOC_CD"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"L" forKey:@"TASK"];
    [taskDic setObject:txtLocCode.text forKey:@"VALUE"];
    
    // 음영지역에서 작업할 때는 WBS창을 띄워주지 않는다.
    // 작업관리로 실행 할 때는 저장할때 선택한 WBS가 있다면(음영지역이 아니었음) WBS선택 창을 띄워주지 않는다.
    // 작업관리 실행 시 isSelectedWBS의 값으로 설정될 것임.
    if (![JOB_GUBUN isEqualToString:@"시설등록"] && !isOffLine){
        [taskDic setObject:@"Y" forKey:@"WBS"]; // 선택한 WBS가 없음
    }else{
        [taskDic setObject:@"N" forKey:@"WBS"]; // 선택한 WBS가 있음.  선택은 아래에서 할 것임.
    }
    [taskList addObject:taskDic];
    
    //"인계"나 "인수"시에만 WBS 번호를 선택하도록 한다.
    if (![JOB_GUBUN isEqualToString:@"시설등록"]){
        if (!isOffLine){
            if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"]
                ){
                if (strCompleteLocBarCode.length)
                    [self requestWBSCode:strCompleteLocBarCode];
            }
            else if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"Y"] && !isSlectedWBS && strCompleteLocBarCode.length)
                [self requestWBSCode:strCompleteLocBarCode];
            else
                isOperationFinished = YES;
        }
        else
            isOperationFinished = YES;
    }else {
        [self search];
        isOperationFinished = YES;
    }
}

- (void)processWBSList:(NSArray*)wbsList
{
    if (wbsList.count){
        WBSListViewController* vc = [[WBSListViewController alloc] init];
        vc.delegate = self;
        vc.wbsList = wbsList;
        vc.JOB_GUBUN = JOB_GUBUN;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString* message = @"WBS가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    }
}

- (void)processDeviceBarcode:(NSDictionary*)devideInfoDic
{
    if (devideInfoDic){
        NSString* operationSystemToken = [devideInfoDic objectForKey:@"operationSystemToken"];
        NSString* standardServiceCode = [devideInfoDic objectForKey:@"standardServiceCode"];
        NSString* operationSystemCode = [devideInfoDic objectForKey:@"operationSystemCode"];    // 장비아이디
        
        NSString* deviceID = [devideInfoDic objectForKey:@"deviceId"];
        deviceLocCd = [devideInfoDic objectForKey:@"locationCode"];
        deviceLocNm = [devideInfoDic objectForKey:@"locationShortName"];
        
        if ( [operationSystemToken isEqualToString:@"02"] && ![standardServiceCode length]){
            
            NSString* message = [NSString stringWithFormat:@"장치아이디 %@는\n운용시스템 구분자가 'ITAM'이며 \n IT표준서비스코드가 '없음'이므로\n스캔이 불가합니다.\n전사기준정보관리시스템(MDM)에\n문의하세요",strDeviceID];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }
        
        // 통합 NMS 대상 장치 ID의 장비ID가 삭제되었을 경우 ERP Barcode Web에서 출력 및 스캔 불가 - DR-2014-08382 : request by 박장수 2014.03.11
        if ( ([operationSystemToken isEqualToString:@"04"] || [operationSystemToken isEqualToString:@"08"] || [operationSystemToken isEqualToString:@"09"] || [operationSystemToken isEqualToString:@"10"]) && [operationSystemCode isEqualToString:@""]){
            
            NSString* message = [NSString stringWithFormat:@"통합NMS 대상 장치ID의 장비ID가\n삭제되어 스캔이 불가합니다. \n전사기준정보관리시스템(MDM)에\n문의하세요."];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            isOperationFinished = YES;
            
            return;
        }
        
        //물품명
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:[NSString stringWithFormat:@"%@/%@",[devideInfoDic objectForKey:@"itemCode"],[devideInfoDic objectForKey:@"itemName"]]];
        
        if (isMultiDevice){     // wbs에 인계작업이 있는 경우 여러개의 deviceId 정보를 추가하기 위해서...
            [subFacList addObject:devideInfoDic];
            return;
        }else{
            // tableList에 추가할 제목필드 만들기
            NSString* title = [NSString stringWithFormat:@"D:%@:%@:%@:%@:R:%@:%@", [devideInfoDic objectForKey:@"deviceId"], [devideInfoDic objectForKey:@"deviceName"], [devideInfoDic objectForKey:@"itemCode"], [devideInfoDic objectForKey:@"itemName"], [devideInfoDic objectForKey:@"locationCode"], [devideInfoDic objectForKey:@"deviceStatusName"]];
            isSuccDeviceScan = NO;
            [self addDeviceToTableTitle:title Info:devideInfoDic Parent:strCompleteLocBarCode];
            if (isSuccDeviceScan){
                if (deviceID.length){
                    txtDeviceID.text = deviceID;
                    strDeviceID = txtDeviceID.text;
                }
                
                strDeviceID = [devideInfoDic objectForKey:@"deviceId"];
                [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
            }else{
                [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
            }
            
            // 작업관리
            [workDic setObject:txtDeviceID.text forKey:@"DEVICE_ID"];
            //working task add
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"D" forKey:@"TASK"];
            [taskDic setObject:txtDeviceID.text forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    
    if (!isMultiDevice){
        [self scrollToIndex:nSelectedRow];
        self.isSendFlag = YES;
        isOperationFinished = YES;
    }
}

- (void)processCheckValidateDeviceIdResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* associatedDic = objc_getAssociatedObject(tableList,&key1000);
        NSLog(@"Get AsscoatedDic 1000 [%@]", associatedDic);
        NSString* deviceId = [associatedDic objectForKey:@"deviceId"];
        
        for(NSDictionary* dic in resultList){
            NSString* barcodeInDeviceId = [dic objectForKey:@"EQUNR"];
            BOOL existsFlagInDeviceId = NO;
            
            for(NSDictionary* subDic in fullTableList){
                NSString* deviceId_this = @"";
                
                if ([[subDic objectForKey:@"PART_NAME"] isEqualToString:@"L"])
                    continue;
                if (![[subDic objectForKey:@"PART_NAME"] isEqualToString:@"D"])
                    continue;
                
                
                deviceId_this = [subDic objectForKey:@"deviceId"];
                
                if (![deviceId_this isEqualToString:deviceId])    continue;
                
                NSMutableIndexSet* childIndexSet = [NSMutableIndexSet indexSet];
                [WorkUtil getChildIndexesOfCurrentIndex:[fullTableList indexOfObject:subDic] fccList:fullTableList childSet:childIndexSet isContainSelf:NO];
                if([self checkExistWithDevideId:deviceId FccId:barcodeInDeviceId InChildSet:childIndexSet]){
                    existsFlagInDeviceId = YES;
                    break;
                }
            }
            if(!existsFlagInDeviceId){
                NSString* location = [associatedDic objectForKey:@"locCode"];
                NSString* message = [NSString stringWithFormat:@"스캔하신\n '건물위치정보(%@)' 와\n 장치ID(운용상태)의\n '건물위치정보(%@)' 가\n 상이합니다.\n 장치ID를 확인하시기 바랍니다.", [strCompleteLocBarCode substringToIndex:11], [location substringToIndex:11]];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil  isError:YES];
                diagStat = NO;
                return;
            }
        }
    }else{
        diagStat = NO;
        return;
    }
    
    diagStat = YES;
}

- (void)processSAPResponse:(NSArray*)sapList
{
    if ([sapList count]){
        NSDictionary* firstDic = [sapList objectAtIndex:0];
        NSString* barcode = [firstDic objectForKey:@"EQUNR"];
        if (![strFccBarCode isEqualToString:barcode]){
            if ([barcode rangeOfString:strFccBarCode].location != NSNotFound){
                strFccBarCode = barcode;
                txtFacCode.text = strFccBarCode;
            }
        }
        
        // 1. 설비상태 체크
        NSString* ZPSTATU = [firstDic objectForKey:@"ZPSTATU"];
        NSString* ZDESC = [firstDic objectForKey:@"ZDESC"];
        NSString* SUBMT = [firstDic objectForKey:@"SUBMT"];
        
        NSString* message = [WorkUtil processCheckFccStatus:ZPSTATU desc:ZDESC submt:SUBMT];
        if (message.length){
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
            isOperationFinished = YES;
            
            return;
        }
        
        NSString* O_DATA_C = [firstDic objectForKey:@"O_DATA_C"];
        
        if (([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"])){
            if([O_DATA_C isEqualToString:@"2"]){
                NSString* message = @"해당 설비바코드는 '인계'\n 대상이 아닙니다.\n '시설등록'으로 처리 하시기 바랍니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                return;
            }
            
            //matsua : dr-2015-06633
            NSString *ZANLN1 = [firstDic objectForKey:@"ZANLN1"]; //자산번호
            NSString *ANSDT = [firstDic objectForKey:@"ANSDT"];   //취득일
            NSString *ZSETUP = [firstDic objectForKey:@"ZSETUP"]; //공사비
            
            // 자료보정
            if ([ANSDT isEqualToString:@"0000-00-00"]) ANSDT = @"";
            if ([ZSETUP isEqualToString:@""] || [ZSETUP isEqualToString:@"0.00"]) ZSETUP = @"0";
            
            if(![ZANLN1 isEqualToString:@""] && ![ANSDT isEqualToString:@""] && ![ZSETUP isEqualToString:@"0"]){
                NSString* message = @"구품 설비는 철거 스캔 선행 후\n인계 작업을 진행 하시기 바랍니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                //return;
            }
        }
        else if ([JOB_GUBUN isEqualToString:@"시설등록"] && ([O_DATA_C isEqualToString:@""] || [O_DATA_C isEqualToString:@"1"])){
            NSString* message = @"해당 설비바코드는 '시설등록'\n 대상이 아닙니다.\n '인계'로 처리 하시기 바랍니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            isOperationFinished = YES;
            
            return;
        }
        
        NSString* thisBarcode = [firstDic objectForKey:@"EQUNR"];
        NSString* barcodeName = [firstDic objectForKey:@"MAKTX"];
        NSString* partTypeName = [WorkUtil getPartTypeName:[firstDic objectForKey:@"ZPPART"] device:[firstDic objectForKey:@"ZPGUBUN"]];
        NSString* statusName = [WorkUtil getFacilityStatusName:[firstDic objectForKey:@"ZPSTATU"]];
        NSString* ZKOSTL = [firstDic objectForKey:@"ZKOSTL"];
        NSString* ZKTEXT = [firstDic objectForKey:@"ZKTEXT"];
        NSString* deviceTypeName =  [WorkUtil getDeviceTypeName:[firstDic objectForKey:@"ZPGUBUN"]]; //디바이스코드(ZPGUBUN)
        NSString* deviceID = [firstDic objectForKey:@"ZEQUIPGC"];
        NSString* checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@", ZKOSTL, ZKTEXT];
        NSString* scanType;
        
        if (isModifyMode)   // 수정을 위해 스캔한 경우
            scanType = @"1";
        else                // 무조건 추가
            scanType = @"2";
        NSString* wbsNo = @"";
        if ([JOB_GUBUN isEqualToString:@"시설등록"] && [firstDic objectForKey:@"ZPS_PNR"] != nil)
            wbsNo = [firstDic objectForKey:@"ZPS_PNR"];
        NSString* title = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@::", partTypeName, thisBarcode, statusName, barcodeName, deviceTypeName, deviceID, scanType, checkOrgValue, wbsNo];
        
        self.isSendFlag = YES;
        
        if (![self checkFacInfo:firstDic]){
            isOperationFinished = YES;
            return;
        }
        
        NSMutableDictionary* sapInfoDic = [NSMutableDictionary dictionary];
        [sapInfoDic setObject:deviceID forKey:@"DEVICEID"];
        [sapInfoDic setObject:wbsNo forKey:@"POSID"];
        [sapInfoDic setObject:@"" forKey:@"SHELFID"];
        [sapInfoDic setObject:thisBarcode forKey:@"UNITID"];
        [sapInfoDic setObject:[firstDic objectForKey:@"EQKTX"] forKey:@"EQKTX"];
        [sapInfoDic setObject:[firstDic objectForKey:@"ZPGUBUN"] forKey:@"DEVTYPE"];
        [sapInfoDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapInfoDic setObject:[firstDic objectForKey:@"ZEQUIPLP"] forKey:@"LOCCODE"];
        [sapInfoDic setObject:@"" forKey:@"HEQUNR"];
        [sapInfoDic setObject:[firstDic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
        [sapInfoDic setObject:scanType forKey:@"SCANTYPE"];
        [sapInfoDic setObject:@"" forKey:@"CHECKORGVALUE"];
        [sapInfoDic setObject:[firstDic objectForKey:@"ZPPART"] forKey:@"PARTTYPE"];
        [sapInfoDic setObject:statusName forKey:@"deviceStatusName"];
        
        if (!isModifyMode){
            //working task add
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"F" forKey:@"TASK"];
            [taskDic setObject:strFccBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        
        self.isSendFlag = YES;
        [self addFacToTableWithTitle:title Info:sapInfoDic isRemake:YES];
        lblPartType.text = partTypeName;
        isChange = YES;
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    else {
        NSString* message = @"존재하지 않는 설비바코드입니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
    [self scrollToIndex:nSelectedRow];
    isOperationFinished = YES;
}

- (void)processRescanYNResponse:(NSArray*)resultList
{
    if ([resultList count]){
        [self setWorkStepFlage:resultList];
        
        if ([JOB_GUBUN isEqualToString:@"인계"]){
            // 인계스캔 재스캔 요청 조회 - 01 결과 리스트
            rescanList = [NSMutableArray array];
            for (NSDictionary* dic in resultList){
                NSMutableDictionary* searchDic = [NSMutableDictionary dictionary];
                [searchDic setObject:[dic objectForKey:@"DOCNO"] forKey:@"DOCNO"];
                [searchDic setObject:[dic objectForKey:@"POSID"] forKey:@"POSID"];
                [searchDic setObject:[dic objectForKey:@"DEVICEID"] forKey:@"DEVICEID"];
                
                [rescanList addObject:searchDic];
            }
            
            if (isRescan){
                self.isSendFlag = NO;
                NSString* message = @"재스캔 요청이 들어왔습니다.\n 정확히 스캔 하시기바랍니다.\n 기존 Data가 존재 합니다.\n 기존 Data를 삭제 후\n 신규 Scan하시겠습니까?";
                [self showMessage:message tag:200 title1:@"예" title2:@"아니오"];
                
                return;
            }else
                [self requestSearch];
        }else if ([JOB_GUBUN isEqualToString:@"인수"]){
            [self setWorkStepFlage:resultList];
            btnRegDecision.enabled = isWorkStep;
            [self requestSearch];
        }
    }else
        [self requestSearch];
}

- (void)processRescanResponse:(NSArray*)resultList
{
#if 0
    if ([resultList count]){
        NSString* message = [resultList objectAtIndex:0];
        if (message.length)
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:NO];
    }
#else
    NSDictionary* msgDic = [resultList objectAtIndex:0];
    NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n\n%@", (int)sendCount, [msgDic objectForKey:@"E_MESG"]];
    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:NO];
#endif
    isWorkStep = NO;
    self.isSendFlag = NO;
    
    [self afterSearch];
}

- (void)processSearchResponse:(NSArray*)resultList
{
    if (![resultList count]){
        if ([JOB_GUBUN isEqualToString:@"인계"]){
            NSString* message = @"첫 인계스캔 입니다.\n 작업하신 장비를 장치바코드를 포함하여 정확하게 스캔하여 주시기 바랍니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
            
        }else if ([JOB_GUBUN isEqualToString:@"인수"]){
            NSString* message = @"조회된 정보가 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
        }else if ([JOB_GUBUN isEqualToString:@"시설등록"]){
            NSString* message = @"첫 시설등록스캔 입니다.\n 작업하신 장비를 장치바코드를 포함하여 정확하게 스캔하여 주시기 바랍니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
            
        }
        
        [_tableView reloadData];
        [self showCount];
        [self afterSearch];
        return;
    }
    
    listDeviceId = [NSMutableArray array];
    
    strDeviceID = [(NSDictionary*)[resultList objectAtIndex:0] objectForKey:@"DEVICEID"];
    
    txtDeviceID.text = strDeviceID;
    
    deviceCount = 0;
    NSString* oldDeviceId = @"";
    NSDictionary* lastDic;
    for(NSDictionary* dic in resultList){
        lastDic = dic;
        NSMutableDictionary* sapInfoDic = [NSMutableDictionary dictionary];
        
        NSString* UFACBARCODE = [dic objectForKey:@"SHELFID"];
        NSString* deviceId = [dic objectForKey:@"DEVICEID"];
        NSString* wbsno = [dic objectForKey:@"POSID"];
        NSString* SHELFID = [dic objectForKey:@"SHELFID"];
        NSString* barcode = [dic objectForKey:@"UNITID"];
        NSString* EQKTX = [dic objectForKey:@"EQKTX"];
        NSString* devType = [dic objectForKey:@"DEVTYPE"];
        NSString* partType = @"";
        partType = [dic objectForKey:@"PARTTYPE"];
        NSString* partTypeName = @"";
        partTypeName = [WorkUtil getPartTypeName:partType device:devType];
        NSString* LOCCODE = [dic objectForKey:@"LOCCODE"];
        NSString* HEQUI = [dic objectForKey:@"HEQUI"];
        NSString* ZPSTATU = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]];
        
        [sapInfoDic setObject:deviceId forKey:@"DEVICEID"];
        [sapInfoDic setObject:wbsno forKey:@"POSID"];
        [sapInfoDic setObject:SHELFID forKey:@"HEQUNR"];
        [sapInfoDic setObject:barcode forKey:@"UNITID"];
        [sapInfoDic setObject:barcode forKey:@"EQUNR"];
        [sapInfoDic setObject:EQKTX forKey:@"EQKTX"];
        [sapInfoDic setObject:devType forKey:@"DEVTYPE"];
        [sapInfoDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapInfoDic setObject:LOCCODE forKey:@"LOCCODE"];
        [sapInfoDic setObject:HEQUI forKey:@"HEQUI"];
        [sapInfoDic setObject:ZPSTATU forKey:@"ZPSTATU"];
        [sapInfoDic setObject:partType forKey:@"PARTTYPE"];
        [sapInfoDic setObject:@"0" forKey:@"SCANTYPE"];
        [sapInfoDic setObject:@"" forKey:@"CHECKORGVALUE"];
        
        BOOL isExist = NO;
        for(NSDictionary* subDic in listDeviceId){
            NSString* subDeviceId = [subDic objectForKey:@"DEVICEID"];
            NSString* subWbsNo = [subDic objectForKey:@"POSID"];
            
            if ([deviceId isEqualToString:subDeviceId] &&
                [wbsno isEqualToString:subWbsNo]){
                
                isExist = YES;
                break;
            }
        }
        if (!isExist){
            NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
            
            [newDic setObject:deviceId forKey:@"DEVICEID"];
            [newDic setObject:wbsno forKey:@"POSID"];
            
            [listDeviceId addObject:newDic];
        }
        if( deviceCount == 0){
            fullTableList = [NSMutableArray array];
            tableList = [NSMutableArray array];
            [_tableView reloadData];
            [self showCount];
            
            
            [self addLocToTableWithLocBarcode:LOCCODE];
        }
        NSDictionary* multiInfoDic;
        if ([oldDeviceId isEqualToString:@""] || ![oldDeviceId isEqualToString:deviceId]){
            subFacList = [NSMutableArray array];
            [self requestMultiInfoWithDeviceId:deviceId];
            
            multiInfoDic = [subFacList objectAtIndex:0];
            UFACBARCODE = LOCCODE;
            NSString* deviceName = [multiInfoDic objectForKey:@"deviceName"];
            NSString* itemCode = [multiInfoDic objectForKey:@"itemCode"];
            NSString* itemName = [multiInfoDic objectForKey:@"itemName"];
            NSString* loccd = [multiInfoDic objectForKey:@"locationCode"];
            NSString* deviceStatusName = [multiInfoDic objectForKey:@"deviceStatusName"];
            NSString* title = [NSString stringWithFormat:@"D:%@:%@:%@:%@:R:%@:%@",
                               deviceId, deviceName, itemCode, itemName, loccd, deviceStatusName ];
            [self addDeviceToTableTitle:title Info:multiInfoDic Parent:UFACBARCODE];
        }
        oldDeviceId = deviceId;
        if ([SHELFID isEqualToString:@""])
            UFACBARCODE = deviceId;
        
        NSInteger level = [self getLevel:UFACBARCODE];
        [sapInfoDic setObject:UFACBARCODE forKey:@"HEQUNR"];
        [sapInfoDic setObject:[NSString stringWithFormat:@"%d", (int)level+1] forKey:@"LEVEL"];
        
        NSString* scanValue = @"0";
        NSString* checkOrganizationValue = @"";
        NSString* title = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@",
                           partTypeName, barcode, ZPSTATU, EQKTX,
                           [WorkUtil getDeviceTypeName:devType],
                           HEQUI, scanValue, checkOrganizationValue,
                           wbsno];
        [self addFacToTableWithTitle:title Info:sapInfoDic isRemake:NO];
        
        deviceCount++;
    }
    if (![[lastDic objectForKey:@"PART_NAME"] isEqualToString:@"L"] &&
        ![[lastDic objectForKey:@"PART_NAME"] isEqualToString:@"D"]){
        txtDeviceID.text = [lastDic objectForKey:@"DEVICEID"];
        strDeviceID = txtDeviceID.text;
        txtFacCode.text = [lastDic objectForKey:@"UNITID"];
        strFccBarCode = txtFacCode.text;
    }
    
    [self reloadTableWithRefresh:YES];
    [self afterSearch];
}

- (void)processSendRescanResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        if ([[dic objectForKey:@"E_RSLT"] isEqualToString:@"S"]){
            NSString* message = @"# 전송건수 : 1건 정상전송 되었습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self initViews];
            [self showCount];
        }
    }
    isOperationFinished = YES;
}


- (void)processSendResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        
        NSString* result = [dic objectForKey:@"E_RSLT"];
        NSString* e_mesg = [dic objectForKey:@"E_MESG"];
        
        
        [workDic setObject:result forKey:@"TRANSACT_YN"];
        if (e_mesg.length)
            [workDic setObject:e_mesg forKey:@"TRANSACT_MSG"];
        [self saveToWorkDB];
        isDataSaved = YES;
        
        
        if ([[dic objectForKey:@"E_RSLT"] isEqualToString:@"S"]){
            NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n\n %@",(int)sendCount,[dic objectForKey:@"E_MESG"]];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            if ([JOB_GUBUN isEqualToString:@"인수"] || [JOB_GUBUN isEqualToString:@"시설등록"]){
                btnSend.enabled = NO;
                btnReScanReq.enabled = NO;
                btnMove.enabled = NO;
                btnModify.enabled = NO;
                btnDel.enabled = NO;
                btnChangeWBS.enabled = NO;
                btnRegDecision.enabled = YES;
            }else{
                [self initViews];
                [self showCount];
            }
        }
    }
    self.isSendFlag = NO;
    isOperationFinished = YES;
    
}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if (pid == REQUEST_LOC_COD || pid == REQUEST_OTD || pid == REQUEST_WBS){
        [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    }else if (pid == REQUEST_MULTI_INFO && !isMultiDevice){
        [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
    }else if (pid == REQUEST_SAP_FCC_COD){
        txtFacCode.text = strFccBarCode = @"";
        lblPartType.text = @"";
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    }else if (pid == TAKEOVER_REQUEST_RESCAN_YN || pid == TAKEOVER_REQUEST_RESCAN || pid == TAKEOVER_REQUEST_SEARCH){
        [self afterSearch];
    }
    
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (pid == REQUEST_SEND && [JOB_GUBUN isEqualToString:@"인계"]){
            if([message rangeOfString:@"권한"].location != NSNotFound){
                message = [NSString stringWithFormat:@"'%@' 조직은\n인계 권한이 없습니다.\nISC(1588-3391)로 문의하시기\n바랍니다.", strUserOrgName];
            }
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }else if (pid == REQUEST_SAP_FCC_COD && [JOB_GUBUN isEqualToString:@"시설등록"]){
            if ([message isEqualToString:@"시설 바코드가 없습니다."]){
                message = @"존재하지 않는 설비바코드입니다.";
            }
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }else
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
    
    isOperationFinished = YES;
}

- (void) processEndSession:(requestOfKind)pid
{
    if (pid == TAKEOVER_REQUEST_RESCAN_YN || pid == TAKEOVER_REQUEST_RESCAN || pid == TAKEOVER_REQUEST_SEARCH){
        [self afterSearch];
    }
    
    if (pid == REQUEST_LOC_COD || pid == REQUEST_OTD || pid == REQUEST_WBS){
        [self performSelectorOnMainThread:@selector(setLocFirstResponder) withObject:nil waitUntilDone:NO];
    }else if (REQUEST_MULTI_INFO && !isMultiDevice){
        [self performSelectorOnMainThread:@selector(setDeviceFirstResponder) withObject:nil waitUntilDone:NO];
    }else if (REQUEST_SAP_FCC_COD){
        txtFacCode.text = strFccBarCode = @"";
        lblPartType.text = @"";
        [self performSelectorOnMainThread:@selector(setFacFirstResponder) withObject:nil waitUntilDone:NO];
    }
    
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
    
    if (!isMultiDevice)
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
        wpSendParamLayer = txtDeviceID.text;
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

@end

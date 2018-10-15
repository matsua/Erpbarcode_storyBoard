//
//  BuyOutIntoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 16..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "objc/runtime.h"
#import "BuyOutIntoViewController.h"
#import "FccInfoViewController.h"
#import "CommonCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"

@interface BuyOutIntoViewController ()
@property(nonatomic,strong) IBOutlet UITextField* txtFacCode;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property(nonatomic,strong) IBOutlet UILabel* lblPartType;
@property(nonatomic,strong) IBOutlet UILabel* lblfccBarcode;
@property(nonatomic,strong) UILabel* lblCount;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;

@property(nonatomic,strong) CustomPickerView* yearPicker;
@property(nonatomic,strong) CustomPickerView* monthPicker;
@property(nonatomic,strong) CustomPickerView* plantPicker;
@property(nonatomic,strong) CustomPickerView* savedLocPicker;

@property(nonatomic,strong) NSString* strFccBarCode;

@property(nonatomic,strong) NSMutableArray* fccSAPList;
@property(nonatomic,strong) NSMutableArray* originalSAPList;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property(nonatomic,assign) NSInteger nSelectedRow;

@property(nonatomic,strong) IBOutlet UIButton* btnYear;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;
@property(nonatomic,strong) IBOutlet UIButton* btnMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblPlant;
@property(nonatomic,strong) IBOutlet UIButton* btnPlant;
@property(nonatomic,strong) IBOutlet UIButton* btnSavedLoc;
@property (strong, nonatomic) IBOutlet UILabel *lblSavedLoc;
@property (strong, nonatomic) IBOutlet UIButton *btnInit;

@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) int sendCount;
@property(nonatomic,assign) int successCount;

@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) NSString* strUserOrgCode;
@property(nonatomic,strong) NSString* strUserOrgName;
@property(nonatomic,strong) NSString* strUserOrgType;
@property(nonatomic,strong) NSString* strBusinessNumber;
@property(nonatomic,strong) NSString* selectedYearPickerData;
@property(nonatomic,strong) NSString* selectedMonthPickerData;
@property(nonatomic,strong) NSString* selectedPlantPickerData;
@property(nonatomic,strong) NSString* selectedSavedLocPickerData;
@property(nonatomic,strong) NSString* selectedDocNoPickerData;

@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property(nonatomic,strong) IBOutlet UIView* fccBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* curdView;
@property(nonatomic,strong) IBOutlet UIView* plantView;
@property(nonatomic,strong) IBOutlet UIView* insepectionView;
@property(nonatomic,strong) IBOutlet UIView* saveLocView;
@property(nonatomic,strong) UILongPressGestureRecognizer* longPressGesture;
@property(nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic,strong) NSArray* plantList;
@property(nonatomic,strong) NSArray* savedLocList;
@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,strong) NSString* sendResult;
@property(nonatomic,assign) BOOL isDataSaved;   // 저장했는지 여부..  초기화 하면 NO 저장하면 YES
@property(nonatomic,assign) BOOL isOffLine;
@end

@implementation BuyOutIntoViewController
@synthesize JOB_GUBUN;
@synthesize _scrollView;
@synthesize txtFacCode;
@synthesize _tableView;
@synthesize indicatorView;
@synthesize lblOrperationInfo;
@synthesize lblPartType;
@synthesize lblCount;
@synthesize btnInit;
@synthesize fccSAPList;
@synthesize strFccBarCode;
@synthesize nSelectedRow;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize fccBarcodeView;
@synthesize longPressGesture;
@synthesize tapGesture;
@synthesize sendCount;
@synthesize successCount;
@synthesize strUserOrgType;
@synthesize strBusinessNumber;
@synthesize curdView;
@synthesize plantView;
@synthesize insepectionView;
@synthesize saveLocView;
@synthesize lblfccBarcode;
@synthesize btnMonth;
@synthesize lblMonth;
@synthesize btnYear;
@synthesize lblYear;
@synthesize yearPicker;
@synthesize monthPicker;
@synthesize plantPicker;
@synthesize savedLocPicker;
@synthesize selectedYearPickerData;
@synthesize selectedMonthPickerData;
@synthesize btnPlant;
@synthesize lblPlant;
@synthesize plantList;
@synthesize btnSavedLoc;
@synthesize lblSavedLoc;
@synthesize savedLocList;
@synthesize selectedPlantPickerData;
@synthesize selectedSavedLocPickerData;
@synthesize selectedDocNoPickerData;
@synthesize originalSAPList;
@synthesize workDic;
@synthesize taskList;
@synthesize sendResult;
@synthesize fetchTaskList;
@synthesize isOperationFinished;
@synthesize dbWorkDic;
@synthesize isDataSaved;
@synthesize isOffLine;

#pragma mark - View LifeCycle
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
    
    // text field에 키입력을 받지 않도록 설정
    [self makeDummyInputViewForTextField];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    strUserOrgType = [dic objectForKey:@"orgTypeCode"];
    strBusinessNumber = [dic objectForKey:@"bussinessNumber"];

    // 화면의 초기 구성을 만듦
    [self layoutSubview];
    
    // 음영지역에서 작업중인지 저장되어 있는 값을 얻어온다.
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];

    //작업관리 초기화
    [self workDataInit];
    
    fccSAPList = [NSMutableArray array];
    originalSAPList = [NSMutableArray array];
    nSelectedRow = -1;
    
    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];

    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    // 작업관리로 들어왔는지 여부에 따라 분기함
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"])
    {
        [self requestPlant];
    }
    else{
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


#pragma mark - DB Method
- (void)processWorkData
{
    if (dbWorkDic.count){
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

#pragma mark - GCD
-(void) waitForGCD
{
    isOperationFinished = NO;

    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        
        if ([task isEqualToString:@"P"]) //plant 요청
        {
            [self requestPlant];
        }
        else if ([task isEqualToString:@"DELETE"]) //셀 삭제
        {
            [self deleteBarcode:value];
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            strFccBarCode = value;
            txtFacCode.text = strFccBarCode;
            
            if (strFccBarCode.length){
                [self processCheckSingleScan];
            }
        }
        else
            isOperationFinished = YES;
        
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
        isOperationFinished = NO;
    }
    
    [self layoutControl];
    
    //작업관리 끝
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    isDataSaved = YES;
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    if (sender == yearPicker)
        [yearPicker hideView];
    else if (sender == monthPicker)
        [monthPicker hideView];
    else if (sender == plantPicker)
        [plantPicker hideView];
    else if (sender == savedLocPicker)
        [savedLocPicker hideView];
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
}

- (void)onDone:(NSString *)data sender:(id)sender {
    if (sender == yearPicker){
        selectedYearPickerData = data;
        lblYear.text = selectedYearPickerData;
        [yearPicker hideView];
    }
    else if (sender == monthPicker){
        selectedMonthPickerData = data;
        lblMonth.text = selectedMonthPickerData;
        [monthPicker hideView];

        [self requestPlant];
    }
    else if (sender == plantPicker){
        selectedPlantPickerData = data;
        lblPlant.text = selectedPlantPickerData;
        [plantPicker hideView];
    }
    else if (sender == savedLocPicker){
        selectedSavedLocPickerData = data;
        lblSavedLoc.text = selectedSavedLocPickerData;
        [savedLocPicker hideView];
    }
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
}

#pragma mark - handle gesture
-(void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
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


-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (fccSAPList.count){
        CGPoint p = [gestureRecognizer locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        if (indexPath){
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
}

#pragma mark - UserDefine method

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
        txtFacCode.inputView = dummyView;
    }
}

// 초기 화면 구성
- (void) layoutSubview
{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];

    //카운트 레이블 구성
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];
        
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    //long press gesture add
    longPressGesture =[[UILongPressGestureRecognizer alloc]
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
    
    lblYear.text = [NSDate YearString];
    selectedYearPickerData = lblYear.text;
    lblMonth.text = [NSDate MonthString];
    selectedMonthPickerData = lblMonth.text;
    
    lblYear.text = [NSDate YearString];
    selectedYearPickerData = lblYear.text;
    lblMonth.text = [NSDate MonthString];
    selectedMonthPickerData = lblMonth.text;

    [txtFacCode becomeFirstResponder];
}

- (void) layoutControl
{
    if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 200){ //200 설비 바코드
        strFccBarCode = barcode;
        
        NSString* message = [Util barcodeMatchVal:2 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            strFccBarCode = txtFacCode.text = @"";
            [txtFacCode becomeFirstResponder];
            return YES;
        }
        
        if (strFccBarCode.length){
            [self processCheckSingleScan];
        }
    }
    
    return YES;
}

// 음영지역 작업인 경우 설비바코드를 스캔했을 때 처리
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
        BOOL isEmptySAPList = YES;
        if (originalSAPList.count)
            isEmptySAPList = NO;
        //데이터 1개
        NSDictionary* dic = [goodsList objectAtIndex:0];
        NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
        NSString* compType;
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            compType = @"";
        else
            compType = [dic objectForKey:@"COMPTYPE"];
        NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
        
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        if (barcodeName== nil)
            barcodeName = @"";
        else
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        [sapDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
        [sapDic setObject:@"" forKey:@"ZPSTATU"];
        [sapDic setObject:barcodeName forKey:@"MAKTX"];
        [sapDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"ZMATGB"];
        [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
        [sapDic setObject:@"" forKey:@"ZPPART"];
        [sapDic setObject:@"" forKey:@"ZKOSTL"];
        [sapDic setObject:@"" forKey:@"ZKTEXT"];
        
        [sapDic setObject:@"Y__" forKey:@"ORG_CHECK"];
        // 새롭게 정의한 값
        [sapDic setObject:@"S" forKey:@"RSLT"];
        [sapDic setObject:@"" forKey:@"MESG"];
        
        [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:NO isCheckUU:NO isRemake:YES fccList:originalSAPList job:JOB_GUBUN];
        lblPartType.text = [sapDic objectForKey:@"PART_NAME"];
        
        // 최초 스캔 시
        if (isEmptySAPList){
            if (![barcode isEqualToString:strFccBarCode])
                [sapDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
            else
                [sapDic setObject:@"3" forKey:@"SCANTYPE"]; //상위 설비
        }else{
            if ([JOB_GUBUN isEqualToString:@"납품취소"])
                [sapDic setObject:@"1" forKey:@"SCANTYPE"];
            else if ([[dic objectForKey:@"EQUNR"] isEqualToString:strFccBarCode]){
                NSString* upperBarcode = [sapDic objectForKey:@"HEQUNR"]; // 화면 상의 리스트에 상위바코드
                if (upperBarcode.length)    // 상위바코드가 있으면 해당 상위바코드에 추가 - "2"
                    [sapDic setObject:@"2" forKey:@"SCANTYPE"];
                else
                    [sapDic setObject:@"3" forKey:@"SCANTYPE"];
            }else
                [sapDic setObject:@"0" forKey:@"SCANTYPE"];
        }

        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
        
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    [self reloadTableWithRefesh:YES];
    [self scrollToIndex:nSelectedRow];
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];

    isOperationFinished = YES;
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

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (_tableView.contentSize.height > _tableView.bounds.size.height) {
        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
    }
    [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}


- (void) showCount
{
    int totalCount = 0;
    NSString* formatString = nil;
    
    totalCount = (int)[originalSAPList count];
    formatString = [NSString stringWithFormat:@"%d건", totalCount];
    lblCount.text = formatString;
}

- (BOOL) processCheckSendData
{
    NSString* message = nil;
    
    if (!fccBarcodeView.hidden && !originalSAPList.count){
        message = @"전송할 설비바코드가\n존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return NO;
    }
    
    if (!plantView.hidden && !selectedPlantPickerData.length){
        message = @"플랜트를 선택하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];

        return NO;
    }
    if (!saveLocView.hidden && !selectedSavedLocPickerData.length){
        message = @"저장위치를 선택하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];

        return NO;
    }
    
    return YES;
}

- (BOOL) processCheckSingleScan
{
    NSString* message = nil;
    
    if (originalSAPList.count){
        int index = [WorkUtil getBarcodeIndex:strFccBarCode fccList:originalSAPList];
        
        if (index != -1){ //바코드 존재 해당 배열에서 교체
            message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",strFccBarCode];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            isOperationFinished = YES;
            return NO;
        }
    }
    
    //데이터 변경
    [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
    isDataSaved = NO;
    
    NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
    [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
    [sapDic setObject:@"" forKey:@"HEQUNR"];

    [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:NO isCheckUU:NO isRemake:YES fccList:originalSAPList job:JOB_GUBUN];
    [self reloadTableWithRefesh:YES];
    [self scrollToIndex:nSelectedRow];

    //작업관리 추가
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"F" forKey:@"TASK"];
    [taskDic setObject:strFccBarCode forKey:@"VALUE"];
    [taskList addObject:taskDic];
    //데이터 변경
    [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
    isDataSaved = NO;

    isOperationFinished = YES;
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    return YES;
}

- (void) reloadTableWithRefesh:(BOOL)isRefresh
{
    fccSAPList = [NSMutableArray array];
    for (NSDictionary* dic in originalSAPList){
        [fccSAPList addObject:dic];
    }
    
    if (isRefresh){
        [_tableView reloadData];
        [self showCount];
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

- (void) deleteBarcode:(NSString*)barcode
{
    NSInteger index = [WorkUtil getBarcodeIndex:barcode fccList:originalSAPList];
    if (index != -1){
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"DELETE" forKey:@"TASK"];
        [taskDic setObject:barcode forKey:@"VALUE"];
        [taskList addObject:taskDic];
        
        [WorkUtil deleteBarcodeIndex:index fccList:originalSAPList];
        
        if (originalSAPList.count)
            nSelectedRow = fccSAPList.count - 1;
        else
            nSelectedRow = 0;
        
        [self reloadTableWithRefesh:NO];
        
        if (originalSAPList.count && nSelectedRow > originalSAPList.count-1) {
            nSelectedRow = fccSAPList.count - 1;
        }
        [_tableView reloadData];
        [self showCount];
        
        //데이터 변경
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
}

#pragma mark - UserDefine Action
- (IBAction) touchShowPlantPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    else if (yearPicker.isShow)
        [yearPicker hideView];
    else if (monthPicker.isShow)
        [monthPicker hideView];
    
    [plantPicker showView];
}

- (IBAction) touchShowYearPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    else if (plantPicker.isShow)
        [plantPicker hideView];
    else if (monthPicker.isShow)
        [monthPicker hideView];
    
    [yearPicker showView];
}

- (IBAction) touchShowMonthPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    if (yearPicker.isShow)
        [yearPicker hideView];
    else if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    else if (plantPicker.isShow)
        [plantPicker hideView];
    
    [monthPicker showView];
}

- (IBAction) touchShowSavedLocPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    if (plantPicker.isShow)
        [plantPicker hideView];
    else if (yearPicker.isShow)
        [yearPicker hideView];
    else if (monthPicker.isShow)
        [monthPicker hideView];
    [savedLocPicker showView];
}

- (IBAction) touchSaveBtn:(id)sender
{
    if ([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isDataSaved = YES;
    }        
}

- (IBAction) touchDeleteBtn:(id)sender
{
    NSString* message = nil;    
    if (fccSAPList.count){
        if (fccSAPList.count -1 >= nSelectedRow){
            NSString* message;
            
            message = @"삭제하시겠습니까?";
            [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
        }
    }
    else {
        message = @"선택된 항목이 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

- (IBAction) touchInitBtn
{
    //textfield 초기화
    txtFacCode.text = strFccBarCode = @"";
    lblPartType.text = @"";
    
    if (!fccBarcodeView.hidden){
        if (![txtFacCode isFirstResponder])
            [txtFacCode becomeFirstResponder];
    }
    
    //table초기화
    fccSAPList = [NSMutableArray array];
    originalSAPList = [NSMutableArray array];
    nSelectedRow = -1;
    [_tableView reloadData];
    [self showCount];
    
    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //작업관리 초기화
    dbWorkDic = [NSMutableDictionary dictionary];
    [self workDataInit];
}


- (void) touchBackBtn:(id)sender
{
    if (!isDataSaved && [Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }else{
        [txtFacCode resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction) touchSendBtn:(id)sender
{
    if (isOffLine){
        NSString* message = MESSAGE_CANT_SEND_OFFLINE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    
    if (![Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = NOT_CHANGE_SEND_MESSAGE;

        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        return;
    }

    if ([self processCheckSendData]){
        BOOL errorFlag = NO;
        if (originalSAPList.count){
            for(NSDictionary* dic in originalSAPList){
                NSString* scanType = [dic objectForKey:@"SCANTYPE"];
                if ([scanType isEqualToString:@"0"]){
                    errorFlag = YES;
                    break;
                }
            }
        }
        if (errorFlag){
            NSString* message = @"스캔하지 않은 하위 설비가\n존재합니다.\n스캔하지 않은 하위 설비는 '분실위험'\n처리됩니다.\n그래도 전송하시겠습니까?";
            [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
            return;
        }

        NSString* message = @"전송하시겠습니까?";
        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
    }
}

- (IBAction)touchBackground:(id)sender
{
    if (yearPicker.isShow)
        [yearPicker hideView];
    if (monthPicker.isShow)
        [monthPicker hideView];
    if (plantPicker.isShow)
        [plantPicker hideView];
    if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    
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
    else if (alertView.tag == 600){ //삭제
        if (buttonIndex == 0){ //삭제
            NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
            NSString* barcode = [dic objectForKey:@"EQUNR"];
            [self deleteBarcode:barcode];
        }
    }else if (alertView.tag == 1100){   // back btn클릭시 수정한 정보가 있습니다.
        if (buttonIndex == 0){
            [txtFacCode resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2000){   // 세션이 종료되었습니다.
        if (buttonIndex == 0){
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }

    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
}


#pragma mark - Http Request Method
// 내부사용자 논리창고 자동 셋팅
- (void)requestPlant
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GET_PLANT;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSDictionary* plantDic = nil;
    if (plantList.count){
        plantDic = [plantList objectAtIndex:plantPicker.selectedIndex];
    }
    
    [requestMgr requestPlantForUserOrg:strUserOrgCode];
}

- (void)requestSaveLocation
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAVE_LOCATION;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSDictionary* plantDic = nil;
    if (plantList.count){
        plantDic = [plantList objectAtIndex:plantPicker.selectedIndex];
    }
    
    [requestMgr requestSaveLocation:plantDic];
}

- (void) requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;

    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    //Param 조립
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:selectedYearPickerData forKey:@"GJAHR"]; // 회계연도
    [paramDic setObject:selectedMonthPickerData forKey:@"ZZPI_IND"]; //월
    
    if (plantList.count){
        NSDictionary* plantDic = [plantList objectAtIndex:plantPicker.selectedIndex];
        //plant
        [paramDic setObject:[plantDic objectForKey:@"PLANT"] forKey:@"WERKS"];
    }
    else
        [paramDic setObject:@"" forKey:@"WERKS"];
    
    //subParam 조립
    sendCount = 0;
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in originalSAPList)
    {
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        
        [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"];
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SEND_INVENTORY_SURVEY withData:rootDic];
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
            if ([message hasPrefix:@"시설 바코드가 없습니다."]){
                message = @"존재하지 않는 설비바코드입니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            }else if (![JOB_GUBUN isEqualToString:@"송부취소(팀간)"] && ![JOB_GUBUN isEqualToString:@"접수(팀간)"]){
                // 송부취소(팀간), 접수(팀간) 은 "검색 조건에 맞는 데이타가 없습니다." 로 서버에서 던져줌
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            }
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
        
        isOperationFinished = YES;
        return;
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
        
        isOperationFinished = YES;
        return;
    }
    
    if (pid == REQUEST_GET_PLANT){
        [self processGetPlantResponse:resultList];
    }else if (pid == REQUEST_SAVE_LOCATION){
        [self processSaveLocationResponse:resultList];
    }else if (pid == REQUEST_SEND){
        [self processSendResponse:resultList];
    }else
        isOperationFinished = YES;
}

- (void)processGetPlantResponse:(NSArray*)resultList
{
    if ([resultList count]){
        plantList = resultList;
        NSMutableArray* pickerList = [NSMutableArray array];
        for (NSDictionary* dic in plantList)
        {
            NSString* strAddData = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"PLANT"],[dic objectForKey:@"PLANT_TXT"]];
            [pickerList addObject:strAddData];
        }
        NSString* strPlant = [pickerList objectAtIndex:0];
        lblPlant.text = strPlant;
        plantPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:pickerList];
        plantPicker.delegate = self;
        [plantPicker selectPicker:0];
        [self requestSaveLocation];
        
        //task추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"P" forKey:@"TASK"];
        [taskDic setObject:strUserOrgCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* message = @"플랜트가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    isOperationFinished = YES;
}

- (void)processSaveLocationResponse:(NSArray*)resultList
{
    if ([resultList count]){
        //LGORT:LGOBE 콤보박스에 추가
        savedLocList = resultList;
        NSMutableArray* pickerList = [NSMutableArray array];
        
        for (NSDictionary* dic in savedLocList)
        {
            NSString* strAddData = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"LGORT"],[dic objectForKey:@"LGOBE"]];
            [pickerList addObject:strAddData];
        }
        
        NSString* strSavedLoc = [pickerList objectAtIndex:0];
        lblSavedLoc.text = strSavedLoc;
        savedLocPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:pickerList];
        savedLocPicker.delegate = self;
        [savedLocPicker selectPicker:0];
    }
    else {
        NSString* message = @"저장위치가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void)processSendResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSString* result = [dic objectForKey:@"E_RSLT"];
        NSString* result_msg = [dic objectForKey:@"E_MESG"];
        
        [workDic setObject:result forKey:@"TRANSACT_YN"];
        if (result_msg.length)
            [workDic setObject:result_msg forKey:@"TRANSACT_MSG"];
        [self saveToWorkDB];
        isDataSaved = YES;
        
        if ([result isEqualToString:@"S"]){
            NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n1-%@",sendCount,result_msg];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self touchInitBtn];
        }
    }
}

#pragma mark - UITextFieldDelegate
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
    
    NSString* formatString = @"";
    NSString* barcode = @"";
    NSString* scanType = @"";
    NSString* result = @"";
    
    barcode = [dic objectForKey:@"EQUNR"];
    formatString = barcode;
    
    if ([[dic objectForKey:@"LEVEL"] length])
        cell.indentationLevel = [[dic objectForKey:@"LEVEL"] integerValue];
    else
        cell.indentationLevel = 1;
    [cell setIndentationWidth:10.0f];
    
    CGFloat textLength = [formatString sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
    
    cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength+cell.indentationLevel*cell.indentationWidth, cell.lblTreeData.frame.size.height);
    cell.lblTreeData.text = formatString;
    cell.scrollView.contentSize = CGSizeMake(textLength+cell.indentationLevel*cell.indentationWidth + 30, COMMON_CELL_HEIGHT);
    
    cell.nScanType = [scanType integerValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (nSelectedRow == indexPath.row){
        cell.lblTreeData.textColor = [UIColor blueColor];
        lblPartType.text = [dic objectForKey:@"PART_NAME"];
    }else
        cell.lblTreeData.textColor = [UIColor blackColor];
    
    if (
        [scanType isEqualToString:@"1"] ||
        [scanType isEqualToString:@"2"] ||
        [scanType isEqualToString:@"3"]
        )
       cell.lblBackground.backgroundColor = COLOR_SCAN1;
    
    if ([result isEqualToString:@"F"] || [result isEqualToString:@"E"])
       cell.lblBackground.backgroundColor = RGB(255,182,193); //pinkcolor
    
    else if ([result isEqualToString:@"S"])
       cell.lblBackground.backgroundColor = COLOR_SCAN1;
    
    cell.hasSubNode = YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCell* cell =(CommonCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
    cell.lblTreeData.textColor = [UIColor blackColor];
    if (fccSAPList.count){
        NSDictionary* selItemDic = [fccSAPList objectAtIndex:indexPath.row];
        if (strFccBarCode.length)
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
        else
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
        
        lblPartType.text = [selItemDic objectForKey:@"PART_NAME"];
    }

    nSelectedRow = indexPath.row;

    cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blueColor];
}


@end

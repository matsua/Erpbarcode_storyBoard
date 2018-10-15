//
//  RevisionViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 22..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "RevisionViewController.h"
#import "FccInfoViewController.h"
#import "CommonCell.h"
#import "GridColumn2Cell.h"
#import "GridColumn3Cell.h"
#import "GridColumn9Cell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"
#import <objc/runtime.h>

#import "AddInfoViewController.h"


@interface RevisionViewController ()
{
    const char* key;
}
@property(nonatomic,strong) UILabel* lblCount;
@property(nonatomic,strong) NSString* strUserOrgCode;
@property(nonatomic,strong) NSString* strUserOrgName;
@property(nonatomic,strong) NSString* strUserOrgType;
@property(nonatomic,strong) NSString* strBusinessNumber;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) NSString* strLocBarCode;
@property(nonatomic,strong) NSString* strFccBarCode;
@property(nonatomic,strong) NSString* strDecryptFccBarCode;
@property(nonatomic,strong) NSString* strDecryptLocBarCode;
@property(nonatomic,strong) NSString* strDeviceID;
@property(nonatomic,strong) NSString* UPGDOC; // 개조개량지시서번호
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,assign) NSInteger sendCount;
@property(nonatomic,strong) NSString* strLocFullName;
@property(nonatomic,assign) BOOL isOrgChanged;
@property(nonatomic,assign) BOOL isScanMode;
@property(nonatomic,assign) BOOL isOrgInheritance;
@property(nonatomic,strong) IBOutlet UIScrollView* _scrollView;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property(nonatomic,strong) IBOutlet UILabel* lblPicker;
@property(nonatomic,strong) IBOutlet UILabel* lblPartType;
@property(nonatomic,strong) IBOutlet UILabel* lblDeviceID;
@property(nonatomic,strong) IBOutlet UILabel* lblfccBarcode;
@property(nonatomic,strong) UILongPressGestureRecognizer* longPressGesture;
@property(nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property(nonatomic,strong) IBOutlet UITableView* _tableScan;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UITableView* _tableView2;
@property(nonatomic,strong) IBOutlet UITableView* _tableView3;
@property(nonatomic,strong) IBOutlet UITableView* _tableView4;
@property(nonatomic,strong) IBOutlet UITableView* _tableView5;
@property(nonatomic,strong) IBOutlet UITableView* _tableView6;
@property(nonatomic,strong) IBOutlet UITableView* _tableView7;
@property(nonatomic,strong) IBOutlet UITableView* _tableView8;
@property(nonatomic,strong) IBOutlet UITableView* _tableView9;
@property(nonatomic,strong) IBOutlet UITableView* _tableView10;
@property(nonatomic,strong) IBOutlet UITableView* _tableView11;
@property(nonatomic,strong) IBOutlet UITableView* _tableView12;
@property(nonatomic,strong) IBOutlet UITableView* _tableView13;
@property(nonatomic,strong) IBOutlet UITableView* _tableView14;
@property(nonatomic,strong) IBOutlet UITableView* _tableView15;
@property(nonatomic,strong) IBOutlet UIView* locBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* locNameView;
@property(nonatomic,strong) IBOutlet UIView* fccBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* fccStatusView;
@property(nonatomic,strong) IBOutlet UIView* curdView;
@property(nonatomic,strong) IBOutlet UIView* plantView;
@property(nonatomic,strong) IBOutlet UIView* docNoView;
@property(nonatomic,strong) IBOutlet UIView* savedLocView;
@property(nonatomic,strong) IBOutlet UIView* insepectionView;
@property(nonatomic,strong) IBOutlet UIView* materialView;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView2;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView3;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView3_1;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView4;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView5;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView6;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView7;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView8;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView9;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView10;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView11;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView12;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView13;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView14;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView15;


@property(nonatomic,strong) IBOutlet UIButton* btnInit;
@property(nonatomic,strong) IBOutlet UIButton* btnPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblFccStatus;
@property(nonatomic,strong) IBOutlet UIButton* btnSearch;
@property(nonatomic,strong) IBOutlet UIButton* btnSave;
@property(nonatomic,strong) IBOutlet UIButton* btnDelete;
@property(nonatomic,strong) IBOutlet UIButton* btnSend;
@property(nonatomic,strong) IBOutlet UIButton* btnYear;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;
@property(nonatomic,strong) IBOutlet UIButton* btnMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property(nonatomic,strong) IBOutlet UIButton* btnPlant;
@property (strong, nonatomic) IBOutlet UILabel *lblPlant;
@property(nonatomic,strong) IBOutlet UIButton* btnDocNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDocNo;
@property(nonatomic,strong) IBOutlet UIButton* btnSavedLoc;
@property (strong, nonatomic) IBOutlet UILabel *lblSavedLoc;

@property(nonatomic,strong) IBOutlet UIButton* btnClose;
@property(nonatomic,strong) IBOutlet UILabel* lblMaterial;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader11;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader12;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader13;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader21;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader22;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader23;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader31;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader32;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader33;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader311;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader312;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader313;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader41;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader42;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader43;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader51;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader52;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader53;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader61;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader62;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader63;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader71;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader72;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader73;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader81;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader82;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader83;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader91;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader92;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader93;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader101;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader102;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader103;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader111;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader112;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader113;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader121;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader122;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader123;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader131;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader132;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader133;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader141;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader142;

@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader151;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader152;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader153;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader154;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader155;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader156;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader157;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader158;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader159;


@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,strong) NSMutableArray* selectedItemList;

@property(nonatomic,strong) IBOutlet UITextField* txtLocCode;
@property(nonatomic,strong) IBOutlet UITextField* txtFacCode;
@property(nonatomic,strong) IBOutlet UITextField* txtDeviceID;
@property(nonatomic,strong) IBOutlet NSArray* plantList;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) CustomPickerView* picker;
@property(nonatomic,strong) CustomPickerView* savedLocPicker;
@property(nonatomic,strong) CustomPickerView* yearPicker;
@property(nonatomic,strong) CustomPickerView* monthPicker;
@property(nonatomic,strong) CustomPickerView* plantPicker;
@property(nonatomic,strong) CustomPickerView* docPicker;
@property(nonatomic,strong) NSString* selectedPickerData;
@property(nonatomic,strong) NSString* selectedYearPickerData;
@property(nonatomic,strong) NSString* selPickerData;
@property(nonatomic,strong) NSString* selectedMonthPickerData;
@property(nonatomic,strong) NSString* selectedPlantPickerData;
@property(nonatomic,strong) NSString* selectedSavedLocPickerData;
@property(nonatomic,strong) NSString* selectedDocNoPickerData;
@property(nonatomic,strong) NSMutableArray* fccSAPList;
@property(nonatomic,strong) NSMutableArray* scanSAPList;
@property(nonatomic,strong) NSMutableArray* remodelList;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcodeName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcodeName;
@property(nonatomic,strong) NSDictionary* IM_dic; //인스토어 마킹
@property(nonatomic,strong) NSArray* savedLocList;
@property(nonatomic,strong) NSArray* docNoList;
@property(nonatomic,strong) NSMutableArray* surveySearchList;
@property(nonatomic,strong) IBOutlet UIImageView* imgCheck;
@property(nonatomic,assign) BOOL isDataSaved;   // 저장했는지 여부..  초기화 하면 NO 저장하면 YES
@property(nonatomic,assign) BOOL isOffLine;     // 음영지역인지 여부

@property(nonatomic,assign) IBOutlet IBOutlet UIView* snNumberView;
@property(nonatomic,strong) IBOutlet UITextField* txtSnCode;
@property(nonatomic,assign) IBOutlet IBOutlet UIView* organInfoView;
@property(nonatomic,assign) NSInteger rowSelIdx;     //row select idx
@property(nonatomic,strong) IBOutlet UIButton* btnSelectAll;
@end

@implementation RevisionViewController
@synthesize lblCount;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize strUserOrgType;
@synthesize strLocBarCode;
@synthesize strFccBarCode;
@synthesize strBusinessNumber;
@synthesize lblOrperationInfo;
@synthesize longPressGesture;
@synthesize tapGesture;
@synthesize _tableScan;
@synthesize _tableView;
@synthesize _tableView2;
@synthesize _tableView3;
@synthesize _tableView4;
@synthesize _tableView5;
@synthesize _tableView6;
@synthesize _tableView7;
@synthesize _tableView8;
@synthesize _tableView9;
@synthesize _tableView10;
@synthesize _tableView11;
@synthesize _tableView12;
@synthesize _tableView13;
@synthesize _tableView14;
@synthesize _tableView15;
@synthesize JOB_GUBUN;
@synthesize locBarcodeView;
@synthesize locNameView;
@synthesize fccBarcodeView;
@synthesize insepectionView;
@synthesize curdView;
@synthesize btnPicker;
@synthesize savedLocPicker;
@synthesize selPickerData;
@synthesize txtLocCode;
@synthesize txtFacCode;
@synthesize lblPicker;
@synthesize fccSAPList;
@synthesize picker;
@synthesize scrollLocBarcodeName;
@synthesize lblLocBarcodeName;
@synthesize fccStatusView;
@synthesize strDecryptFccBarCode;
@synthesize strDecryptLocBarCode;
@synthesize indicatorView;
@synthesize nSelectedRow;
@synthesize lblPartType;
@synthesize isOrgChanged;
@synthesize sendCount;
@synthesize txtDeviceID;
@synthesize strDeviceID;
@synthesize strLocFullName;
@synthesize lblDeviceID;
@synthesize surveySearchList;
@synthesize _scrollView;
@synthesize columnHeaderView;
@synthesize columnHeaderView2;
@synthesize columnHeaderView3;
@synthesize columnHeaderView3_1;
@synthesize columnHeaderView4;
@synthesize columnHeaderView5;
@synthesize columnHeaderView6;
@synthesize columnHeaderView7;
@synthesize columnHeaderView8;
@synthesize columnHeaderView9;
@synthesize columnHeaderView10;
@synthesize columnHeaderView11;
@synthesize columnHeaderView12;
@synthesize columnHeaderView13;
@synthesize columnHeaderView14;
@synthesize columnHeaderView15;

@synthesize remodelList;
@synthesize UPGDOC;
@synthesize isOrgInheritance;
@synthesize lblColumnHeader11;
@synthesize lblColumnHeader12;
@synthesize lblColumnHeader13;
@synthesize lblColumnHeader21;
@synthesize lblColumnHeader22;
@synthesize lblColumnHeader23;
@synthesize lblColumnHeader31;
@synthesize lblColumnHeader32;
@synthesize lblColumnHeader33;
@synthesize lblColumnHeader311;
@synthesize lblColumnHeader312;
@synthesize lblColumnHeader313;
@synthesize lblColumnHeader41;
@synthesize lblColumnHeader42;
@synthesize lblColumnHeader43;
@synthesize lblColumnHeader51;
@synthesize lblColumnHeader52;
@synthesize lblColumnHeader53;
@synthesize lblColumnHeader61;
@synthesize lblColumnHeader62;
@synthesize lblColumnHeader63;
@synthesize lblColumnHeader71;
@synthesize lblColumnHeader72;
@synthesize lblColumnHeader73;
@synthesize lblColumnHeader81;
@synthesize lblColumnHeader82;
@synthesize lblColumnHeader83;
@synthesize lblColumnHeader91;
@synthesize lblColumnHeader92;
@synthesize lblColumnHeader93;
@synthesize lblColumnHeader101;
@synthesize lblColumnHeader102;
@synthesize lblColumnHeader103;
@synthesize lblColumnHeader111;
@synthesize lblColumnHeader112;
@synthesize lblColumnHeader113;
@synthesize lblColumnHeader121;
@synthesize lblColumnHeader122;
@synthesize lblColumnHeader123;
@synthesize lblColumnHeader131;
@synthesize lblColumnHeader132;
@synthesize lblColumnHeader133;
@synthesize lblColumnHeader141;
@synthesize lblColumnHeader142;

@synthesize lblColumnHeader151;
@synthesize lblColumnHeader152;
@synthesize lblColumnHeader153;
@synthesize lblColumnHeader154;
@synthesize lblColumnHeader155;
@synthesize lblColumnHeader156;
@synthesize lblColumnHeader157;
@synthesize lblColumnHeader158;
@synthesize lblColumnHeader159;

@synthesize btnSearch;
@synthesize btnSave;
@synthesize btnDelete;
@synthesize btnSend;
@synthesize btnInit;
@synthesize lblFccStatus;
@synthesize btnMonth;
@synthesize btnYear;
@synthesize btnPlant;
@synthesize btnSavedLoc;
@synthesize btnDocNo;
@synthesize lblYear;
@synthesize lblMonth;
@synthesize lblPlant;
@synthesize lblSavedLoc;
@synthesize lblDocNo;
@synthesize btnClose;
@synthesize plantView;
@synthesize savedLocView;
@synthesize docNoView;
@synthesize IM_dic;
@synthesize plantList;
@synthesize savedLocList;
@synthesize docNoList;
@synthesize yearPicker;
@synthesize monthPicker;
@synthesize plantPicker;
@synthesize docPicker;
@synthesize selectedPickerData;
@synthesize selectedYearPickerData;
@synthesize selectedMonthPickerData;
@synthesize selectedPlantPickerData;
@synthesize selectedSavedLocPickerData;
@synthesize selectedDocNoPickerData;
@synthesize lblfccBarcode;
@synthesize isScanMode;
@synthesize materialView;
@synthesize lblMaterial;
@synthesize scanSAPList;

@synthesize workDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize dbWorkDic;
@synthesize isOperationFinished;
@synthesize selectedItemList;
@synthesize imgCheck;
@synthesize isDataSaved;
@synthesize isOffLine;

@synthesize snNumberView;
@synthesize organInfoView;
@synthesize txtSnCode;
@synthesize rowSelIdx;
@synthesize btnSelectAll;

#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [self makeDummyInputViewForTextField];
    
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];
    
    fccSAPList = [NSMutableArray array];
    scanSAPList = [NSMutableArray array];
    
    [self layoutSubviews];
    
    //작업관리 초기화
    isDataSaved = NO;
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    //데이터 변경안함
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //수리완료 피커 처리
    if (picker){
        [workDic setObject:[NSString stringWithFormat:@"%d",picker.selectedIndex] forKey:@"PICKER_ROW"];
    }
    
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];
    
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"])
    {
        if ([JOB_GUBUN isEqualToString:@"상품단말실사"])
            [self requestPlant];
    }
    else{ //작업모드 일때
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
    [self showCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //수리완료 피커
    NSString* pickerRow = [dbWorkDic objectForKey:@"PICKER_ROW"];
    if (picker){
        if (pickerRow.length)
            [picker selectPicker:[pickerRow intValue]];
    }
    
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
    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        isOperationFinished = NO;
        
        if ([task isEqualToString:@"DELETE"]) //셀 삭제
        {
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"DELETE" forKey:@"TASK"];
            [taskList addObject:taskDic];
            if (isScanMode){
                if (scanSAPList.count){
                    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:scanSAPList];
                    if (indexset.count){
                        [scanSAPList removeObjectsAtIndexes:indexset];
                        [_tableScan reloadData];
                        [self showCount];
                    }
                }
            }
            else {
                if (fccSAPList.count){
                    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:fccSAPList];
                    if (indexset.count){
                        [fccSAPList removeObjectsAtIndexes:indexset];
                        [self reloadTables];
                        [self showCount];
                    }
                }
            }
            
            //데이터 변경
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
            
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"P"]) //plant 요청
        {
            [self requestPlant];
        }
        else if ([task isEqualToString:@"L"]) //위치
        {
            strLocBarCode = txtLocCode.text = value;
            if (isOffLine)
                [self setOfflineLocCd:value];
            else
                [self requestLocCode:value];
        }
        else if ([task isEqualToString:@"R"]) //리모델
        {
            strLocBarCode = value;
            [self requestRemodelData];
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            strFccBarCode = value;
            txtFacCode.text = strFccBarCode;
            
            if (strFccBarCode.length){
                if ([JOB_GUBUN isEqualToString:@"상품단말실사"])
                    [self processCheckSingleScan];
                else
                    [self processCheckScan:strFccBarCode];
            }
        }
        else if ([task isEqualToString:@"SELECT_CHECK"]){   // check button 클릭
            GridColumn2Cell* cell = (GridColumn2Cell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[value integerValue] inSection:0]];
            UIButton *btn = cell.btnCheck;
            btn.selected = !btn.selected;
            
            if (isScanMode){
                if (scanSAPList.count) {
                    NSMutableDictionary* selectItem = [scanSAPList objectAtIndex:btn.tag];
                    [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
                    [_tableScan reloadData];
                }
            }
            else {
                if (fccSAPList.count) {
                    NSMutableDictionary* selectItem = [fccSAPList objectAtIndex:btn.tag];
                    [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
                    [_tableView reloadData];
                }
            }
            
            [_tableView reloadData];
            //작업관리에 추가
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"SELECT_CHECK" forKey:@"TASK"];
            [taskDic setObject:[NSString stringWithFormat:@"%d", (int)btn.tag] forKey:@"VALUE"];
            [taskList addObject:taskDic];
            
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"SN_CHANGE"]){
            for (int i=0; i < [fccSAPList count]; i++) {
                if([[[fccSAPList objectAtIndex:i] objectForKey:@"EQUNR"] isEqualToString:[dic objectForKey:@"IDX_BARCODE"]]){
                    [[fccSAPList objectAtIndex:i] setObject:value forKey:@"SERGE"];
                }
            }
            
            [self reloadTables];
            isOperationFinished = YES;
        }
        
        else{
            isOperationFinished = YES;
        }
        
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
    }
    
    [self layoutControl];
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
    else if (sender == docPicker)
        [docPicker hideView];
    else if (sender == picker)
        [picker hideView];
    [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
    
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
    else if (sender == docPicker){
        selectedDocNoPickerData = data;
        lblDocNo.text = selectedDocNoPickerData;
        [docPicker hideView];
    }
    else if (sender == picker){ //수리완료 피커
        selPickerData = data;
        lblFccStatus.text = selPickerData;
        [picker hideView];
        
        //데이터 변경
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    
    //작업데이터 저장
    if (picker)
        [workDic setObject:[NSString stringWithFormat:@"%d",picker.selectedIndex] forKey:@"PICKER_ROW"];
    
    [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
}

#pragma mark - UserDefine method

- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtLocCode.inputView = dummyView;
        txtDeviceID.inputView = dummyView;
        txtFacCode.inputView = dummyView;
        txtSnCode.inputView = dummyView;
    }
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    NSString* message = nil;
    
    if (tag == 100){ //위치바코드
        strDecryptLocBarCode = barcode;
        strLocBarCode = strDecryptLocBarCode;
        
//        if(strLocBarCode.length != 11 && strLocBarCode.length != 14 && strLocBarCode.length != 17 && strLocBarCode.length != 21){
//            message = @"처리할 수 없는 위치바코드입니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            return YES;
//        }
//        
//        if (
//            [JOB_GUBUN isEqualToString:@"수리완료"]       ||
//            [JOB_GUBUN isEqualToString:@"개조개량완료"]    ||
//            [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"] ||
//            [JOB_GUBUN isEqualToString:@"고장등록취소"]    ||
//            [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
//            ){
//            if (strLocBarCode.length > 17 &&
//                ![strLocBarCode hasPrefix:@"VS"] &&
//                ![[strLocBarCode substringFromIndex:17] isEqualToString:@"0000"]
//                ){
//                
//                message = [NSString stringWithFormat:@"'베이' 위치로는 '%@'\n작업을 하실 수 없습니다.",JOB_GUBUN];
//                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//                
//                strDecryptLocBarCode = @"";
//                return NO;
//            }
//        }
        
        message = [Util barcodeMatchVal:1 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDecryptLocBarCode = strLocBarCode = txtLocCode.text = @"";
            [txtLocCode becomeFirstResponder];
            return YES;
        }
        
        if (strLocBarCode.length){
            if (isOffLine)
                [self setOfflineLocCd:strLocBarCode];
            else
                [self requestLocCode:strLocBarCode];
        }
    }
    else if (tag == 200){ //200 설비 바코드
        strDecryptFccBarCode = barcode;
        
        strFccBarCode = strDecryptFccBarCode;
        
        //먼저 위치 바코드 체크
        if (!locBarcodeView.hidden && !lblLocBarcodeName.text.length){
            
            [self performSelectorOnMainThread:@selector(locBecameFirstResponder) withObject:nil waitUntilDone:NO];
            message = @"먼저 위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strFccBarCode = strDecryptFccBarCode = txtFacCode.text = @"";
            lblPartType.text = @"";
            
            return NO;
        }
        
        if (![JOB_GUBUN isEqualToString:@"상품단말실사"]){
//            if (strFccBarCode.length < 16 || strFccBarCode.length > 18)
//            {
//                [self showMessage: @"처리할 수 없는 설비바코드입니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
//                return NO;
//            }
            
            message = [Util barcodeMatchVal:2 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                strDecryptFccBarCode = strFccBarCode = txtFacCode.text = @"";
                [txtFacCode becomeFirstResponder];
                return YES;
            }
        }
        
        if (!isOffLine && [JOB_GUBUN isEqualToString:@"개조개량완료"]){
            BOOL errorFlag = YES;
            for (NSDictionary* dic in remodelList)
            {
                NSString* barcode = [dic objectForKey:@"EQUNR"];
                NSString* upgradeBarcode = [dic objectForKey:@"UPGEQUNR"];
                if (!upgradeBarcode.length){
                    if ([strFccBarCode isEqualToString:barcode]){
                        errorFlag = NO;
                        break;
                    }
                }
                else {
                    if ([strFccBarCode isEqualToString:upgradeBarcode]){
                        errorFlag = NO;
                        break;
                    }
                }
            }
            if (errorFlag){
                message = @"'개조개량완료' 대상 설비바코드가 아닙니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                return NO;
            }
        }
        if (strFccBarCode.length){
            if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
                if (isScanMode)
                    [self processCheckSingleScan];
                else
                    return NO;
            }
            else
                [self processCheckScan:strFccBarCode];
        }
    }
    else if (tag == 300){ //설비S/N
        [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
        
        if (txtFacCode.text.length < 1){
            [self showMessage: @"먼저 설비 바코드를 스캔하세요." tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtSnCode.text = @"";
            return NO;
        }
        else{
            [[fccSAPList objectAtIndex:rowSelIdx] setObject:txtSnCode.text forKey:@"SERGE"];
            [self reloadTables];
            
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"SN_CHANGE" forKey:@"TASK"];
            [taskDic setObject:txtSnCode.text forKey:@"VALUE"];
            [taskDic setObject:txtFacCode.text forKey:@"IDX_BARCODE"];
            [taskList addObject:taskDic];
            
            txtFacCode.text = strFccBarCode = @"";
            txtSnCode.text = @"";
        }
    }
    return YES;
}


- (void)setOfflineLocCd:(NSString*)barcode
{
    [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:MESSAGE_OFFLINE];
    
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
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        
        BOOL isAdd = NO;
        
        if (!fccSAPList.count)
            isAdd = YES;
        NSDictionary* dic = [goodsList objectAtIndex:0];
        NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
        NSString* compType;
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            compType = @"";
        else
            compType = [dic objectForKey:@"COMPTYPE"];
        NSString* partTypeName = [WorkUtil getPartTypeFullName:compType device:[dic objectForKey:@"ZMATGB"]];
        NSString* checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",@"",@""];
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        if (barcodeName== nil)
            barcodeName = @"";
        else
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        
        [sapDic setObject:compType forKey:@"COMPTYPE"];
        [sapDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
        [sapDic setObject:@"" forKey:@"ZPSTATU"];
        [sapDic setObject:barcodeName forKey:@"MAKTX"];
        [sapDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"ZMATGB"];
        [sapDic setObject:[dic objectForKey:@"MATNR"] forKey:@"MATNR"];
        [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
        [sapDic setObject:@"" forKey:@"HEQUNR"];
        [sapDic setObject:@"" forKey:@"ZPPART"];
        [sapDic setObject:@"1" forKey:@"LEVEL"];
        [sapDic setObject:@"" forKey:@"ZKOSTL"];
        [sapDic setObject:@"" forKey:@"ZKTEXT"];
        [sapDic setObject:@"3" forKey:@"SCANTYPE"];
        [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
        
        //add
        [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
        [fccSAPList addObject:sapDic];
        
        if (isAdd){
            nSelectedRow = fccSAPList.count - 1;
            
            //레코드 첫번째 행 선택
            NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
            lblPartType.text = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
        }
        
        [self reloadTables];
        [self showCount];
        [self scrollToFirstPage];
        
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        [self scrollToIndex:nSelectedRow];
        
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
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
- (void) layoutScanMode:(int)index
{
    //테이블 초기화
    scanSAPList = [NSMutableArray array];
    
    imgCheck.hidden = NO;
    lblColumnHeader11.hidden = YES;
    
    lblColumnHeader12.text = @"번호";//60
    lblColumnHeader12.frame = CGRectMake(36, 0, 50, 34);
    lblColumnHeader13.text = @"단말바코드";//100
    lblColumnHeader13.frame = CGRectMake(87, 0, 232, 34);
    
    materialView.hidden = NO;
    NSDictionary* dic = [fccSAPList objectAtIndex:index];
    lblMaterial.text = [NSString stringWithFormat:@"%@:%@:%@",[dic objectForKey:@"MATNR"],[dic objectForKey:@"MAKTX"],[dic objectForKey:@"CHARG"]];
    
    fccBarcodeView.hidden = NO;
    fccBarcodeView.frame = CGRectMake(0, 186, 320, 34);
    
    curdView.frame = CGRectMake(0, 221, 320, 40);
    
    // scanTable 보이기
    _tableScan.hidden = NO;
    _tableView.hidden = YES;
    
    btnSearch.hidden = YES;
    
    btnInit.frame = CGRectMake(112, 2, 50, 35);
    btnDelete.hidden = NO;
    btnDelete.frame = CGRectMake(164, 2, 50, 35);
    btnSend.hidden = NO;
    btnSend.frame = CGRectMake(216, 2, 50, 35);
    btnClose.hidden = NO;
    
    _scrollView.frame = CGRectMake(0, 262, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height + 44));
    _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width, _scrollView.frame.size.height);
    
    [self requestSurveyScanList:index];
}



- (void) layoutSubviews
{
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    //default snNumberView hidden
    snNumberView.hidden = YES;
    
    //카운트 레이블 구성
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    strUserOrgType = [dic objectForKey:@"orgTypeCode"];
    strBusinessNumber = [dic objectForKey:@"bussinessNumber"];
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
    
    if ([JOB_GUBUN isEqualToString:@"수리완료"]) {
        columnHeaderView5.hidden = NO;
        columnHeaderView6.hidden = NO;
        _tableView5.hidden = NO;
        _tableView6.hidden = NO;
        
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*6, _scrollView.frame.size.height);
    }
    else if ([JOB_GUBUN isEqualToString:@"개조개량완료"] ||
             [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
             [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]) {
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*3, _scrollView.frame.size.height);
    }
    else if ([JOB_GUBUN isEqualToString:@"상품단말실사"]) {
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*2, _scrollView.frame.size.height);
        _tableView3.hidden = YES;
        columnHeaderView3.hidden = YES;
        
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        fccBarcodeView.hidden = YES;
        lblfccBarcode.text = @"단말바코드";
        insepectionView.hidden = NO;
        plantView.hidden = NO;
        savedLocView.hidden = NO;
        docNoView.hidden = NO;
        
        //초기화,조회 버튼
        btnInit.frame = CGRectMake(216, 2, 50, 35);
        btnSearch.hidden = NO;
        btnSearch.frame = CGRectMake(268, 2, 50, 35);
        
        btnDelete.hidden = YES;
        btnSave.hidden = YES;
        btnSend.hidden = YES;
        
        isScanMode = NO;
        imgCheck.hidden = YES;
        lblColumnHeader11.text = @"항번";
        lblColumnHeader11.frame = CGRectMake(1, 0, 34, 34);
        lblColumnHeader12.text = @"자재코드";//60
        lblColumnHeader12.frame = CGRectMake(35, 0, 80, 34);
        lblColumnHeader13.text = @"자재명";//100
        lblColumnHeader13.frame = CGRectMake(116, 0, 202, 34);
        
        lblColumnHeader21.text = @"수량";
        lblColumnHeader21.frame = CGRectMake(1, 0, 90, 34);
        lblColumnHeader22.text = @"스캔수량";//60
        lblColumnHeader22.frame = CGRectMake(92, 0, 90, 34);
        lblColumnHeader23.text = @"배치번호";//100
        lblColumnHeader23.frame = CGRectMake(183, 0, 136, 34);
        
        lblYear.text = [NSDate YearString];
        selectedYearPickerData = lblYear.text;
        lblMonth.text = [NSDate MonthString];
        selectedMonthPickerData = lblMonth.text;
    }
    else if ([JOB_GUBUN isEqualToString:@"수리의뢰취소"] ||
             [JOB_GUBUN isEqualToString:@"고장등록취소"]) {
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*5, _scrollView.frame.size.height);
    }
    else if ([JOB_GUBUN isEqualToString:@"수리완료"])
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*7, _scrollView.frame.size.height);
    else{
        _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*4, _scrollView.frame.size.height);
    }
    
    // DR-2015-45173 바코드앱 일부 메뉴의 select 값 순서 변경 by 조석호 과장(예비 -> 유휴)
    if ([JOB_GUBUN isEqualToString:@"고장등록취소"]){
        picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴", @"예비", @"미운용", @"불용대기"]];
        //피커 델리게이트를 항상 먼저 선택
        picker.delegate = self;
        [picker selectPicker:0]; //선택값 예비로 설정 -> 유휴로 변경
        
        CGRect rect = _scrollView.frame;
        rect.origin.y = 200;
        rect.size.height += 36;
        _scrollView.frame = rect;
    }
    else if ([JOB_GUBUN isEqualToString:@"수리의뢰취소"]){
        fccStatusView.hidden = YES;
        curdView.frame = CGRectMake(0, 123, 320, 40);
        
        CGRect rect = _scrollView.frame;
        rect.origin.y = 163;
        rect.size.height += 72;
        _scrollView.frame = rect;
    }
    else if ([JOB_GUBUN isEqualToString:@"수리완료"]){
        picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴", @"예비", @"불용대기"]];
        picker.delegate = self;
        [picker selectPicker:0]; //선택값 예비로 설정 -> 유휴로 변경
        
        
        //table header 정의
        lblColumnHeader31.text = @"위치바코드";
        lblColumnHeader31.frame = CGRectMake(1, 0, 318, 34);
        lblColumnHeader32.hidden = YES;
        lblColumnHeader33.hidden = YES;
        
        lblColumnHeader41.text = @"위치명";
        lblColumnHeader41.frame = CGRectMake(1, 0, 318, 34);
        lblColumnHeader42.hidden = YES;
        lblColumnHeader43.hidden = YES;
        
        lblColumnHeader51.text = @"원인유형";
        lblColumnHeader51.frame = CGRectMake(1, 0,98, 34);
        lblColumnHeader52.text = @"수리유형";
        lblColumnHeader52.frame = CGRectMake(100, 0,98, 34);
        lblColumnHeader53.text = @"고장코드";
        lblColumnHeader53.frame = CGRectMake(200, 0,118, 34);
        
        lblColumnHeader61.text = @"수리의뢰번호";
        lblColumnHeader61.frame = CGRectMake(1, 0, 98, 34);
        lblColumnHeader62.text = @"기존바코드";
        lblColumnHeader62.frame = CGRectMake(100, 0, 118, 34);
        lblColumnHeader63.text = @"대체발행사유";
        lblColumnHeader63.frame = CGRectMake(220, 0,98, 34);
        
        CGRect rect = _scrollView.frame;
        rect.origin.y = 200;
        rect.size.height += 36;
        _scrollView.frame = rect;
    }
    else if (
             [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
             [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]
             ){
        _tableView4.hidden = YES;
        _tableView5.hidden = YES;
        columnHeaderView4.hidden = YES;
        columnHeaderView5.hidden = YES;
        
        
        fccStatusView.hidden = YES;
        curdView.frame = CGRectMake(0, 123, 320, 40);
        CGRect rect = _scrollView.frame;
        rect.origin.y = 163;
        rect.size.height += 72;
        _scrollView.frame = rect;
        
        //table header 정의
        lblColumnHeader31.text = @"장치바코드";
        lblColumnHeader31.frame = CGRectMake(1, 0, 98, 34);
        if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
            lblColumnHeader32.text = @"지시서번호";
            lblColumnHeader32.frame = CGRectMake(100, 0, 118, 34);
            lblColumnHeader33.text = @"운용조직";
            lblColumnHeader33.frame = CGRectMake(220, 0, 98, 34);
        }else{
            lblColumnHeader32.text = @"운용조직";
            lblColumnHeader32.frame = CGRectMake(100, 0, 158, 34);
            lblColumnHeader33.hidden = YES;
        }
    }
    else if (
             [JOB_GUBUN isEqualToString:@"개조개량완료"]
             ){
        //table 3개만 필요함
        picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴", @"예비"]];
        picker.delegate = self;
        [picker selectPicker:0]; //선택값 예비로 설정 -> 유휴로 변경
        
        //table header 정의
        lblColumnHeader31.text = @"장치바코드";
        lblColumnHeader31.frame = CGRectMake(1, 0, 159, 34);
        lblColumnHeader32.text = @"운용조직";
        lblColumnHeader32.frame = CGRectMake(107, 0, 158, 34);
        lblColumnHeader33.hidden = YES;
        lblColumnHeader41.hidden = YES;
        lblColumnHeader42.hidden = YES;
        _tableView4.hidden = YES;
        
        CGRect rect = _scrollView.frame;
        rect.origin.y = 200;
        rect.size.height += 36;
        _scrollView.frame = rect;
    }
    else if ([JOB_GUBUN isEqualToString:@"S/N변경"]){
        snNumberView.hidden = NO;
        
        organInfoView.hidden = YES;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        
        fccBarcodeView.frame = CGRectMake(1, 2, 318, 34);
        snNumberView.frame = CGRectMake(1, 36, 318, 34);
        curdView.frame = CGRectMake(1, 70, 318, 40);
        _scrollView.frame = CGRectMake(1, 110, 318, 151);
        
        columnHeaderView.hidden = YES;
        columnHeaderView2.hidden = YES;
        columnHeaderView3.hidden = YES;
        columnHeaderView4.hidden = YES;
        columnHeaderView5.hidden = YES;
        columnHeaderView6.hidden = YES;
        columnHeaderView7.hidden = YES;
        columnHeaderView8.hidden = YES;
        columnHeaderView9.hidden = YES;
        columnHeaderView10.hidden = YES;
        columnHeaderView11.hidden = YES;
        columnHeaderView12.hidden = YES;
        columnHeaderView13.hidden = YES;
        columnHeaderView14.hidden = YES;
        columnHeaderView15.hidden = NO;
        
        lblColumnHeader151.text = @"설비바코드";
        lblColumnHeader152.text = @"설비 S/N";
        lblColumnHeader153.text = @"설비상태";
        lblColumnHeader154.text = @"물품코드";
        lblColumnHeader155.text = @"물품명";
        lblColumnHeader156.text = @"품목구분";
        lblColumnHeader157.text = @"부품종류";
        lblColumnHeader158.text = @"장치바코드";
        lblColumnHeader159.text = @"운용조직";
        
        _tableView.hidden = YES;
        _tableView2.hidden = YES;
        _tableView3.hidden = YES;
        _tableView4.hidden = YES;
        _tableView5.hidden = YES;
        _tableView6.hidden = YES;
        _tableView7.hidden = YES;
        _tableView8.hidden = YES;
        _tableView9.hidden = YES;
        _tableView10.hidden = YES;
        _tableView11.hidden = YES;
        _tableView12.hidden = YES;
        _tableView13.hidden = YES;
        _tableView14.hidden = YES;
        _tableView15.hidden = NO;
    }
    
    if(![JOB_GUBUN isEqualToString:@"S/N변경"]){
        columnHeaderView15.hidden = YES;
        _tableView15.hidden = YES;
    }
    
    if (!locBarcodeView.hidden)
        [txtLocCode becomeFirstResponder];
    else
        [txtFacCode becomeFirstResponder];
}

- (void) locBecameFirstResponder
{
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}

-(void) setBecameResponder
{
    if (!txtLocCode.text.length && !locBarcodeView.hidden)
        [txtLocCode becomeFirstResponder];
    else if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
    
}

-(void) snBecameFirstResponder{
    if (![txtSnCode isFirstResponder])
        [txtSnCode becomeFirstResponder];
}

- (void) layoutControl
{
    if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
    [self showCount];
}

- (void) reloadTables
{
    if ([JOB_GUBUN isEqualToString:@"수리완료"]){
        [_tableView reloadData];
        [_tableView2 reloadData];
        [_tableView3 reloadData];
        [_tableView4 reloadData];
        [_tableView5 reloadData];
        [_tableView6 reloadData];
    }
    else if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
        if (isScanMode)
            [_tableScan reloadData];
        else {
            [_tableView reloadData];
            [_tableView2 reloadData];
        }
    }
    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
             [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]){
        [_tableView reloadData];
        [_tableView2 reloadData];
        [_tableView3 reloadData];
    }
    else if ([JOB_GUBUN isEqualToString:@"S/N변경"]){
        [_tableView15 reloadData];
    }
    else {
        [_tableView reloadData];
        [_tableView2 reloadData];
        [_tableView3 reloadData];
        [_tableView4 reloadData];
        [_tableView5 reloadData];
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

- (void)scrollToFirstPage
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scanScrollToIndex:(NSInteger)index
{
    CGFloat yOffset = 0;
    
    if (index >= 0){
        if (_tableScan.contentSize.height > _tableScan.frame.size.height) {
            NSArray* visibleCells = _tableView.visibleCells;
            CommonCell* firstcell = [visibleCells firstObject];
            CommonCell* lastcell = [visibleCells lastObject];
            
            if (lastcell && firstcell){
                NSIndexPath* lastPath = [_tableScan indexPathForCell:lastcell];
                NSIndexPath* firstPath = [_tableScan indexPathForCell:firstcell];
                
                if (index == 0) yOffset = 0.0f;
                else if ( index >= firstPath.row && index <= lastPath.row)
                    return;
                else if (index <= lastPath.row)
                    yOffset =  (lastcell.bounds.size.height * index);
                else{
                    if (index == scanSAPList.count - 1)
                        yOffset = _tableScan.contentSize.height - _tableScan.bounds.size.height;
                    else
                        yOffset =  _tableScan.bounds.size.height + lastcell.bounds.size.height * (index - lastPath.row);
                }
            }
        }
        [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
}


- (void) showCount
{
    int shelfCount = 0;
    int rackCount = 0;
    int unitCount = 0;
    int equipCount = 0;
    int totalCount = 0;
    NSString* formatString = nil;
    
    if (fccSAPList.count){
        if ([JOB_GUBUN isEqualToString:@"개조개량완료"] ||
            [JOB_GUBUN isEqualToString:@"상품단말실사"]
            ){
            //개조개량완료
            if (isScanMode)
                totalCount = (int)[scanSAPList count];
            else
                totalCount = (int)[fccSAPList count];
            if([JOB_GUBUN isEqualToString:@"상품단말실사"])
                formatString = [NSString stringWithFormat:@"%d건", totalCount];
            else{
                for(NSDictionary* dic in fccSAPList)
                {
                    NSString* partName = [dic objectForKey:@"PART_NAME"];
                    if ([partName hasPrefix:@"R"])
                        rackCount++;
                    else if ([partName hasPrefix:@"S"])
                        shelfCount++;
                    else if ([partName hasPrefix:@"U"])
                        unitCount++;
                    else if ([partName hasPrefix:@"E"])
                        equipCount++;
                    
                }
                
                formatString = [NSString stringWithFormat:@"R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount,shelfCount,unitCount,equipCount,totalCount];
            }
            lblCount.text = formatString;
            return;
            
        }
        else {
            for(NSDictionary* dic in fccSAPList)
            {
                NSString* partName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
                if ([partName isEqualToString:@"R"])
                    rackCount++;
                else if ([partName isEqualToString:@"S"])
                    shelfCount++;
                else if ([partName isEqualToString:@"U"])
                    unitCount++;
                else if ([partName isEqualToString:@"E"])
                    equipCount++;
            }
        }
    }
    
    totalCount =  rackCount + shelfCount + unitCount + equipCount;
    if([JOB_GUBUN isEqualToString:@"상품단말실사"])
        formatString = [NSString stringWithFormat:@"%d건", totalCount];
    else
        formatString = [NSString stringWithFormat:@"R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount,shelfCount,unitCount,equipCount,totalCount];
    lblCount.text = formatString;
    
}

// matsua: 주소정보조회 팝업 추가
- (IBAction) locInfoBtnAction:(id)sender{
    
    if(strLocBarCode.length < 1){
        return;
    }
    
    [self.view endEditing:YES];
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] init];
    modalView.delegate = self;
    [modalView openModal:strLocBarCode];
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
    
    modalView.locCd = strLocBarCode;
    modalView.locNm = strLocFullName;
    modalView.locNmBd = locAddrBd;
    modalView.locNmLoad = locAddrLoad;
    
    [self presentViewController:modalView animated:NO completion:nil];
    modalView.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        modalView.view.alpha = 1;
    }];
}

- (BOOL) processCheckSendData
{
    NSString* message = nil;
    
    if (!locBarcodeView.hidden && !lblLocBarcodeName.text.length){
        message = @"위치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return NO;
    }
    
    if (!fccBarcodeView.hidden && !fccSAPList.count){
        message = @"전송할 설비바코드가\n존재하지 않습니다";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return NO;
    }
    
    if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
        if (!plantView.hidden && !selectedPlantPickerData.length){
            message = @"플랜트를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return NO;
        }
        if (!savedLocView.hidden && !selectedSavedLocPickerData.length){
            message = @"저장위치를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return NO;
        }
        if (!docNoView.hidden && !selectedDocNoPickerData.length){
            message = @"실사문서번호를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            return NO;
        }
    }
    
    if ([JOB_GUBUN isEqualToString:@"S/N변경"]){
        for (int i=0; i < [fccSAPList count]; i++) {
            if([[[fccSAPList objectAtIndex:i] objectForKey:@"IS_SELECTED"] boolValue]){
                if([[[fccSAPList objectAtIndex:i]objectForKey:@"SERGE"] length] < 1){
                    message = @"입력하지 않은 S/N가 존재합니다.";
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

- (void) processCheckOrganization:(NSDictionary*)dic
{
    NSString* barcode = @"";
    NSString* orgName = @"";
    NSString* orgCode = @"";
    
    if (
        [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
        [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
        ){
        barcode = [dic objectForKey:@"BARCODE"];
        orgName = [dic objectForKey:@"ZKTEXT"];
        orgCode = [dic objectForKey:@"ZKOSTL"];
    }
    else {
        barcode = [dic objectForKey:@"EQUNR"];
        orgName = [dic objectForKey:@"ZKTEXT"];
        orgCode = [dic objectForKey:@"ZKOSTL"];
    }
    
    if (
        [JOB_GUBUN isEqualToString:@"수리완료"] ||
        [JOB_GUBUN isEqualToString:@"S/N변경"]
        )
    {
        //조직변경여부 묻지 않음
        return;
    }
    
    if (![strUserOrgCode isEqualToString:orgCode])
    {
        NSString* message = [NSString stringWithFormat:@"'%@'의 운용조직은\n'%@'입니다.\n운용조직을 '%@'으로\n변경하시겠습니까?",barcode,orgName,strUserOrgName];
        [self showMessage:message tag:200 title1:@"예" title2:@"아니오"];
        
        key = [@"200" UTF8String];
        
        objc_setAssociatedObject(fccSAPList, &key, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        isOrgChanged = NO;
    }
}

- (BOOL) processCheckSingleScan
{
    NSString* message = nil;
    
    if (scanSAPList.count){
        int index = [WorkUtil getBarcodeIndex:strFccBarCode fccList:scanSAPList];
        
        if (index != -1){ //바코드 존재 해당 배열에서 교체
            message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",strFccBarCode];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
            isOperationFinished = YES;
            return NO;
            
        }
        else { //테이블에 바코드 존재하지 않음 행 추가
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
            //선택상태 추가
            [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            [sapDic setObject:@"N" forKey:@"IS_SEND"];
            [scanSAPList addObject:sapDic];
            [_tableScan reloadData];
            [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
        }
    }
    else {
        NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
        [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
        //선택상태 추가
        [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
        [sapDic setObject:@"N" forKey:@"IS_SEND"];
        [scanSAPList addObject:sapDic];
        [_tableScan reloadData];
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    isOperationFinished = YES;
    return YES;
}

- (BOOL) processCheckScan:(NSString*)barcode
{
    NSString* message = nil;
    
    if (fccSAPList.count){
        int index = [WorkUtil getBarcodeIndex:strFccBarCode fccList:fccSAPList];
        
        if (index != -1){ //바코드 존재 해당 배열에서 교체
            message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",barcode];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
            isOperationFinished = YES;
            return NO;
        }
        else if (isOffLine)
            [self setOfflineFacCd:strFccBarCode];
        else { //테이블에 바코드 존재하지 않음 행 추가
            // 고장등록취소, 수리의뢰취소, 개조개량의뢰, 개조개량의뢰취소, 개조개량완료, 장비실사
            if (
                [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
                [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
                )
                [self requestGridInfo:strFccBarCode];
            else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
            {
                //recode 갯수가 1개 이지 않을까 생각듬
                NSString* upgradeBarcode = @"";
                for (NSDictionary* dic in remodelList)
                {
                    NSString* barcode = [dic objectForKey:@"EQUNR"];
                    upgradeBarcode = [dic objectForKey:@"UPGEQUNR"];
                    if (([upgradeBarcode isEqualToString:@""] && [strFccBarCode isEqualToString:barcode]) ||
                        (![upgradeBarcode isEqualToString:@""] && [barcode isEqualToString:upgradeBarcode]))
                        break;
                }
                // 개조개량완료 이며 개조후바코드 있을때는 PDA 단말 자재마스터 조회
                //물품바코드 조회
                if (upgradeBarcode.length)
                    [self requestFccInfo:strFccBarCode];
                else
                    [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
            }
            else if ([JOB_GUBUN isEqualToString:@"수리완료"])
                [self requestRepairReceiptIM];
            else
                [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
        }
    }
    else if (isOffLine)
        [self setOfflineFacCd:strFccBarCode];
    else {
        // 고장등록취소, 수리의뢰취소, 개조개량의뢰, 개조개량의뢰취소, 개조개량완료, 장비실사
        if (
            [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
            [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
            )
            [self requestGridInfo:strFccBarCode];
        else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
        {
            //recode 갯수가 1개 이지 않을까 생각듬
            NSString* UPGEQUNR = @"";
            for (NSDictionary* dic in remodelList)
            {
                NSString* barcode = [dic objectForKey:@"EQUNR"];
                UPGEQUNR = [dic objectForKey:@"UPGEQUNR"];
                if (([UPGEQUNR isEqualToString:@""] && [strFccBarCode isEqualToString:barcode]) ||
                    (![UPGEQUNR isEqualToString:@""] && [strFccBarCode isEqualToString:UPGEQUNR]))
                    break;
                
            }
            // 개조개량완료 이며 개조후바코드 있을때는 PDA 단말 자재마스터 조회
            //물품바코드 조회
            if (UPGEQUNR.length)
                [self requestFccInfo:strFccBarCode];
            else
                [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
        }
        else if ([JOB_GUBUN isEqualToString:@"수리완료"])
            [self requestRepairReceiptIM];
        else
            [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
    }
    return YES;
}


- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - UI Action
-(IBAction)btnSelAll:(id)sender{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    for (int i =0; i < fccSAPList.count; i++) {
        NSMutableDictionary* selectItem = [fccSAPList objectAtIndex:i];
        [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
    }
    
    [_tableView15 reloadData];
    
    //작업관리에 추가
    for (int w =0; w < fccSAPList.count; w++) {
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"SELECT_CHECK" forKey:@"TASK"];
        [taskDic setObject:[NSString stringWithFormat:@"%d", w] forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
}

- (IBAction) touchShowPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    [txtLocCode resignFirstResponder];
    [picker showView];
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

- (IBAction) touchSaveBtn:(id)sender
{
    if([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        isDataSaved = YES;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void) touchBackBtn:(id)sender
{
    if (isScanMode){
        [self touchClose:nil];
        return;
    }
    if (picker.isShow)
        [picker hideView];
    if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    if (yearPicker.isShow)
        [yearPicker hideView];
    if (monthPicker.isShow)
        [monthPicker hideView];
    if (plantPicker.isShow)
        [plantPicker hideView];
    if (docPicker.isShow)
        [docPicker hideView];
    if (!isDataSaved && [Util udBoolForKey:IS_DATA_MODIFIED] && !btnSave.hidden){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }else{
        [txtFacCode resignFirstResponder];
        [txtLocCode resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction) touchBackground:(id)sender
{
    if ([Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }else{
        [txtFacCode resignFirstResponder];
        [txtLocCode resignFirstResponder];
    }
}
- (IBAction) touchClose:(id)sender
{
    isScanMode = NO;
    materialView.hidden = YES;
    fccBarcodeView.hidden = YES;
    curdView.frame = CGRectMake(0, 159, 320, 40);
    
    imgCheck.hidden = YES;
    lblColumnHeader11.hidden = NO;
    lblColumnHeader11.text = @"항번";
    lblColumnHeader11.frame = CGRectMake(1, 0, 34, 34);
    
    _tableView.hidden = NO;
    _tableScan.hidden = YES;
    
    //초기화,조회 버튼
    btnInit.frame = CGRectMake(216, 2, 50, 35);
    btnSearch.hidden = NO;
    btnSearch.frame = CGRectMake(268, 2, 50, 35);
    
    btnDelete.hidden = YES;
    btnSave.hidden = YES;
    btnSend.hidden = YES;
    btnClose.hidden = YES;
    
    lblColumnHeader11.text = @"항번";
    lblColumnHeader11.frame = CGRectMake(1, 0, 34, 34);
    lblColumnHeader12.text = @"자재코드";//60
    lblColumnHeader12.frame = CGRectMake(36, 0, 80, 34);
    lblColumnHeader13.text = @"자재명";//100
    lblColumnHeader13.frame = CGRectMake(117, 0, 202, 34);
    
    lblColumnHeader21.text = @"수량";
    lblColumnHeader21.frame = CGRectMake(1, 0, 90, 34);
    lblColumnHeader22.text = @"스캔수량";//60
    lblColumnHeader22.frame = CGRectMake(92, 0, 90, 34);
    lblColumnHeader23.text = @"배치번호";//100
    lblColumnHeader23.frame = CGRectMake(183, 0, 136, 34);
    
    _scrollView.frame = CGRectMake(0, 199, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height + 44));
    _scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*2, _scrollView.frame.size.height);
    scanSAPList = [NSMutableArray array];
    [_tableScan reloadData];
    [self layoutControl];
}

- (IBAction) touchSearch:(id)sender
{
    if (docNoList.count)
        [self requestSurveySearchList];
}

- (IBAction) touchDeleteBtn:(id)sender
{
    NSString* message = nil;
    
    //check상태만 지운다.
    if (isScanMode){
        NSIndexSet* indexSet = [WorkUtil getSelectedGridIndexes:scanSAPList];
        if (scanSAPList.count <= 0 || indexSet.count <= 0){
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return;
        }
        message = @"삭제하시겠습니까?";
        [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
    }
    else {
        NSIndexSet* indexSet = [WorkUtil getSelectedGridIndexes:fccSAPList];
        if (fccSAPList.count <= 0 || indexSet.count <= 0){
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return;
        }
        message = @"삭제하시겠습니까?";
        [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
    }
}

- (IBAction) touchSendBtn:(id)sender
{
    NSString* message;
    
    if (![Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = NOT_CHANGE_SEND_MESSAGE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        return;
    }
    
    if (isScanMode){
        NSIndexSet* indexSet = [WorkUtil getSelectedGridIndexes:scanSAPList];
        if (scanSAPList.count && indexSet.count)
        {
            if ([self processCheckSendData])
            {
                message = @"전송하시겠습니까?";
                [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
            }
        }else{
            message = @"전송할 설비바코드가\n존재하지 않습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
    }
    else {
        NSIndexSet* indexSet = [WorkUtil getSelectedGridIndexes:fccSAPList];
        if ([self processCheckSendData]){
            if (fccSAPList.count && indexSet.count)
            {
                if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]) {
                    message = @"전송하시겠습니까?\n(개조개량 의뢰된 설비 하위에 설비가 존재하는 경우 분실위험 처리 됩니다. 존재하는 하위 설비에 대해 '실장' 혹은 '입고' 처리를 하여 분실위험을 해소 하시기 바랍니다.)";
                }
                else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]) {
                    message = @"전송하시겠습니까?\n('개조개량의뢰취소'된 설비의 형상을 '실장' 혹은 '입고' 처리하여 실물 정보와 일치시켜 주시기 바랍니다.)";
                }
                else
                    message = @"전송하시겠습니까?";
                [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
            }
            else {
                message = @"전송할 설비바코드가\n존재하지 않습니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            }
        }
    }
}


- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    if (isScanMode){
        if (scanSAPList.count) {
            NSMutableDictionary* selectItem = [scanSAPList objectAtIndex:btn.tag];
            [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
            [_tableScan reloadData];
        }
    }
    else {
        if (fccSAPList.count) {
            NSMutableDictionary* selectItem = [fccSAPList objectAtIndex:btn.tag];
            [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
            [_tableView reloadData];
        }
    }
    //작업관리에 추가
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"SELECT_CHECK" forKey:@"TASK"];
    [taskDic setObject:[NSString stringWithFormat:@"%d", (int)btn.tag] forKey:@"VALUE"];
    [taskList addObject:taskDic];
}


- (IBAction) touchInitBtn
{
    //textfield 초기화
    txtLocCode.text = strLocBarCode = @"";
    txtFacCode.text = strFccBarCode = @"";
    lblPartType.text = @"";
    txtSnCode.text = @"";
    
    if (picker.isShow)
        [picker hideView];
    if (savedLocPicker.isShow)
        [savedLocPicker hideView];
    if (yearPicker.isShow)
        [yearPicker hideView];
    if (monthPicker.isShow)
        [monthPicker hideView];
    if (plantPicker.isShow)
        [plantPicker hideView];
    if (docPicker.isShow)
        [docPicker hideView];
    
    [picker selectPicker:1];
    
    //위치바코드 포커싱
    if (!locBarcodeView.hidden){
        if (![txtLocCode isFirstResponder])
            [txtLocCode becomeFirstResponder];
    }
    else if (!fccBarcodeView.hidden){
        if (![txtFacCode isFirstResponder])
            [txtFacCode becomeFirstResponder];
    }
    
    //Ticker 초기화
    if (!locBarcodeView.hidden){
        [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:@""];
    }
    
    NSString* pickerRow = [workDic objectForKey:@"PICKER_ROW"];
    if(pickerRow == nil){
        pickerRow = @"";
    }
    
    NSString* offline = [workDic objectForKey:@"OFFLINE"];
    
    //작업관리 초기화
    dbWorkDic = [NSMutableDictionary dictionary];
    isDataSaved = NO;
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
    [workDic setObject:pickerRow forKey:@"PICKER_ROW"];
    [workDic setObject:offline forKey:@"OFFLINE"];
    
    
    //table초기화
    if (isScanMode)
        scanSAPList = [NSMutableArray array];
    else {
        fccSAPList = [NSMutableArray array];
        scanSAPList = [NSMutableArray array];
    }
    
    [self reloadTables];
    [self showCount];
    
    //데이터 변경 안함
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
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


-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
        if (fccSAPList.count){
            CGPoint p = [gestureRecognizer locationInView:_tableView];
            NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
            if (indexPath){
                [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableScan)
        return [scanSAPList count];
    else
        return [fccSAPList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* formatString = @"";
    NSString* partTypeName = @"";
    NSString* barcode = @"";
    NSString* status = @"";
    NSString* materialCode = @"";
    NSString* materialName = @"";
    NSString* failureCode = @"";
    NSString* failureName = @"";
    NSString* regNO = @"";
    NSString* devTypeName = @"";
    NSString* scanType = @"";
    NSString* deviceID = @"";
    NSString* checkOrgValue = @"";
    NSString* locBarcode = @"";
    NSString* lifnr = @"";
    NSString* lifnrName = @"";
    
    NSString* URCODN = @"";
    NSString* MNCODN = @"";
    NSString* QMNUM = @"";
    NSString* FECOD = @"";
    NSString* EXBARCODE = @"";
    NSString* RREASON = @"";
    NSString* locName = @"";
    NSString* ZPSTATU = @"";
    NSString* ZEILI = @""; //항번
    NSString* BUCHM = @"";
    NSString* MENGE = @"";
    NSString* CHARG = @"";
    
    NSString* serge=@"";
    
    if ([fccSAPList count]){
        NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
        if (isOffLine){
            partTypeName = [dic objectForKey:@"PART_NAME"]; //부품종류
            barcode = [dic objectForKey:@"EQUNR"]; //설비바코드
            materialCode = [dic objectForKey:@"MATNR"]; //물품코드
            if (!materialCode.length)
                materialCode = [dic objectForKey:@"SUBMT"];
            materialName = [dic objectForKey:@"MAKTX"]; //물품명
            status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
            devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZMATGB"]];//품목구분
            if (!devTypeName.length)
                devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];//품목구분
            failureCode = [dic objectForKey:@"FECOD"]; //고장코드
            failureName = [dic objectForKey:@"FECODN"]; //고장명
            regNO = [dic objectForKey:@"REGNO"];  //등록번호
            scanType = [dic objectForKey:@"SCANTYPE"];
            deviceID = [dic objectForKey:@"ZEQUIPGC"]; //장치바코드
            checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
        }
        else if (
                 [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
                 [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
                 )
        {
            partTypeName = [WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            barcode = [dic objectForKey:@"EQUNR"]; //섧비바코드
            materialCode = [dic objectForKey:@"SUBMT"]; //물품코드
            materialName = [dic objectForKey:@"MAKTX"]; //물품명
            status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
            devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];//품목구분
            failureCode = [dic objectForKey:@"FECOD"]; //고장코드
            failureName = [dic objectForKey:@"FECODN"]; //고장명
            regNO = [dic objectForKey:@"REGNO"];  //등록번호
            lifnr = [dic objectForKey:@"LIFNR"];    // 협력사 코드
            lifnrName = [dic objectForKey:@"LIFNRN"];   // 협력사명
            scanType = [dic objectForKey:@"SCANTYPE"];
            checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
            QMNUM = [dic objectForKey:@"QMNUM"];
            
            formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",barcode,materialCode,materialName,devTypeName,partTypeName,status,failureCode,failureName,regNO,checkOrgValue];
        }
        else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
        {
            partTypeName = [dic objectForKey:@"PART_NAME"]; //부품종류
            barcode = [dic objectForKey:@"EQUNR"]; //설비바코드
            materialCode = [dic objectForKey:@"MATNR"]; //물품코드
            if (!materialCode.length)
                materialCode = [dic objectForKey:@"SUBMT"];
            materialName = [dic objectForKey:@"MAKTX"]; //물품명
            status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
            devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZMATGB"]];//품목구분
            if (!devTypeName.length)
                devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];//품목구분
            failureCode = [dic objectForKey:@"FECOD"]; //고장코드
            failureName = [dic objectForKey:@"FECODN"]; //고장명
            regNO = [dic objectForKey:@"REGNO"];  //등록번호
            scanType = [dic objectForKey:@"SCANTYPE"];
            deviceID = [dic objectForKey:@"ZEQUIPGC"]; //장치바코드
            checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
        }
        else if (
                 [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
                 [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]
                 )
        {
            partTypeName = [WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            barcode = [dic objectForKey:@"EQUNR"]; //섧비바코드
            materialCode = [dic objectForKey:@"SUBMT"]; //물품코드
            materialName = [dic objectForKey:@"MAKTX"]; //물품명
            devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];//품목구분
            deviceID = [dic objectForKey:@"ZEQUIPGC"]; //장치바코드
            checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
        }
        else if ([JOB_GUBUN isEqualToString:@"상품단말실사"])
        {
            ZEILI = [dic objectForKey:@"ZEILI"];
            materialCode = [dic objectForKey:@"MATNR"];
            materialName = [dic objectForKey:@"MAKTX"];
            BUCHM = [dic objectForKey:@"BUCHM"];
            MENGE = [dic objectForKey:@"MENGE"];
            CHARG = [dic objectForKey:@"CHARG"];
        }
        else if ([JOB_GUBUN isEqualToString:@"수리완료"])
        {
            partTypeName = [WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            barcode = [dic objectForKey:@"EQUNR"]; //설비바코드
            materialCode = [dic objectForKey:@"SUBMT"]; //물품코드
            materialName = [dic objectForKey:@"MAKTX"]; //물품명
            devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];//품목구분
            status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
            locBarcode = [dic objectForKey:@"ZEQUIPLP"];
            URCODN     = [dic objectForKey:@"URCODN"];
            QMNUM      = [dic objectForKey:@"QMNUM"];
            MNCODN     = [dic objectForKey:@"MNCODN"];
            locName    = [dic objectForKey:@"ZEQUIPLPT"];
            FECOD      = [dic objectForKey:@"FECOD"];
            EXBARCODE  = [dic objectForKey:@"EXBARCODE"];
            RREASON    = [dic objectForKey:@"RREASON"];
            ZPSTATU    = [dic objectForKey:@"ZPSTATU"];
        }
        else if([JOB_GUBUN isEqualToString:@"S/N변경"]){
            barcode         = [dic objectForKey:@"EQUNR"];                                      //설비바코드
            serge           = [dic objectForKey:@"SERGE"];                                      //설비S/N
            status          = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]];   //설비상태코드(ZPSTATU)
            materialCode    = [dic objectForKey:@"SUBMT"];                                      //물품코드
            materialName    = [dic objectForKey:@"MAKTX"];                                      //물품명
            devTypeName     = [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]];       //품목구분
            partTypeName    = [dic objectForKey:@"PART_NAME"];                                  //부품종류
            deviceID        = [dic objectForKey:@"ZEQUIPGC"];                                   //장치바코드
            checkOrgValue   = [dic objectForKey:@"ORG_CHECK"];                                  //운용조직
            
            //            formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@",barcode,serge,status,materialCode,materialName,devTypeName,partTypeName,deviceID,checkOrgValue];
        }
    }
    
    if (tableView == _tableView){
        if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
            GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridColumn3Cell class]])
                    {
                        cell = object;
                        cell.lblColumn1.frame = CGRectMake(2, 0, 29, 40);
                        cell.lblColumn2.frame = CGRectMake(36, 0, 80,40);
                        cell.lblColumn3.frame = CGRectMake(117, 0, 202, 34);
                        break;
                    }
                }
            }
            cell.lblColumn1.text = ZEILI;
            cell.lblColumn2.text = materialCode;
            cell.lblColumn3.text = materialName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            GridColumn2Cell *cell = (GridColumn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn2Cell"];
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn2Cell" owner:self options:nil];
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridColumn2Cell class]])
                    {
                        cell = object;
                        break;
                    }
                }
            }
            cell.lblColumn1.text = barcode;
            cell.lblColumn2.text = materialCode;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (fccSAPList.count){
                [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnCheck.tag = indexPath.row;
                NSDictionary* cellDic = [fccSAPList objectAtIndex:indexPath.row];
                BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
                cell.btnCheck.selected = isSelected;
            }
            return cell;
        }
        
    }
    else if (tableView == _tableScan){
        //스캔모드 이면 체크 박스추가
        GridColumn2Cell *cell = (GridColumn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn2Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn2Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn2Cell class]])
                {
                    cell = object;
                    cell.lblColumn1.frame = CGRectMake(36, 0, 50, 40);
                    cell.lblColumn2.frame = CGRectMake(87, 0, 232,40);
                    
                    break;
                }
            }
        }
        NSDictionary* scanDic = [scanSAPList objectAtIndex:indexPath.row];
        
        NSString* barcode = [scanDic objectForKey:@"EQUNR"];
        
        cell.lblColumn1.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1]; //번호
        cell.lblColumn2.text = barcode;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (scanSAPList.count){
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [scanSAPList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
        }
        return cell;
        
    }
    else if (tableView == _tableView2){
        GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn3Cell class]])
                {
                    cell = object;
                    break;
                }
            }
        }
        if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
            cell.lblColumn1.frame = CGRectMake(1,0,90,40);
            cell.lblColumn2.frame = CGRectMake(92,0,90,40);
            cell.lblColumn3.frame = CGRectMake(183,0,136,40);
            
            cell.lblColumn1.text = BUCHM;
            cell.lblColumn2.text = MENGE;
            cell.lblColumn3.text = CHARG;
        }
        else {
            cell.lblColumn1.frame = CGRectMake(1,0,164,40);
            cell.lblColumn2.frame = CGRectMake(166,0,90,40);
            cell.lblColumn3.frame = CGRectMake(257,0,72,40);
            
            cell.lblColumn1.text = materialName;
            cell.lblColumn2.text = devTypeName;
            if ([partTypeName hasPrefix:@"E"])
                cell.lblColumn3.text = @"";
            else
                cell.lblColumn3.text = partTypeName;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _tableView3){
        GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn3Cell class]])
                {
                    cell = object;
                    if (
                        [JOB_GUBUN isEqualToString:@"개조개량의뢰"]
                        )
                    {
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,98,40);
                        cell.lblColumn2.frame = CGRectMake(100,0,118,40);
                        cell.lblColumn3.frame = CGRectMake(210,0,98,40);
                    }
                    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]){
                        cell.lblColumn1.frame = CGRectMake(1,0,98,40);
                        cell.lblColumn2.frame = CGRectMake(100,0,118,40);
                        cell.lblColumn3.hidden = YES;
                    }
                    else if ([JOB_GUBUN isEqualToString:@"수리완료"]){
                        
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,160,40);
                        cell.lblColumn2.hidden = YES;
                        cell.lblColumn3.hidden = YES;
                    }
                    else {
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,105,40);
                        cell.lblColumn2.frame = CGRectMake(107,0,200,40);
                        cell.lblColumn3.hidden = YES;
                    }
                    break;
                }
            }
        }
        if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"])
        {
            cell.lblColumn1.text = deviceID;      //장치바코드
            cell.lblColumn3.text = checkOrgValue;   // 운용조직
        }
        else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]){
            cell.lblColumn1.text = deviceID;      //장치바코드
            cell.lblColumn2.text = checkOrgValue;        //운용조직
            cell.lblColumn3.hidden = YES;
        }
        else if ([JOB_GUBUN isEqualToString:@"수리완료"])
        {
            cell.lblColumn1.text = locBarcode;
        }
        else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
        {
            cell.lblColumn1.text = deviceID;
            cell.lblColumn2.text = checkOrgValue;
        }
        else {
            cell.lblColumn1.text = status;
            cell.lblColumn2.text = failureCode;
            cell.lblColumn3.text = failureName;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _tableView4){
        GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn3Cell class]])
                {
                    cell = object;
                    if (
                        [JOB_GUBUN isEqualToString:@"개조개량의뢰"]
                        )
                    {
                        //cell frame 설정
                        cell.lblColumn1.hidden = YES;
                        cell.lblColumn2.frame = CGRectMake(1,0,318,40);
                        cell.lblColumn3.hidden = YES;
                    }
                    else if ([JOB_GUBUN isEqualToString:@"수리완료"]){
                        
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,319,40);
                        cell.lblColumn2.hidden = YES;
                        cell.lblColumn3.hidden = YES;
                    }
                    else {
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,90,40);
                        cell.lblColumn2.frame = CGRectMake(92,0,128,40);
                        cell.lblColumn3.frame = CGRectMake(222, 0, 98, 40);
                    }
                    break;
                }
            }
        }
        
        if ([JOB_GUBUN isEqualToString:@"수리완료"]){
            cell.lblColumn1.text = locName;
            cell.lblColumn2.hidden = YES;
            cell.lblColumn3.hidden = YES;
        }
        else {
            cell.lblColumn1.text = lifnr;
            cell.lblColumn2.text = lifnrName;
            cell.lblColumn3.text = regNO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _tableView5){
        GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn3Cell class]])
                {
                    cell = object;
                    
                    if ([JOB_GUBUN isEqualToString:@"수리완료"]){
                        cell.lblColumn1.frame = CGRectMake(1,0,98,40);
                        cell.lblColumn2.frame = CGRectMake(100,0,98,40);
                        cell.lblColumn3.frame = CGRectMake(200, 0, 118, 40);
                    }
                    else {
                        //cell frame 설정
                        cell.lblColumn1.frame = CGRectMake(1,0,115,40);
                        cell.lblColumn2.frame = CGRectMake(117,0,200,40);
                        cell.lblColumn3.hidden = YES;
                    }
                    break;
                }
            }
        }
        if ([JOB_GUBUN isEqualToString:@"수리완료"]){
            cell.lblColumn1.text = URCODN; //원인유형
            cell.lblColumn2.text = MNCODN; //수리유형
            cell.lblColumn3.text = FECOD; // 고장코드
        }else{
            cell.lblColumn1.text = QMNUM;
            cell.lblColumn2.text = checkOrgValue;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (tableView == _tableView6){
        GridColumn3Cell *cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumn3Cell class]])
                {
                    cell = object;
                    
                    if ([JOB_GUBUN isEqualToString:@"수리완료"]){
                        cell.lblColumn1.frame = CGRectMake(1,0,98,40);
                        cell.lblColumn2.frame = CGRectMake(100,0,118,40);
                        cell.lblColumn3.frame = CGRectMake(220,0,98,40);
                    }
                    break;
                }
            }
        }
        if ([JOB_GUBUN isEqualToString:@"수리완료"]){
            cell.lblColumn1.text = QMNUM;
            cell.lblColumn2.text = EXBARCODE;
            cell.lblColumn3.text = RREASON;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _tableView7){
        GridColumn3Cell* cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for(id object in nib){
                if ([object isMemberOfClass:[GridColumn3Cell class]]){
                    cell = object;
                    
                    cell.lblColumn1.frame = CGRectMake(3, 0, 157, 40);
                    cell.lblColumn2.frame = CGRectMake(163, 0, 77, 40);
                    cell.lblColumn3.frame = CGRectMake(243, 0, 76, 40);
                    
                    break;
                }
            }
        }
        NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
        
        cell.lblColumn1.text = [dic objectForKey:@"locationCode"];
        cell.lblColumn2.text = [dic objectForKey:@"deviceId"];
        cell.lblColumn3.text = [dic objectForKey:@"itemCode"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (tableView == _tableView8 || tableView == _tableView9 ||
              tableView == _tableView10 || tableView == _tableView11 ||
              tableView == _tableView12 || tableView == _tableView13){
        GridColumn3Cell* cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for(id object in nib){
                if ([object isMemberOfClass:[GridColumn3Cell class]]){
                    cell = object;
                    
                    cell.lblColumn1.frame = CGRectMake(3, 0, 103, 40);
                    cell.lblColumn2.frame = CGRectMake(110, 0, 103, 40);
                    cell.lblColumn3.frame = CGRectMake(217, 0, 103, 40);
                    
                    break;
                }
            }
            
        }
        NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
        
        if (tableView == _tableView8){
            cell.lblColumn1.text = [dic objectForKey:@"itemName"];
            cell.lblColumn2.text = [dic objectForKey:@"itemCategoryCode"];
            cell.lblColumn3.text = [dic objectForKey:@"itemCategoryName"];
        }else if (tableView == _tableView9){
            cell.lblColumn1.text = [dic objectForKey:@"partKindCode"];
            cell.lblColumn2.text = [dic objectForKey:@"partKindName"];
            cell.lblColumn3.text = [dic objectForKey:@"itemLargeClassificationCode"];
        }else if (tableView == _tableView10){
            cell.lblColumn1.text = [dic objectForKey:@"itemMiddleClassificationCode"];
            cell.lblColumn2.text = [dic objectForKey:@"itemSmallClassificationCode"];
            cell.lblColumn3.text = [dic objectForKey:@"itemDetailClassificationCode"];
        }else if (tableView == _tableView11){
            cell.lblColumn1.text = [dic objectForKey:@"injuryBarcode"];
            cell.lblColumn2.text = [dic objectForKey:@"publicationWhyCode"];
            cell.lblColumn3.text = [dic objectForKey:@"supplierCode"];
        }else if (tableView == _tableView12){
            cell.lblColumn1.text = [dic objectForKey:@"deptCode"];
            cell.lblColumn2.text = [dic objectForKey:@"operationDeptCode"];
            cell.lblColumn3.text = [dic objectForKey:@"makerCode"];
        }else if (tableView == _tableView13){
            cell.lblColumn1.text = [dic objectForKey:@"makerSerial"];
            cell.lblColumn2.text = [dic objectForKey:@"makerNational"];
            cell.lblColumn3.text = [dic objectForKey:@"obtainDay"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _tableView14){
        GridColumn3Cell* cell = (GridColumn3Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn3Cell"];
        if (!cell){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn3Cell" owner:self options:nil];
            for(id object in nib){
                if ([object isMemberOfClass:[GridColumn3Cell class]]){
                    cell = object;
                    
                    cell.lblColumn1.frame = CGRectMake(3, 0, 103, 40);
                    cell.lblColumn2.frame = CGRectMake(110, 0, 103, 40);
                    break;
                }
            }
        }
        NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
        
        cell.lblColumn1.text = [dic objectForKey:@"generationRequestSeq"];
        cell.lblColumn2.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _tableView15){
        GridColumn9Cell* cell = (GridColumn9Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumn9Cell"];
        if (!cell){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumn9Cell" owner:self options:nil];
            for(id object in nib){
                if ([object isMemberOfClass:[GridColumn9Cell class]]){
                    cell = object;
                    
                    cell.btnCheck.frame = CGRectMake(2, 6, 28, 29);
                    cell.lblColumn2.frame = CGRectMake(32, 0, 151, 40);
                    cell.lblColumn3.frame = CGRectMake(184, 0, 134, 40);
                    
                    cell.lblColumn4.frame = CGRectMake(322, 0, 105, 40);
                    cell.lblColumn5.frame = CGRectMake(427, 0, 105, 40);
                    cell.lblColumn6.frame = CGRectMake(532, 0, 105, 40);
                    
                    cell.lblColumn7.frame = CGRectMake(642, 0, 105, 40);
                    cell.lblColumn8.frame = CGRectMake(747, 0, 105, 40);
                    cell.lblColumn9.frame = CGRectMake(852, 0, 105, 40);
                    
                    cell.lblColumn10.frame = CGRectMake(962, 0, 318, 40);
                    break;
                }
            }
        }
        
        //        NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
        
        cell.lblColumn2.text  = barcode;
        cell.lblColumn3.text  = serge;
        cell.lblColumn4.text  = status;
        cell.lblColumn5.text  = materialCode;
        cell.lblColumn6.text  = materialName;
        cell.lblColumn7.text  = devTypeName;
        cell.lblColumn8.text  = partTypeName;
        cell.lblColumn9.text  = deviceID;
        cell.lblColumn10.text = checkOrgValue;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        rowSelIdx = indexPath.row;
        
        if (fccSAPList.count){
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [fccSAPList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![JOB_GUBUN isEqualToString:@"S/N변경"]){
        if (fccSAPList.count){
            NSDictionary* selItemDic = [fccSAPList objectAtIndex:indexPath.row];
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
            lblPartType.text = [selItemDic objectForKey:@"PART_NAME"];
            isScanMode = YES;
            if (tableView == _tableView)
                nSelectedRow = indexPath.row;
            if (isScanMode){
                [self layoutScanMode:(int)indexPath.row];
            }
        }
    }
    else{
        if (fccSAPList.count){
            NSDictionary* selItemDic = [fccSAPList objectAtIndex:indexPath.row];
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
            [self snBecameFirstResponder];
            rowSelIdx = indexPath.row;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){
        if (buttonIndex == 0){ //전송
            if ([JOB_GUBUN isEqualToString:@"상품단말실사"])
                [self requestSurveySend];
            else if ([JOB_GUBUN isEqualToString:@"수리완료"])
                [self requestIMSend];
            else
                [self requestSend];
        }
        else { //아니오
            if (
                [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
                [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]
                ){
                NSString* message = @"취소하였습니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            }
        }
    }
    else if (alertView.tag == 200){ //조직체크
        
        NSMutableDictionary* associatedDic = objc_getAssociatedObject(fccSAPList,&key);
        
        NSString* barcode = nil;
        if ([associatedDic objectForKey:@"EQUNR"] != nil)
            barcode = [associatedDic objectForKey:@"EQUNR"];
        else
            barcode = [associatedDic objectForKey:@"BARCODE"];
        
        NSMutableDictionary* selItemDic = [fccSAPList objectAtIndex:[WorkUtil getBarcodeIndex:barcode fccList:fccSAPList]];
        
        //조직체크 추가
        NSString* orgCode = [selItemDic objectForKey:@"ZKOSTL"];
        NSString* orgName = [selItemDic objectForKey:@"ZKTEXT"];
        NSString* checkOrgValue = nil;
        
        if (buttonIndex == 0){ //조직변경 sapList 직접변경
            isOrgChanged = YES;
            checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
        }
        else { //조직변경 안함
            isOrgChanged = NO;
            checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
        }
        [selItemDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
        
        //조직변경 반영
        if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"] || [JOB_GUBUN isEqualToString:@"개조개량완료"])
            [_tableView3 reloadData];
        else if ([JOB_GUBUN isEqualToString:@"S/N변경"] ){
            [_tableView15 reloadData];
        }
        else
            [_tableView5 reloadData];
    }
    else if (alertView.tag == 600){ //삭제
        if (buttonIndex == 0){ //삭제
            if (isScanMode){
                if (scanSAPList.count){
                    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:scanSAPList];
                    if (indexset.count){
                        [scanSAPList removeObjectsAtIndexes:indexset];
                        [_tableScan reloadData];
                        [self showCount];
                    }
                }
            }
            else {
                if (fccSAPList.count){
                    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:fccSAPList];
                    if (indexset.count){
                        [fccSAPList removeObjectsAtIndexes:indexset];
                        [self reloadTables];
                        [self showCount];
                    }
                }
            }
            
            //작업관리에 추가
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"DELETE" forKey:@"TASK"];
            [taskList addObject:taskDic];
            
            //데이터 변경
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
        }
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
    }
    //userDefault에 넣는다.
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

- (void)requestSurveySearchList
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PRODUCT_SURVEY_LIST;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if (docNoList.count){
        NSDictionary* dic = [docNoList objectAtIndex:docPicker.selectedIndex];
        [paramDic setObject:[NSDate YearString] forKey:@"GJAHR"]; //회계년도
        [paramDic setObject:[dic objectForKey:@"IBLNR"] forKey:@"IBLNR"]; //실사문서번호
    }
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRODUCT_SURVEY_LIST withData:rootDic];
}


- (void)requestSurveyScanList:(int)index
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PRODUCT_SURVEY_SCAN_LIST;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    NSDictionary* dic = [fccSAPList objectAtIndex:index];
    [paramDic setObject:[dic objectForKey:@"GJAHR"] forKey:@"GJAHR"]; //회계년도
    [paramDic setObject:[dic objectForKey:@"IBLNR"] forKey:@"IBLNR"]; //문서번호
    [paramDic setObject:[dic objectForKey:@"ZEILI"] forKey:@"ZEILI"]; //항목번호
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_PRODUCT_SURVEY_SCAN_LIST withData:rootDic];
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

- (void)requestDocNo
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GET_DOC_NO;
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if (plantList.count){
        NSDictionary* plantDic = [plantList objectAtIndex:plantPicker.selectedIndex];
        //plant
        [paramDic setObject:[plantDic objectForKey:@"PLANT"] forKey:@"WERKS"];
    }
    else
        [paramDic setObject:@"" forKey:@"WERKS"];
    
    if (savedLocList.count){
        NSDictionary* savedLocDic = [savedLocList objectAtIndex:savedLocPicker.selectedIndex];
        //저장위치
        [paramDic setObject:[savedLocDic objectForKey:@"LGORT"] forKey:@"LGORT"];
    }
    else
        [paramDic setObject:@"" forKey:@"LGORT"];
    
    //year picker 값
    [paramDic setObject:selectedYearPickerData forKey:@"GJAHR"];
    [paramDic setObject:selectedMonthPickerData forKey:@"ZZPI_IND"]; //mm
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_GET_DOC_NO withData:rootDic];
}

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

- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLocCode:locBarcode];
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

- (void)requestRepairReceiptIM
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GET_REPAIR_RECEIPT_IM;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:strFccBarCode forKey:@"BARCODE"];
    [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_GET_REPAIR_RECEIPT_IM withData:rootDic];
}

- (void)requestRepairReceipt:(NSString*)fccBarcode injuryBarcode:(NSString*)injuryBarcode reason:(NSString*)reason
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GET_REPAIR_RECEIPT;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:fccBarcode forKey:@"BARCODE"]; //newbarcode
    [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
    [paramDic setObject:injuryBarcode forKey:@"EXBARCODE"]; //훼손 바코드
    [paramDic setObject:reason forKey:@"RREASON"]; //교체 사유
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_GET_REPAIR_RECEIPT withData:rootDic];
}

- (void)requestSAPInfo:(NSString*)fccBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSAPInfo:fccBarcode locCode:locCode deviceID:deviceID  orgCode:@"" isAsynch:YES];
}

- (void)requestGridInfo:(NSString*)fccBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_REVISION_SAP_FCC;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (
        [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
        [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
        )
    {
        [paramDic setObject:@"D" forKey:@"I_TYPE"];
        if ([JOB_GUBUN isEqualToString:@"고장등록취소"])
            [paramDic setObject:@"1" forKey:@"I_STAT"];
        else
            [paramDic setObject:@"2" forKey:@"I_STAT"];
    }
    
    NSMutableArray* subParamList = [NSMutableArray array];
    NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
    if (
        [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
        [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
        ){
        [subParamDic setObject:fccBarcode forKey:@"BARCODE"];
        [subParamList addObject:subParamDic];
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    if (
        [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
        [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
        )
        [requestMgr asychronousConnectToServer:API_GET_FAILURE_LIST withData:rootDic];
    else
        [requestMgr asychronousConnectToServer:API_FAC_INQUERY withData:rootDic];
}

- (void)requestRemodelData
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_REMODEL_LIST;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
        
        [paramDic setObject:[NSDate TodayString] forKey:@"REQ_DATE"];
        [paramDic setObject:strLocBarCode forKey:@"I_LOCCODE"];
    }
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"])
        [requestMgr asychronousConnectToServer:API_GET_REMODEL_LIST withData:rootDic];
    else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
        [requestMgr asychronousConnectToServer:API_REMODEL_COMPLETE_LIST withData:rootDic];
}

- (void) requestIMSend //인스토어 마킹

{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND_REPAIR_IM;
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    //subParam 조립
    //grid형 선택한 셀만 전송
    NSMutableArray* subParamList = [NSMutableArray array];
    NSInteger count = 0;
    for (NSDictionary* dic in fccSAPList)
    {
        NSLog(@"subParamdic [%@]",dic);
        BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
        if (!isSelect)
            continue;
        
        if ([[dic objectForKey:@"injuryBarcode"] isEqualToString:@""])
            continue;
        
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        
        [subParamDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
        [subParamDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
        [subParamDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
        [subParamDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
        [subParamDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
        [subParamDic setObject:[dic objectForKey:@"itemCategoryCode"] forKey:@"itemCategoryCode"];
        [subParamDic setObject:[dic objectForKey:@"partKindCode"] forKey:@"partKindCode"];
        [subParamDic setObject:[dic objectForKey:@"itemLargeClassificationCode"] forKey:@"itemLargeClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemMiddleClassificationCode"] forKey:@"itemMiddleClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemSmallClassificationCode"] forKey:@"itemSmallClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemDetailClassificationCode"] forKey:@"itemDetailClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];
        [subParamDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];
        [subParamDic setObject:[dic objectForKey:@"supplierCode"] forKey:@"supplierCode"];
        [subParamDic setObject:[dic objectForKey:@"deptCode"] forKey:@"deptCode"];
        [subParamDic setObject:[dic objectForKey:@"operationDeptCode"] forKey:@"operationDeptCode"];
        [subParamDic setObject:[dic objectForKey:@"makerCode"] forKey:@"makerCode"];
        [subParamDic setObject:[dic objectForKey:@"makerSerial"] forKey:@"makerSerial"];
        [subParamDic setObject:@"" forKey:@"makerNational"];
        [subParamDic setObject:[dic objectForKey:@"obtainDay"] forKey:@"obtainDay"];
        [subParamDic setObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"generationRequestSeq"]] forKey:@"generationRequestSeq"];
        [subParamList addObject:subParamDic];
        count++;
    }
    if (count){
        NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
        NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
        
        [requestMgr asychronousConnectToServer:API_SEND_REPAIR_IM withData:rootDic];
    }else
        [self requestSend];
}


- (void) requestSurveySend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    //Param 조립
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
    [paramDic setObject:[dic objectForKey:@"GJAHR"] forKey:@"GJAHR"]; //회계년도
    [paramDic setObject:[dic objectForKey:@"IBLNR"] forKey:@"IBLNR"]; //문서번호
    [paramDic setObject:[dic objectForKey:@"ZEILI"] forKey:@"ZEILI"]; //항목번호
    
    //subParam 조립
    //grid형 선택한 셀만 전송
    sendCount = 0;
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in scanSAPList)
    {
        BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
        if (!isSelect)
            continue;
        
        if ([[dic objectForKey:@"IS_SEND"] isEqualToString:@"Y"])
            continue;
        
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        
        [subParamDic setObject:barcode forKey:@"BARCODE"];
        
        
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    if (sendCount == 0){
        NSString* message = @"전송할 항목이 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
        
    }
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SEND_PRODUCT_SURVEY withData:rootDic];
}

// 서버로 전송 --------------------------------------------------------------------------------------------------
- (void) requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    //Param 조립
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    if (
        [JOB_GUBUN isEqualToString:@"고장등록취소"] ||
        [JOB_GUBUN isEqualToString:@"수리의뢰취소"]
        ){
        [paramDic setObject:@"0010" forKey:@"WORKID"];
        [paramDic setObject:@"0430" forKey:@"PRCID"];
    }
    else if ([JOB_GUBUN isEqualToString:@"수리완료"]){
        [paramDic setObject:@"0470" forKey:@"PRCID"];
        [paramDic setObject:[NSDate TodayString] forKey:@"DATE_ENTERED"];
        [paramDic setObject:[NSDate TimeString] forKey:@"TIME_ENTERED"];
    }
    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
        [paramDic setObject:@"0011" forKey:@"WORKID"];
        [paramDic setObject:@"0590" forKey:@"PRCID"];
    }
    else if ([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]){
        [paramDic setObject:@"0011" forKey:@"WORKID"];
        [paramDic setObject:@"0595" forKey:@"PRCID"];
    }
    else if ([JOB_GUBUN isEqualToString:@"상품단말실사"]){
        [paramDic setObject:@"0595" forKey:@"GJAHR"];
        [paramDic setObject:@"0595" forKey:@"IBLNR"];
        [paramDic setObject:@"0595" forKey:@"ZEILI"];
    }
    else if ([JOB_GUBUN isEqualToString:@"S/N변경"]){
        [paramDic setObject:@"0017" forKey:@"WORKID"];
        [paramDic setObject:@"0240" forKey:@"PRCID"];
    }
    
    
    if (
        [JOB_GUBUN isEqualToString:@"개조개량완료"]
        )
    {
        [paramDic setObject:@"0765" forKey:@"PRCID"];
    }
    
    
    if (
        ![JOB_GUBUN isEqualToString:@"개조개량의뢰"] &&
        ![JOB_GUBUN isEqualToString:@"개조개량의뢰취소"] &&
        ![JOB_GUBUN isEqualToString:@"수리완료"] &&
        ![JOB_GUBUN isEqualToString:@"S/N변경"]
        )
    {
        if(!locBarcodeView.hidden && strLocBarCode.length){
            [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
            //위도,경도 헤더에 추가
            // GPS 위치조회 하지 않는 방법으로 변경. 16.11.22
//            if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
//                [ERPLocationManager getInstance].locationDic != nil){
//                NSDictionary* deltaDic = [ERPLocationManager getInstance].locationDic;
//                
//                NSString* longitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LONGTITUDE"] floatValue]];
//                NSString* latitude =  [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LATITUDE"] floatValue]];
//                
//                [paramDic setObject:longitude forKey:@"LONGTITUDE"];
//                [paramDic setObject:latitude forKey:@"LATITUDE"];
//                NSString* address = [WorkUtil getFullNameOfLoc:strLocFullName];
//                
//                double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:address];
//                [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
//            }else{
//                [paramDic setObject:@"" forKey:@"LONGTITUDE"];
//                [paramDic setObject:@"" forKey:@"LATITUDE"];
//                [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
//            }
        }
    }
    
    //subParam 조립
    //grid형 선택한 셀만 전송
    sendCount = 0;
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in fccSAPList)
    {
        BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
        if (!isSelect)
            continue;
        
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        NSString* partType = [dic objectForKey:@"PART_NAME"];
        
        
        if ([JOB_GUBUN isEqualToString:@"고장등록취소"])
        {
            [subParamDic setObject:barcode forKey:@"BARCODE"];
            [subParamDic setObject:@"3" forKey:@"DFLAG"];
            [subParamDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
            [subParamDic setObject:[dic objectForKey:@"REGNO"] forKey:@"DOCNO"]; //고장등록번호
            [subParamDic setObject:[dic objectForKey:@"REGNO"] forKey:@"REGNO"]; //고장등록번호
        }
        else if ([JOB_GUBUN isEqualToString:@"수리의뢰취소"]){
            [subParamDic setObject:barcode forKey:@"BARCODE"];
            [subParamDic setObject:@"3" forKey:@"DFLAG"];
            [subParamDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
            [subParamDic setObject:[dic objectForKey:@"LIFNR"] forKey:@"LIFNR"]; //협력사코드
            [subParamDic setObject:[dic objectForKey:@"QMNUM"] forKey:@"DOCNO"]; //수리의뢰번호
            [subParamDic setObject:[dic objectForKey:@"REGNO"] forKey:@"REGNO"]; //고장등록번호
        }
        else if (
                 [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
                 [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]
                 ){
            [subParamDic setObject:strLocBarCode forKey:@"LOCCODE"]; // 위치바코드
            [subParamDic setObject:barcode forKey:@"EQUIPMENT"]; // 바코드 번호
            [subParamDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MATNR"];     // 물품코드
        }
        else if ([JOB_GUBUN isEqualToString:@"개조개량완료"]){
            [subParamDic setObject:barcode forKey:@"BARCODE"];
            [subParamDic setObject:@"" forKey:@"DEVICEID"]; //장치바코드
            //to-do
            if ([dic objectForKey:@"ZMATGB"])
                [subParamDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"DEVTYPE"]; //ZPGUBUN
            else
                [subParamDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"DEVTYPE"];
            
            // 단품일 경우에는 부품종류가 null 로 정의되어 있기 때문에 SAP에서 처리 시 오류 발생 가능성이 있습니다.
            // 이에 유동처리(탈장, 실장, 입고, 출고, 송부, 접수) 시 단품일 경우에는 부품종류(PARTTYPE) 를 '99' 로 지정하여
            // SAP 로 I/F 해 주시기 바랍니다. 처리 완료시 Test를 위해 Feedback 부탁 드리겠습니다.
            // request by 강준석 2012.02.20
            
            if ([partType isEqualToString:@"E"] || [partType isEqualToString:@"Equipment"])
                [subParamDic setObject:@"99" forKey:@"PARTTYPE"];
            else{
                if ([dic objectForKey:@"ZPPART"] != nil && ![[dic objectForKey:@"ZPPART"] isEqualToString:@""]){
                    [subParamDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"PARTTYPE"]; //part_name -> code
                }
                else{
                    [subParamDic setObject:[dic objectForKey:@"COMPTYPE"] forKey:@"PARTTYPE"]; //part_name -> code
                }
            }
            
            for (NSDictionary* remodelDic in remodelList)
            {
                NSString* remodelBarcode = [remodelDic objectForKey:@"EQUNR"];
                NSString* upgradeBarcode = [remodelDic objectForKey:@"UPGEQUNR"];
                if (!upgradeBarcode.length){
                    if ([barcode isEqualToString:remodelBarcode]){
                        [subParamDic setObject:remodelBarcode forKey:@"EQUIPMENT"];
                        [subParamDic setObject:upgradeBarcode forKey:@"UPGEQUNR"];
                    }
                }
                else {
                    if ([barcode isEqualToString:upgradeBarcode]){
                        [subParamDic setObject:remodelBarcode forKey:@"EQUIPMENT"];
                        [subParamDic setObject:upgradeBarcode forKey:@"UPGEQUNR"];
                    }
                }
            }
            [subParamDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"KOSTL"];
            
        }
        else if ([JOB_GUBUN isEqualToString:@"수리완료"]){
            [subParamDic setObject:[dic objectForKey:@"EXBARCODE"] forKey:@"EXBARCODE"]; //기존바코드 (바코드 대체시 활용)
            [subParamDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"]; //위치바코드(21자리)
            [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"]; //신규바코드 (Scan 된 바코드)
            [subParamDic setObject:[dic objectForKey:@"RREASON"] forKey:@"RREASON"]; //대체발행사유
            [subParamDic setObject:[dic objectForKey:@"QMNUM"] forKey:@"DOCNO"]; //수리의뢰번호
        }
        else if ([JOB_GUBUN isEqualToString:@"S/N변경"]){
            [subParamDic setObject:barcode forKey:@"BARCODE"];
            [subParamDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"KOSTL"];
            [subParamDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"PARTTYPE"];
            [subParamDic setObject:[dic objectForKey:@"SERGE"] forKey:@"SERGE"];
            [subParamDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [subParamDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"DEVTYPE"];
        }
        
        NSString* checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
        if (![JOB_GUBUN isEqualToString:@"수리완료"] && ![JOB_GUBUN isEqualToString:@"S/N변경"])
        {
            if ([checkOrgValue hasPrefix:@"N"]) {
                [subParamDic setObject:@"X" forKey:@"CHKZKOSTL"]; //조직변경 안함
                
            }
            else
                [subParamDic setObject:@"" forKey:@"CHKZKOSTL"]; //조직변경
            //개조개량완료 물품에서 가져오므로 조직값없음
        }
        if (!fccStatusView.hidden)
            [subParamDic setObject:[WorkUtil getFacilityStatusCode:selPickerData] forKey:@"ZPSTATU"]; // 피커선택값
        
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    if ([JOB_GUBUN isEqualToString:@"고장등록취소"])
        [requestMgr asychronousConnectToServer:API_SEND_FAILURE_REG_CANCEL withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"수리의뢰취소"])
        [requestMgr asychronousConnectToServer:API_SEND_REPAIR_REG_CANCEL withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"개조개량의뢰"])
        [requestMgr asychronousConnectToServer:API_SEND_REMODEL_NEW withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"개조개량의뢰취소"])
        [requestMgr asychronousConnectToServer:API_SEND_REMODEL_NEW withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"개조개량완료"])
        [requestMgr asychronousConnectToServer:API_SEND_REVISE_DONE withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"수리완료"])
        [requestMgr asychronousConnectToServer:API_SEND_REPAIR_DONE withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"S/N변경"])
        [requestMgr asychronousConnectToServer:API_SN_CHANGE_STATUS withData:rootDic];
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
        if (pid == REQUEST_LOC_COD)
            [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:@""];
        
        isOperationFinished = YES;
        return;
    }else if (status == -1){ //세션종료
        isOperationFinished = YES;
        
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
        
        return;
    }
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == REQUEST_OTD){
        [self processOTDResponse];
    }else if (pid == REQUEST_PRODUCT_SURVEY_LIST){
        [self processProductSurbeyListResponse:resultList];
    }else if (pid == REQUEST_PRODUCT_SURVEY_SCAN_LIST){
        [self processProductSurveyScanListResponse:resultList];
    }else if (pid == REQUEST_SAVE_LOCATION){
        [self processSaveLocationResponse:resultList];
    }else if (pid == REQUEST_SEND){
        [self processSendResponse:resultList statusCode:status];
    }else if (pid == REQUEST_GET_DOC_NO){
        [self processGetDocNoResponse:resultList];
    }else if (pid == REQUEST_GET_PLANT){
        [self processGetPlantResponse:resultList];
    }else if (pid == REQUEST_ITEM_FCC_COD){
        [self processFccItemInfoResponse:resultList];
    }else if (pid == REQUEST_GET_REPAIR_RECEIPT_IM){
        [self processGetRepairReceiptIMResponse:resultList];
    }else if (pid == REQUEST_GET_REPAIR_RECEIPT){
        [self processGetRepairRceipt:resultList];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPInfoResponse:resultList];
    }else if (pid == REQUEST_REVISION_SAP_FCC){
        [self processRevisionSAPFccResponse:resultList];
    }else if (pid == REQUEST_REMODEL_LIST){
        [self processRemodelListResponse:resultList];
    }else if (pid == REQUEST_SEND_REPAIR_IM){
        [self processSendProductSurveyResponse:resultList];
    }else        isOperationFinished = YES;
    
}

- (void)processOTDResponse
{
    if (
        [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
        [JOB_GUBUN isEqualToString:@"개조개량완료"]
        ){
        [self requestRemodelData];
    }
    
    
    [workDic setObject:strLocBarCode forKey:@"LOC_CD"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"L" forKey:@"TASK"];
    [taskDic setObject:strLocBarCode forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    isOperationFinished = YES;
}

- (void)processProductSurbeyListResponse:(NSArray*)resultList
{
    if ([resultList count]){
        for (NSDictionary* dic in resultList)
        {
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* BUCHM = [[dic objectForKey:@"BUCHM"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString* MENGE = [[dic objectForKey:@"MENGE"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString* CHARG = [[dic objectForKey:@"CHARG"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [sapDic setObject:BUCHM forKey:@"BUCHM"];
            [sapDic setObject:CHARG forKey:@"CHARG"];
            [sapDic setObject:[dic objectForKey:@"GJAHR"] forKey:@"GJAHR"];
            [sapDic setObject:[dic objectForKey:@"IBLNR"] forKey:@"IBLNR"];
            [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"MATNR"] forKey:@"MATNR"];
            [sapDic setObject:[dic objectForKey:@"MEINS"] forKey:@"MEINS"];
            [sapDic setObject:MENGE forKey:@"MENGE"];
            [sapDic setObject:[dic objectForKey:@"ZEILI"] forKey:@"ZEILI"];
            //선택상태 추가
            [fccSAPList addObject:sapDic];
        }
        [self reloadTables];
        [self showCount];
        [self scrollToFirstPage];
    }
    else {
        NSString* msg = @"실사자료가 존재하지 않습니다.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
}

- (void)processProductSurveyScanListResponse:(NSArray*)resultList
{
    if ([resultList count]){
        //BARCODE Y로 설정 row add
        for (NSDictionary* dic in resultList)
        {
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* barcode = [dic objectForKey:@"BARCODE"];
            [sapDic setObject:barcode forKey:@"EQUNR"];
            [sapDic setObject:@"Y" forKey:@"IS_SEND"];
            [scanSAPList addObject:sapDic];
        }
        [_tableScan reloadData];
    }
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
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
        selectedSavedLocPickerData = strSavedLoc;
        
        savedLocPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:pickerList];
        savedLocPicker.delegate = self;
        [self requestDocNo];
    }
    else {
        NSString* msg = @"저장위치가 존재하지 않습니다.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void)processGetDocNoResponse:(NSArray*)resultList
{
    if ([resultList count]){
        //IBLNR:GJAHR 콤보박스에 추가
        docNoList = resultList;
        NSMutableArray* pickerList = [NSMutableArray array];
        for (NSDictionary* dic in docNoList)
        {
            NSString* strAddData = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"IBLNR"],[dic objectForKey:@"GJAHR"]];
            [pickerList addObject:strAddData];
        }
        NSString* strDocNo = [pickerList objectAtIndex:0];
        lblDocNo.text = strDocNo;
        selectedDocNoPickerData = strDocNo;
        
        docPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:pickerList];
        docPicker.delegate = self;
    }
    else {
        NSString* msg = @"실사문서가 존재하지 않습니다.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil];
    }
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
        selectedPlantPickerData = strPlant;
        
        plantPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:pickerList];
        plantPicker.delegate = self;
        [self requestSaveLocation];
        
        //task추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"P" forKey:@"TASK"];
        [taskDic setObject:strUserOrgCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* msg = @"플랜트가 존재하지 않습니다.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    isOperationFinished = YES;
}

- (void)processLocList:(NSArray*)locList
{
    if ([locList count]){
        NSDictionary* dic  = [locList objectAtIndex:0];
        NSString* roomTypeCode = [dic objectForKey:@"roomTypeCode"];
        NSString* operationSystemCode = [dic objectForKey:@"operationSystemCode"];
        NSString* deviceID = [dic objectForKey:@"deviceId"];
        
        [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:[dic objectForKey:@"locationShortName"]];
        strLocFullName = [[locList objectAtIndex:0] objectForKey:@"locationFullName"];
        
        
        //3. 개조개량 의뢰 : ERPBarcode에 서 생성한 가상위치 중 창고유형 ‘06’에 대해서만 허용(다른 Type 불허)
        if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"])
        {
            if (![roomTypeCode isEqualToString:@"06"]){
                NSString* message = @"'업체창고' 위치바코드를\n스캔하세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                strDecryptLocBarCode = strLocBarCode = @"";
                [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:@""];
                
                isOperationFinished = YES;
                return;
            }
        }
        
        //4. 개조개량 완료 : 초기화면은 멀티입고(입고화면), 사용자사 Scan한 위치가 MDM에서 I/F 받은 위치이면 실장 화면
        //그렇지 않고 ERPBarcode에서 생성한 가상창고이면 멀티입고(입고화면)(단, 창고유형 ‘04’, ‘05’ 만 허용
        // '06' 업체창고 추가 - request by 박장수 2012.07.10
        
        else if (
                 [JOB_GUBUN isEqualToString:@"개조개량완료"] ||
                 [JOB_GUBUN isEqualToString:@"수리완료"]
                 //[JOB_GUBUN isEqualToString:@"접수(팀간)"]
                 )
        {
            if ([strLocBarCode hasPrefix:@"VS"]){
                if (
                    ![roomTypeCode isEqualToString:@"04"] &&
                    ![roomTypeCode isEqualToString:@"05"] &&
                    ![roomTypeCode isEqualToString:@"06"]
                    ) {
                    NSString* message = @"'KT창고' 또는 '재활용창고'\n위치바코드를 스캔하세요.";
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                    
                    strDecryptLocBarCode = @"";
                    isOperationFinished = YES;
                    return;
                }
            }
        }
        
        if (txtLocCode.text.length == 9) {//장치바코드
            txtDeviceID.text = txtLocCode.text;
            txtLocCode.text = strLocBarCode;
        }
        else if (txtLocCode.text.length <= 10) {
            txtLocCode.text = strLocBarCode;
        }
        
        if (deviceID.length){
            txtDeviceID.text = deviceID;
            strDeviceID = txtDeviceID.text;
        }
        
        if (operationSystemCode.length)
            lblDeviceID.text = operationSystemCode;
        
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        
        // OTD 물류센터 위치바코드 Validation
        if (![JOB_GUBUN isEqualToString:@"배송출고"]){
            [self requestAuthLocation:strLocBarCode];
        }else
            isOperationFinished = YES;
    }
    else { //
        NSString* message = @"검색된 위치바코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        strDecryptLocBarCode = @"";
        
        isOperationFinished = YES;
    }
}

- (void)processFccItemInfoResponse:(NSArray*)resultList
{
    if ([resultList count]){
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        BOOL isAdd = NO;
        
        if (!fccSAPList.count)
            isAdd = YES;
        for (NSDictionary* dic in resultList) {
            
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            NSString* compType;
            if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
                compType = @"";
            else
                compType = [dic objectForKey:@"COMPTYPE"];
            [sapDic setObject:compType forKey:@"COMPTYPE"];
            NSString* partTypeName = [WorkUtil getPartTypeFullName:compType device:[dic objectForKey:@"ZMATGB"]];
            [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            [sapDic setObject:strFccBarCode forKey:@"EQUNR"];
            [sapDic setObject:@"" forKey:@"ZPSTATU"];
            NSString* barcodeName = [dic objectForKey:@"MAKTX"];
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
            [sapDic setObject:barcodeName forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"ZMATGB"];
            [sapDic setObject:[dic objectForKey:@"MATNR"] forKey:@"MATNR"];
            [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
            [sapDic setObject:@"" forKey:@"HEQUNR"];
            [sapDic setObject:@"" forKey:@"ZPPART"];
            [sapDic setObject:@"1" forKey:@"LEVEL"];
            [sapDic setObject:@"" forKey:@"ZKOSTL"];
            [sapDic setObject:@"" forKey:@"ZKTEXT"];
            [sapDic setObject:@"3" forKey:@"SCANTYPE"];
            //add
            [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            [fccSAPList addObject:sapDic];
        }
        if (isAdd){
            nSelectedRow = fccSAPList.count - 1;
            
            //레코드 첫번째 행 선택
            NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
            lblPartType.text = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
        }
        
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    [self reloadTables];
    [self showCount];
    [self scrollToFirstPage];
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    [self scrollToIndex:nSelectedRow];
}

- (void)processGetRepairReceiptIMResponse:(NSArray*)resultList
{
    //수리완료일 경우에만 온다.
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSString* injuryBarcode = [dic objectForKey:@"injuryBarcode"]; // 회손바코드
        NSString* newBarcode = [dic objectForKey:@"newBarcode"]; // 신규바코드
        NSString* replaceReason = [dic objectForKey:@"publicationWhyCode"]; // 교체사유
        if (injuryBarcode.length && newBarcode.length) {
            IM_dic = dic;
        }
        [self requestRepairReceipt:newBarcode injuryBarcode:injuryBarcode reason:replaceReason];
    }
}

- (void)processGetRepairRceipt:(NSArray*)resultList
{
    if ([resultList count]){
        for (NSDictionary* dic in resultList)
        {
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            [sapDic setObject:[dic objectForKey:@"BARCODE"] forKey:@"EQUNR"];
            [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [sapDic setObject:[dic objectForKey:@"EQKTX"] forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
            [sapDic setObject:[dic objectForKey:@"ZEQUIPLPT"] forKey:@"ZEQUIPLPT"]; //위치내역
            [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [sapDic setObject:[dic objectForKey:@"URCODN"] forKey:@"URCODN"]; //원인코드명
            [sapDic setObject:[dic objectForKey:@"MNCODN"] forKey:@"MNCODN"]; //수리코드명
            [sapDic setObject:[dic objectForKey:@"EXBARCODE"] forKey:@"EXBARCODE"]; //기존바코드
            [sapDic setObject:[dic objectForKey:@"QMNUM"] forKey:@"QMNUM"]; //수리의뢰번호(통지번호)
            [sapDic setObject:[dic objectForKey:@"FECOD"] forKey:@"FECOD"]; //고장코드
            [sapDic setObject:[dic objectForKey:@"RREASON"] forKey:@"RREASON"]; //대체발행 사유
            //add new key
            NSString* partTypeName = [WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            ///////////////////
            if (IM_dic.count){
                [sapDic setObject:[IM_dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
                [sapDic setObject:[IM_dic objectForKey:@"locationCode"] forKey:@"locationCode"];
                [sapDic setObject:[IM_dic objectForKey:@"deviceId"] forKey:@"deviceId"];
                [sapDic setObject:[IM_dic objectForKey:@"itemCode"] forKey:@"itemCode"];
                [sapDic setObject:[IM_dic objectForKey:@"itemName"] forKey:@"itemName"];
                [sapDic setObject:[IM_dic objectForKey:@"itemCategoryCode"] forKey:@"itemCategoryCode"];
                [sapDic setObject:[IM_dic objectForKey:@"itemCategoryName"] forKey:@"itemCategoryName"];
                [sapDic setObject:[IM_dic objectForKey:@"partKindCode"] forKey:@"partKindCode"];
                [sapDic setObject:[IM_dic objectForKey:@"partKindName"] forKey:@"partKindName"];
                [sapDic setObject:[IM_dic objectForKey:@"itemLargeClassificationCode"] forKey:@"itemLargeClassificationCode"];
                [sapDic setObject:[IM_dic objectForKey:@"itemMiddleClassificationCode"] forKey:@"itemMiddleClassificationCode"];
                [sapDic setObject:[IM_dic objectForKey:@"itemSmallClassificationCode"] forKey:@"itemSmallClassificationCode"];
                [sapDic setObject:[IM_dic objectForKey:@"itemDetailClassificationCode"] forKey:@"itemDetailClassificationCode"];
                [sapDic setObject:[IM_dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];
                [sapDic setObject:[IM_dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];
                [sapDic setObject:[IM_dic objectForKey:@"supplierCode"] forKey:@"supplierCode"];
                [sapDic setObject:[IM_dic objectForKey:@"deptCode"] forKey:@"deptCode"];
                [sapDic setObject:[IM_dic objectForKey:@"operationDeptCode"] forKey:@"operationDeptCode"];
                [sapDic setObject:[IM_dic objectForKey:@"makerCode"] forKey:@"makerCode"];
                [sapDic setObject:[IM_dic objectForKey:@"makerSerial"] forKey:@"makerSerial"];
                //                                [sapDic setObject:[IM_dic objectForKey:@"makerNational"] forKey:@"makerNational"];    // SAP에서 날아오지 않음
                [sapDic setObject:[IM_dic objectForKey:@"obtainDay"] forKey:@"obtainDay"];
                [sapDic setObject:[IM_dic objectForKey:@"generationRequestSeq"] forKey:@"generationRequestSeq"];
                
            }else   // Send시 injuryBarcode로 인스토어마킹 전송여부를 결정하기 때문에 반드시 필요한 필드이다
                [sapDic setObject:@"" forKey:@"injuryBarcode"];
            //////////////////////
            [fccSAPList addObject:sapDic];
        }
        [self reloadTables];
        [self showCount];
        [self scrollToFirstPage];
        
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    else {
        NSString* message = @"조회된 정보가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
    isOperationFinished = YES;
}

- (void)processSAPInfoResponse:(NSArray*)resultList
{
    if ([resultList count]){
        
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
        
        BOOL isAdd = NO;
        if (fccSAPList.count)   isAdd = YES;
        
        int i = 0;
        for (NSDictionary* dic in resultList)
        {
            NSString* barcode = [dic objectForKey:@"EQUNR"];
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            
            if (
                [JOB_GUBUN isEqualToString:@"개조개량의뢰"] ||
                [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]
                )
            {
                NSString* ZKEQUI = [dic objectForKey:@"ZKEQUI"]; // 설비처리구분 : B - 부외실물, N - 일반물자, M - 부외실물(제조사물자 체크)
                NSString* ZANLN1 = [dic objectForKey:@"ZANLN1"]; //자산번호
                
                if ([ZKEQUI isEqualToString:@"M"])
                {
                    NSString* message = [NSString stringWithFormat:@"'제조사물자'인 설비바코드는\n'%@' 작업을\n하실 수 없습니다.", JOB_GUBUN];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
                    
                    return;
                }
                
                if (
                    ![ZKEQUI isEqualToString:@"B"] &&
                    !ZANLN1.length
                    )
                {
                    NSString* message = [NSString stringWithFormat:@"자산화가 안 된 설비바코드는\n'%@' 작업을\n하실 수 없습니다.",JOB_GUBUN];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                    
                    return;
                }
                
                if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
                    BOOL errorFlag = YES;
                    NSString* SUBMT = [dic objectForKey:@"SUBMT"];
                    NSLog(@"개조개량의뢰 remodelList [%@]",remodelList);
                    for(NSDictionary* remodelDic in remodelList)
                    {
                        NSString* remodel_SUBMT = [remodelDic objectForKey:@"MATNR"];
                        if ([SUBMT isEqualToString:remodel_SUBMT]){
                            errorFlag = NO;
                            break;
                        }
                    }
                    if (errorFlag){
                        NSString* message = @"'개조개량의뢰' 대상 물품코드가 아닙니다.";
                        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                        
                        return;
                    }
                }
            }
            
            [sapDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];//설비바코드
            [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [sapDic setObject:[dic objectForKey:@"ZDESC"] forKey:@"ZDESC"];
            [sapDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"]; //deviceID
            [sapDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];
            [sapDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];
            [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [sapDic setObject:[dic objectForKey:@"SERGE"] forKey:@"SERGE"];
            
            NSString* partTypeName = [WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            
            //새롭게 만들어준 키값
            
            if ([partTypeName length])
                [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [sapDic setObject:@"" forKey:@"PART_NAME"];
            
            if (isAdd){
                [sapDic setObject:@"2" forKey:@"SCANTYPE"];
            }else{
                if ([barcode isEqualToString:strFccBarCode])
                    [sapDic setObject:@"3" forKey:@"SCANTYPE"]; //최초 스캔
                else
                    [sapDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
            }
            
            //선택상태 추가
            [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            
            //조직체크 추가
            NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
            NSString* orgName = [dic objectForKey:@"ZKTEXT"];
            NSString* checkOrgValue = nil;
            
            if (
                //[JOB_GUBUN isEqualToString:@"실장"] ||
                [JOB_GUBUN isEqualToString:@"개조개량완료"] ||
                [JOB_GUBUN isEqualToString:@"수리완료"]
                )
            {
                // 유닛이나 쉘프 실장은 전송 직전에 운용조직 변경 여부 물어 본다. 상속 받으면 물어 보지 않는다.
                //조직 체크값 관리 ORG_CHECK_VALUE
                if ([partTypeName isEqualToString:@"U"] || [partTypeName isEqualToString:@"S"]){
                    checkOrgValue = [NSString stringWithFormat:@"_%@_%@",orgCode,orgName];
                    [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
                }
                
            }
            else
            {
                if ([strUserOrgCode isEqualToString:orgCode])
                {
                    checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
                    
                }
                else {
                    checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
                    
                }
                
                [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
                
            }
            
            [fccSAPList addObject:sapDic];
            if (isAdd){
                nSelectedRow = fccSAPList.count - 1;
            }
            i++;
            [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
            isDataSaved = NO;
        }
        
        //레코드 첫번째 행 선택
        NSDictionary* dic = [fccSAPList objectAtIndex:0];
        lblPartType.text = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
        
        [self reloadTables];
        [self showCount];
        [self scrollToIndex:nSelectedRow];
        [self scrollToFirstPage];
        
        [self processCheckOrganization:[resultList objectAtIndex:0]];
        
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        
    }
    else {
        NSString* message = @"존재하지 않는 설비바코드입니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    
    if([JOB_GUBUN isEqualToString:@"S/N변경"]){
        [self performSelectorOnMainThread:@selector(snBecameFirstResponder) withObject:nil waitUntilDone:NO];
    }
    else{
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    }
    
    isOperationFinished = YES;
}

- (void)processRevisionSAPFccResponse:(NSArray*)resultList
{
    //고장의뢰취소 || 수리의뢰 취소일경우만 호출된다.
    if ([resultList count]){
        NSDictionary* firstDic = [resultList objectAtIndex:0];
        
        //장비상태 체크
        NSString* status = [firstDic objectForKey:@"ZPSTATU"];
        NSString* desc = [firstDic objectForKey:@"ZSTATUN"];
        NSString* submt = [firstDic objectForKey:@"SUBMT"];
        
        NSString* errorMessage = [WorkUtil processCheckFccStatus:status desc:desc submt:submt];
        if (errorMessage.length){
            [self showMessage:errorMessage tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            isOperationFinished = YES;
            return;
        }
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        [self processCheckOrganization:firstDic];
        BOOL isAdd = NO;
        
        if (fccSAPList.count)   isAdd = YES;
        
        for (NSDictionary* dic in resultList) {
            NSString* barcode = [dic objectForKey:@"BARCODE"];
            NSString* barcodeName = [dic objectForKey:@"EQKTX"];
            NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            
            //새롭게 만들어준 키값
            if ([partTypeName length])
                [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [sapDic setObject:@"" forKey:@"PART_NAME"];
            
            [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            
            [sapDic setObject:barcode forKey:@"EQUNR"]; //BARCODE -> EQUNR
            [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
            if (barcodeName.length)
                [sapDic setObject:barcodeName forKey:@"MAKTX"];
            else
                [sapDic setObject:@"" forKey:@"MAKTX"];
            
            [sapDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
            [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapDic setObject:[dic objectForKey:@"EXBARCODE"] forKey:@"HEQUNR"];
            [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];
            [sapDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];
            [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [sapDic setObject:[dic objectForKey:@"FECOD"] forKey:@"FECOD"]; //고장코드
            [sapDic setObject:[dic objectForKey:@"FECODN"] forKey:@"FECODN"]; //고장명
            [sapDic setObject:[dic objectForKey:@"QMNUM"] forKey:@"QMNUM"]; // 수리의뢰번호
            [sapDic setObject:[dic objectForKey:@"REGNO"] forKey:@"REGNO"]; // 고장등록번호
            [sapDic setObject:[dic objectForKey:@"LIFNR"] forKey:@"LIFNR"]; // 협력사코드
            [sapDic setObject:[dic objectForKey:@"LIFNRN"] forKey:@"LIFNRN"]; // 협력사명
            
            //add 값
            if (isAdd){
                [sapDic setObject:@"2" forKey:@"SCANTYPE"];
            }else{
                if ([barcode isEqualToString:strFccBarCode])
                    [sapDic setObject:@"3" forKey:@"SCANTYPE"]; //최초 스캔
                else
                    [sapDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
            }
            
            //조직체크 추가
            NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
            NSString* orgName = [dic objectForKey:@"ZKTEXT"];
            NSString* checkOrgValue = nil;
            if (isOrgChanged) //운용 조직변경한 경우
            {
                checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
            }
            else {
                checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
            }
            
            [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
            
            //선택상태 추가
            [sapDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            [fccSAPList addObject:sapDic];
        }
        
        nSelectedRow = fccSAPList.count - 1;
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        //레코드 첫번째 행 선택
        NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
        lblPartType.text = [dic objectForKey:@"PART_NAME"];
        
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    [self reloadTables];
    [self showCount];
    [self scrollToIndex:nSelectedRow];
    
    isOperationFinished = YES;
}

- (void)processRemodelListResponse:(NSArray*)resultList
{
    if ([resultList count]){
        remodelList = [NSMutableArray array];
        for (NSDictionary* dic in resultList)
        {
            NSMutableDictionary* remodelDic = [NSMutableDictionary dictionary];
            if ([JOB_GUBUN isEqualToString:@"개조개량의뢰"])
            {
                [remodelDic setObject:[dic objectForKey:@"MATNR"] forKey:@"MATNR"]; // 자재번호
                UPGDOC = [dic objectForKey:@"UPGDOC"];
                [remodelDic setObject:UPGDOC forKey:@"UPGDOC"]; // 개조개량지시서번호
                
            }
            else if ([JOB_GUBUN isEqualToString:@"개조개량완료"])
            {
                [remodelDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"]; //개조전바코드
                [remodelDic setObject:[dic objectForKey:@"UPGEQUNR"] forKey:@"UPGEQUNR"]; //개조후바코드
            }
            [remodelList addObject:remodelDic];
        }
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"R" forKey:@"TASK"];  //remodel request
        [taskDic setObject:strLocBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
        
        isOperationFinished = YES;
    }
}

- (void)processSendProductSurveyResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        sleep(1.0);
        
        [self requestSend];
    }
}

- (void)processSendResponse:(NSArray*)resultList statusCode:(NSInteger)statusCode
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSString* result = [dic objectForKey:@"E_RSLT"];
        NSString* message = [dic objectForKey:@"E_MESG"];
        
        [workDic setObject:result forKey:@"TRANSACT_YN"];
        [workDic setObject:message forKey:@"TRANSACT_MSG"];
        [self saveToWorkDB];
        isDataSaved = YES;
        
        if ([result isEqualToString:@"S"]){
            message = [NSString stringWithFormat:@"# 전송건수 : %d건\n%d-%@",(int)sendCount,(int)statusCode,message];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            [self touchInitBtn];
        }
    }
}

@end

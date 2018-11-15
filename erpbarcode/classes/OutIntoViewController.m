//
//  OutIntoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 9..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "OutIntoViewController.h"
#import "OrgSearchViewController.h"
#import "FccInfoViewController.h"
#import "CommonCell.h"
#import "WBSListViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ERPLocationManager.h"
#import "ZoomPicViewController.h"
#import "ERPAlert.h"
#import <objc/runtime.h>
#import "AddInfoViewController.h"
#import "GridColumnRepairCell.h"
#import "GwlenListController.h"
#import "AppDelegate.h"

@interface OutIntoViewController ()
{
    const char* key;
}
@property(nonatomic,strong) IBOutlet UIView* orgView;
@property(nonatomic,strong) IBOutlet UIView* locBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* locNameView;
@property(nonatomic,strong) IBOutlet UIView* fccBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* fccStatusView;
@property(nonatomic,strong) IBOutlet UIView* sendOrgView;
@property(nonatomic,strong) IBOutlet UIView* curdView;
@property(nonatomic,strong) IBOutlet UIView* deviceIDView;
@property(nonatomic,strong) IBOutlet UIView* deviceInfoView;
@property(nonatomic,strong) IBOutlet UIView* upperFacView;
@property(nonatomic,strong) IBOutlet UIView* uuView;
@property(nonatomic,strong) IBOutlet UITextView* failureContentView;
@property(nonatomic,strong) IBOutlet UIView* failureFccView;
@property(nonatomic,strong) IBOutlet UIView* failureDevView;
@property(nonatomic,strong) IBOutlet UIView* receivedOrgView;
@property(nonatomic,strong) IBOutlet UITextField* txtLocCode;
@property(nonatomic,strong) IBOutlet UITextField* txtFacCode;
@property (strong, nonatomic) IBOutlet UILabel *lblUFacCode;
@property(nonatomic,strong) IBOutlet UITextField* txtUFacCode;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceIDTitle;
@property(nonatomic,strong) IBOutlet UITextField* txtDeviceID;
@property(nonatomic,strong) IBOutlet UITextView* txtViewFailure;
@property (strong, nonatomic) IBOutlet UIButton *btnPicture;
@property (strong, nonatomic) IBOutlet UIView *deliveryOrderView;
@property (strong, nonatomic) IBOutlet UIButton *btnDeliveryOreder;

//@property(nonatomic,strong) IBOutlet UITextField* txtDeviceInfo;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollDeviceInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceInfo;
@property(nonatomic,strong) IBOutlet UILabel* lblDeviceID;
@property(nonatomic,strong) IBOutlet UILabel* lblPartType;
@property(nonatomic,strong) IBOutlet UILabel* lblUpperPartType;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollReceivedOrg;
@property(nonatomic,strong) IBOutlet UILabel* lblReceivedOrg;
@property(nonatomic,strong) IBOutlet UILabel* lblReceivedTitle;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UITableView* _tableView2;
@property(nonatomic,strong) IBOutlet UIButton* btnDelete;
@property(nonatomic,strong) IBOutlet UIButton* btnUU;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnZoomPic;
@property (strong, nonatomic) IBOutlet UIView *shapeView;
@property (strong, nonatomic) IBOutlet UIButton *btnHierachy;
@property (strong, nonatomic) IBOutlet UIButton *btnMove;
@property (strong, nonatomic) IBOutlet UIButton *btnInit;
@property (strong, nonatomic) IBOutlet UIView *shapeOrderView;
@property (strong, nonatomic) IBOutlet UIView *moveCurdView;

@property(nonatomic,strong) NSString* CHKZKOSTL_INSTCONF;
@property(nonatomic,strong) NSString* strUserOrgCode;
@property(nonatomic,strong) NSString* strUserOrgName;
@property(nonatomic,strong) NSString* strUserOrgTypeCode;
@property(nonatomic,strong) NSString* strLocBarCode;
@property(nonatomic,strong) NSString* strFccBarCode;
@property(nonatomic,strong) NSString* strMoveBarCode;
@property(nonatomic,strong) NSString* strUpperBarCode;
@property(nonatomic,strong) NSString* strDeviceID;
@property(nonatomic,strong) NSString* strParentBarCode;
@property(nonatomic,strong) NSString* strOperSystemCode;
@property(nonatomic,strong) NSString* strUserOrgType;
@property(nonatomic,strong) NSString* strBusinessNumber;
@property(nonatomic,strong) NSMutableArray* locResultList;
@property(nonatomic,strong) NSMutableArray* wbsResultList;
@property(nonatomic,strong) NSMutableArray* fccResultList;
@property(nonatomic,strong) NSMutableArray* originalSAPList;
@property(nonatomic,strong) NSMutableArray* fccSAPList;
@property(nonatomic,strong) NSMutableArray* fccMoveList;
@property(nonatomic,strong) NSArray* plantList;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) CustomPickerView* picker;
@property(nonatomic,strong) CustomPickerView* plantPicker;
@property (strong, nonatomic) IBOutlet UIView *viewPictureButton;


@property(nonatomic,strong) UIBarButtonItem* rightBarItem;
@property(nonatomic,strong) IBOutlet UIButton* btnScan;
@property (strong, nonatomic) IBOutlet UILabel *lblScan;
@property(nonatomic,strong) IBOutlet UIButton* btnPicker;
@property (strong, nonatomic) IBOutlet UILabel *lblFccStatus;
@property(strong,nonatomic) UIImage* defaultImage;
@property (strong, nonatomic) IBOutlet UILabel *lblLoc;
@property (strong, nonatomic) IBOutlet UIView *moveView;

@property(nonatomic,strong) IBOutlet UIButton* btnDetailFccInfo;
@property(nonatomic,strong) NSString* selectedPickerData;
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,assign) NSInteger sendCount;
@property(nonatomic,assign) BOOL isRequireLocCode;
@property(nonatomic,assign) BOOL isOrgInheritance;
@property(nonatomic,assign) BOOL isOrgChanged;
@property(nonatomic,assign) BOOL isOrgChanged_Quit;
@property(nonatomic,assign) BOOL isSendOrgChecked;
@property(nonatomic,assign) BOOL isFirstMove;
@property(nonatomic,assign) BOOL isOffLine;
@property(nonatomic, assign) BOOL isSelPicView;
@property(nonatomic,assign) BOOL isMove;
@property(nonatomic,assign) NSInteger successCount;
@property(nonatomic,assign) NSInteger failCount;

@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) NSString* upper_deviceID;
@property(nonatomic,strong) NSString* upper_OperOrgName;
@property(nonatomic,strong) NSString* upper_OperOrgCode;
@property(nonatomic,strong) NSString* first_FccOrgCode;
@property(nonatomic,strong) NSString* first_FccOrgName;
@property(nonatomic,strong) NSDictionary* receivedOrgDic;
@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,assign) BOOL isDataSaved;   // 저장했는지 여부..  초기화 하면 NO 저장하면 YES
@property(nonatomic,strong) NSArray* firstFccSAPList;
@property(nonatomic,strong) UILabel* lblCount;
@property(nonatomic,strong) IBOutlet UILabel* lblPicker;
@property(nonatomic,strong) UILongPressGestureRecognizer* longPressGesture;
@property(nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property(strong, nonatomic) IBOutlet UIView *wbsView;
@property(strong, nonatomic) IBOutlet UILabel *lblWBSNo;
@property(nonatomic,strong) NSMutableDictionary* uniqueOrgDic;
@property(nonatomic,strong) NSMutableArray* uniqueOrgList;
@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) BOOL isUploadOneImageFinished;

@property(assign, nonatomic)int pwSendType;
@property(nonatomic, strong) NSString* deviceLocCd;
@property(nonatomic, strong) NSString* deviceLocNm;

@property (strong, nonatomic) IBOutlet scrollTouch *scrollMaktx;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollDvc;
@property(nonatomic,strong) IBOutlet UILabel* txtMaktx;
@property(nonatomic,strong) IBOutlet UITextField* txtSubmt;
@property(nonatomic,strong) IBOutlet UITextField* txtAuldt;
@property(nonatomic,strong) IBOutlet UITextField* txtDeviceCd;
@property(nonatomic,strong) IBOutlet UILabel* txtDeviceNm;

@property(nonatomic,strong) NSMutableArray* repairHistory;
@property(nonatomic,strong) IBOutlet UIScrollView* _scrollView;
@property(nonatomic,assign) BOOL isChangeViewMode;
@property(nonatomic,assign) BOOL isFacQuMode;
@property (strong, nonatomic) IBOutlet UIView *clv1;
@property (strong, nonatomic) IBOutlet UIView *clv2;
@property (strong, nonatomic) IBOutlet UIImageView *table2Header;
@property(nonatomic, strong) NSString* locType;
@property(nonatomic,assign) BOOL isGwlenListSend;

@end

@implementation OutIntoViewController
@synthesize imagePicker;
@synthesize imageView;

@synthesize dbWorkDic;
@synthesize longPressGesture;
@synthesize tapGesture;
@synthesize isFirst;
@synthesize firstFccSAPList;
@synthesize locNameView;
@synthesize lblDeviceID;
@synthesize scrollLocName;
@synthesize lblLocName;
@synthesize scrollDeviceInfo;
@synthesize lblDeviceInfo;
@synthesize isOrgChanged;
@synthesize isOrgChanged_Quit;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize strUserOrgTypeCode;
@synthesize strUserOrgType;
@synthesize orgView;
@synthesize locBarcodeView;
@synthesize fccBarcodeView;
@synthesize fccStatusView;
@synthesize sendOrgView;
@synthesize deviceIDView;
@synthesize deviceInfoView;
@synthesize upperFacView;
@synthesize uuView;
@synthesize curdView;
@synthesize receivedOrgView;
@synthesize txtLocCode;
@synthesize txtFacCode;
@synthesize lblUFacCode;
@synthesize txtUFacCode;
@synthesize lblDeviceIDTitle;
@synthesize txtDeviceID;
@synthesize btnDelete;
@synthesize btnSave;
@synthesize btnPicture;
@synthesize _tableView;
@synthesize _tableView2;
@synthesize picker;
@synthesize plantPicker;
@synthesize viewPictureButton;
@synthesize indicatorView;
@synthesize scrollReceivedOrg;
@synthesize lblReceivedOrg;
@synthesize lblOrperationInfo;
@synthesize btnZoomPic;
@synthesize locResultList;
@synthesize wbsResultList;
@synthesize fccResultList;
@synthesize fccMoveList;
@synthesize originalSAPList;
@synthesize fccSAPList;
@synthesize strLocBarCode;
@synthesize strFccBarCode;
@synthesize strDeviceID;
@synthesize strBusinessNumber;

@synthesize rightBarItem;
@synthesize btnScan;
@synthesize lblScan;
@synthesize btnPicker;
@synthesize lblFccStatus;
@synthesize selectedPickerData;
@synthesize nSelectedRow;
@synthesize strParentBarCode;
@synthesize isRequireLocCode;
@synthesize isOrgInheritance;
@synthesize isOffLine;
@synthesize isMove;
@synthesize JOB_GUBUN;
@synthesize strOperSystemCode;
@synthesize strUpperBarCode;
@synthesize upper_deviceID;
@synthesize upper_OperOrgName;
@synthesize upper_OperOrgCode;
@synthesize first_FccOrgCode;
@synthesize first_FccOrgName;
@synthesize receivedOrgDic;
@synthesize strMoveBarCode;
@synthesize lblPartType;
@synthesize lblUpperPartType;
@synthesize sendCount;
@synthesize btnDetailFccInfo;
@synthesize btnUU;
@synthesize lblCount;
@synthesize wbsView;
@synthesize lblWBSNo;
@synthesize lblPicker;
@synthesize failureContentView;
@synthesize failureFccView;
@synthesize failureDevView;
@synthesize txtViewFailure;
@synthesize workDic;
@synthesize taskList;
@synthesize fetchTaskList;
@synthesize isOperationFinished;
@synthesize isUploadOneImageFinished;
@synthesize lblReceivedTitle;
@synthesize uniqueOrgDic;
@synthesize uniqueOrgList;
@synthesize isSendOrgChecked;
@synthesize CHKZKOSTL_INSTCONF;
@synthesize isDataSaved;
@synthesize isFirstMove;
@synthesize isSelPicView;
@synthesize defaultImage;
@synthesize plantList;
@synthesize shapeView;
@synthesize btnHierachy;
@synthesize btnInit;
@synthesize btnMove;
@synthesize deliveryOrderView;
@synthesize btnDeliveryOreder;
@synthesize lblLoc;
@synthesize moveView;
@synthesize successCount;
@synthesize failCount;

@synthesize pwSendType;
@synthesize deviceLocCd;
@synthesize deviceLocNm;

@synthesize scrollMaktx;
@synthesize scrollDvc;
@synthesize txtAuldt;
@synthesize txtSubmt;
@synthesize txtMaktx;
@synthesize txtDeviceCd;
@synthesize txtDeviceNm;
@synthesize repairHistory;
@synthesize _scrollView;
@synthesize isChangeViewMode;
@synthesize isFacQuMode;
@synthesize clv1;
@synthesize clv2;
@synthesize table2Header;
@synthesize locType;
@synthesize isGwlenListSend;
@synthesize shapeOrderView;
@synthesize moveCurdView;

const static char* moveObjKey = "moveObjKey";
const static char* moveTarKey = "moveTarKey";

#define MAX_LENGTH 80

#pragma mark - ViewLife Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"납품입고"]){
        self = [super initWithNibName:@"OutIntoViewController1" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"납품취소"]){
        self = [super initWithNibName:@"OutIntoViewController2" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"배송출고"]){
        self = [super initWithNibName:@"OutIntoViewController3" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"입고(팀내)"]){
        self = [super initWithNibName:@"OutIntoViewController4" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"출고(팀내)"]){
        self = [super initWithNibName:@"OutIntoViewController5" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"실장"]){
        self = [super initWithNibName:@"OutIntoViewController6" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"탈장"]){
        self = [super initWithNibName:@"OutIntoViewController7" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"송부(팀간)"]){
        self = [super initWithNibName:@"OutIntoViewController8" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"송부취소(팀간)"]){
        self = [super initWithNibName:@"OutIntoViewController9" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"접수(팀간)"]){
        self = [super initWithNibName:@"OutIntoViewController10" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"형상구성(창고내)"]){
        self = [super initWithNibName:@"OutIntoViewController11" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"형상해제(창고내)"]){
        self = [super initWithNibName:@"OutIntoViewController12" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"고장등록"]){
        self = [super initWithNibName:@"OutIntoViewController13" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"설비상태변경"]){
        self = [super initWithNibName:@"OutIntoViewController14" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"설비정보"]){
        self = [super initWithNibName:@"OutIntoViewController15" bundle:nibBundleOrNil];
    }
    else if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"고장수리이력"]){
        self = [super initWithNibName:@"OutIntoViewController16" bundle:nibBundleOrNil];
    }
    else{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    }
    
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
    
    // AlertView를 관리하기 위한 flag역할을 한다.
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    // 현재 작업중인 작업명 저장, 이를 이용해서 title을 만든다.
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    // 스캔취소했을 때 처음 서버로 부터 로드된 데이타로 원상복구하기 위해서 첫 로드 데이타인지 여부를 나타내는 flag
    isFirst = YES;
    // 고장등록시 사진을 선택하였는지 여부
    isSelPicView = NO;
    
    // 스캐너 입력외에 키보드 입력을 허용할 것인지 여부에 대한 설정을 한다.
    [self makeDummyInputViewForTextField];
    // 각 메뉴별 화면을 초기화한다.
    [self layoutSubView];
    // 음영지역작업인지
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];
    
    //작업관리 초기화
    [self workDataInit];
    
    //위도,경도 가져온다.
    //    [[ERPLocationManager getInstance] getMyPosition];
    
    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    // 초기화
    firstFccSAPList = [[NSArray alloc] init];
    fccSAPList = [[NSMutableArray alloc] init];
    originalSAPList = [NSMutableArray array];
    fccMoveList = [[NSMutableArray alloc] init];
    
    // 작업관리 모드가 아니면...
    if ([[Util udObjectForKey:USER_WORK_MODE] isEqualToString:@"N"])
    {
        if ([JOB_GUBUN isEqualToString:@"납품입고"])
            [self requestLogicalLocCode:YES locBarcode:@""];
        else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
                 [JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            isFirstMove = YES;
            [self requestMoveData:@"" orgCode:strUserOrgCode];
        }
    }
    // 작업관리 모드이면...
    else{
        [self performSelectorOnMainThread:@selector(processWorkData) withObject:nil waitUntilDone:NO];
    }
    
    if ([JOB_GUBUN isEqualToString:@"납품취소"])
        [self showCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Touch Event
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - DB Method
// 작업관리
- (void)processWorkData
{
    // 화면이 로드되고 처음 뜰 때 나타내는 초기 정보들을 저장된 데이타에 의해 설정한다.
    if (dbWorkDic.count){
// TASK에 저장되므로 여기서는 필요없음
// UU 버튼 선택여부
//        if (!uuView.hidden){
//            NSString* uuState = [dbWorkDic objectForKey:@"UU_YN"];
//            btnUU.selected = ([uuState isEqualToString:@"Y"]) ? YES:NO;
//        }
//        // 형상구성 선택여부
//        if (!shapeView.hidden && !btnHierachy.hidden){
//            NSString* treeState = [dbWorkDic objectForKey:@"TREE_YN"];
//            btnHierachy.selected = ([treeState isEqualToString:@"Y"]) ? YES:NO;
//        }
//        // 스캔필수 선택여부
//        if (!curdView.hidden && !btnScan.hidden){
//            NSString* scanState = [dbWorkDic objectForKey:@"SCAN_YN"];
//            btnScan.selected = ([scanState isEqualToString:@"Y"]) ? YES:NO;
//        }
//        // 배송오더 선택여부
//        if (!deliveryOrderView.hidden && !btnDeliveryOreder.hidden){
//            NSString* orderState = [dbWorkDic objectForKey:@"ORDER_YN"];
//            btnDeliveryOreder.selected = ([orderState isEqualToString:@"Y"]) ? YES:NO;
//        }
        
        // Pickerview의 선택이 있었다면 설정한다.
        NSString* pickerRow = [dbWorkDic objectForKey:@"PICKER_ROW"];
        if (picker){
            if (pickerRow.length)
                [picker selectPicker:[pickerRow intValue]];
        }
        
        //고장내역
        NSString* strComment = [dbWorkDic objectForKey:@"COMMENT"];
        if (!failureContentView.hidden && strComment.length)
            txtViewFailure.text = strComment;
        // 송부 또는 접수 조직 설정
        if (!receivedOrgView.hidden){
            NSData* orgData = [dbWorkDic objectForKey:@"ORGCODE"];
            if (orgData.bytes > 0){
                NSDictionary* orgDic = [NSKeyedUnarchiver unarchiveObjectWithData:orgData];
                if(orgDic.count){
                    [Util setScrollTouch:scrollReceivedOrg Label:lblReceivedOrg withString:[NSString stringWithFormat:@"%@/%@",[orgDic objectForKey:@"costCenter"],[orgDic objectForKey:@"orgName"]]];
                    receivedOrgDic = orgDic;
                }
            }
        }
        //스캔필수추가
        NSData* taskData = [dbWorkDic objectForKey:@"TASK"];
        if (taskData.bytes > 0){
            fetchTaskList = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
        }
        
        // 초기 화면 이후의 동작들을 실행한다.
        if (fetchTaskList.count)
            [self waitForGCD];
    }
}

// 작업관리 DB에 저장
- (BOOL)saveToWorkDB
{
    NSString* workId = @"";
    
    // 기존에 저장되어 있던 ID가 있으면 업데이트 아니면 추가(INSERT)
    if ([dbWorkDic count])
        workId = [NSString stringWithFormat:@"%@", [dbWorkDic objectForKey:@"ID"]];
    
    NSMutableDictionary* workData = [NSMutableDictionary dictionary];
    
    // 초기화면 설정관련 작업관리 정보
    [workData setObject:workDic forKey:@"WORKDIC"];
    // 초기 이후의 동작들에 관한 작업관리 정보
    [workData setObject:taskList forKey:@"TASKLIST"];
    // 조직관련 정보(송부 혹은 접수조직)입력이 필요한 경우
    if (receivedOrgDic != nil)
        [workData setObject:receivedOrgDic forKey:@"ORGDIC"];
    
    // DB에 실질적으로 저장한다.
    BOOL retValue = [[DBManager sharedInstance] saveWorkData:workData ToWorkDBWithId:workId];
    
    // 현재 저장한 작업의 ID를 저장하고 있어야 같은 작업에 대해 이 후 추가 저장할 때 UPDATE할 수 있으므로..
    // workId가 없다면 새로 INSERT한 작업이므로 마지막 입력된 ID를 저장하고,
    // workId가 있었다면 UPDATE이므로 그대로 workId를 저장한다.
    if(![workId length]){
        workId = [NSString stringWithFormat:@"%d", [[DBManager sharedInstance] countSelectQuery:SELECT_LAST_ID_FROM_WORK_INFO]];
    }
    [workData setObject:workId forKey:@"ID"];
    
    // 같은 ID로 저장할 수 있으므로 현재의 작업내용를 복사한다.
    dbWorkDic = [workData copy];
    
    return retValue;
}

#pragma mark - GCD
// 초기설정 이후의 동작들을 실행한다. - 작업관리
// [TASK, VALUE]로 저장된다.
// **** TASK
// L - 위치 바코드 스캔
// M - 송부취소(팀간) 접수(팀간) 첫 화면에서 최초로 호출된다.  이 동작을 나타낸다.
// D - 장치 바코드 스캔
// U - 상위 바코드 스캔
// F - 설비 바코드 스캔
// DELETE - 삭제
// MOVE - 이동
// SCAN_YN - 스캔필수 버튼 클릭
// UU_YN - UU버튼 클릭
// TREE_YN - 형상구성 버튼 클릭
// **** VALUE : TASK에 따라 필요한 정보
-(void) waitForGCD
{
    for (NSDictionary* dic in fetchTaskList) {
        NSString* task = [dic objectForKey:@"TASK"];
        NSString* value = [dic objectForKey:@"VALUE"];
        
        // 작업이 완료될 때까지 다음 TASK진행을 기다려준다.  이때 작업의 완료 여부를 결정하는 Bool 변수
        isOperationFinished = NO;
        
        // TASK에 따른 작업 실행
        if ([task isEqualToString:@"L"]) //위치
        {
            txtLocCode.text = strLocBarCode =value;
            
            if (isOffLine)
                [self setOfflineLocCd:value];
            else
                [self requestLocCode:value];
        }
        else if ([task isEqualToString:@"M"]) //송부취소(팀간) 접수(팀간) 최초 호출
        {
            if ([[dic objectForKey:@"IS_FIRST_MOVE"] isEqualToString:@"Y"])
                isFirstMove = YES;
            else{
                txtFacCode.text = strMoveBarCode = value;
                isFirstMove = NO;
            }
            [self requestMoveData:value orgCode:strUserOrgCode];
        }
        else if ([task isEqualToString:@"D"]) //장치아이디
        {
            txtDeviceID.text = strDeviceID =value;
            
            if (isOffLine)
                [self setOffLineDeviceCd:value];
            else
                [self requestDeviceCode:value];
        }
        else if ([task isEqualToString:@"U"]) //상위바코드
        {
            strUpperBarCode  = value;
            txtUFacCode.text = strUpperBarCode;
            [self requestUpperFacCode:strUpperBarCode locCode:@"" deviceID:@""];
        }
        else if ([task isEqualToString:@"F"]) //설비바코드
        {
            if (
                [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
                [JOB_GUBUN isEqualToString:@"접수(팀간)"]
                )
                strMoveBarCode = value;
            else
                strFccBarCode = value;
            
            txtFacCode.text = value;
            
            if (strMoveBarCode.length)
                [self processCheckScan:strMoveBarCode];
            else
                [self processCheckScan:strFccBarCode];
        }
        else if ([task isEqualToString:@"DELETE"]) //셀 삭제
        {
            [self deleteBarcode:value];
        }
        else if ([task isEqualToString:@"MOVE"]) //이동
        {
            NSString* source = [dic objectForKey:@"SOURCE"];
            NSString* target = [dic objectForKey:@"TARGET"];
            
            [self moveSource:source toTarget:target];
        }
        else if ([task isEqualToString:@"SCAN_YN"]) // 스캔필수 버튼 클릭
        {
            if ([value isEqualToString:@"Y"]){
                btnScan.selected = YES;
                btnDelete.enabled = YES;
                
                //작업관리에 추가
                NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
                [taskDic setObject:@"SCAN_YN" forKey:@"TASK"];
                [taskDic setObject:@"Y" forKey:@"VALUE"];
                [taskList addObject:taskDic];
            }else{
                btnScan.selected = NO;
                if ([JOB_GUBUN isEqualToString:@"실장"]){
                    // scanvalue = 2 인것만 제거
                    // DR-2014-13014 실장메뉴 U-U 스캔후 스켄필수 해제 시 하위설비 삭제 기능 개선-request by 정진우 -> 2014.05.22 : 류성호
                    // [self processScanYN];
                }
                
                btnDelete.enabled = NO;
            }
            isOperationFinished = YES;
        }
        else if ([task isEqualToString:@"UU_YN"]){  // UU 버튼 클릭
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
        else if ([task isEqualToString:@"TREE_YN"]){    // 형상구성 버튼 클릭
            if ([value isEqualToString:@"Y"])
                btnHierachy.selected = YES;
            else
                btnHierachy.selected = NO;
            isOperationFinished = YES;
            
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"TREE_YN" forKey:@"TASK"];
            [taskDic setObject:(btnHierachy.selected)? @"Y":@"N" forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        else
            isOperationFinished = YES;
        
        // 현재 작업이 완료될때까지 기다린다.
        while (!isOperationFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
    }
    
    // 포커스 설정
    [self layoutControl];
    // 작업관리가 모두 끝났음을 알려줌
    [Util udSetObject:@"N" forKey:USER_WORK_MODE];
    // 작업관리를 실행 했다는 것은 DB에 저장된 작업을 실행한 것이고, 그 외 추가 작업은 없으므로 이미 DB에 저장됐음을 의미한다.
    // 백버튼을 클릭 했을때 현재 저장하지 않은 작업이 남아 있으면 메시지를 띄워주기 위해 필요한 변수임.
    isDataSaved = YES;
}

#pragma mark - Notification Event
// 송부 혹은 접수조직을 선택했을때(OrgSearchViewController에서)
- (void) orgDataReceived:(NSNotification *)notification
{
    receivedOrgDic = [notification object];
    if (receivedOrgDic.count){
        lblReceivedOrg.text = [NSString stringWithFormat:@"%@/%@",[receivedOrgDic objectForKey:@"costCenter"],[receivedOrgDic objectForKey:@"orgName"]];
        [Util setScrollTouch:scrollReceivedOrg Label:lblReceivedOrg withString:[NSString stringWithFormat:@"%@/%@",[receivedOrgDic objectForKey:@"costCenter"],[receivedOrgDic objectForKey:@"orgName"]]];
        
        if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            //데이터 초기화
            originalSAPList = [NSMutableArray array];
            
            isFirstMove = NO;
            [self requestMoveData:@"" orgCode:@""];
        }
        //작업관리 추가
        [workDic setObject:receivedOrgDic forKey:@"ORGCODE"];
    }
}

// 선택하지 않고 취소 했을 때....
- (void) orgDataCanceled:(NSNotification *)notification
{
    //취소 했으므로 데이터 초기화
    lblReceivedOrg.text = @"";
    receivedOrgDic = [NSMutableDictionary dictionary];
    
    if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        originalSAPList = [NSMutableArray array];
        isFirstMove = NO;
        [self requestMoveData:@"" orgCode:@""];
    }
}


#pragma mark - protocol method
// WBSListViewController 에서 WBS를 선택한 경우
- (void)setWBSNo:(NSString*)wbsNo withResult:(BOOL)result;
{
    if ([JOB_GUBUN isEqualToString:@"철거"]){
        lblWBSNo.text = wbsNo;
        
        [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
    }
}

// WBSListViewController에서 WBS를 선택하지 않고, 취소한 경우
- (void)cancelSelectWBSNo
{
    [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
    return;
}

#pragma mark - handle gesture
// TableView에 있는 항목을 길게 tab했을때 발생하는 이벤트처리
// 이때 설비의 상세 정보 화면을 띄워준다.
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
                    if([JOB_GUBUN isEqualToString:@"고장등록"]){
                        vc.paramScreenCode = @"고장이력조회";
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}


// TableView에 있는 항목을 길게 tab했을때 발생하는 이벤트처리
// 해당 항목 선택의 의미가 있다.
- (void) handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        return;
    }
    //to-do 키패드 떠있는지 체크해서 죽여야 함.
    if ([txtViewFailure isFirstResponder])
        [txtViewFailure resignFirstResponder];
    else if ([txtFacCode isFirstResponder])
        [txtFacCode resignFirstResponder];
    
    if (fccSAPList.count){
        CGPoint p = [gestureRecognizer locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        if (indexPath){
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= MAX_LENGTH)
    {
        return YES;
    } else {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        
        AlertViewController *toast = [[AlertViewController alloc] initWithTitle:nil message:@"고장내역은 80자 이내로 입력하세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [toast show];
        
        int duration = 1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast hide];
            //[toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        return NO;
    }
}

#pragma mark - UserDefine Method
// 작업관리에 필요한 영역들을 초기화하고, 현재 초기 화면에 설정되어 있는 상태들을 저장한다.
// TRANSACT_YN - 전송 여부를 저장한다.  초기에는 당연히 N
- (void) workDataInit
{
    isDataSaved = NO;
    
    //작업관리 초기화
    workDic = [NSMutableDictionary dictionary];
    taskList = [NSMutableArray array];
    
    [workDic setObject:[WorkUtil getWorkCode:JOB_GUBUN] forKey:@"WORK_CD"];
    [workDic setObject:@"N" forKey:@"TRANSACT_YN"]; //미전송
    
// TASK에 추가로 저장되므로 여기서는 필요없는 데이터이다.  그래서 comment out처리함 2014. 1. 7 박수임
//    if (!uuView.hidden)
//        [workDic setObject:(btnUU.selected)? @"Y":@"N" forKey:@"UU_YN"];
//
//    //형상구성여부
//    if (!shapeView.hidden && !btnHierachy.hidden)
//        [workDic setObject:(btnHierachy.selected)? @"Y":@"N" forKey:@"TREE_YN"];
//
//    //스캔필수 처리
//    if (!curdView.hidden && !btnScan.hidden)
//        [workDic setObject:(btnScan.selected)? @"Y":@"N" forKey:@"SCAN_YN"];
//
//    //배송오더 처리
//    if (!deliveryOrderView.hidden && !btnDeliveryOreder.hidden)
//        [workDic setObject:(btnDeliveryOreder.selected)? @"Y":@"N" forKey:@"ORDER_YN"];
    
    
    //picker data 처리(고장코드 포함)
    if (picker){
        if (![JOB_GUBUN isEqualToString:@"고장등록"]) //고장등록은 초기값 없음
            [workDic setObject:[NSString stringWithFormat:@"%d",picker.selectedIndex] forKey:@"PICKER_ROW"];
    }
    
    //offline 여부
    if (isOffLine)
        [workDic setObject:@"Y" forKey:@"OFFLINE"];
    else
        [workDic setObject:@"N" forKey:@"OFFLINE"];
    
}

// TextField의 tag값을 이용하여 어떤 textfield가 포커스되어 있는지 판단한다.
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    NSString* message = nil;
    
    if (tag == 100){ //위치바코드
        strLocBarCode = barcode;
        
        message = [Util barcodeMatchVal:1 barcode:strLocBarCode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            txtLocCode.text = strLocBarCode = @"";
            strLocBarCode = @"";
            [txtLocCode becomeFirstResponder];
            return YES;
        }
        
        // 철거일 때는 WBS번호를 갖고와 처리하는 경우가 있으므로 다른 경우와는 달리 이전 저장된 WBS등의 정보가 있을 수 있으므로
        // 이를 모두 초기화 해주는 작업이 필요하다.
        if([JOB_GUBUN isEqualToString:@"철거"]){
            isFirst = YES;
            
            //textfield 초기화
            if (isRequireLocCode){
                lblWBSNo.text = @"";
            }
            txtFacCode.text = strFccBarCode = strMoveBarCode = @"";
            
            if (!locNameView.hidden){
                [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
            }
            
            //table초기화
            fccSAPList = [NSMutableArray array];
            originalSAPList = [NSMutableArray array];
            nSelectedRow = -1;
            
            [_tableView reloadData];
            [self showCount];
        }
        
        if (strLocBarCode){
            if (isOffLine)  // 음역지역 일 때는 서버접속이 안되므로 위치 정보에 "'음영지역작업' 중입니다."라고 뿌려준다.
                [self setOfflineLocCd:strLocBarCode];
            else    // 음영지역이 아니라면 입력한 바코드를 서버로 보내 필요 데이타를 얻어오도록 한다.
                [self requestLocCode:strLocBarCode];
        }
    }
    else if (tag == 200){ //200 설비 바코드
        strFccBarCode = barcode;
        
        if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
            if(strFccBarCode.length < 16 || strFccBarCode.length > 18){
                [self showMessage:@"처리할수 없는 설비바코드 입니다." tag:-1 title1:@"닫기" title2:nil];
                txtFacCode.text = strFccBarCode = @"";
                [txtFacCode becomeFirstResponder];
                return YES;
            }
        }
        
        if([strFccBarCode isEqualToString:@"1359"]){
            [Util udSetObject:@"1" forKey:INPUT_MODE];
            message = @"테스트 입력모드 변경";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return NO;
        }
        
        message = [Util barcodeMatchVal:2 barcode:strFccBarCode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            txtFacCode.text = strFccBarCode = @"";
            strFccBarCode = @"";
            [txtFacCode becomeFirstResponder];
            return YES;
        }
        
        if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] || [JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            strMoveBarCode = strFccBarCode;
        }
        
        // 설비정보 조회의 경우에는 설비정보 하나씩 조회되므로 항상 무조건 초기화해준다.
        if ([JOB_GUBUN isEqualToString:@"설비정보"]){
            originalSAPList = [NSMutableArray array];
            fccSAPList = [NSMutableArray array];
            [_tableView reloadData];
        }
        
        //먼저 위치 바코드 체크 => 위치바코드가 필요한 작업(isRequireLocCode로 체크)인데 위치바코드 스캔없이 설비바코드 스캔했다면 오류
        //송부(팀간)은 적용안됨
        if(isRequireLocCode && !lblLocName.text.length){
            [self performSelectorOnMainThread:@selector(locBecameFirstResponder) withObject:nil waitUntilDone:NO];
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strFccBarCode = @"";
            strMoveBarCode = @"";
//            txtFacCode.text = @"";
            lblPartType.text = @"";
            return NO;
        }
        
        //찍은 설비바코드가 상위 바코드와 같으면 중복스캔
        if (!upperFacView.hidden && [barcode isEqualToString:txtUFacCode.text]){
            message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",barcode];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            strUpperBarCode = @"";
//            lblUpperPartType.text = @"";
            [self checkOrgInheritance];
            
            return NO;
        }
        
        // 송부취소(팀간), 접수(팀간)은 따로 처리
        if (strMoveBarCode.length)
            [self processCheckScan:strMoveBarCode];
        else if (strFccBarCode.length){
            if ([JOB_GUBUN isEqualToString:@"납품취소"]){
                // 납품취소일 때는 리스트를 모두 지우고 요청한다.
                originalSAPList = [NSMutableArray array];
                fccSAPList = [NSMutableArray array];
                [_tableView reloadData];
                [self showCount];
                if (isOffLine)
                    [self setOfflineFacCd:strFccBarCode];
                else
                    [self requestSAPInfo:strFccBarCode locCode:@"" deviceID:@""];
            }else
                [self processCheckScan:strFccBarCode];
        }
    }
    else if (tag == 300){ //300 장치 바코드
        strDeviceID = barcode;
        
        message = [Util barcodeMatchVal:3 barcode:strDeviceID];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDeviceID = @"";
//            txtDeviceID.text = @"";
            [txtDeviceID becomeFirstResponder];
            return YES;
        }
        
        if (isOffLine){
            [self setOffLineDeviceCd:strDeviceID];
        }else
            [self requestDeviceCode:strDeviceID];
        
    }
    else if (tag == 500){ //500 상위 바코드
        strUpperBarCode = barcode;
        
        message = [Util barcodeMatchVal:2 barcode:strUpperBarCode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            lblUpperPartType.text = strUpperBarCode = @"";
//            txtUFacCode.text = @"";
            [txtDeviceID becomeFirstResponder];
            [self checkOrgInheritance];
            return YES;
        }
        
        // 설비바코드와 상위바코드가 중복되는지 체크, 같다면 중복스캔 메시지
        if ([originalSAPList count]){
            if (strUpperBarCode.length){
                int idx =   [WorkUtil getBarcodeIndex:strUpperBarCode fccList:originalSAPList];
                if (idx != -1){
                    message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",barcode];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
//                    txtUFacCode.text = @"";
                    strUpperBarCode = @"";
                    lblUpperPartType.text = @"";
                    [self checkOrgInheritance];
                    return NO;
                }
            }
        }
        
        if (strUpperBarCode.length){
            if (isOffLine)
                [self setOfflineUFacCd:strUpperBarCode];
            else
                [self requestUpperFacCode:strUpperBarCode locCode:@"" deviceID:@""];
        }
    }
    
    return YES;
}

// 음영지역 작업에 해당됨
// 위치, 장치의 경우에는 서버로 요청이 불가능 하므로 "'음영지역' 작업중"이라는 메시지를 뿌려주는 것으로 대체한다.
- (void)setOfflineLocCd:(NSString*)barcode
{
    [Util setScrollTouch:scrollLocName Label:lblLocName withString:MESSAGE_OFFLINE];
    if (!wbsView.hidden)    lblWBSNo.text = lblLocName.text;
    
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

// 음영지역에서 작업할 경우에는 로컬 DB 에 저장된 물품정보를 조회하여 처리해 준다.
- (void)setOfflineFacCd:(NSString*)barcode
{
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSString* errorMessage = @"";
    
    // DB에서 물품정보 조회
    NSArray* goodsList = [WorkUtil getBarcodeInfoInPDA:barcode errorMessage:errorMessage];
    
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(goodsList == nil || (goodsList != nil && goodsList.count <= 0)){
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isOperationFinished = YES;
        return;
    }
    
    if ([goodsList count]){
        BOOL isEmptySAPList = YES;
        
        // 추가인지 최초스캔인지 여부
        if (originalSAPList.count)
            isEmptySAPList = NO;
        
        //무조건 데이터 1개
        NSDictionary* dic = [goodsList objectAtIndex:0];
        NSString* compType;
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            compType = @"";
        else
            compType = [dic objectForKey:@"COMPTYPE"];
        NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
        
        // 여러설비 동시에 작업할 수 있는지 체크
        if ([self isCanMultiFacPartTypeName:partTypeName]){
            NSString* message = [NSString stringWithFormat:@"여러 설비를 동시에 '%@' 작업을\n하실 수 없습니다.\n먼저 전송 후 다시 시도하세요.",JOB_GUBUN];
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            isOperationFinished = YES;
            
            return;
        }
        
        // 필요한 데이타 타입으로 셋팅
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        if (barcodeName== nil)
            barcodeName = @"";
        else
            barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        
        NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
        if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] || [JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            [sapDic setObject:@"" forKey:@"TRANSNO"];
            [sapDic setObject:@"" forKey:@"ITEMNO"];
        }
        [sapDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapDic setObject:barcode forKey:@"EQUNR"];
        [sapDic setObject:@"" forKey:@"ZPSTATU"];
        [sapDic setObject:barcodeName forKey:@"MAKTX"];
        [sapDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"ZPGUBUN"];
        [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
        [sapDic setObject:@"" forKey:@"ZPPART"];
        [sapDic setObject:@"" forKey:@"ZKOSTL"];
        [sapDic setObject:@"" forKey:@"ZKTEXT"];
        [sapDic setObject:@"" forKey:@"ZEQUIPGC"];  // deviceId
        
        //조직체크 추가
        NSString* orgCode = [sapDic objectForKey:@"ZKOSTL"];
        NSString* orgName = [sapDic objectForKey:@"ZKTEXT"];
        NSString* checkOrgValue = nil;
        checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
        
        [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
        
        // 새롭게 정의한 값
        [sapDic setObject:@"S" forKey:@"RSLT"];
        [sapDic setObject:@"" forKey:@"MESG"];
        
        BOOL isMakeHierachy = YES;
        if ([JOB_GUBUN isEqualToString:@"입고(팀내)"] || [JOB_GUBUN isEqualToString:@"철거"])
            isMakeHierachy = NO;
        
        
        // 트리구조를 만들어 추가시켜준다.
        [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:isMakeHierachy isCheckUU:btnUU.selected isRemake:YES fccList:originalSAPList job:JOB_GUBUN];
        
        lblPartType.text = [sapDic objectForKey:@"PART_NAME"];
        
        // 스캔타입 설정
        if (isEmptySAPList){    // 최초 스캔 시
            if (![barcode isEqualToString:strFccBarCode])
                [sapDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
            else
                [sapDic setObject:@"3" forKey:@"SCANTYPE"]; //상위 설비
        }else{
            if ([JOB_GUBUN isEqualToString:@"납품취소"])    // 납품취소인 경우 모든 설비의 스캔타입이 "1"
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
        
        // 작업관리 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:barcode forKey:@"VALUE"];
        [taskList addObject:taskDic];
        
        // Back 버튼 클릭시 저장하지 않은 작업이 있는지 체크하기 위한 설정
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
    }
    
    // fccSAPList를 만들고, 화면도 반영
    [self reloadTableWithRefresh:YES];
    [self scrollToIndex:nSelectedRow];
    
    // 스캔취소시 최초 데이타리스트로 돌려놓아야 하므로 최초의 것 따로 저장
    if (isFirst){
        isFirst = NO;
        firstFccSAPList = [NSMutableArray arrayWithArray:originalSAPList];
    }
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

// 음영지역 상위바코드 스캔시...
- (void)setOfflineUFacCd:(NSString*)barcode
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
        if (originalSAPList.count){
            BOOL isError = NO;
            
            NSDictionary* dic = [goodsList objectAtIndex:0];
            NSString* compType;
            if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
                compType = @"";
            else
                compType = [dic objectForKey:@"COMPTYPE"];
            NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
            lblUpperPartType.text = partTypeName;
            
            // 리스트 중 최상위(스캔한 설비)의 종류
            NSString* rootPartTypeName = [WorkUtil getParentPartName:originalSAPList];
            
            if ([rootPartTypeName isEqualToString:@"S"]){
                // E-S 가능 -> 단품 랙, R-S 가능 그 외 불가능, S-S N/A
                if (
                    ![partTypeName isEqualToString:@"R"] &&
                    ![partTypeName isEqualToString:@"E"]
                    ) {
                    isError = YES;
                }
            }
            else if ([rootPartTypeName isEqualToString:@"U"]){
                //U-E N/A
                // E도 UNIT의 상위가 될 수 있음
                // R-U, S-U, U-U가능
                if (
                    ![partTypeName isEqualToString:@"R"] &&
                    ![partTypeName isEqualToString:@"S"] &&
                    ![partTypeName isEqualToString:@"U"]
                    ) {
                    isError = YES;
                }
            }
            if (isError){
                NSDictionary* partNameDic = [Util udObjectForKey:MAP_PART_NAME];
                NSString* message = [NSString stringWithFormat:@"'%@'의 상위바코드로 '%@'을\n스캔 하실 수 없습니다.",
                                     [partNameDic objectForKey: rootPartTypeName],[partNameDic objectForKey:partTypeName]];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                
                return;
            }
        }
        
        //작업관리 추가
        if (txtUFacCode.text.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"U" forKey:@"TASK"];
            [taskDic setObject:txtUFacCode.text forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    
    [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

// 여러 설비를 동시에 작업할 수 있는지 여부를 체크한다.
- (BOOL)isCanMultiFacPartTypeName:(NSString*)partTypeName
{
    // 화면 상의 상위바코드 찾아오기
    NSDictionary* parentItemDic = nil;
    if(originalSAPList.count){
        // 아래서부터 올라가면서 최상위 바코드를 찾는다.(Root)
        // => 여러 설비(Root가 여러개)가 있을 경우에는 나중에 스캔한 설비를 우선 찾아낸다.
        int upperIndexset = [WorkUtil getReverseParentIndex:originalSAPList];
        if (upperIndexset!= -1){
            parentItemDic = [originalSAPList objectAtIndex:upperIndexset];
        }
        else {  // 없다면, 현재 select된 설비 => 이런 경우는 없을듯...
            NSDictionary* subDic = [fccSAPList objectAtIndex:nSelectedRow];
            parentItemDic = [WorkUtil getItemFromFccList:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList];
        }
    }
    // 실장, 탈장, 출고(팀내), 설비상태변경, 송부(팀간) => 여러설비를 동시에 작업할 수 없음.
    // -- 화면 상의 상위바코드 찾아오기
    BOOL isError = NO;
    
// 탈장, 출고(팀내), 설비상태변경, 송부(팀간) 여러설비 작업 가능하도록 수정 요청
// 2014. 2. 11 request by 김희선
//    if (originalSAPList.count && (
//                                  [JOB_GUBUN isEqualToString:@"실장"]        ||
//                                  [JOB_GUBUN isEqualToString:@"탈장"]        ||
//                                  [JOB_GUBUN isEqualToString:@"출고(팀내)"]   ||
//                                  [JOB_GUBUN isEqualToString:@"설비상태변경"]  ||
//                                  [JOB_GUBUN isEqualToString:@"송부(팀간)"])
//        ){
    if ((originalSAPList.count && [JOB_GUBUN isEqualToString:@"실장"]) || (originalSAPList.count && [JOB_GUBUN isEqualToString:@"형상구성(창고내)"])){
        NSString* upperpartType = [parentItemDic objectForKey:@"PART_NAME"];
        
        // U - R, S, E NA
        // U - U만 가능
        if ([upperpartType isEqualToString:@"U"]){
            if ([partTypeName isEqualToString:@"R"] || [partTypeName isEqualToString:@"S"] || [partTypeName isEqualToString:@"E"])
                isError = YES;
        }
        // E - R, S, U NA
        // E - E만 가능
        else if ([upperpartType isEqualToString:@"E"]){
            if ([partTypeName isEqualToString:@"R"] || [partTypeName isEqualToString:@"S"] || [partTypeName isEqualToString:@"U"])
                isError = YES;
        }
        // S - E, S, R NA
        // S - U 가능
        else if ([upperpartType isEqualToString:@"S"]){
            if ([partTypeName isEqualToString:@"E"] || [partTypeName isEqualToString:@"S"] || [partTypeName isEqualToString:@"R"])
                isError = YES;
        }
        // R - E, R NA
        // R - S, U 가능
        else if ([upperpartType isEqualToString:@"R"]){
            if ([partTypeName isEqualToString:@"E"] || [partTypeName isEqualToString:@"R"])
                isError = YES;
        }
    }
    
    return isError;
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
    if (![txtDeviceID isFirstResponder] && [txtDeviceID isEnabled])
        [txtDeviceID becomeFirstResponder];
}

- (void) upperBecameFirstResponder
{
    if (![txtUFacCode isFirstResponder] && [txtUFacCode isEnabled])
        [txtUFacCode becomeFirstResponder];
}

- (void) fccBecameFirstResponder
{
    if (![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

- (void) locBecameFirstResponder
{
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}


// 스캔취소와 삭제
- (void) deleteBarcode:(NSString*)barcode
{
    //스캔취소 : 스캔값을 1->0
    NSInteger index = [WorkUtil getBarcodeIndex:barcode fccList:originalSAPList];
    BOOL isDelete = NO;
    if (index != -1){
        if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            NSMutableDictionary* dic = [originalSAPList objectAtIndex:index];
            NSString* scanType = [dic objectForKey:@"SCANTYPE"];
            if ([scanType isEqualToString:@"1"]){
                [dic setObject:@"0" forKey:@"SCANTYPE"];
                
                // fccSAPList를 만들고, 화면도 반영
                [self reloadTableWithRefresh:YES];
                
                isDelete = YES;
            }
        }
        
        if (!isDelete)
        {
            // 해당 바코드 하위에 속해 있는 Child 설비를 모두 삭제하고, parent - child 관계를 다시 설정해준다.
            [WorkUtil deleteBarcodeIndex:index fccList:originalSAPList];
            
            // fccSAPList를 만들고, 화면에 반영하지 않음
            [self reloadTableWithRefresh:NO];
            
            if (originalSAPList.count)
                nSelectedRow = fccSAPList.count - 1;
            else
                nSelectedRow = 0;
            
            if (originalSAPList.count && nSelectedRow > originalSAPList.count-1) {
                nSelectedRow = fccSAPList.count - 1;
            }
            [_tableView reloadData];
            [self showCount];
            
            isDelete = YES;
        }
    }
    
    if (isDelete){
        //데이터 변경, Back 버튼 클릭시 수정한 데이타가 있을 때 경고하기 위해
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"DELETE" forKey:@"TASK"];
        [taskDic setObject:barcode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    
    isOperationFinished = YES;
}

// source설비를 target하위로 이동한다.
- (void)moveSource:(NSString*)source toTarget:(NSString*)target
{
    // 실제로 이동을 수행하며, 이에 따른 parent-child관계설정까지 마무리한다.
    [WorkUtil moveSource:source toTarget:target fccList:originalSAPList];
    
    // fccSAPList를 만들고, 화면에 반영하지 않음
    [self reloadTableWithRefresh:NO];
    nSelectedRow = [WorkUtil getBarcodeIndex:source fccList:originalSAPList];
    [_tableView reloadData];
    [self showCount];
    
    //작업관리 추가
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"MOVE" forKey:@"TASK"];
    [taskDic setObject:source forKey:@"SOURCE"];
    [taskDic setObject:target forKey:@"TARGET"];
    [taskList addObject:taskDic];
    
    isOperationFinished = YES;
}

// 스캔필수 == "N"인 경우 첫번째 스캔한 데이타를 제외하고 그 하위로 딸려온 하위 설비들은 삭제해준다.
// 입고팀내 && 철거는 제외
- (void) processScanYN
{
    if (originalSAPList.count){
        for (NSInteger index = originalSAPList.count-1; index >= 0; index--){
            NSDictionary* dic = [originalSAPList objectAtIndex:index];
            // index != 0 => 처음 스캔한 정보
            // scanType == 3 => 최초스캔
            // scanType == 2 => 추가 스캔
            if (([[dic objectForKey:@"SCANTYPE"] isEqualToString:@"2"] ||
                 [[dic objectForKey:@"SCANTYPE"] isEqualToString:@"3"]) && index != 0){
                NSMutableIndexSet* deletedIndexes = [NSMutableIndexSet indexSet];
                
                // index에 해당한 바코드의 하위에 있는(Child)리스트를 deleteIndexes에 저장
                [WorkUtil getChildIndexesOfCurrentIndex:index fccList:originalSAPList childSet:deletedIndexes isContainSelf:YES];
                [originalSAPList removeObjectsAtIndexes:deletedIndexes];
            }
        }
        // 첫번째 설비를 선택하도록 함
        nSelectedRow = 0;
        // fccSAPList를 만들고, 화면도 반영
        [self reloadTableWithRefresh:YES];
    }
}

// TableView하단에 설비의 개수를 표시
- (void) showCount
{
    int shelfCount = 0;
    int rackCount = 0;
    int unitCount = 0;
    int equipCount = 0;
    int totalCount = 0;
    NSString* formatString = nil;
    
    if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        if(txtFacCode.text.length > 0){
            [txtFacCode becomeFirstResponder];
        }else{
            [txtDeviceID becomeFirstResponder];
        }
        lblCount.text = [NSString stringWithFormat:@"%d건",(int)[repairHistory count]];
    }else{
        if (originalSAPList.count){
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
        }
        totalCount =  rackCount + shelfCount + unitCount + equipCount;
        formatString = [NSString stringWithFormat:@"R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount,shelfCount,unitCount,equipCount,totalCount];
        lblCount.text = formatString;
    }
}

// orignalSAPList에는 full 데이타가 있다.  트리에서 열림과 닫힘에 따라 하위 노드들의 표시 여부가 결정되므로
// 이에 따라 실제로 화면에 표시되는 리스트는 fccSAPList 이다.
// originalSAPList를 기반으로 현재 상태에 따라 fccSAPList를 만들어준다.
- (void) reloadTableWithRefresh:(BOOL)isRefresh
{
    fccSAPList = [NSMutableArray array];
    for(int index = 0; index < originalSAPList.count; ){
        NSDictionary* dic = [originalSAPList objectAtIndex:index];
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        // 현재 트리가 +인지 -인지 값
        SubCategoryInfo category = [[dic objectForKey:@"exposeStatus"] intValue];
        
        // + (펼쳐지지 않은 상태)라면...  하위 노드들을 추가하지 않고, 그 수만큼 건너 뛴 다음의 설비에 대해 처리한다.
        if (category == SUB_CATEGORIES_NO_EXPOSE){
            NSString* selancestor = [dic objectForKey:@"ANCESTOR"];
            NSMutableIndexSet * childIndexSet = [NSMutableIndexSet indexSet];
            
            
            if (!selancestor.length) //취상위 레벨일 경우 ancestor 존재하지 않는다.
                selancestor = barcode;
            [WorkUtil getChildIndexesOfCurrentIndex:index fccList:originalSAPList childSet:childIndexSet isContainSelf:NO];
            index += [childIndexSet count];
            
            //            NSLog(@"childIndexSet [%@]", childIndexSet);
        }
        // 펼쳐졌거나, 하위에 설비가 없는 경우라면 순차적으로 처리해 준다.
        index++;
        [fccSAPList addObject:dic];
    }
    
    // UU버튼을 매번 초기화해준다.
    btnUU.selected = NO;
    if (!shapeView.hidden)
        btnUU.enabled = btnHierachy.selected;
    
    // 화면반영여부, fccSAPList만 만들고, 화면에 반영하지 않을 수 있다.
    if (isRefresh){
        [_tableView reloadData];
        [self showCount];
    }
}

// TableView에서 가장 아래로 scroll을 이동시킴
- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (_tableView.contentSize.height > _tableView.bounds.size.height) {
        yOffset = _tableView.contentSize.height - _tableView.bounds.size.height;
    }
    [_tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

// 해당 index로 scroll을 이동 시킴
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
        if (![JOB_GUBUN isEqualToString:@"설비정보"]){ //keyin 되게 한다.
            txtFacCode.inputView = dummyView;
        }
        txtUFacCode.inputView = dummyView;
    }
}

// 화면 초기 설정
- (void) layoutSubView
{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    // 카운트 레이블 구성
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.font = [UIFont systemFontOfSize:14];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];
    
    // 접수 또는 송부조직 선택/취소 시 발생되는 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orgDataReceived:)
                                                 name:@"orgSelectedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orgDataCanceled:)
                                                 name:@"orgCancelNotification"
                                               object:nil];
    
    
    // 위치바코드 필수 여부 설정
    if ([JOB_GUBUN isEqualToString:@"고장등록취소"]     ||
        [JOB_GUBUN isEqualToString:@"수뢰의뢰취소"]  ||
        [JOB_GUBUN isEqualToString:@"실장"]  ||
        [JOB_GUBUN isEqualToString:@"수리완료"]     ||
        [JOB_GUBUN isEqualToString:@"개조개량의뢰"]        ||
        [JOB_GUBUN isEqualToString:@"개조개량의뢰취소"]     ||
        [JOB_GUBUN isEqualToString:@"개조개량완료"]        ||
        [JOB_GUBUN isEqualToString:@"입고(팀내)"]      ||
        [JOB_GUBUN isEqualToString:@"접수(팀간)"]   ||
        [JOB_GUBUN isEqualToString:@"납품입고"] ||
        [JOB_GUBUN isEqualToString:@"배송출고"] ||
        [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]
        )
        isRequireLocCode = YES;
    else
        isRequireLocCode = NO;
    
    
    //운용조직
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    strUserOrgType = [dic objectForKey:@"orgTypeCode"];
    strBusinessNumber = [dic objectForKey:@"bussinessNumber"];
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    // 기타 자료구조 초기화
    firstFccSAPList = [[NSArray alloc] init];
    fccSAPList = [[NSMutableArray alloc] init];
    fccMoveList = [[NSMutableArray alloc] init];
    
    // 피커뷰 구성 및 초기화
    if (
        [JOB_GUBUN isEqualToString:@"설비상태변경"] ||
        [JOB_GUBUN isEqualToString:@"입고(팀내)"] ||
        [JOB_GUBUN isEqualToString:@"접수(팀간)"] ||
        [JOB_GUBUN isEqualToString:@"수리완료"] ||
        [JOB_GUBUN isEqualToString:@"개조개량완료"] ||
        [JOB_GUBUN isEqualToString:@"고장등록취소"]
        )
    {
        if(
           [JOB_GUBUN isEqualToString:@"고장등록취소"]
           ){
            picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴",@"예비",@"미운용"]];
        }
        else if ([JOB_GUBUN isEqualToString:@"설비상태변경"] ){
            picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴",@"예비",@"미운용", @"불용대기"]];
        }
        else if(![JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴",@"예비",@"불용대기"]];
        }
        else{
            picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"유휴",@"예비"]];
        }
        lblFccStatus.text = @"예비";
        picker.delegate = self;
        [picker selectPicker:0]; //선택값 예비로 설정 matsua: 유휴로 변경
    }
    
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
    
    
    // 본격적인 화면 구성
    uuView.hidden = YES;
    deviceIDView.hidden = YES;
    deviceInfoView.hidden = YES;
    upperFacView.hidden = YES;
    receivedOrgView.hidden = YES;
    sendOrgView.hidden = YES;
    wbsView.hidden = YES;
    failureFccView.hidden = YES;
    failureDevView.hidden = YES;
    shapeOrderView.hidden = YES;
    
    _scrollView.hidden = YES;
    
    if (![JOB_GUBUN isEqualToString:@"납품입고"]){
        btnMove.hidden = YES;
        btnInit.frame = CGRectMake(133, 5, 45,30);
    }
    
    if(
       [JOB_GUBUN isEqualToString:@"출고(팀내)"] ||
       [JOB_GUBUN isEqualToString:@"탈장"]
       ){
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 26, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height); //설비바코드
//        curdView.frame = CGRectMake(0, 61, 320, 40); //3번째 라인
        
        _tableView.frame = CGRectMake(0, 102, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 80);
    }
    else if ([JOB_GUBUN isEqualToString:@"실장"]){
        uuView.hidden = NO;
        deviceIDView.hidden = NO;
        deviceInfoView.hidden = NO;
        upperFacView.hidden = NO;
        
        fccStatusView.hidden = YES;
        
        txtDeviceID.backgroundColor = (txtDeviceID.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        lblDeviceIDTitle.textColor = (txtDeviceID.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
        txtUFacCode.backgroundColor = (txtUFacCode.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        lblUFacCode.textColor = (txtUFacCode.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
        
        txtDeviceID.backgroundColor = (txtDeviceID.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        txtUFacCode.backgroundColor = (txtUFacCode.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        
        deviceIDView.frame = CGRectMake(deviceIDView.frame.origin.x, 121, deviceIDView.frame.size.width, deviceIDView.frame.size.height);
        deviceInfoView.frame = CGRectMake(deviceInfoView.frame.origin.x, 156, deviceInfoView.frame.size.width,deviceInfoView.frame.size.height);
        upperFacView.frame = CGRectMake(upperFacView.frame.origin.x, 181, upperFacView.frame.size.width,upperFacView.frame.size.height);
//        curdView.frame = CGRectMake(0, 216, 320,40);
        _tableView.frame = CGRectMake(0, 257, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
        receivedOrgView.hidden = NO;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        receivedOrgView.frame = CGRectMake(receivedOrgView.frame.origin.x, 26, receivedOrgView.frame.size.width,receivedOrgView.frame.size.height); //접수조직
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 52, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height); //설비바코드
//        curdView.frame = CGRectMake(0, 87, 320,40);
        
        _tableView.frame = CGRectMake(0, 128, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        // DR-2013-57935 송부취소(팀간)시 위치코드 스캔 추가 - request by 정진우 2013.11.25, program by 류성호 2014.06.03
        //locBarcodeView.hidden = YES;
        //locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 87, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height); //설비바코드
//        curdView.frame = CGRectMake(0, 120, 320,40);
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = NO;
        [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked_disable"] forState:UIControlStateSelected];
        lblScan.textColor = RGB(120, 120, 96);
        [btnDelete setImage:[UIImage imageNamed:@"button_scan_cancel"] forState:UIControlStateNormal];
        [btnDelete setImage:[UIImage imageNamed:@"button_scan_cancel_up"] forState:UIControlStateHighlighted];
        
        _tableView.frame = CGRectMake(0, 160, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 80);
        
        
        [txtFacCode becomeFirstResponder];
    }
    else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        fccStatusView.hidden = NO;
        orgView.hidden = NO;
        lblReceivedTitle.text = @"송부조직";
        receivedOrgView.hidden = NO;
        receivedOrgView.frame = CGRectMake(receivedOrgView.frame.origin.x, 27, receivedOrgView.frame.size.width,receivedOrgView.frame.size.height);
        sendOrgView.hidden = NO;
        locBarcodeView.frame = CGRectMake(locBarcodeView.frame.origin.x, 52, locBarcodeView.frame.size.width,locBarcodeView.frame.size.height);
        locNameView.frame = CGRectMake(locNameView.frame.origin.x, 87, locNameView.frame.size.width, locNameView.frame.size.height);
        sendOrgView.frame = CGRectMake(sendOrgView.frame.origin.x, 115, sendOrgView.frame.size.width,sendOrgView.frame.size.height);
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 114, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height);
        fccStatusView.frame = CGRectMake(fccStatusView.frame.origin.x, 142, fccStatusView.frame.size.width,fccStatusView.frame.size.height);
//        curdView.frame = CGRectMake(0, 178, 320, 40);
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = NO;
        [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked_disable"] forState:UIControlStateSelected];
        lblScan.textColor = RGB(120, 120, 96);
        
        //스캔취소 버튼으로 바꾼다.
        [btnDelete setImage:[UIImage imageNamed:@"button_scan_cancel"] forState:UIControlStateNormal];
        [btnDelete setImage:[UIImage imageNamed:@"button_scan_cancel_up"] forState:UIControlStateHighlighted];
        _tableView.frame = CGRectMake(0, curdView.frame.origin.y + curdView.frame.size.height + 2, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"설비정보"]){
        orgView.hidden = NO;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        moveCurdView.hidden = YES;
        curdView.hidden = YES;
        btnDetailFccInfo.hidden = NO;
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 27, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height);
        _tableView.frame = CGRectMake(0, 61, 320, PHONE_SCREEN_HEIGHT - (fccBarcodeView.frame.origin.y + fccBarcodeView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"설비상태변경"]){
        orgView.hidden = NO;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 27, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height);
        fccStatusView.frame = CGRectMake(fccStatusView.frame.origin.x, 62, fccStatusView.frame.size.width,fccStatusView.frame.size.height);
//        curdView.frame = CGRectMake(0, 98, 346, 40);
        _tableView.frame = CGRectMake(0, 139, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"철거"]){
        NSDictionary* dic = [Util udObjectForKey:USER_INFO];
        strUserOrgTypeCode = [dic objectForKey:@"orgTypeCode"];
        if (![strUserOrgTypeCode isEqualToString:@"INS_USER"]){
            fccStatusView.hidden = YES;
            wbsView.hidden = NO;
            receivedOrgView.hidden = NO;
            curdView.hidden = NO;
            
            receivedOrgView.frame = CGRectMake(receivedOrgView.frame.origin.x, 26, receivedOrgView.frame.size.width,receivedOrgView.frame.size.height);
            locBarcodeView.frame = CGRectMake(locBarcodeView.frame.origin.x, 61, locBarcodeView.frame.size.width,locBarcodeView.frame.size.height);
            locNameView.frame = CGRectMake(locNameView.frame.origin.x, 96, locNameView.frame.size.width,locNameView.frame.size.height);
            wbsView.frame = CGRectMake(wbsView.frame.origin.x, 131, wbsView.frame.size.width,wbsView.frame.size.height);
            fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 166, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height);
//            curdView.frame = CGRectMake(0, 201, 320, 40);
            _tableView.frame = CGRectMake(0, 242, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 70);
            isRequireLocCode = YES;
        }else{
            fccStatusView.hidden = YES;
            locBarcodeView.hidden = YES;
            locNameView.hidden = YES;
            wbsView.hidden = YES;
            
            orgView.hidden = NO;
            receivedOrgView.hidden = NO;
            fccBarcodeView.hidden = NO;
            curdView.hidden = NO;
            
            receivedOrgView.frame = CGRectMake(receivedOrgView.frame.origin.x, 26, receivedOrgView.frame.size.width,receivedOrgView.frame.size.height);
            fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 61, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height);
//            curdView.frame = CGRectMake(0, 96, 320, 40);
            
            _tableView.frame = CGRectMake(0, 131, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 70);
            isRequireLocCode = NO;
        }
    }
    else if(
            [JOB_GUBUN isEqualToString:@"고장등록"]
            ){
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        
        //스캔필수 버튼 비활성화
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = NO;
        [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked_disable"] forState:UIControlStateSelected];
        lblScan.textColor = RGB(120, 120, 96);
        
        fccBarcodeView.frame = CGRectMake(0, 28, 320,30); //설비바코드
        //picker lable
        lblPicker.text = @"고장코드";
        lblFccStatus.text = @"선택하세요.";
        lblFccStatus.textColor = [UIColor lightGrayColor];
        
        fccStatusView.frame = CGRectMake(fccStatusView.frame.origin.x, 58, fccStatusView.frame.size.width,fccStatusView.frame.size.height);
        picker = [[CustomPickerView alloc]
                  initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240)
                  data:@[@"선택하세요.",@"Z001:이상로그발생",@"Z002:H/W FAULT(동작불가)",@"Z003:절체 불량",
                         @"Z004:행업",@"Z005:서비스 불가",@"Z006:Power 불량",
                         @"Z007:FAN 불량",@"Z008:낙뢰피해",@"Z999:기타"]];
        picker.delegate = self;
        selectedPickerData = @"";
        failureContentView.hidden = NO;
        failureContentView.frame = CGRectMake(failureContentView.frame.origin.x, 95, failureContentView.frame.size.width, failureContentView.frame.size.height);
        if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"]){
            txtViewFailure.frame = CGRectMake(txtViewFailure.frame.origin.x, txtViewFailure.frame.origin.y, 170, txtViewFailure.frame.size.height);
            btnPicture.hidden = NO;
        }
        
        viewPictureButton.frame = CGRectMake(144, failureContentView.frame.origin.y + failureContentView.frame.size.height, 160, 125);
        [self.view addSubview:viewPictureButton];
        defaultImage = [btnPicture backgroundImageForState:UIControlStateNormal];
        
//        curdView.frame = CGRectMake(0, 159, 320, 40);
        _tableView.frame = CGRectMake(0, 199, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"납품취소"]){
        fccStatusView.hidden = YES;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        shapeView.hidden = YES;
        //스캔필수 버튼 비활성화
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = NO;
        [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked_disable"] forState:UIControlStateNormal];
        btnScan.enabled = NO;
        lblScan.textColor = RGB(120, 120, 96);
        btnMove.hidden = YES;
        btnInit.frame = CGRectMake(133, 5, 45,30);
        fccBarcodeView.frame = CGRectMake(2, 28, 318,30); //설비바코드
        uuView.hidden = YES;
//        curdView.frame = CGRectMake(0, 60, 320, 40); //3번째 라인
        
        // 삭제버튼 없음으로 인해 추가
        btnDelete.hidden = YES;
        btnInit.frame = CGRectMake(179, 5, 45, 30);
        
        _tableView.frame = CGRectMake(0, 100, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 70);
    }
    else if([JOB_GUBUN isEqualToString:@"배송출고"])
    {
        fccStatusView.hidden = YES;
        btnMove.hidden = YES;
        btnInit.frame = CGRectMake(133, 5, 45,30);
        lblLoc.text = @"수신위치";
        uuView.hidden = YES;
        shapeOrderView.hidden = NO;
        shapeView.hidden = YES;
        deliveryOrderView.hidden = NO;
//        deliveryOrderView.frame = CGRectMake(2, 117, 318,24);
        
//        curdView.frame = CGRectMake(2, 145, 320, 40);
        _tableView.frame = CGRectMake(0, 185, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if([JOB_GUBUN isEqualToString:@"납품입고"])
    {
        fccStatusView.hidden = YES;
        shapeOrderView.hidden = NO;
        shapeView.hidden = NO;
        uuView.hidden = NO;
        btnScan.hidden = YES;
        lblScan.hidden = YES;
        btnHierachy.selected = NO;
//        curdView.frame = CGRectMake(2, 145, 320, 40);
        _tableView.frame = CGRectMake(0, curdView.frame.origin.y + curdView.frame.size.height, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    else if ([JOB_GUBUN isEqualToString:@"고장정보"]){
        orgView.hidden = YES;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        curdView.hidden = YES;
        deviceIDView.hidden = NO;
        txtDeviceID.enabled = YES;
        btnDetailFccInfo.hidden = NO;
        
        fccBarcodeView.frame = CGRectMake(0, 2, 318,30); //설비바코드
        deviceIDView.frame = CGRectMake(0, 66, 318,30); //장치ID
        
        txtFacCode.frame = CGRectMake(txtFacCode.frame.origin.x, txtFacCode.frame.origin.y, 235, txtFacCode.frame.size.height);
        txtDeviceID.frame = CGRectMake(txtDeviceID.frame.origin.x, txtDeviceID.frame.origin.y, 235, txtDeviceID.frame.size.height);
        
        failureFccView.hidden = NO;
        failureDevView.hidden = NO;
        
        _tableView.frame = CGRectMake(0, 164, 320, PHONE_SCREEN_HEIGHT - (failureDevView.frame.origin.y + failureDevView.frame.size.height)  - 70);
        
    }else if ([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        orgView.hidden = YES;
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        moveCurdView.hidden = YES;
        curdView.hidden = YES;
        deviceIDView.hidden = NO;
        txtDeviceID.enabled = YES;
        btnDetailFccInfo.hidden = YES;
        
        _scrollView.hidden = NO;
        _tableView.hidden = YES;
        _tableView2.hidden = NO;
        
        fccBarcodeView.frame = CGRectMake(0, 2, 318,30); //설비바코드
        deviceIDView.frame = CGRectMake(0, 66, 318,30); //장치ID
        
        txtFacCode.frame = CGRectMake(txtFacCode.frame.origin.x, txtFacCode.frame.origin.y, 235, txtFacCode.frame.size.height);
        txtDeviceID.frame = CGRectMake(txtDeviceID.frame.origin.x, txtDeviceID.frame.origin.y, 235, txtDeviceID.frame.size.height);
        
        failureFccView.hidden = NO;
        failureDevView.hidden = NO;
        
        clv1.hidden = NO; clv2.hidden = YES;
        isFacQuMode = NO;
        
        _scrollView.frame = CGRectMake(0, (failureDevView.frame.origin.y + failureDevView.frame.size.height), 320, PHONE_SCREEN_HEIGHT - (failureDevView.frame.origin.y + failureDevView.frame.size.height + 80));
        _scrollView.contentSize = CGSizeMake(_tableView2.bounds.size.width, _scrollView.frame.size.height);
        
    }else if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        uuView.hidden = NO;
        upperFacView.hidden = NO;
        fccStatusView.hidden = YES;
        
        txtUFacCode.backgroundColor = (txtUFacCode.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        lblUFacCode.textColor = (txtUFacCode.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
        
        txtUFacCode.backgroundColor = (txtUFacCode.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
        
        upperFacView.frame = CGRectMake(upperFacView.frame.origin.x, fccBarcodeView.frame.origin.y + fccBarcodeView.frame.size.height, upperFacView.frame.size.width,upperFacView.frame.size.height);
//        curdView.frame = CGRectMake(0, 159, 320,40);
        _tableView.frame = CGRectMake(0, 199, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
        
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = NO;
        [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked_disable"] forState:UIControlStateSelected];
        
    }else if([JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
        locBarcodeView.hidden = YES;
        locNameView.hidden = YES;
        fccStatusView.hidden = YES;
        fccBarcodeView.frame = CGRectMake(fccBarcodeView.frame.origin.x, 26, fccBarcodeView.frame.size.width,fccBarcodeView.frame.size.height); //설비바코드
//        curdView.frame = CGRectMake(0, 61, 320, 40); //3번째 라인
        
        _tableView.frame = CGRectMake(0, 102, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height) - 80);
        
        btnScan.selected = YES;
        btnScan.userInteractionEnabled = YES;
        
    }
    else {
        _tableView.frame = CGRectMake(0, 197, 320, PHONE_SCREEN_HEIGHT - (curdView.frame.origin.y + curdView.frame.size.height)  - 70);
    }
    
    //jdh 추가
    if (!locBarcodeView.hidden && !txtLocCode.text.length){
        [self performSelectorOnMainThread:@selector(locBecameFirstResponder) withObject:nil waitUntilDone:NO];
    }
    else
        [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
}

-(void) setBecameResponder
{
    if (!txtLocCode.text.length && !locBarcodeView.hidden)
        [txtLocCode becomeFirstResponder];
    else if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
    else if (!txtDeviceID.text.length && !deviceIDView.hidden)
        [txtDeviceID becomeFirstResponder];
}

-(void) layoutControl
{
    
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        if ([originalSAPList count]){
            NSDictionary* dic = [originalSAPList objectAtIndex:0];
            NSString* partTypeName = [dic objectForKey:@"PART_NAME"];
            if ([partTypeName isEqualToString:@"R"]){
                txtUFacCode.enabled = NO;
                txtUFacCode.text = @"";
                txtDeviceID.enabled = YES;
            }
            else if ([partTypeName isEqualToString:@"S"]){
                txtUFacCode.enabled = YES;
                txtDeviceID.enabled = YES;
            }
            else if ([partTypeName isEqualToString:@"U"]){
                txtUFacCode.enabled = YES;
                txtUFacCode.text = @"";
                txtDeviceID.enabled = NO;
            }
            else if ([partTypeName isEqualToString:@"E"]){
                txtUFacCode.enabled = NO;
                txtUFacCode.text = @"";
                txtDeviceID.enabled = YES;
            }
            
            if ([strLocBarCode hasPrefix:@"VS"])
            {
                txtDeviceID.enabled = NO;
                txtDeviceID.text = lblDeviceID.text = strDeviceID = @"";
                [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
//                txtUFacCode.enabled = NO;
//                txtUFacCode.text = strUpperBarCode = @"";
            }
            
            txtDeviceID.backgroundColor = (txtDeviceID.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
            lblDeviceIDTitle.textColor = (txtDeviceID.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
            txtUFacCode.backgroundColor = (txtUFacCode.enabled)? [UIColor whiteColor]:[UIColor lightGrayColor];
            lblUFacCode.textColor = (txtUFacCode.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
            
        }
        
    }
    if (!lblLocName.text.length && !locBarcodeView.hidden)
        [txtLocCode becomeFirstResponder];
    
    else if(![txtFacCode isFirstResponder])
        [txtFacCode becomeFirstResponder];
}

// isOrgInheritance는 전송할 때 필요하다.
- (void) checkOrgInheritance
{
    if ([JOB_GUBUN isEqualToString:@"실장"]){
        // 스캔한 설비(SCANTYPE != "0")
        NSString* upperpartName = [WorkUtil getParentPartName:originalSAPList];
        
        if ([upperpartName isEqualToString:@"U"] || (strUpperBarCode.length && [upper_deviceID isEqualToString:strDeviceID])){
            isOrgInheritance = YES;
        }
        else{
            isOrgInheritance = NO;
        }
    }else if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        NSString* upperpartName = [WorkUtil getParentPartName:originalSAPList];
        
        if ([upperpartName isEqualToString:@"U"] || strUpperBarCode.length){
            isOrgInheritance = YES;
        }
        else{
            isOrgInheritance = NO;
        }
    }
}

// 스캔한 설비의 유효성 검사 및 필요에 따른 분기 처리
- (BOOL) processCheckScan:(NSString*)barcode
{
    NSString* message = nil;
    BOOL isExistInListThisBarcode = NO;
    
    // 테이블뷰에 이미 설비들이 있는 경우
    if (originalSAPList.count){
        int index = 0;
        NSString* scanType = nil;
        
        NSString* strBarcode = nil;
        if (strMoveBarCode.length)  // 송부취소, 접수(팀간)인 경우
            strBarcode = strMoveBarCode;
        else if (strFccBarCode.length)
            strBarcode = strFccBarCode;
        
        // 스캔한 바코드가 이미 리스트에 있는지 여부를 체크한다.
        index = [WorkUtil getBarcodeIndex:strBarcode fccList:originalSAPList];
        if (index != -1){ //바코드 존재 해당 배열에서 교체
            isExistInListThisBarcode = YES;
            
            // 실제 화면에 표시되어 있는 리스트는 fccSAPList, 실질적인 데이터를 갖고 있는 리스트는 originalSAPList
            // 이 둘의 싱크를 맞춰주어야 하므로...
            NSMutableDictionary* childDic = [originalSAPList objectAtIndex:index];
            
//      matsua : TODO. 불용대기 상태 변경시 알림.
//    입고(팀내), 설비상태변경 개별 설비스캔시 오늘날짜<=보증종료일(GWLEEN_O)일경우 메세지 출력 -> 확인 누르면 창닫힘(단순 알림) msg <무상교환/수리 확(보증기간 내 설비)>
//    GWLEEN_O 추가
//            if([childDic objectForKey:@"GWLEN_O"] != nil || ![[childDic objectForKey:@"GWLEN_O"] isEqualToString:@""]){
//                if([[NSDate TodayString] intValue] <= [[[childDic objectForKey:@"GWLEN_O"] stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue]){
//                    [self showMessage:@"<무상교환/수리 확(보증기간 내 설비)>" tag:-1 title1:@"닫기" title2:nil];
//                }
//            }
            
            scanType = [childDic objectForKey:@"SCANTYPE"];
            
            NSString* sapbarcode;
            if(strMoveBarCode.length){
                sapbarcode = [childDic objectForKey:@"EQUNR"];
                if (![strMoveBarCode isEqualToString:sapbarcode]){
                    if ([sapbarcode rangeOfString:strMoveBarCode].location != NSNotFound){
                        strMoveBarCode = sapbarcode;
                        txtFacCode.text = strMoveBarCode;
                    }
                }
            }
            else if (strFccBarCode.length){
                sapbarcode = [childDic objectForKey:@"EQUNR"];
                if (![strFccBarCode isEqualToString:sapbarcode]){
                    if ([sapbarcode rangeOfString:strFccBarCode].location != NSNotFound){
                        strFccBarCode = sapbarcode;
                        txtFacCode.text = strFccBarCode;
                        barcode = sapbarcode;
                    }
                }
            }
            
            if(![JOB_GUBUN isEqualToString:@"접수(팀간)"] && ![JOB_GUBUN isEqualToString:@"납품입고"] && ![JOB_GUBUN isEqualToString:@"납품취소"] && ![JOB_GUBUN isEqualToString:@"배송출고"] ){
                // 하위에 달린 설비가 있을 경우 바로 상위에 있는 설비를 먼저 스캔하지 않고, 하위설비를 스캔할 경우 오류메세지를 띄워준다.
                int parentIndex = [WorkUtil getParentIndex:[childDic objectForKey:@"HEQUNR"] fccList:originalSAPList];
                if (parentIndex != -1)
                {
                    NSDictionary* parentDic = [originalSAPList objectAtIndex:parentIndex];
                    NSString* parentScanValue = [parentDic objectForKey:@"SCANTYPE"];
                    if ([parentScanValue isEqualToString:@"0"]){
                        message = @"상위바코드를 스캔하세요.";
                        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                        isOperationFinished = YES;
                        
                        return NO;
                    }
                }
            }
            
            //스캔처리
            // scanType이 "0"인 경우는 scanType을 1로 변경한다.
            if ([scanType isEqualToString:@"0"]){
                //데이터 변경
                [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
                isDataSaved = NO;
                
                [childDic setObject:@"1" forKey:@"SCANTYPE"];
                [originalSAPList replaceObjectAtIndex:index withObject:childDic];
                nSelectedRow = index;
                
                // fccSAPList를 만들고, 화면도 반영
                [self reloadTableWithRefresh:YES];
                [self scrollToIndex:nSelectedRow];
            }
            // "0"이 아닌 경우는 중복스캔처리한다.
            else {
                message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",txtFacCode.text];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                
                // 스캔한 설비를 선택하는 것으로 표시하고 그쪽으로 스크롤도 이동함
                nSelectedRow = index;
                
                // fccSAPList를 만들고, 화면도 반영
                [self reloadTableWithRefresh:YES];
                [self scrollToIndex:nSelectedRow];
                
                isOperationFinished = YES;
                
                return NO;
            }
            
            [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
            
            // 작업관리 추가
            NSMutableDictionary* taskDic2 = [NSMutableDictionary dictionary];
            [taskDic2 setObject:@"F" forKey:@"TASK"];
            if(strFccBarCode != nil)
                [taskDic2 setObject:strFccBarCode forKey:@"VALUE"];
            else if (strMoveBarCode != nil)
                [taskDic2 setObject:strMoveBarCode forKey:@"VALUE"];
            
            [taskList addObject:taskDic2];
            
            if([JOB_GUBUN isEqualToString:@"고장등록"]){
                [self requestFccBreakDown:strFccBarCode];
            }
            
            isOperationFinished = YES;
        }
    }
    if (!isExistInListThisBarcode){ // 최초스캔이면(리스트에 설비정보가 없는 경우), 스캔한 설비가 리스트에 없는 경우
        // 접수(팀간)은 리스트에 없는 설비는 처리할 수 없다. -> 접수도 리스트에 없는 자기가 접수할 설비는 추가할 수 있다 - request by 박장수 : DR-2014-37505
        /*
         if([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
         NSString* message = @"'송부' 하지 않은 설비는\n'접수' 하실 수 없습니다.";
         [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
         isOperationFinished = YES;
         return NO;
         }
         */
        
        if (isOffLine)  // 음역지역작업인 경우
            [self setOfflineUFacCd:barcode];
        else{           // 음영지역작업이 아닌 경우
            if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] || [JOB_GUBUN isEqualToString:@"접수(팀간)"]){
                // 화면 로드되면서 requestMoveData하는 경우에는 isFirstMove = YES,
                // 그게 아니라 스캔에 의해 조회할때는 NO
                isFirstMove = NO;
                
                [self requestMoveData:barcode orgCode:@""];
            }
            else if ([JOB_GUBUN isEqualToString:@"납품입고"]){
                [self requestFccInfo:strFccBarCode];
            }
            else
                if([JOB_GUBUN isEqualToString:@"고장정보"]||[JOB_GUBUN isEqualToString:@"고장수리이력"]){
                    [self requestFccDetail:barcode];
                    repairHistory = nil;
                    [_tableView2 reloadData];
                    [Util setScrollTouch:scrollMaktx Label:txtMaktx withString:@""];
                    txtSubmt.text = @"";
                    lblCount.text = @"";
                }
                else{
                    [self requestSAPInfo:barcode locCode:@"" deviceID:@""];
                }
        }
    }
    
    return YES;
}

// 전송 validation 체크
//"스캔하신 장치바코드(%@)와 상위바코드의 장치바코드가 상이합니다." 인 경우의 처리
- (BOOL) processCheckChildTree
{
    NSString* message = nil;
    
    if (![JOB_GUBUN isEqualToString:@"납품취소"]){
        if(!btnScan.selected){  // 스캔필수가 아닌경우
            if (originalSAPList.count > 1){
                message = @"하위 설비를 포함하여\n처리됩니다.\n전송하시겠습니까?";
            }
            else {  // 이런 경우는 없지만...
                message = @"전송하시겠습니까?";
            }
            [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
            
            return NO;
        }
        // 스캔필수인 경우...
        else {
            BOOL __block errorFlag = NO;
            if (originalSAPList.count){
                // scanType이 "1", "2", "3"인 설비의 리스트를 얻어온다.
                NSIndexSet* scanIndexset = [WorkUtil getScanIndexes:originalSAPList];
                
                if (scanIndexset.count){
                    [scanIndexset enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
                        NSDictionary* dic = [originalSAPList objectAtIndex:index];
                        NSString* barcode = [dic objectForKey:@"EQUNR"];
                        // 스캔한 설비(scanType이 1, 2, 3인경우)의 하위(Child)설비 리스트를 childIndexset에 저장
                        NSIndexSet* childIndexset = [WorkUtil getChildBarcodeIndexes:barcode fccList:originalSAPList];
                        if (childIndexset.count){
                            // 하위 설비 중 스캔하지 않은 설비가 있다면 오류처리
                            [childIndexset enumerateIndexesUsingBlock:^(NSUInteger subindex, BOOL *stop) {
                                NSDictionary* childDic = [originalSAPList objectAtIndex:subindex];
                                NSString* scanType = [childDic objectForKey:@"SCANTYPE"];
                                if ([scanType isEqualToString:@"0"]){
                                    errorFlag = YES;
                                }
                            }];
                        }
                    }];
                }
            }
            if (errorFlag){
                message = @"스캔하지 않은 하위 설비가\n존재합니다.\n스캔하지 않은 하위 설비는 '분실위험'\n처리됩니다.\n그래도 전송하시겠습니까?";
                [self showMessage:message tag:500 title1:@"예" title2:@"아니오"];
                
                return NO;
            }
        }
    }
    return YES;
}

// 전송시 유효성 체크
- (BOOL) processCheckSendData
{
    NSString* message = nil;
    
    // 위치바코드를 스캔하지 않은 경우 오류처리
    if(!locBarcodeView.hidden && !lblLocName.text.length){
        message = @"위치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return NO;
    }
    
    // 고장등록인 경우 고장코드를 선택하지 않은 경우도 오류 처리
    if (
        [JOB_GUBUN isEqualToString:@"고장등록"]
        ){
        if (!selectedPickerData.length || [selectedPickerData hasPrefix:@"선택하세요"]){
            message = @"먼저 고장코드를 선택하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return NO;
        }
    }
    
    if (
        ![JOB_GUBUN isEqualToString:@"철거"] &&
        ![JOB_GUBUN isEqualToString:@"접수(팀간)"] &&
        ![JOB_GUBUN isEqualToString:@"송부취소(팀간)"] &&
        ![JOB_GUBUN isEqualToString:@"납품입고"] &&
        ![JOB_GUBUN isEqualToString:@"납품취소"] &&
        ![JOB_GUBUN isEqualToString:@"배송출고"]
        )
        
    {
        // 조직이 필요한데, 선택하지 않은 경우 오류처리
        if (!receivedOrgView.hidden){
            NSString* receivedOrgCode = [receivedOrgDic objectForKey:@"costCenter"];
            if (!receivedOrgCode.length){
                message = @"조직을 선택하세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                return NO;
            }
        }
    }
    
    // 장치바코드를 스캔하지 않은 경우 오류 처리
    if (!deviceIDView.hidden && !txtDeviceID.text.length && txtDeviceID.enabled ){
        message = @"장치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
        
        return NO;
        
    }
    // 스캔한 장치바코드가 유효하지 않은 경우 오류 처리
    else if (!deviceIDView.hidden && txtDeviceID.text.length !=9 && txtDeviceID.enabled){
        message = @"장치바코드의 형식이 잘 못 되었습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
        return NO;
    }
    
    // 상위바코드를 스캔하지 않은 경우 오류처리
    // 실장하려고 스캔한 최상위 설비가 Unit인 경우는 상위바코드를 반드시 입력해야 한다.
    NSString* upperpartName = [WorkUtil getParentPartName:originalSAPList];
    if ([JOB_GUBUN isEqualToString:@"실장"]){
        if (txtUFacCode.isEnabled && [upperpartName isEqualToString:@"U"] && !strUpperBarCode.length){
            NSString* message = @"실장하실 대상인\n상위바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return NO;
        }
    }else if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        if (txtUFacCode.isEnabled && [upperpartName isEqualToString:@"U"] && !strUpperBarCode.length){
            NSString* message = @"형상구성하실 대상인\n상위바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return NO;
        }
    }
    
    
    // 설비바코드 리스트가 없는 경우 오류처리
    if (!fccBarcodeView.hidden && !originalSAPList.count){
        message = @"전송할 설비바코드가\n존재하지 않습니다";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return NO;
    }
    
    
    /*
     2. 스캔한 상위바코드가 Equipment 일 경우 (표준랙에 Shelf형 장비 실장)
     상위바코드의 장치바코드 ＝ 스캔한 장치바코드 -> Error 처리함.
     (Equipment 및 Shelf형 장비는 각각 별개의 장치바코드를 가지고 있음)
     ==> Error Message "스캔한 장치바코드와 상위바코드(Equipment)의 장치바코드가 동일하여
     처리할 수 없으므로 상위바코드를 스캔하지 않거나 스캔한 장치바코드를 확인하세요."
     이와 별개로 Shelf 실장 시 상위바코드가 Equipment 일 경우 E-S-U 의 형상을 구성하지 않고
     위치 밑에 S-U 형상으로 내부적으로 처리할려고 합니다. 작업자는 물리적인 위치에서 상위바코드가
     Rack or Equipment 의 구분을 하지 않고 스캔을 하며,  Equipment의 하위에는 Shelf가 위치할 수 없기 때문입니다.
     (Equipment는 Shelf 와 동일한 Level로 위치함)
     ==> Shelf 실장 시 스캔한 상위바코드가 Equipment 일 경우 상위바코드 필드에 Equipment 를 I/F 하지
     않으면 됩니다.
     */
    
    if ([JOB_GUBUN isEqualToString:@"실장"])
    {
        if (strDeviceID.length && upper_deviceID.length){
            if ([lblUpperPartType.text isEqualToString:@"E"])
            {
                if ([upper_deviceID isEqualToString:strDeviceID]){
                    message = [NSString stringWithFormat:@"스캔하신 장치바코드(%@)와\n 상위바코드의 장치바코드\n(%@)가 동일하여 \
                               처리할 수 없으므로 \n상위바코드를 스캔하지 않거나 스캔한 장치바코드를 확인하세요.",strDeviceID,upper_deviceID];
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    return NO;
                }
            }
            else {
                // alert에서 "예"클릭시 [self processCheckChildTree] 호출
                if (![upper_deviceID isEqualToString:strDeviceID]){
                    message = [NSString stringWithFormat:@"스캔하신 장치바코드(%@)와\n상위바코드의 장치바코드(%@)\n가 상이합니다.\n처리하시겠습니까?",strDeviceID,upper_deviceID];
                    [self showMessage:message tag:300 title1:@"예" title2:@"아니오"];
                    return NO;
                }
            }
        }
    }
    
    // 스캔필수가 아닌경우
    if(!btnScan.hidden && !btnScan.selected){
        if (originalSAPList.count > 1){
            message = @"하위 설비를 포함하여\n처리됩니다.\n전송하시겠습니까?";
        }
        else {
            message = @"전송하시겠습니까?";
        }
        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
        return NO;
    }
    //스캔필수인 경우
    else {
        if (![JOB_GUBUN isEqualToString:@"송부취소(팀간)"]
            )
        {
            BOOL __block errorFlag = NO;
            if ([JOB_GUBUN isEqualToString:@"접수(팀간)"])
            {
                // 스캔한 설비(scanType이 1, 2, 3인경우)의 하위(Child) 설비중 스캔하지 않은 설비가 하나라도 있으면 오류처리하고,
                // 전송여부를 묻는다.
                if (originalSAPList.count){
                    // 스캔값이 "1", "2", "3"인 리스트 생성
                    NSIndexSet* scanIndexset = [WorkUtil getScanIndexes:originalSAPList];
                    if (scanIndexset.count){
                        [scanIndexset enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
                            //                            NSLog(@"enum index[%d]",index);
                            NSDictionary* dic = [originalSAPList objectAtIndex:index];
                            NSString* barcode = [dic objectForKey:@"EQUNR"];
                            
                            // 스캔한 설비의 Child list생성
                            NSIndexSet* childIndexset = [WorkUtil getChildBarcodeIndexes:barcode fccList:originalSAPList];
                            // 그 중 스캔하지 않은 설비가 있다면 오류 처리
                            if (childIndexset.count){
                                [childIndexset enumerateIndexesUsingBlock:^(NSUInteger subindex, BOOL *stop) {
                                    //                                    NSLog(@"enum subindex[%d]",subindex);
                                    NSDictionary* childDic = [originalSAPList objectAtIndex:subindex];
                                    NSString* scanType = [childDic objectForKey:@"SCANTYPE"];
                                    if ([scanType isEqualToString:@"0"]){
                                        errorFlag = YES;
                                    }
                                }];
                            }
                        }];
                    }
                }
            }
            // 접수(팀간)외의 작업일 경우에는 전체 리스트에서 스캔하지 않은 설비가 하나라도 있으면 오류처리
            else {
                if (originalSAPList.count){
                    for(NSDictionary* dic in originalSAPList){
                        NSString* scanType = [dic objectForKey:@"SCANTYPE"];
                        if ([scanType isEqualToString:@"0"]){
                            errorFlag = YES;
                            break;
                        }
                    }
                }
            }
            
            if (errorFlag){
                if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                    message = @"스캔하지 않은 설비가\n존재합니다.\n대상 설비 전체를 스캔하지 \n않을 경우 작업이 불가합니다";
                    [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
                    return YES;
                }else{
                    message = @"스캔하지 않은 하위 설비가\n존재합니다.\n스캔하지 않은 하위 설비는 '분실위험'\n처리됩니다.\n그래도 전송하시겠습니까?";
                    
                    // tag:100 => 전송하시겠습니까?  묻지 않고,
                    // tag: 500 => 전송하시겠습니까를 다시 묻는다.
                    // 이렇게 할필요가 있나...?
                    if ([JOB_GUBUN isEqualToString:@"납품입고"] ||
                        [JOB_GUBUN isEqualToString:@"납품취소"] ||
                        [JOB_GUBUN isEqualToString:@"배송출고"])
                        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                    else
                        [self showMessage:message tag:500 title1:@"예" title2:@"아니오"];
                    return NO;
                }
            }
            else {  // 오류가 아닌경우...  전송
                if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                    if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                        [self checkOrgInheritance];
                    }
                    
                    if ([self processSendCheckOrganization]){
                        message = @"전송하시겠습니까?";
                        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                    }
                }else if([JOB_GUBUN isEqualToString:@"입고(팀내)"]){
                    if([locType isEqualToString:@"06"]){
                        NSString* zsetup_message = @"";
                        if (originalSAPList.count){
                            for(NSDictionary* dic in originalSAPList){
                                NSString *ZSETUP = [dic objectForKey:@"ZSETUP"];
                                
                                if(![ZSETUP isEqualToString:@"0"] &&
                                   ![ZSETUP isEqualToString:@"0.00"] &&
                                   ![ZSETUP isEqualToString:@""] &&
                                   ZSETUP != nil){
                                    zsetup_message = [NSString stringWithFormat:@"%@%@\n",zsetup_message,[dic objectForKey:@"EQUNR"]];
                                }
                                
                                
                            }
                        }
                        
                        if(zsetup_message.length > 0){
                            zsetup_message = [NSString stringWithFormat:@"설비바코드\n%@는 입고처리 전 철거관리 메뉴에서\n철거SCAN을 반드시 수행하셔야 합니다.\n철거관리 메뉴로 이동하시겠습니까?",zsetup_message];
                            [self showMessage:zsetup_message tag:1200 title1:@"예" title2:@"아니오"];
                        }
                        else{
                            message = @"전송하시겠습니까?";
                            [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                        }
                    }else{
                        message = @"전송하시겠습니까?";
                        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                    }
                }
                else{
                    message = @"전송하시겠습니까?";
                    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                }
            }
            
        }
        else { //송부취소(팀간)
            message = @"전송하시겠습니까?";
            [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
        }
        return YES;
        
    }
    
    return YES;
}

// 실장 상속받지 않고 첫번째이면서 쉘프이면 - 운용조직 변경여부 물어본다. 유닛실장은 상위 바코드의 조직 무조건 상속
// 상위바코드를 스캔한 경우, 상위바코드의 장치 바코드와 스캔한 장치바코드가 같은 경우도 조직 상속
- (BOOL) processSendCheckOrganization
{
    NSString* message = nil;
    NSString* upperpartName = [WorkUtil getParentPartName:originalSAPList];
    
    NSLog(@"CHKZKOSTL_INSTCONF == %@", CHKZKOSTL_INSTCONF);
    
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        CHKZKOSTL_INSTCONF = @"";
        
        if (isOrgInheritance) {
            // 상위설비의 운용조직과 최초 스캔한 설비의 운용조직 상이 시...
            if (originalSAPList.count){
                NSDictionary* firstDic = [originalSAPList firstObject];
                first_FccOrgCode = [firstDic objectForKey:@"ZKOSTL"];
                first_FccOrgName = [firstDic objectForKey:@"ZKTEXT"];
            }
            if (upper_OperOrgCode.length && first_FccOrgCode.length && ![first_FccOrgCode isEqualToString:upper_OperOrgCode]){
                [Util udSetBool:YES forKey:@"IS_DATA_MODIFIED"];
                isDataSaved = NO;
                
                message = [NSString stringWithFormat:@"%@ 대상 설비의 운용조직\n(%@)을\n상위설비의 운용조직\n(%@)으로\n변경합니다.\n진행하시겠습니까?",JOB_GUBUN,first_FccOrgName,upper_OperOrgName];
                [self showMessage:message tag:400 title1:@"예" title2:@"아니오"];
                
                return NO;
            }
            
        }
        else { //조직 상속 받지않으면 Y/N 체크
            if ([upperpartName isEqualToString:@"S"]) {// 쉘프 실장 시 하위 포함 일괄 운용조직 변경 여부 셋팅
                if (originalSAPList.count){
                    NSDictionary* dic = [originalSAPList objectAtIndex:0];
                    NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
                    NSString* barcode = [dic objectForKey:@"EQUNR"];
                    NSString* orgName = [dic objectForKey:@"ZKTEXT"];
                    
                    if (![strUserOrgCode isEqualToString:orgCode])
                    {
                        message = [NSString stringWithFormat:@"'%@'의 운용조직은\n'%@'입니다.\n운용조직을 '%@'으로\n변경하시겠습니까?",barcode,orgName,strUserOrgName];
                        [self showMessage:message tag:700 title1:@"예" title2:@"아니오"];
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

// 스캔한 설비의 조직을 변경여부 결정
- (BOOL) processCheckOrganization:(NSDictionary*)dic
{
    NSString* barcode = nil;
    NSString* orgName = nil;
    NSString* orgCode = nil;
    
    if ([dic objectForKey:@"EQUNR"]){
        barcode = [dic objectForKey:@"EQUNR"];
        orgName = [dic objectForKey:@"ZKTEXT"];
        orgCode = [dic objectForKey:@"ZKOSTL"];
    }
    else {  // 송부(취소), 접수(팀간)인 경우
        barcode = [dic objectForKey:@"BARCODE"];
        orgName = [dic objectForKey:@"EXZKOSTLTXT"];
        orgCode = [dic objectForKey:@"EXZKOSTL"];
    }
    
    NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
    NSString *parentsType = @"";
    
    if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        if([fccSAPList count] == 0){
            parentsType = [dic objectForKey:@"PART_NAME"];
        }else{
            parentsType = [[fccSAPList objectAtIndex:0] objectForKey:@"PART_NAME"];
        }
    }
    
    if (
        ([JOB_GUBUN isEqualToString:@"실장"] && ([partTypeName isEqualToString:@"U"] || [partTypeName isEqualToString:@"S"]))          ||
        ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"] && ([parentsType isEqualToString:@"U"] || [parentsType isEqualToString:@"S"])) ||
        [JOB_GUBUN isEqualToString:@"배송출고"]         ||
        [JOB_GUBUN isEqualToString:@"납품취소"]         ||
        [JOB_GUBUN isEqualToString:@"접수(팀간)"]       ||
        [JOB_GUBUN isEqualToString:@"설비정보"]         ||
        isChangeViewMode
        )
    {
        //조직변경여부 묻지 않음
        return YES;
    }
    
    // 송부취소(팀간)은 폐지 조직일 경우 폐지조직임을 알리고 진행 여부 표시
    if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"] && [orgName rangeOfString:@"폐지"].length) {
        NSString* message = [NSString stringWithFormat:@"'%@'의 운용조직은\n'%@' 으로 폐지 조직입니다.\n처리 시 조직은 '%@'(으)로\n변경됩니다.\n\r처리하시겠습니까?",barcode,orgName,strUserOrgName];
        [[ERPAlert getInstance] showAlertMessage:message tag:200 title1:@"예" title2:@"아니오" isError:NO isCheckComplete:YES delegate:self];
        if (isOrgChanged == YES)
        {
            isOrgChanged_Quit = NO;
        } else {
            // 처리하시겠습니까? 'N'이면 그냥 빠져나가야 한다.....
            isOrgChanged_Quit = YES;
        }
        return NO;
    }
    if (![strUserOrgCode isEqualToString:orgCode])
    {
        NSString* message = [NSString stringWithFormat:@"'%@'의 운용조직은\n'%@'입니다.\n운영조직을 '%@'(으)로\n변경하시겠습니까?",barcode,orgName,strUserOrgName];
        [[ERPAlert getInstance] showAlertMessage:message tag:200 title1:@"예" title2:@"아니오" isError:NO isCheckComplete:YES delegate:self];
        
        return NO;
    }
    // 조직이 같은 경우에는 변경할 필요가 없으므로
    else {
        isOrgChanged = NO;
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

// 현재 리스트에 있는 설비의 조직을 바탕으로 조직 리스트를 만든다. (접수, 송부조직리스트)
// 조직을 선택하면 그 조직에 해당하는 설비 리스트를 다시 만든다.
// 그럴 때마다 조직리스트를 다시 만들어야 한다.
- (void) makeOrgList
{
    if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        NSMutableArray* uniqueCostCenter = [NSMutableArray array];
        NSInteger index = 0;
        for(NSDictionary* dic in originalSAPList){
            NSString* skostl = [dic objectForKey:@"SKOSTL"];
            if (index == 0)
                [uniqueCostCenter addObject:skostl];
            else{
                BOOL isDup = NO;
                for (NSString* s in uniqueCostCenter){
                    if ([skostl isEqualToString:s]){
                        isDup = YES;
                        break;
                    }
                }
                if (isDup)  continue;
                else
                    [uniqueCostCenter addObject:skostl];
            }
            index++;
        }
        
        // 리스트에 있는 설비조직을 바탕으로 만는 SKOSTL리스트로
        uniqueOrgList = [NSMutableArray array];
        int i = 0;
        for (NSString* string in uniqueCostCenter)
        {
            NSMutableDictionary* unionDic = [NSMutableDictionary dictionary];
            [unionDic setObject:string forKey:@"costCenter"];
            NSString* addString = [string substringFromIndex:1];
            [unionDic setObject:addString forKey:@"orgCode"];
            int index = [WorkUtil getSendOrgIndex:string fccList:originalSAPList];
            if (index != -1){
                NSDictionary* orgNameDic = [originalSAPList objectAtIndex:index];
                [unionDic setObject:[orgNameDic objectForKey:@"SKOSTLTXT"] forKey:@"orgName"];
            }
            [uniqueOrgList addObject:unionDic];
            i++;
        }
        //        NSLog(@"uniqueOrgList [%@]",uniqueOrgList);
    }
    
    // 조직을 선택할 때마다 그에 따른 설비리스트가 달라진다.
    // 이때마다 새로운 리스트를 firstFccSAPList에 카피한다.  스캔취소시 처음 로드한 리스트로 표현하기 위해서 필요하다.
    firstFccSAPList = [NSMutableArray arrayWithArray:originalSAPList];
}

#pragma mark - UserDefine Action
// TableView에서 각 셀에 +, -를 클릭한 경우
// 하위 설비를 보여줬다 감췄다한다.
- (void) touchTreeBtn:(id)sender
{
    int nTag = (int)[sender tag];
    nSelectedRow = nTag;
    // 선택한 아이템 정보를 얻어온다.
    NSMutableDictionary* selItemDic = [fccSAPList objectAtIndex:nTag];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    //    NSLog(@"selItemDic [%@]",selItemDic);
    
    // 현재의 expose상태를 얻어온다.
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
        
    }
    // 카테고리가 있는 경우는 열린경우와 닫힌 경우가 있다.
    else{
        // 현재 상태가 열러있다면 닫아야 하므로 하위의 설비를 삭제해주어야 한다.
        if (cellStatus == SUB_CATEGORIES_EXPOSED){ //delete (collapse)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_NO_EXPOSE] forKey:@"exposeStatus"];
            // fccSAPList를 만들고, 화면도 반영
            [self reloadTableWithRefresh:YES];
        }
        // 현재 상태가 닫여 있다면, 열어줘야 하므로 하위 설비를 추가해 주어야 한다.
        else { //insert (expand)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            // fccSAPList를 만들고, 화면도 반영
            [self reloadTableWithRefresh:YES];
        }
    }
}

// 현재작업에서 빠져나감
- (void) touchBackBtn:(id)sender
{
    if (picker.isShow)
        [picker hideView];
    
    // 수정한 정보가 있는 경우, 작업관리에 저장하지 않고, 나가려고 하면 메시지 출력한다.
    if (![JOB_GUBUN isEqualToString:@"설비정보"] && [Util udBoolForKey:IS_DATA_MODIFIED] && !isDataSaved){
        NSString* message = @"수정한 자료가 존재합니다.\n저장하지 않고 종료하시겠습니까?";
        [self showMessage:message tag:1100 title1:@"예" title2:@"아니오"];
    }
    else{
        [txtFacCode resignFirstResponder];
        [txtLocCode resignFirstResponder];
        [txtViewFailure resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 고장등록인 경우 사진을 찍거라 카메라롤에서 선택하고자 할 경우
// 이미 사진이 선택되었다면, 확대해서 보여줄 것인지도 선택할 수 있다.
- (IBAction)touchPictureBtn:(id)sender {
    // 설비리스트가 없거나 선택된 항목이 없는 경우에는 오류처리
    if (originalSAPList.count <= 0 || nSelectedRow < 0){
        NSString* message = @"고장등록할 항목을 선택하신 후\n사진관련 작업을 하실 수 있습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
        
        return;
    }
    
    // 버튼하나로 뷰를 나타냈다 감췄다하기 위해서(toggle button)
    isSelPicView = !isSelPicView;
    
    if (isSelPicView){
        if ([[fccSAPList objectAtIndex:nSelectedRow] objectForKey:@"PICTURE"] == nil){
            btnZoomPic.enabled = NO;
        }
        else{
            btnZoomPic.enabled = YES;
        }
        
        viewPictureButton.hidden = NO;
    }else{
        viewPictureButton.hidden = YES;
    }
}

// 선택된 이미지를 확대해서 보여주는 버튼
- (IBAction)touchZoomPic:(id)sender {
    isSelPicView = NO;
    viewPictureButton.hidden = YES;
    
    NSDictionary* selItemDic = [fccSAPList objectAtIndex:nSelectedRow];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    
    ZoomPicViewController* vc = [[ZoomPicViewController alloc] init];
    vc.imageFailure = [itemInFullListDic objectForKey:@"PICTURE"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 해당 설비의 고장상태를 사진 찍는 버튼
- (IBAction)touchTakePic:(id)sender {
    isSelPicView = NO;
    viewPictureButton.hidden = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

// 카메라 롤에서 사진 선택
- (IBAction)touchSelectCameraRoll:(id)sender {
    isSelPicView = NO;
    viewPictureButton.hidden = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}


- (IBAction) touchShowPicker:(id)sender
{
    [txtFacCode resignFirstResponder];
    [txtLocCode resignFirstResponder];
    [txtViewFailure resignFirstResponder];
    [picker showView];
}

- (IBAction) touchOrgBtn:(id)sender
{
    //음영지역 아닐때만 호출
    if (isOffLine){
        NSString* message = @"'음영지역작업' 중에는\n조직을 선택할 수 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    
    // 설비리스트에 있는 설비의 조직을 기반으로 조직 리스트를 생성한다.
    [self makeOrgList];
    
    OrgSearchViewController* vc = [[OrgSearchViewController alloc] init];
    vc.Sender = self;
    if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        vc.isSearchMode = YES;
        vc.orgList = uniqueOrgList;
    }
    else
        vc.isSearchMode = NO;
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction) touchFccInfoBtn:(id)sender
{
    if([JOB_GUBUN isEqualToString:@"고장정보"]){
        [self fccDetailScreen];
        return;
    }
    
    // 조회한 설비리스트가 없는 경우는 오류처리
    if (originalSAPList.count <= 0){
        NSString* message = @"상세조회 하실 설비바코드를\n선택하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    // 설비상세정보화면을 띄워준다.
    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
    if (originalSAPList.count){
        NSDictionary* subDic = [fccSAPList objectAtIndex:nSelectedRow];
        NSDictionary* selItemdic = [WorkUtil getItemFromFccList:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList];
        
        vc.paramBarcode = [selItemdic objectForKey:@"EQUNR"];
        
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fccDetailScreen{
    if(txtFacCode.text.length <= 0){
        NSString* message = @"상세조회 하실 설비바코드를\n입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
    vc.paramBarcode = txtFacCode.text;
    vc.paramScreenCode = @"고장정보";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) touchSendBtn:(id)sender
{
    isGwlenListSend = NO;
    
    // 음영지역에서 작업할 경우에는 전송하지 못한다.
    if (isOffLine){
        NSString* message = MESSAGE_CANT_SEND_OFFLINE;
        [self showMessage:message tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    
    // 추가 작업을 하지 않은 경우에는 전송할때 메시지를 띄워준다.
    if (![Util udBoolForKey:IS_DATA_MODIFIED]){
        NSString* message = NOT_CHANGE_SEND_MESSAGE;
        
        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        return;
    }
    // 전송에 필요한 유효성 검사 후 전송
    [self processCheckSendData];
}

- (IBAction) touchSaveBtn:(id)sender
{
    //고장내역 저장
    if (!failureContentView.hidden && txtViewFailure.text.length)
        [workDic setObject:txtViewFailure.text forKey:@"COMMENT"];
    
    // 현재까지의 작업을 작업관리 DB에 저장한다.
    if([self saveToWorkDB]){
        NSString* message = @"저장하였습니다.";
        isDataSaved = YES;
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

// 바탕화면을 터치하면 키보드를 내려준다.  사실 제기능을 하지 못한다.
// 바탕에 여유공강이 없어서....
- (IBAction)touchBackground:(id)sender
{
    [txtLocCode resignFirstResponder];
    [txtFacCode resignFirstResponder];
    [txtViewFailure resignFirstResponder];
}

- (IBAction)touchUUBtn:(id)sender
{
    btnUU.selected = !btnUU.selected;
    
    // 작업관리 추가
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"UU_YN" forKey:@"TASK"];
    [taskDic setObject:(btnUU.selected)? @"Y":@"N" forKey:@"VALUE"];
    [taskList addObject:taskDic];
}

// 스캔필수버튼
- (IBAction)touchScanBtn:(id)sender
{
    NSString* message = nil;
    
    btnScan.selected = !btnScan.selected;
    [workDic setObject:(btnScan.selected)? @"Y":@"N" forKey:@"SCAN_YN"];
    
    if (btnScan.selected){
        message = [NSString stringWithFormat:@"'%@' 하실 설비를\n모두 스캔하세요.\n스캔하지 않은 설비는 '분실위험'\n처리됩니다.",JOB_GUBUN];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        btnDelete.enabled = YES;
        
        //작업관리에 추가
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"SCAN_YN" forKey:@"TASK"];
        [taskDic setObject:@"Y" forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else{
        message = @"스캔이 원칙입니다.\n스캔 없이 하위 포함 일괄 처리에\n대한 모든 책임은\n담당자에게 있습니다.\n진행 하시겠습니까?";
        [self showMessage:message tag:800 title1:@"예" title2:@"아니오"];
    }
    
    [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
}

- (IBAction) touchDeleteBtn:(id)sender
{
    NSString* message = nil;
    
    if (originalSAPList.count > 0 && fccSAPList.count -1 >= nSelectedRow){
        
        NSDictionary* subDic = [fccSAPList objectAtIndex:nSelectedRow];
        NSMutableDictionary* dic = (NSMutableDictionary*)[WorkUtil getItemFromFccList:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList];
        
        if (
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"접수(팀간)"]
            ){ //스캔취소
            NSString* scanType = [dic objectForKey:@"SCANTYPE"];
            if ([scanType isEqualToString:@"1"]){
                [self deleteBarcode:[subDic objectForKey:@"EQUNR"]];
            }
            else if ([scanType isEqualToString:@"2"] || [scanType isEqualToString:@"3"]){
                NSString* barcode = [dic objectForKey:@"EQUNR"];
                
                // 하위 설비가 있는 경우와 그렇지 않은 경우의 삭제 경고 메시지가 달라진다.
                NSIndexSet* indexset = [WorkUtil getChildBarcodeIndexes:barcode fccList:originalSAPList];
                if (indexset.count >= 1)
                    message = @"선택된 항목의 하위 설비를 포함하여\n삭제됩니다.\n삭제하시겠습니까?";
                else
                    message = @"삭제하시겠습니까?";
                [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
            }
        }
        else {
            NSString* scanType = [dic objectForKey:@"SCANTYPE"];
            // 스캔한 설비가 아니라 서버에서 딸려온 설비는 삭제가 불가능하다.
            if (![scanType isEqualToString:@"2"] && ![scanType isEqualToString:@"3"]){
                message = @"조회된 설비바코드는\n삭제하실 수 없습니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            }else{
                NSString* barcode = [dic objectForKey:@"EQUNR"];
                
                // 하위 설비가 있는 경우와 그렇지 않은 경우의 삭제 경고 메시지가 달라진다.
                NSIndexSet* indexset = [WorkUtil getChildBarcodeIndexes:barcode fccList:originalSAPList];
                if (indexset.count >= 1)
                    message = @"선택된 항목의 하위 설비를 포함하여\n삭제됩니다.\n삭제하시겠습니까?";
                else
                    message = @"삭제하시겠습니까?";
                [self showMessage:message tag:600 title1:@"예" title2:@"아니오"];
            }
        }
    }
    else if (originalSAPList.count <= 0 || nSelectedRow < 0 || nSelectedRow == NSNotFound){
        [self showMessage:@"선택된 항목이 없습니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

-(IBAction)touchInit{
    txtFacCode.text = strFccBarCode = strMoveBarCode = @"";
    txtSubmt.text = @"";
    txtMaktx.text = @"";
    
    txtDeviceID.text = strDeviceID  = @"";
    txtDeviceCd.text = @"";
    
    repairHistory = [NSMutableArray array];
    [_tableView reloadData];
    
    [txtFacCode becomeFirstResponder];
}

- (IBAction) touchInitBtn
{
    if (picker.isShow)
        [picker hideView];
    
    isFirst = YES;
    
    //textfield 초기화
    txtLocCode.text = strLocBarCode = @"";
    txtFacCode.text = strFccBarCode = strMoveBarCode = @"";
    txtDeviceID.text = strDeviceID  = @"";
    txtUFacCode.text = strUpperBarCode = @"";
    lblDeviceID.text = @"";
    lblPartType.text = @"";
    upper_deviceID = @"";
    upper_OperOrgCode = @"";
    upper_OperOrgName = @"";
    
    if ([JOB_GUBUN isEqualToString:@"고장등록"])
        [btnPicture setBackgroundImage:defaultImage forState:UIControlStateNormal];
    
    
    txtViewFailure.text = @"";
    
    
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        txtDeviceID.enabled = txtUFacCode.enabled = NO;
        lblDeviceIDTitle.textColor = (txtDeviceID.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
        lblUFacCode.textColor = (txtUFacCode.enabled)? [UIColor blackColor] : [UIColor lightGrayColor];
    }
    
    if (!btnScan.selected)
        btnScan.selected = YES;
    btnDelete.enabled = btnScan.selected;
    btnHierachy.selected = YES;
    
    //U-U 버튼 초기화
    btnUU.enabled = YES;
    btnUU.selected = NO;
    
    //형상구성여부
    if (!shapeView.hidden && !btnHierachy.hidden)
        [workDic setObject:(btnHierachy.selected)? @"Y":@"N" forKey:@"TREE_YN"];
    
    //접수조직 초기화 안함?
    if ([JOB_GUBUN isEqualToString:@"접수(팀간)"])
    {
        if (!receivedOrgView.hidden){
            lblReceivedOrg.text = @"";
            receivedOrgDic = [NSMutableDictionary dictionary];
        }
    }
    
    
    //위치바코드 포커싱
    if (!locBarcodeView.hidden){
        if (![txtLocCode isFirstResponder])
            [txtLocCode becomeFirstResponder];
    }
    else if (!fccBarcodeView.hidden){
        if (![txtFacCode isFirstResponder])
            [txtFacCode becomeFirstResponder];
    }
    
    if (!locNameView.hidden){
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
    }
    
    if (!deviceInfoView.hidden)
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
    
    //table초기화
    fccSAPList = [NSMutableArray array];
    originalSAPList = [NSMutableArray array];
    [_tableView reloadData];
    [self showCount];
    nSelectedRow = -1;
    
    if (![JOB_GUBUN isEqualToString:@"고장등록"])
        [picker selectPicker:1];
    
    if (
        [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
        [JOB_GUBUN isEqualToString:@"접수(팀간)"]
        )
    {
        isFirstMove = YES;
        [self requestMoveData:@"" orgCode:strUserOrgCode];
    }
    
    if ([JOB_GUBUN isEqualToString:@"고장등록"]){
        lblFccStatus.text = @"선택하세요.";
        lblFccStatus.textColor = [UIColor lightGrayColor];
    }
    
    //데이터 변경 없음
    [Util udSetBool:NO forKey:IS_DATA_MODIFIED];
    
    //작업관리 초기화
    dbWorkDic = [NSMutableDictionary dictionary];
    [self workDataInit];
    
    if ([JOB_GUBUN isEqualToString:@"납품입고"]){ //가상창고 불러온다.
        btnHierachy.selected = NO;
        [self requestLogicalLocCode:YES locBarcode:@""];
    }
}

// 형상구성 버튼
- (IBAction)touchHierachyBtn:(id)sender {
    btnHierachy.selected = !btnHierachy.selected;
    
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"TREE_YN" forKey:@"TASK"];
    [taskDic setObject:(btnHierachy.selected)? @"Y":@"N" forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    btnUU.enabled = btnHierachy.selected;
}

// 배송오더버튼
- (IBAction)touchDeliveryOrderBtn:(id)sender {
    btnDeliveryOreder.selected = !btnDeliveryOreder.selected;
    [workDic setObject:(btnDeliveryOreder.selected)? @"Y":@"N" forKey:@"ORDER_YN"];
}

// 이동버튼 클릭하면 추가적 뷰가 나타난다.  여기서 취소하면 이 뷰가 사라지고, 이동기능이 취소된다.
- (IBAction)touchCancelBtn:(id)sender {
    if (isMove){
        isMove = NO;
        moveView.hidden = YES;
    }
    [txtFacCode becomeFirstResponder];
}

- (IBAction)touchMoveBtn:(id)sender {
    if (!isMove){
        if (nSelectedRow < 0){
            NSString* message = @"선택된 항목이 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return;
        }
        // isMove는 현재 이동모드에 진입했을을 알수 있는 변수이다.
        isMove = YES;
        // moveView를 띄워준다.
        moveView.hidden = NO;
        
        // 키보드가 올라와 있다면 내려준다.
        [txtLocCode resignFirstResponder];
        [txtDeviceID resignFirstResponder];
        [txtFacCode resignFirstResponder];
    }
}

#pragma mark - Camera Delegate
// 사진 촬영
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSDictionary* selItemDic = [fccSAPList objectAtIndex:nSelectedRow];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    
    [itemInFullListDic setObject:image forKey:@"PICTURE"];
    
    [btnPicture setBackgroundImage:image forState:UIControlStateNormal];
    // 사용자가 애플리케이션의 뷰 화면으로 돌아갈수 있도록 이미지 피커를 종료시킨다.
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

// 카메라 롤 선택
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDictionary* selItemDic = [fccSAPList objectAtIndex:nSelectedRow];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    // 현재 포토 이미지뷰에다 선택한 이미지를 로드함
    [itemInFullListDic setObject:image forKey:@"PICTURE"];
    [btnPicture setBackgroundImage:image forState:UIControlStateNormal];
    
    // 이미지 피커뷰 내리기
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

// 사용자가 취소버튼을 누르면 그 밖의 다른 어떤 동작도 필요하지 않지만, 이미지 피커를 종료시키는 작업을 해야한다.
// 그렇게 되지 않으면 뷰를 가린 채로 이미지 피커가 여전히 화면상에 나타나 있을것이다.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
-(void) clickedButtonAtIndex:(NSInteger)buttonIndex alertView:(AlertViewController*)alertView;
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![Util udBoolForKey:IS_ALERT_COMPLETE])
        [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    if (alertView.tag == 100){ //전송
        if (buttonIndex == 0){
            // 납품취소일 경우에는 설비들의 전송 유효성을 검사한 후
            // 모든 설비의 유효성이 성공인 경우에만 전송하고,
            // 그렇지 않은 경우에는 전송하지 않는다.
            if ([JOB_GUBUN isEqualToString:@"납품취소"]){
                [self requestStausCheck];
            }else
                [self requestSend];
        }
    }
    else if (alertView.tag == 200){ //조직체크
        if (buttonIndex == 0){ //조직변경 sapList 직접변경
            isOrgChanged = YES;
        }
        else { //조직변경 안함
            isOrgChanged = NO;
        }
    }
    // "스캔하신 장치바코드(%@)와 상위바코드의 장치바코드가 상이합니다." 인 경우의 처리
    // 실장모드 이며 단품이 아니면서(U,S) 상위장치바코드와 장치바코드가 다를경우
    else if (alertView.tag == 300){
        if (buttonIndex == 0){ //Y
            if([self processCheckChildTree]){
                if([self processSendCheckOrganization]){
                    NSString* message = @"전송하시겠습니까?";
                    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
                }
                // else
                // processSendCheckOrganization가 NO를 리턴한 경우는 그 메소드 안에서 전송처리를 이미 했으므로 여기서는 전송여부 물을필요 없음.
            }
            // else
            // processCheckChildTree가 NO를 리턴한 경우는 그 메소드 안에서 전송처리를 이미 했으므로 여기서는 전송여부 물을필요 없음.
        }
    }
    else if (alertView.tag == 400){ //실장모드에서 조직변경 여부
        //processSendCheckOrganization pass한경우
        
        if (buttonIndex == 1){ //N
            [self performSelectorOnMainThread:@selector(upperBecameFirstResponder) withObject:nil waitUntilDone:NO];
            NSString* message = @"상위설비를 정확히\n스캔하시기 바랍니다.";
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }
        else { //조직변경 클릭시
            CHKZKOSTL_INSTCONF = @"Y";                // 실장 상위조직 상속하므로 조직변경 Y로 셋팅
            NSString* orgCode;
            NSString* orgName;
            NSString* checkOrgValue;
            
            //상위설비의 운용조직으로 변경
            for (NSMutableDictionary* dic in originalSAPList) {
                //조직체크 추가
                orgCode = [dic objectForKey:@"ZKOSTL"];
                orgName = [dic objectForKey:@"ZKTEXT"];
                
                checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",upper_OperOrgCode,upper_OperOrgName];
                [dic setObject:checkOrgValue forKey:@"ORG_CHECK"];
            }
            NSString* message = @"전송하시겠습니까?";
            [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
        }
    }
    else if (alertView.tag == 500){ //하위설비 포함 전송
        if (buttonIndex == 0){ //하위설비 포함
            if ([self processSendCheckOrganization]){
                NSString* message = @"전송하시겠습니까?";
                [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
            }
        }
    }
    else if (alertView.tag == 600){ //삭제
        if (buttonIndex == 0){ //삭제
            NSDictionary* dic = [fccSAPList objectAtIndex:nSelectedRow];
            NSString* barcode = [dic objectForKey:@"EQUNR"];
            
            [self deleteBarcode:barcode];
        }
    }
    else if (alertView.tag == 700){ //실장 조직체크 루핑돌면서 다 조직값 변경
        NSString* checkOrgValue = nil;
        NSString* orgCode = nil;
        NSString* orgName = nil;
        
        if (buttonIndex == 0) {//조직변경
            isOrgChanged = YES;
            
            for (NSMutableDictionary* dic in originalSAPList) {
                //조직체크 추가
                orgCode = [dic objectForKey:@"ZKOSTL"];
                orgName = [dic objectForKey:@"ZKTEXT"];
                
                checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
                [dic setObject:checkOrgValue forKey:@"ORG_CHECK"];
                CHKZKOSTL_INSTCONF = @"Y";
            }
        }
        else {//조직변경 안함
            isOrgChanged = NO;
            for (NSMutableDictionary* dic in originalSAPList) {
                //조직체크 추가
                orgCode = [dic objectForKey:@"ZKOSTL"];
                orgName = [dic objectForKey:@"ZKTEXT"];
                
                checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
                [dic setObject:checkOrgValue forKey:@"ORG_CHECK"];
                CHKZKOSTL_INSTCONF = @"N";
            }
            
        }
        NSString* message = @"전송하시겠습니까?";
        [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
        [self reloadTableWithRefresh:YES];// fccSAPList를 만들고, 화면도 반영
    }
    else if (alertView.tag == 800){ //스캔필수
        if (buttonIndex == 1) //진행안함
            btnScan.selected = YES;
        else{ //진행 (최초에 호출한 것만 다시 진행)
            // 스캔필수 해제 시 추가한 설비 삭제는 실장인 경우만 하도록 수정  - request by 류성호 2014.2.11
            //           if (![JOB_GUBUN isEqualToString:@"입고(팀내)"] && ![JOB_GUBUN isEqualToString:@"철거"]){
            if ([JOB_GUBUN isEqualToString:@"실장"]){
                // DR-2014-13014 실장메뉴 U-U 스캔후 스켄필수 해제 시 하위설비 삭제 기능 개선-request by 정진우 -> 2014.05.22 : 류성호
                // [self processScanYN];  // scanvalue = 2 인 것만 제거
                
            }
            
            btnDelete.enabled = NO;
            
            //작업관리에 추가
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"SCAN_YN" forKey:@"TASK"];
            [taskDic setObject:@"N" forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    else if (alertView.tag == 900){ //상위바코드 U일때
        if (buttonIndex == 1){ //아니오시 초기화
            txtUFacCode.text = @"";
            strUpperBarCode = @"";
            lblUpperPartType.text = @"";
        }
    }
    else if (alertView.tag == 1000){ //이동
        if (buttonIndex == 1){
            isMove = NO;
            moveView.hidden = YES;
        }
        else{
            NSDictionary* objDic = objc_getAssociatedObject(fccSAPList,&moveObjKey);
            NSDictionary* tarDic = objc_getAssociatedObject(fccSAPList, &moveTarKey);
            NSString* objPartType = [objDic objectForKey:@"PART_NAME"];
            NSString* tarPartType = [tarDic objectForKey:@"PART_NAME"];
            NSString* message = [WorkUtil nodeValidateSourceType:objPartType TargetType:tarPartType isCheckSu:btnUU.selected];
            // 메세지가 ""이 아니면 오류임.  오류 메시지를 띄워준다.
            if (![message isEqualToString:@""]){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            }else{
                [self moveSource:[objDic objectForKey:@"EQUNR"] toTarget:[tarDic objectForKey:@"EQUNR"]];
            }
            isMove = NO;
            moveView.hidden = YES;
        }
        [txtFacCode becomeFirstResponder];
    }
    else if (alertView.tag == 1100){
        if (buttonIndex == 0){
            [txtFacCode resignFirstResponder];
            [txtLocCode resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }else if(alertView.tag == 1800){
        if (buttonIndex == 0){
            [Util udSetObject:@"N" forKey:USER_WORK_MODE];
            [Util udSetObject:@"설비상태변경" forKey:USER_WORK_NAME];
            
            lblPicker.text = @"설비상태";
            failureContentView.hidden = YES;
            NSString * fc = txtFacCode.text;
            isChangeViewMode = YES;
            
            [self touchInitBtn];
            [self viewDidLoad];
            
            
            txtFacCode.text = fc;
            
            [picker selectPicker:3];
            
            btnScan.userInteractionEnabled = YES;
            btnScan.selected = YES;
            [btnScan setImage:[UIImage imageNamed:@"common_checkbox_checked"] forState:UIControlStateSelected];
            lblScan.textColor = [UIColor blackColor];
            
            [self processShouldReturn:fc tag:200];
            
        }
    }else if (alertView.tag == 1200){
        if (buttonIndex == 0){
            [Util udSetObject:@"N" forKey:USER_WORK_MODE];
            [Util udSetObject:@"철거" forKey:USER_WORK_NAME];
            
            [self touchInitBtn];
            [self viewDidLoad];
        }else{
            [self requestSend];
        }
    }
    
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
}

// 여기부터는 서버로부터 데이타를 요청하는 메소드들이다.
#pragma mark - Http Request Method
- (void)requestAuthLocation:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_OTD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestAuthLocation:locBarcode];
}

// 내부사용자 논리창고 자동 셋팅
- (void)requestLogicalLocCode:(BOOL)isRequireOrg locBarcode:(NSString*)locBarcode
{
    /* 논리창고 자동 셋팅 로직 제거 - 2014.09.17
     if (![strUserOrgType isEqualToString:@"REP_USER"] && ![strUserOrgType isEqualToString:@"INS_USER"]) return;
     
     ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
     
     requestMgr.delegate = self;
     requestMgr.reqKind = REQUEST_LOGICAL_LOC;
     
     [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
     
     [requestMgr requestLogicalLocCode:locBarcode isNeedUserInfo:isRequireOrg];
     */
}

- (void)requestRepairHistoryList
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_REPAIR_HISTORY;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    if([txtFacCode.text length] > 0){
        [paramDic setObject:txtFacCode.text forKey:@"EQUNR"];
    }
    if([txtDeviceID.text length] > 0){
        [paramDic setObject:txtDeviceID.text forKey:@"ZEQUIPGC"];
    }
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_GET_REPAIR_HISTORY withData:rootDic];
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

- (void)requestFccDetail:(NSString*)fccBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_DETAIL_SAP_FCC;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:fccBarcode forKey:@"EQUNR"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_FAC_INQUERY_DETAIL withData:rootDic];
}

- (void)requestFccBreakDown:(NSString*)fccBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_BREAK_COD;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:fccBarcode forKey:@"I_EQUNR"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_FAC_BREAKDOWN withData:rootDic];
}

- (void)requestUpperFacCode:(NSString*)upperBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_UPPER_SAP_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSAPInfo:upperBarcode locCode:locCode deviceID:deviceID  orgCode:@"" isAsynch:YES];
}

- (void) requestMoveData:(NSString*)barcode orgCode:(NSString*)orgCode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MOVE_SEARCH;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSDictionary* userDic = [Util udObjectForKey:USER_INFO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
        [paramDic setObject:@"R" forKey:@"STEP"];
        [paramDic setObject:[userDic objectForKey:@"orgId"] forKey:@"SKOSTL"];
    }
    else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        [paramDic setObject:@"S" forKey:@"STEP"];
        [paramDic setObject:[userDic objectForKey:@"orgId"] forKey:@"RKOSTL"];
        if (receivedOrgDic.count)
            [paramDic setObject:[receivedOrgDic objectForKey:@"costCenter"] forKey:@"SZKOSTL"];
        else
            [paramDic setObject:@"" forKey:@"SZKOSTL"];
        
        if (barcode.length)
            [paramDic setObject:barcode forKey:@"EQUNR"];     //접수(팀간)- 자기조직에 해당 하는 접수 바코드 추가
        
        [paramDic setObject:@"I" forKey:@"SRCSYS"];
    }
    else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        [paramDic setObject:@"S" forKey:@"STEP"];
        [paramDic setObject:[userDic objectForKey:@"orgId"] forKey:@"SKOSTL"];
        if (barcode.length)
            [paramDic setObject:barcode forKey:@"EQUNR"];     //송부취소(팀간)- 자기조직 아닌 바코드 추가
        
        [paramDic setObject:@"I" forKey:@"SRCSYS"];
    }
    [paramDic setObject:@"X" forKey:@"INCL"];
    [paramDic setObject:@"" forKey:@"INCLCL"]; //이동중만 보이게 (X:전송시 다보임)
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_MOVE_SEARCH withData:rootDic];
}



- (void)requestStausCheck
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_STATUS_CHECK;
    
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:@"0021" forKey:@"I_ZPSTATU"];
    
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in originalSAPList)
    {
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        NSLog(@"subParamdic [%@]",dic);
        [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"];
        [subParamList addObject:subParamDic];
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_BUYOUT_CHECK withData:rootDic];
}

- (void) requestSearchOrg:(NSString*)rootOrgCode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEARCH_ORG;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSearchRootOrgCode:rootOrgCode];
}

#pragma gwlenRequest delegate -- call by GwlenListController
- (void)gwlenRequest:(BOOL)send{
    isGwlenListSend = YES;
    [self requestSend];
}

- (void) requestSend
{
    // 전송할 데이타가 없는 경우 오류처리
    if (![originalSAPList count]){ //장치 리스트가 없는 경우도 있네
        NSLog(@"originalSAPList no data");
        return;
    }
    
    // 송부(팀간)은 송부조직을 선택하지 않으면 오류처리한다.
    if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
        if (!receivedOrgDic.count){
            NSLog(@"receivedOrgDic no data!");
            return;
        }
    }
    
    //입고(팀내), 설비상태 변경 - 불용처리 - 보증기간내 설비 있을경우 설비 리스트 팝업으로 보여준다.
    if(!isGwlenListSend){
        if(([JOB_GUBUN isEqualToString:@"입고(팀내)"] && picker.selectedIndex == 2) || ([JOB_GUBUN isEqualToString:@"설비상태변경"] && picker.selectedIndex == 3)){
            NSMutableArray* gwlenList = [NSMutableArray array];
            if (originalSAPList.count){
                for(NSDictionary* dic in originalSAPList){
                    if([[NSDate TodayString] intValue] <= [[[dic objectForKey:@"GWLEN_O"] stringByReplacingOccurrencesOfString:@"-" withString:@""] intValue]){
                        [gwlenList addObject:dic];
                    }
                }
            }
            
            if(gwlenList.count){
                GwlenListController *modalView = [[GwlenListController alloc] initWithNibName:@"GwlenListController" bundle:nil];
                modalView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                modalView.delegate = self;
                modalView.list = gwlenList;
                [self presentViewController:modalView animated:NO completion:nil];
                modalView.view.alpha = 1;
                return;
            }
        }
    }
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    // ROOT설비 바코드(최초스캔한)의 종류명
    NSString* upperpartName = [WorkUtil getParentPartName:originalSAPList];
    
    //사용자 정보
    NSDictionary* orgDic = [Util udObjectForKey:USER_INFO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    /* 2014. 2. 11 박수임 수정 request by 류성호
     * PRCID 셋팅 - DR-2013-56563 - request by 김희선 2014. 01. 08
     * request by 양석훈
     * @ 프로세스유형을 아래와 같이 변경 부탁 드립니다.
     1. 설비상태변경(모든 작업에 대하여)
     0005, 0125 Multi 미운용
     0009, 0155 Multi 예비
     0008, 0185 Multi 유휴
     0013, 0230 Multi 불용대기
     2. 탈장
     0006, 0035 Multi 탈장
     3. 출고(팀내)
     0018, 0680 Multi 출고
     4. 송부(팀간), 고장등록
     두 작업은 프로세스 유형 변경 없이 멀티로 전송
     */
    if ([JOB_GUBUN isEqualToString:@"입고(팀내)"]){
        [paramDic setObject:@"0019" forKey:@"WORKID"];
        [paramDic setObject:@"0760" forKey:@"PRCID"];
    }
    else  if ([JOB_GUBUN isEqualToString:@"출고(팀내)"]){
        [paramDic setObject:@"0018" forKey:@"WORKID"];
        [paramDic setObject:@"0680" forKey:@"PRCID"];
    }
    else  if ([JOB_GUBUN isEqualToString:@"탈장"]){
        [paramDic setObject:@"0006" forKey:@"WORKID"];
        [paramDic setObject:@"0035" forKey:@"PRCID"];
    }
    else  if ([JOB_GUBUN isEqualToString:@"실장"])
        [paramDic setObject:@"0007" forKey:@"WORKID"];
    else  if ([JOB_GUBUN isEqualToString:@"송부(팀간)"] || [JOB_GUBUN isEqualToString:@"송부취소(팀간)"])
        [paramDic setObject:@"0016" forKey:@"WORKID"];
    else if ([JOB_GUBUN isEqualToString:@"납품취소"]){
        [paramDic setObject:@"1008" forKey:@"WORKID"];
        [paramDic setObject:@"1011" forKey:@"PRCID"];
    }
    else if ([JOB_GUBUN isEqualToString:@"배송출고"]){
        [paramDic setObject:@"1007" forKey:@"WORKID"];
        [paramDic setObject:@"1170" forKey:@"PRCID"];
        
        // 배송 오더
        if (btnDeliveryOreder.selected)
            [paramDic setObject:@"Y" forKey:@"ZDOCRT"];
        else
            [paramDic setObject:@"" forKey:@"ZDOCRT"];
    }
    else if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        [paramDic setObject:@"0020" forKey:@"WORKID"];
    }
    else if([JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
        [paramDic setObject:@"0020" forKey:@"WORKID"];
        [paramDic setObject:@"0950" forKey:@"PRCID"];
    }
    
    // GPS정보 셋팅
    if(
       ![JOB_GUBUN isEqualToString:@"납품입고"] &&
       ![JOB_GUBUN isEqualToString:@"송부(팀간)"] &&
       ![JOB_GUBUN isEqualToString:@"송부취소(팀간)"] &&
       ![JOB_GUBUN isEqualToString:@"철거"]
       ){
        if(strLocBarCode.length){
            [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
            
            // GPS 위치조회 하지 않는 방법으로 변경. 16.11.22
            //            // QA서버 접속시에만 GPS데이타를 넘긴다.  운영서버 접속시에는 공백으로 보낸다.
            //            if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
            //                [ERPLocationManager getInstance].locationDic != nil){
            //                NSDictionary* deltaDic = [ERPLocationManager getInstance].locationDic;
            //                NSString* longitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LONGTITUDE"] floatValue]];
            //                NSString* latitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LATITUDE"] floatValue]];
            //
            //                [paramDic setObject:longitude forKey:@"LONGTITUDE"];
            //                [paramDic setObject:latitude forKey:@"LATITUDE"];
            //
            //                NSString* locFucllName = [[locResultList objectAtIndex:0] objectForKey:@"locationFullName"];
            //                // 주소부분만 잘라
            //                locFucllName = [WorkUtil getFullNameOfLoc:locFucllName];
            //
            //                // 현재 위치와 위치바코드에 해당하는 주소와의 거리
            //                double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:locFucllName];
            //                [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
            //            }else{
            //                [paramDic setObject:@"" forKey:@"LONGTITUDE"];
            //                [paramDic setObject:@"" forKey:@"LATITUDE"];
            //                [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
            //            }
        }
    }
    
    if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"])
    {
        [paramDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
    }
    
    //to-do 실장일때만 처리
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        [self checkOrgInheritance];     // 전송 직전에 상속 여부 체크
        
        if (isOrgInheritance)
            [paramDic setObject:@"X" forKey:@"ZDOCRT"]; //상위 바코드 조직 상속
        else
            [paramDic setObject:@"" forKey:@"ZDOCRT"]; //상위 바코드 조직 상속받지 않음
    }
    
    if (![JOB_GUBUN isEqualToString:@"송부취소(팀간)"] &&
        ![JOB_GUBUN isEqualToString:@"접수(팀간)"] &&
        ![JOB_GUBUN isEqualToString:@"납품입고"] &&
        ![JOB_GUBUN isEqualToString:@"납품취소"]){
        if(btnScan.selected)
            [paramDic setObject:@"X" forKey:@"CHKSCAN"];
        else
            [paramDic setObject:@"" forKey:@"CHKSCAN"];
    }
    
    // 납품입고, 납품취소, 배송출고는 deviceID, upperFacId 입력하는 필드가 없으므로 아래 코드는 실행 하지 않는다.
    if (strDeviceID.length ){
        [paramDic setObject:strDeviceID forKey:@"DEVICEID"];
    }
    
    // 실장의 경우 상위바코드도 함께 보낸다.
    if (!upperFacView.hidden){
        if ([upperpartName isEqualToString:@"E"] || strUpperBarCode == nil)
            [paramDic setObject:@"" forKey:@"UBARCODE"];
        else{
            [paramDic setObject:strUpperBarCode forKey:@"UBARCODE"];
        }
    }
    
    if ([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        if ([strLocBarCode hasPrefix:@"VS"])
            [paramDic setObject:@"X" forKey:@"CHKSTORT"];
        else
            [paramDic setObject:@"" forKey:@"CHKSTORT"];
    }
    
    if ([JOB_GUBUN isEqualToString:@"실장"])
    {
        if ([upperpartName isEqualToString:@"R"])
            [paramDic setObject:@"0250" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"S"])
            [paramDic setObject:@"0260" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"U"])
            [paramDic setObject:@"0270" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"E"])
            [paramDic setObject:@"0271" forKey:@"PRCID"];
        
    }
    else if ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"])
    {
        if ([upperpartName isEqualToString:@"R"])
            [paramDic setObject:@"0910" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"S"])
            [paramDic setObject:@"0920" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"U"])
            [paramDic setObject:@"0930" forKey:@"PRCID"];
        else if ([upperpartName isEqualToString:@"E"])
            [paramDic setObject:@"0940" forKey:@"PRCID"];
        
    }
    
    else if([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
        
        //운용조직
        NSDictionary* dic = [Util udObjectForKey:USER_INFO];
        
        [paramDic setObject:@"0310" forKey:@"PRCID"];
        [paramDic setObject:@"P" forKey:@"SRCSYS"];
        [paramDic setObject:[dic objectForKey:@"orgId"] forKey:@"SKOSTL"]; //사용자 조직
        [paramDic setObject:[receivedOrgDic objectForKey:@"costCenter"] forKey:@"RKOSTL"]; //접수조직
        [paramDic setObject:@"9200" forKey:@"WERKS"];
        [paramDic setObject:@"" forKey:@"CENTER"];
        [paramDic setObject:[dic objectForKey:@"orgId"] forKey:@"SZKOSTL"]; //사용자조직
    }
    
    else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        [paramDic setObject:@"0016" forKey:@"WORKID"];
        
        //받은조직값
        //val.Add(tmp_row["SKOSTL"].ToString());
        
        [paramDic setObject:@"0320" forKey:@"PRCID"];
        [paramDic setObject:@"P" forKey:@"SRCSYS"];
        [paramDic setObject:[orgDic objectForKey:@"orgId"] forKey:@"RKOSTL"];
        [paramDic setObject:@"9200" forKey:@"WERKS"];
        [paramDic setObject:[orgDic objectForKey:@"orgId"] forKey:@"KOSTL"];
    }
    
    else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        [paramDic setObject:@"0315" forKey:@"PRCID"];
        [paramDic setObject:@"P" forKey:@"SRCSYS"];
        //송부조직(선택시) 어떤값?
        //조직 받은값
        // val.Add(tmp_row["RKOSTL"].ToString());
        
        [paramDic setObject:[orgDic objectForKey:@"orgId"] forKey:@"KOSTL"];
        [paramDic setObject:@"9200" forKey:@"WERKS"];
    }
    else if ([JOB_GUBUN isEqualToString:@"고장등록"])
    {
        [paramDic setObject:@"0410" forKey:@"PRCID"];
    }
    
    if ([JOB_GUBUN isEqualToString:@"설비상태변경"]){
        
        switch (picker.selectedIndex) {
            case 0:     // 유휴
                [paramDic setObject:@"0008" forKey:@"WORKID"];
                [paramDic setObject:@"0185" forKey:@"PRCID"];
                break;
            case 1:     // 예비
                [paramDic setObject:@"0009" forKey:@"WORKID"];
                [paramDic setObject:@"0155" forKey:@"PRCID"];
                break;
            case 2:     // 미운용
                [paramDic setObject:@"0005" forKey:@"WORKID"];
                [paramDic setObject:@"0125" forKey:@"PRCID"];
                break;
            case 3:     // 불용대기
                [paramDic setObject:@"0013" forKey:@"WORKID"];
                [paramDic setObject:@"0230" forKey:@"PRCID"];
                break;
        }
    }
    else if ([JOB_GUBUN isEqualToString:@"철거"]){
        [paramDic setObject:@"0012" forKey:@"WORKID"];
        if ([strUserOrgTypeCode isEqualToString:@"INS_USER"]){
            //직영철거
            [paramDic setObject:@"ZPMN_CONFIRM_REMOVAL_IN_PROC" forKey:@"FUNCNAME"];
            // "0770' :  직영철거, '0775' :  직영철거송부"
            if (receivedOrgDic.count)
                [paramDic setObject:@"0775" forKey:@"PRCID"];
            else
                [paramDic setObject:@"0770" forKey:@"PRCID"];
        }
        else{
            [paramDic setObject:@"ZPMN_CONFIRM_REMOVAL_PROC" forKey:@"FUNCNAME"];
            // '0710' - 위탁철거, '0715' - 위탁철거송부 (PDA)
            if (receivedOrgDic.count)
                [paramDic setObject:@"0715" forKey:@"PRCID"];
            else
                [paramDic setObject:@"0710" forKey:@"PRCID"];
        }
        if (receivedOrgDic.count){
            [paramDic setObject:strUserOrgCode forKey:@"KOSTL"];
            [paramDic setObject:strUserOrgCode forKey:@"SKOSTL"];
            [paramDic setObject:strUserOrgCode forKey:@"SZKOSTL"];
            [paramDic setObject:[receivedOrgDic objectForKey:@"costCenter"] forKey:@"RKOSTL"];
        }
        if (![strUserOrgTypeCode isEqualToString:@"INS_USER"])
            [paramDic setObject:lblWBSNo.text forKey:@"POSID"];
    }
    
    //subParam 조립
    sendCount = 0;
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in originalSAPList)
    {
        //        NSLog(@"subParamdic [%@]",dic);
        
        NSMutableDictionary *subParamDic = [[NSMutableDictionary alloc] init];
        //to-do scanvalue 3 -> 1
        NSString* scanValue = @"";
        if (btnScan.selected) scanValue = [dic objectForKey:@"SCANTYPE"];
        if (![JOB_GUBUN isEqualToString:@"송부취소(팀간)"] &&
            ![JOB_GUBUN isEqualToString:@"접수(팀간)"] &&
            ![JOB_GUBUN isEqualToString:@"납품입고"] &&
            ![JOB_GUBUN isEqualToString:@"납품취소"]
            ){
            if ([scanValue isEqualToString:@"3"])
                [subParamDic setObject:@"1" forKey:@"SCAN"];
            else
                [subParamDic setObject:scanValue forKey:@"SCAN"]; // 0:스캔하지않음 1:스캔 2:추가
        }
        else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            if ([scanValue isEqualToString:@"3"])
                [subParamDic setObject:@"1" forKey:@"SCAN"];
            else
                [subParamDic setObject:scanValue forKey:@"SCAN"]; // 0:스캔하지않음 1:스캔 2:추가
        }
        
        //접수(팀간) | 송부취소(팀간)은 상위를 스캔하지 않고, 자신을 스캔하지 않았으면 전송하지 않음.
        if (
            [JOB_GUBUN isEqualToString:@"접수(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"]
            ){
            
            NSString* scanType = [dic objectForKey:@"SCANTYPE"];
            
            NSString* upperBarcode = [dic objectForKey:@"HEQUNR"];
            
            if (!upperBarcode.length && [scanType isEqualToString:@"0"]) {//자신이 상위바코드이면서 스캔하지 않은경우
                continue;
            }
            else { //하위바코드
                NSString* parentscanType = [WorkUtil getScanTypeOfBarcode:upperBarcode fccList:originalSAPList];
                NSLog(@"barcode[%@] scanType[%@] parentscanType [%@]",[dic objectForKey:@"EQUNR"],scanType,parentscanType);
                if (
                    [parentscanType isEqualToString:@"0"] &&
                    [scanType isEqualToString:@"0"]
                    
                    )
                    continue;
            }
        }
        
        if ([JOB_GUBUN isEqualToString:@"고장등록"])
        {
            if (selectedPickerData.length){ //"선택하세요" 선택한경우는 들어 오지 않는다.
                NSArray* tokenList = [selectedPickerData componentsSeparatedByString:@":"];
                NSString* failureCode = [tokenList objectAtIndex:0];
                [subParamDic setObject:failureCode forKey:@"FECOD"]; // 고장코드
            }
            [subParamDic setObject:txtViewFailure.text forKey:@"FETXT"]; // 고장내역
        }
        
        if (
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"접수(팀간)"]
            )
        {
            [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"];
            if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"E"])
                [subParamDic setObject:@"99" forKey:@"PARTTYPE"];
            else
                [subParamDic setObject:[dic objectForKey:@"PARTTYPE"] forKey:@"PARTTYPE"];
            
            [subParamDic setObject:[dic objectForKey:@"DEVTYPE"] forKey:@"DEVTYPE"];
        }
        else if ([JOB_GUBUN isEqualToString:@"납품입고"]){
            [subParamDic setObject:@"1"                 forKey:@"DFLAG"];
            [subParamDic setObject:strLocBarCode        forKey:@"LOCCODE"];
            [subParamDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            NSString* partTypeName = [dic objectForKey:@"PART_NAME"];
            
            [subParamDic setObject:[WorkUtil getPartTypeCode:partTypeName] forKey:@"PARTTYPE"];
            
            
            if ([partTypeName isEqualToString:@"E"])
                [subParamDic setObject:@"30" forKey:@"DEVTYPE"];
            else
                [subParamDic setObject:@"40" forKey:@"DEVTYPE"];
            
            [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EXBARCODE"]; //바코드
            
            //최상위 노드이면 상위바코드 ""
            [subParamDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUI"]; //상위바코드
            
        }
        else if ([JOB_GUBUN isEqualToString:@"납품취소"]){
            [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"];
        }
        else
        {
            [subParamDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"BARCODE"];
            /// 단품일 경우에는 부품종류가 null 로 정의되어 있기 때문에 SAP에서 처리 시 오류 발생 가능성이 있습니다. 이에 유동처리(탈장, 실장, 입고, 출고, 송부, 접수) 시 단품일 경우에는 부품종류(PARTTYPE) 를 '99' 로 지정하여 SAP 로 I/F 해 주시기 바랍니다.
            if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"E"])
                [subParamDic setObject:@"99" forKey:@"PARTTYPE"];
            else
                [subParamDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"PARTTYPE"];
            
            if (![JOB_GUBUN isEqualToString:@"철거"]){
                [subParamDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"DEVTYPE"];
                [subParamDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"DEVICEID"];
            }
        }
        
        if (
            [JOB_GUBUN isEqualToString:@"접수(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"]
            )
        {
            NSString* itemNo = [NSString stringWithFormat:@"%d",(int)sendCount + 1];
            [subParamDic setObject:[dic objectForKey:@"TRANSNO"] forKey:@"DOCNO"];
            [subParamDic setObject:[dic objectForKey:@"ITEMNO"] forKey:@"ITEM"];
            [subParamDic setObject:itemNo forKey:@"ITEMNO"];
        }
        
        if (
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"접수(팀간)"]
            ){
            [subParamDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"EXBARCODE"]; //상위바코드
        }
        else if(![JOB_GUBUN isEqualToString:@"납품입고"] &&
                ![JOB_GUBUN isEqualToString:@"납품취소"])
            [subParamDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"EXBARCODE"]; //상위바코드
        
        
        if (
            ![JOB_GUBUN isEqualToString:@"납품입고"] &&
            ![JOB_GUBUN isEqualToString:@"납품취소"]
            )
        {
            NSString* checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
            if ([JOB_GUBUN isEqualToString:@"실장"]){
                NSString* scanType = [dic objectForKey:@"SCANTYPE"];
                NSString* CHKZKOSTL;
                
                if([[dic objectForKey:@"PART_NAME"]isEqualToString:@"E"]){
                    if([[dic objectForKey:@"ORG_CHECK"]hasPrefix:@"N"]){
                        CHKZKOSTL_INSTCONF = @"X";
                    }
                }
                
                if (CHKZKOSTL_INSTCONF.length)
                    CHKZKOSTL = CHKZKOSTL_INSTCONF;
                
                if (btnScan.selected && [scanType isEqualToString:@"0"])
                    CHKZKOSTL = @"X";
                
                if ([CHKZKOSTL isEqualToString:@"N"] || [CHKZKOSTL isEqualToString:@"X"]){
                    CHKZKOSTL = @"X";
                    [subParamDic setObject:CHKZKOSTL forKey:@"CHKZKOSTL"]; // 조직변경 안함
                }
                else
                    [subParamDic setObject:@"" forKey:@"CHKZKOSTL"]; // 조직변경
            }
            else if ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                NSString* scanType = [dic objectForKey:@"SCANTYPE"];
                NSString* orgChange = [dic objectForKey:@"ORGCH"];
                NSString* CHKZKOSTL;
                
                if (CHKZKOSTL_INSTCONF.length)
                    CHKZKOSTL = CHKZKOSTL_INSTCONF;
                
                if(![orgChange isEqualToString:@""]){
                    if([orgChange isEqualToString:@"YES"]){
                        CHKZKOSTL = @"";
                    }else{
                        CHKZKOSTL = @"N";
                    }
                }
                
                if (btnScan.selected && [scanType isEqualToString:@"0"])
                    CHKZKOSTL = @"X";
                
                if ([CHKZKOSTL isEqualToString:@"N"] || [CHKZKOSTL isEqualToString:@"X"]){
                    CHKZKOSTL = @"X";
                    [subParamDic setObject:CHKZKOSTL forKey:@"CHKZKOSTL"]; // 조직변경 안함
                }
                else
                    [subParamDic setObject:@"" forKey:@"CHKZKOSTL"]; // 조직변경
                
                
                
                NSLog(@"CHKZKOSTL_INSTCONF == %@", CHKZKOSTL);
            }
            else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            }
            else
            {
                if ([checkOrgValue hasPrefix:@"N"]) { //조직변경 안함
                    [subParamDic setObject:@"X" forKey:@"CHKZKOSTL"];
                }
                else //조직변경
                    [subParamDic setObject:@"" forKey:@"CHKZKOSTL"];
            }
        }
        if ([JOB_GUBUN isEqualToString:@"출고(팀내)"]){
            [subParamDic setObject:@"0270" forKey:@"ZPSTATU"]; //출고로 설정
        }
        else if ([JOB_GUBUN isEqualToString:@"탈장"]){
            [subParamDic setObject:@"0080" forKey:@"ZPSTATU"];
        }
        else if ([JOB_GUBUN isEqualToString:@"실장"]){
            [subParamDic setObject:@"0060" forKey:@"ZPSTATU"];
            [subParamDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"KOSTL"];
        }
        else if ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
            [subParamDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [subParamDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"KOSTL"];
        }
        else if ([JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
            [subParamDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
        }
        else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
            [subParamDic setObject:@"0140" forKey:@"ZPSTATU"];
        }
        else if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
            if (receivedOrgDic.count)
                [subParamDic setObject:@"0140" forKey:@"ZPSTATU"];
        }
        else if ([JOB_GUBUN isEqualToString:@"철거"]){
            if (![strUserOrgTypeCode isEqualToString:@"INS_USER"] && strLocBarCode.length > 0){
                [subParamDic setObject:strLocBarCode forKey:@"ZEQUIPLP"];
            }
            
            if (receivedOrgDic.count)
                [subParamDic setObject:@"0140" forKey:@"ZPSTATU"];
        }
        else if ([JOB_GUBUN isEqualToString:@"배송출고"]){
            if (btnDeliveryOreder.selected &&
                [scanValue isEqualToString:@"0"]
                )
                [subParamDic setObject:@"0081" forKey:@"ZPSTATU"]; // 스캔하지 않으면 분실위험으로
            else
                [subParamDic setObject:@"0270" forKey:@"ZPSTATU"]; // 상태변경용 설비상태    "0270" 출고중
        }
        else if ([JOB_GUBUN isEqualToString:@"납품취소"])
            [subParamDic setObject:@"0021" forKey:@"ZPSTATU"]; //출고로 설정
        else {
            if (![JOB_GUBUN isEqualToString:@"고장등록"] &&
                ![JOB_GUBUN isEqualToString:@"납품입고"]) {
                NSString* facilityCode = [WorkUtil getFacilityStatusCode:selectedPickerData];
                [subParamDic setObject:facilityCode forKey:@"ZPSTATU"];
            }
            
        }
        
        [subParamList addObject:subParamDic];
        sendCount++;
    }
    
    if (([JOB_GUBUN isEqualToString:@"접수(팀간)"] || [JOB_GUBUN isEqualToString:@"송부취소(팀간)"]) &&
        !sendCount){
        NSString* message = @"전송할 설비바코드가 존재하지 않습니다.\n스캔확인 하지 않은 설비바코드는\n전송되지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    
    NSLog(@"postdata param[%@]\n subParamList[%@]",paramDic,subParamList);
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    
    if ([JOB_GUBUN isEqualToString:@"입고(팀내)"]){
        [requestMgr asychronousConnectToServer:API_SEND_OUTINTO withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"출고(팀내)"]){
        [requestMgr asychronousConnectToServer:API_SEND_DELIVERY withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"실장"]){
        [requestMgr asychronousConnectToServer:API_SEND_MOUNT withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"탈장"]){
        [requestMgr asychronousConnectToServer:API_SEND_UNMOUNT withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        [requestMgr asychronousConnectToServer:API_SEND_FORM_MAKE withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
        [requestMgr asychronousConnectToServer:API_SEND_FORM_CLEAR withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
        [requestMgr asychronousConnectToServer:API_SEND_DEVICE_NEW withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
        [requestMgr asychronousConnectToServer:API_SEND_DEVICE_CANCEL withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        [requestMgr asychronousConnectToServer:API_SEND_RECEIPT_NEW withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"설비상태변경"]){
        [requestMgr asychronousConnectToServer:API_FAC_CHANGE_STATUS withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"철거"]){
        [requestMgr asychronousConnectToServer:API_SUBMIT_REMOVAL_SCAN withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"고장등록"]){
        [requestMgr asychronousConnectToServer:API_SEND_FAILURE_REG withData:rootDic];
    }
    else if ([JOB_GUBUN isEqualToString:@"납품입고"])
        [requestMgr asychronousConnectToServer:API_SEND_BUYOUT_INTO withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"납품취소"])
        [requestMgr asychronousConnectToServer:API_SEND_BUYOUT_CANCEL withData:rootDic];
    else if([JOB_GUBUN isEqualToString:@"배송출고"])
        [requestMgr asychronousConnectToServer:API_SEND_DELIVERY_MM withData:rootDic];
}



// 고장등록 시 사진 전송
- (void) sendImageToServer
{
    // 여러장의 사진을 한장씩 보낸다.
    // 앞에 보낸 사진 전송 후 response 받고(isUploadOneImageFinished로 체크), 다음 사진 전송
    for (NSDictionary* dic in originalSAPList){
        if ([dic objectForKey:@"PICTURE"] == nil)
            continue;
        
        isUploadOneImageFinished = NO;
        [self requestImageUpload:dic];
        
        while (!isUploadOneImageFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        }
    }
    
    [self touchInitBtn];
}

- (void) requestImageUpload:(NSDictionary*)dic
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_FAULT_IMAGE_UPLOAD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSString* barcode = @"WD3K90447220000001";//[NSString stringWithFormat:@"%@",[dic objectForKey:@"EQUNR"]];
    NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation([dic objectForKey:@"PICTURE"], 0)];
    NSString* filename = [NSString stringWithFormat:@"%@.jpg", barcode];
    
    [requestMgr setTextDataKey:@"barcode" Value:@"WD3K90447220000001"];
    [requestMgr setTextDataKey:@"prcid" Value:@"0410"];
    [requestMgr setImageDataKey:@"file" data:imageData filename:filename contentType:@"image/png"];
    [requestMgr sychronousSendTextNImageConnectToServer:FAILURE_PICTURE_UPLOAD];
}

// 서버로부터 온 Response처리하는 메소드들....
#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    //    if (resultList != nil)
    //        NSLog(@"Result List [%@]", resultList);
    
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
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == REQUEST_OTD){
        [self processOTDResponse];
    }else if (pid == REQUEST_LOGICAL_LOC){
        [self processLogicalLocResponse:resultList];
    }else if (pid == REQUEST_WBS){
        [self processWBSList:resultList];
    }else if (pid == REQUEST_MULTI_INFO){
        if (resultList)
            [self processDeviceBarcode:[resultList objectAtIndex:0]];
        else
            [self processDeviceBarcode:nil];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPInfoResponse:resultList];
    }else if(pid == REQUEST_SAP_FCC_BREAK_COD){
        [self processBreakDownInfo:resultList];
    }else if (pid == REQUEST_ITEM_FCC_COD){
        [self processFccItemInfoResponse:resultList];
    }else if (pid == REQUEST_UPPER_SAP_FCC_COD){
        [self processUpperSAPFccResponse:resultList];
    }else if (pid == REQUEST_MOVE_SEARCH){
        [self processMoveSearchResponse:resultList];
    }else if (pid == REQUEST_SEARCH_ORG){
        [self processSearchOrgResponse:resultList];
    }else if (pid == REQUEST_SEND){
        [self processSendResponse:resultList statusCode:status];
    }else if (pid == REQUEST_STATUS_CHECK){     // 납품취소 전송
        [self processStatusCheckResponse:resultList];
    }else if (pid == REQUEST_FAULT_IMAGE_UPLOAD){
        isUploadOneImageFinished = YES;
    }else if(pid == REQUEST_DETAIL_SAP_FCC){
        [self processSAPFccDetailResponse:resultList];
    }else if(pid == REQUEST_REPAIR_HISTORY){
        [self repairListResponse:resultList];
    }else isOperationFinished = YES;
}

- (void)processLogicalLocResponse:(NSArray*)resultList
{
    if ([resultList count]){
        BOOL isCheckOTD = NO;
        NSString* locCode = @"";
        NSString* locName = @"";
        
        for (NSDictionary* dic in resultList)
        {
            NSString* storageType = [dic objectForKey:@"storageType"];
            locCode = [dic objectForKey:@"storageLocationCode"];
            locName = [dic objectForKey:@"storageLocationName"];
            
            if (![strUserOrgType isEqualToString:@"INS_USER"]) {
                if ([storageType isEqualToString:@"06"])
                    isCheckOTD = YES;
            }
            else {
                if ([storageType isEqualToString:@"04"]){
                    isCheckOTD = YES;
                    break;
                }
            }
        }
        
        if (true) return;   // DR-2014-31084 : 납품입고시 위치바코드 스캔 원칙으로 변경 - request by 박장수 2014.07.01 -> changed by 류성호 2014.07.03
        
        if (
            isCheckOTD &&
            ![JOB_GUBUN isEqualToString:@"배송출고"]
            ){          // 배송출고는 수신위치 스캔 시 사용자 validatin 하지 않음
            if (locName.length){        // 위치 바코드로부터 얻어온 위치정보(주소같은...)를 뿌려준다.
                [Util setScrollTouch:scrollLocName Label:lblLocName withString:locName];
            }
            if (locCode.length){
                strLocBarCode = locCode;
                txtLocCode.text = strLocBarCode;
                
                [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
                [self requestAuthLocation:locCode];
            }
        }
    }
}

- (void)processLocList:(NSArray*)locList
{
    if (locList.count){
        NSDictionary* dic = [locList objectAtIndex:0];
        
        NSLog(@"=processLocList=%@", dic);
        
        // 위치정보 표시
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:[dic objectForKey:@"locationShortName"]];
        
        NSString* roomTypeCode = [dic objectForKey:@"roomTypeCode"];
        NSString* operationSystemCode = [dic objectForKey:@"operationSystemCode"];
        NSString* deviceID = [dic objectForKey:@"deviceId"];
        NSString* completeLocationCode = [dic objectForKey:@"completeLocationCode"];
        locType = roomTypeCode;
        
        if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
            if ([strLocBarCode hasPrefix:@"VS"]){
                if (![roomTypeCode isEqualToString:@"04"] && ![roomTypeCode isEqualToString:@"05"] && ![roomTypeCode isEqualToString:@"06"]){
                    NSString* message = @"'KT창고' 또는 '재활용창고'\n위치바코드를 스캔하세요.";
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                    strLocBarCode = @"";
                    locResultList = nil;
                    return;
                }
            }
        }
        
        if (txtLocCode.text.length == 9) {      //장치바코드
            strLocBarCode = completeLocationCode;
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
        
        if ([JOB_GUBUN isEqualToString:@"배송출고"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){ //배송출고만 otd 생략하기 때문에 - 형상구성(창고내) 예외 추가
            [workDic setObject:strLocBarCode forKey:@"LOC_CD"];
            //working task add
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"L" forKey:@"TASK"];
            [taskDic setObject:strLocBarCode forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
        // OTD 물류센터 위치바코드 Validation
        if (![JOB_GUBUN isEqualToString:@"배송출고"] && ![JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
            [self requestAuthLocation:strLocBarCode];
        }else{
            isOperationFinished = YES;
        }
    }
    else { //
        NSString* message = @"검색된 위치바코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isOperationFinished = YES;
    }
}

- (void)processOTDResponse
{
    [workDic setObject:txtLocCode.text forKey:@"LOC_CD"];
    //working task add
    NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
    [taskDic setObject:@"L" forKey:@"TASK"];
    [taskDic setObject:txtLocCode.text forKey:@"VALUE"];
    [taskList addObject:taskDic];
    
    if (![JOB_GUBUN isEqualToString:@"철거"] && [txtDeviceID.text length]){
        [self requestDeviceCode:txtDeviceID.text];
    }
    
    // 철거는 INS_USER가 아닌 경우 WBS선택이 필요하므로 WBS목록을 요청한다.
    BOOL isRequestWBS = NO;
    if ([JOB_GUBUN isEqualToString:@"철거"] &&
        (strUserOrgTypeCode.length > 0 && ![strUserOrgTypeCode isEqualToString:@"INS_USER"])){
        // 음영지역에서는 WBS를 선택할 수 없음.
        if (!isOffLine){
            isRequestWBS = YES;
            [self requestWBSCode:strLocBarCode];
        }
    }
    if (!isRequestWBS)
        isOperationFinished = YES;
}

// WBS 목록을 받으면 선택할 수 있도록 화면에 띄워준다.
- (void)processWBSList:(NSArray*)wbsList
{
    if ([wbsList count]){
        wbsResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in wbsList){
            NSMutableDictionary* wbsDic = [NSMutableDictionary dictionary];
            
            if ([JOB_GUBUN isEqualToString:@"철거"]){
                [wbsDic setObject:[dic objectForKey:@"NAME1"] forKey:@"NAME1"];
                [wbsDic setObject:[dic objectForKey:@"POSID"] forKey:@"POSID"];
                [wbsDic setObject:[dic objectForKey:@"POST1"] forKey:@"POST1"];
            }
            
            [wbsResultList addObject:wbsDic];
        }
        if ([JOB_GUBUN isEqualToString:@"철거"] || [JOB_GUBUN isEqualToString:@"인계"] ||
            [JOB_GUBUN isEqualToString:@"인수"] || [JOB_GUBUN isEqualToString:@"시설등록"]){
            WBSListViewController* vc = [[WBSListViewController alloc] init];
            vc.delegate = self;
            vc.wbsList = wbsResultList;
            vc.JOB_GUBUN = JOB_GUBUN;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        NSLog(@"WBS가 없습니다.");
        NSString* message = @"WBS가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
    
    isOperationFinished = YES;
}

- (void)processFccItemInfoResponse:(NSArray*)resultList
{
    
    if ([resultList count]){
        BOOL isEmptySAPList = YES;
        if (originalSAPList.count)
            isEmptySAPList = NO;
        
        //데이터 1개
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
        NSString* compType;
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            compType = @"";
        else
            compType = [dic objectForKey:@"COMPTYPE"];
        NSString* partTypeName = [WorkUtil getPartTypeName:compType device:[dic objectForKey:@"ZMATGB"]];
        
        // partTypeName : R, S, U, E
        [sapDic setObject:partTypeName forKey:@"PART_NAME"];
        [sapDic setObject:strFccBarCode forKey:@"EQUNR"];   // barcode
        [sapDic setObject:@"" forKey:@"ZPSTATU"];
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        [sapDic setObject:barcodeName forKey:@"MAKTX"];
        [sapDic setObject:[dic objectForKey:@"ZMATGB"] forKey:@"ZMATGB"];
        [sapDic setObject:@"" forKey:@"ZEQUIPLP"];
        [sapDic setObject:@"" forKey:@"ZPPART"];
        [sapDic setObject:@"" forKey:@"ZKOSTL"];
        [sapDic setObject:@"" forKey:@"ZKTEXT"];
        
        // 최초스캔 - 3, 추가 - 2 ==> 전송할때는 1로 변경해서 전송한다.
        if (isEmptySAPList)
            [sapDic setObject:@"3" forKey:@"SCANTYPE"];
        else
            [sapDic setObject:@"2" forKey:@"SCANTYPE"];
        
        [sapDic setObject:@"Y__" forKey:@"ORG_CHECK"];
        // 새롭게 정의한 값, 전송 후 실패시 그 결과를 표시해주기 위함.
        [sapDic setObject:@"S" forKey:@"RSLT"];
        [sapDic setObject:@"" forKey:@"MESG"];
        
        // table view에 tree구조를 만들어 주면서 insert
        [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:btnHierachy.selected isCheckUU:btnUU.selected isRemake:YES fccList:originalSAPList job:JOB_GUBUN];
        lblPartType.text = [sapDic objectForKey:@"PART_NAME"];
        
        [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        
        //데이터 변경
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        
        // 작업관리
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* message = @"물품정보가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    // fccSAPList를 만들고, 화면도 반영
    [self reloadTableWithRefresh:YES];
    [self scrollToIndex:nSelectedRow];
    
    isOperationFinished = YES;
}

-(void)processSAPFccDetailResponse:(NSArray*)resultList{
    if ([resultList count]){
        [Util setScrollTouch:scrollMaktx Label:txtMaktx withString:[[resultList objectAtIndex:0] objectForKey:@"MAKTX"]];
        txtSubmt.text = [[resultList objectAtIndex:0] objectForKey:@"SUBMT"];
        if([[[resultList objectAtIndex:0] objectForKey:@"ZEQUIPGC"] length] > 0){
            txtDeviceID.text = [[resultList objectAtIndex:0] objectForKey:@"ZEQUIPGC"];
            txtDeviceCd.text = @"";
        }else{
            txtDeviceID.text = @"";
            txtDeviceCd.text = @"";
            [self requestRepairHistoryList];
            return;
        }
        
    }
    isFacQuMode = YES;
    [self requestDeviceCode:txtDeviceID.text];
    //    [self requestRepairHistoryList];
}

-(void)repairListResponse:(NSArray*)resultList{
    repairHistory = [NSMutableArray array];
    
    if (resultList.count){
        for (NSDictionary* dic in resultList)
        {
            NSMutableDictionary* repairDic = [NSMutableDictionary dictionary];
            [repairDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];
            [repairDic setObject:[dic objectForKey:@"MATNR"] forKey:@"MATNR"];
            [repairDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [repairDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
            [repairDic setObject:[dic objectForKey:@"ERDAT"] forKey:@"ERDAT"];
            [repairDic setObject:[dic objectForKey:@"AUSBS"] forKey:@"AUSBS"];
            [repairDic setObject:[dic objectForKey:@"FECODN"] forKey:@"FECODN"];
            [repairDic setObject:[dic objectForKey:@"URSTX2"] forKey:@"URSTX2"];
            [repairDic setObject:[dic objectForKey:@"LIFNRN"] forKey:@"LIFNRN"];
            
            [repairHistory addObject:repairDic];
        }
    }
    if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        [_tableView2 reloadData];
    }else{
        [_tableView reloadData];
    }
    
    [self showCount];
}

-(void)processBreakDownInfo:(NSArray*)resultList{
    if ([resultList count]){
        NSDictionary* firstDic = [resultList objectAtIndex:0];
        
        NSString* E_INFO= [firstDic objectForKey:@"E_INFO"];
        int E_CTL_CNT  = [[firstDic objectForKey:@"E_CTL_CNT"] intValue];
        
        if([E_INFO isEqualToString:@"X"]){
            NSString* message = [NSString stringWithFormat:@"설비 %@ 는\n\r고장 기준수( %d회)를\n\r초과한 설비입니다.\n\r처분(불용대기) 하시려면 '예'\n\r고장등록 하시려면 '아니오'를\n\r선택하세요.", strFccBarCode, E_CTL_CNT];
            [self showMessage:message tag:1800 title1:@"예" title2:@"아니오"];
        }
    }
}

- (void)processSAPInfoResponse:(NSArray*)resultList
{
    if ([resultList count]){
        // 스캔한 바코드정보
        NSDictionary* firstDic = [resultList objectAtIndex:0];
        
        //장비상태 체크
        NSString* status = [firstDic objectForKey:@"ZPSTATU"];
        NSString* desc = [firstDic objectForKey:@"ZDESC"];
        NSString* submt = [firstDic objectForKey:@"SUBMT"];
        NSString* locCode = [firstDic objectForKey:@"ZEQUIPLP"];
        NSString* part = [firstDic objectForKey:@"ZPPART"];
        
        // 해당 바코드가 현재의 JOB(JOB_GUBUN)을 실행 할 수 있는 상태인지 여부 판단
        // errorMessage가 @""가 아닌 경우는 오류상황이므로 메세지 띄워주고 리턴.  그렇지 않은 경우는 오류 아님.
        NSString* errorMessage = [WorkUtil processCheckFccStatus:status desc:desc submt:submt];
        if (errorMessage.length){
            [self showMessage:errorMessage tag:-1 title1:@"닫기" title2:nil isError:YES];
            isOperationFinished = YES;
            
            return;
        }
        
        // 송부(팀간)의 경우 받아온 리스트 중에서 하나라도 조건(예비/유휴상태만 가능함)에 맞지 않으면 리턴한다.
        if ([JOB_GUBUN isEqualToString:@"송부(팀간)"]){
            for(NSDictionary* dic in resultList){
                NSString* status = [dic objectForKey:@"ZPSTATU"];
                
                if (
                    ![status isEqualToString:@"0100"] &&
                    ![status isEqualToString:@"0110"]
                    )
                {
                    NSString* message = [NSString stringWithFormat:@"'예비/유휴' 상태가 아닌 설비는\n'%@'작업을\n하실 수 없습니다.", JOB_GUBUN];
                    
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                    isOperationFinished = YES;
                    
                    return;
                }
            }
        }
        
        if ([JOB_GUBUN isEqualToString:@"탈장"]){
            if ([locCode hasPrefix:@"VS"]){
                NSString* message = [NSString stringWithFormat:@"'창고(%@)'\n설비바코드는\n'%@' 작업을\n하실 수 없습니다.",locCode,JOB_GUBUN];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                isOperationFinished = YES;
                
                return;
            }
        }else if([JOB_GUBUN isEqualToString:@"개조개량의뢰"]){
            if([[firstDic objectForKey:@"ZKEQUI"] isEqualToString:@"M"]){
                NSString* message = [NSString stringWithFormat:@"'제조사물자'인 설비바코드는\n'%@' 작업을\n하실 수 없습니다.", JOB_GUBUN];
                [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
                isOperationFinished = YES;
                
                return;
            }
            
        }else if ([JOB_GUBUN isEqualToString:@"철거"]){
            
            NSString* zkequi = [firstDic objectForKey:@"ZKEQUI"];
            NSString* zanln1 = [firstDic objectForKey:@"ZANLN1"];
            
            if (![zkequi hasSuffix:@"B"] && zanln1.length <= 0)
            {
                NSString* message = [NSString stringWithFormat:@"자산화가 안 된 설비바코드는\n '%@'작업을\n하실 수 없습니다.",JOB_GUBUN];
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                isOperationFinished = YES;
                
                return;
            }
            
        }
        else if ([JOB_GUBUN isEqualToString:@"실장"])
        {
            // 창고 실장이면 설비바코드의 위치도 창고이어야 함.. request by 오종윤 2012.09.13
            if ([strLocBarCode hasPrefix:@"VS"] && ![locCode hasPrefix:@"VS"])
            {
                NSString* message = @"위치바코드 유형이 '창고'인\n설비바코드를 스캔하세요.";
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
            
            NSString *O_DATA_C = [firstDic objectForKey:@"O_DATA_C"];
            NSString *ZANLN1 = [firstDic objectForKey:@"ZANLN1"]; //자산번호
            NSString *ZKEQUI = [firstDic objectForKey:@"ZKEQUI"]; //설비처리구분
            NSString *HOST_YN = [firstDic objectForKey:@"HOST_YN"];
            NSString *USG_YN = [firstDic objectForKey:@"USG_YN"];
            
            if([HOST_YN isEqualToString:@"N"]){
                NSString *message_val = @"서버 호스트매핑 완료 후 실장 등록 진행하시기 바랍니다.\n자세한사항은 http://itam.kt.com 초기화면 하단 공지사항\n‘전사 서버 IT자산관리 정책’을 참고하세요.\n문의처: itam@kt.com";
                [[ERPAlert getInstance] showAlertMessage:message_val tag:-1 title1:@"닫기" title2:nil isError:NO isCheckComplete:YES delegate:self];
            }
            if([USG_YN isEqualToString:@"N"]){
                NSString *message_val = @"ITAM시스템(itam.kt.com)에 성능정보가 수집이 되고 있지 않습니다.\nITAM 로그인 후 > 하단 성능정보 수집\n매뉴얼을 참고하시어 현행화 부탁 드립니다.\n문의사항 : itam@kt.com";
                [[ERPAlert getInstance] showAlertMessage:message_val tag:-1 title1:@"닫기" title2:nil isError:NO isCheckComplete:YES delegate:self];
            }
            
            if([O_DATA_C isEqualToString:@"2"] && [ZANLN1 isEqualToString:@""] && ([ZKEQUI isEqualToString:@""] || [ZKEQUI isEqualToString:@"N"])){
                NSString* message = @"해당 설비바코드는 '신품'이므로\n실장처리가 불가합니다.\n'시설등록'으로 처리 하시기 바랍니다";
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
        }
        else if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"] || [JOB_GUBUN isEqualToString:@"형상해제(창고내)"]){
            if (![strLocBarCode isEqualToString:locCode] && [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                NSString* message = @"설비바코드의 위치가 스캔한 위치바코드와 다릅니다. 입고(팀내) 작업 후 형상구성하세요.";
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
            
            if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"] && [part isEqualToString:@""]){
                NSString* message = [NSString stringWithFormat:@"'단품'은 형상구성 대상 설비가 아닙니다."];
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
            
            if (![status isEqualToString:@"0100"] && ![status isEqualToString:@"0110"] && ![status isEqualToString:@"0020"]){
                NSString* message = @"";
                if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                    message = [NSString stringWithFormat:@"'유휴/예비/납품입고' 상태만 형상구성이 가능합니다."];
                }else{
                    message = [NSString stringWithFormat:@"'유휴/예비/납품입고' 상태만 형상해제가 가능합니다."];
                }
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
            
            if (locCode.length > 17 && ![locCode hasPrefix:@"VS"] && ![[locCode substringFromIndex:17] isEqualToString:@"0000"]){
                NSString *message = [NSString stringWithFormat:@"'베이' 에 위치해 있는 설비로는 '%@'\n작업을 하실 수 없습니다.",JOB_GUBUN];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                isOperationFinished = YES;
                
                return;
            }
        }
        
        // 화면 상의 상위바코드 찾아오기
        NSDictionary* parentItemDic = nil;
        if(originalSAPList.count){
            int upperIndexset = [WorkUtil getReverseParentIndex:originalSAPList];
            if (upperIndexset!= -1){
                parentItemDic = [originalSAPList objectAtIndex:upperIndexset];
            }
            else {
                NSDictionary* subDic = [fccSAPList objectAtIndex:nSelectedRow];
                parentItemDic = [WorkUtil getItemFromFccList:[subDic objectForKey:@"EQUNR"] fccList:originalSAPList];
            }
        }
        
        // 스캔한 설비의 partType을 이용하여, 여러 설비를 동시에 작업할 수 있는 JOB인지 여부 판단.
        NSString* partTypeName = [WorkUtil getPartTypeName:[firstDic objectForKey:@"ZPPART"] device:[firstDic objectForKey:@"ZPGUBUN"]];
        
        if ([self isCanMultiFacPartTypeName:partTypeName]){
            NSString* message = [NSString stringWithFormat:@"여러 설비를 동시에 '%@' 작업을\n하실 수 없습니다.\n먼저 전송 후 다시 시도하세요.",JOB_GUBUN];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            isOperationFinished = YES;
            
            return;
        }
        
        if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
            if([resultList count] > 1){
                NSString *childBarcode = @"";
                NSString *sapBarcode = @"";
                
                for (NSDictionary* childDic in resultList){
                    childBarcode = [childDic objectForKey:@"EQUNR"];
                    for(NSDictionary* sapDic in originalSAPList){
                        sapBarcode = [sapDic objectForKey:@"EQUNR"];
                        if([childBarcode isEqualToString:sapBarcode]){
                            [self showMessage:[NSString stringWithFormat:@"중복 스캔입니다.\n\n%@",childBarcode] tag:-1 title1:@"닫기" title2:nil];
                            isOperationFinished = YES;
                            return;
                        }
                    }
                }
            }
        }
        
        // 운영조직 변경 여부
        isOrgChanged = NO;
        [self processCheckOrganization:[resultList objectAtIndex:0]];
        
        // 최초 추가인 경우 isEmptyList = YES
        // 추가 되는 경우는 NO
        BOOL isEmptyList = YES;
        NSString* rootPartTypeName = @"";
        if (originalSAPList.count){ // 화면에 보이지는 않지만, 실제로 모든 항목을 갖고 있다. => fccSAPList가 실제로 보이는 리스트
            isEmptyList = NO;
            rootPartTypeName = [WorkUtil getPartTypeName:[[originalSAPList objectAtIndex:0] objectForKey:@"ZPPART"] device:[[originalSAPList objectAtIndex:0] objectForKey:@"ZPGUBUN"]];
        }
        
        
        // 스캔한 후 서버로 부터 온 리스트 중 첫 번째 항목(스캔한 설비)인 경우 isFirstScan = YES else NO
        BOOL isFirstScan = YES;
        
        for (NSDictionary* dic in resultList)
        {
            if([JOB_GUBUN isEqualToString:@"설비상태변경"]){
                NSString* status = [dic objectForKey:@"ZPSTATU"];
                if([status isEqualToString:@"0240"]){
                    continue;
                }
            }
            
            // -- 입고(팀내), 철거는 다중처리 허용 - 기존 스캔한 바코드가 불러온 설비에 있을 경우 기존 스캔한 바코드 삭제 처리
            // 서버로 부터 받은 설비가 이전에 originalSAPList에 추가된적이 있다면, 이전 추가된 설비정보를 삭제하도록 한다.
            // 이때 이전 추가된 설비정보고 스캔에 의한 설비(스캔타입이 "0"이 아닌경우)라면 isScanAlready = YES, else NO
            // 새로 추가되는 설비정보의 스캔타입을 일치시켜주기 위함.
            BOOL isScanAlready = NO;
            if ([JOB_GUBUN isEqualToString:@"입고(팀내)"] ||
                [JOB_GUBUN isEqualToString:@"설비상태변경"] ||
                [JOB_GUBUN isEqualToString:@"철거"]){
                for(NSDictionary* oldDic in originalSAPList){
                    if ([[dic objectForKey:@"EQUNR"] isEqualToString:[oldDic objectForKey:@"EQUNR"]]){
                        if (![[oldDic objectForKey:@"SCANTYPE"] isEqualToString:@"0"])
                            isScanAlready = YES;
                        
                        [originalSAPList removeObject:oldDic];
                        break;
                    }
                }
                
                if (originalSAPList.count <= nSelectedRow)
                    nSelectedRow = originalSAPList.count - 1;
            }
            
            NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
            
            // 스캔한 설비가 아니고 다른 설비번호가 SAP으로부터 올 때 SAP으로부터 온 설비로 셋팅
            // 이때 SAP으로 부터 온 설비바코드는 스캔한 바코드를 포함하고 있으므로...  이를 통해 같은 설비임을 알 수 있다.
            NSString* barcode = [dic objectForKey:@"EQUNR"];
            if (![strFccBarCode isEqualToString:barcode]){
                if ([barcode rangeOfString:strFccBarCode].location != NSNotFound){
                    strFccBarCode = barcode;
                    txtFacCode.text = strFccBarCode;
                }
            }
            
            if([dic objectForKey:@"DEVICEGB"] != nil) [sapDic setObject:[dic objectForKey:@"DEVICEGB"] forKey:@"DEVICEGB"];
            if([dic objectForKey:@"DEVICEGC"] != nil) [sapDic setObject:[dic objectForKey:@"DEVICEGC"] forKey:@"DEVICEGC"];
            [sapDic setObject:[dic objectForKey:@"EQKTX"] forKey:@"EQKTX"];
            [sapDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];//설비바코드
            if([dic objectForKey:@"HEQKTX"] != nil) [sapDic setObject:[dic objectForKey:@"HEQKTX"] forKey:@"HEQKTX"];
            [sapDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];//상위바코드
            if([dic objectForKey:@"LEVEL"] != nil) [sapDic setObject:[dic objectForKey:@"LEVEL"] forKey:@"LEVEL"];
            [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [sapDic setObject:[dic objectForKey:@"ZANLN1"] forKey:@"ZANLN1"];
            [sapDic setObject:[dic objectForKey:@"ZDESC"] forKey:@"ZDESC"];
            [sapDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
            [sapDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
            [sapDic setObject:[dic objectForKey:@"ZKEQUI"] forKey:@"ZKEQUI"];
            [sapDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"]; //설비의 운용조직
            [sapDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];
            [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [sapDic setObject:@"" forKey:@"ORGCH"];
            if([dic objectForKey:@"ZSETUP"] != nil) [sapDic setObject:[dic objectForKey:@"ZSETUP"] forKey:@"ZSETUP"];   // 셋업공사비 //matsua : test
            NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
            if([dic objectForKey:@"GWLEN_O"] != nil)[sapDic setObject:[dic objectForKey:@"GWLEN_O"] forKey:@"GWLEN_O"];     //보증종료일
            //새롭게 만들어준 키값
            
            if ([partTypeName length])
                [sapDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [sapDic setObject:@"" forKey:@"PART_NAME"];
            
            //조직체크 추가
            NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
            NSString* orgName = [dic objectForKey:@"ZKTEXT"];
            NSString* checkOrgValue = nil;
            
            if (([JOB_GUBUN isEqualToString:@"실장"] && ([rootPartTypeName isEqualToString:@"U"] || [rootPartTypeName isEqualToString:@"S"])) ||
                ([JOB_GUBUN isEqualToString:@"형상구성(창고내)"] && ([rootPartTypeName isEqualToString:@"U"] || [rootPartTypeName isEqualToString:@"S"])))
            {
                // 유닛이나 쉘프 실장은 전송 직전에 운용조직 변경 여부 물어 본다. 상속 받으면 물어 보지 않는다.
                //조직 체크값 관리 ORG_CHECK_VALUE
                checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
            }
            else if ([JOB_GUBUN isEqualToString:@"납품취소"] ||
                     [JOB_GUBUN isEqualToString:@"배송출고"]){
                checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@", orgCode, orgName];
            }
            else if (![JOB_GUBUN isEqualToString:@"출고"])
            {
                if (isOrgChanged) //운용 조직변경한 경우
                {
                    checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
                }
                else {
                    checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
                }
            }
            
            [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
            
            if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
                NSString *ParentPart = @"";
                if([fccSAPList count] == 0){
                    ParentPart = [[resultList objectAtIndex:0] objectForKey:@"PART_NAME"];
                }else{
                    ParentPart = [[fccSAPList objectAtIndex:0] objectForKey:@"PART_NAME"];
                }
                
                if([ParentPart isEqualToString:@"R"]){
                    if(isOrgChanged){
                        [sapDic setObject:@"YES" forKey:@"ORGCH"];
                    }else{
                        [sapDic setObject:@"NO" forKey:@"ORGCH"];
                    }
                }
            }
            
            // 입고(팀내), 철거는 새로 tree구조를 만들지 않고, SAP으로 부터 받은 tree구조를 이용한다.
            BOOL isMakeHierachy = YES;
            
            // 형상구성 비 선택시 tree구조를 만들지 않는다.
            if(!btnHierachy.hidden)
                isMakeHierachy = btnHierachy.selected;
            
            // 아래의 항목들은 형상구성 버튼 클릭 여부에 상관없이 병렬로 만든어 주어야 하므로 isMakeHierachy = NO로 설정한다.
            // 출고(팀내), 탈장, 송부(팀간), 설비상태변경, 고장등록, 배송출고도 R,S,U스캔시 형상 단절하여 병렬처리
            // --> 납품입고, 실장 외의 작업이 해당됨.
            // request by 김희선 2014. 2. 11
            if ((![JOB_GUBUN isEqualToString:@"납품입고"] && ![JOB_GUBUN isEqualToString:@"실장"] && ![JOB_GUBUN isEqualToString:@"형상구성(창고내)"]) && isFirstScan)
                isMakeHierachy = NO;
            
            // tableview에 tree구조를 만들어 insert해준다.
            [WorkUtil makeHierarchyOfAddedData:sapDic selRow:&nSelectedRow isMakeHierachy:isMakeHierachy isCheckUU:btnUU.selected isRemake:isFirstScan fccList:originalSAPList job:JOB_GUBUN];
            
            // 납품취소시에는 모든 설비의 스캔타입을 "1"로 설정한다.
            // 이전 추가한 리스트가 없는 경우에는 스캔한 설비가 아닌 경우 스탠타입 "0" 스캔한 경우는 "3"
            // 기존 리스트에 추가하는 경우에는 입고(팀내), 철거인 경우 위에서 중복 체크에서 중복이 있었다면, 그 스캔타입으로 설정한다.
            // 기존 리스트에 추가하는 경우, 위의 경우가 아니고, 스캔한 바코드라면
            // => 화면 상의 상위 바코드가 있다면 추가 이므로 "2"
            // => 그렇지 않은 경우는 최초스캔이므로 "3"
            // => 스캔한 바코드가 아니라면 "0"으로 스캔타입을 설정한다.
            if ([JOB_GUBUN isEqualToString:@"납품취소"])
                [sapDic setObject:@"1" forKey:@"SCANTYPE"];
            else if (isEmptyList){
                if (![barcode isEqualToString:strFccBarCode])
                    [sapDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
                else
                    [sapDic setObject:@"3" forKey:@"SCANTYPE"]; //상위 설비
            }else{
                if (([JOB_GUBUN isEqualToString:@"입고(팀내)"] || [JOB_GUBUN isEqualToString:@"철거"] || [JOB_GUBUN isEqualToString:@"설비상태변경"]) && isScanAlready)
                    [sapDic setObject:@"1" forKey:@"SCANTYPE"];
                else if ([[dic objectForKey:@"EQUNR"] isEqualToString:strFccBarCode]){  // 스캔한 바코드라면...
                    NSString* upperBarcode = [sapDic objectForKey:@"HEQUNR"]; // 화면 상의 리스트에 상위바코드
                    if (upperBarcode.length)    // 상위바코드가 있으면 해당 상위바코드에 추가 - "2"
                        [sapDic setObject:@"2" forKey:@"SCANTYPE"];
                    else
                        [sapDic setObject:@"3" forKey:@"SCANTYPE"];
                }else
                    [sapDic setObject:@"0" forKey:@"SCANTYPE"];
            }
            
            // 이미 데이타를 하나라도 처리한 후 이므로 isFirstScan은 NO로 설정한다.
            isFirstScan = NO;
        }
        
        if ([JOB_GUBUN isEqualToString:@"납품취소"]){
            nSelectedRow = [WorkUtil getBarcodeIndex:strFccBarCode fccList:originalSAPList];
        }else if ([JOB_GUBUN isEqualToString:@"납품입고"] ||
                  [JOB_GUBUN isEqualToString:@"배송출고"])
            nSelectedRow = 0;
        
        // fccSAPList를 만들고, 화면도 반영
        [self reloadTableWithRefresh:YES];
        [self scrollToIndex:nSelectedRow];
        
        // 스캔 취소시 최초 수신데이터로 변경해 주기 위해서...
        if (isFirst){
            isFirst = NO;
            firstFccSAPList = [NSMutableArray arrayWithArray:originalSAPList];
        }
        
        // 변경된 자료가 있음을 설정(back버튼 클릭스 체크위해서..)
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        isDataSaved = NO;
        
        
        // 작업관리
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"F" forKey:@"TASK"];
        [taskDic setObject:strFccBarCode forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    else {
        NSString* message = @"존재하지 않는 설비바코드입니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
    [self showCount];
    
    if([JOB_GUBUN isEqualToString:@"실장"] || [JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
        if([resultList count] > 0){
            nSelectedRow = [WorkUtil getBarcodeIndex:strFccBarCode fccList:originalSAPList];
        }
    }
    
    // 고장등록 => 선택한 설비에 해당 이미지가 있다면 그 이미지를 표시한다.
    if ([JOB_GUBUN isEqualToString:@"고장등록"] && nSelectedRow >= 0){
        NSDictionary* selItemDic = [fccSAPList objectAtIndex:nSelectedRow];
        if([selItemDic objectForKey:@"PICTURE"] != nil){
            UIImage* picture = [selItemDic objectForKey:@"PICTURE"];
            [btnPicture setBackgroundImage:picture forState:UIControlStateNormal];
        }else
            [btnPicture setBackgroundImage:defaultImage forState:UIControlStateNormal];
    }
    
    if([JOB_GUBUN isEqualToString:@"고장등록"]){
        [self requestFccBreakDown:strFccBarCode];
    }
    
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    
    isOperationFinished = YES;
}

- (void)processDeviceBarcode:(NSDictionary*)devideInfoDic
{
    NSLog(@"device dic [%@]",devideInfoDic);
    
    NSString* operationSystemToken = [devideInfoDic objectForKey:@"operationSystemToken"];  // 운영시스템 구분자
    NSString* standardServiceCode = [devideInfoDic objectForKey:@"standardServiceCode"];    // 표준서비스코드
    NSString* operationSystemCode = [devideInfoDic objectForKey:@"operationSystemCode"];    // 장비아이디
    NSString* deviceID = [devideInfoDic objectForKey:@"deviceId"];
    NSString* deviceName = [devideInfoDic objectForKey:@"deviceName"];
    deviceLocCd = [devideInfoDic objectForKey:@"locationCode"];
    deviceLocNm = [devideInfoDic objectForKey:@"locationShortName"];
    
    if ( [operationSystemToken isEqualToString:@"02"] && ![standardServiceCode length]){
        
        NSString* message = [NSString stringWithFormat:@"장치아이디 %@는\n운용시스템 구분자가 'ITAM'이며 \n IT표준서비스코드가 '없음'이므로\n스캔이 불가합니다.\n전사기준정보관리시스템(MDM)에\n문의하세요",strDeviceID];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        isOperationFinished = YES;
        
        return;
    }
    
    // 통합 NMS 대상 장치 ID의 장비ID가 삭제되었을 경우 ERP Barcode Web에서 출력 및 스캔 불가 - DR-2014-08382 : request by 박장수 2014.03.11
    if ( ([operationSystemToken isEqualToString:@"04"] || [operationSystemToken isEqualToString:@"08"] || [operationSystemToken isEqualToString:@"09"] || [operationSystemToken isEqualToString:@"10"]) && [operationSystemCode isEqualToString:@""]){
        
        NSString* message = [NSString stringWithFormat:@"통합NMS 대상 장치ID의 장비ID가\n삭제되어 스캔이 불가합니다. \n전사기준정보관리시스템(MDM)에\n문의하세요."];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        isOperationFinished = YES;
        
        return;
    }
    
    //물품명
    [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:[NSString stringWithFormat:@"%@/%@/%@/%@",[devideInfoDic objectForKey:@"itemCode"],[devideInfoDic objectForKey:@"itemName"],[devideInfoDic objectForKey:@"locationCode"],[devideInfoDic objectForKey:@"deviceStatusName"]]];
    
    //device id 할당
    if (deviceID.length){
        if([JOB_GUBUN isEqualToString:@"고장정보"]||[JOB_GUBUN isEqualToString:@"고장수리이력"]){
            if(!isFacQuMode){
                txtFacCode.text = @"";
                txtSubmt.text = @"";
                txtMaktx.text = @"";
                txtDeviceCd.text = deviceName;
            }else{
                txtDeviceCd.text = deviceName;
                isFacQuMode = NO;
            }
        }
        else{
            txtDeviceID.text = deviceID;
            strDeviceID = txtDeviceID.text;
        }
        
        [workDic setObject:txtDeviceID.text forKey:@"DEVICE_ID"];
        //working task add
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"D" forKey:@"TASK"];
        [taskDic setObject:txtDeviceID.text forKey:@"VALUE"];
        [taskList addObject:taskDic];
    }
    
    if([JOB_GUBUN isEqualToString:@"고장정보"] || [JOB_GUBUN isEqualToString:@"고장수리이력"]){
        [self requestRepairHistoryList];
    }else{
        if (operationSystemCode.length){
            lblDeviceID.text = operationSystemCode;
        }
    }
    
    [self performSelectorOnMainThread:@selector(upperBecameFirstResponder) withObject:nil waitUntilDone:NO];
    isOperationFinished = YES;
}

// 상위바코드(실장)
- (void)processUpperSAPFccResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        //데이터가 여러건 나온다..그러나 1건만 처리
        NSDictionary* dic = [resultList objectAtIndex:0];
        NSString* ZEQUIPLP = [dic objectForKey:@"ZEQUIPLP"];
        NSString* ZPSTATU = [dic objectForKey:@"ZPSTATU"];
        NSString* ZDESC = [dic objectForKey:@"ZDESC"];
        upper_deviceID = [dic objectForKey:@"ZEQUIPGC"]; // 상위바코드 장치아이디
        upper_OperOrgName = [dic objectForKey:@"ZKTEXT"];  // 상위 설비의 운용 조직명
        upper_OperOrgCode = [dic objectForKey:@"ZKOSTL"];  //상위 바코드 운용 조직코드
        
        NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
        lblUpperPartType.text = partTypeName;
        
        NSString* JOBGUBUN = [Util udObjectForKey:USER_WORK_NAME];
        
        if (![ZEQUIPLP isEqualToString:strLocBarCode] && isRequireLocCode){
            NSString* message = [NSString stringWithFormat:@"스캔하신 위치바코드와 상위바코드의\n위치바코드가 상이합니다.\n동일한 위치의 상위바코드를\n스캔하세요."];
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            txtUFacCode.text = @"";
            strUpperBarCode = @"";
            lblUpperPartType.text = @"";
            isOperationFinished = YES;
            upper_deviceID = @"";
            upper_OperOrgCode = @"";
            upper_OperOrgName = @"";
            [self checkOrgInheritance];
            
            return;
        }
        
        if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"] && [partTypeName isEqualToString:@""]){
            NSString* message = [NSString stringWithFormat:@"'단품'은 형상구성 대상 설비가 아닙니다."];
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            isOperationFinished = YES;
            
            return;
        }
        
        // 실장 - 상위바코드가 운용이 아니면 실장 불가 처리 -  2014.01.15 request by 김희선 - modify by 류성호
        //if(strLocBarCode.length > 17 && ![strLocBarCode hasPrefix:@"VS"] && ![[strLocBarCode substringFromIndex:17] isEqualToString:@"0000"] && ![ZPSTATU isEqualToString:@"0060"]) {
        if (![ZPSTATU isEqualToString:@"0060"] && ![JOB_GUBUN isEqualToString:@"형상구성(창고내)"]) {
            NSString* message = [NSString stringWithFormat:@"상위 설비의 상태가 '%@'인\n상위 설비는 '%@' 작업을\n하실 수 없습니다.", ZDESC, JOB_GUBUN];
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            txtUFacCode.text = @"";
            strUpperBarCode = @"";
            lblUpperPartType.text = @"";
            isOperationFinished = YES;
            upper_deviceID = @"";
            upper_OperOrgCode = @"";
            upper_OperOrgName = @"";
            [self checkOrgInheritance];
            
            return;
        }
        
        /*
         * request by 강준석 - 2012.07.07
         실장 되는 설비의 상태가 불용관련된거 실장못하게 validation 걸었는데..
         상태 추가 좀 해주세요..
         0120 고장
         0130 수리의뢰
         0160 수리완료송부
         * 탈장 -> 2012.08.01
         상위바코드가 탈장이면 실장 안되게...
         코드 0080
         */
        if([JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
            if (![ZPSTATU isEqualToString:@"0100"] && ![ZPSTATU isEqualToString:@"0110"] && ![ZPSTATU isEqualToString:@"0020"]){
                NSString* message = [NSString stringWithFormat:@"'유휴/예비/납품입고' 상태만 형상구성이 가능합니다."];
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                [self checkOrgInheritance];
                
                return;
            }
        }else{
            if ([ZPSTATU isEqualToString:@"0021"] || [ZPSTATU isEqualToString:@"0080"] || [ZPSTATU isEqualToString:@"0120"] || [ZPSTATU isEqualToString:@"0130"] ||
                [ZPSTATU isEqualToString:@"0160"] || [ZPSTATU isEqualToString:@"0200"] || [ZPSTATU isEqualToString:@"0210"] || [ZPSTATU isEqualToString:@"0240"] ||
                [ZPSTATU isEqualToString:@"0260"] || [ZPSTATU isEqualToString:@"0270"]){
                NSString* message = [NSString stringWithFormat:@"상위 설비의 상태가 %@인 설비로\n %@작업을\n하실 수 없습니다.",ZDESC,JOBGUBUN];
                
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                [self checkOrgInheritance];
                
                return;
            }
            
            if (!upper_deviceID.length){
                NSString* message = [NSString stringWithFormat:@"장치ID가 없는 상위설비입니다.\n상위설비부터 처리하신 후\n다시 실행하세요"];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                [self checkOrgInheritance];
                
                return;
            }
        }
        
        if (!upper_OperOrgCode.length){
            NSString* message = [NSString stringWithFormat:@"운용조직이 없는 상위설비입니다.\n상위설비부터 처리하신 후\n다시 실행하세요."];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            txtUFacCode.text = @"";
            strUpperBarCode = @"";
            lblUpperPartType.text = @"";
            isOperationFinished = YES;
            upper_deviceID = @"";
            upper_OperOrgCode = @"";
            upper_OperOrgName = @"";
            [self checkOrgInheritance];
            
            return;
        }
        
        if(![JOB_GUBUN isEqualToString:@"형상구성(창고내)"]){
            if ([partTypeName isEqualToString:@"U"]){
                NSString* parentPartTypeName = [WorkUtil getParentPartName:originalSAPList];
                if ([parentPartTypeName isEqualToString:@"U"]){ //상위바코드 부품종류
                    NSString* message = [NSString stringWithFormat:@"상위 설비로 '유닛' 을 스캔하였습니다.\n진행하시겠습니까?"];
                    [self showMessage:message tag:900 title1:@"예" title2:@"아니오"];
                    isOperationFinished = YES;
                    upper_deviceID = @"";
                    upper_OperOrgCode = @"";
                    upper_OperOrgName = @"";
                    [self checkOrgInheritance];
                    
                    return;
                }
            }
        }else{
            NSString* parentPartTypeName = [WorkUtil getParentPartName:originalSAPList];
            if([parentPartTypeName isEqualToString:partTypeName]){
                NSString *tmpName = @"";
                if([partTypeName isEqualToString:@"S"]){
                    tmpName = @"Shelf";
                }else if([partTypeName isEqualToString:@"R"]){
                    tmpName = @"Rack";
                }else if([partTypeName isEqualToString:@"U"]){
                    tmpName = @"Unit";
                }
                
                NSString* message = [NSString stringWithFormat:@"'%@'의 상위바코드로 '%@'을\n스캔 하실 수 없습니다.",tmpName,tmpName];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                [self checkOrgInheritance];
                
                return;
            }
        }
        
        // 실장 할 설비와 스캔한 상위바코드와 관계 유효성 체크
        if (originalSAPList.count){
            BOOL isError = NO;
            
            NSString* rootPartTypeName = [WorkUtil getParentPartName:originalSAPList];
            if ([rootPartTypeName isEqualToString:@"S"]){
                if (
                    //S-S N/A
                    ![partTypeName isEqualToString:@"R"] &&
                    ![partTypeName isEqualToString:@"E"]
                    ) {
                    // E-S 가능 -> 단품 랙
                    isError = YES;
                }
            }
            else if ([rootPartTypeName isEqualToString:@"U"]){
                if (
                    ![partTypeName isEqualToString:@"R"] &&
                    ![partTypeName isEqualToString:@"S"] &&
                    ![partTypeName isEqualToString:@"U"]
                    ) {
                    //U-E N/A
                    // E도 UNIT의 상위가 될 수 있음
                    isError = YES;
                }
            }
            if (isError){
                NSDictionary* partNameDic = [Util udObjectForKey:MAP_PART_NAME];
                NSString* message = [NSString stringWithFormat:@"'%@'의 상위바코드로 '%@'을\n스캔 하실 수 없습니다.",
                                     [partNameDic objectForKey: rootPartTypeName],[partNameDic objectForKey:partTypeName]];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                txtUFacCode.text = @"";
                strUpperBarCode = @"";
                lblUpperPartType.text = @"";
                isOperationFinished = YES;
                upper_deviceID = @"";
                upper_OperOrgCode = @"";
                upper_OperOrgName = @"";
                
                [self checkOrgInheritance];
                return;
            }
        }
        
        
        // 작업관리 추가
        if (txtUFacCode.text.length){
            NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
            [taskDic setObject:@"U" forKey:@"TASK"];
            [taskDic setObject:txtUFacCode.text forKey:@"VALUE"];
            [taskList addObject:taskDic];
        }
    }
    [self performSelectorOnMainThread:@selector(fccBecameFirstResponder) withObject:nil waitUntilDone:NO];
    isOperationFinished = YES;
}

// 납품취소시 유효성 검증한다.
// 각 설비 바코드 개별에 대해 성공과 실패 여부에 따라 카운트해주고, 메시지 뿌려준다.
- (void)processStatusCheckResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        successCount = 0;
        failCount = 0;
        
        for (NSDictionary* dic in resultList)
        {
            NSString* result = [dic objectForKey:@"RSLT"];
            NSString* mesg = [dic objectForKey:@"MESG"];
            NSString* barcode = [dic objectForKey:@"BARCODE"];
            int index = [WorkUtil getBarcodeIndex:barcode fccList:originalSAPList];
            if (index != -1){
                NSMutableDictionary* processDic = [originalSAPList objectAtIndex:index];
                if ([result isEqualToString:@"S"]){
                    [processDic setObject:@"유효성 검증 성공" forKey:@"MESG"];
                    successCount++;
                }
                else{
                    failCount++;
                    [processDic setObject:mesg forKey:@"MESG"];
                    [processDic setObject:result forKey:@"RSLT"];
                }
            }
        }
        
        // fccSAPList를 만들고, 화면에 반영하지 않음
        [self reloadTableWithRefresh:NO];
        nSelectedRow = fccSAPList.count - 1;
        [_tableView reloadData];
        [self showCount];
        [self scrollToIndex:nSelectedRow];
        
        // 유효하지 않은 설비가 하나라도 있다면 오류처리하고 전송하지 않는다.
        // 모두 유효하다면 전송한다.
        if (failCount > 0){
            NSString* message = @"변경하려는 설비(하위 포함)의 상태가\n처리 불가능한 값을 포함하고 있습니다.\n처리 불가능한 사유는\n각 행의 우측 끝에서 보실 수 있습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        else { //전송
            [self requestSend];
        }
    }
}

// 송부취소, 접수(팀간)인 경우 이동중인 설비의 리스트를 처리한다.
- (void)processMoveSearchResponse:(NSArray*)resultList
{
    if (resultList.count){
        //        NSLog(@"move list [%@]",resultList);
        
        // SAP에서 이동중이 아닌 설비는 status = 2(경고)로 줘야 하는데,
        // 이동중인 설비가 아닌 경우가 정상 처리되어 넘어올 때가 있다.
        // 이를 처리하기 위한 루틴이다.
        if (!isFirstMove){
            NSDictionary* firstDic = [resultList objectAtIndex:0];
            NSString* firstBarcode = [firstDic objectForKey:@"BARCODE"];
            NSString* firstStatus = [WorkUtil getFacilityStatusName:[firstDic objectForKey:@"NZPSTATU"]];
            if (![firstStatus isEqualToString:@"이동중"]){
                NSString* message = [NSString stringWithFormat:@"'%@'는\n이동 중인 설비가 아닙니다.\n확인 후 처리하시기 바랍니다.", firstBarcode];
                [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
                isOperationFinished = YES;
                return;
            }
        }
        
        // 조직변경 여부 체크
        isOrgChanged = NO;
        //        [self processCheckOrganization:[resultList objectAtIndex:0]];
        //        if (isOrgChanged_Quit) return;      // 폐지조직일 경우 처리하시겠습니까? NO 선택하면 그냥 빠져나가기 - 류성호 2014.02.25
        
        // originalSAPList가 비어있는 경우 - 최초추가인 경우는 isEmptyList = YES else NO
        BOOL isEmptyList = YES;
        if (originalSAPList.count)
            isEmptyList = NO;
        
        // 서버에서 넘어온 리스트가 중복이 되어서 넘어오는 경우가 있다.
        // 중복된 데이타를 삭제해주기 위해 distinct BARCODE 리스트를 먼저 얻어와서 처리한다.
        NSMutableArray* distinctArray = [resultList mutableCopy];
        for(NSInteger index=resultList.count-1; index >= 0; index--){
            NSDictionary* dic = [resultList objectAtIndex:index];
            for(NSInteger subIndex=index-1; subIndex >= 0;subIndex--){
                NSDictionary* subDic = [resultList objectAtIndex:subIndex];
                
                if ([[dic objectForKey:@"BARCODE"] isEqualToString:[subDic objectForKey:@"BARCODE"]]){
                    [distinctArray removeObject:subDic];
                    break;
                }
            }
        }
        
        BOOL isFirstScan = YES;
        for(NSDictionary* dic in distinctArray){
            NSString* deviceStatus = [WorkUtil getFacilityStatusName:[dic objectForKey:@"NZPSTATU"]];
            NSString* barcode = [dic objectForKey:@"BARCODE"];
            
            if (![deviceStatus isEqualToString:@"이동중"]) continue;
            
            if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]) {
                if ([[dic objectForKey:@"SLOSS"] isEqualToString:@"X"]) continue;
                // sap에서 안 넘겨줌....
                //NSString* rkostl = [dic objectForKey:@"RKOSTL"];
                //if (![rkostl isEqualToString:strUserOrgCode]) continue;
            }
            
            NSMutableDictionary* moveDic = [NSMutableDictionary dictionary];
            [moveDic setObject:[dic objectForKey:@"TRANSNO"]       forKey:@"TRANSNO"];
            [moveDic setObject:[dic objectForKey:@"EXBARCODE"]     forKey:@"HEQUNR"];
            [moveDic setObject:[dic objectForKey:@"BARCODE"]       forKey:@"EQUNR"];
            [moveDic setObject:[dic objectForKey:@"MAKTX"]         forKey:@"MAKTX"];
            [moveDic setObject:[dic objectForKey:@"DEVICEID"]      forKey:@"DEVICEID"];
            [moveDic setObject:[dic objectForKey:@"DEVTYPE"]       forKey:@"DEVTYPE"];
            [moveDic setObject:[dic objectForKey:@"PARTTYPE"]      forKey:@"PARTTYPE"];
            [moveDic setObject:[dic objectForKey:@"NZPSTATU"]      forKey:@"NZPSTATU"];
            [moveDic setObject:[dic objectForKey:@"EXDEVICEID"]    forKey:@"ZEQUIPGC"];
            [moveDic setObject:[dic objectForKey:@"ITEMNO"]        forKey:@"ITEMNO"];
            [moveDic setObject:[dic objectForKey:@"EXZKOSTL"]      forKey:@"EXZKOSTL"];
            [moveDic setObject:[dic objectForKey:@"EXZKOSTLTXT"]   forKey:@"EXZKOSTLTXT"];
            [moveDic setObject:[dic objectForKey:@"LEVEL"]         forKey:@"LEVEL"];
            
            if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
                [moveDic setObject:[dic objectForKey:@"SKOSTL"]        forKey:@"SKOSTL"];
                [moveDic setObject:[dic objectForKey:@"SKOSTLTXT"]     forKey:@"SKOSTLTXT"];
            }
            
            NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"PARTTYPE"] device:[dic objectForKey:@"DEVTYPE"]];
            
            //새롭게 만들어준 키값
            if ([partTypeName length])
                [moveDic setObject:partTypeName forKey:@"PART_NAME"];
            else
                [moveDic setObject:@"" forKey:@"PART_NAME"];
            
            // 최상위 1개 바코드만 조직체크
            /* 1.송부조직이 달라도 스캔할 경우 송부중 설비라면 표시.
             2.송부조직이 폐지조직인 경우 송부조직이 폐지조직임을 알리고 전송시 처리자 조직으로 변경여부 팝업문의
             3. Y- 처리자 조직으로 변경 N - 전송안함
             */
            
            //조직체크 추가
            NSString* orgCode = [dic objectForKey:@"EXZKOSTL"];
            NSString* orgName = [dic objectForKey:@"EXZKOSTLTXT"];
            NSString* checkOrgValue = nil;
            
            if (isOrgChanged) //운용 조직변경한 경우
                checkOrgValue = [NSString stringWithFormat:@"Y_%@_%@",orgCode,orgName];
            else
                checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
            [moveDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
            
            
            [moveDic setValue:[NSString stringWithFormat:@"%d", SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [WorkUtil makeHierarchyOfAddedData:moveDic selRow:&nSelectedRow isMakeHierachy:YES isCheckUU:btnUU.selected isRemake:isFirstScan fccList:originalSAPList job:JOB_GUBUN];
            
            if (isEmptyList){
                if (![barcode isEqualToString:strMoveBarCode])
                    [moveDic setObject:@"0" forKey:@"SCANTYPE"]; //하위 설비
                else
                    [moveDic setObject:@"1" forKey:@"SCANTYPE"]; //상위 설비
            }else{
                //상위 바코드가 있는지 체크 없으면 3, 하위 설비면 1
                NSString* upperBarcode = [moveDic objectForKey:@"HEQUNR"];
                if (upperBarcode.length)
                    [moveDic setObject:@"1" forKey:@"SCANTYPE"]; //불러온 하위 설비
                else
                    [moveDic setObject:@"3" forKey:@"SCANTYPE"]; //추가된 상위 설비
            }
            
            isFirstScan = NO;
            
            if (isFirst)
                isFirst = NO;
            
            //            nSelectedRow = -1;
            // fccSAPList를 만들고, 화면도 반영
            [self reloadTableWithRefresh:YES];
            [self scrollToIndex:nSelectedRow];
        }
        
        // 이미 처리했다면 비어있는 상태가 아니므로 NO로 설정
        isEmptyList = NO;
        
        // 작업관리
        NSMutableDictionary* taskDic = [NSMutableDictionary dictionary];
        [taskDic setObject:@"M" forKey:@"TASK"];
        if (isFirstMove){
            [taskDic setObject:@"Y" forKey:@"IS_FIRST_MOVE"];
            [taskDic setObject:@"" forKey:@"VALUE"];
        }
        else{
            [taskDic setObject:@"N" forKey:@"IS_FIRST_MOVE"];
            [taskDic setObject:strMoveBarCode forKey:@"VALUE"];
        }
        [taskList addObject:taskDic];
    }
    [self showCount];
    [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
    [_tableView reloadData];
    
    // 초기 화면 데이타 로드가 아닌 경우라면 수정된것으로 처리
    if (!isFirstMove)
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
    isDataSaved = NO;
    
    isOperationFinished = YES;
}

- (void)processSearchOrgResponse:(NSArray*)resultList
{
    if(resultList.count){
        NSMutableArray* orgList = [NSMutableArray array];
        if(resultList.count){
            
            NSMutableDictionary* orgDic = [NSMutableDictionary dictionary];
            for (NSDictionary* dic in resultList){
                NSString* orgCode = [dic objectForKey:@"orgCode"];
                
                NSArray* filterArray = [orgCode componentsSeparatedByString:@"@"];
                
                if ([filterArray count]){
                    [orgDic setObject:[filterArray objectAtIndex:0] forKey:@"orgCode"];
                    [orgDic setObject:[dic objectForKey:@"orgName"] forKey:@"orgName"];
                    [orgDic setObject:[dic objectForKey:@"parentOrgCode"] forKey:@"parentOrgCode"];
                    [orgDic setObject:[dic objectForKey:@"costCenter"] forKey:@"costCenter"];
                    [orgDic setObject:[dic objectForKey:@"orgLevel"] forKey:@"orgLevel"];
                    [orgList addObject:orgDic];
                }
                
            }
            //조직도 userDefault에 저장
            [Util udSetObject:orgList forKey:LIST_ORG];
        }
    }
}

// 전송결과 처리
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
        if ([JOB_GUBUN isEqualToString:@"납품입고"] ||
            [JOB_GUBUN isEqualToString:@"납품취소"]
            )
        {
            for (NSDictionary* dic in resultList)
            {
                NSString* barcode = [dic objectForKey:@"EXBARCODE"];
                NSString* result = [dic objectForKey:@"RSLT"];
                if ([result isEqualToString:@"S"]){
                    successCount++;
                    continue;
                }
                else{
                    int index = [WorkUtil getBarcodeIndex:barcode fccList:originalSAPList];
                    if (index != -1){
                        NSMutableDictionary* failDic = [originalSAPList objectAtIndex:index];
                        [failDic setObject:[dic objectForKey:@"MESG"] forKey:@"MESG"];
                        [failDic setObject:@"F" forKey:@"RSLT"];
                        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
            
            NSDictionary* dic = [resultList objectAtIndex:0];
            NSString* result_msg = [dic objectForKey:@"MESG"];
            
            // 전송 후 작업관리 추가
            [workDic setObject:@"S" forKey:@"TRANSACT_YN"];
            if (result_msg.length)
                [workDic setObject:result_msg forKey:@"TRANSACT_MSG"];
            [self saveToWorkDB];
            isDataSaved = YES;
            
            NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n# 성공건수 : %d건\n# 실패건수 : %d건",(int)[resultList count],(int)successCount,(int)[resultList count] - (int)successCount];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            
            txtFacCode.text = @"";
            strFccBarCode = @"";
            lblPartType.text = @"";
            if ((resultList.count - successCount) <= 0)
                [self touchInitBtn];
            [self performSelectorOnMainThread:@selector(layoutControl) withObject:nil waitUntilDone:NO];
        }
        else {
            NSDictionary* dic = [resultList objectAtIndex:0];
            NSString* result = [dic objectForKey:@"E_RSLT"];
            NSString* result_msg = [dic objectForKey:@"E_MESG"];
            
            // 전송 후 작업관리 추가
            [workDic setObject:result forKey:@"TRANSACT_YN"];
            if (result_msg.length)
                [workDic setObject:result_msg forKey:@"TRANSACT_MSG"];
            [self saveToWorkDB];
            isDataSaved = YES;
            
            if ([result isEqualToString:@"S"]){
                NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n\n%d-%@",(int)sendCount,(int)statusCode,[dic objectForKey:@"E_MESG"]];
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                
                // 고장등록의 경우 전송후 고장설비 사진을 서버로 업로드한다.(QA서버접속시에만)
                if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
                    [JOB_GUBUN isEqualToString:@"고장등록"]){
                    
                    [self sendImageToServer];
                }
                // 화면을 초기화한다.
                else{
                    [self touchInitBtn];
                }
            }
        }
    }
}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message Status:(NSInteger)status
{
    // 위치바코드 요청 실패시에는 위치정보표시부분을 초기화 해준다.
    if (pid == REQUEST_LOC_COD)
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:@""];
    
    if (pid == REQUEST_LOC_COD || pid == REQUEST_OTD || pid == REQUEST_WBS){
        [self performSelectorOnMainThread:@selector(locBecameFirstResponder) withObject:nil waitUntilDone:NO];
    }
    // 장치바코드 요청 실패 시에는 장치정보 표시부분 초기화
    else if (pid == REQUEST_MULTI_INFO){
        [Util setScrollTouch:scrollDeviceInfo Label:lblDeviceInfo withString:@""];
        if ([JOB_GUBUN isEqualToString:@"실장"])
            txtDeviceID.text = strDeviceID = @"";
        if (![txtDeviceID isFirstResponder])
            [txtDeviceID becomeFirstResponder];
    }
    // 설비바코드 요청 실패
    else if (pid == REQUEST_SAP_FCC_COD){
        if (!txtLocCode.text.length){
            if (![txtLocCode isFirstResponder])
                [txtLocCode becomeFirstResponder];
        }
        else{
            if (![txtFacCode isFirstResponder])
                [txtFacCode becomeFirstResponder];
        }
    }
    // 상위 바코드 요청실패
    else if (pid == REQUEST_UPPER_SAP_FCC_COD){
        if (![txtUFacCode isFirstResponder])
            [txtUFacCode becomeFirstResponder];
    }
    // 고장등록 이미지 업로드 요청 실패
    else if (pid == REQUEST_FAULT_IMAGE_UPLOAD){
        isUploadOneImageFinished = YES;
    }
    
    if ([message length] ){
        if (status == 2 && strMoveBarCode != nil && ![strMoveBarCode isEqualToString:@""]){
            if (pid == REQUEST_MOVE_SEARCH || pid == REQUEST_SAP_FCC_COD){
                if ([JOB_GUBUN isEqualToString:@"송부취소(팀간)"]){
                    message = [NSString stringWithFormat:@"'%@' 는\n이동 중인 설비가 아닙니다.\n확인 후 처리하시기 바랍니다.",strMoveBarCode];
                }else{
                    message = @"존재하지 않는 설비바코드입니다.";
                }
            }
            else if ([message hasPrefix:@"시설 바코드가 없습니다."]){
                message = @"존재하지 않는 설비바코드입니다.";
            }
        }
        
        if (message.length){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
    }
    
    isOperationFinished = YES;
}

- (void) processEndSession:(requestOfKind)pid
{
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
    
    isOperationFinished = YES;
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    if ([JOB_GUBUN isEqualToString:@"고장등록"]){
        if(![lblFccStatus.text hasPrefix:@"선택하세요"])
            lblFccStatus.text = selectedPickerData;
    }else
        lblFccStatus.text = selectedPickerData;
    
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [picker hideView];
    [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
}

// 피커뷰에서 항목을 선택했을 때...
- (void)onDone:(NSString *)data sender:(id)sender {
    lblFccStatus.textColor = [UIColor blackColor];
    selectedPickerData = data;
    lblFccStatus.text = data;
    
    //데이터 변경
    [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
    isDataSaved = NO;
    
    //작업데이터 저장
    [workDic setObject:[NSString stringWithFormat:@"%d",picker.selectedIndex] forKey:@"PICKER_ROW"];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [picker hideView];
    [self performSelectorOnMainThread:@selector(setBecameResponder) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    if (picker.isShow)
        [picker hideView];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    if (![Util udBoolForKey:IS_ALERT_COMPLETE]){
        NSLog(@"textFieldShouldBeginEditing==================");
        return NO;
    }
    
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
    if(![JOB_GUBUN isEqualToString:@"고장수리이력"] && ![JOB_GUBUN isEqualToString:@"고장정보"]){
        return [fccSAPList count];
    }else{
        //        [self.view endEditing:YES];
        return [repairHistory count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![JOB_GUBUN isEqualToString:@"고장수리이력"] && ![JOB_GUBUN isEqualToString:@"고장정보"]){
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
        
        NSString* scanType = @"";
        NSString* partTypeName = @"";
        NSString* formatString = @"";
        NSString* barcode = @"";
        NSString* status = @"";
        NSString* barcodeName = @"";
        NSString* devTypeName = @"";
        NSString* deviceID = @"";
        NSString* parentBarcode = @"";
        NSString* checkOrgValue = @"";
        NSString* result = @"";
        
        if (
            [JOB_GUBUN isEqualToString:@"송부취소(팀간)"] ||
            [JOB_GUBUN isEqualToString:@"접수(팀간)"]
            ){
            NSString* docNo = [dic objectForKey:@"TRANSNO"];
            NSString* barcode = [dic objectForKey:@"EQUNR"];
            NSString* barcodeName = [dic objectForKey:@"MAKTX"];
            partTypeName = [dic objectForKey:@"PART_NAME"];
            NSString* devTypeName = [WorkUtil getDeviceTypeName:[dic objectForKey:@"DEVTYPE"]];
            NSString* devStatus = [WorkUtil getFacilityStatusName:[dic objectForKey:@"NZPSTATU"]];
            NSString* deviceID = [dic objectForKey:@"ZEQUIPGC"];
            NSString* itemNO = [dic objectForKey:@"ITEMNO"];
            NSString* checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
            scanType = [dic objectForKey:@"SCANTYPE"];
            
            formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,devStatus,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,docNo,itemNO];
        }
        else if ([JOB_GUBUN isEqualToString:@"배송출고"]){
            if ([fccSAPList count]){
                
                partTypeName = [dic objectForKey:@"PART_NAME"];
                barcode = [dic objectForKey:@"EQUNR"];
                status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
                barcodeName = [dic objectForKey:@"MAKTX"];
                barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
                devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]]; //디바이스코드(ZPGUBUN)
                deviceID = [dic objectForKey:@"ZEQUIPGC"];
                scanType = [dic objectForKey:@"SCANTYPE"];
                
                parentBarcode = [dic objectForKey:@"HEQUNR"];
                checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
                formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,parentBarcode,@"",@""];
            }
        }
        else {
            if ([fccSAPList count]){
                
                partTypeName = [dic objectForKey:@"PART_NAME"];
                barcode = [dic objectForKey:@"EQUNR"];
                status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
                barcodeName = [dic objectForKey:@"MAKTX"];
                barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
                
                if ([JOB_GUBUN isEqualToString:@"납품입고"]){
                    devTypeName = [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZMATGB"]];
                    deviceID = @"";
                }
                else{
                    devTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]]; //디바이스코드(ZPGUBUN)
                    deviceID = [dic objectForKey:@"ZEQUIPGC"];
                }
                
                NSString* resultMsg = @"";
                if ([JOB_GUBUN isEqualToString:@"납품입고"] ||
                    [JOB_GUBUN isEqualToString:@"납품취소"]){
                    parentBarcode = @"";
                    result = [dic objectForKey:@"RSLT"];
                    
                    if (result.length){
                        resultMsg = [dic objectForKey:@"MESG"];
                    }
                    else
                        result = @"";
                }
                else
                    parentBarcode = [dic objectForKey:@"HEQUNR"];
                
                scanType = [dic objectForKey:@"SCANTYPE"];
                
                NSString* wbsNo = @""; //작업구분이 시설등록일때만 존재한다.
                NSString* assetNo = @""; //자산번호
                
                checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
                
                if ([JOB_GUBUN isEqualToString:@"설비정보"])
                    formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,wbsNo];
                else if ([JOB_GUBUN isEqualToString:@"납품입고"])
                    formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,@"",resultMsg];
                else if ([JOB_GUBUN isEqualToString:@"납품취소"])
                    formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,@"",result, resultMsg];
                else
                    formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,devTypeName,deviceID,scanType,checkOrgValue,parentBarcode,wbsNo,assetNo];
            }
        }
        
        // 설비의 상하 관계에 따라 LEVEL별 들여쓰기
        if ([[dic objectForKey:@"LEVEL"] length])
            cell.indentationLevel = [[dic objectForKey:@"LEVEL"] integerValue];
        else
            cell.indentationLevel = 1;
        
        [cell setIndentationWidth:15.0f];
        
        // 각 셀이 스크롤되도록 한다.
        CGFloat textLength = [formatString sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
        
        cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength+cell.indentationLevel*cell.indentationWidth, cell.lblTreeData.frame.size.height);
        cell.lblTreeData.text = formatString;
        cell.scrollView.contentSize = CGSizeMake(textLength+cell.indentationLevel*cell.indentationWidth + 30, cell.scrollView.frame.size.height);
        
        cell.nScanType = [scanType integerValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 선택된 셀을 파란색으로 표시
        if (nSelectedRow == indexPath.row){
            cell.lblTreeData.textColor = [UIColor blueColor];
            lblPartType.text = [dic objectForKey:@"PART_NAME"];
        }
        // 선택된 셀이 아닌 경우에는 검정색으로 표시
        else
            cell.lblTreeData.textColor = [UIColor blackColor];
        
        // 스캔한 경우("1", "2", "3") 셀의 배경색을 그린으로 표시
        if ([scanType isEqualToString:@"1"] || [scanType isEqualToString:@"2"] || [scanType isEqualToString:@"3"])
            cell.lblBackground.backgroundColor = COLOR_SCAN1;
        
        // 오류가 있는 경우 분홍색으로 표시
        if ([result isEqualToString:@"F"] || [result isEqualToString:@"E"])
            cell.lblBackground.backgroundColor = RGB(255,182,193); //pinkcolor
        
        // 오류가 없는 경우에는 그린으로 표시
        else if ([result isEqualToString:@"S"])
            cell.lblBackground.backgroundColor = COLOR_SCAN1;
        
        // tree 구조에서 child를 확장, 비확장 관련 설정(버튼 등...)
        cell.hasSubNode = YES;
        // 하위에 child설비가 없는 경우
        if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_NO_CATEGORIES){
            cell.btnTree.hidden = YES;
            cell.hasSubNode = NO;
        }
        // 하위에 child설비가 있지만, 확장되지 않은 경우 (+)로표시
        else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_NO_EXPOSE){
            cell.btnTree.hidden = NO;
            cell.btnTree.tag = indexPath.row;
            [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        // 하위에 child설비가 있고, 확장된 경우 (-)로 표시
        else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_EXPOSED){
            cell.btnTree.hidden = NO;
            cell.btnTree.tag = indexPath.row;
            [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    else{
        if ([repairHistory count]){
            NSDictionary* dic = [repairHistory objectAtIndex:indexPath.row];
            GridColumnRepairCell *cell = (GridColumnRepairCell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumnRepairCell"];
            
            if(txtFacCode.text.length > 0){
                clv1.hidden = NO; clv2.hidden = YES;
                //_tableView2.frame = CGRectMake(_tableView2.frame.origin.x, _tableView2.frame.origin.y, 820, _tableView2.frame.size.height);
                //table2Header.frame = CGRectMake(table2Header.frame.origin.x, table2Header.frame.origin.y, 820, table2Header.frame.size.height);
            }
            else{
                clv1.hidden = YES; clv2.hidden = NO;
                //_tableView2.frame = CGRectMake(_tableView2.frame.origin.x, _tableView2.frame.origin.y, 1134, _tableView2.frame.size.height);
                //table2Header.frame = CGRectMake(table2Header.frame.origin.x, table2Header.frame.origin.y, 1134, table2Header.frame.size.height);
            }
            
            //_scrollView.contentSize = CGSizeMake(_tableView2.bounds.size.width, _scrollView.frame.size.height);
            
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumnRepairCell" owner:self options:nil];
                float scale = (float)self.view.frame.size.width / 320.0f;
                float width = self.view.frame.size.width;
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridColumnRepairCell class]])
                    {
                        cell = object;
                        if(txtFacCode.text.length > 0){
                            cell.lblColumn1.frame = CGRectMake(4, 0, width / 3.0f, 40);
                            cell.lblColumn2.frame = CGRectMake(4 + width / 3.0f, 0, width / 3.0f, 40);
                            cell.lblColumn3.frame = CGRectMake(4 + width * 2.0f / 3.0f, 0, width / 3.0f, 40);
                            cell.lblColumn4.frame = CGRectMake(4 + width, 0, width / 2.0f, 40);
                            cell.lblColumn5.frame = CGRectMake(4 + width * 1.5f, 0, width / 2.0f, 40);
                            cell.lblColumn6.frame = CGRectMake(4 + width * 2.0f, 0, width / 2.0f, 40);
                        }else{
                            cell.lblColumna.frame = CGRectMake(4, 0, 160, 40);
                            cell.lblColumnb.frame = CGRectMake(164, 0, 110, 40);
                            cell.lblColumn1.frame = CGRectMake(274, 0, 160, 40);
                            cell.lblColumn2.frame = CGRectMake(434, 0, 110, 40);
                            cell.lblColumn3.frame = CGRectMake(544, 0, 110, 40);
                            cell.lblColumn4.frame = CGRectMake(654, 0, 160, 40);
                            cell.lblColumn5.frame = CGRectMake(814, 0, 160, 40);
                            cell.lblColumn6.frame = CGRectMake(974, 0, 160, 40);
                        }
                        break;
                    }
                }
            }
            
            if(txtFacCode.text.length > 0){
                cell.lblColumn1.text = [dic objectForKey:@"ZEQUIPGC"];
                cell.lblColumn2.text = [dic objectForKey:@"ERDAT"];
                cell.lblColumn3.text = [dic objectForKey:@"AUSBS"];
                cell.lblColumn4.text = [dic objectForKey:@"FECODN"];
                cell.lblColumn5.text = [dic objectForKey:@"URSTX2"];
                cell.lblColumn6.text = [dic objectForKey:@"LIFNRN"];
            }else{
                cell.lblColumna.text = [dic objectForKey:@"EQUNR"];
                cell.lblColumnb.text = [dic objectForKey:@"MATNR"];
                cell.lblColumn1.text = [dic objectForKey:@"MAKTX"];
                cell.lblColumn2.text = [dic objectForKey:@"ERDAT"];
                cell.lblColumn3.text = [dic objectForKey:@"AUSBS"];
                cell.lblColumn4.text = [dic objectForKey:@"FECODN"];
                cell.lblColumn5.text = [dic objectForKey:@"URSTX2"];
                cell.lblColumn6.text = [dic objectForKey:@"LIFNRN"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        return;
    }
    
    CommonCell* cell =(CommonCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([JOB_GUBUN isEqualToString:@"고장수리이력"]){
        return;
    }
    
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blueColor];
    
    // 이동하려고 하는 경우(isMove == YES)인 경우에는 현재 선택한 셀 하위로 이동하겠다는 의미임.
    if(isMove){
        NSDictionary* objectDic = [fccSAPList objectAtIndex:nSelectedRow];
        NSDictionary* objectInFullDic = [WorkUtil getItemFromFccList:[objectDic objectForKey:@"EQUNR"] fccList:originalSAPList];
        
        nSelectedRow = indexPath.row;
        NSDictionary* targetDic = [fccSAPList objectAtIndex:nSelectedRow];
        NSDictionary* targetInFullDic = [WorkUtil getItemFromFccList:[targetDic objectForKey:@"EQUNR"] fccList:originalSAPList];
        
        objc_setAssociatedObject(fccSAPList, &moveObjKey, objectInFullDic, OBJC_ASSOCIATION_COPY);
        objc_setAssociatedObject(fccSAPList, &moveTarKey, targetInFullDic, OBJC_ASSOCIATION_COPY);
        
        
        NSString* message = [NSString stringWithFormat:@"'%@:%@'의 하위로 이동하시겠습니까?",
                             [targetDic objectForKey:@"PART_NAME"],
                             [targetDic objectForKey:@"EQUNR"]];
        [self showMessage:message tag:1000 title1:@"예" title2:@"아니오"];
        return;
    }
    
    // 이동인 아닌 경우는 단순 선택이므로, 이에 해당하는 작업을 한다.
    // 선택된 셀의 설비 바코드를 txtFacCode에 설정하고, lblPartType에 해당 설비의 종류명을 설정한다.
    if (fccSAPList.count){
        NSDictionary* selItemDic = [fccSAPList objectAtIndex:indexPath.row];
        if (strFccBarCode.length)
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
        else
            txtFacCode.text = [selItemDic objectForKey:@"EQUNR"];
        
        lblPartType.text = [selItemDic objectForKey:@"PART_NAME"];
        
        // 고장등록인 경우에는 선택한 설비에 대한 사진이 설정되어 있다면 그 사진을 표시하도록 한다.
        if([JOB_GUBUN isEqualToString:@"고장등록"] && [selItemDic objectForKey:@"PICTURE"] != nil){
            UIImage* picture = [selItemDic objectForKey:@"PICTURE"];
            [btnPicture setBackgroundImage:picture forState:UIControlStateNormal];
        }
    }
    
    // 선택된 셀임을 설정한다.
    nSelectedRow = indexPath.row;
    [_tableView reloadData];
    
    if ([JOB_GUBUN isEqualToString:@"납품취소"])
        strFccBarCode = txtFacCode.text;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [txtFacCode becomeFirstResponder];
}

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

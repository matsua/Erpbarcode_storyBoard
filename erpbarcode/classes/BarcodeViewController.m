//
//  BarcodeViewController.m
//  erpbarcode
//
//  Created by matsua on 2015. 6. 29..
//  Copyright (c) 2015년 ktds. All rights reserved.
//
#import "BarcodeViewController.h"
#import "ERPAlert.h"
#import "AppDelegate.h"

#import "BarcodePrintController.h"

#import "ERPRequestManager.h"
#import "CustomPickerView.h"
#import "DatePickerViewController.h"
#import "OrgSearchViewController.h"

#import "IMListCell.h"
#import "LocListCell.h"
#import "DeviceListCell.h"
#import "SourceMarkingListCell.h"
#import "CancelRsViewController.h"
#import "PrintSettingViewController.h"

@interface BarcodeViewController ()

@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) IBOutlet UIView* orgView;
@property(nonatomic,strong) IBOutlet UIView* instoreView;
@property(nonatomic,strong) IBOutlet UIView* srcmkView;
@property(nonatomic,strong) IBOutlet UIView* chBarcodeReqView;
@property(nonatomic,strong) IBOutlet UIView* chBarcodecomView;
@property(nonatomic,strong) IBOutlet UIView* chBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* divBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* locBarcodeView;
@property(nonatomic,strong) IBOutlet UIView* printerSetView;
@property(nonatomic,strong) IBOutlet UIView* buttonView;

@property(nonatomic,strong) IBOutlet UIView* instoreListView;
@property(nonatomic,strong) IBOutlet UIView* srcmkListView;
@property(nonatomic,strong) IBOutlet UIView* chBarcodecomListView;
@property(nonatomic,strong) IBOutlet UIView* chBarcodeListView;
@property(nonatomic,strong) IBOutlet UIView* divBarcodeListView;
@property(nonatomic,strong) IBOutlet UIView* locBarcodeListView;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property(nonatomic,strong) NSString* strUserOrgCode;
@property(nonatomic,strong) NSString* strUserOrgName;
@property(nonatomic,strong) IBOutlet UILabel* lblOrperationInfo;

@property(nonatomic,strong) IBOutlet UITextField *instoreNewCode;
@property(nonatomic,strong) IBOutlet UITextField *instoreInjCode;
@property(nonatomic,strong) IBOutlet UIScrollView* ins_scrollView;
@property(nonatomic,strong) IBOutlet UIView* ins_columnHeaderView;
@property(nonatomic,strong) IBOutlet UIView* loc_columnHeaderView;
@property(nonatomic,strong) IBOutlet UIView* smk_columnHeaderView;
@property(nonatomic,strong) IBOutlet UIView* dvc_columnHeaderView;
@property(nonatomic,strong) IBOutlet UITableView* ins_tableView;

@property(nonatomic,strong) IBOutlet UILabel* lblProgression;
@property(nonatomic,strong) IBOutlet UILabel* lblRequestReason;
@property(nonatomic,strong) IBOutlet UILabel* lblLabelTp;
@property(nonatomic,strong) IBOutlet UILabel* lblReqStartDate;
@property(nonatomic,strong) IBOutlet UILabel* lblReqEndDate;
@property(nonatomic,strong) CustomPickerView* ProgressionPicker;
@property(nonatomic,strong) CustomPickerView* RequestReasonPicker;
@property(nonatomic,strong) CustomPickerView* LabelTpPicker;

@property(nonatomic,strong) DatePickerViewController* StartDatePicker;
@property(nonatomic,strong) DatePickerViewController* EndDatePicker;

@property(nonatomic,strong) NSString* selectedProgressionPickerData;
@property(nonatomic,strong) NSString* selectedRequestReasonPickerData;
@property(nonatomic,strong) NSString* selectedLabelTpPickerData;
@property(nonatomic,strong) NSString* selectedStartDatePickerData;
@property(nonatomic,strong) NSString* selectedEndDatePickerData;

@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) BOOL isOffLine;
@property(nonatomic,strong) NSDictionary* receivedOrgDic;

@property(nonatomic,strong) NSMutableArray* stResultList;
@property(nonatomic,strong) NSMutableArray* ltResultList;
@property(nonatomic,strong) NSMutableArray* pwResultList;
@property(nonatomic,strong) NSMutableArray* insResultList;
@property(nonatomic,strong) NSMutableArray* oriResultList;
@property(nonatomic,strong) NSMutableArray* insSendDataList;

@property(nonatomic,strong) NSString* stKey;
@property(nonatomic,strong) NSString* ltKey;
@property(nonatomic,strong) NSString* pwKey;
@property(nonatomic,strong) NSString* cancelRsKey;
@property(nonatomic,strong) NSString* cancelRsDetail;

@property(assign, nonatomic)int dateType;
@property(assign, nonatomic) BOOL allCheck;

@property(nonatomic,strong) IBOutlet UIButton *searchBtn;
@property(nonatomic,strong) IBOutlet UIButton *printTestBtn;
@property(nonatomic,strong) IBOutlet UIButton *printBtn;
@property(nonatomic,strong) IBOutlet UIButton *requestBtn;
@property(nonatomic,strong) IBOutlet UIButton *generateBtn;
@property(nonatomic,strong) IBOutlet UIButton *republishBtn;

@property(nonatomic,strong) IBOutlet UILabel* lblSido;
@property(nonatomic,strong) IBOutlet UILabel* lblSigoon;
@property(nonatomic,strong) IBOutlet UILabel* lblDong;
@property(nonatomic,strong) CustomPickerView* SidoPicker;
@property(nonatomic,strong) CustomPickerView* SigoonPicker;
@property(nonatomic,strong) CustomPickerView* DongPicker;

@property(nonatomic,strong) NSMutableArray* sdResultList;
@property(nonatomic,strong) NSMutableArray* sgResultList;
@property(nonatomic,strong) NSMutableArray* doResultList;

@property(nonatomic,strong) NSString* selectedSidoPickerData;
@property(nonatomic,strong) NSString* selectedSigoonPickerData;
@property(nonatomic,strong) NSString* selectedDongPickerData;

@property(nonatomic,strong) NSString* sdKey;
@property(nonatomic,strong) NSString* sgKey;

@property(nonatomic,strong) IBOutlet UITextField *dongItf;
@property(nonatomic,strong) IBOutlet UITextField *locCdItf;
@property(nonatomic,strong) IBOutlet UITextField *bunjiItf;
@property(nonatomic,strong) IBOutlet UITextField *hoItf;

@property(nonatomic,strong) IBOutlet UIButton *dongSelectBtn;

@property(nonatomic,strong) IBOutlet UITextField *purchaseNo;
@property(nonatomic,strong) IBOutlet UITextField *purchaseLineNo;
@property(nonatomic,strong) IBOutlet UITextField *barcodeFrom;
@property(nonatomic,strong) IBOutlet UITextField *barcodeTo;

@property(nonatomic,strong) IBOutlet UITextField *deviceId;
@property(nonatomic,strong) IBOutlet UITextField *operationSystemCode;
@property(nonatomic,strong) IBOutlet UITextField *registerUserId;

@property(nonatomic,strong) IBOutlet UILabel* printYn;
@property(nonatomic,strong) NSString* pskKey;
@property(nonatomic,strong) CustomPickerView* printYnPicker;

@property(nonatomic,strong) IBOutlet UILabel* lblStartDate;
@property(nonatomic,strong) IBOutlet UILabel* lblEndDate;

//@property(nonatomic,strong) IBOutlet UILabel *totalCount;


//@property(nonatomic,strong) NSMutableArray* ins_checkList;

@end

@implementation BarcodeViewController

@synthesize JOB_GUBUN;
@synthesize orgView;
@synthesize instoreView;
@synthesize srcmkView;
@synthesize chBarcodeReqView;
@synthesize chBarcodecomView;
@synthesize chBarcodeView;
@synthesize divBarcodeView;
@synthesize locBarcodeView;
@synthesize printerSetView;
@synthesize buttonView;

@synthesize instoreListView;
@synthesize srcmkListView;
@synthesize chBarcodecomListView;
@synthesize chBarcodeListView;
@synthesize divBarcodeListView;
@synthesize locBarcodeListView;

@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize lblOrperationInfo;

@synthesize instoreNewCode;
@synthesize instoreInjCode;
@synthesize ins_scrollView;
@synthesize ins_columnHeaderView;
@synthesize loc_columnHeaderView;
@synthesize smk_columnHeaderView;
@synthesize dvc_columnHeaderView;
@synthesize ins_tableView;

@synthesize indicatorView;
@synthesize isOperationFinished;
@synthesize isOffLine;
@synthesize receivedOrgDic;

@synthesize lblProgression;
@synthesize lblRequestReason;
@synthesize lblLabelTp;
@synthesize lblReqStartDate;
@synthesize lblReqEndDate;
@synthesize ProgressionPicker;
@synthesize RequestReasonPicker;
@synthesize LabelTpPicker;
@synthesize selectedProgressionPickerData;
@synthesize selectedRequestReasonPickerData;
@synthesize selectedLabelTpPickerData;
@synthesize StartDatePicker;
@synthesize EndDatePicker;
@synthesize dateType;

@synthesize stResultList;
@synthesize ltResultList;
@synthesize pwResultList;
@synthesize insResultList;
@synthesize oriResultList;
@synthesize insSendDataList;
@synthesize stKey;
@synthesize ltKey;
@synthesize pwKey;
@synthesize cancelRsKey;
@synthesize cancelRsDetail;
@synthesize allCheck;
//@synthesize ins_checkList;

@synthesize searchBtn;
@synthesize printTestBtn;
@synthesize printBtn;
@synthesize requestBtn;
@synthesize generateBtn;
@synthesize republishBtn;

@synthesize lblSido;
@synthesize lblSigoon;
@synthesize lblDong;

@synthesize SidoPicker;
@synthesize SigoonPicker;
@synthesize DongPicker;

@synthesize sdResultList;
@synthesize sgResultList;
@synthesize doResultList;

@synthesize selectedSidoPickerData;
@synthesize selectedSigoonPickerData;
@synthesize selectedDongPickerData;

@synthesize sdKey;
@synthesize sgKey;

@synthesize dongItf;
@synthesize locCdItf;
@synthesize bunjiItf;
@synthesize hoItf;

@synthesize dongSelectBtn;

@synthesize purchaseNo;
@synthesize purchaseLineNo;
@synthesize barcodeFrom;
@synthesize barcodeTo;

@synthesize deviceId;
@synthesize operationSystemCode;
@synthesize registerUserId;

@synthesize pskKey;
@synthesize printYnPicker;
@synthesize printYn;
@synthesize lblStartDate;
@synthesize lblEndDate;


#pragma mark - ViewLife Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBarHidden = NO;
    
     [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
     
     JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
     self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
        [self requestBcTraSt];
    }else if([JOB_GUBUN isEqualToString:@"위치바코드"]){
        [self requestSido];
    }else if ([JOB_GUBUN isEqualToString:@"소스마킹"]||[JOB_GUBUN isEqualToString:@"장치바코드"]){
        [self requestLabelTp];
    }
    
    isOffLine = [[Util udObjectForKey:USER_OFFLINE] boolValue];
    dateType = 0;
    
    [self layoutSubView];
    
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgCode"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[dic objectForKey:@"orgId"],strUserOrgName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orgDataReceived:)
                                                 name:@"spotOrgSelectedNotification"
                                               object:nil];
    
    StartDatePicker = [[DatePickerViewController alloc] init];
    CGRect dateFrameStart = CGRectMake(StartDatePicker.view.frame.origin.x, self.view.frame.size.height + 20, StartDatePicker.view.frame.size.width, StartDatePicker.view.frame.size.height);
    StartDatePicker.view.frame = dateFrameStart;
    StartDatePicker.delegate = self;
    [self.view addSubview:StartDatePicker.view];
    
    EndDatePicker = [[DatePickerViewController alloc] init];
    CGRect dateFrameEnd = CGRectMake(EndDatePicker.view.frame.origin.x, self.view.frame.size.height + 20, EndDatePicker.view.frame.size.width, EndDatePicker.view.frame.size.height);
    EndDatePicker.view.frame = dateFrameEnd;
    EndDatePicker.delegate = self;
    [self.view addSubview:EndDatePicker.view];
    
}

- (void)layoutSubView{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    instoreView.hidden = YES;
    srcmkView.hidden = YES;
    chBarcodeReqView.hidden = YES;
    chBarcodecomView.hidden = YES;
    chBarcodeView.hidden = YES;
    divBarcodeView.hidden = YES;
    locBarcodeView.hidden = YES;
    printerSetView.hidden = YES;
    buttonView.hidden = YES;
    instoreListView.hidden = YES;
    srcmkListView.hidden = YES;
    chBarcodecomListView.hidden = YES;
    chBarcodeListView.hidden = YES;
    divBarcodeListView.hidden = YES;
    locBarcodeListView.hidden = YES;
    ins_columnHeaderView.hidden = YES;
    loc_columnHeaderView.hidden = YES;
    smk_columnHeaderView.hidden = YES;
    dvc_columnHeaderView.hidden = YES;
    
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
        instoreView.hidden = NO;
        printerSetView.hidden = NO;
        printerSetView.frame = CGRectMake(printerSetView.frame.origin.x, instoreView.frame.origin.y + instoreView.frame.size.height, printerSetView.frame.size.width,printerSetView.frame.size.height);
        buttonView.hidden = NO;
        buttonView.frame = CGRectMake(buttonView.frame.origin.x, printerSetView.frame.origin.y + printerSetView.frame.size.height, buttonView.frame.size.width,buttonView.frame.size.height);
        instoreListView.hidden = NO;
        instoreListView.frame = CGRectMake(instoreListView.frame.origin.x, buttonView.frame.origin.y + buttonView.frame.size.height, instoreListView.frame.size.width,instoreListView.frame.size.height);
        
        ins_columnHeaderView.hidden = NO;
        ins_scrollView.contentSize = CGSizeMake(ins_tableView.bounds.size.width, ins_scrollView.frame.size.height);
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSTimeInterval sevenPerDay = 24 * 7 * 60 * 60;
        
        NSDate *now = [NSDate date];
        NSString *today = [format stringFromDate:now];
        
        NSDate *weekAgo = [[NSDate alloc] initWithTimeIntervalSinceNow:-sevenPerDay];
        NSString *preday = [format stringFromDate:weekAgo];
        
        lblReqStartDate.text = preday;
        lblReqEndDate.text = today;

    }else if ([JOB_GUBUN isEqualToString:@"소스마킹"]){
        smk_columnHeaderView.hidden = NO;
        srcmkView.hidden = NO;
        printerSetView.hidden = NO;
        printerSetView.frame = CGRectMake(printerSetView.frame.origin.x, srcmkView.frame.origin.y + srcmkView.frame.size.height, printerSetView.frame.size.width,printerSetView.frame.size.height);
        buttonView.hidden = NO;
        buttonView.frame = CGRectMake(buttonView.frame.origin.x, printerSetView.frame.origin.y + printerSetView.frame.size.height, buttonView.frame.size.width,buttonView.frame.size.height);
        srcmkListView.hidden = NO;
        srcmkListView.frame = CGRectMake(srcmkListView.frame.origin.x, buttonView.frame.origin.y + buttonView.frame.size.height, srcmkListView.frame.size.width,srcmkListView.frame.size.height);
        requestBtn.hidden = YES;
        generateBtn.hidden = YES;
        republishBtn.hidden = YES;
        searchBtn.frame = CGRectMake(157, searchBtn.frame.origin.y, searchBtn.frame.size.width,searchBtn.frame.size.height);
        printTestBtn.frame = CGRectMake(204, printTestBtn.frame.origin.y, printTestBtn.frame.size.width,printTestBtn.frame.size.height);
        ins_scrollView.contentSize = CGSizeMake(ins_tableView.bounds.size.width, ins_scrollView.frame.size.height);
        ins_scrollView.frame = CGRectMake(ins_scrollView.frame.origin.x, ins_scrollView.frame.origin.y - 25,ins_scrollView.frame.size.width, ins_scrollView.frame.size.height);
        pskKey = @"";
        printYn.text = @"전체";
    }else if ([JOB_GUBUN isEqualToString:@"장치바코드"]){
        dvc_columnHeaderView.hidden = NO;
        divBarcodeView.hidden = NO;
        printerSetView.hidden = NO;
        printerSetView.frame = CGRectMake(printerSetView.frame.origin.x, divBarcodeView.frame.origin.y + divBarcodeView.frame.size.height, printerSetView.frame.size.width,printerSetView.frame.size.height);
        buttonView.hidden = NO;
        buttonView.frame = CGRectMake(buttonView.frame.origin.x, printerSetView.frame.origin.y + printerSetView.frame.size.height, buttonView.frame.size.width,buttonView.frame.size.height);
        divBarcodeListView.hidden = NO;
        divBarcodeListView.frame = CGRectMake(divBarcodeListView.frame.origin.x, buttonView.frame.origin.y + buttonView.frame.size.height, divBarcodeListView.frame.size.width,divBarcodeListView.frame.size.height);
        requestBtn.hidden = YES;
        generateBtn.hidden = YES;
        republishBtn.hidden = YES;
        searchBtn.frame = CGRectMake(157, searchBtn.frame.origin.y, searchBtn.frame.size.width,searchBtn.frame.size.height);
        printTestBtn.frame = CGRectMake(204, printTestBtn.frame.origin.y, printTestBtn.frame.size.width,printTestBtn.frame.size.height);
        ins_scrollView.contentSize = CGSizeMake(ins_tableView.bounds.size.width, ins_scrollView.frame.size.height);
        ins_scrollView.frame = CGRectMake(ins_scrollView.frame.origin.x, ins_scrollView.frame.origin.y - 60,ins_scrollView.frame.size.width, ins_scrollView.frame.size.height + 50);
    }else if ([JOB_GUBUN isEqualToString:@"위치바코드"]){
        locBarcodeView.hidden = NO;
        printerSetView.hidden = NO;
        printerSetView.frame = CGRectMake(printerSetView.frame.origin.x, locBarcodeView.frame.origin.y + locBarcodeView.frame.size.height, printerSetView.frame.size.width,printerSetView.frame.size.height);
        buttonView.hidden = NO;
        buttonView.frame = CGRectMake(buttonView.frame.origin.x, printerSetView.frame.origin.y + printerSetView.frame.size.height, buttonView.frame.size.width,buttonView.frame.size.height);
        locBarcodeListView.hidden = NO;
        locBarcodeListView.frame = CGRectMake(locBarcodeListView.frame.origin.x, buttonView.frame.origin.y + buttonView.frame.size.height, locBarcodeListView.frame.size.width,locBarcodeListView.frame.size.height);
        loc_columnHeaderView.hidden = NO;
        ins_scrollView.contentSize = CGSizeMake(ins_tableView.bounds.size.width, ins_scrollView.frame.size.height);
        ins_scrollView.frame = CGRectMake(ins_scrollView.frame.origin.x, ins_scrollView.frame.origin.y - 5,ins_scrollView.frame.size.width, ins_scrollView.frame.size.height);
        
        requestBtn.hidden = YES;
        generateBtn.hidden = YES;
        republishBtn.hidden = YES;
        
        searchBtn.frame = CGRectMake(157, searchBtn.frame.origin.y, searchBtn.frame.size.width,searchBtn.frame.size.height);
        printTestBtn.frame = CGRectMake(204, printTestBtn.frame.origin.y, printTestBtn.frame.size.width,printTestBtn.frame.size.height);
        
        lblLabelTp.text = @"30x80mm";
        ltKey = @"7";
    }
}

#pragma mark - IBAction : UI : touchProgressionPicker
- (IBAction)touchProgressionPicker:(id)sender {
    [ProgressionPicker showView];
}

#pragma mark - IBAction : UI : touchRequestReasonPicker
- (IBAction)touchRequestReasonPicker:(id)sender {
    [RequestReasonPicker showView];
}

#pragma mark - IBAction : UI : touchLabelTpPicker
- (IBAction)touchLabelTpPicker:(id)sender {
    if ([JOB_GUBUN isEqualToString:@"위치바코드"]){
        ltResultList = [NSMutableArray array];
        NSMutableArray* tempLt = [NSMutableArray array];
        NSMutableDictionary* ltDic = [NSMutableDictionary dictionary];
        
        [ltDic setObject:@"7" forKey:@"commonCode"];
        [ltDic setObject:@"30x80mm" forKey:@"commonCodeName"];
        [tempLt addObject:@"30x80mm"];
        [ltResultList addObject:ltDic];
        
        ltKey = @"";
        
        LabelTpPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempLt];
        LabelTpPicker.delegate = self;
    }
    
    [LabelTpPicker showView];
}

#pragma mark - IBAction : UI : touchSidoPicker
- (IBAction)touchSidoPicker:(id)sender {
    [SidoPicker showView];
}

#pragma mark - IBAction : UI : touchSigoonPicker
- (IBAction)touchSigoonPicker:(id)sender {
    [SigoonPicker showView];
}

#pragma mark - IBAction : UI : touchDongPicker
- (IBAction)touchDongPicker:(id)sender {
    [DongPicker showView];
}

#pragma mark - IBAction : UI : touchStartDatePicker
- (IBAction)touchStartDatePicker:(id)sender {
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"])
        dateType = 1;
    else
        dateType = 3;
    
    CGRect pickerFrame = StartDatePicker.view.frame;
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.1];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
    StartDatePicker.view.frame = pickerFrame;

    [UIView commitAnimations];
}

#pragma mark - IBAction : UI : touchEndDatePicker
- (IBAction)touchEndDatePicker:(id)sender {
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"])
        dateType = 2;
    else
        dateType = 4;
    
    CGRect pickerFrame = EndDatePicker.view.frame;
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.1];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
    EndDatePicker.view.frame = pickerFrame;
    
    [UIView commitAnimations];
}

#pragma mark - IBAction : UI : touchPrintYnPicker
- (IBAction)touchPrintYnPicker:(id)sender {
    NSMutableArray* tempLt = [NSMutableArray array];
    [tempLt addObject:@"전체"];
    [tempLt addObject:@"출력"];
    [tempLt addObject:@"미출력"];
    
    printYnPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempLt];
    printYnPicker.delegate = self;
    
    [printYnPicker showView];
}

#pragma mark - IBAction : UI : touchCheckAll
- (IBAction)touchCheckAll:(id)sender {
    NSMutableArray* checkArray = [NSMutableArray array];
    if([JOB_GUBUN isEqualToString:@"위치바코드"]) checkArray = oriResultList;
    else checkArray = insResultList;
    
    if(allCheck){
        //전체해제
        for(NSDictionary* dic in checkArray){
            [dic setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
        }
        allCheck = NO;
    }else{
        //전체선택
        for(NSDictionary* dic in checkArray){
            if([JOB_GUBUN isEqualToString:@"소스마킹"]){
                if([[dic objectForKey:@"printYn"] isEqualToString:@"BC_CPT"]){
                    [dic setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
                }else{
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
                }
            }else if([JOB_GUBUN isEqualToString:@"장치바코드"]){
                if([[dic objectForKey:@"conditions"] isEqualToString:@"20"]||[[dic objectForKey:@"conditions"] isEqualToString:@"30"]){
                    [dic setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
                }else{
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
                }
            }else{
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            }
        }
        allCheck = YES;
    }
    
    if([JOB_GUBUN isEqualToString:@"위치바코드"]) oriResultList = checkArray;
    else insResultList = checkArray;
    
    [ins_tableView reloadData];
}

#pragma mark - UI : backBtn
- (void) touchBackBtn:(id)sender
{
    if (ProgressionPicker.isShow)
        [ProgressionPicker hideView];
    if (RequestReasonPicker.isShow)
        [RequestReasonPicker hideView];
    if (LabelTpPicker.isShow)
        [LabelTpPicker hideView];
    if (SidoPicker.isShow)
        [SidoPicker hideView];
    if (SigoonPicker.isShow)
        [SigoonPicker hideView];
    if (DongPicker.isShow)
        [DongPicker hideView];
    if (printYnPicker.isShow)
        [printYnPicker hideView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 진행상태 data
-(void)requestBcTraSt{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_BC_TRA_ST;
    
    stKey = @"";
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_BC_TRA_ST withData:rootDic];
}

#pragma mark - 요청사유 dataGet
-(void)requestPblsWhy{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PBLS_WHY;
    
    pwKey = @"";
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_PBLS_WHY withData:rootDic];
}

#pragma mark - 라벨용지 dataGet 
-(void)requestLabelTp{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LABEL_TP;
    
    ltKey = @"";
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_LABEL_TP withData:rootDic];
}

#pragma mark - 시/도 조회
-(void)requestSido{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SIDO_LOC_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_LOC_SIDO withData:rootDic];
}

#pragma mark - 시/군 조회
-(void)requestSigoon:(BOOL)valueSet{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    if(valueSet){
        requestMgr.reqKind = REQUEST_SIGOON_LOC_BARCODE_TRUE;
    }else{
        requestMgr.reqKind = REQUEST_SIGOON_LOC_BARCODE_FALSE;
    }
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:sdKey forKey:@"broadId"];
    NSDictionary* bodyDic = [Util noneMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_LOC_SIGOON withData:rootDic];
}

#pragma mark - 동 조회
-(void)requestDong{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_DONG_LOC_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *param3 = [[NSMutableDictionary alloc] init];
    [param1 setObject:@"" forKey:@"key"];
    [paramDic setObject:param1 forKey:@"broadId"];
    [paramDic setObject:param1 forKey:@"middleId"];
    [param3 setObject:dongItf.text forKey:@"key"];
    [paramDic setObject:param3 forKey:@"locName"];
    [requestMgr asychronousConnectToServer:API_PRT_LOC_DONG withData:paramDic];
}

#pragma mark - 사용자검색
- (IBAction)findUser:(id)sender{
    FindUserController *modalView = [[FindUserController alloc] initWithNibName:@"FindUserController" bundle:nil];
    modalView.delegate = self;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:modalView animated:NO completion:nil];
}

#pragma mark - 검색조회
-(IBAction)requestSearch:(id)sender {
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
        NSString *sDate = [lblReqStartDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *eDate = [lblReqEndDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if([sDate intValue] > [eDate intValue]){
            [self showMessage:@"검색 시작일이 종료일보다 클수 없습니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
        
        requestMgr.delegate = self;
        requestMgr.reqKind = REQUEST_SEARCH_INS_BARCODE;
        
        [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:strUserOrgCode forKey:@"operationDeptCode"];                                                                                //운용조직
        [paramDic setObject:stKey forKey:@"transactionStatusCode"];                                                                                     //진행상태
        [paramDic setObject:instoreNewCode.text forKey:@"newBarcode"];                                                                                  //신규바코드
        [paramDic setObject:instoreInjCode.text forKey:@"injuryBarcode"];                                                                               //훼손바코드
        [paramDic setObject:@"" forKey:@"itemCode"];                                                                                                    //자재코드
        [paramDic setObject:pwKey forKey:@"publicationWhyCode"];                                                                                        //요청사유
        [paramDic setObject:sDate forKey:@"beginDate"];                                                                                                 //처리일
        [paramDic setObject:eDate forKey:@"endDate"];                                                                                                   //처리일
        
        [requestMgr asychronousConnectToServer:API_PRT_INS_SEARCH withData:paramDic];
    }else if([JOB_GUBUN isEqualToString:@"위치바코드"]){
        NSString *trimString = [locCdItf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if(trimString.length == 0){
            if(sdKey.length == 0){
                [self showMessage:@"시/도 를 선택 해주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
            if(sgKey.length == 0){
                [self showMessage:@"시/군/구 를 선택 해주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
            if(dongItf.text.length == 0){
                [self showMessage:@"읍/면/동 을 입력 해주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
        
        requestMgr.delegate = self;
        requestMgr.reqKind = REQUEST_SEARCH_LOC_BARCODE;
        
        [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        if(trimString.length > 0) [paramDic setObject:[trimString substringToIndex:11] forKey:@"locationCode"];
        if(sdKey.length > 0) [paramDic setObject:sdKey forKey:@"boardId"];
        if(sgKey.length > 0) [paramDic setObject:sgKey forKey:@"middleBmassId"];
        if(dongItf.text.length > 0) [paramDic setObject:dongItf.text forKey:@"geoName"];
        if(bunjiItf.text.length > 0) [paramDic setObject:bunjiItf.text forKey:@"BUNJI"];
        if(hoItf.text.length > 0) [paramDic setObject:hoItf.text forKey:@"HO"];
        
        [requestMgr asychronousConnectToServer:API_PRT_LOC_SEARCH withData:paramDic];
    }else if([JOB_GUBUN isEqualToString:@"소스마킹"]){
        if([purchaseNo.text length] > 0){
            if([purchaseLineNo.text length] < 1){
                if([barcodeFrom.text length] < 1 || [barcodeTo.text length] < 1){
                    [self showMessage:@"검색조건을 입력해 주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                    return;
                }
            }
        }else{
//            if([barcodeFrom.text length] < 1 || [barcodeTo.text length] < 1){
                [self showMessage:@"검색조건을 입력해 주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
//            }
        }
        
        if([barcodeFrom.text length] > 0 || [barcodeTo.text length] > 0){
            if([barcodeFrom.text length] > 18 || [barcodeTo.text length] > 18 || [barcodeFrom.text length] < 14 || [barcodeTo.text length] < 14){
                [self showMessage:@"처리할 수 없는 바코드입니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
            
            if([barcodeFrom.text length] != [barcodeTo.text length]){
                [self showMessage:@"바코드 입력 자릿수가 틀립니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
        
        requestMgr.delegate = self;
        requestMgr.reqKind = REQUEST_SEARCH_PO_NO_BARCODE;
        
        [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:purchaseNo.text forKey:@"purchaseNumber"];                 //po_no
        [paramDic setObject:purchaseLineNo.text forKey:@"purchaseLineNumber"];         //항목번호
        [paramDic setObject:[barcodeFrom.text uppercaseString] forKey:@"newBarcodeFrom"];                //바코드From
        [paramDic setObject:[barcodeTo.text uppercaseString]forKey:@"newBarcodeTo"];                    //바코드To
        [paramDic setObject:pskKey forKey:@"selectPrtYn"];                             //출력여부
        
        NSDictionary* bodyDic = [Util noneMessageBody:paramDic];
        NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
        [requestMgr asychronousConnectToServer:API_PRT_SM_PO_NO_SEARCH withData:rootDic];
        
    }else if([JOB_GUBUN isEqualToString:@"장치바코드"]){
        NSString *sDate = [lblStartDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *eDate = [lblEndDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if(![lblStartDate.text isEqualToString:@""] && ![lblEndDate.text isEqualToString:@""]){
            if([sDate intValue] > [eDate intValue]){
                [self showMessage:@"검색 시작일이 종료일보다 클수 없습니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        if([deviceId.text isEqualToString:@""] &&
           [operationSystemCode.text isEqualToString:@""] &&
           [registerUserId.text isEqualToString:@""]){
            [self showMessage:@"검색조건을 입력해 주세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        if(registerUserId.text.length > 3){
            if([[lblStartDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""] length] < 6 ||
               [[lblEndDate.text stringByReplacingOccurrencesOfString:@"-" withString:@""] length] < 6){
                [self showMessage:@"생성일을 입력하세요. " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
        
        requestMgr.delegate = self;
        requestMgr.reqKind = REQUEST_SEARCH_DEVICE_BARCODE;
        
        [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        [paramDic setObject:deviceId.text forKey:@"deviceId"];                          //장치ID
        [paramDic setObject:registerUserId.text forKey:@"registerUserId"];              //생성자
        [paramDic setObject:lblStartDate.text forKey:@"registerFromDate"];              //생성일시작
        [paramDic setObject:lblEndDate.text forKey:@"registerToDate"];                  //생성일종료
//        [paramDic setObject:@"notify100" forKey:@"registerUserId"];                   //생성자 test : notify100
        [paramDic setObject:[operationSystemCode.text uppercaseString] forKey:@"operationSystemCode"];    //장비ID
        
        [requestMgr asychronousConnectToServer:API_PRT_DEVICEID_SEARCH withData:paramDic];
    }
}

#pragma IFindUserRequest delegate -- call by FindUserController
- (void)findUserRequest:(NSString *)userId{
    registerUserId.text = userId;
}

#pragma mark - request data 벨리데이션 처리
-(void)sendDataVali:(int)type{
    //요청취소 0, 발행 1, 재발행2, 출력3
    
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
        NSString *msg = @"훼손바코드 \n";
        insSendDataList = [NSMutableArray array];
        
        for(NSDictionary* dic in insResultList){
            BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
            if (!isSelect)  continue;
            else{
                if((type == 0 && [[dic objectForKey:@"transactionStatusCode"] isEqualToString:@"BC_CPT"]) ||
                   (type == 1 && ![[dic objectForKey:@"transactionStatusCode"] isEqualToString:@"BC_REQ"]) ||
                   (type == 2 && !([[dic objectForKey:@"transactionStatusCode"] isEqualToString:@"BC_PBL"] && [[dic objectForKey:@"publicationWhyCode"] isEqualToString:@"1"])) ||
                   (type == 3 && ![[dic objectForKey:@"transactionStatusCode"] isEqualToString:@"BC_CRT"])){
                    msg = [NSString stringWithFormat:@"%@%@\n",msg,[dic objectForKey:@"injuryBarcode"]];
                    [dic setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
                }else{
                    [insSendDataList addObject:dic];
                }
            }
        }
        
        if(type == 0){
            if([cancelRsKey length] < 1){
                [self showMessage:@"요청취소 사유를 선택해주세요 " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        if(type == 3){
            if([ltKey isEqualToString:@""] || ltKey.length < 1){
                [self showMessage:@"라벨용지를 선택해주세요 " tag:-1 title1:@"닫기" title2:nil isError:YES];
                return;
            }
        }
        
        if([msg length] > 10){
            if(type == 0){
                msg = @"완료건은 삭제불가 합니다.";
            }else if(type == 1){
                msg = @"요청인 상태만 발행이 가능합니다.";
            }else if(type == 2){
                msg = @"인쇄 상태고 훼손 사유만 재발행 할 수 있습니다.";
            }else if(type == 3){
                msg = @"발행인 상태만 출력 가능합니다.";
            }
            [self showMessage:msg tag:0 title1:@"닫기" title2:nil isError:YES];
        }else{
            if([insSendDataList count] < 1){
                [self showMessage:@"전송하실 바코드가 없습니다." tag:0 title1:@"닫기" title2:nil isError:YES];
                return;
            }else if([insSendDataList count] > 1000){
                [self showMessage:@"바코드 전송은 1000건 까지만 가능합니다." tag:0 title1:@"닫기" title2:nil isError:YES];
                return;
            }else{
                if (type == 0) [self requestCancel];
                else if (type == 1) [self requestGenerate];
                else if (type == 2) [self requestRepublish];
                else if (type == 3) [self requestPrint:YES];
            }
        }
    }else if([JOB_GUBUN isEqualToString:@"위치바코드"] || [JOB_GUBUN isEqualToString:@"소스마킹"] || [JOB_GUBUN isEqualToString:@"장치바코드"]){
        if([ltKey isEqualToString:@""] || ltKey.length < 1){
            [self showMessage:@"라벨용지를 선택해주세요 " tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        insSendDataList = [NSMutableArray array];
         NSMutableArray* sendArray = [NSMutableArray array];
        
        if([JOB_GUBUN isEqualToString:@"위치바코드"]) sendArray = oriResultList;
        else sendArray = insResultList;
        
        for(NSDictionary* dic in sendArray){
            BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
            if (!isSelect)  continue;
            else{
                [insSendDataList addObject:dic];
            }
        }
        
        if([insSendDataList count] < 1){
            [self showMessage:@"전송하실 바코드가 없습니다." tag:0 title1:@"닫기" title2:nil isError:YES];
            return;
        }else if([insSendDataList count] > 1000){
            [self showMessage:@"바코드 전송은 1000건 까지만 가능합니다." tag:0 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        BarcodePrintController *bpr = [[BarcodePrintController alloc] init];
        bpr.delegate = self;
        [bpr makeBarcodeAndPrint:[ltKey intValue] sendDataList:insSendDataList statusMod:true];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if(alertView.tag == 0){
        [ins_tableView reloadData];
    }else if(alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

#pragma mark - 요청취소
-(IBAction)requestCancel:(id)sender {
    
    CancelRsViewController *modalView = [[CancelRsViewController alloc] initWithNibName:@"CancelRsViewController" bundle:nil];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    modalView.delegate = self;
    
    [self presentViewController:modalView animated:NO completion:nil];
    modalView.view.alpha = 1;
}

#pragma mark - 발행
-(IBAction)requestGenerate:(id)sender {
    [self sendDataVali:1];
}

#pragma mark - 재발행
-(IBAction)requestRepublish:(id)sender {
    [self sendDataVali:2];
}

//#pragma mark - 출력 테스트
//- (IBAction)printTest:(id)sender{
//    [self requestPrint:NO];
//}

#pragma mark - IBAction : printSetting
- (IBAction)printSetting:(id)sender{
    if([ltKey isEqualToString:@""] || ltKey == nil){
        [self showMessage:@"라벨용지를 선택해주세요 " tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    PrintSettingViewController *modalView = [[PrintSettingViewController alloc] initWithNibName:@"PrintSettingViewController" bundle:nil];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    modalView.type = ltKey;
    [self presentViewController:modalView animated:NO completion:nil];
    modalView.view.alpha = 1;
}

#pragma mark - 출력
- (IBAction)print:(id)sender{
    [self sendDataVali:3];
}

-(void)requestGenerate{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* subParamList = [NSMutableArray array];
    
    for (NSDictionary* dic in insSendDataList)
    {
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        [subParamDic setObject:[dic objectForKey:@"generationRequestDetailSeq"] forKey:@"generationRequestDetailSeq"];  //채번요청상세일련번호
        [subParamDic setObject:[dic objectForKey:@"generationRequestSeq"] forKey:@"generationRequestSeq"];              //채번요청일련번호
        [subParamDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];                  //발행사유코드
        [subParamDic setObject:[dic objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];                              //구바코드여부
        [subParamDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];                            //훼손바코드
        [subParamDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];                                      //자재코드
        
        [subParamList addObject:subParamDic];
    }
    
    [paramDic setObject:subParamList forKey:@"params"];
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    requestMgr.delegate = self;
    
    requestMgr.reqKind = REQUEST_GENERATE_INS_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr asychronousConnectToServer:API_PRT_INS_GENERATE withData:paramDic];
}

-(void)requestRepublish{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* subParamList = [NSMutableArray array];
    
    for (NSDictionary* dic in insSendDataList)
    {
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        [subParamDic setObject:[dic objectForKey:@"generationRequestDetailSeq"] forKey:@"generationRequestDetailSeq"];  //채번요청상세일련번호
        [subParamDic setObject:[dic objectForKey:@"generationRequestSeq"] forKey:@"generationRequestSeq"];              //채번요청일련번호
        [subParamDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];                  //발행사유코드
        [subParamDic setObject:[dic objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];                              //구바코드여부
        [subParamDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];                            //훼손바코드
        [subParamDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];                                      //자재코드
        
        [subParamList addObject:subParamDic];
    }
    
    [paramDic setObject:subParamList forKey:@"params"];
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    requestMgr.delegate = self;
    
    requestMgr.reqKind = REQUEST_REPUBLISH_INS_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr asychronousConnectToServer:API_PRT_INS_REPUBLISH withData:paramDic];
}

#pragma mark - 인스토어마킹 프린트 동시에 한건씩 상태값 변경
- (void)isPrintComplete:(NSDictionary *)completeDicData
{    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PRINT_INS_BARCODE;
    
    NSMutableArray* paramList = [NSMutableArray array];
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    
//    for(NSDictionary *dic in completeDicData){
        NSMutableDictionary* paramDic = [NSMutableDictionary dictionary];
        
        [paramDic setObject:[completeDicData objectForKey:@"newBarcode"] forKey:@"newBarcode"];                                  //신규바코드
        [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];                                     //userId
        [paramDic setObject:@"I" forKey:@"process"];                                                                 //process
        [paramDic setObject:[completeDicData objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];                              //구바코드유무
        [paramList addObject:paramDic];
//    }
    
    NSDictionary* bodyDic = [Util singleListMessageBody:paramList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_INS_STATUS_MOD withData:rootDic];
}

#pragma mark - 소스마킹 프린트 동시에 한건씩 상태값 변경
- (void)smPrintComplete:(NSDictionary *)completeDicData
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PRINT_SM_BARCODE;
    
    NSMutableArray* paramList = [NSMutableArray array];
    
    NSDictionary *userinfo = [Util udObjectForKey:USER_INFO];
    
//    for(NSDictionary *dic in completeDicData){
        NSMutableDictionary* paramDic = [NSMutableDictionary dictionary];
        
        [paramDic setObject:[completeDicData objectForKey:@"barcode"] forKey:@"newBarcode"];                                     //신규바코드
        [paramDic setObject:[userinfo objectForKey:@"userId"] forKey:@"userId"];                                     //userId
        [paramDic setObject:@"S" forKey:@"process"];                                                                 //process
        [paramDic setObject:[completeDicData objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];                              //구바코드유무
        [paramList addObject:paramDic];
//    }
    
    NSDictionary* bodyDic = [Util singleListMessageBody:paramList];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_SM_PRINT_YN withData:rootDic];
}

#pragma popRequest delegate -- call by CancelRsViewController
- (void)popRequest:(NSString *)_cancelRsKey cancelRsDt:(NSString *)_cancelRsDt{
    cancelRsKey = _cancelRsKey;
    cancelRsDetail = _cancelRsDt;
    [self sendDataVali:0];
}

-(void)requestCancel{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableArray* subParamList = [NSMutableArray array];
    
    for (NSDictionary* dic in insSendDataList)
    {
        NSMutableDictionary *subParamDic = [NSMutableDictionary dictionary];
        [subParamDic setObject:[dic objectForKey:@"generationRequestDetailSeq"] forKey:@"generationRequestDetailSeq"];  //채번요청상세일련번호
        [subParamDic setObject:[dic objectForKey:@"generationRequestSeq"] forKey:@"generationRequestSeq"];              //채번요청일련번호
        
        [subParamDic setObject:cancelRsKey forKey:@"deleteWhyCode"];                                                    //취소사유코드
        [subParamDic setObject:cancelRsDetail forKey:@"deleteWhyDescription"];                                          //취소사유상세
        
        [subParamDic setObject:[dic objectForKey:@"transactionStatusCode"] forKey:@"transactionStatusCode"];            //진행상태코드
        [subParamDic setObject:[dic objectForKey:@"transactionUserId"] forKey:@"transactionUserId"];                    //처리자ID
        [subParamDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];                            //훼손바코드
        [subParamDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];                                  //신규바코드
        [subParamDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];                  //요청사유
        
        [subParamList addObject:subParamDic];
    }
    
    [paramDic setObject:subParamList forKey:@"params"];
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    requestMgr.delegate = self;
    
    requestMgr.reqKind = REQUEST_CANCEL_INS_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr asychronousConnectToServer:API_PRT_INS_CANCEL withData:paramDic];
}

-(void)requestPrint:(BOOL)send
{
    if([ltKey isEqualToString:@""]){
        [self showMessage:@"라벨용지를 선택해주세요 " tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    if(send == NO){ //test
        NSMutableArray *dicArray = [[NSMutableArray alloc] init];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:@"K912345678901234" forKey:@"newBarcode"];
        [dic setObject:@"Unit" forKey:@"partKindName"];
        [dic setObject:@"LG_AGAM" forKey:@"itemName"];
        [dic setObject:@"P00012836970000000000" forKey:@"locationCode"];
        [dic setObject:@"OO특별시 OO구" forKey:@"geoName"];
        [dic setObject:@"OO동 OO건물" forKey:@"locationName"];
        [dic setObject:@"K912345678901234" forKey:@"deviceId"];
        [dic setObject:@"LG_AGAM" forKey:@"deviceName"];
        [dic setObject:@"LG_AGAM" forKey:@"barcode"];
        [dicArray addObject:dic];
        
        BarcodePrintController *bpr = [[BarcodePrintController alloc] init];
        [bpr makeBarcodeAndPrint:[ltKey intValue] sendDataList:dicArray statusMod:false];
    }else{
        BarcodePrintController *bpr = [[BarcodePrintController alloc] init];
        bpr.delegate = self;
        [bpr makeBarcodeAndPrint:[ltKey intValue] sendDataList:insSendDataList statusMod:true];
    }
}

#pragma mark - IBAction : UI : printSensor
-(IBAction)printSensor:(id)sender{
    BarcodePrintController *bpr = [[BarcodePrintController alloc] init];
    [bpr printSensor];
}


#pragma  mark - IDatePickerView delegate -- call by DatePickerViewController
- (void) selectDate:(NSString *)date showingDate:(NSString *)showingDate
{
    if(dateType == 1)
        lblReqStartDate.text = showingDate;
    else if(dateType == 2)
        lblReqEndDate.text = showingDate;
    else if(dateType == 3)
        lblStartDate.text = showingDate;
    else
        lblEndDate.text = showingDate;
}

- (void) cancelDatePicker
{
    //delegate
}

#pragma  mark - IPrintRequest delegate -- call by BarcodePrintController
-(void)printRequest:(NSString*)kind completeDicData:(NSDictionary *)completeDicData{
    if([kind isEqualToString:@"ING"]){
        if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
            [self isPrintComplete:completeDicData];
        }else if([JOB_GUBUN isEqualToString:@"소스마킹"]){
            [self smPrintComplete:completeDicData];
        }
    }else if([kind isEqualToString:@"END"]){
        if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"] || [JOB_GUBUN isEqualToString:@"소스마킹"]){
            [self requestSearch:nil];
        }
    }else{
        [self showMessage:@"바코드 출력중 오류가 났습니다." tag:-1 title1:@"닫기" title2:nil];
    }
}

#pragma  mark - IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    if (status == 0 || status == 2){
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        NSString* message = [headerDic objectForKey:@"detail"];
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self processFailRequest:pid Message:message Status:status];
        
        return;
    }
    else if (status == -1){ //세션종료
        [self processEndSession:pid];
        return;
    }
    
    if (pid == REQUEST_BC_TRA_ST){
        [self processBcTraSt:resultList];
    }else if (pid == REQUEST_PBLS_WHY){
        [self processPblsWhy:resultList];
    }else if (pid == REQUEST_LABEL_TP){
        [self processLabelTp:resultList];
    }else if (pid == REQUEST_SEARCH_INS_BARCODE){
        allCheck = NO;
        [self processSearchInsBarcode:resultList];
    }else if (pid == REQUEST_CANCEL_INS_BARCODE){
        [self requestSearch:nil];
    }else if (pid == REQUEST_GENERATE_INS_BARCODE){
        [self requestSearch:nil];
    }else if (pid == REQUEST_REPUBLISH_INS_BARCODE){
        [self requestSearch:nil];
    }else if(pid == REQUEST_PRINT_INS_BARCODE){
        [self requestSearch:nil];
    }else if (pid == REQUEST_SIDO_LOC_BARCODE){
        [self processSido:resultList];
    }else if (pid == REQUEST_SIGOON_LOC_BARCODE_FALSE){
        [self processSigoon:resultList valueSet:NO];
    }else if (pid == REQUEST_SIGOON_LOC_BARCODE_TRUE){
        [self processSigoon:resultList valueSet:YES];
    }else if (pid == REQUEST_DONG_LOC_BARCODE){
        [self processDong:resultList];
    }else if (pid == REQUEST_SEARCH_LOC_BARCODE){
        [self processSearchLocBarcode:resultList];
    }else if(pid == REQUEST_SEARCH_PO_NO_BARCODE){
        [self processSearchSourceMarking:resultList];
    }else if(pid == REQUEST_SEARCH_DEVICE_BARCODE){
        [self processSearchDevice:resultList];
    }else isOperationFinished = YES;
}

#pragma  mark - 진행상태 코드 조회
- (void)processBcTraSt:(NSArray*)reultList
{
    NSMutableArray* tempSt = [NSMutableArray array];
    
    if (reultList.count){
        stResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* stDic = [NSMutableDictionary dictionary];
            
            if([stResultList count] < 1){
                NSMutableDictionary* stDicTemp = [NSMutableDictionary dictionary];
                [stDicTemp setObject:@"all" forKey:@"commonCode"];
                [stDicTemp setObject:@"전체" forKey:@"commonCodeName"];
                [tempSt addObject:@"전체"];
                [stResultList addObject:stDicTemp];
            }
            
            [stDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [stDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempSt addObject:[dic objectForKey:@"commonCodeName"]];
            [stResultList addObject:stDic];
        }
    }
    [self requestPblsWhy];
    
    lblProgression.text = @"전체";
    stKey = @"all";
    
    ProgressionPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempSt];
    ProgressionPicker.delegate = self;
}

#pragma  mark - 요청사유 코드 조회
- (void)processPblsWhy:(NSArray*)reultList
{
    NSMutableArray* tempPw = [NSMutableArray array];
    
    if (reultList.count){
        pwResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* pwDic = [NSMutableDictionary dictionary];
            
            if([pwResultList count] < 1){
                NSMutableDictionary* pwDicTemp = [NSMutableDictionary dictionary];
                [pwDicTemp setObject:@"all" forKey:@"commonCode"];
                [pwDicTemp setObject:@"전체" forKey:@"commonCodeName"];
                [tempPw addObject:@"전체"];
                [pwResultList addObject:pwDicTemp];
            }
            
            [pwDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [pwDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempPw addObject:[dic objectForKey:@"commonCodeName"]];
            [pwResultList addObject:pwDic];
        }
    }
    [self requestLabelTp];
    
    lblRequestReason.text = @"전체";
    pwKey = @"all";
    
    RequestReasonPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempPw];
    RequestReasonPicker.delegate = self;
}

#pragma  mark - 라벨용지 코드 조회
- (void)processLabelTp:(NSArray*)reultList
{
    NSMutableArray* tempLt = [NSMutableArray array];
    
    if (reultList.count){
        ltResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* ltDic = [NSMutableDictionary dictionary];
            
            if([JOB_GUBUN isEqualToString:@"장치바코드"]){
                if(![[dic objectForKey:@"commonCodeName"] isEqualToString:@"6x35mm"] &&
                   ![[dic objectForKey:@"commonCodeName"] isEqualToString:@"20x45mm"] &&
                   ![[dic objectForKey:@"commonCodeName"] isEqualToString:@"30x80mm"] ){
                    continue;
                }
            }
            
            [ltDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [ltDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempLt addObject:[dic objectForKey:@"commonCodeName"]];
            [ltResultList addObject:ltDic];
        }
    }
    
    lblLabelTp.text = @"선택";
    
    LabelTpPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempLt];
    LabelTpPicker.delegate = self;
}

#pragma  mark - 시/도 코드 조회
- (void)processSido:(NSArray*)reultList
{
    NSMutableArray* tempSd = [NSMutableArray array];
    
    if (reultList.count){
        sdResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* sdDic = [NSMutableDictionary dictionary];
            
            [sdDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [sdDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempSd addObject:[dic objectForKey:@"commonCodeName"]];
            [sdResultList addObject:sdDic];
        }
    }
    
    lblSido.text = @"선택";
    
    SidoPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempSd];
    SidoPicker.delegate = self;
}

#pragma  mark - 시/군 코드 조회
- (void)processSigoon:(NSArray*)reultList valueSet:(BOOL)ValueSet
{
    NSMutableArray* tempSg = [NSMutableArray array];
    
    if (reultList.count){
        sgResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* sgDic = [NSMutableDictionary dictionary];
            
            [sgDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [sgDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempSg addObject:[dic objectForKey:@"commonCodeName"]];
            [sgResultList addObject:sgDic];
        }
    }
    
    if(ValueSet){
        for (NSDictionary* dic in reultList){
            if([[dic objectForKey:@"commonCode"] isEqualToString:selectedDongPickerData]){
                lblSigoon.text = [dic objectForKey:@"commonCodeName"];
                sgKey = selectedDongPickerData;
            }
        }
    }else{
        lblSigoon.text = @"선택";
    }
    
    SigoonPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempSg];
    SigoonPicker.delegate = self;
}

#pragma  mark - 동 코드 조회
- (void)processDong:(NSArray*)reultList
{
    NSMutableArray* tempDo = [NSMutableArray array];
    
    if (reultList.count){
        doResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* doDic = [NSMutableDictionary dictionary];
            [doDic setObject:[dic objectForKey:@"address"] forKey:@"address"];
            [doDic setObject:[dic objectForKey:@"broadId"] forKey:@"broadId"];
            [doDic setObject:[dic objectForKey:@"middleId"] forKey:@"middleId"];
            [doDic setObject:[dic objectForKey:@"bmasId"] forKey:@"bmasId"];
            [tempDo addObject:[dic objectForKey:@"address"]];
            [doResultList addObject:doDic];
        }
    }
    
    DongPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempDo];
    DongPicker.delegate = self;
    
    [DongPicker showView];
}

#pragma  mark - 인스토어마킹 관리 검색 : 데이터
- (void)processSearchInsBarcode:(NSArray*)reultList
{
    insResultList = [[NSMutableArray array] init];
    
    if (reultList.count){
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* insDic = [NSMutableDictionary dictionary];
            
            [insDic setObject:[dic objectForKey:@"assetClassificationName"] forKey:@"assetClassificationName"];
            [insDic setObject:[dic objectForKey:@"assetClassificationSequence"] forKey:@"assetClassificationSequence"];
            [insDic setObject:[dic objectForKey:@"barcodeRuleFormat"] forKey:@"barcodeRuleFormat"];
            [insDic setObject:[dic objectForKey:@"beginDate"] forKey:@"beginDate"];
            [insDic setObject:[dic objectForKey:@"deptCode"] forKey:@"deptCode"];
            [insDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
            [insDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];
            [insDic setObject:[dic objectForKey:@"itemCategoryCode"] forKey:@"itemCategoryCode"];
            [insDic setObject:[dic objectForKey:@"itemCategoryName"] forKey:@"itemCategoryName"];
            [insDic setObject:[dic objectForKey:@"itemClassificationName"] forKey:@"itemClassificationName"];
            [insDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
            [insDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
            [insDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
            [insDic setObject:[dic objectForKey:@"locationName"] forKey:@"locationName"];
            [insDic setObject:[dic objectForKey:@"makerCode"] forKey:@"makerCode"];
            [insDic setObject:[dic objectForKey:@"makerName"] forKey:@"makerName"];
            [insDic setObject:[dic objectForKey:@"makerSerial"] forKey:@"makerSerial"];
            [insDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
            [insDic setObject:[dic objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];
            [insDic setObject:[dic objectForKey:@"orgName"] forKey:@"orgName"];
            [insDic setObject:[dic objectForKey:@"partKindCode"] forKey:@"partKindCode"];
            [insDic setObject:[dic objectForKey:@"partKindName"] forKey:@"partKindName"];
            [insDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];
            [insDic setObject:[dic objectForKey:@"publicationWhyName"] forKey:@"publicationWhyName"];
            [insDic setObject:[dic objectForKey:@"transactionDate"] forKey:@"transactionDate"];
            [insDic setObject:[dic objectForKey:@"transactionStatusCode"] forKey:@"transactionStatusCode"];
            [insDic setObject:[dic objectForKey:@"transactionStatusName"] forKey:@"transactionStatusName"];
            [insDic setObject:[dic objectForKey:@"transactionTime"] forKey:@"transactionTime"];
            [insDic setObject:[dic objectForKey:@"transactionUserId"] forKey:@"transactionUserId"];
            [insDic setObject:[dic objectForKey:@"transactionUserName"] forKey:@"transactionUserName"];
            [insDic setObject:[dic objectForKey:@"generationRequestDetailSeq"] forKey:@"generationRequestDetailSeq"];
            [insDic setObject:[dic objectForKey:@"generationRequestSeq"] forKey:@"generationRequestSeq"];
            [insDic setObject:[dic objectForKey:@"traUserId"] forKey:@"traUserId"];
            [insDic setObject:[dic objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];
            [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            [insResultList addObject:insDic];
        }
    }
    [ins_tableView reloadData];
}

#pragma  mark - 위치바코드 관리 검색 : 데이터
- (void)processSearchLocBarcode:(NSArray*)reultList
{
    
    oriResultList = [[NSMutableArray array] init];
    
    if (reultList.count){
        int tag = 0;
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* insDic = [NSMutableDictionary dictionary];
            [insDic setObject:[dic objectForKey:@"locationTypeName"] forKey:@"locationTypeName"];
            [insDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
            [insDic setObject:[dic objectForKey:@"locationLevel"] forKey:@"locationLevel"];
            [insDic setObject:[dic objectForKey:@"locationName"] forKey:@"locationName"];
            [insDic setObject:[dic objectForKey:@"roomTypeCode"] forKey:@"roomTypeCode"];
            [insDic setObject:[dic objectForKey:@"sttus"] forKey:@"sttus"];
            [insDic setObject:[dic objectForKey:@"subLocationTypeName"] forKey:@"subLocationTypeName"];
            [insDic setObject:[dic objectForKey:@"geoName"] forKey:@"geoName"];
            [insDic setObject:[dic objectForKey:@"buildingDistionctYN"] forKey:@"buildingDistionctYN"];
            [insDic setObject:[dic objectForKey:@"buildingTypeName"] forKey:@"buildingTypeName"];
            [insDic setObject:[dic objectForKey:@"ktBuildingTypeName"] forKey:@"ktBuildingTypeName"];
            [insDic setObject:[dic objectForKey:@"mnofiId"] forKey:@"mnofiId"];
            [insDic setObject:[dic objectForKey:@"mnofiName"] forKey:@"mnofiName"];
            [insDic setObject:[dic objectForKey:@"description"] forKey:@"description"];
            [insDic setObject:[NSNumber numberWithInt:tag] forKey:@"TAG"];
            [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_EXPEND"];
            if([[dic objectForKey:@"locationLevel"] isEqualToString:@"1"]){
                [insDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SHOW"];
            }else{
                [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SHOW"];
            }
            [oriResultList addObject:insDic];
            tag++;
        }
        
        insResultList = [[NSMutableArray array] init];
        for ( NSMutableDictionary* insDic in oriResultList ) {
            if( [[insDic objectForKey:@"IS_SHOW"] boolValue] == YES ){
                 [insResultList addObject:insDic];
            }
        }
    }
    
    [ins_tableView reloadData];
}

#pragma  mark - 소스마킹 검색 : 데이터
- (void)processSearchSourceMarking:(NSArray*)reultList
{
    insResultList = [[NSMutableArray array] init];
    
    if (reultList.count){
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* insDic = [NSMutableDictionary dictionary];
            [insDic setObject:[dic objectForKey:@"barcode"] forKey:@"barcode"];
            [insDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
            [insDic setObject:[dic objectForKey:@"purchaseLineNumber"] forKey:@"purchaseLineNumber"];
            [insDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
            [insDic setObject:[dic objectForKey:@"partKindName"] forKey:@"partKindName"];
            [insDic setObject:[dic objectForKey:@"productTypeName"] forKey:@"productTypeName"];
            [insDic setObject:[dic objectForKey:@"oldBarcodeYN"] forKey:@"oldBarcodeYN"];
            [insDic setObject:[dic objectForKey:@"etc"] forKey:@"printYn"];
            [insDic setObject:@"" forKey:@"ect"];
            [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            
            [insResultList addObject:insDic];
        }
    }
    [ins_tableView reloadData];
}

#pragma  mark - 장치바코드 검색 : 데이터
- (void)processSearchDevice:(NSArray*)reultList
{
    insResultList = [[NSMutableArray array] init];
    
    if (reultList.count){
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* insDic = [NSMutableDictionary dictionary];
            [insDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
            [insDic setObject:[dic objectForKey:@"deviceName"] forKey:@"deviceName"];
            [insDic setObject:[dic objectForKey:@"conditions"] forKey:@"conditions"];
            if([[dic objectForKey:@"conditions"]isEqualToString:@"10"]){
                [insDic setObject:@"운용" forKey:@"conditionsValue"];
            }else if([[dic objectForKey:@"conditions"]isEqualToString:@"20"]){
                [insDic setObject:@"종료진행" forKey:@"conditionsValue"];
            }else if([[dic objectForKey:@"conditions"]isEqualToString:@"30"]){
                [insDic setObject:@"종료" forKey:@"conditionsValue"];
            }else{
                [insDic setObject:@"" forKey:@"conditionsValue"];
            }
            [insDic setObject:[dic objectForKey:@"projectNo"] forKey:@"projectNo"];
            [insDic setObject:[dic objectForKey:@"wbsCode"] forKey:@"wbsCode"];
            [insDic setObject:[dic objectForKey:@"operationSystemTokenName"] forKey:@"operationSystemTokenName"];
            [insDic setObject:[dic objectForKey:@"operationSystemCode"] forKey:@"operationSystemCode"];
            [insDic setObject:[dic objectForKey:@"operationSystemName"] forKey:@"operationSystemName"];
            [insDic setObject:[dic objectForKey:@"locationIdTokenName"] forKey:@"locationIdTokenName"];
            [insDic setObject:[dic objectForKey:@"deviceStatusName"] forKey:@"deviceStatusName"];
            [insDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
            [insDic setObject:[dic objectForKey:@"argumentDecisionName"] forKey:@"argumentDecisionName"];
            [insDic setObject:[dic objectForKey:@"active"] forKey:@"active"];
            [insDic setObject:[dic objectForKey:@"registerDate"] forKey:@"registerDate"];
            [insDic setObject:@"" forKey:@"ect"];
            [insDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            
            [insResultList addObject:insDic];
        }
        
        [ins_tableView reloadData];
    }else{
        NSString* message = @"조회된 장치바코드 정보가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    
}

#pragma mark - processFailRequest
- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message Status:(NSInteger)status
{
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

#pragma mark - processEndSession
- (void) processEndSession:(requestOfKind)pid
{
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
    
    isOperationFinished = YES;
}

#pragma mark - messegeAlert
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

#pragma mark - messegeAlert
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    if (sender == ProgressionPicker)
        [ProgressionPicker hideView];
    else if (sender == RequestReasonPicker)
        [RequestReasonPicker hideView];
    else if (sender == LabelTpPicker)
        [LabelTpPicker hideView];
    else if (sender == SidoPicker)
        [SidoPicker hideView];
    else if (sender == SigoonPicker)
        [SigoonPicker hideView];
    else if (sender == DongPicker)
        [DongPicker hideView];
    else if (sender == printYnPicker)
        [printYnPicker hideView];
}

- (void)onDone:(NSString *)data sender:(id)sender {
    if (sender == ProgressionPicker){
        selectedProgressionPickerData = data;
        lblProgression.text = selectedProgressionPickerData;
        stKey = [[stResultList objectAtIndex:ProgressionPicker.selectedIndex] objectForKey:@"commonCode"];
        [ProgressionPicker hideView];
    }
    else if (sender == RequestReasonPicker){
        selectedRequestReasonPickerData = data;
        lblRequestReason.text = selectedRequestReasonPickerData;
        pwKey = [[pwResultList objectAtIndex:RequestReasonPicker.selectedIndex] objectForKey:@"commonCode"];
        [RequestReasonPicker hideView];
    }
    else if (sender == LabelTpPicker){
        selectedLabelTpPickerData = data;
        lblLabelTp.text = selectedLabelTpPickerData;
        ltKey = [[ltResultList objectAtIndex:LabelTpPicker.selectedIndex] objectForKey:@"commonCode"];
        [LabelTpPicker hideView];
    }
    else if (sender == SidoPicker){
        selectedSidoPickerData = data;
        lblSido.text = selectedSidoPickerData;
        sdKey = [[sdResultList objectAtIndex:SidoPicker.selectedIndex] objectForKey:@"commonCode"];
        [SidoPicker hideView];
        [self requestSigoon:NO];
    }
    else if (sender == SigoonPicker){
        selectedSigoonPickerData = data;
        lblSigoon.text = selectedSigoonPickerData;
        sgKey = [[sgResultList objectAtIndex:SigoonPicker.selectedIndex] objectForKey:@"commonCode"];
        [SigoonPicker hideView];
    }
    else if (sender == DongPicker){
        [self findSodi:[[doResultList objectAtIndex:DongPicker.selectedIndex] objectForKey:@"broadId"]];
        selectedDongPickerData = [[doResultList objectAtIndex:DongPicker.selectedIndex] objectForKey:@"middleId"];
        selectedDongPickerData = [NSString stringWithFormat:@"%@|%@",[[doResultList objectAtIndex:DongPicker.selectedIndex] objectForKey:@"middleId"], [[doResultList objectAtIndex:DongPicker.selectedIndex] objectForKey:@"bmasId"]];
        [DongPicker hideView];
        
    }
    else if (sender == printYnPicker){
        if(printYnPicker.selectedIndex == 0){
            pskKey = @"";
            printYn.text = @"전체";
        }else if (printYnPicker.selectedIndex == 1){
            pskKey = @"Y";
            printYn.text = @"출력";
        }else{
            pskKey = @"N";
            printYn.text = @"미출력";
        }
        [printYnPicker hideView];
    }
}

- (void)findSodi:(NSString*)sd
{
    for (NSDictionary* dic in sdResultList){
        NSString *code = [dic objectForKey:@"commonCode"];
        NSString *name = [dic objectForKey:@"commonCodeName"];
        if([code isEqualToString:sd]){
            sdKey = code;
            lblSido.text = name;
        }
    }
    [self requestSigoon:YES];
}

#pragma mark - IBAction : touchOrgBtn
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

#pragma mark - orgDataReceived
- (void) orgDataReceived:(NSNotification *)notification
{
    receivedOrgDic = [notification object];
    if (receivedOrgDic.count){
        lblOrperationInfo.text = [NSString stringWithFormat:@"%@/%@",[receivedOrgDic objectForKey:@"costCenter"],[receivedOrgDic objectForKey:@"orgName"]];
        strUserOrgCode = [receivedOrgDic objectForKey:@"orgCode"];
        strUserOrgName = [receivedOrgDic objectForKey:@"orgName"];
    }
}

#pragma mark - touchedSelectBtn
- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    if([JOB_GUBUN isEqualToString:@"장치바코드"]){
        if([[[insResultList objectAtIndex:btn.tag] objectForKey:@"conditions"]isEqualToString:@"20"]){
            [self showMessage:@"표준서비스코드상태가 \n\r종료진행,종료 일경우 \n\r출력할 수 없습니다." tag:-1 title1:@"닫기" title2:nil];
            return;
        }else if([[[insResultList objectAtIndex:btn.tag] objectForKey:@"conditions"]isEqualToString:@"30"]){
            [self showMessage:@"표준서비스코드상태가 \n\r종료진행,종료 일경우 \n\r출력할 수 없습니다." tag:-1 title1:@"닫기" title2:nil];
            return;
        }
    }
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [[insResultList objectAtIndex:btn.tag] setValue:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
    }else{
        [[insResultList objectAtIndex:btn.tag] setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
    }
}

#pragma mark - Touch Event
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textFieldShouldReturn
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger tag = [textField tag];
    NSString* message = @"";
    
    if([JOB_GUBUN isEqualToString:@"위치바코드"]){
        if(tag == 100){
            message = [Util barcodeMatchVal:1 barcode:[textField text]];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                textField.text = @"";
                [textField becomeFirstResponder];
                return YES;
            }
        }else{
            if(lblSido.text.length < 1){
                message = @"시/도 검색을 해주세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                textField.text = @"";
                return YES;
            }
            
            if(lblSigoon.text.length < 1){
                message = @"시/군/구 검색을 해주세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                textField.text = @"";
                return YES;
            }
            
            NSString* dong = textField.text;
            textField.text = dong;
            [self requestDong];
        }
    }else if([JOB_GUBUN isEqualToString:@"장치바코드"]){
        if(textField.text.length > 0){
            if(tag == 100){
                message = [Util barcodeMatchVal:3 barcode:[textField text]];
                if(message.length > 0){
                    [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                    textField.text = @"";
                    [textField becomeFirstResponder];
                    return YES;
                }
            }
            textField.text = [textField.text uppercaseString];
        }
        
    }else if([JOB_GUBUN isEqualToString:@"소스마킹"]){
        if(textField.text.length > 0){
            message = [Util barcodeMatchVal:2 barcode:[textField text]];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
                textField.text = @"";
                [textField becomeFirstResponder];
                return YES;
            }
            
            textField.text = [textField.text uppercaseString];
        }
    }
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - showIndicator
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

#pragma mark - hideIndicator
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [insResultList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([JOB_GUBUN isEqualToString:@"인스토어마킹관리"]){
        static NSString *CellIdentifier = @"IMListCell";
        IMListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMListCell" owner:self options:nil];
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (insResultList.count){
            NSDictionary* dic = [insResultList objectAtIndex:indexPath.row];
            
            cell.lblLabel1.text = [dic objectForKey:@"newBarcode"];
            cell.lblLabel2.text = [dic objectForKey:@"injuryBarcode"];
            cell.lblLabel3.text = [dic objectForKey:@"itemCode"];
            cell.lblLabel4.text = [dic objectForKey:@"itemName"];
            cell.lblLabel5.text = [dic objectForKey:@"itemCategoryName"];
            cell.lblLabel6.text = [dic objectForKey:@"partKindName"];
            cell.lblLabel7.text = [dic objectForKey:@"transactionDate"];
            cell.lblLabel8.text = [dic objectForKey:@"transactionTime"];
            cell.lblLabel9.text = [dic objectForKey:@"transactionStatusName"];
            cell.lblLabel10.text = [dic objectForKey:@"deviceId"];
            
            [Util setScrollTouch:cell.scrollItem1 Label:cell.lblLabel11 withString:[dic objectForKey:@"locationCode"]];
            [Util setScrollTouch:cell.scrollItem2 Label:cell.lblLabel12 withString:[dic objectForKey:@"locationName"]];
            [Util setScrollTouch:cell.scrollItem3 Label:cell.lblLabel13 withString:[dic objectForKey:@"itemClassificationName"]];
            [Util setScrollTouch:cell.scrollItem4 Label:cell.lblLabel14 withString:[dic objectForKey:@"assetClassificationName"]];
            [Util setScrollTouch:cell.scrollItem6 Label:cell.lblLabel15 withString:[dic objectForKey:@"makerName"]];
            
            cell.lblLabel16.text = [dic objectForKey:@"makerSerial"];
            cell.lblLabel17.text = [dic objectForKey:@"transactionUserName"];
            cell.lblLabel18.text = [dic objectForKey:@"publicationWhyName"];
            
            [Util setScrollTouch:cell.scrollItem5 Label:cell.lblLabel19 withString:[dic objectForKey:@"orgName"]];
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [insResultList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
        }
        return cell;
    }else if ([JOB_GUBUN isEqualToString:@"위치바코드"]){
        
        static NSString *CellIdentifier = @"LocListCell";
        LocListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"LocListCell" owner:self options:nil];
            cell = arr[0];
        }

        if (insResultList.count){
            NSDictionary* dic = [insResultList objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblLabel1.text = [dic objectForKey:@"locationTypeName"];
            cell.lblLabel2.text = [dic objectForKey:@"locationCode"];
            cell.lblLabel3.text = [dic objectForKey:@"locationName"];
            cell.lblLabel4.text = [dic objectForKey:@"roomTypeCode"];
            cell.lblLabel5.text = [dic objectForKey:@"roomTypeName"];
            cell.lblLabel6.text = [dic objectForKey:@"sttus"];
            cell.lblLabel7.text = [dic objectForKey:@"subLocationTypeName"];
            [Util setScrollTouch:cell.scrollItem1 Label:cell.lblLabel8 withString:[dic objectForKey:@"geoName"]];
            cell.lblLabel9.text = [dic objectForKey:@"buildingDistionctYN"];
            cell.lblLabel10.text = [dic objectForKey:@"buildingTypeName"];
            cell.lblLabel11.text = [dic objectForKey:@"ktBuildingTypeName"];
            cell.lblLabel12.text = [dic objectForKey:@"mnofiId"];
            cell.lblLabel13.text = [dic objectForKey:@"mnofiName"];
            [Util setScrollTouch:cell.scrollItem4 Label:cell.lblLabel14 withString:[dic objectForKey:@"description"]];

            NSDictionary* cellDic = [insResultList objectAtIndex:indexPath.row];
            int index = [[dic objectForKey:@"TAG"] intValue];
            NSLog(@"index :: %d", index);
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = index;
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
            
            [cell.btnCheck setImage:[UIImage imageNamed:@"common_checkbox.png"] forState:UIControlStateNormal];
            [cell.btnCheck setImage:[UIImage imageNamed:@"common_checkbox_checked.png"] forState:UIControlStateSelected];
            
            [cell.expendable addTarget:self action:@selector(expendableTouch:) forControlEvents:UIControlEventTouchUpInside];
            cell.expendable.tag = index;
            BOOL isExpend = [[cellDic objectForKey:@"IS_EXPEND"] boolValue];
            cell.expendable.selected = isExpend;
            
            [cell.expendable setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [cell.expendable setImage:[UIImage imageNamed:@"red-minus.png"] forState:UIControlStateSelected];

            BOOL isShow = [[cellDic objectForKey:@"IS_SHOW"] boolValue];
            
            if([[dic objectForKey:@"locationLevel"] isEqualToString:@"1"]){
                cell.btnCheck.frame = CGRectMake(33, cell.btnCheck.frame.origin.y, cell.btnCheck.frame.size.width, cell.btnCheck.frame.size.height);
                cell.expendable.frame = CGRectMake(0, cell.expendable.frame.origin.y, cell.expendable.frame.size.width, cell.expendable.frame.size.height);
                cell.expendable.selected = isExpend;
                
                if([oriResultList count] > index + 1){
                    if(![[[oriResultList objectAtIndex:index + 1] objectForKey:@"locationLevel"] isEqualToString:@"2"]) cell.expendable.hidden = YES;
                    else cell.expendable.hidden = NO;
                }else{
                    cell.expendable.hidden = YES;
                }
            }else if([[dic objectForKey:@"locationLevel"] isEqualToString:@"2"]){
                cell.btnCheck.frame = CGRectMake(53, cell.btnCheck.frame.origin.y, cell.btnCheck.frame.size.width, cell.btnCheck.frame.size.height);
                cell.expendable.frame = CGRectMake(25, cell.expendable.frame.origin.y, cell.expendable.frame.size.width, cell.expendable.frame.size.height);
                cell.hidden = !isShow;
                
                if([oriResultList count] > index + 1){
                    if(![[[oriResultList objectAtIndex:index + 1] objectForKey:@"locationLevel"] isEqualToString:@"3"]) cell.expendable.hidden = YES;
                    else cell.expendable.hidden = NO;
                }else{
                    cell.expendable.hidden = YES;
                }
            }else{
                cell.btnCheck.frame = CGRectMake(73, cell.btnCheck.frame.origin.y, cell.btnCheck.frame.size.width, cell.btnCheck.frame.size.height);
                cell.hidden = !isShow;
                cell.expendable.hidden = YES;
            }
        }
        return cell;
    }else if ([JOB_GUBUN isEqualToString:@"소스마킹"]){
        static NSString *CellIdentifier = @"SourceMarkingListCell";
        SourceMarkingListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SourceMarkingListCell" owner:self options:nil];
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (insResultList.count){
            NSDictionary* dic = [insResultList objectAtIndex:indexPath.row];
            cell.lblLabel1.text = [dic objectForKey:@"barcode"];
            cell.lblLabel2.text = [dic objectForKey:@"itemCode"];
            cell.lblLabel3.text = [dic objectForKey:@"purchaseLineNumber"];
            cell.lblLabel4.text = [dic objectForKey:@"itemName"];
            cell.lblLabel5.text = [dic objectForKey:@"partKindName"];
            cell.lblLabel6.text = [dic objectForKey:@"productTypeName"];
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            
            BOOL isSelected = [[dic objectForKey:@"IS_SELECTED"] boolValue];
            
            if([[dic objectForKey:@"printYn"] isEqualToString:@"BC_CPT"]){
                cell.lblLabel7.text = @"바코드 발행 불가";
                cell.backgroundColor = RGB(255,182,193);
                cell.btnCheck.selected = false;
                cell.btnCheck.enabled = false;
                
            }else{
                cell.lblLabel7.text = [dic objectForKey:@"ect"];
                cell.backgroundColor = [UIColor whiteColor];
                cell.btnCheck.selected = isSelected;
                cell.btnCheck.enabled = true;
            }
        }
        return cell;
    }
    else if ([JOB_GUBUN isEqualToString:@"장치바코드"]){
        static NSString *CellIdentifier = @"DeviceListCell";
        DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"DeviceListCell" owner:self options:nil];
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (insResultList.count){
            NSDictionary* dic = [insResultList objectAtIndex:indexPath.row];
            cell.lblLabel1.text = [dic objectForKey:@"deviceId"];
            cell.lblLabel2.text = [dic objectForKey:@"deviceName"];
            cell.lblLabel3.text = [dic objectForKey:@"projectNo"];
            cell.lblLabel4.text = [dic objectForKey:@"wbsCode"];
            cell.lblLabel5.text = [dic objectForKey:@"operationSystemTokenName"];
            cell.lblLabel6.text = [dic objectForKey:@"operationSystemCode"];
            cell.lblLabel7.text = [dic objectForKey:@"operationSystemName"];
            cell.lblLabel8.text = [dic objectForKey:@"locationIdTokenName"];
            cell.lblLabel9.text = [dic objectForKey:@"deviceStatusName"];
            cell.lblLabel10.text = [dic objectForKey:@"itemCode"];
            cell.lblLabel11.text = [dic objectForKey:@"argumentDecisionName"];
            cell.lblLabel12.text = [dic objectForKey:@"active"];
            cell.lblLabel13.text = [dic objectForKey:@"registerDate"];
            cell.lblLabel14.text = [dic objectForKey:@"ect"];
            cell.lblLabel15.text = [dic objectForKey:@"conditionsValue"];
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [insResultList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}


-(void)expendableTouch:(id)sender{
    UIButton* btn = (UIButton*)sender;
    
    btn.selected = !btn.selected;
        
    [[oriResultList objectAtIndex:btn.tag] setValue:[NSNumber numberWithBool:btn.selected] forKey:@"IS_EXPEND"];
    
    int level = [[[oriResultList objectAtIndex:btn.tag] objectForKey:@"locationLevel"] intValue];
    
    for(int i = (int)btn.tag + 1; i < (int)[oriResultList count]; i++){
        
        int idxLevel = [[[oriResultList objectAtIndex:i] objectForKey:@"locationLevel"] intValue];
        
        if(idxLevel == level + 1){
            [[oriResultList objectAtIndex:i] setValue:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SHOW"];
        }else if(idxLevel == level + 2){
            [[oriResultList objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SHOW"];
        }else{
            break;
        }
    }
    
    insResultList = [[NSMutableArray array] init];
    for ( NSMutableDictionary* insDic in oriResultList ) {
        if( [[insDic objectForKey:@"IS_SHOW"] boolValue] == YES ){
            [insResultList addObject:insDic];
        }
    }

    [ins_tableView reloadData];
}






@end

//
//  FccInfoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 3..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "FccInfoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"
#import "GridColumnRepairCell.h"

@interface FccInfoViewController ()
@property(nonatomic,strong) IBOutlet UIScrollView* _scrollView;
@property(nonatomic,strong) IBOutlet UIScrollView* _scrollView2;

@property(nonatomic,strong) IBOutlet UIView* normalView;
@property(nonatomic,strong) IBOutlet UIView* locView;
@property(nonatomic,strong) IBOutlet UIView* orgView;
@property(nonatomic,strong) IBOutlet UIView* warrantyView;
@property(nonatomic,strong) IBOutlet UIView* failureView;
@property(nonatomic,strong) IBOutlet UIView* failureListView;

@property(nonatomic,assign) IBOutlet UIButton* normalBtn;
@property(nonatomic,assign) IBOutlet UIButton* locBtn;
@property(nonatomic,assign) IBOutlet UIButton* orgBtn;
@property(nonatomic,assign) IBOutlet UIButton* warrantyBtn;
@property(nonatomic,assign) IBOutlet UIButton* failureBtn;
@property(nonatomic,assign) IBOutlet UIButton* failureListBtn;

@property (strong, nonatomic) IBOutlet scrollTouch *scrollZATEXT;
@property (strong, nonatomic) IBOutlet UILabel *lblZATEXT;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollDeviceName;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcode;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcodeName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcodeName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollFunctionName;
@property (strong, nonatomic) IBOutlet UILabel *lblFunctionName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollFunctionCode;
@property (strong, nonatomic) IBOutlet UILabel *lblFunctionCode;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollOrg;
@property (strong, nonatomic) IBOutlet UILabel *lblOrg;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollMaker;
@property (strong, nonatomic) IBOutlet UILabel *lblMaker;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollProvider;
@property (strong, nonatomic) IBOutlet UILabel *lblProvider;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollProviderName;
@property (strong, nonatomic) IBOutlet UILabel *lblProviderName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollFccName;
@property (strong, nonatomic) IBOutlet UILabel *lblFccName;

@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UILabel* listCount;

@property(nonatomic,strong) NSDictionary* fccInfoDic;
@property(nonatomic,strong) NSDictionary* repairHistoryDic;
@property(nonatomic,strong) NSMutableArray* repairHistory;
@property(nonatomic,assign) NSInteger nSelectedBtn;
@property(nonatomic,assign) NSInteger nPrevBtn;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
//@property(nonatomic,strong) IBOutlet UIPageControl* pageControl;
@end

@implementation FccInfoViewController
@synthesize _scrollView;
@synthesize _scrollView2;
@synthesize indicatorView;
@synthesize normalView;
@synthesize orgView;
@synthesize warrantyView;
@synthesize failureView;
@synthesize failureListView;
@synthesize locView;
@synthesize normalBtn;
@synthesize locBtn;
@synthesize orgBtn;
@synthesize warrantyBtn;
@synthesize failureBtn;
@synthesize failureListBtn;
@synthesize paramBarcode;
@synthesize paramScreenCode;
@synthesize nSelectedBtn;
@synthesize nPrevBtn;
@synthesize fccInfoDic;
@synthesize repairHistoryDic;
@synthesize repairHistory;

@synthesize _tableView;
@synthesize listCount;

//@synthesize pageControl;

@synthesize scrollZATEXT;
@synthesize lblZATEXT;
@synthesize scrollDeviceName;
@synthesize lblDeviceName;
@synthesize scrollFunctionCode;
@synthesize lblFunctionCode;
@synthesize scrollFunctionName;
@synthesize lblFunctionName;
@synthesize scrollLocBarcode;
@synthesize lblLocBarcode;
@synthesize scrollLocBarcodeName;
@synthesize lblLocBarcodeName;
@synthesize scrollOrg;
@synthesize lblOrg;
@synthesize scrollMaker;
@synthesize lblMaker;
@synthesize scrollProvider;
@synthesize lblProvider;
@synthesize scrollProviderName;
@synthesize lblProviderName;
@synthesize scrollGoodsName;
@synthesize lblGoodsName;
@synthesize scrollFccName;
@synthesize lblFccName;

#pragma mark - ViewLife Cycle
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
    self.title = @"상세조회";
    NSLog(@"paramBarcode %@",paramBarcode);
    NSLog(@"paramScreenCode %@",paramScreenCode);
    self.navigationController.navigationBarHidden = NO;
    
    [self layoutSubView];
    
    if (paramBarcode.length)
        [self requestFccDetail:paramBarcode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UserDefine Method
- (void) layoutSubView
{
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    if(![paramScreenCode isEqualToString:@"고장정보"]){
        int index5BtnWidth = 64;
        normalBtn.frame = CGRectMake(normalBtn.frame.origin.x, normalBtn.frame.origin.y, index5BtnWidth, normalBtn.frame.size.height);
        locBtn.frame = CGRectMake((normalBtn.frame.origin.x + normalBtn.frame.size.width), locBtn.frame.origin.y, index5BtnWidth, locBtn.frame.size.height);
        orgBtn.frame = CGRectMake((locBtn.frame.origin.x + locBtn.frame.size.width), locBtn.frame.origin.y, index5BtnWidth, orgBtn.frame.size.height);
        warrantyBtn.frame = CGRectMake((orgBtn.frame.origin.x + orgBtn.frame.size.width), warrantyBtn.frame.origin.y, index5BtnWidth, warrantyBtn.frame.size.height);
        failureBtn.hidden = YES;
        failureListBtn.frame = CGRectMake((warrantyBtn.frame.origin.x + warrantyBtn.frame.size.width), failureListBtn.frame.origin.y, index5BtnWidth, failureListBtn.frame.size.height);
        
        if([paramScreenCode isEqualToString:@"고장이력조회"]){
            [self contentsShow:60];
        }else{
            [self contentsShow:10];
        }
    }
    else{
        [self contentsShow:50];
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

- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





- (void) fillWarrantyContent
{
    if (fccInfoDic.count){
        UITextField* tf = nil;
        tf = (UITextField*)[warrantyView viewWithTag:400]; //보증기준코드명
        tf.text = [fccInfoDic objectForKey:@"ABCKZ"];
        
        tf = (UITextField*)[warrantyView viewWithTag:401]; //보증기준코드
        tf.text = [fccInfoDic objectForKey:@"ABCTX"];
        
        tf = (UITextField*)[warrantyView viewWithTag:402]; //신규설비 보증기간 시작
        tf.text = [fccInfoDic objectForKey:@"GWLDT_O"];
        
        tf = (UITextField*)[warrantyView viewWithTag:403]; //신규설비 보증기간 종료
        tf.text = [fccInfoDic objectForKey:@"GWLEN_O"];
        
        tf = (UITextField*)[warrantyView viewWithTag:404]; //개조설비 보증기간 시작
        tf.text = [fccInfoDic objectForKey:@"GWLDT_I"];
        
        tf = (UITextField*)[warrantyView viewWithTag:405]; //개조설비 보증기간 종료
        tf.text = [fccInfoDic objectForKey:@"GWLEN_I"];        
    }
}

- (void) fillorgContent
{
    if (fccInfoDic.count){
        UITextField* tf = nil;
        [Util setScrollTouch:scrollOrg Label:lblOrg withString:[fccInfoDic objectForKey:@"ZKTEXT"]];
        
        tf = (UITextField*)[orgView viewWithTag:301]; //운용조직명
        tf.text = [fccInfoDic objectForKey:@"ZKOSTL"];
        
        tf = (UITextField*)[orgView viewWithTag:302]; //WBS요소
        tf.text = [fccInfoDic objectForKey:@"PROID"];
        
        tf = (UITextField*)[orgView viewWithTag:303]; //유지보수센터명
        tf.text = [fccInfoDic objectForKey:@"CENTER_NAME"];
        
        tf = (UITextField*)[orgView viewWithTag:304]; //유지보수센터코드
        tf.text = [fccInfoDic objectForKey:@"ZCENTER"];
        
        tf = (UITextField*)[orgView viewWithTag:305]; //운용시스템구분
        tf.text = [fccInfoDic objectForKey:@"ZEQUIPGL_TXT"];
    }
}

- (void) fillLocContent
{
    if (fccInfoDic.count){
        UITextField* tf = nil;
        tf = (UITextField*)[locView viewWithTag:200]; //국사위치
        tf.text = [fccInfoDic objectForKey:@"ZKUKCO"];

        tf = (UITextField*)[locView viewWithTag:201]; //유무선구분
        tf.text = [fccInfoDic objectForKey:@"EQUIPGD_TXT"];

        tf = (UITextField*)[locView viewWithTag:202]; //장치아이디
        tf.text = [fccInfoDic objectForKey:@"ZEQUIPGC"];
        
        [Util setScrollTouch:scrollDeviceName Label:lblDeviceName withString:[fccInfoDic objectForKey:@"DEVICEGB"]];

        [Util setScrollTouch:scrollProvider Label:lblProvider withString:[fccInfoDic objectForKey:@"ZLIFNR"]];

        [Util setScrollTouch:scrollProviderName Label:lblProviderName withString:[fccInfoDic objectForKey:@"ZLIFNM"]];

        [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcode withString:[fccInfoDic objectForKey:@"ZEQUIPLP"]];
        
        [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:[fccInfoDic objectForKey:@"PLOCNAME"]];
        [Util setScrollTouch:scrollFunctionName Label:lblFunctionName withString:[fccInfoDic objectForKey:@"PLTXT"]];
        
        [Util setScrollTouch:scrollFunctionCode Label:lblFunctionCode withString:[fccInfoDic objectForKey:@"TPLNR"]];
    }
}

- (void) fillNormalContent
{
    if (fccInfoDic.count){
        UITextField* tf = nil;
        tf = (UITextField*)[normalView viewWithTag:100]; //설비바코드
        tf.text = [fccInfoDic objectForKey:@"EQUNR"];
        
        // 바코드명
        [Util setScrollTouch:scrollFccName Label:lblFccName withString:[fccInfoDic objectForKey:@"EQKTX"]];
        
        tf = (UITextField*)[normalView viewWithTag:102]; //상위바코드
        tf.text = [fccInfoDic objectForKey:@"HEQUNR"];

        tf = (UITextField*)[normalView viewWithTag:103]; //상위바코드명
        tf.text = [fccInfoDic objectForKey:@"HEQKTX"];
        
        tf = (UITextField*)[normalView viewWithTag:104]; //설비상태
        tf.text = [fccInfoDic objectForKey:@"ZDESC"];
        
        tf = (UITextField*)[normalView viewWithTag:105]; //설비상태코드
        tf.text = [fccInfoDic objectForKey:@"ZPSTATU"];
        
        // 제조사
        [Util setScrollTouch:scrollMaker Label:lblMaker withString:[fccInfoDic objectForKey:@"ZCODENAME"]];

        
        tf = (UITextField*)[normalView viewWithTag:107]; //제조사 s/n
        tf.text = [fccInfoDic objectForKey:@"SERGE"];

        tf = (UITextField*)[normalView viewWithTag:108]; //납품일
        tf.text = [fccInfoDic objectForKey:@"AULDT"];
        
        tf = (UITextField*)[normalView viewWithTag:109]; //취득일
        tf.text = [fccInfoDic objectForKey:@"ANSDT"];
        
        tf = (UITextField*)[normalView viewWithTag:110]; //물품코드
        tf.text = [fccInfoDic objectForKey:@"SUBMT"];
        
        //물품명
        [Util setScrollTouch:scrollGoodsName Label:lblGoodsName withString:[fccInfoDic objectForKey:@"MAKTX"]];

        
        tf = (UITextField*)[normalView viewWithTag:112]; //자산분류(대)
        tf.text = [fccInfoDic objectForKey:@"ZATEXT01"];

        tf = (UITextField*)[normalView viewWithTag:113]; //대분류코드
        tf.text = [fccInfoDic objectForKey:@"ZEQART1"];
        
        tf = (UITextField*)[normalView viewWithTag:114]; //자산분류(중)
        tf.text = [fccInfoDic objectForKey:@"ZATEXT02"];
        
        tf = (UITextField*)[normalView viewWithTag:115]; //중분류코드
        tf.text = [fccInfoDic objectForKey:@"ZEQART2"];
        
        tf = (UITextField*)[normalView viewWithTag:116]; //자산분류(소)
        tf.text = [fccInfoDic objectForKey:@"ZATEXT03"];
        
        tf = (UITextField*)[normalView viewWithTag:117]; //소분류코드
        tf.text = [fccInfoDic objectForKey:@"ZEQART3"];
        
        // 자산분류(세)
        [Util setScrollTouch:scrollZATEXT Label:lblZATEXT withString:[fccInfoDic objectForKey:@"ZATEXT04"]];

        tf = (UITextField*)[normalView viewWithTag:119]; //세분류코드
        tf.text = [fccInfoDic objectForKey:@"ZEQART4"];
        
        tf = (UITextField*)[normalView viewWithTag:120]; //품목구분
        tf.text = [fccInfoDic objectForKey:@"PTXT1"];

        tf = (UITextField*)[normalView viewWithTag:121]; //품목구분코드
        tf.text = [fccInfoDic objectForKey:@"ZPGUBUN"];
        
        tf = (UITextField*)[normalView viewWithTag:122]; //부품종류
        tf.text = [fccInfoDic objectForKey:@"PTXT2"];
        
        tf = (UITextField*)[normalView viewWithTag:123]; //부품종류코드
        tf.text = [fccInfoDic objectForKey:@"ZPPART"];
        
        tf = (UITextField*)[normalView viewWithTag:124]; //설비처리구분명
        tf.text = [fccInfoDic objectForKey:@"ZKEQUI_TXT"];
 
        tf = (UITextField*)[normalView viewWithTag:125]; //설비처리구분코드
        tf.text = [fccInfoDic objectForKey:@"ZKEQUI"];
        
        tf = (UITextField*)[normalView viewWithTag:126]; //자산번호
        tf.text = [fccInfoDic objectForKey:@"ZANLN1"];
        
        tf = (UITextField*)[normalView viewWithTag:127]; //최종변경자ID
        tf.text = [fccInfoDic objectForKey:@"ZPDAUSER"];
        
        tf = (UITextField*)[normalView viewWithTag:128]; //최종변경자명
        tf.text = [fccInfoDic objectForKey:@"ZPDAUSERNM"];

        

        tf = (UITextField*)[normalView viewWithTag:129]; //최종변경일
        tf.text = [NSString stringWithFormat:@"%@  %@",[fccInfoDic objectForKey:@"AEDAT"],[fccInfoDic objectForKey:@"CHANGED_TIME"]];
        
        tf = (UITextField*)[normalView viewWithTag:130]; //교체전설비
        tf.text = [fccInfoDic objectForKey:@"ZEQBR"];

        tf = (UITextField*)[normalView viewWithTag:131]; //교체후설비
        tf.text = [fccInfoDic objectForKey:@"ZEQRR"];
    }
}

// TODO.정보조회 도우미 >> 고장정보
- (void) fillFailureContent{
    
}

-(IBAction)touchMenuBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [self contentsShow:(int)btn.tag];
}

-(void)contentsShow:(int)tag{
        normalBtn.selected = NO;
        locBtn.selected = NO;
        orgBtn.selected = NO;
        warrantyBtn.selected = NO;
        failureBtn.selected = NO;
        failureListBtn.selected = NO;
        
        [normalView removeFromSuperview];
        [locView removeFromSuperview];
        [orgView removeFromSuperview];
        [warrantyView removeFromSuperview];
        [failureView removeFromSuperview];
        [failureListView removeFromSuperview];
        
        switch (tag) {
            case 10://일반
                normalBtn.selected = YES;
                [_scrollView addSubview:normalView];
                _scrollView.contentSize = normalView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                [self fillNormalContent];
                break;
            case 20://위치
                locBtn.selected = YES;
                [_scrollView addSubview:locView];
                _scrollView.contentSize = locView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                [self fillLocContent];
                break;
            case 30://조직
                orgBtn.selected = YES;
                [_scrollView addSubview:orgView];
                _scrollView.contentSize = orgView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                [self fillorgContent];
                break;
            case 40://보증
                warrantyBtn.selected = YES;
                [_scrollView addSubview:warrantyView];
                _scrollView.contentSize = warrantyView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                [self fillWarrantyContent];
                break;
            case 50://고장
                failureBtn.selected = YES;
                [_scrollView addSubview:failureView];
                _scrollView.contentSize = failureView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                [self fillFailureContent];
                break;
            case 60://고장이력
                failureListBtn.selected = YES;
                [_scrollView addSubview:failureListView];
                _scrollView.contentSize = failureListView.bounds.size;
                _scrollView.contentOffset = CGPointMake(0, 0);
                
                [_scrollView addSubview:_scrollView2];
                _scrollView2.frame = CGRectMake(0, 0, 320, PHONE_SCREEN_HEIGHT - 105);
                _scrollView2.contentSize = CGSizeMake(_tableView.bounds.size.width, _scrollView2.frame.size.height);
            
                listCount.frame = CGRectMake(0, (_scrollView2.frame.origin.y + _scrollView2.frame.size.height), 320, 22);
                                
                break;
        }
}

#pragma mark - Http Request Method
- (void)requestFccDetail:(NSString*)fccBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_DETAIL_SAP_FCC;
    
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
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:fccBarcode forKey:@"EQUNR"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_FAC_INQUERY_DETAIL withData:rootDic];
}

#pragma mark - Http Request Method
- (void)requestRepairHistoryList:(NSString*)fccBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_REPAIR_HISTORY;
    
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
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:fccBarcode forKey:@"EQUNR"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_GET_REPAIR_HISTORY withData:rootDic];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    if (indicatorView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
        self.view.userInteractionEnabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }

//    if (resultList != nil)
//        NSLog(@"Result List [%@]", resultList);
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (pid == REQUEST_SAP_FCC_COD){
                if ([message hasPrefix:@"데이터가 존재하지 않습니다."])
                    message = @"하위 설비가 존재하지 않습니다.";
            }
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
        return;
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
        
        return;
    }
    
    if (pid == REQUEST_DETAIL_SAP_FCC){
        if (resultList.count){
            fccInfoDic = [resultList objectAtIndex:0];
            [self fillNormalContent];
            [self requestRepairHistoryList:paramBarcode];
        }
    }
    
    if(pid == REQUEST_REPAIR_HISTORY){
        repairHistory = [NSMutableArray array];
        
        if (resultList.count){
            for (NSDictionary* dic in resultList)
            {
                NSMutableDictionary* repairDic = [NSMutableDictionary dictionary];
                
                [repairDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
                [repairDic setObject:[dic objectForKey:@"ERDAT"] forKey:@"ERDAT"];
                [repairDic setObject:[dic objectForKey:@"AUSBS"] forKey:@"AUSBS"];
                [repairDic setObject:[dic objectForKey:@"FECODN"] forKey:@"FECODN"];
                [repairDic setObject:[dic objectForKey:@"URSTX2"] forKey:@"URSTX2"];
                [repairDic setObject:[dic objectForKey:@"LIFNRN"] forKey:@"LIFNRN"];
                
                [repairHistory addObject:repairDic];
            }
        }
        [_tableView reloadData];
        
        if((int)[repairHistory count] > 0){
            listCount.text = [NSString stringWithFormat:@"%lu 건", (unsigned long)(int)[repairHistory count]];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [repairHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([repairHistory count]){
        NSDictionary* dic = [repairHistory objectAtIndex:indexPath.row];
        
        GridColumnRepairCell *cell = (GridColumnRepairCell*)[tableView dequeueReusableCellWithIdentifier:@"GridColumnRepairCell"];
        if (!cell){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridColumnRepairCell" owner:self options:nil];
            for (id object in nib)
            {
                if ([object isMemberOfClass:[GridColumnRepairCell class]])
                {
                    cell = object;
                    cell.lblColumn1.frame = CGRectMake(4, 0, 110, 40);
                    cell.lblColumn2.frame = CGRectMake(114, 0, 110,40);
                    cell.lblColumn3.frame = CGRectMake(224, 0, 110, 40);
                    cell.lblColumn4.frame = CGRectMake(334, 0, 160, 40);
                    cell.lblColumn5.frame = CGRectMake(494, 0, 160, 40);
                    cell.lblColumn6.frame = CGRectMake(654, 0, 160, 40);
                    break;
                }
            }
        }
        
        cell.lblColumn1.text = [dic objectForKey:@"ZEQUIPGC"];
        cell.lblColumn2.text = [dic objectForKey:@"ERDAT"];
        cell.lblColumn3.text = [dic objectForKey:@"AUSBS"];
        cell.lblColumn4.text = [dic objectForKey:@"FECODN"];
        cell.lblColumn5.text = [dic objectForKey:@"URSTX2"];
        cell.lblColumn6.text = [dic objectForKey:@"LIFNRN"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2000){
        if (buttonIndex == 0){
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

@end

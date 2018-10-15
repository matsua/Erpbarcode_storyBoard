//
//  GoodsInfoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "CommonCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GoodsInfoFirstTableCell.h"
#import "GoodsInfoSecondTableCell.h"
#import "ERPAlert.h"


@interface GoodsInfoViewController ()

- (void)reloadTwoTables;
- (void)loadScrollViewWithPage:(UIView *)page;
- (void)createPages;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (IBAction)changePage:(id)sender;

@property (strong, nonatomic) IBOutlet UIPageControl *_pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIView *firstTitleView;
@property (strong, nonatomic) IBOutlet UIView *secondTitleView;

@property(strong, nonatomic) UITableView* _firstTable;
@property(strong, nonatomic) UITableView* _secondTable;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property(nonatomic,strong) IBOutlet UITextField* txtGoodsCode;
@property(nonatomic,strong) IBOutlet UITextField* txtGoodsName;
@property (strong, nonatomic) IBOutlet UIButton *btnInit;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) NSArray* goodsList;
@property(nonatomic,strong) UILabel* lblCount;

@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,assign) BOOL isOffLine;
@end

@implementation GoodsInfoViewController


@synthesize btnInit;
@synthesize btnSelect;
@synthesize _firstTable;
@synthesize _secondTable;
@synthesize _pageControl;
@synthesize _scrollView;
@synthesize txtGoodsCode;
@synthesize txtGoodsName;
@synthesize goodsList;
@synthesize indicatorView;
@synthesize lblCount;
@synthesize JOB_GUBUN;
@synthesize nSelectedRow;

@synthesize delegate;

@synthesize btnSearch;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];

    self.title = [NSString stringWithFormat:@"물품정보%@", [Util getTitleWithServerNVersion]];

    self.navigationController.navigationBarHidden = NO;
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];

    if ([JOB_GUBUN isEqualToString:@"물품정보"]){
        btnSelect.hidden = YES;
        btnInit.hidden = YES;
        btnSearch.frame = CGRectMake(258, 5, 45, 30);
    }else if([JOB_GUBUN isEqualToString:@"바코드대체요청"] || [JOB_GUBUN isEqualToString:@"부외실물등록요청"]){
        btnInit.hidden = NO;
        btnSelect.hidden = NO;
    }

    [txtGoodsCode becomeFirstResponder];
    
    isOffLine = [[Util udObjectForKey:@"USER_OFFLINE"] boolValue];

    CGRect scrollViewRect = [_scrollView bounds];
    
    _scrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 2, 1);
    [self createPages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  user define method
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - User Action Method
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSearchBtn:(id)sender
{
    txtGoodsCode.text = [txtGoodsCode.text uppercaseString];
    txtGoodsName.text = [txtGoodsName.text uppercaseString];
    if (!txtGoodsCode.text.length && !txtGoodsName.text.length){
        [self showMessage:@"물품코드 또는 물품명을 입력하세요." tag:-1 title1:@"닫기" title2:@""];
        return;
    }

    if (txtGoodsCode.text.length && txtGoodsCode.text.length < 6){
        [self showMessage:@"물품코드를 6자리 이상 입력하세요." tag:-1 title1:@"닫기" title2:@""];
        return;
    }
    if (txtGoodsName.text.length && txtGoodsName.text.length < 3){
        [self showMessage:@"물품명을 3자리 이상 입력하세요." tag:-1 title1:@"닫기" title2:@""];
        return;
        
    }
    if (!isOffLine)
        [self requestGoodInfo];
    else{
        NSString* bismt = @"";
        NSString* matnr = @"";
        NSString* maktx = @"";
        
        if (txtGoodsCode.text.length)
            matnr = txtGoodsCode.text;
        if (txtGoodsName.text.length)
            maktx = txtGoodsName.text;
        
        NSString* errMsg;
        NSArray* resultList = [[DBManager sharedInstance] getGoodsSearchByMATNR:matnr MAKTX:maktx BISMT:bismt PDA_FLAG:YES ERROR_MSG:errMsg];
        
        if (resultList.count){
            goodsList = [NSArray arrayWithArray:resultList];
            lblCount.text = [NSString stringWithFormat:@"%d건",(int)[resultList count]];
            [self tableView:_firstTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [txtGoodsCode resignFirstResponder];
            [txtGoodsName resignFirstResponder];
        }
        else {
            NSString* message = @"물품 정보가 존재하지 않습니다.";
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
            
            lblCount.text = @"";
        }
        [self reloadTwoTables];
    }
}

- (IBAction)touchBackground:(id)sender
{
    [txtGoodsName resignFirstResponder];
    [txtGoodsCode resignFirstResponder];
}

- (IBAction)touchInitBtn:(id)sender {
    goodsList = [NSMutableArray array];
    
    txtGoodsCode.text = @"";
    txtGoodsName.text = @"";
    lblCount.text = @"";
    [txtGoodsName resignFirstResponder];
    [txtGoodsCode resignFirstResponder];
    [self reloadTwoTables];
}

- (IBAction)touchSelectBtn:(id)sender {
    
    if (!goodsList.count){
        NSString* message = @"물품을 선택하세요.";

        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        return;
    }
    
    NSDictionary* dic = [goodsList objectAtIndex:nSelectedRow];
    
    NSString* mtart;
    NSString* barcd;
    NSString* devType;
    NSString* comptype;
    
    if ([[dic objectForKey:@"MTART"] isKindOfClass:[NSNull class]])
        mtart = @"";
    else
        mtart = [dic objectForKey:@"MTART"];
    
    if ([[dic objectForKey:@"BARCD"] isKindOfClass:[NSNull class]])
        barcd = @"";
    else
        barcd = [dic objectForKey:@"BARCD"];
    
    if ([[dic objectForKey:@"ZMATGB"] isKindOfClass:[NSNull class]])
        devType = @"";
    else
        devType = [dic objectForKey:@"ZMATGB"];
    
    if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
        comptype = @"";
    else
        comptype = [dic objectForKey:@"COMPTYPE"];
    
    
    NSString* partType = [WorkUtil getPartTypeFullName:comptype device:devType];
    
    if ([devType isEqualToString:@"40"] && [partType isEqualToString:@"40"]){
        NSString* message = @"부품종류가 존재하지 않습니다.\n기준정보 관리자(MDM)에게\n문의하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];

        return;
    }
    
    if (![mtart isEqualToString:@"ERSA"] || ![barcd isEqualToString:@"Y"]){
        NSString* message = @"처리할 수 없는 물품코드입니다.\n(SAP 상의 자재유형이 'ERSA'가 아니거나 바코드라벨링이‘Y’가 아님)";

        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];

        return;
        
    }

    
    [delegate selectGoodsCode:dic];
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Http Request Method
- (void)requestGoodInfo
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_ITEM_FCC_COD;
    
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
    
    NSString* bismt = @"";
    NSString* matnr = @"";
    NSString* maktx = @"";
    
    if (txtGoodsCode.text.length)
        matnr = txtGoodsCode.text;
    if (txtGoodsName.text.length)
        maktx = txtGoodsName.text;
    
    [requestMgr requestFccItemInfo:bismt matnr:matnr maktx:maktx maktxEnable:YES];
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
        
    if (pid == REQUEST_ITEM_FCC_COD){
        if (resultList.count){
            goodsList = [NSArray arrayWithArray:resultList];
            lblCount.text = [NSString stringWithFormat:@"%d건",(int)[resultList count]];
            [self tableView:_firstTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [txtGoodsCode resignFirstResponder];
            [txtGoodsName resignFirstResponder];
        }
        else {
            NSString* message = @"물품 정보가 존재하지 않습니다.";
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
            
            lblCount.text = @"";
        }
        [self reloadTwoTables];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    textField.text = [textField.text uppercaseString];
    [textField resignFirstResponder];
    return YES;
}


- (void) reloadTwoTables
{
    [_firstTable reloadData];
    [_secondTable reloadData];
    
    return;
}


// 스크롤뷰에 페이지를 로드함
- (void)loadScrollViewWithPage:(UIView *)page
{
	int pageCount = (int)[[_scrollView subviews] count];
	
	CGRect bounds = _scrollView.bounds;
	bounds.origin.x = bounds.size.width * pageCount;
	bounds.origin.y = 0;
	page.frame = bounds;
	[_scrollView addSubview:page];
}

- (void)createPages
{
    if ([_scrollView.subviews count])
        for (UIView *subView in [_scrollView subviews])
            [subView removeFromSuperview];

    
	CGRect pageRect = [_scrollView bounds];
    CGRect tableRect = [_scrollView bounds];
    CGRect titleRect = CGRectMake(0, 0, 320, 44);
    tableRect.origin.y += titleRect.size.height;
    tableRect.size.height -= titleRect.size.height;

    
    // 첫번째 페이지 생성
    UIView* firstView = [[UIView alloc]initWithFrame:pageRect];
    firstView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.firstTitleView.frame = titleRect;
    [firstView addSubview:self.firstTitleView];
    
    _firstTable = [[UITableView alloc]initWithFrame:tableRect];
    _firstTable .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _firstTable.delegate = self;
    _firstTable.dataSource = self;
    _firstTable.tag = 1;
    _firstTable.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:_firstTable];
    
    [self loadScrollViewWithPage:firstView];

    // 두번째 페이지 생성
    UIView* secondView = [[UIView alloc]initWithFrame:pageRect];
    secondView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.secondTitleView.frame = titleRect;
    [secondView addSubview:self.secondTitleView];
    
    _secondTable = [[UITableView alloc]initWithFrame:tableRect];
    _secondTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _secondTable.delegate = self;
    _secondTable.dataSource = self;
    _secondTable.tag = 2;
    _secondTable.contentMode = UIViewContentModeScaleAspectFit;
    [secondView addSubview:_secondTable];
    
    [self loadScrollViewWithPage:secondView];
    
    return;
}


- (IBAction)changePage:(id)sender
{
    int page = (int)_pageControl.currentPage;
	
	// 지정된 페이지로 스크롤 뷰의 내용을 스크롤한다.
	CGRect frame = _scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [goodsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = [goodsList objectAtIndex:indexPath.row];


    if (tableView.tag == 1){
        static NSString *CellIdentifier = @"GoodsInfoFirstCellId";
        GoodsInfoFirstTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoFirstTableCell" owner:self options:nil];
            
            cell = arr[0];
        }
        NSString* devType = [dic objectForKey:@"ZMATGB"];
        NSString* partType = [dic objectForKey:@"COMPTYPE"];
        
        NSString* devPartName  = [WorkUtil getDeviceTypeName:devType];
        NSString* partTypeName = [WorkUtil getPartTypeName:partType device:devType];
        
        NSDictionary* partNameDic = [Util udObjectForKey:MAP_PART_NAME];
        NSString* partFullName = [partNameDic objectForKey:partTypeName];
        cell.lblCode.text = [dic objectForKey:@"MATNR"];
        cell.lblName.text = [dic objectForKey:@"MAKTX"];
        cell.lblDevPartName.text = devPartName;
        cell.lblPartFullName.text = partFullName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([JOB_GUBUN isEqualToString:@"바코드대체요청"] || [JOB_GUBUN isEqualToString:@"부외실물등록요청"])
            if (nSelectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;

        
        return cell;
    }else if (tableView.tag == 2){
        static NSString *CellIdentifier = @"GoodsInfoSecondCellId";
        GoodsInfoSecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoSecondTableCell" owner:self options:nil];
            
            cell = arr[0];
        }
        
        NSString* categoryName;
        if ([[dic objectForKey:@"ITEMCLASSIFICATIONNAME"] isKindOfClass:[NSNull class]])
            categoryName = @"";
        else
            categoryName = [dic objectForKey:@"ITEMCLASSIFICATIONNAME"];
        
        //제조사
        NSString* madefirm;
        if ([[dic objectForKey:@"ZEMAFT_NAME"] isKindOfClass:[NSNull class]])
            madefirm = @"";
        else
            madefirm = [dic objectForKey:@"ZEMAFT_NAME"];
       
        //자재유형
        NSString* materialType;
        if ([[dic objectForKey:@"MTART"] isKindOfClass:[NSNull class]])
            materialType = @"";
        else
            materialType = [dic objectForKey:@"MTART"];
        
        //바코드 라벨링 여부
        NSString* barcodeYN;
        if ([[dic objectForKey:@"BARCD"] isKindOfClass:[NSNull class]])
            barcodeYN = @"";
        else
            barcodeYN = [dic objectForKey:@"BARCD"];
        
        cell.lblCategoryName.text = categoryName;
        cell.lblMadeFirm.text = madefirm;
        cell.lblMeterialType.text = materialType;
        cell.lblBarcodeYN.text = barcodeYN;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([JOB_GUBUN isEqualToString:@"바코드대체요청"] || [JOB_GUBUN isEqualToString:@"부외실물등록요청"])
            if (nSelectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;

        return cell;
    }
    


    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self reloadTwoTables];
}

//  셀 선택이 가능한 경우 테이블 두개의 선택 싱크를 맞추기 위함
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.

    nSelectedRow = indexPath.row;
    [self reloadTwoTables];
}


#pragma mark - UIScrollViewDelegate
// 스크롤시 페이지 위치 설정
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2)
					 / pageWidth) + 1;
    _pageControl.currentPage = page;
    
    
    // 두개의 테이블이 동시에 움직일 수 있도록 하기 위해 추가한 코드임.
    UITableView *slaveTable = nil;
    
    if (_firstTable == scrollView) {
        slaveTable = _secondTable;
    } else if (_secondTable == scrollView) {
        slaveTable = _firstTable;
    }
    
    [slaveTable setContentOffset:scrollView.contentOffset];
}

@end

//
//  WBSListViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 16..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "WBSListViewController.h"
#import "SelectWBSFirstPageCell.h"
#import "SelectWBSSecondPageCell.h"
#import "SelectWBSto2PageCell.h"
#import "SelectWBSto3PageCell.h"

@interface WBSListViewController ()

@end

@implementation WBSListViewController

@synthesize _pageCtrl;
@synthesize _scrollView;

@synthesize page1TitleView;
@synthesize page2TitleView;
@synthesize toPage2TitleView;
@synthesize toPage3TitleView;

@synthesize _tblFirst;
@synthesize _tblSecond;
@synthesize _tblThird;

@synthesize delegate;
@synthesize wbsList;
@synthesize selectedRow;
@synthesize selectedWBSNo;
@synthesize JOB_GUBUN;



///////////////////////////////////////////////////////////////////////////////

#pragma User Define Method

- (void)createPages
{
    if ([_scrollView.subviews count])
        for (UIView *subView in [_scrollView subviews])
            [subView removeFromSuperview];
    
    
	CGRect pageRect = [_scrollView bounds];
    CGRect tableRect = [_scrollView bounds];
    CGRect titleRect = CGRectMake(0, 0, 320, 40);
    tableRect.origin.y += titleRect.size.height;
    tableRect.size.height -= titleRect.size.height;
    
    
    // 첫번째 페이지 생성
    UIView* firstView = [[UIView alloc]initWithFrame:pageRect];
    firstView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    page1TitleView.frame = titleRect;
    [firstView addSubview:page1TitleView];
    
    _tblFirst = [[UITableView alloc]initWithFrame:tableRect];
    _tblFirst .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tblFirst.delegate = self;
    _tblFirst.dataSource = self;
    _tblFirst.tag = 1;
    _tblFirst.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:_tblFirst];
    
    [self loadScrollViewWithPage:firstView];
    
    if ([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"]){
        // 두번째 페이지 생성
        UIView* secondView = [[UIView alloc]initWithFrame:pageRect];
        secondView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        toPage2TitleView.frame = titleRect;
        [secondView addSubview:toPage2TitleView];
        
        _tblSecond = [[UITableView alloc]initWithFrame:tableRect];
        _tblSecond.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tblSecond.delegate = self;
        _tblSecond.dataSource = self;
        _tblSecond.tag = 2;
        _tblSecond.contentMode = UIViewContentModeScaleAspectFit;
        [secondView addSubview:_tblSecond];
        
        [self loadScrollViewWithPage:secondView];
        

        // 세번째 페이지 생성
        UIView* thirdView = [[UIView alloc]initWithFrame:pageRect];
        thirdView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        toPage3TitleView.frame = titleRect;
        [thirdView addSubview:toPage3TitleView];
        
        _tblThird = [[UITableView alloc]initWithFrame:tableRect];
        _tblThird.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tblThird.delegate = self;
        _tblThird.dataSource = self;
        _tblThird.tag = 3;
        _tblThird.contentMode = UIViewContentModeScaleAspectFit;
        [thirdView addSubview:_tblThird];
        
        [self loadScrollViewWithPage:thirdView];
        
        
        CGRect scrollViewRect = [_scrollView bounds];
        _scrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 3, 1);
    }else{
        // 두번째 페이지 생성
        UIView* secondView = [[UIView alloc]initWithFrame:pageRect];
        secondView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        page2TitleView.frame = titleRect;
        [secondView addSubview:page2TitleView];
        
        _tblSecond = [[UITableView alloc]initWithFrame:tableRect];
        _tblSecond.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tblSecond.delegate = self;
        _tblSecond.dataSource = self;
        _tblSecond.tag = 2;
        _tblSecond.contentMode = UIViewContentModeScaleAspectFit;
        [secondView addSubview:_tblSecond];
        
        [self loadScrollViewWithPage:secondView];
        
        
        CGRect scrollViewRect = [_scrollView bounds];
        _scrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 2, 1);
    }

    _tblFirst.multipleTouchEnabled = NO;
    _tblSecond.multipleTouchEnabled = NO;
    _tblThird.multipleTouchEnabled = NO;
    
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


/////////////////////////////////////////////////////////////////////////////////


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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.title = @"WBS 선택";
    
    [self createPages];

    if (wbsList.count > 0){
        [self tableView:_tblFirst didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [wbsList count];
}
//self.viewBg.backgroundColor = RGB(203, 249, 181);

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([JOB_GUBUN isEqualToString:@"인계"] || [JOB_GUBUN isEqualToString:@"인수"]){
        if (tableView.tag == 1){
            static NSString *CellIdentifier = @"SelectWBSFirstPageCellId";
            SelectWBSFirstPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SelectWBSFirstPageCell" owner:self options:nil];
                
                cell = arr[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary* dic = wbsList[indexPath.row];
            NSString* name = [dic objectForKey:@"NAME1"];
            NSString* posid = [dic objectForKey:@"POSID"];
            
            cell.lblCompany.text = name;
            cell.lblWBSNo.text = posid;
            
            if (selectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;
            else
                cell.viewBg.backgroundColor = [UIColor clearColor];

            return cell;
        }else if (tableView.tag == 2){
            static NSString *CellIdentifier = @"SelectWBSto2PageCellId";
            SelectWBSto2PageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SelectWBSto2PageCell" owner:self options:nil];
                
                cell = arr[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary* dic = wbsList[indexPath.row];
            NSString* workType = [dic objectForKey:@"ZPJT_CODET"];
            NSString* wbsContent = [dic objectForKey:@"POST1"];
            
            cell.lblWorkKind.text = workType;
            cell.wbsContent.text = wbsContent;
            
            if (selectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;
            else
                cell.viewBg.backgroundColor = [UIColor clearColor];
            return cell;
        }else if (tableView.tag == 3){
            static NSString *CellIdentifier = @"SelectWBSto3PageCellId";
            SelectWBSto3PageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SelectWBSto3PageCell" owner:self options:nil];
                
                cell = arr[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary* dic = wbsList[indexPath.row];
            NSString* status = [dic objectForKey:@"STATUS"];
            NSString* wbsStatus;
            if ([status isEqualToString:@"01"])
                wbsStatus = @"01-생성(TRTD)";
            else if ([status isEqualToString:@"02"])
                wbsStatus = @"02-릴리즈(REL)";
            else if ([status isEqualToString:@"03"])
                wbsStatus = @"03-종료(CLSD)";
            NSString* costCenterStatus = [dic objectForKey:@"KOSTL_STATUS"];
            
            cell.lblWBSStatus.text = wbsStatus;
            cell.lblCostCenterStatus.text = costCenterStatus;
            
            if (selectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;
            else
                cell.viewBg.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
    }
    else{        
        if (tableView.tag == 1){
            static NSString *CellIdentifier = @"SelectWBSFirstPageCellId";
            SelectWBSFirstPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SelectWBSFirstPageCell" owner:self options:nil];
                
                cell = arr[0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSDictionary* dic = wbsList[indexPath.row];
            NSString* name = [dic objectForKey:@"NAME1"];
            NSString* posid = [dic objectForKey:@"POSID"];
            
            cell.lblCompany.text = name;
            cell.lblWBSNo.text = posid;
            
            if (selectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;
            else
                cell.viewBg.backgroundColor = [UIColor clearColor];

            return cell;
        }else if (tableView.tag == 2){
            static NSString *CellIdentifier = @"SelectWBSSecondPageCellId";
            SelectWBSSecondPageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"SelectWBSSecondPageCell" owner:self options:nil];
                
                cell = arr[0];
            }
            NSDictionary* dic = wbsList[indexPath.row];
            NSString* post1 = [dic objectForKey:@"POST1"];
            
            cell.lblWBSContent.text = post1;
            
            if (selectedRow == indexPath.row)
                cell.viewBg.backgroundColor = COLOR_SCAN1;
            else
                cell.viewBg.backgroundColor = [UIColor clearColor];

            return cell;
        }
        
    }
        
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tblFirst reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblSecond reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblThird reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//  셀 선택이 가능한 경우 테이블 두개의 선택 싱크를 맞추기 위함
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger prevSel = selectedRow;
    NSDictionary* dic = wbsList[indexPath.row];
    selectedRow = indexPath.row;
    selectedWBSNo = [dic objectForKey:@"POSID"];
    
    [_tblFirst reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:prevSel inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblSecond reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:prevSel inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblThird reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:prevSel inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];

    [_tblFirst reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblSecond reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblThird reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (IBAction)selectButton:(id)sender {
    BOOL result = TRUE;
    
    if ([JOB_GUBUN isEqualToString:@"인계"] ||[JOB_GUBUN isEqualToString:@"인수"] ||
        [JOB_GUBUN isEqualToString:@"시설등록"] ){
        NSDictionary* dic = wbsList[selectedRow];
        
        if ([[dic objectForKey:@"STATUS"] isEqualToString:@"03"] ||
            [[dic objectForKey:@"KOSTL_STATUS"] hasPrefix:@"X"]){
            result = FALSE;
            
            UIAlertView* av;
        
            NSString* message = [NSString stringWithFormat:@"WBS번호 '%@'의 \n코스트센터 상태가 '폐지'이므로\n선택하실 수 없습니다.\n공사 담당자에게 문의하시기 바랍니다.", [dic objectForKey:@"POSTID"]];
            av = [[UIAlertView alloc]
                  initWithTitle:@"알림"
                  message:message
                  delegate:nil
                  cancelButtonTitle:nil
                  otherButtonTitles:@"닫기", nil];
            [av show];
            [Util playSoundWithMessage:message isError:NO];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [delegate setWBSNo:selectedWBSNo withResult:result];
}

- (IBAction)cancelButton:(id)sender {
    selectedWBSNo = @"";
    selectedRow = -1;
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    [delegate cancelSelectWBSNo];
}

- (IBAction)changePage:(id)sender {
    int page = (int)_pageCtrl.currentPage;
	
	// 지정된 페이지로 스크롤 뷰의 내용을 스크롤한다.
	CGRect frame = _scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[_scrollView scrollRectToVisible:frame animated:YES];
}


@end

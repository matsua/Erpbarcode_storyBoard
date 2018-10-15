//
//  WorkDataViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 8..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "WorkDataViewController.h"
#import "GridColumn2Cell.h"
#import "GridColumn3Cell.h"
#import "GridNoBtn2Cell.h"
#import "BuyOutIntoViewController.h"
#import "OutIntoViewController.h"
#import "AppDelegate.h"
#import "SpotCheckViewController.h"
#import "RevisionViewController.h"
#import "TakeOverNRegEquipViewController.h"
#import "MainMenuViewController.h"
#import "ERPAlert.h"

@interface WorkDataViewController ()
@property(nonatomic,strong) NSMutableArray* fetchList;
@property(nonatomic,assign) NSInteger nSelectedRow;
@end

@implementation WorkDataViewController
@synthesize indicatorView;
@synthesize fetchList;
@synthesize btnDate;
@synthesize btnSendResult;
@synthesize btnWork;
@synthesize _scrollView;
@synthesize _tableView1;
@synthesize _tableView2;
@synthesize _tableView3;
@synthesize _tableView4;
@synthesize pvDate;
@synthesize pvSendResult;
@synthesize pvWorkName;
@synthesize columnHeaderView;
@synthesize columnHeaderView2;
@synthesize columnHeaderView3;
@synthesize columnHeaderView4;
@synthesize lblColumnHeader11;
@synthesize lblColumnHeader12;
@synthesize lblColumnHeader21;
@synthesize lblColumnHeader22;
@synthesize lblColumnHeader31;
@synthesize lblColumnHeader32;
@synthesize lblColumnHeader41;
@synthesize lblColumnHeader42;
@synthesize strSelDate;
@synthesize strSelWorkName;
@synthesize strSelSendResult;
@synthesize nSelectedRow;

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
    self.title = @"작업관리";
    
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.contentSize = CGSizeMake(_tableView1.bounds.size.width*4, _scrollView.frame.size.height);
    nSelectedRow = -1;
    
    fetchList = [NSMutableArray array];
    
    [self initPickerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndJob:) name:RCV_END_JOB object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCV_END_JOB object:nil];
}

#pragma End_Job Notification
- (void)EndJob
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
}

#pragma mark - DB function
- (void)fetchWorkData
{
    NSString* strSqlQuery = SELECT_WORK_DATA;
    if (pvWorkName.selectedIndex != 0)
        strSqlQuery = [strSqlQuery stringByAppendingFormat:@"AND WORK_CD ='%@' ",[WorkUtil getWorkCode:strSelWorkName]];
    if (pvDate.selectedIndex != 0)
        strSqlQuery = [strSqlQuery stringByAppendingFormat:@"AND strftime('%%Y-%%m-%%d',SAVE_TIME) ='%@' ",strSelDate];

    if (pvSendResult.selectedIndex != 0){
        NSString* strTransaction;
        if ([strSelSendResult isEqualToString:@"미전송"])
            strTransaction = @"N";
        else if ([strSelSendResult isEqualToString:@"전송성공"])
            strTransaction = @"S";
        else if ([strSelSendResult isEqualToString:@"전송실패"])
            strTransaction = @"E";
        
        strSqlQuery = [strSqlQuery stringByAppendingFormat:@"AND TRANSACT_YN ='%@' ",strTransaction];
    }
    strSqlQuery = [strSqlQuery stringByAppendingString:@" ORDER BY SAVE_TIME DESC"];
    
//    NSLog(@"%@",strSqlQuery);
    fetchList = [[DBManager sharedInstance] executeSelectQuery:strSqlQuery];

    [self reloadTables];
//    NSLog(@"fetchList %@",fetchList);
}


#pragma mark - UserDefine Method
- (void) reloadTables
{
    [_tableView1 reloadData];
    [_tableView2 reloadData];
    [_tableView3 reloadData];
    [_tableView4 reloadData];

}
- (void) initPickerData
{
    NSArray* fetchWorkList = [[DBManager sharedInstance] executeSelectQuery:SELECT_PICKER_WORK];
    NSMutableArray* WorkList = [NSMutableArray array];
    [WorkList addObject:@"-전체-"];
    
    for (NSDictionary* dic in fetchWorkList) {
        NSString* workCode = [dic objectForKey:@"WORK_CD"];
        if (workCode.length !=2) {
            continue;
        }
        [WorkList addObject:[WorkUtil getWorkName:workCode]];
        
    }

    strSelWorkName = @"-전체-";
    [btnWork setTitle:@"-전체-" forState:UIControlStateNormal];
    pvWorkName = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:WorkList];
    pvWorkName.delegate = self;
    
    NSArray* fetchWorkDateList = [[DBManager sharedInstance] executeSelectQuery:SELECT_PICKER_DATE];
    NSMutableArray* WorkDateList = [NSMutableArray array];
    [WorkDateList addObject:@"-전체-"];
    
    for (NSDictionary* dic in fetchWorkDateList) {
         NSString* workDate = [dic objectForKey:@"SAVE_TIME"];
        if (workDate != nil)
            [WorkDateList addObject:workDate];
    }
    
    strSelDate = @"-전체-";
    [btnDate setTitle:@"-전체-" forState:UIControlStateNormal];
    pvDate = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:WorkDateList];
    pvDate.delegate = self;

    strSelSendResult = @"-전체-";
    [btnSendResult setTitle:@"-전체-" forState:UIControlStateNormal];
    pvSendResult = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"-전체-",@"미전송",@"전송성공", @"전송실패"]];
    pvSendResult.delegate = self;
    
    [self fetchWorkData];
}

- (void) touchBackBtn:(id)sender
{
    if (pvSendResult.isShow)
        [pvSendResult hideView];
    else if (pvDate.isShow)
        [pvDate hideView];
    else if (pvWorkName.isShow)
        [pvWorkName hideView];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)showWorkPickerView:(id)sender {
    if (pvSendResult.isShow)
        [pvSendResult hideView];
    else if (pvDate.isShow)
        [pvDate hideView];
    [pvWorkName showView];
}

- (IBAction)showDatePicker:(id)sender {
    if (pvWorkName.isShow)
        [pvWorkName hideView];
    else if (pvSendResult.isShow)
        [pvSendResult hideView];
    [pvDate showView];
}

- (IBAction)showSendResultPicker:(id)sender {
    if (pvWorkName.isShow)
        [pvWorkName hideView];
    else if (pvDate.isShow)
        [pvDate hideView];
    [pvSendResult showView];
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


// 작업 선택하여 실행
- (IBAction)touchOK:(id)sender {
    if (!fetchList.count) return;

    NSDictionary* selItemDic;
    if (nSelectedRow >= 0){
        selItemDic = [fetchList objectAtIndex:nSelectedRow];
    }
    if (!selItemDic.count){
        
        NSMutableArray *tempList = [NSMutableArray array];
        for (int i = 0; i < [fetchList count]; i++){
            if([[[fetchList objectAtIndex:i] objectForKey:@"IS_SELECTED"] boolValue]){
                [tempList addObject:[fetchList objectAtIndex:i]];
            }
        }
        
        if([tempList count] > 1){
            [self showMessage:@"작업내역은 한개의 작업만 선택 가능 합니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        if([tempList count] == 0){
            [self showMessage:@"선택한 자료가 없습니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        selItemDic = [tempList objectAtIndex:0];
    }
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];

    NSString* WORK_CD = [selItemDic objectForKey:@"WORK_CD"];
    
    [Util udSetObject:@"Y" forKey:USER_WORK_MODE]; //작업모드
    [Util udSetObject:[WorkUtil getWorkName:WORK_CD] forKey:USER_WORK_NAME];
    
    MainMenuViewController* mainVc = [[MainMenuViewController alloc] init];
    
    // WORK_CD는 메인메뉴 순서(0 ~ 7)와 서브메뉴의 순서(0 ~ 9)
    // 예> 납품입고는 메인메뉴 순서 0, 서브메뉴순서 0 => "00"
    if (
        [WORK_CD isEqualToString:@"63"] // 임대단말실사
        )
    {
        BuyOutIntoViewController* vc = [[BuyOutIntoViewController alloc] init];
        vc.dbWorkDic = selItemDic;
        self.navigationController.viewControllers = @[mainVc,vc];
    }
    else if (
            [WORK_CD isEqualToString:@"00"] ||  // 납품입고
            [WORK_CD isEqualToString:@"01"] ||  // 납품취소
            [WORK_CD isEqualToString:@"02"] ||  // 배송출고
            [WORK_CD isEqualToString:@"10"] ||  // 입고(팀내)
            [WORK_CD isEqualToString:@"11"] ||  // 출고(팀내)
            [WORK_CD isEqualToString:@"12"] ||  // 실장
            [WORK_CD isEqualToString:@"13"] ||  // 탈장
            [WORK_CD isEqualToString:@"14"] ||  // 송부(팀간)
            [WORK_CD isEqualToString:@"15"] ||  // 송부취소(팀간)
            [WORK_CD isEqualToString:@"16"] ||  // 접수(팀간)
            [WORK_CD isEqualToString:@"30"] ||  // 고장등록
            [WORK_CD isEqualToString:@"40"] ||  // 철거관리
            [WORK_CD isEqualToString:@"50"] ||  // 설비상태변경
            [WORK_CD isEqualToString:@"71"] ||   // 설비정보
            [WORK_CD isEqualToString:@"17"] ||   // 형상구성(창고내)
            [WORK_CD isEqualToString:@"18"]    // 형상해제(창고내)
        )
    {
        OutIntoViewController* vc = [[OutIntoViewController alloc] init];
        vc.dbWorkDic = selItemDic;
        self.navigationController.viewControllers = @[mainVc,vc];
    }
    else if (
             [WORK_CD isEqualToString:@"31"] || // 고장등록취소
             [WORK_CD isEqualToString:@"32"] || // 수리의뢰취소
             [WORK_CD isEqualToString:@"33"] || // 수리완료
             [WORK_CD isEqualToString:@"34"] || // 개조개량의뢰
             [WORK_CD isEqualToString:@"35"] || // 개조개량의뢰취소
             [WORK_CD isEqualToString:@"36"] || // 개조개량완료
             [WORK_CD isEqualToString:@"51"] || // S/N변경
             [WORK_CD isEqualToString:@"80"]    // 위치바코드
             ){
        RevisionViewController* vc = [[RevisionViewController alloc] init];
        vc.dbWorkDic = selItemDic;
        self.navigationController.viewControllers = @[mainVc,vc];
    }
    else if (
             [WORK_CD isEqualToString:@"60"] || // 현장점검(창고/실)
             [WORK_CD isEqualToString:@"61"]  // 현장점검(베이)
             )
    {
        SpotCheckViewController* vc = [[SpotCheckViewController alloc] init];
        vc.dbWorkDic = selItemDic;
        self.navigationController.viewControllers = @[mainVc,vc];
    }
    else if (
             [WORK_CD isEqualToString:@"03"] || // 인계
             [WORK_CD isEqualToString:@"04"] || // 인수
             [WORK_CD isEqualToString:@"05"]){  // 시설등록
        TakeOverNRegEquipViewController* vc = [[TakeOverNRegEquipViewController alloc]init];
        vc.dbWorkDic = selItemDic;
        self.navigationController.viewControllers = @[mainVc, vc];
    }
}

// 삭제
- (IBAction)touchDel:(id)sender {
    if (fetchList.count){
        // 체크박스에 선택된 리스트 생성
        NSIndexSet* deleteIndexSet = [WorkUtil getSelectedGridIndexes:fetchList];
        NSMutableArray *deleteIndexPaths = [NSMutableArray array];
        
        // 선택된 리스트에 해당하는  Dictionary에서 키인 ID로 DB에서 삭제하고, 화면에서도 삭제한다.
        __block int successCount = 0;
        if (deleteIndexSet.count){
            [deleteIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
                [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                NSDictionary* dic = [fetchList objectAtIndex:index];
                NSString *sqlQuery = [NSString stringWithFormat:DELETE_TABLE_WORK_INFO, [[dic objectForKey:@"ID"] intValue]];
                if ([[DBManager sharedInstance] executeQuery:sqlQuery])
                {
                    successCount++;
                }

            }];
            if (deleteIndexPaths.count == successCount){
                [fetchList removeObjectsAtIndexes:deleteIndexSet];
                [self reloadTables];
            }
        }
    }
}

- (IBAction)touchClose:(id)sender {
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    if (sender == pvWorkName)
        [pvWorkName hideView];
    else if (sender == pvDate)
        [pvDate hideView];
    if (sender == pvSendResult)
        [pvSendResult hideView];
}

- (void)onDone:(NSString *)data sender:(id)sender {
    if (sender == pvWorkName){
        strSelWorkName = data;
        [btnWork setTitle:strSelWorkName forState:UIControlStateNormal];
        [pvWorkName hideView];

    }
    else if (sender == pvDate){
        strSelDate = data;
        [btnDate setTitle:strSelDate forState:UIControlStateNormal];
        [pvDate hideView];
    }
    else if (sender == pvSendResult){
        strSelSendResult = data;
        [btnSendResult setTitle:strSelSendResult forState:UIControlStateNormal];
        [pvSendResult hideView];
    }
    //작업명으로 가져온다.
    [self fetchWorkData];
}

- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    if (fetchList.count) {
        NSMutableDictionary* selectItem = [fetchList objectAtIndex:btn.tag];
        [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
        [_tableView1 reloadData];
    }    
}

- (IBAction)touchedSelectAllBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    for (NSMutableDictionary* dic in fetchList) {
        NSMutableDictionary* selectItem = dic;
        [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
        [_tableView1 reloadData];
    }
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    nSelectedRow = indexPath.row;
  
    [self reloadTables];
    
    if (tableView == _tableView1){
        GridColumn2Cell* cell = (GridColumn2Cell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR_SCAN1;
    }
    else if (tableView == _tableView2){
        GridNoBtn2Cell* cell = (GridNoBtn2Cell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR_SCAN1;
    }
    else if (tableView == _tableView3){
        GridNoBtn2Cell* cell = (GridNoBtn2Cell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR_SCAN1;
    }
    
    else if (tableView == _tableView4){
        GridNoBtn2Cell* cell = (GridNoBtn2Cell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = COLOR_SCAN1;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return [fetchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (fetchList.count){
        NSDictionary* cellItemDic = [fetchList objectAtIndex:indexPath.row];
        if (tableView == _tableView1){
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
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [fetchList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
            
            cell.lblColumn1.text = [WorkUtil getWorkName:[cellItemDic objectForKey:@"WORK_CD"]];//작업구분
            cell.lblColumn2.text = [cellItemDic objectForKey:@"SAVE_TIME"]; //작업시간
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (nSelectedRow == indexPath.row)
                cell.contentView.backgroundColor = COLOR_SCAN1;
            else
                cell.contentView.backgroundColor = [UIColor clearColor];

            return cell;
        }
        else if (tableView == _tableView2){
            GridNoBtn2Cell *cell = (GridNoBtn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridNoBtn2Cell"];
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridNoBtn2Cell" owner:self options:nil];
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridNoBtn2Cell class]])
                    {
                        cell = object;
                         break;
                    }
                }
            }
            cell.lblColumn1.frame = CGRectMake(1, 0, 70, 40);
            cell.lblColumn2.frame = CGRectMake(72, 0, 246, 40);
            
            NSString* transact_YN = [cellItemDic objectForKey:@"TRANSACT_YN"]; //전송여부
            if ([transact_YN isEqualToString:@"S"])
                cell.lblColumn1.text = @"전송성공";
            else if ([transact_YN isEqualToString:@"E"])
                cell.lblColumn1.text = @"전송실패";
            else if ([transact_YN isEqualToString:@"N"])
                cell.lblColumn1.text = @"미전송";
            cell.lblColumn2.text = [cellItemDic objectForKey:@"TRANSACT_MSG"]; //전송메세지
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nSelectedRow == indexPath.row)
                cell.contentView.backgroundColor = COLOR_SCAN1;
            else
                cell.contentView.backgroundColor = [UIColor clearColor];

            return cell;
        }
        else if (tableView == _tableView3){
            GridNoBtn2Cell *cell = (GridNoBtn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridNoBtn2Cell"];
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridNoBtn2Cell" owner:self options:nil];
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridNoBtn2Cell class]])
                    {
                        cell = object;
                         break;
                    }
                }
            }
            cell.lblColumn1.frame = CGRectMake(1, 0, 178, 40);
            cell.lblColumn2.frame = CGRectMake(180, 0,138, 40);
            
            cell.lblColumn1.text = [cellItemDic objectForKey:@"LOC_CD"]; //위치바코드
            cell.lblColumn2.text = [cellItemDic objectForKey:@"DEVICE_ID"]; //장치아이디
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nSelectedRow == indexPath.row)
                cell.contentView.backgroundColor = COLOR_SCAN1;
            else
                cell.contentView.backgroundColor = [UIColor clearColor];

            return cell;
        }
        else if (tableView == _tableView4){
            GridNoBtn2Cell *cell = (GridNoBtn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridNoBtn2Cell"];
            if (!cell){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridNoBtn2Cell" owner:self options:nil];
                for (id object in nib)
                {
                    if ([object isMemberOfClass:[GridNoBtn2Cell class]])
                    {
                        cell = object;
                         break;
                    }
                }
            }
            cell.lblColumn1.frame = CGRectMake(1, 0, 151, 40);
            cell.lblColumn2.frame = CGRectMake(153, 0,167, 40);
            
            cell.lblColumn1.text = [cellItemDic objectForKey:@"WBS"]; //WBS번호
            cell.lblColumn2.text = [cellItemDic objectForKey:@"OFFLINE"]; //음영지역 작업여부
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nSelectedRow == indexPath.row)
                cell.contentView.backgroundColor = COLOR_SCAN1;
            else
                cell.contentView.backgroundColor = [UIColor clearColor];

            return cell;
        }
    }
    return nil;
}
@end

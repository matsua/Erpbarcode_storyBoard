//
//  OrgSearchViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "OrgSearchViewController.h"
#import "OrgSearchCell.h"
#import "OutIntoViewController.h"
#import "SpotCheckViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"

@interface OrgSearchViewController ()
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) NSMutableArray* insertIndexPaths;
@property(nonatomic,strong) NSIndexPath* selectedPath;
@property(nonatomic,strong) NSMutableArray* insertItems;
@property(nonatomic,strong) NSMutableArray* deleteItems;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) IBOutlet UITextField* txtOrgName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblOrgNameTitle;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSearch;
@end

@implementation OrgSearchViewController
@synthesize _tableView;
@synthesize indicatorView;
@synthesize orgList;
@synthesize insertItems;
@synthesize deleteItems;
@synthesize selectedPath;
@synthesize insertIndexPaths;
@synthesize JOB_GUBUN;
@synthesize txtOrgName;
@synthesize Sender;
@synthesize isSearchMode;
@synthesize lblOrgNameTitle;
@synthesize btnSearch;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = NO;
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = @"조직 선택";
    
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];

    if ([JOB_GUBUN isEqualToString:@"접수(팀간)"]){
        lblOrgNameTitle.hidden = YES;
        txtOrgName.hidden = YES;
        btnSearch.hidden = YES;
    }
 
    if (!isSearchMode){
        NSArray* udOrgList = [Util udObjectForKey:LIST_ORG];
        orgList = [NSMutableArray arrayWithArray:udOrgList];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Http Request method
- (void) requestTreeSearchOrg:(NSString*)rootOrgCode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEARCH_ORG;
    
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
    
    [requestMgr requestSearchRootOrgCode:rootOrgCode];
}

- (void) requestNameSearchOrg:(NSString*)searchText
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEARCH_ORG_NAME;
    
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
    NSMutableDictionary * preParam = [NSMutableDictionary dictionary];
    [preParam setObject:searchText forKey:@"key"];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];    
    [paramDic setObject:preParam forKey:@"orgName"];
    
    [requestMgr asychronousConnectToServer:API_NAME_SEARCH_ORG withData:paramDic];
    isSearchMode = YES;
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
    
    if (pid == REQUEST_SEARCH_ORG){
        [self processSearchOrg:resultList];
    }else if (pid == REQUEST_SEARCH_ORG_NAME){
        [self processSearchOrgName:resultList];
    }
}

- (void)processSearchOrg:(NSArray*)resultList
{
    if ([resultList count]){
        insertItems = [NSMutableArray array];
        insertIndexPaths = [NSMutableArray array];
        
        NSInteger listIdx = selectedPath.row+1;
        NSMutableDictionary* selDic = [orgList objectAtIndex:selectedPath.row];
        [selDic setObject:@"0" forKey:@"HAS_TFT"];
        for (NSDictionary* dic in resultList){
            NSMutableDictionary* orgDic = [NSMutableDictionary dictionary];
            NSString* orgCode = [dic objectForKey:@"orgCode"];
            NSArray* filterArray = [orgCode componentsSeparatedByString:@"@"];
            
            [orgDic setObject:[filterArray objectAtIndex:0] forKey:@"orgCode"];
            [orgDic setObject:[dic objectForKey:@"orgName"] forKey:@"orgName"];
            [orgDic setObject:[dic objectForKey:@"parentOrgCode"] forKey:@"parentOrgCode"];
            [orgDic setObject:[dic objectForKey:@"costCenter"] forKey:@"costCenter"];
            [orgDic setObject:[dic objectForKey:@"orgLevel"] forKey:@"orgLevel"];
            [orgDic setObject:[NSNumber numberWithInteger:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            
            
            if ([[dic objectForKey:@"orgName"] rangeOfString:@"TFT"].length > 0 || [[dic objectForKey:@"orgName"] rangeOfString:@"CTF"].length > 0 || [[dic objectForKey:@"orgName"] rangeOfString:@"TF"].length > 0)
                [selDic setObject:@"1" forKey:@"HAS_TFT"];
            
            [insertItems addObject:orgDic];
            
            NSIndexPath *newIdxPath = [NSIndexPath indexPathForRow:listIdx inSection:selectedPath.section];
            [insertIndexPaths addObject:newIdxPath];
            [orgList insertObject:orgDic atIndex:listIdx++];
        }
        
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
    }
    else {//데이터 없을경우 처리
        
        NSDictionary *dic = [orgList objectAtIndex:selectedPath.row];
        NSMutableDictionary *selItemDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [selItemDic setObject:[NSNumber numberWithInteger:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
        [orgList replaceObjectAtIndex:selectedPath.row withObject:selItemDic];
        
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)processSearchOrgName:(NSArray*)resultList
{
    if ([resultList count]){
        orgList = [NSMutableArray array];
        for (NSDictionary* dic in resultList){
            NSString* orgCode = [dic objectForKey:@"orgCode"];
            if (!orgCode.length) continue;
            NSMutableDictionary* orgDic = [NSMutableDictionary dictionary];
            NSArray* filterArray = [orgCode componentsSeparatedByString:@"@"];
            
            [orgDic setObject:[filterArray objectAtIndex:0] forKey:@"orgCode"];
            [orgDic setObject:[filterArray objectAtIndex:1] forKey:@"costCenter"];
            
            NSString* orgName = [dic objectForKey:@"orgName"];
            orgName = [orgName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""]; //1개만 필터링 한다.
            
            [orgDic setObject:orgName forKey:@"orgName"];
            [orgDic setObject:[dic objectForKey:@"parentOrgCode"] forKey:@"parentOrgCode"];
            [orgDic setObject:[dic objectForKey:@"orgLevel"] forKey:@"orgLevel"];
            [orgDic setObject:[NSNumber numberWithInteger:SUB_NO_CATEGORIES] forKey:@"exposeStatus"];
            [orgList addObject:orgDic];
        }
    }
    [_tableView reloadData];
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

#pragma mark - UserAction method
- (void) touchBackBtn:(id)sender
{
    if ([Sender isKindOfClass:[OutIntoViewController class]])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"orgCancelNotification"
         object:nil];
    }
    
    [txtOrgName resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)touchSearchBtn:(id)sender
{
    if (txtOrgName.text.length)
        [self requestNameSearchOrg:txtOrgName.text];
    else{
        NSString* message = @"입력 데이터가 없습니다.";

        [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
    }
    
}

- (IBAction)touchSelectBtn:(id)sender
{
    if (!orgList.count) return;
    
    NSDictionary* userdic = [Util udObjectForKey:USER_INFO];
    NSString* strUserOrgCode = [userdic objectForKey:@"orgId"];
    
    NSDictionary* selItemDic = [orgList objectAtIndex:selectedPath.row];
    NSString* selOrgCode = [selItemDic objectForKey:@"costCenter"];
    
    if (
        [JOB_GUBUN isEqualToString:@"송부(팀간)"] ||
        [JOB_GUBUN isEqualToString:@"철거"]
        )
    {
        NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
        if (cellStatus != SUB_NO_CATEGORIES){
            if (![[selItemDic objectForKey:@"HAS_TFT"] boolValue]){
                NSString* message = @"최하위 조직으로만\n송부하실 수 있습니다.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
                return;
            }
        }
        if ([strUserOrgCode isEqualToString:selOrgCode]){
            NSString* message = @"동일한 조직으로\n송부하실 수 없습니다.\n'출고/입고' 메뉴로 처리해\n주시기 바랍니다.";

            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];

            return;
        }
    }
    
    if (selItemDic.count){
        
        if ([Sender isKindOfClass:[OutIntoViewController class]])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"orgSelectedNotification"
             object:selItemDic];
            
        }
        else {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"spotOrgSelectedNotification"
             object:selItemDic];
            
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    }
}

- (IBAction)touchCancelBtn:(id)sender
{
    if ([Sender isKindOfClass:[OutIntoViewController class]])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"orgCancelNotification"
         object:nil];
    }
    
   [txtOrgName resignFirstResponder];
   [self.navigationController popViewControllerAnimated:NO]; 
}

- (void) touchTreeBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    NSDictionary *dic = [orgList objectAtIndex:btn.tag];
    
    NSMutableDictionary *selItemDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    

    selectedPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
    }
    else{
        if (cellStatus == SUB_CATEGORIES_EXPOSED){ //delete

            NSMutableArray *deleteIndexPaths = [NSMutableArray array];
            [selItemDic setObject:[NSNumber numberWithInteger:SUB_CATEGORIES_NO_EXPOSE] forKey:@"exposeStatus"];
            [orgList replaceObjectAtIndex:btn.tag withObject:selItemDic];
            
            NSMutableIndexSet* deleteSet = [NSMutableIndexSet indexSet];
                                            
            [WorkUtil getChildOrgesOfCurrentIndex:btn.tag orgList:orgList childSet:deleteSet isContainSelf:NO];
            
            [orgList removeObjectsAtIndexes:deleteSet];
            
            [deleteSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
                [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            [_tableView reloadRowsAtIndexPaths:@[selectedPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else { //insert
            if (selItemDic.count){
                [selItemDic setObject:[NSNumber numberWithInteger:SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
                [orgList replaceObjectAtIndex:btn.tag withObject:selItemDic];
                [self requestTreeSearchOrg:[selItemDic objectForKey:@"orgCode"]];
            }
            
        }
        
    }
}

- (IBAction)touchBackground:(id)sender
{
    [txtOrgName resignFirstResponder];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orgList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrgSearchCell *cell = (OrgSearchCell*)[tableView dequeueReusableCellWithIdentifier:@"OrgSearchCell"];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrgSearchCell" owner:self options:nil];
        for (id object in nib)
        {
            if ([object isMemberOfClass:[OrgSearchCell class]])
            {
                cell = object;
                 break;
            }
        }
    }
    
    NSDictionary* dic = [orgList objectAtIndex:indexPath.row];
    
    int orgLevel = [[dic objectForKey:@"orgLevel"] intValue];
    if (orgLevel > 0)
        cell.indentationLevel = orgLevel -1;
    else
        cell.indentationLevel = 0;
    
    if (isSearchMode){
        cell.lblContent.text = [NSString stringWithFormat:@"%@:%@:%@",
                                [dic objectForKey:@"orgName"],
                                [dic objectForKey:@"orgCode"],
                                [dic objectForKey:@"costCenter"]];

    }
    else {
        cell.lblContent.text = [NSString stringWithFormat:@"%@:%@:%@",
                       [dic objectForKey:@"orgName"],
                       [dic objectForKey:@"orgCode"],
                       [dic objectForKey:@"costCenter"]];
    }
    [cell setIndentationWidth:10.0f];
    
    [cell.btntreeNode addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.btntreeNode.tag = indexPath.row;
    
    if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_NO_CATEGORIES){
        cell.imgtreeNode.image = nil;
    }
    
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_NO_EXPOSE){
        cell.imgtreeNode.image = [UIImage imageNamed:@"plus"];
    }
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_EXPOSED){
        cell.imgtreeNode.image = [UIImage imageNamed:@"minus"];
    }
    
    if (selectedPath.row == indexPath.row)
        cell.lblContent.textColor = [UIColor blueColor];
    else
        cell.lblContent.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [orgList objectAtIndex:indexPath.row];
    NSMutableDictionary *selItemDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    
    selectedPath = indexPath;
    
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
        if (selItemDic.count){
            NSLog(@"selected row [%@]",selItemDic);         
            [selItemDic setObject:[NSNumber numberWithInteger:SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            [orgList replaceObjectAtIndex:indexPath.row withObject:selItemDic];
            [self requestTreeSearchOrg:[selItemDic objectForKey:@"orgCode"]];
        }
    }
    else{
        if (cellStatus == SUB_CATEGORIES_EXPOSED){ //delete
            [_tableView reloadData];
        }
        else { //insert
            [_tableView reloadData];
        }

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}


@end

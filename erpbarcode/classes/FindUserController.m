//
//  FindUserController.m
//  erpbarcode
//
//  Created by matsua on 2014. 3. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ERPAlert.h"

#import "FindUserController.h"
#import "ERPRequestManager.h"
#import "FindUserListCell.h"

@interface FindUserController ()
@property(nonatomic,strong) IBOutlet UITextField* txtUserId;
@property(nonatomic,strong) IBOutlet UITextField* txtUserNm;
@property(nonatomic,strong) IBOutlet UITableView* userTableView;
@property(nonatomic,strong) NSMutableArray* userResultList;
@property(nonatomic,assign) NSInteger selRow;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) IBOutlet UIScrollView* scrollView;

@end

@implementation FindUserController

@synthesize delegate;
@synthesize txtUserId;
@synthesize txtUserNm;
@synthesize userTableView;
@synthesize userResultList;
@synthesize selRow;
@synthesize indicatorView;
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView.contentSize = CGSizeMake(userTableView.bounds.size.width, scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)closeModal:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)search:(id)sender{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEARCH_SEARCH_USER_BARCODE;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:txtUserId.text forKey:@"userId"];                //유저아이디
    [paramDic setObject:txtUserNm.text forKey:@"userName"];              //유저네임
    
    [requestMgr asychronousConnectToServer:API_PRT_USER_SEARCH withData:paramDic];
}

-(IBAction)select:(id)sender{
    NSString *userIdValue = @"";
    
    for (int i = 0; i < [userResultList count]; i++){
        if([[[userResultList objectAtIndex:i] objectForKey:@"IS_SELECTED"] boolValue]){
            userIdValue = [[userResultList objectAtIndex:i] objectForKey:@"userId"];
        }
    }
    
    if([userIdValue length] < 1){
        [self showMessage:@"선택된 항목이 없습니다. " tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    [delegate findUserRequest:userIdValue];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];

}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    [self processFindUserResponse:resultList];
}

-(void)processFindUserResponse:(NSArray*)resultList{
    userResultList = [[NSMutableArray array] init];
    
    if (resultList.count){
        
        for (NSDictionary* dic in resultList){
            NSMutableDictionary* userDic = [NSMutableDictionary dictionary];
            
            [userDic setObject:[dic objectForKey:@"userId"] forKey:@"userId"];
            [userDic setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
            [userDic setObject:[dic objectForKey:@"orgName"] forKey:@"orgName"];
            [userDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            
            [userResultList addObject:userDic];
        }
    }
    [userTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userResultList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FindUserListCell";
    FindUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"FindUserListCell" owner:self options:nil];
        cell = arr[0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (userResultList.count){
        NSDictionary* dic = [userResultList objectAtIndex:indexPath.row];
        
        cell.lblLabel1.text = [dic objectForKey:@"userId"];
        cell.lblLabel2.text = [dic objectForKey:@"userName"];
        cell.lblLabel3.text = [dic objectForKey:@"orgName"];
        
        [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnCheck.tag = indexPath.row;
        
        BOOL isSelected = [[dic objectForKey:@"IS_SELECTED"] boolValue];
        cell.btnCheck.selected = isSelected;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selRow = indexPath.row;
}

#pragma mark - touchedSelectBtn
- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    for (int i = 0; i < [userResultList count]; i++){
        
        if(i == btn.tag){
            if (btn.selected) {
                [[userResultList objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
            }else{
                [[userResultList objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            }
        }else{
            [[userResultList objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
        }
    }
    
    [userTableView reloadData];
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

#pragma mark - messegeAlert
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

@end

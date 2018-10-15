//
//  LocInfoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "LocInfoViewController.h"
#import "GridNoBtn2Cell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"

@interface LocInfoViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property (strong, nonatomic) IBOutlet UITableView *tableView2;
@property(nonatomic,strong) IBOutlet UITextField* txtLocCode;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) IBOutlet CLTickerView* locTickerView;
@property(nonatomic,strong) NSMutableArray* locList;
@property(nonatomic,strong) NSString* strLocBarCode;
@property(nonatomic,strong) UILabel* lblCount;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcode;
@end

@implementation LocInfoViewController
@synthesize scrollView;
@synthesize tableView2;
@synthesize _tableView;
@synthesize txtLocCode;
@synthesize indicatorView;
@synthesize locList;
@synthesize locTickerView;
@synthesize strLocBarCode;
@synthesize lblCount;
@synthesize scrollLocBarcode;
@synthesize lblLocBarcode;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"위치바코드정보%@", [Util getTitleWithServerNVersion]];
    self.navigationController.navigationBarHidden = NO;
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    [self makeDummyInputViewForTextField];
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.textAlignment = NSTextAlignmentCenter;
    //lblContent.text = @"test";
    [self.view addSubview:lblCount];
    
    [txtLocCode becomeFirstResponder];
    
    scrollView.contentSize = CGSizeMake(_tableView.bounds.size.width*2, scrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma User Defined Method
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //위치바코드
        if (barcode.length){
            strLocBarCode = barcode;
            NSLog(@"decrypt LocCode: [%@]",strLocBarCode);
            
            NSString *message = [Util barcodeMatchVal:1 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                strLocBarCode = txtLocCode.text = @"";
                [txtLocCode becomeFirstResponder];
                return YES;
            }
            
            [self requestLocCode:strLocBarCode];
        }
        else {
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

            return NO;
            
        }
    }
    return  YES;
}

- (void)makeDummyInputViewForTextField
{
//    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
//    txtLocCode.inputView = dummyView;
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}


- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
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

#pragma mark - UserAction Method
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) touchSearchBtn:(id)sender
{
    if (txtLocCode.text.length)
        [self requestLocCode:txtLocCode.text];
    else {
        NSString* message = @"위치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

- (IBAction)touchBackground:(id)sender
{   
    [txtLocCode resignFirstResponder];
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

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

#pragma mark - Http Request Method
- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
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
    
    [requestMgr requestLocCode:locBarcode];
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
    
    if (pid == REQUEST_LOC_COD){
        [self processLocCodeResponse:resultList];
    }
}

- (void) processLocCodeResponse:(NSArray*)resultList
{
    locList = [resultList mutableCopy];
    if ([locList count]){
        lblCount.text = [NSString stringWithFormat:@"%d건",(int)[locList count]];
    }
    [_tableView reloadData];
    [tableView2 reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [locList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    NSDictionary* dic = [locList objectAtIndex:indexPath.row];
    NSString* completeLocCode = [dic objectForKey:@"completeLocationCode"];
    NSString* locationShortName = [dic objectForKey:@"locationShortName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView == _tableView){
        cell.lblColumn1.frame = CGRectMake(2, 0, 160, 44);
        cell.lblColumn2.frame = CGRectMake(164, 0, 156, 44);
        cell.lblColumn1.text = completeLocCode;
        if (locationShortName.length > 18)
            cell.lblColumn2.text = [locationShortName  substringToIndex:18];
        else
            cell.lblColumn2.text = locationShortName;
    }else if (tableView == tableView2){
        if (locationShortName.length > 18){
            cell.lblColumn1.frame = CGRectMake(0, 0, 318, 44);
            cell.lblColumn1.text = [locationShortName substringFromIndex:19];
            cell.lblColumn2.hidden = YES;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end

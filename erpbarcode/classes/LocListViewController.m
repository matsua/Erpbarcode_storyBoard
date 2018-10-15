//
//  LocListViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 6..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "LocListViewController.h"
#import "CommonCell.h"
#import "DeviceInfoViewController.h"
#import "SpotCheckViewController.h"
#import "AppDelegate.h"

@interface LocListViewController ()
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocName;
@property(nonatomic,strong) IBOutlet UILabel*   lblLocName;
@property(nonatomic,strong) IBOutlet UITextField*   txtLocCode;
@property(nonatomic,strong) NSString* strLocCode;
@property(nonatomic,strong) NSString* JOB_GUBUN;
@property(nonatomic,strong) UILabel* lblCount;
@end

@implementation LocListViewController
@synthesize locList;
@synthesize _tableView;
@synthesize scrollLocName;
@synthesize lblLocName;
@synthesize txtLocCode;
@synthesize sender;
@synthesize strLocCode;
@synthesize JOB_GUBUN;
@synthesize lblCount;

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
    self.title = @"위치바코드를 스캔하세요.";
    self.navigationItem.hidesBackButton = YES;
    [self makeDummyInputViewForTextField];
    
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchCancelBtn:)];
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50,  PHONE_SCREEN_HEIGHT - 44 - 20, 250, 20)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblCount];
    
    if (locList.count){
        lblCount.text = [NSString stringWithFormat:@"%d건",(int)[locList count]];
    }
    [_tableView reloadData];
    
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
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

#pragma  User Define method
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    strLocCode = barcode;
    
    UIAlertView* av = nil;
    int index = [WorkUtil getLocIndex:strLocCode fccList:locList];
    if (index == -1)
    {
        NSString* message = @"해당 장치에 존재하지 않는\n위치바코드입니다.";
        av = [[UIAlertView alloc]
              initWithTitle:nil
              message:message
              delegate:nil
              cancelButtonTitle:nil
              otherButtonTitles:@"닫기", nil];
        [av show];
        [Util playSoundWithMessage:message isError:YES];
    }
    else{
        
        NSDictionary* dic = [locList objectAtIndex:index];
        [Util setScrollTouch:scrollLocName Label:lblLocName withString:[dic objectForKey:@"ZEQUIPLP_TXT"]];
        
        if ([JOB_GUBUN isEqualToString:@"현장점검(베이)"]){
            if (
                [strLocCode hasPrefix:@"VS"] ||
                (strLocCode.length > 17 && [[strLocCode substringFromIndex:17] isEqualToString:@"0000"])
                ){
                NSString* message = @"'가상창고/실' 위치 점검은\n'현장점검(창고/실)'\n메뉴를 사용하시기 바랍니다.";
                av = [[UIAlertView alloc]
                      initWithTitle:@"알림"
                      message:message
                      delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"닫기", nil];
                [av show];
                [Util playSoundWithMessage:message isError:YES];
                return NO;
            }
            
        }
        if ([sender isKindOfClass:[DeviceInfoViewController class]])
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"DeviceLocSelectedNotification"
             object:dic];
        }
        else {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"locSelectedNotification"
             object:dic];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
    return YES;
}

- (void)makeDummyInputViewForTextField
{
//    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
//    txtLocCode.inputView = dummyView;
}

#pragma mark - UserInterface Action
- (void) touchCancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
    
    
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [locList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    NSDictionary* dic = [locList objectAtIndex:indexPath.row];
    NSString* formatString = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"ZEQUIPLP"],[dic objectForKey:@"ZEQUIPLP_TXT"]];
    
    CGFloat textLength = [formatString sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
    cell.scrollView.contentSize = CGSizeMake(textLength + 20, COMMON_CELL_HEIGHT);
    
    cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength, cell.lblTreeData.frame.size.height);
    
    cell.lblTreeData.text = formatString;
    // +, - 버튼을 가리고 label을 앞으로 당긴다.
    cell.btnTree.hidden = YES;
    CGRect rect = CGRectMake(2, cell.lblTreeData.frame.origin.y, cell.lblTreeData.frame.size.width, cell.lblTreeData.frame.size.height);
    cell.lblTreeData.frame = rect;
    
    cell.hasSubNode = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}


@end

//
//  BaseViewController.m
//  erpbarcode
//
//  Created by matsua on 16. 12. 06..
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarReaderViewController.h"
#import "BaseViewResultController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@property(nonatomic,strong) IBOutlet UIView *locCodeView;
@property(nonatomic,strong) IBOutlet UIView *fccCodeView;
@property(nonatomic,strong) IBOutlet UITextField *locCode;
@property(nonatomic,strong) IBOutlet UITextField *fccCode;
@property(nonatomic,strong) NSString *bsnNo;
@property(nonatomic,assign) NSInteger nSelected;

@end

@implementation BaseViewController
@synthesize locCodeView;
@synthesize fccCodeView;
@synthesize locCode;
@synthesize fccCode;
@synthesize bsnNo;
@synthesize bsnGb;
@synthesize nSelected;

#pragma mark - View LifeCycle

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
    self.navigationController.navigationBarHidden = NO;
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@(%@)%@", JOB_GUBUN, bsnGb, [Util getTitleWithServerNVersion]];
    
    [self makeDummyInputViewForTextField];
    
    [self layoutChangeSubview];
}

- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        locCode.inputView = dummyView;
        fccCode.inputView = dummyView;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

- (IBAction)scan:(id)sender
{
    NSLog(@"ScanViewController :: scan");
    AppDelegate *app = [AppDelegate sharedInstance];
    UINavigationController * controller = (UINavigationController*)app.window.rootViewController;
    
    nSelected = [sender tag];
    ZBarReaderViewController *barcodeReaderController = [[ZBarReaderViewController alloc] init];
    barcodeReaderController.readerDelegate = self;
    [controller pushViewController:barcodeReaderController animated:YES];
}

#pragma mark - ZBarReaderController methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> scanResults = [info objectForKey:ZBarReaderControllerResults];
    
    NSString *result;
    ZBarSymbol *symbol;
    
    for (symbol in scanResults)
    {
        result = [symbol.data copy];
        break;
    }
    
    if(nSelected == 0){
        [locCode setText:result];
    }else{
        [fccCode setText:result];
    }
    
    NSLog(@"Result : %@", result);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"ScanViewController :: imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)requestBtn:(id)sender{
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    NSString *url = @"";
    NSString *userId = @"91186176";
    NSString *locCd = locCode.text;
    NSString *fccCd = @"001Z00911318010012";
    
    if([bsnGb isEqualToString:@"OA"]){//OA
        if([JOB_GUBUN isEqualToString:@"불용요청"]){//불용요청
            url = [NSString stringWithFormat:API_BASE_OA_WORK_LIST_HALF, bsnNo, userId, fccCd];
        }else if([JOB_GUBUN isEqualToString:@"OA연식조회"]){//OA연식조회
            url = [NSString stringWithFormat:API_BASE_OA_ITEM_SEARCH, bsnNo, userId, fccCd];
        }else{//신규등록, 관리자 변경, 재물조사, 납품확인, 대여등록, 대여반납
            url = [NSString stringWithFormat:API_BASE_OA_WORK_LIST, bsnNo, userId, locCd, fccCd];
        }
    }else{//OE
        if([JOB_GUBUN isEqualToString:@"불용요청"]){//불용요청
            url = [NSString stringWithFormat:API_BASE_OE_WORK_LIST_HALF, bsnNo, userId, fccCd];
        }else if([JOB_GUBUN isEqualToString:@"비품연식조회"] ){//비품연식조회
            url = [NSString stringWithFormat:API_BASE_OE_ITEM_SEARCH, bsnNo, userId, fccCd];
        }else{//신규등록, 관리자 변경, 재물조사, 납품확인, 대여등록, 대여반납
            url = [NSString stringWithFormat:API_BASE_OE_WORK_LIST, bsnNo, userId, locCd, fccCd];
        }
    }
    
    NSLog(@"url=======%@", url);
    
    BaseViewResultController *resultView = [[BaseViewResultController alloc] init];
    resultView.webUrl = url;
    [self presentViewController:resultView animated:YES completion:nil];
}

-(void)layoutChangeSubview{
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    bsnNo = @"";
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    
    if([JOB_GUBUN isEqualToString:@"불용요청"] || [JOB_GUBUN isEqualToString:@"비품연식조회"] || [JOB_GUBUN isEqualToString:@"OA연식조회"]){
        CGRect locviewFrame = CGRectMake(locCodeView.frame.origin.x, locCodeView.frame.size.height, locCodeView.frame.size.width, locCodeView.frame.size.height);
        locCodeView.hidden = YES;
        fccCodeView.frame = locviewFrame;
    }
    
    if([JOB_GUBUN isEqualToString:@"신규등록"]) bsnNo = @"0501";
    else if([JOB_GUBUN isEqualToString:@"관리자변경"]) bsnNo = @"0504";
    else if([JOB_GUBUN isEqualToString:@"재물조사"]) bsnNo = @"0601";
    else if([JOB_GUBUN isEqualToString:@"불용요청"]) bsnNo = @"0505";
    else if([JOB_GUBUN isEqualToString:@"OA연식조회"] || [JOB_GUBUN isEqualToString:@"비품연식조회"]) bsnNo = @"0602";
    else if([JOB_GUBUN isEqualToString:@"납품확인"]) bsnNo = @"0512";
    else if([JOB_GUBUN isEqualToString:@"대여등록"]) bsnNo = @"0513";
    else if([JOB_GUBUN isEqualToString:@"대여반납"]) bsnNo = @"0503";

}

- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

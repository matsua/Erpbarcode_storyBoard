//
//  PersonalInfoAgreeController.m
//  erpbarcode
//
//  Created by matsua on 17. 01. 02..
//  Copyright (c) 2017년 ktds. All rights reserved.
//

#import "PersonalInfoAgreeController.h"


@interface PersonalInfoAgreeController ()
@property(nonatomic,strong) IBOutlet UILabel* lblHeader1;
@property(nonatomic,strong) IBOutlet UILabel* lblHeader2;
@property(nonatomic,strong) IBOutlet UILabel* lblHeader3;
@property(nonatomic,strong) IBOutlet UILabel* lblHeader4;
@property(nonatomic,strong) IBOutlet UILabel* lblContents1;
@property(nonatomic,strong) IBOutlet UILabel* lblContents2;
@property(nonatomic,strong) IBOutlet UILabel* lblContents3;
@property(nonatomic,strong) IBOutlet UILabel* lblContents4;
@property(nonatomic,strong) IBOutlet UIButton* agree1;
@property(nonatomic,strong) IBOutlet UIButton* agree2;
@property(nonatomic,strong) IBOutlet UIButton* agree3;
@property(nonatomic,strong) IBOutlet UIButton* agree4;

@end

@implementation PersonalInfoAgreeController
@synthesize agreeDeligate;
@synthesize lblHeader1;
@synthesize lblHeader2;
@synthesize lblHeader3;
@synthesize lblHeader4;
@synthesize lblContents1;
@synthesize lblContents2;
@synthesize lblContents3;
@synthesize lblContents4;
@synthesize agree1;
@synthesize agree2;
@synthesize agree3;
@synthesize agree4;


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
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    self.title = @"이용약관";
    
    if([[Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE1"]isEqualToString:@"1"]){
        agree1.selected = YES;
    }
    
    if([[Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE2"]isEqualToString:@"1"]){
        agree2.selected = YES;
    }
    
    if([[Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE3"]isEqualToString:@"1"]){
        agree3.selected = YES;
    }
    
    if([[Util loadSetupInfoFromPlist:@"PERSONAL_INFO_AGREE4"]isEqualToString:@"1"]){
        agree4.selected = YES;
    }
    
    lblHeader1.layer.borderWidth = 1.0;
    lblHeader2.layer.borderWidth = 1.0;
    lblHeader3.layer.borderWidth = 1.0;
    lblHeader4.layer.borderWidth = 1.0;
    lblContents1.layer.borderWidth = 1.0;
    lblContents2.layer.borderWidth = 1.0;
    lblContents3.layer.borderWidth = 1.0;
    lblContents4.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -  User Define Action
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)agree:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if(btn.tag == 2){
        agree1.selected = YES;
        agree2.selected = YES;
        agree3.selected = YES;
        agree4.selected = YES;
    }else{
        btn.selected = !btn.selected;
    }
}

- (IBAction)close:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if(btn.tag == 1){
        if(!agree1.selected || !agree2.selected || !agree3.selected || !agree4.selected){
            UIAlertView* am = [[UIAlertView alloc]
                               initWithTitle:@"알림"
                               message:@"필수 약관내용에 동의를 해주셔야 서비스 이용 가능합니다."
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"닫기", nil];
            [am show];
            return;
        }else{
            [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE1" value:@"1"];
            [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE2" value:@"1"];
            [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE3" value:@"1"];
            [Util writeSetupInfoToPlist:@"PERSONAL_INFO_AGREE4" value:@"1"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [agreeDeligate userAgree:YES];
        }
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end

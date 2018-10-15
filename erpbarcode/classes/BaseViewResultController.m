//
//  BaseViewResultController.m
//  erpbarcode
//
//  Created by matsua on 16. 12. 06..
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import "BaseViewResultController.h"

@interface BaseViewResultController ()

@property(nonatomic,strong) IBOutlet UIWebView *resultWebView;
@property(nonatomic,strong) IBOutlet UIView *navigator;
@property(nonatomic,assign) IBOutlet UIButton *back;
@property(nonatomic,assign) IBOutlet UITextView *title;
@end

@implementation BaseViewResultController
@synthesize resultWebView;
@synthesize navigator;
@synthesize back;
@synthesize title;
@synthesize bsnGb;
@synthesize webUrl;


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
    
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    NSString *JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    title.text = [NSString stringWithFormat:@"%@(%@)%@", JOB_GUBUN, bsnGb, [Util getTitleWithServerNVersion]];
    
    NSURL *resultWebUrl = [[NSURL alloc] initWithString:webUrl];
    NSURLRequest *resultWebUrlRequest = [[NSURLRequest alloc] initWithURL:resultWebUrl];
    [resultWebView loadRequest:resultWebUrlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)touchBackBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

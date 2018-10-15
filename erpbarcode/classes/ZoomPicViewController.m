//
//  ZoomPicViewController.m
//  erpbarcode
//
//  Created by 박수임 on 14. 1. 10..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ZoomPicViewController.h"

@interface ZoomPicViewController ()

@end

@implementation ZoomPicViewController

@synthesize imageViewFailure;
@synthesize imageFailure;

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
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    imageViewFailure.image = imageFailure;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

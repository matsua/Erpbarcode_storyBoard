//
//  ResetPasswordController.h
//  erpbarcode
//
//  Created by matsua on 2016. 6. 9..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CommonViewController.h"

@interface ResetPasswordController : CommonViewController <IProcessRequest>

@property (nonatomic,strong) NSString *gb;

@end


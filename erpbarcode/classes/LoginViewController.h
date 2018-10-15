//
//  LoginViewController.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "SelfCertificationViewController.h"
#import "PersonalInfoAgreeController.h"
#import "NoticeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController : UIViewController <IProcessRequest, ICertificationInfo, IUserAgree, INoticeConfirm>

- (IBAction)touchedLogin:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (void)requestUserLogout;

@end

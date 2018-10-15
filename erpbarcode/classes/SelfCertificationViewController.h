//
//  SelfCertificationViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 12. 19..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@protocol ICertificationInfo <NSObject>
- (void)certificationInfo:(BOOL)certification;

@end

@interface SelfCertificationViewController : UIViewController <IProcessRequest>

@property(strong, nonatomic) id <ICertificationInfo> certificationDelegate;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet UITextField *txtCertNo;
@property (strong, nonatomic) IBOutlet UIButton *btnSendCertNo;
@property (strong, nonatomic) IBOutlet UILabel *lblSecond;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;

@property (nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property (strong, nonatomic) NSDictionary* userInfoDic;
@property (assign, nonatomic) BOOL isExit;
@property (assign, nonatomic) BOOL isRequesting;
@property (assign, nonatomic) BOOL isConfirmation;
@property (strong, nonatomic) NSString* certificationNumber;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) int timeCount;

- (IBAction)touchSendCertNo:(id)sender;
- (IBAction)touchSend:(id)sender;
- (IBAction)touchClose:(id)sender;


@end

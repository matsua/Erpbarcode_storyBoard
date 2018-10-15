//
//  SpotCheckViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 21..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"

@interface SpotCheckViewController : UIViewController<UIGestureRecognizerDelegate, IProcessRequest, IPopRequest>
@property(nonatomic,strong) NSDictionary* dbWorkDic;

- (IBAction) touchLocBtn:(id)sender;
- (IBAction) touchInitBtn;
- (IBAction)touchScanCancelBtn;
- (IBAction) touchOrgBtn:(id)sender;
@end

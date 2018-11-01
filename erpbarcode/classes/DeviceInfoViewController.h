//
//  DeviceInfoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocListViewController.h"
#import "ERPRequestManager.h"
#import "CommonViewController.h"

@interface DeviceInfoViewController : CommonViewController <UIGestureRecognizerDelegate, IProcessRequest>
-(IBAction)touchMenuBtn:(id)sender;
-(IBAction)touchMainMenuBtn:(id)sender;
- (IBAction)touchSearchBtn:(id)sender;
- (IBAction)touchBarcodeInfoBtn:(id)sender;
@end

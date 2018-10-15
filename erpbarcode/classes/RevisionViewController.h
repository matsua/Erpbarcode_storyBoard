//
//  RevisionViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 22..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"


@interface RevisionViewController : UIViewController<CustomPickerViewDelegate,UIGestureRecognizerDelegate, IProcessRequest, IPopRequest>
- (IBAction) touchShowPicker:(id)sender;
@property(nonatomic,strong) NSDictionary* dbWorkDic;
@end

//
//  BuyOutIntoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 16..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "ERPRequestManager.h"
#import "CommonViewController.h"

@interface BuyOutIntoViewController : CommonViewController<UIGestureRecognizerDelegate,CustomPickerViewDelegate, IProcessRequest>
@property(nonatomic,strong) NSDictionary* dbWorkDic;
@end

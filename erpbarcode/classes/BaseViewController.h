//
//  BaseViewController.h
//  erpbarcode
//
//  Created by matsua on 16. 12. 06.
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CommonViewController.h"
#import "ScanViewController.h"

@interface BaseViewController : CommonViewController < IProcessRequest, IScanBarcode>

@property(nonatomic,strong) NSDictionary* dbWorkDic;

@end

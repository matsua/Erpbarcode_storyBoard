//
//  BaseViewController.h
//  erpbarcode
//
//  Created by matsua on 16. 12. 06.
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderViewController.h"
#import "ERPRequestManager.h"

@interface BaseViewController : UIViewController <ZBarReaderDelegate, IProcessRequest>

@property(nonatomic,strong) NSDictionary* dbWorkDic;

@end

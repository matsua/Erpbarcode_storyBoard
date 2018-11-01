//
//  GoodsInfoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CommonViewController.h"

@protocol ISelectGoodsInfo <NSObject>

- (void)selectGoodsCode:(NSDictionary*)dic;
- (void)cancelGoodsInfo;

@end

@interface GoodsInfoViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, IProcessRequest>

@property (strong, nonatomic) id<ISelectGoodsInfo> delegate;

@end

//
//  CancelRsViewController.h
//  erpbarcode
//
//  Created by matsua on 2015. 9. 16..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CustomPickerView.h"

@protocol IdPopRequest <NSObject>
- (void)popRequest:(NSString *)cancelRsKey cancelRsDt:(NSString *)cancelRsDt;

@end

@interface CancelRsViewController : UIViewController<IProcessRequest,CustomPickerViewDelegate>



@property(strong, nonatomic) id <IdPopRequest> delegate;

@end


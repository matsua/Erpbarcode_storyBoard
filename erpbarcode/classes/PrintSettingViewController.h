//
//  PrintSettingViewController.h
//  erpbarcode
//
//  Created by matsua on 2015. 9. 16..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "CommonViewController.h"

@interface PrintSettingViewController : CommonViewController<UITextFieldDelegate, CustomPickerViewDelegate>
@property(nonatomic,retain) NSString* type;


@end


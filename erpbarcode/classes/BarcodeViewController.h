//
//  BarcodeViewController.h
//  erpbarcode
//
//  Created by matsua on 2015. 6. 29..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CustomPickerView.h"
#import "DatePickerViewController.h"
#import "CancelRsViewController.h"
#import "FindUserController.h"
#import "BarcodePrintController.h"

@interface BarcodeViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, IProcessRequest, CustomPickerViewDelegate, IDatePickerView, IdPopRequest, UITextFieldDelegate, IFindUserRequest, IPrintRequest>


-(void)isPrintComplete:(NSDictionary *)completeDicData;
-(void)smPrintComplete:(NSDictionary *)completeDicData;

@end

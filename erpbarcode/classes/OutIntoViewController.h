//
//  OutIntoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 9..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "WBSListViewController.h"
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"
#import "GwlenListController.h"

@interface OutIntoViewController : UIViewController <CustomPickerViewDelegate,UIGestureRecognizerDelegate, ISelectWBS, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IProcessRequest, IPopRequest, UITextViewDelegate, IGwlenRequest>
@property(nonatomic,strong) NSDictionary* dbWorkDic;

@property (strong, nonatomic)UIImagePickerController* imagePicker;
@property (strong, nonatomic)UIImageView* imageView;
@property (strong, nonatomic)UIImage* selPicture;

- (IBAction) touchShowPicker:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)touchScanBtn:(id)sender;
- (IBAction) touchSendBtn:(id)sender;
- (IBAction) touchOrgBtn:(id)sender;
- (IBAction)touchUUBtn:(id)sender;
- (IBAction) touchInitBtn;
- (BOOL) processCheckOrganization:(NSDictionary*) dic;
@end

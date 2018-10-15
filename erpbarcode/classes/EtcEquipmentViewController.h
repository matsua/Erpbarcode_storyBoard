//
//  EtcEquipmentViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoViewController.h"
#import "DatePickerViewController.h"
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"

@interface EtcEquipmentViewController : UIViewController <ISelectGoodsInfo,IDatePickerView, IProcessRequest, IPopRequest>

@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblOrgName;
@property (strong, nonatomic) IBOutlet UITextField *txtLocBarcode;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcodeName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollAssetL;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollAssetM;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollAssetS;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollAssetD;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollGoodsClass;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcodeName;
@property (strong, nonatomic) IBOutlet UITextField *txtGoodsId;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsClass;
@property (strong, nonatomic) IBOutlet UILabel *lblAssetL;
@property (strong, nonatomic) IBOutlet UILabel *lblAssetM;
@property (strong, nonatomic) IBOutlet UILabel *lblAssetS;
@property (strong, nonatomic) IBOutlet UILabel *lblAssetD;
@property (strong, nonatomic) IBOutlet UILabel *lblMaker;
@property (strong, nonatomic) IBOutlet UITextField *txtMakerSN;
@property (strong, nonatomic) IBOutlet UILabel *lblItemClass;
@property (strong, nonatomic) IBOutlet UILabel *lblPartKind;
@property (strong, nonatomic) IBOutlet UIButton *btnRegDate;
@property (strong, nonatomic) IBOutlet UILabel *lblRegDate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sgmMakersYN;
@property (strong, nonatomic) IBOutlet UITextField *txtReqCount;
@property (strong, nonatomic) DatePickerViewController* datePickerVC;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property (strong, nonatomic) NSMutableArray* locCodeList;
@property (strong, nonatomic) NSMutableArray* itemStatusList;
@property (strong, nonatomic) NSDictionary* infoDic;


@property(strong, nonatomic) NSString* JOB_GUBUN;
@property(strong, nonatomic) NSString* strUserOrgCode;
@property(strong, nonatomic) NSString* strUserOrgName;
@property(strong, nonatomic) NSString* strLocBarcode;
@property(strong, nonatomic) NSString* strUserOrgType;
@property(strong, nonatomic) NSString* strBusinessNumber;
@property(strong, nonatomic) NSString* strGoodsId;
@property(strong, nonatomic) NSString* strSgmMakersYN;
@property(assign, nonatomic) NSInteger reqCount;
@property(strong, nonatomic) NSString* strRegDate;
@property(assign, nonatomic) BOOL pickerVisible;
@property(assign, nonatomic) BOOL keyboardVisible;


- (IBAction)changSegmentValue:(id)sender;
- (IBAction)touchGoodsInfo:(id)sender;
- (IBAction)touchShowDateView:(id)sender;

- (IBAction)touchRequest:(id)sender;

@end

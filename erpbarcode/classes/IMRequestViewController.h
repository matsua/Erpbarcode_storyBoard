//
//  IMRequestViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
#import "GoodsInfoViewController.h"
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"

@interface IMRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CustomPickerViewDelegate, ISelectGoodsInfo, IProcessRequest, IPopRequest>

@property (strong, nonatomic) IBOutlet UIScrollView *_itemScrollVIew;
@property (strong, nonatomic) IBOutlet UILabel *lblOrgName;
@property (strong, nonatomic) IBOutlet UITextField *txtLocBarcode;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcodeName;
@property (strong, nonatomic) IBOutlet UITextField *txtDeviceId;
@property (strong, nonatomic) IBOutlet UITextField *txtGoodsId;
@property (strong, nonatomic) IBOutlet UIButton *btnGoodsList;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UITextField *txtUpperId;
@property (strong, nonatomic) IBOutlet UIButton *btnRequestReason;
@property (strong, nonatomic) IBOutlet UILabel *lblRequestReason;

@property (strong, nonatomic) IBOutlet UITextField *txtDamageId;
@property (strong, nonatomic) IBOutlet UITextField *txtMakerSN;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIView *viewDeviceId;
@property (strong, nonatomic) IBOutlet UIView *viewGoodsId;
@property (strong, nonatomic) IBOutlet UIView *viewGoodsName;
@property (strong, nonatomic) IBOutlet UIView *viewUpperBarcode;
@property (strong, nonatomic) IBOutlet UIView *viewRequestReason;
@property (strong, nonatomic) IBOutlet UIView *viewMakerSN;

@property (strong, nonatomic) IBOutlet UIView *viewDamagedBarcode;

@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewTitle1;
@property (strong, nonatomic) IBOutlet UIView *viewTitle2;
@property (strong, nonatomic) IBOutlet UIView *viewTitle3;
@property (strong, nonatomic) IBOutlet UIView *viewTitle4;
@property (strong, nonatomic) IBOutlet UIView *viewTitle5;
@property (strong, nonatomic) IBOutlet UIView *viewTitle6;
@property (strong, nonatomic) UITableView* _table1;
@property (strong, nonatomic) UITableView* _table2;
@property (strong, nonatomic) UITableView* _table3;
@property (strong, nonatomic) UITableView* _table4;
@property (strong, nonatomic) UITableView* _table5;
@property (strong, nonatomic) UITableView* _table6;

@property(nonatomic,strong) CustomPickerView* picker;

@property (strong, nonatomic) NSMutableArray* dataList;
@property (strong, nonatomic) NSMutableArray* locCodeList;
@property (strong, nonatomic) NSMutableArray* itemStatusList;

@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString* JOB_GUBUN;
@property (strong, nonatomic) NSString* strUserOrgCode;
@property (strong, nonatomic) NSString* strUserOrgName;
@property (strong, nonatomic) NSString* strLocCode;
@property (strong, nonatomic) NSString* strGoodId;
@property (strong, nonatomic) NSString* strDeviceId;
@property (strong, nonatomic) NSString* strDamageId;
@property (strong, nonatomic) NSString* selectedPickerData;
@property (assign, nonatomic) int sendCount;
@property (strong, nonatomic) NSString* instoreMarkingRequestReason;
@property (assign, nonatomic) BOOL keyboardVisible;
@property (nonatomic) CGRect scrollRect;
@property (assign, nonatomic) BOOL isShowPicker;
// 물품정보 화면을 띄울 때 -> 물품코드 <검색>버튼 클릭이 아닌 tableview의 list에서 물품코드를 tap했을 경우
// 물품정보 화면 띄울 때 flag설정해 준다
@property (assign, nonatomic) BOOL isChangeGoodsIdMode;
@property (assign, nonatomic) BOOL isGetGoods;      // itemStatus단순 정보 조회인지(NO), 물품조회과정인지(YES)
@property (assign, nonatomic) NSInteger nSelectedRow;
@property (strong, nonatomic) UITapGestureRecognizer* tabPressGesture;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;


- (IBAction)touchGoodsListBtn:(id)sender;
- (IBAction)touchRequestReasonBtn:(id)sender;
- (IBAction)touchInitBtn:(id)sender;
- (IBAction)touchSearchBtn:(id)sender;
- (IBAction)touchDeleteBtn:(id)sender;
- (IBAction)touchRequestBtn:(id)sender;
- (IBAction)changePage:(id)sender;
- (IBAction)closeKeyboard:(id)sender;

@end

//
//  TakeOverNRegEquipViewController.h
//  erpbarcode
//
//  Created by 박scanDeleteRequest수임 on 13. 10. 17..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSListViewController.h"
#import "ArgumentConfirmViewController.h"
#import "ERPRequestManager.h"
#import "AddInfoViewController.h"


@interface TakeOverNRegEquipViewController : UIViewController <UIGestureRecognizerDelegate, ISelectWBS, IArgumentConfirm, IProcessRequest, IPopRequest>

@property(nonatomic,strong) NSDictionary* dbWorkDic;
@property(nonatomic,strong) NSMutableDictionary* workDic;
@property(nonatomic,strong) NSMutableArray* taskList;
@property(nonatomic,strong) NSArray* fetchTaskList;
@property(nonatomic,assign) __block BOOL isOperationFinished;
@property(nonatomic,assign) BOOL isDataSaved;
@property(nonatomic,assign) BOOL isOffLine;
@property(nonatomic,assign) BOOL isMultiDevice;


@property(strong, nonatomic) NSString* JOB_GUBUN;
@property(strong, nonatomic) UILongPressGestureRecognizer* longPressGesture;
@property(strong, nonatomic) UITapGestureRecognizer* tapGesture;
@property(strong, nonatomic) NSString* strUserOrgCode;
@property(strong, nonatomic) NSString* strUserOrgName;
@property(strong, nonatomic) NSString* strUserId;
@property(strong, nonatomic) NSMutableArray* fccMoveList;
@property(strong, nonatomic) UILabel* lblCount;
@property(strong, nonatomic) UILabel* lblCount2;
@property(strong, nonatomic) NSString* strMoveBarCode;
@property(strong, nonatomic) NSString* strFccBarCode;
@property(strong, nonatomic) NSString* strDocNo;
@property(assign, nonatomic) NSInteger nSelectedRow;
@property(assign, nonatomic) BOOL isOrgChanged;
@property(assign, nonatomic) BOOL isFirst;
@property(assign, nonatomic) BOOL isRescan;
@property(assign, nonatomic) BOOL isWorkStep;
@property(assign, nonatomic) BOOL isSendFlag;
@property(assign, nonatomic) BOOL isValidateDeviceId;
@property(assign, nonatomic) BOOL isModifyMode;
@property(assign, nonatomic) BOOL isMoveMode;
@property(assign, nonatomic) BOOL isChange;
@property(assign, nonatomic) BOOL isSuccDeviceScan;
@property(assign, nonatomic) BOOL isAlertYes;
@property(assign, nonatomic) BOOL isSlectedWBS;

@property(assign, nonatomic) NSInteger sendCount;
@property(strong, nonatomic) NSString* strLocBarCode;
@property(strong, nonatomic) NSString* strCompleteLocBarCode;
@property(strong, nonatomic) NSString* strDeviceID;
@property(strong, nonatomic) NSString* strWBSNo;
@property(assign, nonatomic) NSInteger deviceCount;
@property(strong, nonatomic) NSString* strSelectedFac;
@property(strong, nonatomic) UIActivityIndicatorView* indicatorView;
@property(strong, nonatomic) NSMutableArray* locResultList;
@property(strong, nonatomic) NSMutableArray* wbsResultList;
@property(strong, nonatomic) NSMutableArray* fccResultList;
@property(strong, nonatomic) NSMutableArray* rescanList;
@property(strong, nonatomic) NSMutableArray* subFacList;
@property(strong, nonatomic) NSMutableArray* fullTableList;
@property(strong, nonatomic) NSMutableArray* tableList;
@property(strong, nonatomic) NSMutableArray* searchResultList;
@property(strong, nonatomic) NSMutableArray* listDeviceId;
@property(strong, nonatomic) NSMutableArray* validateYNList;

@property(assign, nonatomic) int pwSendType;
@property(assign, nonatomic) NSString* deviceLocCd;
@property(assign, nonatomic) NSString* deviceLocNm;

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIView *orgView;
@property (strong, nonatomic) IBOutlet UILabel *lblOperationInfo;
@property (strong, nonatomic) IBOutlet UIView *locBarcodeView;
@property (strong, nonatomic) IBOutlet UITextField *txtLocCode;
@property (strong, nonatomic) IBOutlet UIView *locNameView;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocName;
@property (strong, nonatomic) IBOutlet UIView *fccBarcodeView;
@property (strong, nonatomic) IBOutlet UILabel *lblPartType;
@property (strong, nonatomic) IBOutlet UITextField *txtFacCode;
@property (strong, nonatomic) IBOutlet UIView *uuView;
@property (strong, nonatomic) IBOutlet UIButton *btnUU;
@property (strong, nonatomic) IBOutlet UIButton *btnDetailFccInfo;
@property (strong, nonatomic) IBOutlet UIView *deviceIDView;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceIdTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtDeviceID;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceID;
@property (strong, nonatomic) IBOutlet UIView *deviceINfoView;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollDeviceInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceInfo;
@property (strong, nonatomic) IBOutlet UIView *wbsView;
@property (strong, nonatomic) IBOutlet UILabel *lblWBSNo;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeWBS;
@property (strong, nonatomic) IBOutlet UITableView *_tableView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@property (strong, nonatomic) IBOutlet UIButton *btnClear;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;

@property (strong, nonatomic) IBOutlet UIButton *btnReScanReq;
@property (strong, nonatomic) IBOutlet UIButton *btnMove;
@property (strong, nonatomic) IBOutlet UIButton *btnModify;
@property (strong, nonatomic) IBOutlet UIButton *btnDel;
@property (strong, nonatomic) IBOutlet UIButton *btnRegDecision;
@property (strong, nonatomic) IBOutlet UIView *messageView;   // 수정과 이동시 함께 쓰는 뷰임
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;



- (IBAction)touchBackground:(id)sender;
- (IBAction)touchFccInfoBtn:(id)sender;
- (IBAction)touchInitBtn:(id)sender;
- (IBAction)touchReScanReqBtn:(id)sender;
- (IBAction)touchMoveBtn:(id)sender;
- (IBAction)touchDelBtn:(id)sender;
- (IBAction)touchSaveBtn:(id)sender;
- (IBAction)touchSendBtn:(id)sender;
- (IBAction)touchRegDecisionBtn:(id)sender;
- (IBAction)touchUUBtn:(id)sender;
- (IBAction)touchChangeWBSBtn:(id)sender;
- (IBAction)touchModifyBtn:(id)sender;
- (IBAction)touchCancel:(id)sender;


@end

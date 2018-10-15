//
//  ArgumentConfirmViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 28..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@protocol IArgumentConfirm <NSObject>

- (void)EndArgumentConfirmIsSend:(BOOL)isSend;

@end

@interface ArgumentConfirmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, IProcessRequest>

@property (strong, nonatomic) id<IArgumentConfirm> delegate;

@property (strong, nonatomic) IBOutlet UIView *viewTitle1;
@property (strong, nonatomic) IBOutlet UIView *viewTitle2;
@property (strong, nonatomic) IBOutlet UIView *viewTitle3;
@property (strong, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewButtons;


@property (strong, nonatomic) UITableView* _tblFirst;
@property (strong, nonatomic) UITableView* _tblSecond;
@property (strong, nonatomic) UITableView* _tblThird;
@property (strong, nonatomic) UITableView* _tblFourth;

@property (strong, nonatomic) NSMutableArray* dataList;
@property (strong, nonatomic) NSArray* infoList;
@property (strong, nonatomic) NSMutableArray* listOftakeOverList;
@property (strong, nonatomic) NSMutableArray* takeOverList;
@property (strong, nonatomic) NSMutableArray* subFacList;

@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString* JOB_GUBUN;
@property (strong, nonatomic) NSString* POSID;
@property (strong, nonatomic) NSString* loccd;

@property(strong, nonatomic) UIActivityIndicatorView* indicatorView;

- (IBAction)changePage:(id)sender;
- (IBAction)touchReg:(id)sender;
- (IBAction)touchCancel:(id)sender;

@end

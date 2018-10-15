//
//  CompleteScanViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@interface CompleteScanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, IProcessRequest>

@property (strong, nonatomic) IBOutlet UITextField *txtFacBarcode;
@property (strong, nonatomic) IBOutlet UIPageControl *_pageCtrl;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIView *title1;
@property (strong, nonatomic) IBOutlet UIView *title2;
@property (strong, nonatomic) IBOutlet UIView *title3;

@property (strong, nonatomic) UITableView* _table1;
@property (strong, nonatomic) UITableView* _table2;
@property (strong, nonatomic) UITableView* _table3;

@property (strong, nonatomic) NSMutableArray* dataList;
@property (strong, nonatomic) NSArray* resultFccDate;

@property (strong, nonatomic) NSString* JOB_GUBUN;
@property (strong, nonatomic) NSString* strFacBarcode;
@property(nonatomic,strong) IBOutlet UILabel* lblPartType;
@property(nonatomic, assign) BOOL isValidFac;
@property(nonatomic, assign) NSString* injuryBarcode;

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

- (IBAction)chagePage:(id)sender;
- (IBAction)touchDelete:(id)sender;
- (IBAction)touchSend:(id)sender;

@end

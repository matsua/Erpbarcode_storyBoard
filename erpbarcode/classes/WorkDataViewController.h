//
//  WorkDataViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 8..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"

@interface WorkDataViewController : UIViewController <CustomPickerViewDelegate>

@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;

@property (strong, nonatomic) IBOutlet UIButton *btnWork;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSendResult;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UITableView *_tableView1;
@property (strong, nonatomic) IBOutlet UITableView *_tableView2;
@property (strong, nonatomic) IBOutlet UITableView *_tableView3;
@property (strong, nonatomic) IBOutlet UITableView *_tableView4;
@property (strong, nonatomic) CustomPickerView* pvWorkName;
@property (strong, nonatomic) CustomPickerView* pvDate;
@property (strong, nonatomic) CustomPickerView* pvSendResult;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView2;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView3;
@property(nonatomic,strong) IBOutlet UIView* columnHeaderView4;


@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader11;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader12;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader21;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader22;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader31;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader32;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader41;
@property(nonatomic,strong) IBOutlet UILabel* lblColumnHeader42;

@property (strong, nonatomic) NSString* strSelWorkName;
@property (strong, nonatomic) NSString* strSelDate;
@property (strong, nonatomic) NSString* strSelSendResult;

- (IBAction)showWorkPickerView:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)showSendResultPicker:(id)sender;
- (IBAction)touchOK:(id)sender;
- (IBAction)touchDel:(id)sender;
- (IBAction)touchClose:(id)sender;


@end

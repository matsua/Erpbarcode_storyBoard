//
//  WBSListViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 16..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISelectWBS <NSObject>

- (void)setWBSNo:(NSString*)wbsNo withResult:(BOOL)result;
- (void)cancelSelectWBSNo;

@end



@interface WBSListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<ISelectWBS> delegate;

@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *_pageCtrl;
@property (strong, nonatomic) IBOutlet UIView *page2TitleView;
@property (strong, nonatomic) IBOutlet UIView *page1TitleView;
@property (strong, nonatomic) IBOutlet UIView *toPage2TitleView;
@property (strong, nonatomic) IBOutlet UIView *toPage3TitleView;


@property (strong, nonatomic) UITableView* _tblFirst;
@property (strong, nonatomic) UITableView* _tblSecond;
@property (strong, nonatomic) UITableView* _tblThird;

@property (strong, nonatomic) NSArray* wbsList;
@property(assign, nonatomic) NSInteger selectedRow;
@property(strong, nonatomic) NSString* selectedWBSNo;
@property(strong, nonatomic) NSString* JOB_GUBUN;

- (IBAction)selectButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)changePage:(id)sender;

@end

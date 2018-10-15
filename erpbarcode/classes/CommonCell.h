//
//  CommonCell.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 14..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMMON_CELL_HEIGHT     35

@interface CommonCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UITextView* textTreeData;
@property(nonatomic,strong) IBOutlet scrollTouch* scrollView;
@property(nonatomic,strong) IBOutlet UILabel* lblTreeData;
@property(nonatomic,strong) IBOutlet UILabel* lblBackground;
@property(nonatomic,assign) NSInteger nScanType;
@property(nonatomic,strong) IBOutlet UIButton* btnTree;
@property(nonatomic,assign) BOOL hasSubNode;
@end

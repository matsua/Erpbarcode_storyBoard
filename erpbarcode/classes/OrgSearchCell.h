//
//  OrgSearchCell.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"

@interface OrgSearchCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIImageView* imgtreeNode;
@property (nonatomic,strong) IBOutlet UIButton* btntreeNode;
@property (nonatomic,strong) IBOutlet UILabel* lblContent;
@property (nonatomic,strong) TreeNode *treeNode;
@property (nonatomic,assign) BOOL isIndentMode;
@end

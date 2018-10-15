//
//  GoodsInfoFirstTableCell.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 8..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoFirstTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDevPartName;
@property (strong, nonatomic) IBOutlet UILabel *lblPartFullName;


@end

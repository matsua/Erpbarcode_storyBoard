//
//  GoodsInfoSecondTableCell.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 8..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoSecondTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (strong, nonatomic) IBOutlet UILabel *lblMadeFirm;
@property (strong, nonatomic) IBOutlet UILabel *lblMeterialType;
@property (strong, nonatomic) IBOutlet UILabel *lblBarcodeYN;


@end

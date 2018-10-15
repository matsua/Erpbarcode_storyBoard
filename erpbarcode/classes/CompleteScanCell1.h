//
//  CompleteScanCell1.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteScanCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;

@property (strong, nonatomic) IBOutlet UILabel *lblFacBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsId;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;

- (IBAction)touchCheckBtn:(id)sender;
@end

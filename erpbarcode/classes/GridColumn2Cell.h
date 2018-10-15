//
//  GridColumn2Cell.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 10. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridColumn2Cell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel* lblColumn1;
@property(nonatomic,strong) IBOutlet UILabel* lblColumn2;
@property(nonatomic,strong) IBOutlet UIButton* btnCheck;
@end

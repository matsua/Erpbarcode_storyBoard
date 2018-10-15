//
//  IMRequestCell1.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMRequestCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UILabel *lblFacId;
@property (strong, nonatomic) IBOutlet UILabel *lblFacStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsId;

- (IBAction)touchCheckBtn:(id)sender;


@end

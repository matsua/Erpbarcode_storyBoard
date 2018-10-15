//
//  ArgumentConfirmCell1.h
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 28..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArgumentConfirmCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (strong, nonatomic) IBOutlet UILabel *lblDeviceId;
@property (strong, nonatomic) IBOutlet UILabel *lblL1Name;
@property (strong, nonatomic) IBOutlet UILabel *lblL2Name;

- (IBAction)touchCheckBtn:(id)sender;


@end

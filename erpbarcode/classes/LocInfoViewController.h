//
//  LocInfoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CommonViewController.h"

@interface LocInfoViewController : CommonViewController <IProcessRequest>


- (IBAction) touchSearchBtn:(id)sender;
- (IBAction)touchBackground:(id)sender;
@end

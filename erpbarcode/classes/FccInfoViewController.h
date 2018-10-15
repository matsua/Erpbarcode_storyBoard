//
//  FccInfoViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 3..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@interface FccInfoViewController : UIViewController <IProcessRequest>

@property(nonatomic,strong) NSString* paramBarcode;
@property(nonatomic,strong) NSString* paramScreenCode;
-(IBAction)touchMenuBtn:(id)sender;
@end

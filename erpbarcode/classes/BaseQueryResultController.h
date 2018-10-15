//
//  BaseViewController.h
//  erpbarcode
//
//  Created by matsua on 16. 12. 06.
//  Copyright (c) 2016년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderViewController.h"

@interface BaseViewController : UIViewController <ZBarReaderDelegate>

@property(nonatomic,assign) NSString *bsnGb;

@end

//
//  LocListViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 6..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LocListViewController : CommonViewController

@property(nonatomic,strong) NSArray* locList;
@property(nonatomic,strong) id sender;
@end

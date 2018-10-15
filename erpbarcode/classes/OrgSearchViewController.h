//
//  OrgSearchViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@interface OrgSearchViewController : UIViewController <IProcessRequest>

- (IBAction)touchCancelBtn:(id)sender;
@property(nonatomic,strong) id Sender;
@property(nonatomic,assign) BOOL isSearchMode;
@property(nonatomic,strong) NSMutableArray* orgList;
@end

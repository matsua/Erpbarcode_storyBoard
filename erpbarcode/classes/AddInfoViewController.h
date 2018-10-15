//
//  AddInfoViewController.h
//  erpbarcode
//
//  Created by matsua on 2014. 3. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@protocol IPopRequest <NSObject>
- (void)popRequest:(NSString *)locAddrBd locAddrLoad:(NSString *)locAddrLoad;

@end

@interface AddInfoViewController : UIViewController<IProcessRequest>

@property (nonatomic, retain) NSString *locCd;
@property (nonatomic, retain) NSString *locNm;
@property (nonatomic, retain) NSString *locNmBd;
@property (nonatomic, retain) NSString *locNmLoad;

@property(strong, nonatomic) id <IPopRequest> delegate;

- (void) openModal:(NSString*)locCd_re;

@end


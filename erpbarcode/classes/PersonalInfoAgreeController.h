//
//  PersonalInfoAgreeController.h
//  erpbarcode
//
//  Created by matsua on 17. 01. 02..
//  Copyright (c) 2017년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IUserAgree <NSObject>
- (void)userAgree:(BOOL)agree;
@end


@interface PersonalInfoAgreeController : UIViewController

@property(strong, nonatomic) id <IUserAgree> agreeDeligate;

@end

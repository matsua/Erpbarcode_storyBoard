//
//  FindUserController.h
//  erpbarcode
//
//  Created by matsua on 2014. 3. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"

@protocol IFindUserRequest <NSObject>
- (void)findUserRequest:(NSString *)userId;

@end

@interface FindUserController : UIViewController<IProcessRequest>

@property(strong, nonatomic) id <IFindUserRequest> delegate;

@end

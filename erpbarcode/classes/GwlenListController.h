//
//  GwlenListController.h
//  erpbarcode
//
//  Created by matsua on 17. 07. 26..
//  Copyright (c) 2017년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IGwlenRequest <NSObject>
- (void)gwlenRequest:(BOOL)send;

@end

@interface GwlenListController : UIViewController<IGwlenRequest>

@property (nonatomic, retain) NSMutableArray *list;

@property(strong, nonatomic) id <IGwlenRequest> delegate;
@end

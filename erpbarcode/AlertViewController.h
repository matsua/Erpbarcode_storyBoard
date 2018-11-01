//
//  AlertViewController.h
//  erpbarcode
//
//  Created by Kim Sunmi on 2018. 11. 1..
//  Copyright © 2018년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AlertViewController;

@protocol AlertViewDelegate
-(void) clickedButtonAtIndex:(NSInteger)buttonIndex alertView:(AlertViewController*)alertView;
@end

@interface AlertViewController : NSObject

@property(strong, nonatomic) UIAlertController* alertController;
@property(assign, nonatomic) NSInteger tag;


- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                     delegate:(nullable id /*<ERPAlertDelegate>*/)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(UIAlertAction*)addAction:(NSString*)title index:(NSInteger)index style:(UIAlertActionStyle)style delegate:(id<AlertViewDelegate>)delegate;

- (void) show;
- (void) hide;
@end

NS_ASSUME_NONNULL_END

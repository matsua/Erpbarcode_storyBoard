//
//  CommonViewController.h
//  erpbarcode
//
//  Created by Kim Sunmi on 2018. 10. 24..
//  Copyright © 2018년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPAlert.h"
#import "AlertViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonViewController : UIViewController<AlertViewDelegate>

- (UIStatusBarStyle) getStatusBarStyle;
- (UIViewController*)instantiateViewController:(NSString *)storyBoardName viewName:(NSString*)viewName;
- (UIViewController*)pushViewController:(NSString *)storyBoardName viewName:(NSString*)viewName animated:(BOOL)animated;
- (UIViewController*)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController*)showViewController:(UIViewController *)viewController;

- (UIViewController*)getOutIntoView:(NSString*)workName;
- (UIViewController*)goOutIntoView:(NSString*)workName;
- (CGFloat)getBottomPadding;
- (void)setCountLabelPosition:(UIView*)lblCount  y:(CGFloat)y height:(CGFloat)height;
- (void)setCountLabelPosition:(UIView*)lblCount parent:(UIView*)parent y:(CGFloat)y height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END

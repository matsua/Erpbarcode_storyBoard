//
//  UINavigationItem+Addition.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 11. 28..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Addition)
- (void)addLeftBarButtonItem:(NSString*)imageName target:(id)target action:(SEL)action;
- (void)addRightBarButtonItem:(NSString*)imageName target:(id)target action:(SEL)action;
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
@end

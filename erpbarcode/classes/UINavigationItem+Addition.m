//
//  UINavigationItem+Addition.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 11. 28..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "UINavigationItem+Addition.h"

@implementation UINavigationItem (Addition)

- (void)addLeftBarButtonItem:(NSString*)imageName target:(id)target action:(SEL)action
{
    UIImage* backButtonImage;
    UIBarButtonItem * leftBarButtonItem;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonImage = [[UIImage imageNamed:imageName]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        leftBarButtonItem = [[UIBarButtonItem alloc]
                           initWithImage:backButtonImage
                           style:UIBarButtonItemStyleBordered
                           target:target
                           action:action];
        
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        [leftBarButtonItem setBackgroundVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
    }
    else{
        //왼쪽 버튼 구성
        backButtonImage = [UIImage imageNamed:imageName];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor clearColor];
        leftBtn.frame = CGRectMake(10,7,30,30);
        
        [leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        // Just set the UIBarButtonItem as you would normally
        [self setLeftBarButtonItem:leftBarButtonItem];
        
    }
}

- (void)addRightBarButtonItem:(NSString*)imageName target:(id)target action:(SEL)action
{
    UIImage* backButtonImage;
    UIBarButtonItem * rightBarButtonItem;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonImage = [[UIImage imageNamed:imageName]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        rightBarButtonItem = [[UIBarButtonItem alloc]
                             initWithImage:backButtonImage
                             style:UIBarButtonItemStyleBordered
                             target:target
                             action:action];
        
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        negativeSpacer.width = -10;
        [rightBarButtonItem setBackgroundVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
    }
    else{
        //오른쪽 버튼 구성
        backButtonImage = [UIImage imageNamed:imageName];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:backButtonImage forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        rightBtn.frame = CGRectMake(266,7,44,30);
        
        [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
        // Just set the UIBarButtonItem as you would normally
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
 
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}


@end

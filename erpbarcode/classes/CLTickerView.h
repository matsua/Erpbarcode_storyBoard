//
//  CLTickerView.h
//
//  Created by Cayden Liew on 3/5/12.
//  Copyright (c) 2012 Cayden Liew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScrollview.h"

@interface CLTickerView : UIView <UIScrollViewDelegate, CLScrollviewDelegate> {
    NSTimer *scrollingTimer;
    NSInteger contentWidth;
    NSInteger labelWidth;
    BOOL startScrolling;
    
    
    UILabel *label;
}

@property (nonatomic, retain) CLScrollview *scrollview;
@property (nonatomic, retain) NSString *marqueeStr;
@property (nonatomic, retain) UIFont *marqueeFont;
@property (nonatomic, retain) UIColor *textColor;

- (void)start;
- (CGSize)labelSizeForText:(NSString *)text forFont:(UIFont *)font;
- (void)stopScrolling;
@end

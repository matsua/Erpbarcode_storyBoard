//
//  scrollTouch.m
//  PPM
//
//  Created by boazcmt on 13. 5. 20..
//  Copyright (c) 2013년 kth. All rights reserved.
//

#import "scrollTouch.h"

@implementation scrollTouch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesBegan:touches withEvent:event];
}


-(void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*)event{
    
//    UITouch* touch =[[event allTouches] anyObject];
    
    if(!self.dragging){
        if (self.superview.superview)
            [self.superview.superview touchesEnded: touches withEvent:event];
    }
    else{
        [super touchesEnded: touches withEvent:event];
    }
}


@end

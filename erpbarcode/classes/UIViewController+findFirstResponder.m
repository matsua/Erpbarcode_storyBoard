//
//  UIViewController+findFirstResponder.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 11. 15..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "UIViewController+findFirstResponder.h"

@implementation UIViewController (findFirstResponder)

-(id)findFirstResponder
{
    if(self.isFirstResponder){
        return self;
    }
    id firstResponder =[self.view findFirstResponder];
    if(firstResponder != nil){
        return firstResponder;
    }
    for(UIViewController*childViewController in self.childViewControllers){
        firstResponder =[childViewController findFirstResponder];
        if(firstResponder != nil){
            return firstResponder;
        }
    }
    return nil;
}
@end

@implementation UIView (findFirstResponder)
-(UIView*)findFirstResponder
{
    if(self.isFirstResponder){
        return self;
    }
    for(UIView* subView in self.subviews)
    {
        UIView* firstResponder = [subView findFirstResponder];
        if(firstResponder != nil){
            return firstResponder;
        }
    }
    return nil;
}
@end

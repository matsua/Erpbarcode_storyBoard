//
//  AlertViewController.m
//  erpbarcode
//
//  Created by Kim Sunmi on 2018. 11. 1..
//  Copyright © 2018년 ktds. All rights reserved.
//

#import "AlertViewController.h"
#import "AppDelegate.h"

@interface AlertViewController ()

@end

@implementation AlertViewController

@synthesize tag;

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                     delegate:(nullable id /*<ERPAlertDelegate>*/)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    
    self = [super init];
    
    if (self){
        
        self.alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
                
        va_list args;
        va_start(args, otherButtonTitles);
        int index = 0;
        if (cancelButtonTitle != nil && cancelButtonTitle.length > 0) {
            UIAlertAction* action = [self addAction:cancelButtonTitle index:index style:UIAlertActionStyleCancel delegate:delegate];
            [self.alertController addAction:action];
            index++;
        }
        for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString *)) {
            
            if (arg != nil && arg.length > 0) {
                UIAlertAction* action = [self addAction:arg index:index style:UIAlertActionStyleDefault delegate:delegate];
                [self.alertController addAction:action];
            }
            index++;            
        }
        
        va_end(args);
    }    
    return self;
}

-(UIAlertAction*)addAction:(NSString*)title index:(NSInteger)index style:(UIAlertActionStyle)style delegate:(id<AlertViewDelegate>)delegate {
    
    if (self.alertController == nil) return nil;
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * action) {
        if (delegate != nil) {
            [delegate clickedButtonAtIndex:index alertView:self];
        }
        [self.alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    return action;
}

-(void)show {
    
    if (self.alertController == nil) return;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIViewController* rootView = appDelegate.window.rootViewController;
    while(rootView.presentedViewController) {
        rootView = rootView.presentedViewController;
    }
    [rootView presentViewController:self.alertController animated:YES completion:nil];
}

-(void)hide {
    
    if (self.alertController == nil) return;
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

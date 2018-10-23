//
//  CommonViewController.m
//  erpbarcode
//
//  Created by Kim Sunmi on 2018. 10. 24..
//  Copyright © 2018년 ktds. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (UIViewController*)instantiateViewController:(NSString *)storyBoardName viewName:(NSString*)viewName {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    if (sb == nil) return nil;
    
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:viewName];
    if (vc == nil) return nil;    
    
    return vc;
}


- (UIViewController*)pushViewController:(NSString *)storyBoardName viewName:(NSString*)viewName animated:(BOOL)animated{
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    if (sb == nil) return nil;
    
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:viewName];
    if (vc == nil) return nil;
    
    [self.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (UIViewController*)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (viewController == nil) return nil;

    [self.navigationController pushViewController:viewController animated:YES];
    return viewController;
}

- (UIViewController*)showViewController:(UIViewController *)viewController {
    
    if (viewController == nil) return nil;
    
    [self.navigationController showViewController:viewController sender:nil];
    return viewController;
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

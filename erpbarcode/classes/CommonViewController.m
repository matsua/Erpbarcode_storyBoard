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

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self getStatusBarStyle] animated:YES];
}

- (UIStatusBarStyle) getStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
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

- (UIViewController*)goOutIntoView:(NSString*)workName {
    
    UIViewController* viewController = [self getOutIntoView:workName];
    if (viewController == nil) return nil;
    
    [self pushViewController:(UIViewController *)viewController animated:(BOOL)YES];
    
    return viewController;
}

- (UIViewController*)getOutIntoView:(NSString*)workName {
    
    if([workName isEqualToString:@"납품입고"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"납품취소"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"배송출고"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"입고(팀내)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"출고(팀내)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"실장"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"탈장"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"송부(팀간)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"송부취소(팀간)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"접수(팀간)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"형상구성(창고내)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"형상해제(창고내)"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"고장등록"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"설비상태변경"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"설비정보"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else if([workName isEqualToString:@"고장수리이력"]){
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
    else{
        return [self instantiateViewController:@"OutInto" viewName:@"OutIntoViewController"];
    }
}

- (void)clickedButtonAtIndex:(NSInteger)buttonIndex alertView:(AlertViewController*)alertView {
    
    
}

- (CGFloat)getBottomPadding {
    
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        return bottomPadding;
    }
    return 0;
}

- (void)setCountLabelPosition:(UIView*)lblCount parent:(UIView*)parent y:(CGFloat)y height:(CGFloat)height {
    
    lblCount.translatesAutoresizingMaskIntoConstraints = false;
    CGFloat bottom = [self getBottomPadding] + y;
    [lblCount.widthAnchor constraintEqualToConstant:parent.bounds.size.width].active = YES;
    [lblCount.heightAnchor constraintEqualToConstant:height].active = YES;
    [lblCount.centerXAnchor constraintEqualToAnchor:parent.centerXAnchor].active = YES;
    [lblCount.topAnchor constraintEqualToAnchor:parent.bottomAnchor constant:-bottom].active = YES;
}

- (void)setCountLabelPosition:(UIView*)lblCount y:(CGFloat)y height:(CGFloat)height{
    
    lblCount.translatesAutoresizingMaskIntoConstraints = false;
    CGFloat bottom = [self getBottomPadding] + y;
    [lblCount.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
    [lblCount.heightAnchor constraintEqualToConstant:height].active = YES;
    [lblCount.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [lblCount.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-bottom].active = YES;
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

//
//  MainMenuViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERPRequestManager.h"
#import "CommonViewController.h"

typedef enum _MenuMoveDirection {
	MENU_MOVE_UP = 0,
    MENU_MOVE_DOWN = 1
} MenuMoveDirection;

@interface MainMenuViewController : CommonViewController <IProcessRequest>

@property (nonatomic,nonatomic) NSString *preview;
@property (nonatomic,nonatomic) UIView* subMenuView;
@property (nonatomic,nonatomic) NSLayoutConstraint *subMenuLayout;

@property (nonatomic,strong) NSArray* setupInfoList;
@property (nonatomic,strong) NSArray* menuList;
@property (nonatomic, strong) NSArray* subMenuList;
@property (nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property (assign, nonatomic) BOOL isAlreadyOpen;
@property (assign, nonatomic) NSInteger prevMainMenuTag;
@property (strong, nonatomic) UIButton* prevButton;
@property (assign, nonatomic) NSInteger selectedMenu;
@property(nonatomic,assign) BOOL isOffLine;
@property (assign, nonatomic) BOOL isQA;
@property (assign, nonatomic) NSInteger currentOpenedMainMenu;

@property (strong, nonatomic) IBOutlet UIView *viewSubMenu;
@property (strong, nonatomic) IBOutlet UIView *viewMainMenu1;
@property (strong, nonatomic) IBOutlet UIView *viewMainMenu2;
@property (strong, nonatomic) IBOutlet UIView *viewMainMenu3;
@property (strong, nonatomic) IBOutlet UIView *viewMainMenu4;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (strong, nonatomic) IBOutlet UILabel *lblServer;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (strong, nonatomic) IBOutlet UIView *viewMainSubMenu1;
@property (strong, nonatomic) IBOutlet UIView *viewMainSubMenu2;
@property (strong, nonatomic) IBOutlet UIView *viewMainSubMenu3;
@property (strong, nonatomic) IBOutlet UIView *viewMainSubMenu4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcMenu;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcSubMenu1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcSubMenu2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcSubMenu3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcSubMenu4;

- (IBAction)touchSubMemu:(id)sender;
- (IBAction)touchMainMenu:(id)sender;
- (IBAction)touchMangeWork:(id)sender;
- (IBAction)touchFccInfo:(id)sender;
- (IBAction)touchSetup:(id)sender;
- (IBAction)touchExit:(id)sender;


@end

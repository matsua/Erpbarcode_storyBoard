//
//  SettingViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 10..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewRereadDelay.h"
#import "ERPRequestManager.h"

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, IProcessRequest, UITextFieldDelegate>
{
    NSMutableArray *listOfItems;
    
    UIProgressView * progressView;
    UISwitch *soundSwitch;
    UISwitch *softKeyboardSwitch;
    UISwitch *connectAlertSwitch;
    UISwitch *autoTriggerSwitch;
    
    UISwitch *autoEraseSwitch;
    UISwitch *beepSoundSwitch;
    UISwitch *beepOnScanSwitch;
    UISwitch *beepVolumeHighSwitch;
    UISwitch *vibratorSwitch;
    UISwitch *keyPadSwitch;
    
    UITableViewCell *rereadCell;
    
    SettingViewRereadDelay *delayView;

}
- (void)requestKDCSettingFinished;

@end

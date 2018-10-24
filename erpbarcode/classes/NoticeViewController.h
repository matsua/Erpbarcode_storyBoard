//
//  NoticeViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 12. 11..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@protocol INoticeConfirm <NSObject>
- (void)noticeConfirm;
@end

@interface NoticeViewController : CommonViewController<UITextViewDelegate>
@property(strong, nonatomic) id <INoticeConfirm> noticeDeligate;
@property(nonatomic,strong) NSArray* noticeList;
@end

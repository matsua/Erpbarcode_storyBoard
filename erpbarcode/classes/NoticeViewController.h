//
//  NoticeViewController.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 12. 11..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INoticeConfirm <NSObject>
- (void)noticeConfirm;
@end

@interface NoticeViewController : UIViewController<UITextViewDelegate>
@property(strong, nonatomic) id <INoticeConfirm> noticeDeligate;
@property(nonatomic,strong) NSArray* noticeList;
@end

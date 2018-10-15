//
//  DatePickerViewController.h
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 3..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDatePickerView <NSObject>

- (void)selectDate:(NSString*)date showingDate:(NSString*)showingDate;
- (void)cancelDatePicker;

@end

@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) id<IDatePickerView> delegate;

- (IBAction)touchSelectBtn:(id)sender;
- (IBAction)touchCancelBtn:(id)sender;
- (void)hideDatePicker;

@end

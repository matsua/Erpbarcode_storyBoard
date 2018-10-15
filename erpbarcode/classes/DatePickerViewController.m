//
//  DatePickerViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 3..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchSelectBtn:(id)sender {
    NSDateFormatter *outputFormatterDate = [[NSDateFormatter alloc] init];
    [outputFormatterDate setDateFormat:@"yyyyMMdd"];
    NSString* date = [outputFormatterDate stringFromDate:datePicker.date];
    [outputFormatterDate setDateFormat:@"yyyy-MM-dd"];
    NSString* showingDate = [outputFormatterDate stringFromDate:datePicker.date];
    [self hideDatePicker];
    [self.delegate selectDate:date showingDate:showingDate];
}

- (IBAction)touchCancelBtn:(id)sender {
    [self hideDatePicker];
    [self.delegate cancelDatePicker];
}

- (void)hideDatePicker
{
    // 피커뷰의 위치를 구함
    CGRect pickerFrame = self.view.frame;
    
    // 에니메이션을 설정함
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    // 피커뷰의 이동 위치를 설정함
    pickerFrame.origin.y = self.view.superview.frame.size.height + 20;
    
    // 피커뷰에 적용함
    self.view.frame = pickerFrame;
    
    // 에니메이션을 시작함
    [UIView commitAnimations];
    
}

@end

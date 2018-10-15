//
//  CustomPickerView.m
// 
//
//  
//  Copyright (c) 2013년 KTH. All rights reserved.
//

#import "CustomPickerView.h"


@interface CustomPickerView()
@property(nonatomic, strong) NSArray *pickerData;


/**
 *  hideView에서 애니메이션 종료시 호출될 메소드, 키윈도우에서 피커뷰를 제거
 */
- (void)hideFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

/**
 *  취소 버튼 선택
 */
- (void)cancelPickerView;

/**
 *  선택 버튼 선택
 */
- (void)donePickerView;

@end


@implementation CustomPickerView
@synthesize delegate;
@synthesize pickerData;
@synthesize selectedIndex;
@synthesize lblDescription;
@synthesize isShow;

- (id)initWithFrame:(CGRect)frame data:(NSArray*)data
{
    self = [super initWithFrame:frame];
    if (self) {
         
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.frame = CGRectMake(0, 0, 320, 44);
        
        UIBarButtonItem *flexibleBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        

        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPickerView)];
       
       UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"완료" style:UIBarButtonItemStyleDone target:self action:@selector(donePickerView)];
        
        NSArray *buttonsArray = [[NSArray alloc] initWithObjects:flexibleBar,cancelBtn,doneBtn, nil];
        toolbar.items = buttonsArray;
        
        lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, 250, 30)];
        lblDescription.text = @"";
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.textColor = [UIColor whiteColor];
        [toolbar addSubview:lblDescription];
        
        [self addSubview:toolbar];
        
        //피커 설정
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 216)];
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = RGB(235, 235, 241);
        [self addSubview:pickerView];
        
        //피커 DataArray
        selectedIndex = 0;
        self.pickerData = [[NSArray alloc] initWithArray:data];
    }
    return self;
}

#pragma mark - method
- (void)selectPicker:(int)nSelectRow
{
    if (pickerData.count-1 >= nSelectRow){
        selectedIndex = nSelectRow;
        [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
        [self donePickerView];
    }
}
- (void)showView {
    UIWindow *wnd = [[UIApplication sharedApplication] keyWindow];
    
    [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    
	[wnd addSubview:self];
    isShow = YES;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView commitAnimations];
}

- (void)hideView {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideFinish:finished:context:)];
	[UIView commitAnimations];
}

- (void)hideFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self removeFromSuperview];
    isShow = NO;
}

- (void)cancelPickerView {
    if(delegate!=nil && [(id)delegate respondsToSelector:@selector(onCancel:)]) {
        [delegate onCancel:self];
    }
}

- (void)donePickerView {
    if(delegate!=nil && [(id)delegate respondsToSelector:@selector(onDone:sender:)]) {
        [delegate onDone:[pickerData objectAtIndex:selectedIndex] sender:self];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerData count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedIndex = (int)row;
}

@end

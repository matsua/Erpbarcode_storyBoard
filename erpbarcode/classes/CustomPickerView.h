//
//  CustomPickerView.h
//
//
//  
//  Copyright (c) 2013년 KTH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate

/**
 *  취소 버튼 클릭시 호출
 */
//- (void)onCancel;

/**
 *  선택 버튼 클릭시 호출
 *  @param data : 피커에서 선택된 값
 */
//- (void)onDone:(NSString*)data;



/**
 *  취소 버튼 클릭시 호출
 */
- (void)onCancel:(id)sender;

/**
 *  선택 버튼 클릭시 호출
 *  @param data : 피커에서 선택된 값
 */
- (void)onDone:(NSString*)data sender:(id)sender;

@end

/**
 *  메일 주소 입력용 피커뷰
 */
@interface CustomPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *pickerView;
}
@property(nonatomic, assign) id<CustomPickerViewDelegate>delegate;
@property(nonatomic, assign) int selectedIndex; // 선택한 피커 인덱스 참조용도 2012/04/20 jung
@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, strong) UILabel *lblDescription;
/**
 *  피커 설정
 *  @param data : 피커에서 노출될 값들
 */
- (id)initWithFrame:(CGRect)frame data:(NSArray*)data;

/**
 *  피커뷰를 노출
 */
- (void)showView;

/**
 *  피커뷰 내리기
 */
- (void)hideView;

// 피커 선택한것처럼 에뮬레이트 한다.
- (void)selectPicker:(int)nSelectRow;
@end

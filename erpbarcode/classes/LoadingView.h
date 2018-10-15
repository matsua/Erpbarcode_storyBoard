//
//  LoadingView.h
//  SmartFSB
//
//  Created by  Jung dae ho on 12. 8. 7..
//  Copyright (c) 2012년 SmartFSB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomActivityIndicatorView;

@interface LoadingView : UIView
@property (nonatomic,retain) UILabel      *refreshLabel;
//@property (nonatomic,retain) CustomActivityIndicatorView      *indicatorView;
@property (nonatomic,retain) UIActivityIndicatorView      *indicatorView;

/**
 *  로딩 애니메이션 시작
 */
-(void) startLoading;

/**
 *  로딩 상태 반환
 *  @return : 로딩 중이면 YES반환
 */
- (BOOL)isLoading;

-(void) stopLoading;

@end

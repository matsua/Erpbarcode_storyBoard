//
//  LoadingView.m
//  SmartFSB
//
//  Created by  Jung dae ho on 12. 8. 7..
//  Copyright (c) 2012년 SmartFSB. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@end

@implementation LoadingView
@synthesize refreshLabel;
@synthesize indicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro"]];
        backgroundView.frame = frame;
        
        NSLog(@"PHONE_SCREEN_WIDTH = %f", PHONE_SCREEN_WIDTH);
        NSLog(@"PHONE_SCREEN_HEIGHT = %f", PHONE_SCREEN_HEIGHT);
        
        int mHeight = 147;
        switch ((int)PHONE_SCREEN_HEIGHT) {
            case 568:
                printf("iPhone 5 or 5S or 5C");
                mHeight = 176;
                break;
            case 667:
                printf("iPhone 6/6S/7/8");
                mHeight = 208;
                break;
            case 736:
                printf("iPhone 6+/6S+/7+/8+");
                mHeight = 230;
                break;
            case 812:
                printf("iPhone X, Xs");
                mHeight = 255;
                break;
            default:
                printf("unknown");
                mHeight = 147;
        }
        

        // 버전정보를 표시하는 레이블 생성, 설정
        refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_SCREEN_WIDTH/2 - 3, PHONE_SCREEN_HEIGHT/2 + mHeight, 200, 15)];
        refreshLabel.backgroundColor = [UIColor clearColor];
        refreshLabel.font = [UIFont systemFontOfSize:12];
        refreshLabel.textColor = RGB(158, 158, 158);
        refreshLabel.shadowColor = [UIColor whiteColor];
        refreshLabel.shadowOffset = CGSizeMake(0, 1);
        refreshLabel.text = @"";
        
        if (![indicatorView isAnimating])
        {
            indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.frame = CGRectMake(PHONE_SCREEN_WIDTH/2-30, PHONE_SCREEN_HEIGHT/2-30, 60.0f, 60.0f);
            indicatorView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
            indicatorView.layer.cornerRadius = 10.0f;
            indicatorView.contentMode = UIViewContentModeCenter;
            [self addSubview:indicatorView];
            self.userInteractionEnabled = NO;
            [indicatorView startAnimating];
        }
        
        [self addSubview:backgroundView];
        [backgroundView addSubview:refreshLabel];
        [backgroundView addSubview:indicatorView];
        self.alpha = 0.0f;
    }
    return self;
}

-(void)startLoading
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    NSString *userVersionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    refreshLabel.text = userVersionNumber; //버전정보
    self.alpha = 1.0f;
    [indicatorView startAnimating];
    [UIView commitAnimations];
}

-(void)stopLoading
{
    [indicatorView stopAnimating];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideFinish:finished:context:)];
	self.alpha = 0.0f;
	[UIView commitAnimations];
    self.userInteractionEnabled = YES;
}


- (void)hideFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self removeFromSuperview];
}

- (BOOL)isLoading {
    return [indicatorView isAnimating];
}

@end

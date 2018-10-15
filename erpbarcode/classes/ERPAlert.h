//
//  ERPAlert.h
//  erpbarcode
//
//  Created by 박수임 on 14. 2. 12..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

// ERPAlert은 배포후 추가로 만들어진 클래스이다.
// Alert Message를 띄워주는 부분이 너무 많아 호출하는 쪽 코드변경 없이 클래스를 추가하기 위해
// 조금 비효율적인 부분이 있음.


@interface ERPAlert : NSObject

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) NSString* message;
@property (assign, nonatomic) NSInteger tag;
@property (strong, nonatomic) NSString* title1;
@property (strong, nonatomic) NSString* title2;
@property (assign, nonatomic) BOOL isError;
@property (assign, nonatomic) BOOL isCheckComplte;


+ (ERPAlert *)getInstance;
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)t1 title2:(NSString*)t2 isError:(BOOL)isError isCheckComplete:(BOOL)isCheckComplete delegate:(id)delegate;
- (void) showAlertMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)t1 title2:(NSString*)t2 isError:(BOOL)isError isCheckComplete:(BOOL)isCheckComplete delegate:(id)delegate;
@end

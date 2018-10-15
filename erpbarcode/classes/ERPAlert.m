//
//  ERPAlert.m
//  erpbarcode
//
//  Created by 박수임 on 14. 2. 12..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ERPAlert.h"

@implementation ERPAlert



- (id)init
{
    self = [super init];
    
    if (self){
        _message = @"";
        _tag = -1;
        _title1 = @"";
        _title2 = @"";
        _isError = NO;
        _isCheckComplte = YES;
    }
    
    return self;
}

+ (ERPAlert *)getInstance
{
    static ERPAlert *instance = nil;
    
    @synchronized(self)
    {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)t1 title2:(NSString*)t2 isError:(BOOL)isError isCheckComplete:(BOOL)isCheckComplete delegate:(id)delegate
{
    _delegate = delegate;
    _message = message;
    _tag = tag;
    _title1 = t1;
    _title2 = t2;
    _isError = isError;
    _isCheckComplte = isCheckComplete;
    [self performSelectorOnMainThread:@selector(showAlertMessage) withObject:nil waitUntilDone:NO];
}


// main thread로 실행하지 않으려 할 때...
- (void) showAlertMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)t1 title2:(NSString*)t2 isError:(BOOL)isError isCheckComplete:(BOOL)isCheckComplete delegate:(id)delegate
{
    _delegate = delegate;
    _message = message;
    _tag = tag;
    _title1 = t1;
    _title2 = t2;
    _isError = isError;
    _isCheckComplte = isCheckComplete;
    
    [self showAlertMessage];
}

- (void) showAlertMessage
{
    if (_isCheckComplte){
        if (![Util udBoolForKey:IS_ALERT_COMPLETE])
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
        
        //userDefault에 넣는다.
        [Util udSetBool:NO forKey:IS_ALERT_COMPLETE];
    }
    
    UIAlertView *av = nil;
    
    if(_title1 == nil || _title2.length == 0){
        av = [[UIAlertView alloc] initWithTitle:@"알림"
                                        message:_message
                                       delegate:_delegate
                              cancelButtonTitle:nil
                              otherButtonTitles:_title1, nil];
    }else {
        av = [[UIAlertView alloc] initWithTitle:@"알림"
                                        message:_message
                                       delegate:_delegate
                              cancelButtonTitle:nil
                              otherButtonTitles:_title1, _title2, nil];
    }
    
    if (_tag > 0)
        av.tag = _tag;
    [av show];
    
    [Util playSoundWithMessage:_message isError:_isError];
    
    if (_isCheckComplte){
        //버튼 누르기전까지 지연.
        while (![Util udBoolForKey:IS_ALERT_COMPLETE])
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
}

@end

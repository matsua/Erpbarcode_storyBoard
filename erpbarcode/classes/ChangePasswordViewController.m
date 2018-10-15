//
//  ChangePasswordViewController.m
//  erpbarcode
//
//  Created by matsua on 2014. 10. 1..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ERPRequestManager.h"

@interface ChangePasswordViewController ()
@property(nonatomic,strong) IBOutlet UITextField* password;
@property(nonatomic,strong) IBOutlet UITextField* password_confirm;
@property(nonatomic,strong) IBOutlet UITextView*  errMsg;
@property(nonatomic,strong) IBOutlet UIView* changeView;
@property(nonatomic,strong) IBOutlet UIView* errMsgView;
@property(nonatomic,strong) IBOutlet UIButton* endBtn;

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _changeView.hidden = NO;
    _errMsgView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)changePassword:(id)sender{
    NSLog(@"changePassword >> %@ %@", _password.text, _password_confirm.text);
    
    NSString *str = _password.text;
    NSString *str2 = _password_confirm.text;
    
    if(![str isEqualToString:str2]){
        _changeView.hidden = YES;
        _errMsgView.hidden = NO;
        [_errMsg setText:@"비밀번호가 일치하지 않습니다."];
        return;
    }
    
    if (str.length < 5 ||
        ([str rangeOfString: @"*"].length == 0 &&
                              [str rangeOfString: @"+"].length == 0 &&
                              [str rangeOfString: @"!"].length == 0 &&
                              [str rangeOfString: @"("].length == 0 &&
                              [str rangeOfString: @")"].length == 0 &&
                              [str rangeOfString: @"^"].length == 0 &&
                              [str rangeOfString: @"#"].length == 0 &&
                              [str rangeOfString: @"@"].length == 0 &&
                              [str rangeOfString: @"\\"].length == 0 ))
    {
        _changeView.hidden = YES;
        _errMsgView.hidden = NO;
        [_errMsg setText:@"비밀번호는 5자리 이상이며 특수문자 하나 이상 포함하시기 바랍니다."];
        return;
    }
    
    if([str isEqualToString:@"1234!"]){
        _changeView.hidden = YES;
        _errMsgView.hidden = NO;
        [_errMsg setText:@"초기 비밀번호로 변경하실 수 없습니다."];
        return;
    }
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_PASSWORD_CHANGE;
    
    [requestMgr requestPasswordChange:_password.text];
}

-(IBAction)closeModal:(id)sender{
    UIButton* btn = (UIButton*)sender;
    if(btn.tag == 1){
        _changeView.hidden = NO;
        _errMsgView.hidden = YES;
        _password.text = @"";
        _password_confirm.text = @"";
        return;
    }
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.password resignFirstResponder];
    [self.password_confirm resignFirstResponder];
}

#pragma processRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status{
    _endBtn.tag = 0;
    _changeView.hidden = YES;
    _errMsgView.hidden = NO;
    [_errMsg setText:@"비밀번호를 성공적으로\n\r변경하였습니다.\n\r새로운 비밀번호로 다시 로그인하시기 바랍니다."];
}

@end

//
//  EtcEquipmentViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "EtcEquipmentViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"
#import "AddInfoViewController.h"

#define KEYBOARD_SIZE   216


@interface EtcEquipmentViewController ()

@end


@implementation EtcEquipmentViewController

@synthesize _scrollView;
@synthesize lblOrgName;
@synthesize txtLocBarcode;
@synthesize scrollLocBarcodeName;
@synthesize lblLocBarcodeName;
@synthesize txtGoodsId;
@synthesize lblGoodsName;
@synthesize lblGoodsClass;
@synthesize lblAssetL;
@synthesize lblAssetM;
@synthesize lblAssetS;
@synthesize lblAssetD;
@synthesize lblMaker;
@synthesize txtMakerSN;
@synthesize lblItemClass;
@synthesize lblPartKind;
@synthesize btnRegDate;
@synthesize lblRegDate;
@synthesize sgmMakersYN;
@synthesize txtReqCount;
@synthesize datePickerVC;

@synthesize indicatorView;

@synthesize locCodeList;
@synthesize itemStatusList;
@synthesize infoDic;

@synthesize scrollAssetL;
@synthesize scrollAssetM;
@synthesize scrollAssetS;
@synthesize scrollAssetD;
@synthesize scrollGoodsClass;

@synthesize JOB_GUBUN;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize strUserOrgType;
@synthesize strBusinessNumber;
@synthesize strLocBarcode;
@synthesize strGoodsId;
@synthesize strSgmMakersYN;
@synthesize strRegDate;
@synthesize reqCount;
@synthesize pickerVisible;
@synthesize keyboardVisible;


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
    self.navigationController.navigationBarHidden = NO;
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    [self makeDummyInputViewForTextField];
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];

    _scrollView.contentSize = CGSizeMake(320, 480);

    datePickerVC = [[DatePickerViewController alloc] init];
    // 피커뷰의 생성 위치를 설정함
    CGRect dateFrame = CGRectMake(datePickerVC.view.frame.origin.x, self.view.frame.size.height + 20, datePickerVC.view.frame.size.width, datePickerVC.view.frame.size.height);
    datePickerVC.view.frame = dateFrame;
    datePickerVC.delegate = self;
    
    // 피커뷰를 루트뷰 위에 올림
    [self.view addSubview:datePickerVC.view];
    
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    strUserOrgType = [dic objectForKey:@"orgTypeCode"];
    strBusinessNumber = [dic objectForKey:@"bussinessNumber"];
    lblOrgName.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];

    [txtLocBarcode becomeFirstResponder];
    [self Clear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kdcBarcodeDataArrived:) name:kdcBarcodeDataArrivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kdcBarcodeDataArrivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - KSCAN Notification
-(void)kdcBarcodeDataArrived:(NSNotification*)noti
{
    KDCReader *kReader = (KDCReader *)[noti object];
    NSString* barcode = (NSString*)[kReader GetBarcodeData];
    UIResponder *firstResponder = [self findFirstResponder];
    if([firstResponder isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)firstResponder;
        textField.text = barcode;
        [self processShouldReturn:barcode tag:textField.tag];
    }
}


#pragma User Defined Method
- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){

        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtLocBarcode.inputView = dummyView;
    }
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //위치바코드
        if ([barcode length]){
            strLocBarcode = barcode;
            
//            if (
//                strLocBarcode.length > 17 &&
//                ![strLocBarcode hasPrefix:@"VS"] &&
//                ![[strLocBarcode substringFromIndex:17] isEqualToString:@"0000"]
//                ){
//                NSString* message = [NSString stringWithFormat:@"'베이' 위치로는 '%@'\n작업을 하실 수 없습니다.",JOB_GUBUN];
//                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//                [txtLocBarcode becomeFirstResponder];
//                return NO;
//            }
//            
//            if(strLocBarcode.length != 11 && strLocBarcode.length != 14 && strLocBarcode.length != 17 && strLocBarcode.length != 21){
//                NSString* message = @"처리할 수 없는 위치바코드입니다.";
//                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//                return YES;
//            }
            
            NSString* message = [Util barcodeMatchVal:1 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                txtLocBarcode.text = strLocBarcode = @"";
                [txtLocBarcode becomeFirstResponder];
                return YES;
            }
            
            [self requestLocCode:strLocBarcode];
        }
        else {
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

            [txtLocBarcode becomeFirstResponder];
            
            return NO;
        }
    }else if (tag == 300){   //물품코드
        strGoodsId = barcode;
        
        NSString* message = [Util barcodeMatchVal:4 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtGoodsId.text = strGoodsId = @"";
            [txtGoodsId becomeFirstResponder];
            return YES;
        }
        
        [self getGoodsInfo:strGoodsId];
    }
    
    return YES;
}

- (void)Clear
{
    txtLocBarcode.text = strLocBarcode = @"";
    txtGoodsId.text = strGoodsId = @"";
    lblGoodsName.text = @"";
    lblGoodsClass.text = @"";
    lblAssetL.text = @"";
    lblAssetM.text = @"";
    lblAssetS.text = @"";
    lblAssetD.text = @"";
    lblMaker.text = @"";
    txtMakerSN.text = @"";
    lblItemClass.text = @"";
    lblPartKind.text = @"";
    lblRegDate.text = [NSDate TodayStringWithDash];
    strRegDate = [NSDate TodayString];
    sgmMakersYN.selectedSegmentIndex = 0;
    txtReqCount.text = @"1";
    reqCount = 1;
    
    pickerVisible = NO;
    keyboardVisible = NO;
    
    strRegDate = @"";
    txtMakerSN.text = @"";
    [txtLocBarcode becomeFirstResponder];
    
    [self requestLogicalLocCode:YES locBarcode:@""];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    if (pickerVisible)
        [datePickerVC hideDatePicker];
    
    if ([txtLocBarcode isFirstResponder])
        return;
    
    CGRect scrollRect = _scrollView.frame;
    
    NSDictionary* userInfo = [notif userInfo];
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // 에니메이션을 설정함
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration:animationDuration]; // 에니메이션 시간
    // 에니메이션 효과
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    
    // 에니메이션 시작
    [UIView commitAnimations];

    if ([txtMakerSN isFirstResponder] || [txtReqCount isFirstResponder]){
        _scrollView.contentSize = CGSizeMake(320, 500 + KEYBOARD_SIZE);
        CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height + 500 + KEYBOARD_SIZE);
        [_scrollView scrollRectToVisible:viewRect animated:YES];
    }
    keyboardVisible = YES;
}


- (void)keyboardWillHide:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [UIView commitAnimations];
    
    CGRect scrollRect = _scrollView.frame;
    if ([txtMakerSN isFirstResponder] || [txtReqCount isFirstResponder]){
        _scrollView.contentSize = CGSizeMake(320, 480);
        CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height);
        [_scrollView scrollRectToVisible:viewRect animated:YES];
    }

    
    keyboardVisible = NO;
}

- (void)getGoodsInfo:(NSString*)goodsId
{
    if (goodsId == nil || [goodsId isEqualToString:@""]){
        NSString* message = @"물품코드 또는 물품명을 입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        
        return;
    }
    if (goodsId.length > 0 && goodsId.length < 6){
        NSString* message = @"물품코드를 6자리 이상 입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];

        return;
    }
    
    [self requestItemStatus:goodsId labelTitle:@"물품코드"];
}

- (void)resignFirstResponderForAllTxt
{
    [txtLocBarcode resignFirstResponder];
    [txtGoodsId resignFirstResponder];
    [txtMakerSN resignFirstResponder];
    [txtReqCount resignFirstResponder];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

- (void) showIndicator
{
    if (![indicatorView isAnimating])
    {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.frame = CGRectMake(PHONE_SCREEN_WIDTH/2-30, PHONE_SCREEN_HEIGHT/2-30, 60.0f, 60.0f);
        indicatorView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        indicatorView.layer.cornerRadius = 10.0f;
        indicatorView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:indicatorView];
        self.view.userInteractionEnabled = NO;
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [indicatorView startAnimating];
    }
}

- (void) hideIndicator
{
    if (indicatorView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
        self.view.userInteractionEnabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }
}


#pragma User Defined Action
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponderForAllTxt];
}

- (void) touchBackBtn:(id)sender
{
    [self resignFirstResponderForAllTxt];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changSegmentValue:(id)sender {
    if (sgmMakersYN.selectedSegmentIndex == 1)
        strSgmMakersYN = @"M";
    else
        strSgmMakersYN = @"B";
}

- (IBAction)touchGoodsInfo:(id)sender {
    [Util udSetObject:JOB_GUBUN forKey:USER_WORK_NAME];
    GoodsInfoViewController* vc = [[GoodsInfoViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchShowDateView:(id)sender {
    if (keyboardVisible){
        [txtMakerSN resignFirstResponder];
        [txtReqCount resignFirstResponder];
    }
    
    // 피커뷰의 크기를 구함
    CGRect pickerFrame = datePickerVC.view.frame;
    
    // 에니메이션을 설정함
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.1]; // 에니메이션 시간
    // 에니메이션 효과
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    // 이동할 위치 설정
    pickerFrame.origin.y = self.view.frame.size.height - pickerFrame.size.height;
    
    // 피커뷰에 적용
    datePickerVC.view.frame = pickerFrame;
    
    // 에니메이션 시작
    [UIView commitAnimations];
    
    _scrollView.contentSize = CGSizeMake(320, 500 + datePickerVC.view.frame.size.height);
    CGRect scrollRect = _scrollView.frame;
    CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height + datePickerVC.view.frame.size.height);
    [_scrollView scrollRectToVisible:viewRect animated:YES];
    
    pickerVisible = YES;
}

- (IBAction)touchRequest:(id)sender {
    if (!lblLocBarcodeName.text.length){
        NSString* message = @"위치바코드를 스캔하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
    }
    if (!strGoodsId.length){
        NSString* message = @"물품코드를 입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return;
    }
    
    if ([lblAssetL.text isEqualToString:@""]){
        NSString* message = @"자산분류가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
    }


    if ([txtReqCount.text isEqualToString:@""]){
        [txtReqCount becomeFirstResponder];
        NSString* message = @"요청개수를 정수로 입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
        
    }
    reqCount = [txtReqCount.text integerValue];
    if (reqCount > 30){
        [txtReqCount becomeFirstResponder];
        NSString* message = @"요청개수를 30개 이하로\n입력하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
    }
    NSString* message = @"전송하시겠습니까?";
    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if (alertView.tag == 100){
        if (buttonIndex == 0)
            [self requestSend];
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

#pragma ISelectGoodsInfo method
- (void)selectGoodsCode:(NSDictionary*)dic
{
    NSString* devType = [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZMATGB"]];
    NSString* partType = [WorkUtil getPartTypeFullName:[dic objectForKey:@"COMPTYPE"] device:[dic objectForKey:@"ZMATGB"]];
    // 물품명
    lblGoodsName.text = [dic objectForKey:@"MAKTX"];
    // 물품분류
    [Util setScrollTouch:scrollGoodsClass Label:lblGoodsClass withString:[dic objectForKey:@"ITEMCLASSIFICATIONNAME"]];
    // 제조사
    lblMaker.text = [dic objectForKey:@"ZEMAFT_NAME"];
    // 물품코드
    txtGoodsId.text = [dic objectForKey:@"MATNR"];
    strGoodsId = txtGoodsId.text;
    // 품목구분
    lblItemClass.text = devType;
    //부품종류
    lblPartKind.text = partType;
    
    [self requestAssetClass:strGoodsId];
}

- (void)cancelGoodsInfo
{
    
}

#pragma IDatePickerView
- (void) selectDate:(NSString *)date showingDate:(NSString *)showingDate
{
    CGRect scrollRect = _scrollView.frame;
    _scrollView.contentSize = CGSizeMake(320, 480);

    CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height);
    [_scrollView scrollRectToVisible:viewRect animated:YES];
    
    pickerVisible = NO;
    strRegDate = date;
    lblRegDate.text = showingDate;
}

- (void) cancelDatePicker
{
    CGRect scrollRect = _scrollView.frame;
    _scrollView.contentSize = CGSizeMake(320, 480);
    CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height);
    [_scrollView scrollRectToVisible:viewRect animated:YES];

    pickerVisible = NO;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if ([string isEqualToString:@"\n"]){
        NSLog(@"newline char range [%@] string[%@]",NSStringFromRange(range),string);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

#pragma mark - Http Request Method
- (void)requestAuthLocation:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_OTD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    //    [self showIndicator];
    
    [requestMgr requestAuthLocation:locBarcode];
}

- (void)requestLogicalLocCode:(BOOL)isRequireOrg locBarcode:(NSString*)locBarcode
{
    /*
    if (![strUserOrgType isEqualToString:@"REP_USER"] && ![strUserOrgType isEqualToString:@"INS_USER"]) return;

    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOGICAL_LOC;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLogicalLocCode:locBarcode isNeedUserInfo:isRequireOrg];
    */
}


- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLocCode:locBarcode];
}

- (void)requestItemStatus:(NSString*)matnr labelTitle:(NSString*)label
{
    // 먼저 기존 정보 초기화
    // 물품명
    lblGoodsName.text = @"";
    // 물품분류
    lblGoodsClass.text = @"";
    // 제조사
    lblMaker.text = @"";
    // 물품코드
    //txtGoodsId.text = @"";
    strGoodsId = txtGoodsId.text;
    // 품목구분
    lblItemClass.text = @"";
    //부품종류
    lblPartKind.text = @"";
    //자산분류
    lblAssetL.text = @"";lblAssetM.text = @"";lblAssetS.text = @"";lblAssetD.text = @"";
    
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = IM_REQUEST_ITEM_STATUS;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:matnr forKey:@"matnr"];
    [paramDic setObject:@"" forKey:@"maktx"];
    [paramDic setObject:@"" forKey:@"bismt"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_SEARCH_ITEMINFO withData:bodyDic];
}


- (void)requestAssetClass:(NSString*)goodsId
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = IM_REQUEST_SEARCH_ASSET;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:goodsId forKey:@"itemCode"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_SEARCH_ASSET withData:bodyDic];
}

- (void) requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;

    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary* paramDic = [NSMutableDictionary dictionary];
    NSString* zkostl = strUserOrgCode;
    NSString* zeqrt1 = [infoDic objectForKey:@"assetLargeClassificationCode"];
    NSString* zeqrt2 = [infoDic objectForKey:@"assetMiddleClassificationCode"];
    NSString* zeqrt3 = [infoDic objectForKey:@"assetSmallClassificationCode"];
    NSString* zeqrt4 = [infoDic objectForKey:@"assetDetailClassificationCode"];
    NSString* submt = txtGoodsId.text;
    NSString* serge = txtMakerSN.text;
    NSString* partType = lblPartKind.text;
    NSString* devType = [WorkUtil getDeviceCode:lblItemClass.text];
    if (sgmMakersYN.selectedSegmentIndex == 1)
        strSgmMakersYN = @"M";
    else
        strSgmMakersYN = @"B";
    
    [paramDic setObject:zkostl forKey:@"ZKOSTL"];
    [paramDic setObject:@"1" forKey:@"PBLS_CNT"];
    [paramDic setObject:@"IMD" forKey:@"GNRT_REQ_TP_CD"];
    [paramDic setObject:@"INS" forKey:@"GNRT_TARG_CD"];
    [paramDic setObject:@"2" forKey:@"PBLS_WHY_CD"];
    [paramDic setObject:zeqrt1 forKey:@"ZEQART1"];
    [paramDic setObject:zeqrt2 forKey:@"ZEQART2"];
    [paramDic setObject:zeqrt3 forKey:@"ZEQART3"];
    [paramDic setObject:zeqrt4 forKey:@"ZEQART4"];
    [paramDic setObject:submt forKey:@"SUBMT"];
    [paramDic setObject:serge forKey:@"SERGE"];
    [paramDic setObject:strRegDate forKey:@"OBT_DAY"];
    [paramDic setObject:partType forKey:@"ZPTART"];
    [paramDic setObject:devType forKey:@"PGUBUN"];
    [paramDic setObject:strLocBarcode forKey:@"ZEQUIPLP"];

    // GPS 위치조회 하지 않는 방법으로 변경. 16.11.22
//    if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
//        [ERPLocationManager getInstance].locationDic != nil){
//        NSDictionary* deltaDic = [ERPLocationManager getInstance].locationDic;
//        
//        NSString* longitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LONGTITUDE"] floatValue]];
//        NSString* latitude =  [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LATITUDE"] floatValue]];
//        
//        [paramDic setObject:longitude forKey:@"LONGTITUDE"];
//        [paramDic setObject:latitude forKey:@"LATITUDE"];
//        NSString* locFucllName = [[locCodeList objectAtIndex:0] objectForKey:@"locationFullName"];
//        locFucllName = [WorkUtil getFullNameOfLoc:locFucllName];
//        
//        double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:locFucllName];
//        [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
//    }else{
//        [paramDic setObject:@"" forKey:@"LONGTITUDE"];
//        [paramDic setObject:@"" forKey:@"LATITUDE"];
//        [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
//    }
    
    [paramDic setObject:strSgmMakersYN forKey:@"ZKEQUI"];

    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    reqCount--;
    
    [requestMgr sychronousConnectToServer:API_SUBMIT_INSTOREMARKING withData:bodyDic];
}


#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(pid == REQUEST_DATA_NULL && status == 99){
        return;
    }
    
    NSString* message = @"";
    if (resultList.count){
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        message = [headerDic objectForKey:@"detail"];
    }
    
    if (status == 0 || status == 2){ //실패
        [self processFailRequest:pid Message:message];
        
        return;
    }else if (status == -1){ //세션종료
        [self processEndSession:pid];
        return;
    }
    
    if (pid != REQUEST_SEND && (resultList == nil || [resultList count] <= 0))
    {
        NSLog(@"There are not exist result");
        return;
    }
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == REQUEST_OTD){
    }else if (pid == IM_REQUEST_ITEM_STATUS){
        [self processItemStatusResponse:resultList];
    }else if (pid == IM_REQUEST_SEARCH_ASSET){
        [self processSearchAssetResponse:resultList];
    }else if (pid == REQUEST_LOGICAL_LOC){
        [self processLogicalLocResponse:resultList];
    }else if (pid == REQUEST_SEND){
        if (reqCount <= 0){
            NSString* returnMessageFromSAP = message;
            NSLog(@"PrintMessage [%@]", message);
            if (returnMessageFromSAP == nil || [returnMessageFromSAP isEqualToString:@""] )
                returnMessageFromSAP = @"정상 전송되었습니다.";
            
            NSString* msg = [NSString stringWithFormat:@"# 전송건수 : %@건\n\n%@",
                             txtReqCount.text,returnMessageFromSAP];
            [self showMessage:msg tag:-1 title1:@"닫기" title2:nil isError:NO];
            
            [self Clear];
        }else{
            [self requestSend];
        }
    }
}

- (void)processLogicalLocResponse:(NSArray*)resultList
{
    if ([resultList count]){
        BOOL isCheckOTD = NO;
        NSString* locCode = @"";
        NSString* locName = @"";
        
        for (NSDictionary* dic in resultList)
        {
            NSString* storageType = [dic objectForKey:@"storageType"];
            locCode = [dic objectForKey:@"storageLocationCode"];
            locName = [dic objectForKey:@"storageLocationName"];
            
            if (![strUserOrgType isEqualToString:@"INS_USER"]) {
                if ([storageType isEqualToString:@"06"])
                    isCheckOTD = YES;
            }
            else {
                if ([storageType isEqualToString:@"04"]){
                    isCheckOTD = YES;
                    break;
                }
            }
        }
        
        if (true) return;   // DR-2014-31084 : 납품입고시 위치바코드 스캔 원칙으로 변경 - request by 박장수 2014.07.01 -> changed by 류성호 2014.07.03

        if (isCheckOTD){
            if (locName.length){
                [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:locName];
            }
            if (locCode.length){
                strLocBarcode = locCode;
                txtLocBarcode.text = strLocBarcode;
                
                [self requestAuthLocation:locCode];
            }
        }
    }
    [txtGoodsId becomeFirstResponder];
}

- (void)processLocList:(NSArray*)locList
{
    if (locList){
        NSDictionary* dic = [locList objectAtIndex:0];
        [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:[dic objectForKey:@"locationShortName"]];
        
        strLocBarcode = [dic objectForKey:@"completeLocationCode"];
        
        if ([locCodeList count])
            txtLocBarcode.text = strLocBarcode;
        
        [self requestAuthLocation:strLocBarcode];
    }
    else { //
        NSString* message = @"검색된 위치바코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void)processItemStatusResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        
        NSString* mtart;
        NSString* barcd;
        NSString* devType;
        NSString* comptype;
        
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            comptype = @"";
        else
            comptype = [dic objectForKey:@"COMPTYPE"];
        
        if ([[dic objectForKey:@"ZMATGB"] isKindOfClass:[NSNull class]])
            devType = @"";
        else
            devType = [dic objectForKey:@"ZMATGB"];
        
        if ([[dic objectForKey:@"MTART"] isKindOfClass:[NSNull class]])
            mtart = @"";
        else
            mtart = [dic objectForKey:@"MTART"];
        
        if ([[dic objectForKey:@"BARCD"] isKindOfClass:[NSNull class]])
            barcd = @"";
        else
            barcd = [dic objectForKey:@"BARCD"];
        
        NSString* partType = [WorkUtil getPartTypeFullName:comptype device:devType];
        
        if ([devType isEqualToString:@"40"] && [partType isEqualToString:@"40"]){
            NSString* message = @"부품종류가 존재하지 않습니다.\n기준정보 관리자(MDM)에게\n문의하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        }
        else if (![mtart isEqualToString:@"ERSA"] || ![barcd isEqualToString:@"Y"]){
            NSString* message = @"처리할 수 없는 물품코드입니다.\n(SAP 상의 자재유형이 'ERSA'가 아니거나 바코드라벨링이‘Y’가 아님)";
            
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:YES];
        }
        else{
            // 물품명
            lblGoodsName.text = [dic objectForKey:@"MAKTX"];
            // 물품분류
            [Util setScrollTouch:scrollGoodsClass Label:lblGoodsClass withString:[dic objectForKey:@"ITEMCLASSIFICATIONNAME"]];
            // 제조사
            lblMaker.text = [dic objectForKey:@"ZEMAFT_NAME"];
            // 물품코드
            txtGoodsId.text = [dic objectForKey:@"MATNR"];
            strGoodsId = txtGoodsId.text;
            // 품목구분
            lblItemClass.text = devType;
            //부품종류
            lblPartKind.text = partType;
            
            [self requestAssetClass:strGoodsId];
            
            [txtGoodsId resignFirstResponder];
        }
    }else {
        lblGoodsName.text = @"";
        [self showMessage:@"물품정보가 존재하지 않습니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
        [txtGoodsId resignFirstResponder];
    }
    
}

- (void)processSearchAssetResponse:(NSArray*)resultList
{
    if ([resultList count]){
        if (![resultList count]){
            NSString* message = @"자산분류가 존재하지 않습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            
            return;
        }
        
        NSDictionary* dic = [resultList objectAtIndex:0];
        infoDic = dic;
        [Util setScrollTouch:scrollAssetL Label:lblAssetL withString:[dic objectForKey:@"assetLargeClassificationName"]];
        [Util setScrollTouch:scrollAssetM Label:lblAssetM withString:[dic objectForKey:@"assetMiddleClassificationName"]];
        [Util setScrollTouch:scrollAssetS Label:lblAssetS withString:[dic objectForKey:@"assetSmallClassificationName"]];
        [Util setScrollTouch:scrollAssetD Label:lblAssetD withString:[dic objectForKey:@"assetDetailClassificationName"]];
    }
}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        if (pid == REQUEST_LOC_COD)
            [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:@""];
        
        if (pid == REQUEST_LOC_COD || pid == REQUEST_LOGICAL_LOC){
            if (![txtLocBarcode isFirstResponder])
                [txtLocBarcode becomeFirstResponder];
        }
    }
}

- (void) processEndSession:(requestOfKind)pid
{
    if (pid == REQUEST_LOC_COD)
        [Util setScrollTouch:scrollLocBarcodeName Label:lblLocBarcodeName withString:@""];
    
    if (pid == REQUEST_LOC_COD || pid == REQUEST_LOGICAL_LOC){
        if (![txtLocBarcode isFirstResponder])
            [txtLocBarcode becomeFirstResponder];
    }

    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
}

// matsua: 주소정보조회 팝업 추가
- (IBAction) locInfoBtnAction:(id)sender{
    
    if(strLocBarcode.length < 1){
        return;
    }
    
    [self.view endEditing:YES];
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] init];
    modalView.delegate = self;
    [modalView openModal:strLocBarcode];
}

#pragma popRequest delegate -- call by AddInfoViewController
- (void)popRequest:(NSString *)locAddrBd locAddrLoad:(NSString *)locAddrLoad{
    
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if(!locAddrBd.length && !locAddrLoad.length){
        [self showMessage:@"위치정보가 없습니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] initWithNibName:@"AddInfoViewController" bundle:nil];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    modalView.locCd = strLocBarcode;
    modalView.locNm = lblLocBarcodeName.text;
    modalView.locNmBd = locAddrBd;
    modalView.locNmLoad = locAddrLoad;
    
    [self presentViewController:modalView animated:NO completion:nil];
    modalView.view.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        modalView.view.alpha = 1;
    }];
}


@end

//
//  IMRequestViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 29..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "IMRequestViewController.h"
#import "IMRequestCell1.h"
#import "IMRequestCell2.h"
#import "IMRequestCell3.h"
#import "IMRequestCell4.h"
#import "IMRequestCell5.h"
#import "IMRequestCell6.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPLocationManager.h"
#import "ERPAlert.h"
#import "AddInfoViewController.h"

#define KEYBOARD_SIZE   216

@interface IMRequestViewController ()

@end

@implementation IMRequestViewController

@synthesize _itemScrollVIew;
@synthesize lblOrgName;
@synthesize txtLocBarcode;
@synthesize scrollLocBarcode;
@synthesize lblLocBarcodeName;
@synthesize txtDeviceId;
@synthesize txtGoodsId;
@synthesize btnGoodsList;
@synthesize lblGoodsName;
@synthesize txtUpperId;
@synthesize btnRequestReason;
@synthesize lblRequestReason;
@synthesize txtDamageId;
@synthesize txtMakerSN;
@synthesize lblCount;
@synthesize pageCtrl;
@synthesize _scrollView;
@synthesize viewTitle1;
@synthesize viewTitle2;
@synthesize viewTitle3;
@synthesize viewTitle4;
@synthesize viewTitle5;
@synthesize viewTitle6;
@synthesize _table1;
@synthesize _table2;
@synthesize _table3;
@synthesize _table4;
@synthesize _table5;
@synthesize _table6;
@synthesize viewDamagedBarcode;
@synthesize viewDeviceId;
@synthesize viewGoodsId;
@synthesize viewGoodsName;
@synthesize viewMakerSN;
@synthesize viewRequestReason;
@synthesize viewUpperBarcode;

@synthesize picker;


@synthesize dataList;
@synthesize locCodeList;
@synthesize itemStatusList;

@synthesize selectedRow;
@synthesize JOB_GUBUN;
@synthesize strUserOrgCode;
@synthesize strUserOrgName;
@synthesize strLocCode;
@synthesize strDeviceId;
@synthesize strGoodId;
@synthesize strDamageId;
@synthesize selectedPickerData;
@synthesize sendCount;
@synthesize instoreMarkingRequestReason;
@synthesize keyboardVisible;
@synthesize scrollRect;
@synthesize tabPressGesture;
@synthesize  isChangeGoodsIdMode;
@synthesize isGetGoods;
@synthesize nSelectedRow;

@synthesize indicatorView;

@synthesize  isShowPicker;

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

    [self makeDummyInputViewForTextField];
    
    JOB_GUBUN = [Util udObjectForKey:USER_WORK_NAME];
    self.title = [NSString stringWithFormat:@"%@%@", JOB_GUBUN, [Util getTitleWithServerNVersion]];
    
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    
    CGRect itemScrollViewRect = [_itemScrollVIew bounds];
    _itemScrollVIew.contentSize = CGSizeMake(itemScrollViewRect.size.width, itemScrollViewRect.size.height + KEYBOARD_SIZE - (self.view.frame.size.height - itemScrollViewRect.size.height));
    
    NSDictionary* dic = [Util udObjectForKey:USER_INFO];
    strUserOrgCode = [dic objectForKey:@"orgId"];
    strUserOrgName = [dic objectForKey:@"orgName"];
    lblOrgName.text = [NSString stringWithFormat:@"%@/%@",strUserOrgCode,strUserOrgName];
    
    // grid스타일 페이지를 만들어준다.
    [self createPages];
    
    // 요청사유 필드에 "선택하세요"라고 초기값을 설정한다.
    lblRequestReason.text = @"선택하세요.";
    lblRequestReason.textColor = [UIColor lightGrayColor];

    // pickerView의 초기 리스트값을 설정한다.
    picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"훼손",@"오부착(교환)",@"교품"]];
    picker.delegate = self;
    
    // "물품코드를 변경하시겠습니까?"라는 물음에 의한 것인지 여부...  처음엔 아닌거로 설정
    isChangeGoodsIdMode = NO;
    nSelectedRow = -1;
    
    //single tap gesture add
    tabPressGesture = [[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(handleSingleTap:)];
    tabPressGesture.numberOfTapsRequired = 1;
    tabPressGesture.delegate = self;
    [self._table1 addGestureRecognizer:tabPressGesture];

    //위도,경도 얻어온다.
//    [[ERPLocationManager getInstance] getMyPosition];

    selectedPickerData = @"";
    
    [txtLocBarcode becomeFirstResponder];
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

#pragma User Define Action
// 키보드를 올려주면서 스크롤 위치를 변경해 주기 위해서...(키보드에 의행 해당 항목이 가려지지 않도록 하기 위해)
- (void)keyboardWillShow:(NSNotification *)notif
{
    // 키보드를 올려주기 전에 피커뷰가 띄워져 있으면 숨겨준다.
    if (isShowPicker)
        [picker hideView];
    
    // 아래의 항목은 키보드가 올라와도 항목이 가려지지 않으므로 그냥 리턴한다.
    if ([txtLocBarcode isFirstResponder] || [txtDeviceId isFirstResponder] ||
        [txtGoodsId isFirstResponder] || [txtUpperId isFirstResponder] ||
        [txtDamageId isFirstResponder])
        return;
    
    scrollRect = _itemScrollVIew.frame;
    
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
    
    NSInteger orgPos = 0;
    if ([txtDamageId isFirstResponder])
        orgPos = viewDamagedBarcode.frame.origin.y;
    else if ([txtMakerSN isFirstResponder])
        orgPos = viewMakerSN.frame.origin.y;
    if (orgPos){
        CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height + orgPos);
        [_itemScrollVIew scrollRectToVisible:viewRect animated:YES];
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
    CGRect viewRect = CGRectMake(scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height);
    [_itemScrollVIew scrollRectToVisible:viewRect animated:YES];

    keyboardVisible = NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponderForAllTxt];
}

- (void) touchBackBtn:(id)sender
{
    if (picker.isShow)
        [picker hideView];
    
    [self resignFirstResponderForAllTxt];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchGoodsListBtn:(id)sender {
    [Util udSetObject:JOB_GUBUN forKey:USER_WORK_NAME];
    GoodsInfoViewController* vc = [[GoodsInfoViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchRequestReasonBtn:(id)sender {
    [self resignFirstResponderForAllTxt];

    [picker showView];
}

- (IBAction)touchInitBtn:(id)sender {
    [self Clear];
}

- (IBAction)touchSearchBtn:(id)sender {
    if (txtLocBarcode.text.length == 0 && txtDeviceId.text.length == 0 &&
        txtGoodsId.text.length == 0 && txtDamageId.text.length == 0 &&
        txtUpperId.text.length == 0 && txtMakerSN.text.length == 0){
        NSString* msg = @"검색조건을 입력하세요.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    if (txtLocBarcode.text.length > 0 && txtUpperId.text.length != 0 &&
        txtDamageId.text.length != 0){
        if (txtDeviceId.text.length == 0 && txtGoodsId.text.length == 0 &&
            txtMakerSN.text.length == 0 && [selectedPickerData isEqualToString:@""]){
            NSString* message = @"위치바코드를 포함한 검색조건을 하나 이상 입력하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];

            return;
        }
    }
    dataList = [NSMutableArray array];
    [self reloadTables];
    
    lblCount.text = @"0건";
    
    [self closeKeyboard:nil];
    [self requestSearch];
}

- (IBAction)touchDeleteBtn:(id)sender {
    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:dataList];
    if ((int)[dataList count] <= 0 || !indexset.count){
        NSString* message = @"선택된 항목이 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
    }
    [dataList removeObjectsAtIndexes:indexset];
    [self reloadTables];
}

- (IBAction)touchRequestBtn:(id)sender {
    if ([selectedPickerData isEqualToString:@"선택하세요."] || [selectedPickerData isEqualToString:@""]){
        NSString* message = @"요청사유를 선택하세요.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

        return;
    }
    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:dataList];
    if (!indexset.count){
        NSString* message = @"전송할 설비바코드가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        return;
    }

    NSString* message = @"전송하시겠습니까?";
    [self showMessage:message tag:200 title1:@"예" title2:@"아니오"];
}

- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    if (dataList.count) {
        NSMutableDictionary* selectItem = [dataList objectAtIndex:btn.tag];
 
        if ([[selectItem objectForKey:@"ISEXIST"] isEqualToString:@"Y"]){
            NSString* message = @"이미 요청 중인 바코드입니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        // 물품코드 사용중지여부 따지지 않게 변경 - request by 김희선 - 2014.01.08
        /*
        if ([[selectItem objectForKey:@"status"] isEqualToString:@"사용중지"] &&
            [[selectItem objectForKey:@"extGW"] isEqualToString:@""]){
            NSString* message = @"사용중지된 물품은 처리할 수 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return;
        }
        */
        
        NSString* partTypeCode = [selectItem objectForKey:@"ZPGUBUN"];
        NSString* devTypeCode = [selectItem objectForKey:@"ZPPART"];
        NSString* statusName = [selectItem objectForKey:@"ZPSTATU_NAME"];
        
        if ([devTypeCode isEqualToString:@"40"] && [partTypeCode isEqualToString:@"40"]){
            NSString* message = @"부품종류가 존재하지 않습니다.\n기준정보 관리자(MDM)에게\n문의하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return;
        }
        
        // 납품취소, 사용중지, 불용확정 - 검색시 걸리므로 이쪽로직에서는 삭제함
        // 불용요청, 인수예정, 인계완료, 납품입고, 이동중 일때는 바코드 대체요청 처리하지 않음
        if (
//            [statusName isEqualToString:@"납품취소"] ||
//            [statusName isEqualToString:@"사용중지"] ||
            [statusName isEqualToString:@"불용확정"] ||
            [statusName isEqualToString:@"불용요청"] ||
            [statusName isEqualToString:@"인수예정"] ||
            [statusName isEqualToString:@"인계완료"] ||
            [statusName isEqualToString:@"납품입고"] ||
            [statusName isEqualToString:@"이동중"] ||
            [statusName isEqualToString:@"시설등록완료"]){
            NSString* message = [NSString stringWithFormat:@"설비의 상태가 '%@'인 설비는\n처리할 수 없습니다.", statusName];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
            return;
        }
        
        btn.selected = !btn.selected;
        
        [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];
        [self reloadTables];
    }
}

- (IBAction)changePage:(id)sender {
    int page = (int)pageCtrl.currentPage;
	
	// 지정된 페이지로 스크롤 뷰의 내용을 스크롤한다.
	CGRect frame = _scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[_scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)closeKeyboard:(id)sender {
    [self resignFirstResponderForAllTxt];
}

#pragma ISelectGoodsInfo method
- (void)selectGoodsCode:(NSDictionary*)dic
{
    if (isChangeGoodsIdMode){
        if (nSelectedRow >= 0){
            NSMutableDictionary* selDic = [dataList objectAtIndex:nSelectedRow];
            
            [selDic setObject:[dic objectForKey:@"MATNR"] forKey:@"SUBMT"];
            [selDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [_table1 reloadData];
            [_table2 reloadData];
        }
        isChangeGoodsIdMode = NO;
        
        NSString* message = [NSString stringWithFormat:@"'오부착(교환)' 물품코드를\n'%@'로\n설정하였습니다.", [dic objectForKey:@"MATNR"]];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }else{
        txtGoodsId.text = [dic objectForKey:@"MATNR"];
        lblGoodsName.text = [dic objectForKey:@"MAKTX"];
    }
}

- (void)cancelGoodsInfo
{
    
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
        txtDeviceId.inputView = dummyView;
        txtGoodsId.inputView = dummyView;
        txtUpperId.inputView = dummyView;
        txtDamageId.inputView = dummyView;
    }
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //위치바코드
        strLocCode = barcode;
        
        NSString* message = [Util barcodeMatchVal:1 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtLocBarcode.text = strLocCode = @"";
            [txtLocBarcode becomeFirstResponder];
            return YES;
        }
        
//        if(strLocCode.length != 11 && strLocCode.length != 14 && strLocCode.length != 17 && strLocCode.length != 21){
//            NSString* message = @"처리할 수 없는 위치바코드입니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            
//            [txtLocBarcode becomeFirstResponder];
//            
//            return YES;
//        }
        
        [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcodeName withString:@""];
        
        [self requestLocCode:strLocCode];
    }else if (tag == 300){   //물품코드
        strGoodId = barcode;
        
        NSString* message = [Util barcodeMatchVal:4 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            txtGoodsId.text = strGoodId = @"";
            [txtGoodsId becomeFirstResponder];
            return YES;
        }
        
        [self getGoodsInfo:strGoodId];
    }
    
    return YES;
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


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if (alertView.tag == 100)  {
        if (buttonIndex == 0){
            [self resignFirstResponderForAllTxt];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 200){
        if (buttonIndex == 0){
            [self requestSend];
        }
    }else if (alertView.tag == 300){
        if (buttonIndex == 0){
            isChangeGoodsIdMode = YES;
            [Util udSetObject:JOB_GUBUN forKey:USER_WORK_NAME];
            GoodsInfoViewController* vc = [[GoodsInfoViewController alloc]init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}


#pragma mark - handle gesture
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (dataList.count){
        CGPoint p = [gestureRecognizer locationInView:_table1];
        NSIndexPath* indexPath = [_table1 indexPathForRowAtPoint:p];
        if(p.x < 58 || !indexPath){  // 물품코드 출력시만 처리 함 || tableList의 index 범위 벗어나지 않은 경우
        }
        else if (![selectedPickerData isEqualToString:@"오부착(교환)"]){
            NSString* message = @"요청사유가 '오부착(교환)' 일 경우에만\n물품코드 변경이 가능합니다.";

            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }
        else{
            nSelectedRow = indexPath.row;
            
            NSString* message = @"요청사유가 '오부착(교환)' 입니다.\n물품코드를 변경하시겠습니까?";
            [self showMessage:message tag:300 title1:@"예" title2:@"아니오"];
        }
    }
}


#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    if (![lblRequestReason.text hasPrefix:@"선택하세요."])
        lblRequestReason.text = selectedPickerData;
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [picker hideView];
}

- (void)onDone:(NSString *)data sender:(id)sender {
    lblRequestReason.textColor = [UIColor blackColor];
    selectedPickerData = data;
    lblRequestReason.text = data;
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [picker hideView];
}

- (void)selectPickerViewData:(NSString *)selectData
{
    selectedPickerData = selectData;
    lblRequestReason.text = selectData;
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        static NSString *CellIdentifier = @"IMRequestCell1Id";
        IMRequestCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell1" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblFacId.text = [dic objectForKey:@"FEQUNR"];
            cell.lblFacStatus.text = [dic objectForKey:@"ZPSTATU_NAME"];
            cell.lblGoodsId.text = [dic objectForKey:@"SUBMT"];
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [dataList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
        }
        return cell;
    }else if (tableView.tag == 2){
        static NSString *CellIdentifier = @"IMRequestCell2Id";
        IMRequestCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell2" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblGoodsName.text = [dic objectForKey:@"MAKTX"];
            cell.lblItemDevision.text = [dic objectForKey:@"ZPGUBUN_NAME"];//[WorkUtil
            cell.lblPartsKind.text = [dic objectForKey:@"PARTTYPENAME"];
        }
        return cell;
    }else if (tableView.tag == 3){
        static NSString *CellIdentifier = @"IMRequestCell3Id";
        IMRequestCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell3" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblLocId.text = [dic objectForKey:@"ZEQUIPLP"];
            cell.lblLocName.text = [dic objectForKey:@"PLOCNAME"];
        }
        return cell;
    }else if (tableView.tag == 4){
        static NSString *CellIdentifier = @"IMRequestCell4Id";
        IMRequestCell4 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell4" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblAssets.text = [dic objectForKey:@"ZASANBUNRYU"];
            cell.lblAssetsDetail.text = [dic objectForKey:@"ZASANBUNRYU2"];
        }
        return cell;
    }else if (tableView.tag == 5){
        static NSString *CellIdentifier = @"IMRequestCell5Id";
        IMRequestCell5 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell5" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblMakerName.text = [NSString stringWithFormat:@"%@/%@",
                                      [dic objectForKey:@"NAME1"], [dic objectForKey:@"HERST"]];
            cell.lblMakerSN.text = [dic objectForKey:@"SERGE"];
            cell.lblDeviceId.text = [dic objectForKey:@"ZEQUIPGC"];
        }
        
        return cell;
    }else if (tableView.tag == 6){
        static NSString *CellIdentifier = @"IMRequestCell6Id";
        IMRequestCell6 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"IMRequestCell6" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblStopUseYN.text = [dic objectForKey:@"status"];
            cell.lblReplaceGoodsId.text = [dic objectForKey:@"extGW"];
            cell.lblOrgReqStat.text = [dic objectForKey:@"ISEXIST"];
            cell.lblCostCencer.text = [dic objectForKey:@"ZKOSTL"];
        }
        
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

//  셀 선택이 가능한 경우 테이블 두개의 선택 싱크를 맞추기 위함
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    // 두개의 테이블이 동시에 같은 row가 선택되도록 하기 위함
    [_table1 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_table2 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_table3 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_table4 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_table5 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_table6 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    selectedRow = indexPath.row;
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


#pragma User Defined Method
- (void)createPages
{
    if ([_scrollView.subviews count])
        for (UIView *subView in [_scrollView subviews])
            [subView removeFromSuperview];
    
    
	CGRect pageRect = [_scrollView bounds];
    pageRect.origin.y = 339;
    pageRect.size.height = _itemScrollVIew.contentSize.height - pageRect.origin.y;
    
    [_scrollView setFrame:pageRect];
    CGRect tableRect = pageRect;
    CGRect titleRect = CGRectMake(0, 0, 320, 23);
    tableRect.origin.y = titleRect.size.height;
    tableRect.size.height = pageRect.size.height - titleRect.size.height;
    ;
    
    
    // 첫번째 페이지 생성
    UIView* firstView = [[UIView alloc]initWithFrame:pageRect];
    firstView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle1.frame = titleRect;
    [firstView addSubview:viewTitle1];
    
    _table1 = [[UITableView alloc]initWithFrame:tableRect];
    _table1 .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _table1.delegate = self;
    _table1.dataSource = self;
    _table1.tag = 1;
    _table1.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:_table1];
    
    [self loadScrollViewWithPage:firstView];
    
    // 두번째 페이지 생성
    UIView* secondView = [[UIView alloc]initWithFrame:pageRect];
    secondView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle2.frame = titleRect;
    [secondView addSubview:viewTitle2];
    
    _table2 = [[UITableView alloc]initWithFrame:tableRect];
    _table2.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table2.delegate = self;
    _table2.dataSource = self;
    _table2.tag = 2;
    _table2.contentMode = UIViewContentModeScaleAspectFit;
    [secondView addSubview:_table2];
    
    [self loadScrollViewWithPage:secondView];
    
    
    // 세번째 페이지 생성
    UIView* thirdView = [[UIView alloc]initWithFrame:pageRect];
    thirdView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle3.frame = titleRect;
    [thirdView addSubview:viewTitle3];
    
    _table3 = [[UITableView alloc]initWithFrame:tableRect];
    _table3.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table3.delegate = self;
    _table3.dataSource = self;
    _table3.tag = 3;
    _table3.contentMode = UIViewContentModeScaleAspectFit;
    [thirdView addSubview:_table3];
    
    [self loadScrollViewWithPage:thirdView];
    
    // 네번째 페이지 생성
    UIView* fourthView = [[UIView alloc]initWithFrame:pageRect];
    fourthView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle4.frame = titleRect;
    [fourthView addSubview:viewTitle4];
    
    _table4 = [[UITableView alloc]initWithFrame:tableRect];
    _table4.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table4.delegate = self;
    _table4.dataSource = self;
    _table4.tag = 4;
    _table4.contentMode = UIViewContentModeScaleAspectFit;
    [fourthView addSubview:_table4];
    
    [self loadScrollViewWithPage:fourthView];
    
    // 다섯번째 페이지 생성
    UIView* fifthView = [[UIView alloc]initWithFrame:pageRect];
    fifthView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle5.frame = titleRect;
    [fifthView addSubview:viewTitle5];
    
    _table5 = [[UITableView alloc]initWithFrame:tableRect];
    _table5.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table5.delegate = self;
    _table5.dataSource = self;
    _table5.tag = 5;
    _table5.contentMode = UIViewContentModeScaleAspectFit;
    [fifthView addSubview:_table5];
    
    [self loadScrollViewWithPage:fifthView];

    // 여섯번째 페이지 생성
    UIView* sixthView = [[UIView alloc]initWithFrame:pageRect];
    sixthView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle6.frame = titleRect;
    [sixthView addSubview:viewTitle6];
    
    _table6 = [[UITableView alloc]initWithFrame:tableRect];
    _table6.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table6.delegate = self;
    _table6.dataSource = self;
    _table6.tag = 6;
    _table6.contentMode = UIViewContentModeScaleAspectFit;
    [sixthView addSubview:_table6];
    
    [self loadScrollViewWithPage:sixthView];

    
    CGRect scrollViewRect = [_scrollView bounds];
    _scrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 6, 1);
    
    return;
}

// 스크롤뷰에 페이지를 로드함
- (void)loadScrollViewWithPage:(UIView *)page
{
	int pageCount = (int)[[_scrollView subviews] count];
	
	CGRect bounds = _scrollView.bounds;
	bounds.origin.x = bounds.size.width * pageCount;
	bounds.origin.y = 0;
	page.frame = bounds;
	[_scrollView addSubview:page];
}

- (void)Clear
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    txtLocBarcode.text = @"";
    txtDeviceId.text = @"";
    txtGoodsId.text = @"";
    txtUpperId.text = @"";
    txtDamageId.text = @"";
    txtMakerSN.text = @"";
    lblGoodsName.text = @"";
    lblCount.text = @"";
    [self onDone:@"훼손" sender:nil];
    selectedPickerData = @"선택하세요.";
    lblRequestReason.text = @"선택하세요.";
    lblRequestReason.textColor = [UIColor lightGrayColor];
    [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcodeName withString:@""];
    
    strDamageId = @"";
    strLocCode = @"";
    strDeviceId = @"";
    strGoodId = @"";
    
    instoreMarkingRequestReason = @"";
    selectedRow = -1;

    [txtLocBarcode becomeFirstResponder];
    dataList = [NSMutableArray array];
    [self reloadTables];
}

- (void)reloadTables
{
    [_table1 reloadData];
    [_table2 reloadData];
    [_table3 reloadData];
    [_table4 reloadData];
    [_table5 reloadData];
    [_table6 reloadData];
    
    lblCount.text = [NSString stringWithFormat:@"%d건", (int)[dataList count]];
}

- (void)resignFirstResponderForAllTxt
{
    if ([txtLocBarcode isFirstResponder])
        [txtLocBarcode resignFirstResponder];
    else if ([txtDeviceId isFirstResponder])
        [txtDeviceId resignFirstResponder];
    else if ([txtGoodsId isFirstResponder])
        [txtGoodsId resignFirstResponder];
    else if ([txtUpperId isFirstResponder])
        [txtUpperId resignFirstResponder];
    else if ([txtDamageId isFirstResponder])
        [txtDamageId resignFirstResponder];
    else if ([txtMakerSN isFirstResponder])
        [txtMakerSN resignFirstResponder];
}

- (void)getItemStatus
{
    NSString* oldMatnr = @"";
    NSString* status = @"";
    NSString* extGW = @"";
    for (NSDictionary* dic in dataList){
        NSString* matnr = [dic objectForKey:@"SUBMT"];

        if (![matnr isEqualToString:oldMatnr]){
            isGetGoods = NO;
            [self requestItemStatus:matnr];
            NSDictionary* itemStatusDic = [itemStatusList objectAtIndex:0];
//            NSLog(@"itemStatusDic [%@]", itemStatusDic);
            status = [itemStatusDic objectForKey:@"STATUS"];
            if ([status isEqualToString:@"STOP"]){
                status = @"사용중지";
            }else if ([status isEqualToString:@"USE"]){
                status = @"사용중";
            }else{
                status = @"알수없음";
            }
            extGW = [itemStatusDic objectForKey:@"ZZMATN"];
            oldMatnr = matnr;
        }
        [dic setValue:status forKey:@"status"];
        [dic setValue:extGW forKey:@"extGW"];
    }
    [self reloadTables];
}


- (void)getGoodsInfo:(NSString*)goodsId
{
    if (goodsId == nil || [goodsId isEqualToString:@""]){
        NSString* msg = @"물품코드 또는 물품명을 입력하세요.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    if (goodsId.length > 0 && goodsId.length < 6){
        NSString* msg = @"물품코드를 6자리 이상 입력하세요.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil];
        
        return;
    }
    
    isGetGoods = YES;
    [self requestItemStatus:goodsId];
}

#pragma mark - Http Request Method

- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestLocCode:locBarcode];
}


- (void)requestSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = IM_REQUEST_SEARCH;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString* locCode = @"";
    NSString* deviceId = @"";
    NSString* damageId = @"";
    NSString* upperId = @"";
    NSString* makerSN = @"";
    NSString* goodsId = @"";
    
    if (txtLocBarcode.text != nil)
        locCode = txtLocBarcode.text;
    if (txtDeviceId.text != nil)
        deviceId = txtDeviceId.text;
    if (txtDamageId.text != nil)
        damageId = txtDamageId.text;
    if (txtUpperId.text != nil)
        upperId = txtUpperId.text;
    if(txtMakerSN.text != nil)
        makerSN = txtMakerSN.text;
    if (txtGoodsId.text != nil)
        goodsId = txtGoodsId.text;
    
    [paramDic setObject:@"" forKey:@"I_ZKOSTL"];
    [paramDic setObject:locCode forKey:@"I_ZEQUIPLP"];
    [paramDic setObject:deviceId forKey:@"I_ZEQUIPGC"];
    [paramDic setObject:damageId forKey:@"I_FEQUNR"];
    [paramDic setObject:upperId forKey:@"I_HEQUNR"];
    [paramDic setObject:makerSN forKey:@"I_SERGE"];
    [paramDic setObject:goodsId forKey:@"I_SUBMT"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SEARCH_INSTOREMARKING withData:rootDic];
}

- (void)requestItemStatus:(NSString*)matnr
{
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


- (void)requestSend
{
    NSMutableArray* paramList = [NSMutableArray array];
    sendCount = 0;
    for(NSDictionary* dic in dataList){
        BOOL isSelect = [[dic objectForKey:@"IS_SELECTED"] boolValue];
        if (!isSelect)  continue;
        
        NSMutableDictionary* paramDic = [NSMutableDictionary dictionary];
        
        [paramDic setObject:@"1" forKey:@"PBLS_CNT"];
        [paramDic setObject:@"IMD" forKey:@"GNRT_REQ_TP_CD"];
        [paramDic setObject:@"INS" forKey:@"GNRT_TARG_CD"];
        
        if ([selectedPickerData isEqualToString:@"훼손"])
            [paramDic setObject:@"1" forKey:@"PBLS_WHY_CD"];
        else if ([selectedPickerData isEqualToString:@"오부착(교환)"])
            [paramDic setObject:@"3" forKey:@"PBLS_WHY_CD"];
        else if ([selectedPickerData isEqualToString:@"교품"])
            [paramDic setObject:@"4" forKey:@"PBLS_WHY_CD"];
        
        [paramDic setObject:[dic objectForKey:@"ZEQART1"] forKey:@"ZEQART1"];
        [paramDic setObject:[dic objectForKey:@"ZEQART2"] forKey:@"ZEQART2"];
        [paramDic setObject:[dic objectForKey:@"ZEQART3"] forKey:@"ZEQART3"];
        [paramDic setObject:[dic objectForKey:@"ZEQART4"] forKey:@"ZEQART4"];
        [paramDic setObject:[dic objectForKey:@"FEQUNR"] forKey:@"EQUNR"];
        [paramDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
 
        //위도,경도,delta 추가
        //NSDictionary* deltaDic = [Util udObjectForKey:USER_DELTA];
        // GPS 위치조회 하지 않는 방법으로 변경. 16.11.22
//        if ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
//            [ERPLocationManager getInstance].locationDic != nil){
//            NSDictionary* deltaDic = [ERPLocationManager getInstance].locationDic;
//
//            NSString* longitude = [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LONGTITUDE"] floatValue]];
//            NSString* latitude =  [NSString stringWithFormat:@"%.07f",[[deltaDic objectForKey:@"LATITUDE"] floatValue]];
//            
//            [paramDic setObject:longitude forKey:@"LONGTITUDE"];
//            [paramDic setObject:latitude forKey:@"LATITUDE"];
//
//            NSString* locFucllName = [[locCodeList objectAtIndex:0] objectForKey:@"locationFullName"];
//            locFucllName = [WorkUtil getFullNameOfLoc:locFucllName];
//            
//            double distance = [[ERPLocationManager getInstance] getDiffDistanceWithAddress:locFucllName];
//            [paramDic setObject:[NSString stringWithFormat:@"%.07f", distance] forKey:@"DIFF_TITUDE"];
//        }else{
//            [paramDic setObject:@"" forKey:@"LONGTITUDE"];
//            [paramDic setObject:@"" forKey:@"LATITUDE"];
//            [paramDic setObject:@"" forKey:@"DIFF_TITUDE"];
//        }
        
        [paramDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
        [paramDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
        [paramDic setObject:[dic objectForKey:@"SERGE"] forKey:@"SERGE"];
        [paramDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];
        
        [paramList addObject:paramDic];
        
        sendCount++;
    }
    
    if (sendCount == 0){
        NSString* msg = @"전송할 설비바코드가 존재하지 않습니다.";
        [self showMessage:msg tag:-1 title1:@"닫기" title2:nil isError:YES];
        
        return;
    }
    
    
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    

    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];

    NSDictionary* bodyDic = [Util singleListMessageBody:paramList];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SUBMIT_INSTOREMARKING withData:rootDic];

}


#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];

        [self processFailRequest:pid Message:message];
        
        return;
    }else if (status == -1){ //세션종료
        [self processEndSession:pid];
        return;
    }
    
    if (pid != REQUEST_SEND && (resultList == nil || (int)[resultList count] <= 0))
    {
        NSLog(@"There are not exist result");
        return;
    }
    
    if (pid == REQUEST_LOC_COD){
        [self processLocList:resultList];
    }else if (pid == IM_REQUEST_SEARCH){
        [self processSearchResponse:resultList];
    }else if (pid == IM_REQUEST_ITEM_STATUS){
        [self processItemStatusResponse:resultList];
    }else if (pid == REQUEST_SEND){
        NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n\n1-정상 전송되었습니다.", sendCount];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:NO];
        
        [self Clear];
    }
}

- (void)processLocList:(NSArray*)locList
{
    if (locList.count){
        NSDictionary* dic = [locList objectAtIndex:0];
        [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcodeName withString:[dic objectForKey:@"locationShortName"]];
        
        strLocCode = [dic objectForKey:@"completeLocationCode"];
        
        NSString* deviceID = [dic objectForKey:@"deviceId"];
        
        if (txtLocBarcode.text.length == 9) {//장치바코드
            txtDeviceId.text = txtLocBarcode.text;
            txtLocBarcode.text = strLocCode;
        }
        else if (txtLocBarcode.text.length <= 10) {
            txtLocBarcode.text = strLocCode;
        }
        
        
        if (deviceID.length){
            txtDeviceId.text = deviceID;
            strDeviceId = txtDeviceId.text;
        }
    }
    else { //
        NSString* message = @"검색된 위치바코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

- (void)processSearchResponse:(NSArray*)resultList
{
    int count = 0;
    if (resultList.count){
        for(NSDictionary* dic in resultList){
            NSString* status = [dic objectForKey:@"ZPSTATU"];
            if ([status isEqualToString:@"0240"] || // 불용확정
                [status isEqualToString:@"0260"] || // 사용중지
                [status isEqualToString:@"0021"])   // 납품취소
                continue;
            
            NSString* isExist = [dic objectForKey:@"isExist"];
            NSMutableDictionary* dataDic = [NSMutableDictionary dictionary];
            
            [dataDic setObject:[dic objectForKey:@"FEQUNR"] forKey:@"FEQUNR"];
            [dataDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
            [dataDic setObject:[WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]] forKey:@"ZPSTATU_NAME"];
            [dataDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
            [dataDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
            [dataDic setObject:[WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]] forKey:@"ZPGUBUN_NAME"];
            [dataDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
            [dataDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
            [dataDic setObject:[WorkUtil getPartTypeFullName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]] forKey:@"PARTTYPENAME"];
            [dataDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
            [dataDic setObject:[dic objectForKey:@"PLOCNAME"] forKey:@"PLOCNAME"];
            [dataDic setObject:[dic objectForKey:@"ZEQART1"] forKey:@"ZEQART1"];
            [dataDic setObject:[dic objectForKey:@"ZEQART2"] forKey:@"ZEQART2"];
            [dataDic setObject:[dic objectForKey:@"ZEQART3"] forKey:@"ZEQART3"];
            [dataDic setObject:[dic objectForKey:@"ZEQART4"] forKey:@"ZEQART4"];
            NSString* ZASANBUNRYU =
            [NSString stringWithFormat:@"%@/%@/%@/%@",
             [dic objectForKey:@"ZEQART1"], [dic objectForKey:@"ZEQART2"],
             [dic objectForKey:@"ZEQART3"], [dic objectForKey:@"ZEQART4"]] ;
            
            [dataDic setObject:[dic objectForKey:@"ZATEXT01"] forKey:@"ZATEXT01"];
            [dataDic setObject:[dic objectForKey:@"ZATEXT02"] forKey:@"ZATEXT02"];
            [dataDic setObject:[dic objectForKey:@"ZATEXT03"] forKey:@"ZATEXT03"];
            [dataDic setObject:[dic objectForKey:@"ZATEXT04"] forKey:@"ZATEXT04"];
            
            [dataDic setObject:ZASANBUNRYU forKey:@"ZASANBUNRYU"];
            NSString* ZASANBUNRYU2 =
            [NSString stringWithFormat:@"%@/%@/%@/%@",
             [dic objectForKey:@"ZATEXT01"], [dic objectForKey:@"ZATEXT02"],
             [dic objectForKey:@"ZATEXT03"], [dic objectForKey:@"ZATEXT04"]];
            [dataDic setObject:ZASANBUNRYU2 forKey:@"ZASANBUNRYU2"];
            [dataDic setObject:[dic objectForKey:@"NAME1"] forKey:@"NAME1"];
            [dataDic setObject:[dic objectForKey:@"HERST"] forKey:@"HERST"];
            [dataDic setObject:[dic objectForKey:@"SERGE"] forKey:@"SERGE"];
            [dataDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
            [dataDic setObject:isExist forKey:@"ISEXIST"];
            [dataDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];
            [dataDic setObject:@"" forKey:@"status"];
            [dataDic setObject:@"" forKey:@"extGW"];
            [dataDic setObject:[NSNumber numberWithBool:NO] forKey:@"IS_SELECTED"];
            
            [dataList addObject:dataDic];
            count++;
            
            lblCount.text = [NSString stringWithFormat:@"%d건", count];
        }
        if((int)[resultList count] == 0 || count == 0){
            lblCount.text = @"0건";
            NSString* message = @"조회된 설비바코드가 없습니다.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            return;
        }
        
        lblCount.text = [NSString stringWithFormat:@"%d건", (int)[resultList count]];
        
        [self getItemStatus];
    }
}

- (void)processItemStatusResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* resultDic = [resultList objectAtIndex:0];
        
        if (!isGetGoods){
            itemStatusList = [NSMutableArray array];
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            
            NSString* status = @"";
            if(![[resultDic objectForKey:@"STATUS"] isKindOfClass:[NSNull class]])
                status = [resultDic objectForKey:@"STATUS"];
            NSString* zzmatn = @"";
            if(![[resultDic objectForKey:@"ZZMATN"] isKindOfClass:[NSNull class]])
                zzmatn = [resultDic objectForKey:@"ZZMATN"];
            NSString* maktx = @"";
            if(![[resultDic objectForKey:@"MAKTX"] isKindOfClass:[NSNull class]])
                maktx = [resultDic objectForKey:@"MAKTX"];
            
            [dic setObject:status forKey:@"STATUS"];
            [dic setObject:zzmatn forKey:@"ZZMATN"];
            [dic setObject:maktx forKey:@"MAKTX"];
            
            [itemStatusList addObject:dic];
        }else {
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
            else
                lblGoodsName.text = [dic objectForKey:@"MAKTX"];
            
            [txtGoodsId resignFirstResponder];
        }
    }else if (isGetGoods){
        lblGoodsName.text = @"";
        [self showMessage:@"물품정보가 존재하지 않습니다." tag:-1 title1:@"닫기" title2:nil isError:YES];
        [txtGoodsId resignFirstResponder];
    }

}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if ([message length]){
        if (pid == IM_REQUEST_SEARCH){
            if ([message isEqualToString:@"데이터가 존재하지 않습니다."]){
                message = @"조회된 설비바코드가 없습니다.";
            }
        }else
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

- (void) processEndSession:(requestOfKind)pid
{
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
}

// matsua: 주소정보조회 팝업 추가
- (IBAction) locInfoBtnAction:(id)sender{
    
    if(txtLocBarcode.text.length < 1){
        return;
    }
    
    [self.view endEditing:YES];
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    AddInfoViewController *modalView = [[AddInfoViewController alloc] init];
    modalView.delegate = self;
    [modalView openModal:txtLocBarcode.text];
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
    
    modalView.locCd = txtLocBarcode.text;
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

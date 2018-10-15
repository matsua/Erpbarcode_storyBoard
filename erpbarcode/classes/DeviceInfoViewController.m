//
//  DeviceInfoViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "LocListViewController.h"
#import "CommonCell.h"
#import "FccInfoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"

@interface DeviceInfoViewController ()
//@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UITextField* txtDeviceCode;
@property(nonatomic,strong) IBOutlet UITextField* txtSubDeviceCode;
@property(nonatomic,strong) IBOutlet UITextField* txtLocCode;
@property(nonatomic,strong) IBOutlet CLTickerView* locTickerView;
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) IBOutlet UIView* locView;
@property(nonatomic,strong) IBOutlet UIView* orgView;
@property(nonatomic,strong) IBOutlet UIView* attributeView;
@property(nonatomic,strong) IBOutlet UIView* subFccView;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnBarcodeInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnMainMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu1;

@property (strong, nonatomic) IBOutlet scrollTouch *scrollAsset;
@property (strong, nonatomic) IBOutlet UILabel *lblAsset;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocName;
@property (strong, nonatomic) IBOutlet UILabel *lblLocName;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollL4;
@property (strong, nonatomic) IBOutlet UILabel *lblL4;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollLocBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblLocBarcode;
@property (strong, nonatomic) IBOutlet scrollTouch *scrollGoodsId;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsId;

@property(nonatomic,strong) NSString* strDeviceID;
@property(nonatomic,strong) NSString* strLocBarCode;
@property(nonatomic,strong) NSString* strSubDeviceID;
@property(nonatomic,assign) NSInteger nSelectedBtn;
@property(nonatomic,assign) NSInteger nPrevBtn;
@property(nonatomic,assign) BOOL isWireless;
@property(nonatomic,strong) NSMutableArray* originalSAPList;
@property(nonatomic,strong) NSMutableArray* fccSAPList;
@property(nonatomic,strong) NSMutableArray* locResultList;
@property(nonatomic,strong) NSDictionary* receivedLocDic;
@property(nonatomic,assign) NSInteger nSelectedRow;
@property(nonatomic,strong) UILabel* lblCount;

@property(strong, nonatomic) UITapGestureRecognizer* tapGesture;
@property(strong, nonatomic) UILongPressGestureRecognizer* longPressGesture;

@end

@implementation DeviceInfoViewController
@synthesize txtDeviceCode;
@synthesize txtSubDeviceCode;
@synthesize txtLocCode;
@synthesize locTickerView;
@synthesize indicatorView;
@synthesize strLocBarCode;
@synthesize strDeviceID;
@synthesize strSubDeviceID;
@synthesize locView;
@synthesize orgView;
@synthesize attributeView;
@synthesize nSelectedBtn;
@synthesize nPrevBtn;
@synthesize subFccView;
@synthesize isWireless;
@synthesize receivedLocDic;
@synthesize originalSAPList;
@synthesize fccSAPList;
@synthesize locResultList;
@synthesize _tableView;
@synthesize nSelectedRow;
@synthesize lblCount;

@synthesize btnBarcodeInfo;
@synthesize btnMainMenu;
@synthesize btnMenu1;

@synthesize scrollAsset;
@synthesize lblAsset;
@synthesize scrollLocName;
@synthesize lblLocName;
@synthesize scrollL4;
@synthesize lblL4;
@synthesize scrollLocBarcode;
@synthesize lblLocBarcode;
@synthesize scrollGoodsId;
@synthesize lblGoodsId;

@synthesize tapGesture;
@synthesize longPressGesture;

#pragma mark - ViewLife Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kdcBarcodeDataArrived:) name:kdcBarcodeDataArrivedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kdcBarcodeDataArrivedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"장치바코드정보%@", [Util getTitleWithServerNVersion]];

    self.navigationController.navigationBarHidden = NO;
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    [self makeDummyInputViewForTextField];
    
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    nSelectedBtn = 10;
    btnMenu1.selected = YES;
    btnBarcodeInfo.selected = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locDataReceived:) name:@"DeviceLocSelectedNotification" object:nil];
    
    //long press gesture add
    longPressGesture = [[UILongPressGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(handleLongPress:)];
    longPressGesture.cancelsTouchesInView = NO;
    longPressGesture.minimumPressDuration = 1.0f;//seconds
    longPressGesture.delegate = self;
    [self._tableView addGestureRecognizer:longPressGesture];
    
    //single tap gesture add
    tapGesture =[[UITapGestureRecognizer alloc]
                 initWithTarget:self
                 action:@selector(handleSingleTap:)];
    

    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self._tableView addGestureRecognizer:tapGesture];
    subFccView.frame = CGRectMake(subFccView.bounds.origin.x, subFccView.bounds.origin.y,subFccView.bounds.size.width ,PHONE_SCREEN_HEIGHT - 75);

    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(50, _tableView.frame.origin.y + _tableView.frame.size.height + 5, 250, 20)];

    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor blueColor];
    lblCount.textAlignment = NSTextAlignmentCenter;
    lblCount.font = [UIFont systemFontOfSize:12];
    //lblContent.text = @"test";
    [subFccView addSubview:lblCount];
    
    [txtDeviceCode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Notification Event
- (void) locDataReceived:(NSNotification *)notification
{
    receivedLocDic = [notification object];
    [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcode withString:[receivedLocDic objectForKey:@"ZEQUIPLP_TXT"]];
    if (receivedLocDic.count){
        
        if (![strLocBarCode isEqualToString:[receivedLocDic objectForKey:@"ZEQUIPLP"]]){
            //기존데이터가 있는경우 배열 초기화
            if (strLocBarCode.length){
                originalSAPList = [NSMutableArray array];
                fccSAPList = [NSMutableArray array];
            }
            
            strLocBarCode =  [receivedLocDic objectForKey:@"ZEQUIPLP"];
            txtLocCode.text = strLocBarCode;
            
            [self requestLocCode:strLocBarCode];
        }
    }
    
}

#pragma mark - handle gesture

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (fccSAPList.count){
        CGPoint p = [gestureRecognizer locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:p];
        if (indexPath){
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - handle gesture
-(void)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (fccSAPList.count){
        if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
            CGPoint p = [gestureRecognizer locationInView:_tableView];
            NSIndexPath* indexPath = [_tableView indexPathForRowAtPoint:p];
            if(indexPath){

                NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
                if(dic.count){
                    if ([[dic objectForKey:@"PART_NAME"] isEqualToString:@"L"] ||
                        [[dic objectForKey:@"PART_NAME"] isEqualToString:@"D"])
                        return;
                    
                    FccInfoViewController* vc = [[FccInfoViewController alloc] init];
                    vc.paramBarcode = [dic objectForKey:@"EQUNR"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

#pragma mark - UserAction Method
- (void) touchTreeBtn:(id)sender
{
    int nTag = (int)[sender tag];
    nSelectedRow = nTag;
    NSMutableDictionary* selItemDic = [fccSAPList objectAtIndex:nTag];
    NSMutableDictionary* itemInFullListDic = [WorkUtil getItemFromFccList:[selItemDic objectForKey:@"EQUNR"] fccList:originalSAPList];
    NSLog(@"selItemDic [%@]",selItemDic);
    
    NSInteger cellStatus = [[selItemDic objectForKey:@"exposeStatus"] integerValue];
    
    if (cellStatus == SUB_NO_CATEGORIES){ //sub카테고리가 없는경우
        
    }
    else{
        if (cellStatus == SUB_CATEGORIES_EXPOSED){ //delete (collapse)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_NO_EXPOSE] forKey:@"exposeStatus"];
            [self reloadTable];
        }
        else { //insert (expand)
            [itemInFullListDic setValue:[NSString stringWithFormat:@"%d", SUB_CATEGORIES_EXPOSED] forKey:@"exposeStatus"];
            [self reloadTable];
        }
    }
}

- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSearchBtn:(id)sender
{
    [self requestSAPInfo:@"" locCode:txtLocCode.text deviceID:strSubDeviceID];
}

- (IBAction)touchBarcodeInfoBtn:(id)sender
{
    btnMainMenu.selected = NO;
    btnBarcodeInfo.selected = YES;
    if (subFccView.superview)
        [subFccView removeFromSuperview];
}

-(IBAction)touchMenuBtn:(id)sender
{
    
    UIButton* btn = (UIButton*)sender;
    if (nSelectedBtn == btn.tag)
        return;
    
    nPrevBtn = nSelectedBtn;
    if (nSelectedBtn != btn.tag){
        nSelectedBtn = btn.tag;
        UIButton* prevBtn = (UIButton*)[self.view viewWithTag:nPrevBtn];
        prevBtn.selected = NO;
        btn.selected = YES;
        switch (btn.tag) {
            case 10://일반
                if (nPrevBtn == 20)
                    [locView removeFromSuperview];
                else if (nPrevBtn == 30)
                    [orgView removeFromSuperview];
                else
                    [attributeView removeFromSuperview];                
                break;
            case 20://위치
                if (nPrevBtn == 10){                    
                    
                }
                else if (nPrevBtn == 30)
                    [orgView removeFromSuperview];
                else
                    [attributeView removeFromSuperview];
                locView.frame = CGRectMake(0, 80, 320, locView.frame.size.height);
                [self.view addSubview:locView];
                break;
            case 30://조직
                if (nPrevBtn == 10){                    
                    
                }
                else if (nPrevBtn == 20)
                    [locView removeFromSuperview];
                else
                    [attributeView removeFromSuperview];
                orgView.frame = CGRectMake(0, 80, 320, orgView.frame.size.height);
                [self.view addSubview:orgView];
                break;
            case 40://네크워크 장비속성
                if (nPrevBtn == 10){
                }
                else if (nPrevBtn == 20)
                    [locView removeFromSuperview];
                else
                    [orgView removeFromSuperview];
                attributeView.frame = CGRectMake(0, 80, 320, attributeView.frame.size.height);
                [self.view addSubview:attributeView];                
                break;
        }
        
    }
    
}

-(IBAction)touchMainMenuBtn:(id)sender
{
    btnMainMenu.selected = YES;
    btnBarcodeInfo.selected = NO;
    
    //하위설비
    [self.view addSubview:subFccView];
    if (txtDeviceCode.text.length){
        txtSubDeviceCode.text = txtDeviceCode.text;
        strSubDeviceID = txtSubDeviceCode.text;
        [self requestLocCodeByDeviceID:strDeviceID];
    }
    [txtSubDeviceCode becomeFirstResponder];        
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    NSString* barcode = [textField.text uppercaseString];
    
    textField.text = barcode;
    return [self processShouldReturn:barcode tag:[textField tag]];
}

#pragma mark - UserDefine Method
- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //100 장치 바코드
//        [txtDeviceCode resignFirstResponder];
        strDeviceID = strSubDeviceID = txtSubDeviceCode.text = barcode;
//        NSLog(@"decrypt DeviceCode: [%@]",strDeviceID);
//        if (strDeviceID.length != 9){
//            NSString *message = @"처리할 수 없는 장치바코드입니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            return YES;
//        }
        
        NSString *message = [Util barcodeMatchVal:3 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDeviceID = txtDeviceCode.text = strSubDeviceID = txtSubDeviceCode.text = @"";
            [txtDeviceCode becomeFirstResponder];
            return YES;
        }
        
        [self requestDeviceCode:strDeviceID];
    }
    else if (tag == 200){ //200 하위설비의 장치 바코드
        strSubDeviceID = strDeviceID = txtDeviceCode.text =barcode;
//        NSLog(@"decrypt strSubDeviceID: [%@]",strSubDeviceID);
//        if (strSubDeviceID.length != 9){
//            NSString *message = @"처리할 수 없는 장치바코드입니다.";
//            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
//            return YES;
//        }
        
        NSString *message = [Util barcodeMatchVal:3 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
            strDeviceID = txtDeviceCode.text = strSubDeviceID = txtSubDeviceCode.text = @"";
            [txtSubDeviceCode becomeFirstResponder];
            return YES;
        }
        
        [self requestSubDeviceCode:strSubDeviceID];
    }
    else if (tag == 300){ //300 하위설비의 위치 바코드
        if ([barcode length]){
            //장치바코드 길이체크
            if (!txtDeviceCode.text.length && !txtSubDeviceCode.text.length){
                NSString* message = @"장치바코드를 스캔하세요.";
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];

                return NO;
            }
            
            //기존데이터가 있는경우 배열 초기화
            if (strLocBarCode.length){
                originalSAPList = [NSMutableArray array];
                fccSAPList = [NSMutableArray array];
                [_tableView reloadData];
                [self showCount];
            }
            
            strLocBarCode = barcode;
            
            NSString *message = [Util barcodeMatchVal:1 barcode:barcode];
            if(message.length > 0){
                [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
                strLocBarCode = txtLocCode.text = @"";
                [txtLocCode becomeFirstResponder];
                return YES;
            }
            
            NSLog(@"decrypt LocCode: [%@]",strLocBarCode);
            [self requestSAPInfo:@"" locCode:strLocBarCode deviceID:strSubDeviceID];
        }
        else {
            NSString* message = @"위치바코드를 스캔하세요.";
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
    }
    return YES;
}

- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){

        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtLocCode.inputView = dummyView;
        txtSubDeviceCode.inputView = dummyView;
    }
}

- (void) showCount
{
    int shelfCount = 0;
    int rackCount = 0;
    int unitCount = 0;
    int equipCount = 0;
    int totalCount = 0;
    NSString* formatString = nil;
    
    if (originalSAPList.count){
        for(NSDictionary* dic in originalSAPList)
        {
            NSString* partName = [dic objectForKey:@"PART_NAME"];
            if ([partName isEqualToString:@"R"])
                rackCount++;
            else if ([partName isEqualToString:@"S"])
                shelfCount++;
            else if ([partName isEqualToString:@"U"])
                unitCount++;
            else if ([partName isEqualToString:@"E"])
                equipCount++;
            
        }

    }
    totalCount =  rackCount + shelfCount + unitCount + equipCount;
    formatString = [NSString stringWithFormat:@"R(%d) S(%d) U(%d) E(%d) TOTAL:%d건",rackCount,shelfCount,unitCount,equipCount,totalCount];
    lblCount.text = formatString;

}

- (void) reloadTable
{
    fccSAPList = [NSMutableArray array];
    for(int index = 0; index < originalSAPList.count; ){
        NSDictionary* dic = [originalSAPList objectAtIndex:index];
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        SubCategoryInfo category = [[dic objectForKey:@"exposeStatus"] intValue];
        
        if (category == SUB_CATEGORIES_NO_EXPOSE){
            NSString* selancestor = [dic objectForKey:@"ANCESTOR"];
            NSMutableIndexSet * childIndexSet = [NSMutableIndexSet indexSet];
            
            
            if (!selancestor.length) //취상위 레벨일 경우 ancestor 존재하지 않는다.
                selancestor = barcode;
            [WorkUtil getChildIndexesOfCurrentIndex:index fccList:originalSAPList childSet:childIndexSet isContainSelf:NO];
            index += [childIndexSet count];
            
            NSLog(@"childIndexSet [%@]", childIndexSet);
        }
        index++;
        [fccSAPList addObject:dic];
    }
    
    [_tableView reloadData];
    [self showCount];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}


- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}

- (void)setDeviceInfo:(NSDictionary*)dic
{
    UITextField* tf = nil;
    //장치바코드
    tf = (UITextField*)[self.view viewWithTag:1000];
    tf.text = [dic objectForKey:@"deviceId"];
    
    //장치바코드이름
    tf = (UITextField*)[self.view viewWithTag:1001];
    tf.text = [dic objectForKey:@"deviceName"];
    
    //프로젝트번호
    tf = (UITextField*)[self.view viewWithTag:1002];
    tf.text = [dic objectForKey:@"projectNo"];
    
    //WBS번호
    tf = (UITextField*)[self.view viewWithTag:1003];
    tf.text = [dic objectForKey:@"wbsNo"];
    
    //운용시스템 구분자
    NSString* osToken = [dic objectForKey:@"operationSystemTokenName"];
    tf = (UITextField*)[self.view viewWithTag:1004];
    tf.text = osToken;
    
    //운용시스템 코드
    tf = (UITextField*)[self.view viewWithTag:1005];
    tf.text = [dic objectForKey:@"operationSystemCode"];
    
    //위치아이디 구분자
    tf = (UITextField*)[self.view viewWithTag:1006];
    tf.text = [dic objectForKey:@"locationIdTokenName"];
    
    //장치상태명
    tf = (UITextField*)[self.view viewWithTag:1007];
    tf.text = [dic objectForKey:@"deviceStatusName"];
    
    //장치상태 코드
    tf = (UITextField*)[self.view viewWithTag:1008];
    tf.text = [dic objectForKey:@"deviceStatusCode"];
    
    //물품코드
    tf = (UITextField*)[self.view viewWithTag:1009];
    tf.text = [dic objectForKey:@"itemCode"];
    
    //물품명
    [Util setScrollTouch:scrollGoodsId Label:lblGoodsId withString:[dic objectForKey:@"itemName"]];
    
    //자산분류코드
    tf = (UITextField*)[self.view viewWithTag:1011];
    tf.text = [dic objectForKey:@"assetClassificationCode"];
    
    //자산분류코드명(ticker)
    [Util setScrollTouch:scrollAsset Label:lblAsset withString:[dic objectForKey:@"assetClassificationName"]];
    
    //마이그레이션구분
    tf = (UITextField*)[self.view viewWithTag:1013];
    tf.text = [dic objectForKey:@"migrationTypeCode"];
    
    //마이그레이션구분명칭
    tf = (UITextField*)[self.view viewWithTag:1014];
    tf.text = [dic objectForKey:@"migrationTypeName"];
    
    //인수확정여부
    tf = (UITextField*)[self.view viewWithTag:1015];
    tf.text = [dic objectForKey:@"argumentDecisionName"];
    //
    
    //표준서비스코드
    tf = (UITextField*)[self.view viewWithTag:1017];
    tf.text = [dic objectForKey:@"standardServiceCode"];
    
    //표준서비스명
    tf = (UITextField*)[self.view viewWithTag:1018];
    tf.text = [dic objectForKey:@"standardServiceName"];
    
    //위치뷰
    //위치바코드
    tf = (UITextField*)[locView viewWithTag:1100];
    tf.text = [dic objectForKey:@"locationCode"];
    
    //위치바코드명(ticker)
    [Util setScrollTouch:scrollLocName Label:lblLocName withString:[dic objectForKey:@"locationName"]];
    
    //상세주소
    tf = (UITextField*)[locView viewWithTag:1102];
    tf.text = [dic objectForKey:@"detailAddress"];
    
    //조직뷰
    //운용조직명
    tf = (UITextField*)[orgView viewWithTag:1200];
    tf.text = [dic objectForKey:@"operatioinOrgName"];
    
    //운용조직코드
    tf = (UITextField*)[orgView viewWithTag:1201];
    tf.text = [dic objectForKey:@"operationOrgCode"];
    
    //소유조직명
    tf = (UITextField*)[orgView viewWithTag:1202];
    tf.text = [dic objectForKey:@"ownOrgName"];
    
    //소유조직코드
    tf = (UITextField*)[orgView viewWithTag:1203];
    tf.text = [dic objectForKey:@"ownOrgCode"];
    
    //장비속성뷰
    //기능명
    tf = (UITextField*)[attributeView viewWithTag:1300];
    tf.text = [dic objectForKey:@"level1Name"];
    
    //기능
    tf = (UITextField*)[attributeView viewWithTag:1301];
    tf.text = [dic objectForKey:@"level1"];
    
    //계위명
    tf = (UITextField*)[attributeView viewWithTag:1302];
    tf.text = [dic objectForKey:@"level2Name"];
    
    //계위
    tf = (UITextField*)[attributeView viewWithTag:1303];
    tf.text = [dic objectForKey:@"level2"];
    
    //용도명
    tf = (UITextField*)[attributeView viewWithTag:1304];
    tf.text = [dic objectForKey:@"level3Name"];
    
    //용도
    tf = (UITextField*)[attributeView viewWithTag:1305];
    tf.text = [dic objectForKey:@"level3"];
    
    //구간/노드명(Ticker)
    [Util setScrollTouch:scrollL4 Label:lblL4 withString:[dic objectForKey:@"level4Name"]];
    
    //구간/노드
    tf = (UITextField*)[attributeView viewWithTag:1307];
    tf.text = [dic objectForKey:@"level4"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

#pragma mark - Http Request Method
- (void)requestLocCode:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_COD;
    
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
    
    [requestMgr requestLocCode:locBarcode];
}

- (void)requestDeviceCode:(NSString*)deviceBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULTI_INFO_FULL;
    
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
    
    [requestMgr requestMultiInfoWithDeviceCode:deviceBarcode];
}

- (void)requestSubDeviceCode:(NSString*)deviceBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SUB_MULTI_INFO;
    
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
    
    [requestMgr requestMultiInfoWithDeviceCode:deviceBarcode];
}

- (void)requestLocCodeByDeviceID:(NSString*)deviceCode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_GETLOC_SPOTCHECK;
    
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
    
    [requestMgr requestGetLocSpotCheck:deviceCode];
}

- (void)requestSAPInfo:(NSString*)fccBarcode locCode:(NSString*)locCode deviceID:(NSString*)deviceID
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_COD;
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
    
    [requestMgr requestSAPInfo:fccBarcode locCode:locCode deviceID:deviceID orgCode:@"" isAsynch:YES];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    if (indicatorView){
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        indicatorView = nil;
        self.view.userInteractionEnabled = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }

//    if (resultList != nil)
//        NSLog(@"Result List [%@]", resultList);
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (pid == REQUEST_SAP_FCC_COD){
                if ([message hasPrefix:@"데이터가 존재하지 않습니다."])
                    message = @"하위 설비가 존재하지 않습니다.";
            }
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
        }
        
        return;
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
        
        return;
    }
    
    if (pid == REQUEST_MULTI_INFO_FULL){
        [self processMultiInfoResponse:resultList];
    }else if (pid == REQUEST_LOC_COD){
        [self processLocCodeResponse:resultList];
    }else if (pid == REQUEST_SUB_MULTI_INFO){
        [self processSubMultInfoResponse:resultList];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPInfoResponse:resultList];
    }else if (pid == REQUEST_GETLOC_SPOTCHECK){
        [self processGetLocSpotCheckResponse:resultList];
    }
}

- (void) processMultiInfoResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        [self setDeviceInfo:dic];
        
        NSString* osToken = [dic objectForKey:@"operationSystemToken"];
        if (
            [osToken isEqualToString:@"04"] ||
            [osToken isEqualToString:@"08"] ||
            [osToken isEqualToString:@"09"] ||
            [osToken isEqualToString:@"10"] ||
            [osToken isEqualToString:@"69"] ||
            [osToken isEqualToString:@"79"] ||
            [osToken isEqualToString:@"89"] ||
            [osToken isEqualToString:@"99"]
            )
            isWireless = YES; // 무선 장비아이디 스캔 구분
        else
            isWireless = NO;
        
    }
    else {
        NSString* message = @"조회된 데이터가 존재하지 않습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void) processLocCodeResponse:(NSArray*)resultList
{
    if ([resultList count]){
        locResultList = [NSMutableArray array];
        
        //recode 갯수 1개 정보
        for (NSDictionary* dic in resultList) {
            NSMutableDictionary* locDic = [NSMutableDictionary dictionary];
            //정보 display
            
            locTickerView.marqueeFont = [UIFont systemFontOfSize:locTickerView.frame.size.height * 0.7f];
            locTickerView.marqueeStr = [dic objectForKey:@"locationShortName"];
            [locTickerView start];
            
            strLocBarCode = [dic objectForKey:@"completeLocationCode"];
            //user dafault에 저장
            //[Util udSetObject:strLocBarCode forKey:COMPLETE_LOC_CODE];
            
            [locDic setObject:[dic objectForKey:@"completeLocationCode"] forKey:@"completeLocationCode"];
            [locDic setObject:[dic objectForKey:@"locationShortName"] forKey:@"locationShortName"];
            [locDic setObject:[dic objectForKey:@"locationFullName"] forKey:@"locationFullName"];
            [locDic setObject:[dic objectForKey:@"roomTypeCode"] forKey:@"roomTypeCode"];
            [locDic setObject:[dic objectForKey:@"roomTypeName"] forKey:@"roomTypeName"];
            [locDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
            [locDic setObject:[dic objectForKey:@"operationSystemCode"] forKey:@"operationSystemCode"];
            [locDic setObject:[dic objectForKey:@"zkostl"] forKey:@"zkostl"];
            [locDic setObject:[dic objectForKey:@"zktext"] forKey:@"zktext"];
            [locResultList addObject:locDic];
        }
        
        [self requestSAPInfo:@"" locCode:strLocBarCode deviceID:strSubDeviceID];
    }
}

- (void) processSubMultInfoResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        
        NSString* operationSystemToken = [dic objectForKey:@"operationSystemToken"];
        NSString* standardServiceCode = [dic objectForKey:@"standardServiceCode"];
        
        
        if (
            [operationSystemToken isEqualToString:@"04"] ||
            [operationSystemToken isEqualToString:@"08"] ||
            [operationSystemToken isEqualToString:@"09"] ||
            [operationSystemToken isEqualToString:@"10"] ||
            [operationSystemToken isEqualToString:@"69"] ||
            [operationSystemToken isEqualToString:@"79"] ||
            [operationSystemToken isEqualToString:@"89"] ||
            [operationSystemToken isEqualToString:@"99"]
            )
            isWireless = YES; // 무선 장비아이디 스캔 구분
        else
            isWireless = NO;
        
        if ( [operationSystemToken isEqualToString:@"02"] && ![standardServiceCode length]){
            
            NSString* message = [NSString stringWithFormat:@"장치아이디 %@는\n운용시스템 구분자가 'ITAM'이며 \n IT표준서비스코드가 '없음'이므로\n스캔이 불가합니다.\n전사기준정보관리시스템(MDM)에\n문의하세요",strSubDeviceID];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }else
            if (txtSubDeviceCode.text.length){
                strSubDeviceID = txtSubDeviceCode.text;
                [self requestLocCodeByDeviceID:strSubDeviceID];
            }
        
        [self setDeviceInfo:dic];
    }
}

- (void) processSAPInfoResponse:(NSArray*)resultList
{
    fccSAPList = [NSMutableArray array];
    if ([resultList count]){
        NSLog(@"record count [%d]",(int)[resultList count]);
        
        if (!originalSAPList.count){ //최초스캔
            originalSAPList = [NSMutableArray array];
            
            int i = 0;
            for (NSDictionary* dic in resultList)
            {
                NSMutableDictionary* sapDic = [NSMutableDictionary dictionary];
                
                [sapDic setObject:[dic objectForKey:@"DEVICEGB"] forKey:@"DEVICEGB"];
                [sapDic setObject:[dic objectForKey:@"DEVICEGC"] forKey:@"DEVICEGC"];
                [sapDic setObject:[dic objectForKey:@"EQKTX"] forKey:@"EQKTX"];
                [sapDic setObject:[dic objectForKey:@"EQUNR"] forKey:@"EQUNR"];//설비바코드
                [sapDic setObject:[dic objectForKey:@"HEQKTX"] forKey:@"HEQKTX"];
                [sapDic setObject:[dic objectForKey:@"HEQUNR"] forKey:@"HEQUNR"];//상위바코드
                [sapDic setObject:[dic objectForKey:@"LEVEL"] forKey:@"LEVEL"];
                [sapDic setObject:[dic objectForKey:@"MAKTX"] forKey:@"MAKTX"];
                [sapDic setObject:[dic objectForKey:@"SUBMT"] forKey:@"SUBMT"];
                [sapDic setObject:[dic objectForKey:@"ZANLN1"] forKey:@"ZANLN1"];
                [sapDic setObject:[dic objectForKey:@"ZDESC"] forKey:@"ZDESC"];
                [sapDic setObject:[dic objectForKey:@"ZEQUIPGC"] forKey:@"ZEQUIPGC"];
                [sapDic setObject:[dic objectForKey:@"ZEQUIPLP"] forKey:@"ZEQUIPLP"];
                [sapDic setObject:[dic objectForKey:@"ZKEQUI"] forKey:@"ZKEQUI"];
                [sapDic setObject:[dic objectForKey:@"ZKOSTL"] forKey:@"ZKOSTL"];
                [sapDic setObject:[dic objectForKey:@"ZKTEXT"] forKey:@"ZKTEXT"];
                [sapDic setObject:[dic objectForKey:@"ZPGUBUN"] forKey:@"ZPGUBUN"];
                [sapDic setObject:[dic objectForKey:@"ZPPART"] forKey:@"ZPPART"];
                [sapDic setObject:[dic objectForKey:@"ZPSTATU"] forKey:@"ZPSTATU"];
                
                NSString* partTypeName = [WorkUtil getPartTypeName:[dic objectForKey:@"ZPPART"] device:[dic objectForKey:@"ZPGUBUN"]];
                
                //새롭게 만들어준 키값
                
                if ([partTypeName length])
                    [sapDic setObject:partTypeName forKey:@"PART_NAME"];
                else
                    [sapDic setObject:@"" forKey:@"PART_NAME"];
                
                //                                    if (i == 0)
                if([strLocBarCode isEqualToString:[dic objectForKey:@"EQUNR"]])
                    [sapDic setObject:@"3" forKey:@"SCANTYPE"];
                else
                    [sapDic setObject:@"0" forKey:@"SCANTYPE"];
                
                //조직체크 추가
                NSString* orgCode = [dic objectForKey:@"ZKOSTL"];
                NSString* orgName = [dic objectForKey:@"ZKTEXT"];
                NSString* checkOrgValue = nil;
                
                
                checkOrgValue = [NSString stringWithFormat:@"N_%@_%@",orgCode,orgName];
                [sapDic setObject:checkOrgValue forKey:@"ORG_CHECK"];
                
                [WorkUtil setChild:sapDic fccList:originalSAPList];
                [originalSAPList addObject:sapDic];
                i++;
            }
        }
    }
    nSelectedRow = originalSAPList.count - 1;
    [self reloadTable];
    
    if (![txtLocCode isFirstResponder])
        [txtLocCode becomeFirstResponder];
}

- (void)processGetLocSpotCheckResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSMutableArray* locList = [NSMutableArray array];
        //첫번째 행이 데이터 없는게 존재해서 스킵처리
        for (NSDictionary* dic in resultList)
        {
            NSString* locCode = [dic objectForKey:@"ZEQUIPLP"];
            if (!locCode.length)
                continue;
            if (isWireless){ //무선일때 1개만 처리
                txtLocCode.text = locCode;
                
                [Util setScrollTouch:scrollLocBarcode Label:lblLocBarcode withString:[dic objectForKey:@"ZEQUIPLP_TXT"]];
                 return;
            }
            [locList addObject:dic];
        }
        
        LocListViewController* vc = [[LocListViewController alloc] init];
        vc.locList = locList;
        vc.sender = self;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else {
        NSString* message = @"조회된 위치코드가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil isError:YES];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fccSAPList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCell *cell = (CommonCell*)[tableView dequeueReusableCellWithIdentifier:@"CommonCell"];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
        for (id object in nib)
        {
            if ([object isMemberOfClass:[CommonCell class]])
            {
                cell = object;
                break;
            }
        }
    }
    
    NSDictionary* dic = [fccSAPList objectAtIndex:indexPath.row];
    
    NSString* scanType = nil;
    NSString* partTypeName = nil;
    NSString* formatString = nil;
    

    if ([fccSAPList count]){
        
        partTypeName = [dic objectForKey:@"PART_NAME"];
        NSString* barcode = [dic objectForKey:@"EQUNR"];
        NSString* status = [WorkUtil getFacilityStatusName:[dic objectForKey:@"ZPSTATU"]]; //설비상태코드(ZPSTATU)
        NSString* barcodeName = [dic objectForKey:@"MAKTX"];
        barcodeName = [barcodeName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
        NSString* deviceTypeName =  [WorkUtil getDeviceTypeName:[dic objectForKey:@"ZPGUBUN"]]; //디바이스코드(ZPGUBUN)
        NSString* deviceID = [dic objectForKey:@"ZEQUIPGC"];
        scanType = [dic objectForKey:@"SCANTYPE"];
        
        NSString* wbsNo = @""; //작업구분이 시설등록일때만 존재한다.
        NSString* parentBarcode = [dic objectForKey:@"HEQUNR"];
        NSString* checkOrgValue = [dic objectForKey:@"ORG_CHECK"];
        //팀내(입고)일때만 처리해준다.
        NSString* facilityProcessed = [dic objectForKey:@"ZKEQUI"]; //설비처리구분(B,N,공백)
        NSString* assetNo = [dic objectForKey:@"ZANLN1"]; //자산번호
        
        formatString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@:%@:%@:%@:%@:%@:%@",partTypeName,barcode,status,barcodeName,deviceTypeName,parentBarcode,scanType,deviceID,wbsNo,checkOrgValue,facilityProcessed,assetNo];
    }
    
    CGFloat textLength = [formatString sizeWithFont:cell.lblTreeData.font constrainedToSize:CGSizeMake(9999, COMMON_CELL_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping].width;
    cell.indentationLevel = [[dic objectForKey:@"LEVEL"] integerValue];
    [cell setIndentationWidth:15.0f];
    
    cell.scrollView.contentSize = CGSizeMake(textLength + 90, COMMON_CELL_HEIGHT);
    
    cell.lblTreeData.frame = CGRectMake(cell.lblTreeData.frame.origin.x, cell.lblTreeData.frame.origin.y, textLength, cell.lblTreeData.frame.size.height);
    cell.lblTreeData.text = formatString;
    
    cell.nScanType = [scanType integerValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (nSelectedRow == indexPath.row)
        cell.lblTreeData.textColor = [UIColor blueColor];
    else
        cell.lblTreeData.textColor = [UIColor blackColor];
    
    if ([scanType isEqualToString:@"1"])
        cell.lblBackground.backgroundColor = COLOR_SCAN1;
    cell.hasSubNode = YES;
    ///////// Tree View표현을 위한 코드
    if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_NO_CATEGORIES){
        cell.btnTree.hidden = YES;
        cell.hasSubNode = NO;
    }
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_NO_EXPOSE){
        cell.btnTree.hidden = NO;
        cell.btnTree.tag = indexPath.row;
        [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[dic objectForKey:@"exposeStatus"] integerValue] == SUB_CATEGORIES_EXPOSED){
        cell.btnTree.hidden = NO;
        cell.btnTree.tag = indexPath.row;
        [cell.btnTree setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        
        [cell.btnTree addTarget:self action:@selector(touchTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    ////////////

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMON_CELL_HEIGHT;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonCell* cell =(CommonCell*) [tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCell* cell = (CommonCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nSelectedRow inSection:0]];
    cell.lblTreeData.textColor = [UIColor blackColor];
    
    nSelectedRow = indexPath.row;
    
    cell = (CommonCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.lblTreeData.textColor = [UIColor blueColor];
}

@end

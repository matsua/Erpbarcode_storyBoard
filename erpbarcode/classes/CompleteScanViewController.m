//
//  CompleteScanViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 11. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "CompleteScanViewController.h"
#import "CompleteScanCell1.h"
#import "CompleteScanCell2.h"
#import "CompleteScanCell3.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"

@interface CompleteScanViewController ()

@end

@implementation CompleteScanViewController

@synthesize txtFacBarcode;
@synthesize _pageCtrl;
@synthesize _scrollView;
@synthesize lblCount;
@synthesize title1;
@synthesize title2;
@synthesize title3;

@synthesize _table1;
@synthesize _table2;
@synthesize _table3;

@synthesize dataList;

@synthesize JOB_GUBUN;
@synthesize strFacBarcode;
@synthesize lblPartType;
@synthesize isValidFac;
@synthesize injuryBarcode;
@synthesize resultFccDate;

@synthesize indicatorView;

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
    
    [txtFacBarcode becomeFirstResponder];
    
    [self createPages];
    
    [self clear];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kdcBarcodeDataArrivedNotification object:nil];
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
- (void) showMessage:(NSString*)message tag:(NSInteger)tag buttonTitle1:(NSString*)buttonTitle1 buttonTitle2:(NSString*)buttonTitle2
{
    [self showMessage:message tag:tag buttonTitle1:buttonTitle1 buttonTitle2:buttonTitle2 isError:NO];
}

- (void) showMessage:(NSString*)message tag:(NSInteger)tag buttonTitle1:(NSString*)buttonTitle1 buttonTitle2:(NSString*)buttonTitle2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:buttonTitle1 title2:buttonTitle2 isError:isError isCheckComplete:YES delegate:self];
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


- (void)makeDummyInputViewForTextField
{
    if([[Util udObjectForKey:INPUT_MODE] isEqualToString:@"1"]) return;
    
    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] ||
        ([[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"] &&
         ![[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue])
        ){
        UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT, 1, 1)];
        txtFacBarcode.inputView = dummyView;
    }
}

- (BOOL) processShouldReturn:(NSString*)barcode tag:(NSInteger)tag
{
    if (tag == 100){ //설비바코드
        strFacBarcode = barcode;
        
        NSString* message = [Util barcodeMatchVal:2 barcode:barcode];
        if(message.length > 0){
            [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
            txtFacBarcode.text = strFacBarcode = @"";
            return YES;
        }
        
//        if (strFacBarcode.length < 16 || strFacBarcode.length > 18)
//        {
//            NSString* message = @"처리할 수 없는 설비바코드입니다.";
//            [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
//            return YES;
//        }
        
        if ([self isExistInListOfBarcode:barcode] >= 0){
            NSString* message = [NSString stringWithFormat:@"중복 스캔입니다.\n\n%@", barcode];
            [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
            return NO;
        }
        
        [self requestCompleteScanSearch];
    }
    return YES;
}

#pragma  User Defined Action
- (IBAction)chagePage:(id)sender {
}

- (IBAction)touchDelete:(id)sender {
    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:dataList];
    if ((int)[dataList count] <= 0 || !indexset.count){
        NSString* message = @"선택된 항목이 없습니다.";
        [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil isError:YES];
        
        return;
    }
    [dataList removeObjectsAtIndexes:indexset];
    [self reloadTables];
}

- (IBAction)touchSend:(id)sender {
    NSIndexSet* indexset = [WorkUtil getSelectedGridIndexes:dataList];
    if ((int)[dataList count] <= 0 || !indexset.count){
        NSString* message = @"전송할 설비바코드가 존재하지 않습니다.";
        [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil isError:YES];
        
        return;
    }

    NSString* message = @"전송하시겠습니까?";
    [self showMessage:message tag:100 buttonTitle1:@"예" buttonTitle2:@"아니오"];
}

- (void) touchBackBtn:(id)sender
{
    [txtFacBarcode resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchedSelectBtn:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    if (dataList.count) {
        NSMutableDictionary* selectItem = [dataList objectAtIndex:btn.tag];
        
        btn.selected = !btn.selected;
        
        [selectItem setObject:[NSNumber numberWithBool:btn.selected] forKey:@"IS_SELECTED"];

        [self reloadTables];
    }
    
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


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        static NSString *CellIdentifier = @"CompleteScanCell1Id";
        CompleteScanCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CompleteScanCell1" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            NSLog(@"Dic [%@]", dic);
            cell.lblFacBarcode.text = [dic objectForKey:@"newBarcode"];
            cell.lblGoodsId.text = [dic objectForKey:@"itemCode"];
            cell.lblGoodsName.text = [dic objectForKey:@"itemName"];
            
            [cell.btnCheck addTarget:self action:@selector(touchedSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCheck.tag = indexPath.row;
            NSDictionary* cellDic = [dataList objectAtIndex:indexPath.row];
            BOOL isSelected = [[cellDic objectForKey:@"IS_SELECTED"] boolValue];
            cell.btnCheck.selected = isSelected;
            NSLog(@"Dic - [end]");
        }
        return cell;
    }else if (tableView.tag == 2){
        static NSString *CellIdentifier = @"CompleteScanCell2Id";
        CompleteScanCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CompleteScanCell2" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblItemClass.text = [WorkUtil getDeviceTypeName:[dic objectForKey:@"itemCategoryCode"]];
            cell.lblPartKind.text = [WorkUtil getPartTypeFullName:[dic objectForKey:@"partKindCode"] device:[dic objectForKey:@"itemCategoryCode"]];
            cell.lblOldFacBarcode.text = [dic objectForKey:@"injuryBarcode"];
            // 교체사유 코드 + 명 - request by 김희선 - 2014.01.03 : DR-2013-57961
            NSString *changeReason = [NSString stringWithFormat:@"%@-%@", [dic objectForKey:@"publicationWhyCode"], [dic objectForKey:@"publicationWhyName"] ];
            cell.lblChangeReason.text = changeReason;
        }
        
        return cell;
    }else if (tableView.tag == 3){
        static NSString *CellIdentifier = @"CompleteScanCell3Id";
        CompleteScanCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"CompleteScanCell3" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 제조사물자여부 B, M -> Y, N로 변경 - request by 김희선 - 2014.01.03 : DR-2013-57961
        if (dataList.count){
            NSDictionary* dic = [dataList objectAtIndex:indexPath.row];
            cell.lblLocBarcode.text = [dic objectForKey:@"locationCode"];
            cell.lblDeviceBarcode.text = [dic objectForKey:@"deviceId"];
            NSString* makerItemYn = [dic objectForKey:@"makerItemYn"];
            if ([makerItemYn isEqualToString: @"B"]) {
                makerItemYn = @"Y";
            } else {
                makerItemYn = @"N";
            }
            cell.lblMakersYN.text = makerItemYn;
        }
        
        return cell;
    }    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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
- (void) clear
{
    dataList = [NSMutableArray array];
    [self reloadTables];
    lblCount.text = @"0건";
    
    txtFacBarcode.text = @"";
    [txtFacBarcode becomeFirstResponder];
}

- (void)createPages
{
    if ([_scrollView.subviews count])
        for (UIView *subView in [_scrollView subviews])
            [subView removeFromSuperview];
    
    
	CGRect pageRect = [_scrollView bounds];
    CGRect tableRect = [_scrollView bounds];
    CGRect titleRect = CGRectMake(0, 0, 320, 40);
    tableRect.origin.y += titleRect.size.height;
    tableRect.size.height -= titleRect.size.height;
    
    
    // 첫번째 페이지 생성
    UIView* firstView = [[UIView alloc]initWithFrame:pageRect];
    firstView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    title1.frame = titleRect;
    [firstView addSubview:title1];
    
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
    
    title2.frame = titleRect;
    [secondView addSubview:title2];
    
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
    
    title3.frame = titleRect;
    [thirdView addSubview:title3];
    
    _table3 = [[UITableView alloc]initWithFrame:tableRect];
    _table3.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _table3.delegate = self;
    _table3.dataSource = self;
    _table3.tag = 3;
    _table3.contentMode = UIViewContentModeScaleAspectFit;
    [thirdView addSubview:_table3];
    
    [self loadScrollViewWithPage:thirdView];
    
    
    CGRect scrollViewRect = [_scrollView bounds];
    _scrollView.contentSize = CGSizeMake(scrollViewRect.size.width * 3, 1);
    
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

// dataList에 넘겨받은 barcode(설비바코드)가 있는지 체크하여 index return.  없으면 -1 리턴
- (NSInteger)isExistInListOfBarcode:(NSString*)barcode
{
    NSInteger index = -1;
    for(NSDictionary* dic in dataList){
        index++;
        if ([[dic objectForKey:@"newBarcode"] isEqualToString:barcode])
            return index;
    }
    
    return -1;
}

- (void)reloadTables
{
    [_table1 reloadData];
    [_table2 reloadData];
    [_table3 reloadData];
    
    lblCount.text = [NSString stringWithFormat:@"%d건", (int)[dataList count]];
}

#pragma mark - Http Request Method
- (void) requestCompleteScanSearch
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = IM_REQUEST_COMPLETE_SCAN_SEARCH;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:strFacBarcode forKey:@"NEW_BARCODE"];
    [paramDic setObject:@"" forKey:@"LOC_CD"];
    [paramDic setObject:@"" forKey:@"DEV_ID"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SEARCH_IM_COMPLETESCAN withData:rootDic];
}

- (void) requestSAPBarcodeInfo:(NSString*)barcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SAP_FCC_COD;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    [requestMgr requestSAPInfo:barcode locCode:@"" deviceID:@"" orgCode:@"" isAsynch:YES];
}

- (void)requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableArray* subParamList = [NSMutableArray array];
    for (NSDictionary* dic in dataList){
        NSMutableDictionary* subParamDic = [NSMutableDictionary dictionary];
        
        if (![[dic objectForKey:@"IS_SELECTED"] boolValue])
            continue;
        
        [subParamDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
        [subParamDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
        [subParamDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
        [subParamDic setObject:[dic objectForKey:@"itemCategoryCode"] forKey:@"itemCategoryCode"];
        [subParamDic setObject:[dic objectForKey:@"partKindCode"] forKey:@"partKindCode"];
        [subParamDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];
        [subParamDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
        [subParamDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];
        [subParamDic setObject:[dic objectForKey:@"itemLargeClassificationCode"] forKey:@"itemLargeClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemMiddleClassificationCode"] forKey:@"itemMiddleClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemSmallClassificationCode"] forKey:@"itemSmallClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"itemDetailClassificationCode"] forKey:@"itemDetailClassificationCode"];
        [subParamDic setObject:[dic objectForKey:@"deptCode"] forKey:@"deptCode"];
        [subParamDic setObject:[dic objectForKey:@"operationDeptCode"] forKey:@"operationDeptCode"];
        [subParamDic setObject:[dic objectForKey:@"makerCode"] forKey:@"makerCode"];
        [subParamDic setObject:[dic objectForKey:@"makerNational"] forKey:@"makerNational"];
        [subParamDic setObject:[dic objectForKey:@"makerSerial"] forKey:@"makerSerial"];
        NSString* generationRequestSeq = [NSString stringWithFormat:@"%@",
                                          [dic objectForKey:@"generationRequestSeq"]];
        [subParamDic setObject:generationRequestSeq forKey:@"generationRequestSeq"];
        [subParamDic setObject:[dic objectForKey:@"faciltyCategory"] forKey:@"facilityCategory"];
        [subParamDic setObject:[dic objectForKey:@"makerItemYn"] forKey:@"makerItemYn"];
        [subParamList addObject:subParamDic];
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:nil subParam:subParamList];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SUBMIT_IM_COMPLETSCAN withData:rootDic];
}


#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
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
    
    if (pid == IM_REQUEST_COMPLETE_SCAN_SEARCH){
        isValidFac = YES;
        [self processCompleteScanSearchResponse:resultList];
    }else if (pid == REQUEST_SAP_FCC_COD){
        [self processSAPBarcodeResponse:resultList];
    }else if (pid == REQUEST_SEND){
        if ([resultList count])
        {
            NSDictionary* dic = [resultList objectAtIndex:0];
            NSString* result = [dic objectForKey:@"E_RSLT"];
            NSString* result_msg = @"정상 전송되었습니다.";
            
            if ([result isEqualToString:@"S"]){
                message = [NSString stringWithFormat:@"#전송건수 : %d건\n\n%d-%@", (int)[dataList count],(int)status,result_msg];
                [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:@"" isError:NO];
            }
        }
        [self clear];
    }
}

- (void)processCompleteScanSearchResponse:(NSArray*)resultList
{
    resultFccDate = [NSArray array];
    if (![resultList count]){
        NSString* message = @"조회된 설비바코드가 없습니다";
        [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
        return;
    }
    
    resultFccDate = resultList;
    NSDictionary* dic = [resultList objectAtIndex:0];
    
    // 개조개량은 인스토어마킹완료 스캔 대신 개조개량 완료스캔으로 유도
    NSString* publicationWhyCode = [dic objectForKey:@"publicationWhyCode"];
    if ([publicationWhyCode isEqualToString:@"5"]){
        NSString* message = @"해당 바코드는 '개조개량완료'\n작업으로 처리 하시기바랍니다.";
        [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
        return;
    }
    
    injuryBarcode = [dic objectForKey:@"injuryBarcode"];
    if (![injuryBarcode isEqualToString:@""]){
        isValidFac = YES;
        [self requestSAPBarcodeInfo:injuryBarcode];
//        if (!isValidFac)
            return;
    }
    
    [self showTableData:resultList];
}

-(void) showTableData:(NSArray*)resultList
{
    if(!isValidFac){
        return;
    }
    
    NSDictionary* dic = [resultList objectAtIndex:0];
    NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
    lblPartType.text = [WorkUtil getPartTypeName:[dic objectForKey:@"partKindCode"] device:[dic objectForKey:@"itemCategoryCode"]];
    
    [newDic setObject:[NSNumber numberWithBool:YES] forKey:@"IS_SELECTED"];
    [newDic setObject:[dic objectForKey:@"locationCode"] forKey:@"locationCode"];
    [newDic setObject:[dic objectForKey:@"itemCode"] forKey:@"itemCode"];
    [newDic setObject:[dic objectForKey:@"itemName"] forKey:@"itemName"];
    [newDic setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
    [newDic setObject:[dic objectForKey:@"itemCategoryCode"] forKey:@"itemCategoryCode"];
    [newDic setObject:[dic objectForKey:@"partKindCode"] forKey:@"partKindCode"];
    [newDic setObject:[dic objectForKey:@"injuryBarcode"] forKey:@"injuryBarcode"];
    [newDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
    [newDic setObject:[dic objectForKey:@"publicationWhyCode"] forKey:@"publicationWhyCode"];
    [newDic setObject:[dic objectForKey:@"itemLargeClassificationCode"] forKey:@"itemLargeClassificationCode"];
    [newDic setObject:[dic objectForKey:@"itemMiddleClassificationCode"] forKey:@"itemMiddleClassificationCode"];
    [newDic setObject:[dic objectForKey:@"itemSmallClassificationCode"] forKey:@"itemSmallClassificationCode"];
    [newDic setObject:[dic objectForKey:@"itemDetailClassificationCode"] forKey:@"itemDetailClassificationCode"];
    [newDic setObject:[dic objectForKey:@"deptCode"] forKey:@"deptCode"];
    [newDic setObject:[dic objectForKey:@"operationDeptCode"] forKey:@"operationDeptCode"];
    [newDic setObject:[dic objectForKey:@"makerCode"] forKey:@"makerCode"];
    if ([dic objectForKey:@"makerNational"] == nil)
        [newDic setObject:@"" forKey:@"makerNational"];
    else
        [newDic setObject:[dic objectForKey:@"makerNational"] forKey:@"makerNational"];
    [newDic setObject:[dic objectForKey:@"makerSerial"] forKey:@"makerSerial"];
    NSString* generationRequestSeq = [NSString stringWithFormat:@"%@",
                                      [dic objectForKey:@"generationRequestSeq"]];
    [newDic setObject:generationRequestSeq forKey:@"generationRequestSeq"];
    [newDic setObject:[dic objectForKey:@"faciltyCategory"] forKey:@"faciltyCategory"];
    [newDic setObject:[dic objectForKey:@"makerItemYn"] forKey:@"makerItemYn"];
    [newDic setObject:[dic objectForKey:@"newBarcode"] forKey:@"newBarcode"];
    [newDic setObject:[dic objectForKey:@"publicationWhyName"] forKey:@"publicationWhyName"];
    
    [dataList addObject:newDic];
    [self reloadTables];
    
    lblCount.text = [NSString stringWithFormat:@"%d건", (int)[dataList count]];
}

- (void)processSAPBarcodeResponse:(NSArray*)resultList
{
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        
        NSString* partType = [dic objectForKey:@"ZPPART"];
        NSString* devType = [dic objectForKey:@"ZPGUBUN"];
        
        if (([partType isEqualToString:@"40"] && [devType isEqualToString:@"40"]) ||
            ([partType isEqualToString:@""] && [devType isEqualToString:@""])){
            NSString* msg = @"부품종류가 존재하지 않습니다.\n전사기준정보관리시스템(MDM)에\n문의하세요.";
            [self showMessage:msg tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil isError:YES];
            isValidFac = NO;
            return;
        }
        NSString* ZPSTATU = [dic objectForKey:@"ZPSTATU"];
        NSString* ZDESC = [dic objectForKey:@"ZDESC"];
        NSString* submt = [dic objectForKey:@"SUBMT"];
        
        NSString* errorMsg = [WorkUtil processIMRCheckFccStatus:ZPSTATU desc:ZDESC submt:submt injuryBarcode:injuryBarcode];
        if (errorMsg.length){
            isValidFac = NO;
            [self showMessage:errorMsg tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil isError:YES];
            [self showTableData:resultFccDate];
            return;
        }
        
        NSString* errorMessage = [WorkUtil processCheckFccStatus:ZPSTATU desc:ZDESC submt:submt];
        if (errorMessage.length){
            [self showMessage:errorMessage tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil isError:YES];
            isValidFac = YES;
            [self showTableData:resultFccDate];
            return;
        }
        
        [Util udSetBool:YES forKey:IS_DATA_MODIFIED];
        if ([ZPSTATU isEqualToString:@"0130"] ||
            [ZPSTATU isEqualToString:@"0160"]){
            NSString* message = [NSString stringWithFormat:@"설비상태가 '%@'인 설비는\n'%@' 작업을\n하실 수 없습니다.\n'수리완료' 작업으로 처리하시기\n바랍니다.", ZDESC, JOB_GUBUN];
            [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:nil];
            isValidFac = NO;
            [self showTableData:resultFccDate];
            return;
        }
    }
    
    [self showTableData:resultFccDate];
    isValidFac = YES;
}

- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showMessage:message tag:-1 buttonTitle1:@"닫기" buttonTitle2:@"" isError:YES];
    }
}

- (void) processEndSession:(requestOfKind)pid
{
    [self showMessage:@"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)" tag:2000 buttonTitle1:@"예" buttonTitle2:@"아니오" isError:YES];
}



@end

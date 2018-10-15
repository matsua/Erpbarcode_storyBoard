//
//  ArgumentConfirmViewController.m
//  erpbarcode
//
//  Created by 박수임 on 13. 10. 28..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "ArgumentConfirmViewController.h"
#import "ArgumentConfirmCell1.h"
#import "ArgumentConfirmCell2.h"
#import "ArgumentConfirmCell3.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ERPAlert.h"


@interface ArgumentConfirmViewController ()

@end

@implementation ArgumentConfirmViewController

@synthesize indicatorView;
@synthesize viewTitle1;
@synthesize viewTitle2;
@synthesize viewTitle3;
@synthesize pageCtrl;
@synthesize _scrollView;
@synthesize viewButtons;

@synthesize _tblFirst;
@synthesize _tblSecond;
@synthesize _tblThird;
@synthesize _tblFourth;

@synthesize dataList;
@synthesize infoList;
@synthesize listOftakeOverList;
@synthesize takeOverList;
@synthesize subFacList;


@synthesize selectedRow;
@synthesize JOB_GUBUN;
@synthesize POSID;
@synthesize loccd;

@synthesize delegate;

static BOOL isExistData = YES;

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
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
    
    if([JOB_GUBUN isEqualToString:@"인수"])
        self.title = @"인수확정 > 장치바코드 속성";
    else
        self.title = @"등록확정 > 정치바코드 속성";

    [self createPages];
    [self getList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePage:(id)sender {
    int page = (int)pageCtrl.currentPage;
	
	// 지정된 페이지로 스크롤 뷰의 내용을 스크롤한다.
	CGRect frame = _scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma  user define action
- (void) touchBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchReg:(id)sender {
    if (dataList.count <= 0){
        NSString* message = @"전송할 데이터가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        return;
    }
    
    NSString *hostYn = @"Y";
    NSString *usgYn = @"Y";
    
    for (NSDictionary* dic in dataList){
        hostYn = [dic objectForKey:@"HOST_YN"];
        usgYn = [dic objectForKey:@"USG_YN"];
    }
    
    if([hostYn isEqualToString:@"N"]){
        NSString *message_val = @"서버 호스트매핑 완료 후 실장 등록 진행하시기 바랍니다.\n자세한사항은 http://itam.kt.com 초기화면 하단 공지사항\n‘전사 서버 IT자산관리 정책’을 참고하세요.\n문의처: itam@kt.com";
        [[ERPAlert getInstance] showAlertMessage:message_val tag:-1 title1:@"닫기" title2:nil isError:NO isCheckComplete:YES delegate:self];
    }
    
    if([usgYn isEqualToString:@"N"]){
        NSString *message_val = @"ITAM시스템(itam.kt.com)에 성능정보가 수집이 되고 있지 않습니다.\nITAM 로그인 후 > 하단 성능정보 수집\n매뉴얼을 참고하시어 현행화 부탁 드립니다.\n문의사항 : itam@kt.com";
        [[ERPAlert getInstance] showAlertMessage:message_val tag:-1 title1:@"닫기" title2:nil isError:NO isCheckComplete:YES delegate:self];
    }
    
    NSString* message = @"전송하시겠습니까?";
    [self showMessage:message tag:100 title1:@"예" title2:@"아니오"];
}

- (IBAction)touchCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [delegate EndArgumentConfirmIsSend:NO];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)  {    // ERP에 저장된 인계스캔 Data 전체가삭제 됩니다. 정말 삭제 하시겠습니까?
        if (buttonIndex == 0){
            [self requestSend];
            [self.navigationController popViewControllerAnimated:YES];
            [delegate EndArgumentConfirmIsSend:YES];
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
    [Util udSetBool:YES forKey:IS_ALERT_COMPLETE];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1){
        static NSString *CellIdentifier = @"ArgumentConfirmCell1Id";
        ArgumentConfirmCell1 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"ArgumentConfirmCell1" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataList.count){
            NSDictionary* dic = dataList[indexPath.row];
            
            NSString* deviceId = [dic objectForKey:@"deviceId"];
            NSString* level1Name = [dic objectForKey:@"level1Name"];
            NSString* level2Name = [dic objectForKey:@"level2Name"];
            
            
            cell.lblDeviceId.text = deviceId;
            cell.lblL1Name.text = level1Name;
            cell.lblL2Name.text = level2Name;
        }

        return cell;
    }else if (tableView.tag == 2){
        static NSString *CellIdentifier = @"ArgumentConfirmCell2Id";
        ArgumentConfirmCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"ArgumentConfirmCell2" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (dataList.count){
            NSDictionary* dic = dataList[indexPath.row];
            
            NSString* level3Name = [dic objectForKey:@"level3Name"];
            NSString* level4Name = [dic objectForKey:@"level4Name"];
            NSString* docno = [dic objectForKey:@"docno"];
            
            cell.lblL3Name.text = level3Name;
            cell.lblL4Name.text = level4Name;
            cell.lblDocNo.text = docno;
        }
        

        return cell;
        
    }else if (tableView.tag == 3){
        static NSString *CellIdentifier = @"ArgumentConfirmCell3Id";
        ArgumentConfirmCell3 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"ArgumentConfirmCell3" owner:self options:nil];
            
            cell = arr[0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (dataList.count){
            NSDictionary* dic = dataList[indexPath.row];
            
            NSString* loccode = [dic objectForKey:@"loccode"];
            NSString* wbsNo = [dic objectForKey:@"posid"];
            
            cell.lblLocCode.text = loccode;
            cell.wbsNo.text = wbsNo;
        }

        
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma User Defined Method

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
    
    viewTitle1.frame = titleRect;
    [firstView addSubview:viewTitle1];
    
    _tblFirst = [[UITableView alloc]initWithFrame:tableRect];
    _tblFirst .autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tblFirst.delegate = self;
    _tblFirst.dataSource = self;
    _tblFirst.tag = 1;
    _tblFirst.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:_tblFirst];
    
    [self loadScrollViewWithPage:firstView];
    
    // 두번째 페이지 생성
    UIView* secondView = [[UIView alloc]initWithFrame:pageRect];
    secondView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle2.frame = titleRect;
    [secondView addSubview:viewTitle2];
    
    _tblSecond = [[UITableView alloc]initWithFrame:tableRect];
    _tblSecond.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tblSecond.delegate = self;
    _tblSecond.dataSource = self;
    _tblSecond.tag = 2;
    _tblSecond.contentMode = UIViewContentModeScaleAspectFit;
    [secondView addSubview:_tblSecond];
    
    [self loadScrollViewWithPage:secondView];
    
    
    // 세번째 페이지 생성
    UIView* thirdView = [[UIView alloc]initWithFrame:pageRect];
    thirdView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    viewTitle3.frame = titleRect;
    [thirdView addSubview:viewTitle3];
    
    _tblThird = [[UITableView alloc]initWithFrame:tableRect];
    _tblThird.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tblThird.delegate = self;
    _tblThird.dataSource = self;
    _tblThird.tag = 3;
    _tblThird.contentMode = UIViewContentModeScaleAspectFit;
    [thirdView addSubview:_tblThird];
    
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

- (void) getList
{
    takeOverList = [NSMutableArray array];
    for(NSDictionary* dic in infoList){
        NSString* deviceId = [dic objectForKey:@"deviceId"];
        
        [self requestList:deviceId];
    }
}

- (void)reloadTables
{
    [_tblFirst reloadData];
    [_tblSecond reloadData];
    [_tblThird reloadData];
    [_tblFourth reloadData];
}

- (void)makeList
{
    if (!isExistData)
        return;
    dataList = [NSMutableArray array];
    for (NSDictionary* dic in takeOverList){
        NSString* deviceId = [dic objectForKey:@"DEVICEID"];
        
        [self requestMultiInfoWithDeviceId:deviceId];
        
        NSString* locBarcode = [dic objectForKey:@"LOCCODE"];
        // 장치바코드 여러개 나올 수 있으므로 찍은 위치바코드와 맞지 않는 장치바코드는 continue
        if(![loccd isEqualToString:locBarcode])
            continue;
        
        NSString* docno = [dic objectForKey:@"DOCNO"];
        NSString* daori = [dic objectForKey:@"DAORI"];
        NSString* wbsNo = [dic objectForKey:@"POSID"];
        
        NSString* hostYn = [dic objectForKey:@"HOST_YN"];
        NSString* sugYn = [dic objectForKey:@"USG_YN"];
        
        if (docno.length == 0 || daori.length == 0)
            continue;
        
        NSDictionary* subFacDic = [subFacList objectAtIndex:0];
        NSString* takeOverDeviceId = [dic objectForKey:@"DEVICEID"];
        NSString* l1Name = [subFacDic objectForKey:@"level1Name"];
        NSString* l2Name = [subFacDic objectForKey:@"level2Name"];
        NSString* l3Name = [subFacDic objectForKey:@"level3Name"];
        NSString* l4Name = [subFacDic objectForKey:@"level4Name"];
        NSString* l1 = [subFacDic objectForKey:@"level1"];
        NSString* l2 = [subFacDic objectForKey:@"level2"];
        NSString* l3 = [subFacDic objectForKey:@"level3"];
        NSString* l4 = [subFacDic objectForKey:@"level4"];
        
        NSMutableDictionary* newDic = [NSMutableDictionary dictionary];
        [newDic setObject:takeOverDeviceId forKey:@"deviceId"];
        [newDic setObject:l1Name forKey:@"level1Name"];
        [newDic setObject:l2Name forKey:@"level2Name"];
        [newDic setObject:l3Name forKey:@"level3Name"];
        [newDic setObject:l4Name forKey:@"level4Name"];
        [newDic setObject:l1 forKey:@"level1"];
        [newDic setObject:l2 forKey:@"level2"];
        [newDic setObject:l3 forKey:@"level3"];
        [newDic setObject:l4 forKey:@"level4"];
        [newDic setObject:docno forKey:@"docno"];
        [newDic setObject:locBarcode forKey:@"loccode"];
        [newDic setObject:daori forKey:@"daori"];
        [newDic setObject:wbsNo forKey:@"posid"];
        [newDic setObject:hostYn forKey:@"HOST_YN"];
        [newDic setObject:sugYn forKey:@"USG_YN"];
        
        
        [dataList addObject:newDic];
    }
    
    [self reloadTables];
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



#pragma HTTP Request Method
- (void)requestSend
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_SEND;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    NSString* strDate = [NSDate TodayString];
    NSString* strTime = [NSDate TimeString];
    
    [paramDic setObject:@"0003" forKey:@"WORKID"];
    [paramDic setObject:@"0530" forKey:@"PRCID"];
    [paramDic setObject:@"0020" forKey:@"DOCTYPE"];
    [paramDic setObject:@"9200" forKey:@"WERKS"];
    [paramDic setObject:strDate forKey:@"DATE_ENTERED"];
    [paramDic setObject:strTime forKey:@"TIME_ENTERED"];

    NSMutableArray* subParamList = [NSMutableArray array];
    for(NSDictionary* dic in dataList){

        NSMutableDictionary* subParamDic = [NSMutableDictionary dictionary];
        
        [subParamDic setObject:[dic objectForKey:@"docno"] forKey:@"DOCNO"];
        [subParamDic setObject:@"1" forKey:@"DFLAG"];
        [subParamDic setObject:[dic objectForKey:@"posid"] forKey:@"POSID"];
        [subParamDic setObject:[dic objectForKey:@"loccode"] forKey:@"LOCCODE"];
        [subParamDic setObject:[dic objectForKey:@"deviceId"] forKey:@"DEVICEID"];
        [subParamDic setObject:[dic objectForKey:@"daori"] forKey:@"DAORI"];
        
        [subParamList addObject:subParamDic];
    }
    
    NSDictionary* bodyDic = [Util doubleMessageBody:paramDic subParam:subParamList];
    
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_SUBMIT_ARGUMENT_SCAN_CONFIRM withData:rootDic];
}

- (void)requestList:(NSString*)deviceId
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = TAKEOVER_REQUEST_LIST;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    if ([JOB_GUBUN isEqualToString:@"인수"])
        [paramDic setObject:POSID forKey:@"POSID"];
    [paramDic setObject:deviceId forKey:@"DEVICEID"];
    [paramDic setObject:@"02" forKey:@"WORKSTEP"];
    

    NSDictionary* bodyDic = [Util noneMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_SEARCH_ARGUMENT_SCAN_CONFIRM withData:bodyDic];
}

- (void)requestMultiInfoWithDeviceId:(NSString*)deviceId
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULTI_INFO_SYNCH;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    
    [paramDic setObject:deviceId forKey:@"SOURCE_CODE"];
    
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    
    [requestMgr sychronousConnectToServer:API_MULTI_INFO withData:bodyDic];
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
    
    if (pid == REQUEST_SEND){
        [self processSendResponse:resultList];
    }else if (pid == TAKEOVER_REQUEST_LIST){
        [self processListResponse:resultList];
    }else if (pid == REQUEST_MULTI_INFO_SYNCH){
        [self processDeviceIdResponse:[resultList objectAtIndex:0]];
    }
}

- (void)processSendResponse:(NSArray*)resultList
{
    // 성공시 처리
    if ([resultList count]){
        NSDictionary* dic = [resultList objectAtIndex:0];
        if ([[dic objectForKey:@"E_RSLT"] isEqualToString:@"S"]){
            NSString* message = [NSString stringWithFormat:@"# 전송건수 : %d건\n \n %@",(int)[dataList count],[dic objectForKey:@"E_MESG"]];
            [self showMessage:message tag:-1 title1:@"닫기" title2:@"" isError:NO];
        }
    }
}

- (void)processListResponse:(NSArray*)resultList
{
    if ([resultList count]){
        for(NSDictionary* dic in resultList){
            NSString* resultLocCode = [dic objectForKey:@"LOCCODE"];

            // 장치바코드 여러개 나올 수 있으므로 찍은 위치바코드와 맞지 않는 장치바코드는 continue
            if (![resultLocCode isEqualToString:loccd]) continue;
            
            [takeOverList addObject:dic];
        }
        [self makeList];
    }else{
        NSString* message = @"확정할 자료가 없습니다.";
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        isExistData = NO;
    }
}

- (void)processDeviceIdResponse:(NSDictionary*)devideInfoDic
{
    subFacList = [NSMutableArray array];
    if (devideInfoDic){
        NSString* operationSystemToken = [devideInfoDic objectForKey:@"operationSystemToken"];
        NSString* standardServiceCode = [devideInfoDic objectForKey:@"standardServiceCode"];
        
        NSString* deviceID = [devideInfoDic objectForKey:@"deviceId"];
        
        if ( [operationSystemToken isEqualToString:@"02"] && ![standardServiceCode length]){
            NSString* message = [NSString stringWithFormat:@"장치아이디 %@는\n운용시스템 구분자가 'ITAM'이며 \n IT표준서비스코드가 '없음'이므로\n스캔이 불가합니다.\n전사기준정보관리시스템(MDM)에\n문의하세요",deviceID];
            [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
        }
        
        [subFacList addObject:devideInfoDic];
    }
}


- (void) processFailRequest:(requestOfKind)pid Message:(NSString*)message
{
    if ([message length]){
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self showMessage:message tag:-1 title1:@"닫기" title2:nil];
    }
}

- (void) processEndSession:(requestOfKind)pid
{
    NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
    [self showMessage:message tag:2000 title1:@"예" title2:@"아니오"];
}


@end

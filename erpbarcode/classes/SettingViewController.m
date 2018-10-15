//
//  SettingViewController.m
//  erpbarcode
//
//  Created by Seoul Jung on 13. 9. 10..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define FETCH_COUNT         10000

#define softKeyboard        808
#define connectalert        800
#define autotrigger         801
#define autoerase           802
#define beepsound           803
#define beeponscan          804
#define beepvolhigh         805
#define vibrator            806
#define keypad              807

char        RereadDelayBackup;

@interface SettingViewController ()
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,assign) NSInteger nTotalCount;
@property(nonatomic,assign) NSInteger nRemainCount;
@property(nonatomic,assign) NSInteger nCurrentPageNo;
@property(nonatomic,strong) NSString* strEAI_MANTR_CDATE;
@property(nonatomic,strong) IBOutlet UILabel* lblProgressMsg;
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,assign) BOOL isDownloadAll;
@property(nonatomic,strong) NSString* matnrMessage;
@property(nonatomic,assign) BOOL isFinishedGetScanerSetting;

@end

@implementation SettingViewController
@synthesize indicatorView;
@synthesize nTotalCount;
@synthesize nRemainCount;
@synthesize nCurrentPageNo;
@synthesize strEAI_MANTR_CDATE;
@synthesize lblProgressMsg;
@synthesize isDownloadAll;
@synthesize _tableView;
@synthesize matnrMessage;
@synthesize isFinishedGetScanerSetting;

#pragma mark - ViewLife Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"환경설정";
    self.navigationController.navigationBarHidden = NO;
    
    //이전 버튼 구성
    [self.navigationItem addLeftBarButtonItem:@"navigation_back" target:self action:@selector(touchBackBtn:)];

    listOfItems = [[NSMutableArray alloc] init];
	
    NSArray *appinfo;
    appinfo = [NSArray arrayWithObjects:@"어플리케이션 업데이트",nil];
    NSDictionary *appinfoDict = [NSDictionary dictionaryWithObject:appinfo forKey:@"System Settings"];
    
    NSArray *material;
    material = [NSArray arrayWithObjects:@"물품마스터 업데이트",nil];
    NSDictionary *materialDict = [NSDictionary dictionaryWithObject:material forKey:@"System Settings"];
    
    [self getMATNRCount];
 
//    NSArray *sound;
//    sound = [NSArray arrayWithObjects:@"사운드 잠금 여부",nil];
//    NSDictionary *soundDict = [NSDictionary dictionaryWithObject:sound forKey:@"System Settings"];
//    
//    NSArray *bluetooth;
//    bluetooth = [NSArray arrayWithObjects:@"소프트키보드 활성 여부", @"미연결 경고",nil];
//    NSDictionary *bluetoothDict = [NSDictionary dictionaryWithObject:bluetooth forKey:@"System Settings"];
// 
//    NSArray *scan;
//    scan = [NSArray arrayWithObjects:@"자동 스캔",@"자동 스캔 간격",nil];
//    NSDictionary *scanDict = [NSDictionary dictionaryWithObject:scan forKey:@"System Settings"];
//    
//    NSArray *system;
//    system = [NSArray arrayWithObjects: @"자동 삭제", @"비프음", @"스캔 비프음",@"비프음 크게 하기",@"진동 모드",@"키패드 활성화",
//              nil];
//    
//    NSDictionary *systemDict = [NSDictionary dictionaryWithObject:system forKey:@"System Settings"];
//    
//    NSArray *memoryinfo;
//    memoryinfo = [NSArray arrayWithObjects: @"메모리 정보",@"메모리 리셋 하기",nil];
//    
//    NSDictionary *memoryinfoDict = [NSDictionary dictionaryWithObject:memoryinfo forKey:@"System Settings"];
 
    NSArray *kdcinfo;
    kdcinfo = [NSArray arrayWithObjects: @"펌웨어 버전",@"시리얼 번호",@"설비바코드",@"블루투스 주소",@"블루투스 FW 버전",@"배터리 잔량",nil];
    
    NSDictionary *kdcinfoDict = [NSDictionary dictionaryWithObject:kdcinfo forKey:@"System Settings"];
    
    NSArray *printerinfo;
    printerinfo = [NSArray arrayWithObjects: @"IP",@"PORT",nil];
    
    NSDictionary *printerinfoDict = [NSDictionary dictionaryWithObject:printerinfo forKey:@"System Settings"];
    
//    NSArray *timesync;
//    timesync = [NSArray arrayWithObjects: @"시간 동기화 하기",nil];
//    
//    NSDictionary *timesyncDict = [NSDictionary dictionaryWithObject:timesync forKey:@"System Settings"];
//  
//    NSArray *factoryreset;
//    factoryreset = [NSArray arrayWithObjects: @"공장 초기화 하기",nil];
//    
//    NSDictionary *factoryresetDict = [NSDictionary dictionaryWithObject:factoryreset forKey:@"System Settings"];
    
    [listOfItems addObject:appinfoDict];
    [listOfItems addObject:materialDict];
//    [listOfItems addObject:soundDict];
//    [listOfItems addObject:bluetoothDict];
//    [listOfItems addObject:scanDict];
//    [listOfItems addObject:systemDict];
//    [listOfItems addObject:memoryinfoDict];
    [listOfItems addObject:kdcinfoDict];
    [listOfItems addObject:printerinfoDict];
//    [listOfItems addObject:timesyncDict];
//    [listOfItems addObject:factoryresetDict];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestKDCSettingFinished) name:RCV_CMDFINISH_NOTI object:nil];

    AppDelegate *delegate = [[AppDelegate alloc] init];
    if(delegate.getKdcIsConnected) // 스캐너가 연결되었다면
        [self waitforGetKDCSettings];
    else
        [self initKDCSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    
    [self saveKDCSettings];
	[super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 11;
    return 4;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:@"System Settings"];
	
	return [array count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    // Set up the cell...
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"System Settings"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(section ==  0){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = cellValue;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ( [cellValue isEqualToString:@"어플리케이션 업데이트"]) {
            NSString *userVersionNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            NSString* detailInfo = [NSString stringWithFormat:@"현재 버젼(%@)이고, 최신 버전입니다.", userVersionNumber];
            cell.detailTextLabel.text = detailInfo;
        }
        
    }
    
    if(section ==  1){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = cellValue;
        if (nTotalCount){
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d건의 물품정보가 있으며, 업데이트 하셨습니다.", (int)nTotalCount];
        }else{
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = @"물품마스터 정보가 없습니다. 꼭 업데이트 하십시요.";
        }
        
        CGRect rect = CGRectMake(0, 0, 110, 20);
        progressView = [[UIProgressView alloc] initWithFrame:rect];
        cell.accessoryView = progressView;
        [progressView setProgressViewStyle:UIProgressViewStyleBar];
        progressView.progress = 100.0;
        progressView.hidden = YES;
        
        cell.detailTextLabel.numberOfLines = 2;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
//    if(section ==  2){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = cellValue;
//        cell.detailTextLabel.numberOfLines = 2;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if ([cellValue isEqualToString:@"사운드 잠금 여부"])
//        {
//            soundSwitch = [[UISwitch alloc] init];
//            soundSwitch.on = [[Util udObjectForKey:SOUND_ON_OFF] boolValue];
//            cell.accessoryView = soundSwitch;
//            cell.detailTextLabel.text = @"사운드와 효과음을 활성화하시면 작업에 도움이 됩니다.";
//        }
//    }
//    
//    if(section ==  3){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = cellValue;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if ([cellValue isEqualToString:@"미연결 경고"])
//        {
//            cell.detailTextLabel.numberOfLines = 3;
//            cell.accessoryView = connectAlertSwitch;
//            cell.detailTextLabel.text = @"블루투스 연결이 끊어진 상태에서 스캔시 경고를 하여 사용자에게 알려줍니다.";
//        }else if ([cellValue isEqualToString:@"소프트키보드 활성 여부"])
//        {
//            if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"]){
//                softKeyboardSwitch.on = NO;
//                softKeyboardSwitch.enabled = NO;
//                cell.detailTextLabel.numberOfLines = 3;
//                cell.detailTextLabel.text = @"운영 서버에서는 소프트 키보드를 활성화 할 수 없습니다.";
//            }else{
//                softKeyboardSwitch.on = [[Util udObjectForKey:SOFT_KEYBOARD_ON_OFF] boolValue];
//                softKeyboardSwitch.enabled = YES;
//                cell.detailTextLabel.numberOfLines = 2;
//                cell.detailTextLabel.text = @"바코드 스캐너 사용시에는 소프트 키보드를 비활성화 하세요.";
//            }
//            cell.accessoryView = softKeyboardSwitch;
//            
//        }
//    }
//
//    if(section == 4){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = cellValue;
//        cell.detailTextLabel.numberOfLines = 3;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if ([cellValue isEqualToString:@"자동 스캔"])
//        {
//            cell.accessoryView = autoTriggerSwitch;
//            cell.detailTextLabel.text = @"일정 간격마다 자동으로 스캔을 합니다. 스캔버튼을 3초 이상 누르고 있으면 자동 스캔이 종료됩니다.";
//        }
//        if ([cellValue isEqualToString:@"자동 스캔 간격"])
//        {
//            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        
////            if ( RereadDelay == 0 )  [[cell detailTextLabel] setText:@"연속 스캔"];
////            if ( RereadDelay == 1 )  [[cell detailTextLabel] setText:@"빠른 속도"];
////            if ( RereadDelay == 2 )  [[cell detailTextLabel] setText:@"중간 속도"];
////            if ( RereadDelay == 3 )  [[cell detailTextLabel] setText:@"느린 속도"];
////            if ( RereadDelay == 4 )  [[cell detailTextLabel] setText:@"아주 느린 속도"];
//            
//            rereadCell = cell;
//        }
//    }
//   
//    if(section == 5){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//
//        cell.textLabel.text = cellValue;
//        cell.detailTextLabel.numberOfLines = 3;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if ([cellValue isEqualToString:@"자동 삭제"])
//        {
//            cell.accessoryView = autoEraseSwitch;
//            cell.detailTextLabel.text = @"일정 간격마다 자동으로 스캔을 합니다. 스캔버튼을 3초 이상 누르고 있으면 자동스캔이 종료됩니다.";
//        }
//        
//        if ([cellValue isEqualToString:@"비프음"])
//        {
//            cell.accessoryView = beepSoundSwitch;
//            cell.detailTextLabel.text = @"전체 비프 사운드를 켜고 끌수 있습니다.";
//        }
//        
//        if ([cellValue isEqualToString:@"스캔 비프음"])
//        {
//            cell.accessoryView = beepOnScanSwitch;
//            cell.detailTextLabel.text = @"스캔 비프음을 켜고 끌수 있습니다.";
//        }
//        
//        if ([cellValue isEqualToString:@"비프음 크게 하기"])
//        {
//            cell.accessoryView = beepVolumeHighSwitch;
//            cell.detailTextLabel.text = @"스캐너의 비프음을 크게 합니다.";
//        }
//        
//        if ([cellValue isEqualToString:@"진동 모드"])
//        {
//            cell.accessoryView = vibratorSwitch;
//            cell.detailTextLabel.text = @"스캐너 진동 모드를 켜고 끌수 있습니다.";
//        }
//        
//        if ([cellValue isEqualToString:@"키패드 활성화"])
//        {
//            cell.accessoryView = keyPadSwitch;
//            cell.detailTextLabel.text = @"스캐너의 키패드 사용을 비활성화 합니다.";
//        }
//    }
//    
//    if(section == 6){
//        if ([cellValue isEqualToString:@"메모리 정보"])
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            
//            
//            cell.textLabel.text = cellValue;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            NSString *memory =[NSString stringWithFormat:@"%d 개 데이터 저장됨/%d KB 남음", [kdcReader GetStoredBarcodeNumber], [kdcReader GetMemoryLeft]];
//            cell.detailTextLabel.text = memory;
//        }
//        
//        if ([cellValue isEqualToString:@"메모리 리셋 하기"])
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            
//            cell.textLabel.text = cellValue;
//            cell.detailTextLabel.numberOfLines = 2;
//            cell.detailTextLabel.text = @"터치 하면 스캐너의 메모리를 리셋합니다.";
//            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        }
//
//    }
    
    if(section == 2)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

        cell.textLabel.text = cellValue;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        AppDelegate *delegate = [[AppDelegate alloc] init];
        
        if ( [cellValue isEqualToString:@"펌웨어 버전"]) {
            NSString *firmware;
            firmware =[NSString stringWithFormat:@"%s", delegate.getKdcFirmwareVersion];
            cell.detailTextLabel.text = firmware;
        }
        
        if ( [cellValue isEqualToString:@"시리얼 번호"]) {
            NSString *serial =[NSString stringWithFormat:@"%s", delegate.getKdcSerialNumber];
            cell.detailTextLabel.text = serial;
        }
        
        if ( [cellValue isEqualToString:@"설비바코드"]) {
            NSString *fccdata =[NSString stringWithFormat:@"%s", delegate.getKdcModelName];
            cell.detailTextLabel.text = fccdata;
        }
        
        if ( [cellValue isEqualToString:@"블루투스 주소"]) {
            NSString *macaddress =[NSString stringWithFormat:@"%s", delegate.getKdcBluetoothMacAddress];
            cell.detailTextLabel.text = macaddress;
        }
        
        if ( [cellValue isEqualToString:@"블루투스 FW 버전"]) {
            NSString *btversion =[NSString stringWithFormat:@"%s", delegate.getKdcBluetoothFirmwareVersion];
            cell.detailTextLabel.text = btversion;
        }
        
        if ( [cellValue isEqualToString:@"배터리 잔량"]) {
            NSString *battery =[NSString stringWithFormat:@"%d 퍼센트 남음", delegate.getKdcBatteryCapacity];
            cell.detailTextLabel.text = battery;
        }
    }
    
    // 프린터 설정
    if(section == 3){
        NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docRootPath = [docPath objectAtIndex:0];
        NSString *filePath = [docRootPath stringByAppendingFormat:@"/setupInfo.plist"];
        NSDictionary *stringDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        NSString *ip = [stringDic objectForKey:@"IP"];
        NSString *port = [stringDic objectForKey:@"PORT"];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.text = cellValue;
        
        if([cellValue isEqualToString:@"IP"]){
            UITextField *ipFd = [[UITextField alloc] initWithFrame:CGRectMake(170, 2, 150, 40)];
            ipFd.delegate = self;
            ipFd.tag = 0;
            [ipFd setText:ip];
            [cell addSubview:ipFd];
        }else{
            UITextField *portFd = [[UITextField alloc] initWithFrame:CGRectMake(170, 2, 150, 40)];
            portFd.delegate = self;
            portFd.tag = 1;
            [portFd setText:port];
            [cell addSubview:portFd];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
//    // 시간 동기화
//    if(section == 9){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = cellValue;
//        cell.detailTextLabel.numberOfLines = 2;
//        cell.detailTextLabel.text = @"터치 하면 미니 스캐너 시간설정을 핸드폰의 시간과 동기화 시킴니다.";
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
//    // 공장 초기화
//    if(section == 10){
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.textLabel.text = cellValue;
//        cell.detailTextLabel.numberOfLines = 2;
//        cell.detailTextLabel.text = @"터치 하면 미니 스캐너의 설정을 공장 초기화 상태로 되돌리며 시간이 걸릴 수도 있습니다.";
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
	if ( section == 0)	return @"앱 버전";
	if ( section == 1)	return @"자료 업데이트";
//    if ( section == 2)	return @"사운드와 효과음";
//    if ( section == 3)  return @"블루투스 바코드 스캐너 설정";
//    if ( section == 4)	return @"스캔 설정";
//    if ( section == 5)	return @"시스템 설정";
//    if ( section == 6)	return @"메모리 정보";
    if ( section == 2)	return @"KDC 정보";
    if ( section == 3)	return @"프린터 설정";
//    if ( section == 9)	return @"시간 동기화";
//    if ( section == 10)	return @"공장 초기화";
	
    return @"";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
//    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
//	NSArray *array = [dictionary objectForKey:@"System Settings"];
//    NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    if(section == 1)
    {
        return 80;
    }
  
//    if(section == 2)
//    {
//        return 80;
//    }
//    
//    if(section == 3)
//    {
//        return 100;
//    }
//    
//    if(section == 4)
//    {
//        if([cellValue isEqualToString:@"자동 스캔"])
//            return 100;
//        
//        return 44;
//    }
//    
//    
//    if(section == 5)
//    {
//        if([cellValue isEqualToString:@"자동 삭제"])
//            return 100;
//        return 80;
//    }
//    
//    if(section == 9)
//    {
//        return 80;
//    }
//    
//    if(section == 10)
//    {
//        return 80;
//    }
    
    
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"System Settings"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    if([cellValue isEqualToString:@"자동 스캔 간격"])
    {
        if ( [[array objectAtIndex:indexPath.row] isEqual:@"자동 스캔 간격"] ) {
            delayView = [[SettingViewRereadDelay alloc] initWithNibName:@"SettingViewRereadDelay" bundle:nil];
            [self.navigationController pushViewController:delayView animated:YES];
        }
    }
    
    if([cellValue isEqualToString:@"물품마스터 업데이트"])
    {
        UIAlertView* av = nil;
        av = [[UIAlertView alloc]
              initWithTitle:@"질문"
              message:@"물품마스터를 업데이트 하시겠습니까?"
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"예",@"아니오",nil];
        av.tag = 100;
        [av show];
    }
    
    
    if([cellValue isEqualToString:@"메모리 리셋 하기"])
    {
        UIAlertView* av = nil;
        av = [[UIAlertView alloc]
              initWithTitle:@"질문"
              message:@"스캐너의 메모리를 전부 삭제 하시겠습니까?"
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"예",@"아니오",nil];
        av.tag = 200;
        [av show];
    }
    
    if([cellValue isEqualToString:@"시간 동기화 하기"])
    {
        UIAlertView* av = nil;
        av = [[UIAlertView alloc]
              initWithTitle:@"질문"
              message:@"스캐너의 시간을 아이폰 시간과 동기화 시키겠습니까?"
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"예",@"아니오",nil];
        av.tag = 300;
        [av show];
    }
    
    if([cellValue isEqualToString:@"공장 초기화 하기"])
    {
        UIAlertView* av = nil;
        av = [[UIAlertView alloc]
              initWithTitle:@"질문"
              message:@"스캐너의 설정을 초기화 하겠습니까?"
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"예",@"아니오",nil];
        av.tag = 400;
        [av show];
    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    BOOL isWrite = NO;
    NSString *msg = @"";
    
    if(textField.tag == 0){
        isWrite = [Util writeSetupInfoToPlist:@"IP" value:[textField text]];
        if(isWrite) msg = @"프린트 IP 설정 저장에 성공 했습니다.";
        else msg = @"프린트 IP 설정 저장에 실패 했습니다.";
    }else{
        isWrite = [Util writeSetupInfoToPlist:@"PORT" value:[textField text]];
        if(isWrite) msg = @"프린트 PORT 설정 저장에 성공 했습니다.";
        else msg = @"프린트 PORT 설정 저장에 실패 했습니다.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    [alert show];
    
    [textField resignFirstResponder];
    return YES;
}

- (void) stopWaitforGetKDCSettings
{
    if (!isFinishedGetScanerSetting)
    {
        [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
        
        UIAlertView *av = nil;
        
        av = [[UIAlertView alloc]
              initWithTitle:@"알림"
              message:@"스캐너의 설정을 가져오는데 실패 하였습니다. 다시 시도 하시기 바랍니다."
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"확인", nil];
        [av show];
    }
}

- (void) waitforGetKDCSettings
{
//    if (![indicatorView isAnimating])
//    {
//        [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
//        isFinishedGetScanerSetting = NO;
//    }
    
    [self initKDCSettings];
}

- (void) initKDCSettings
{
    softKeyboardSwitch = [[UISwitch alloc] init];
    softKeyboardSwitch.tag = softKeyboard;
    
    connectAlertSwitch = [[UISwitch alloc] init];
    connectAlertSwitch.tag = connectalert;
    
    autoTriggerSwitch = [[UISwitch alloc] init];
    autoTriggerSwitch.tag = autotrigger;
    
    autoEraseSwitch = [[UISwitch alloc] init];
    autoEraseSwitch.tag = autoerase;
    
    beepSoundSwitch = [[UISwitch alloc] init];
    beepSoundSwitch.tag = beepsound;
    
    beepOnScanSwitch = [[UISwitch alloc] init];
    beepOnScanSwitch.tag = beeponscan;
    
    beepVolumeHighSwitch = [[UISwitch alloc] init];
    beepVolumeHighSwitch.tag = beepvolhigh;
    
    vibratorSwitch = [[UISwitch alloc] init];
    vibratorSwitch.tag = vibrator;
    
    keyPadSwitch = [[UISwitch alloc] init];
    keyPadSwitch.tag = keypad;
}

- (void) loadKDCSettings
{
    
//    KDCSettingBackup = KDCSetting;
//    
//    softKeyboardSwitch = [[UISwitch alloc] init];
//    softKeyboardSwitch.tag = softKeyboard;
//    if ( KDCSetting & 0x20000000 )	[softKeyboardSwitch setOn:YES];
//
//    
//    connectAlertSwitch = [[UISwitch alloc] init];
//    connectAlertSwitch.tag = connectalert;
//    if ( KDCSetting & 0x20000000 )	[connectAlertSwitch setOn:YES];
//    
//    autoTriggerSwitch = [[UISwitch alloc] init];
//    autoTriggerSwitch.tag = autotrigger;
//    if ( KDCSetting & 0x01000000 )	[autoTriggerSwitch setOn:YES];
//    
//    RereadDelayBackup = RereadDelay;
//    
//    autoEraseSwitch = [[UISwitch alloc] init];
//    autoEraseSwitch.tag = autoerase;
//    if ( KDCSetting & 0x10000000 )	[autoEraseSwitch setOn:YES];
//    
//    beepSoundSwitch = [[UISwitch alloc] init];
//    beepSoundSwitch.tag = beepsound;
//    if ( KDCSetting & 0x80000000 )	[beepSoundSwitch setOn:YES];
//    
//    beepOnScanSwitch = [[UISwitch alloc] init];
//    beepOnScanSwitch.tag = beeponscan;
//    if ( KDCSetting & 0x02000000 )	[beepOnScanSwitch setOn:YES];
//    
//    beepVolumeHighSwitch = [[UISwitch alloc] init];
//    beepVolumeHighSwitch.tag = beepvolhigh;
//    if ( KDCSetting & 0x40000000 )	[beepVolumeHighSwitch setOn:YES];
//    
//    vibratorSwitch = [[UISwitch alloc] init];
//    vibratorSwitch.tag = vibrator;
//    if ( KDCSetting & 0x04000000 )	[vibratorSwitch setOn:YES];
//    
//    keyPadSwitch = [[UISwitch alloc] init];
//    keyPadSwitch.tag = keypad;
//    if ( KDCSetting & 0x08000000 )	[keyPadSwitch setOn:YES];
}

- (void) saveKDCSettings
{
    
//    if (IsConnected ) {
//        KDCSetting &= (~0xFF000000);
//        
//        
//        if ( connectAlertSwitch.on)     KDCSetting |= 0x20000000;
//        if ( autoTriggerSwitch.on)      KDCSetting |= 0x01000000;
//        if ( autoEraseSwitch.on)        KDCSetting |= 0x10000000;
//        if ( beepSoundSwitch.on)        KDCSetting |= 0x80000000;
//        if ( beepOnScanSwitch.on)       KDCSetting |= 0x02000000;
//        if ( beepVolumeHighSwitch.on)   KDCSetting |= 0x40000000;
//        if ( vibratorSwitch.on)         KDCSetting |= 0x04000000;
//        if ( keyPadSwitch.on)           KDCSetting |= 0x08000000;
//        
//        //미연결 경고
//        if ( (KDCSetting & 0x20000000) != (KDCSettingBackup & 0x20000000) )
//            [kscan SendCommandWithValue:"bTaS":(KDCSetting & 0x20000000) ? 1 : 0];
//        //자동 스캔
//        if ( (KDCSetting & 0x01000000) != (KDCSettingBackup & 0x01000000) )
//            [kscan SendCommandWithValue:"GtSM":(KDCSetting & 0x01000000) ? 1 : 0];
//        //자동 스캔 간격
//        if ( RereadDelay != RereadDelayBackup )
//            [kscan SendCommandWithValue:"GtSD":RereadDelay];
//        //자동 삭제
//        if ( (KDCSetting & 0x10000000) != (KDCSettingBackup & 0x10000000) )
//            [kscan SendCommandWithValue:"GnES":(KDCSetting & 0x10000000) ? 1 : 0];
//        //비프음
//        if ( (KDCSetting & 0x80000000) != (KDCSettingBackup & 0x80000000) )
//            [kscan SendCommandWithValue:"Gb":(KDCSetting & 0x80000000) ? 1 : 0];
//        //스캔 사운드
//        if ( (KDCSetting & 0x02000000) != (KDCSettingBackup & 0x02000000) )
//            [kscan SendCommandWithValue:"GbSS":(KDCSetting & 0x02000000) ? 1 : 0];
//        //비프음 크게하기
//        if ( (KDCSetting & 0x40000000) != (KDCSettingBackup & 0x40000000) )
//            [kscan SendCommandWithValue:"GbV":(KDCSetting & 0x40000000) ? 1 : 0];
//        //진동 모드
//        if ( (KDCSetting & 0x04000000) != (KDCSettingBackup & 0x04000000) )
//            [kscan SendCommandWithValue:"GnVS":(KDCSetting & 0x04000000) ? 1 : 0];
//        //키패드 활성화
//        if ( (KDCSetting & 0x08000000) != (KDCSettingBackup & 0x08000000) )
//            [kscan SendCommandWithValue:"GkNS":(KDCSetting & 0x08000000) ? 1 : 0];
//        
//        [kscan FinishCommand];
//    }
}

- (void)requestKDCSettingFinished
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    isFinishedGetScanerSetting = YES;
    [self loadKDCSettings];
    [_tableView reloadData];
}

#pragma User Method
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


#pragma mark - User Action Method
- (void) touchBackBtn:(id)sender
{
    [Util writeSetupInfoToPlist:@"SOUND" value:[NSString stringWithFormat:@"%d", soundSwitch.on]];
    [Util writeSetupInfoToPlist:@"SOFT_KEYBOARD" value:[NSString stringWithFormat:@"%d", softKeyboardSwitch.on]];
    [Util udSetBool:soundSwitch.on forKey:SOUND_ON_OFF];
    [Util udSetBool:softKeyboardSwitch.on forKey:SOFT_KEYBOARD_ON_OFF];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpdateBtn:(id)sender
{
    UIAlertView* av = nil;
    av = [[UIAlertView alloc]
          initWithTitle:@"질문"
                message:@"변경내역만 업데이트 하시겠습니까?"
                delegate:self
       cancelButtonTitle:nil
       otherButtonTitles:@"예",@"아니오",nil];
    av.tag = 100;
    [av show];
    [Util playSoundWithMessage:@"변경내역만 업데이트 하시겠습니까?" isError:NO];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==100){
        if (buttonIndex == 0){ //예 ,업데이트
            isDownloadAll = NO;
            [self requestMatnr:1];
        }
        else { //아니오, 전체다운로드
            isDownloadAll = YES;
        }
    }else if (alertView.tag ==200){
        if (buttonIndex == 0){ //예 ,업데이트
//            [kscan EraseKDCMemory];
//            [kscan FinishCommand];
        }
        else { //아니오, 전체다운로드
            //
        }
    }else if (alertView.tag ==300){
        if (buttonIndex == 0){ //예 ,업데이트
//            [kscan SyncKDCClock];
        }
        else { //아니오, 전체다운로드
            //
        }
    }else if (alertView.tag ==400){
        if (buttonIndex == 0){ //예 ,업데이트
//            [kscan SetFactoryDefault];
        }
        else { //아니오, 전체다운로드
            //
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 0){
            LoginViewController* vc = [[LoginViewController alloc] init];
            [vc requestUserLogout];
        }
    }
}

#pragma mark - Http Request Method
- (void)requestMatnr:(int)nFetchCount
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MATNR_INFO;
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    //ud 에서 사용자 정보 가져온다.
    NSDictionary* userInfoDic = [Util udObjectForKey:USER_INFO];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[userInfoDic objectForKey:@"orgId"] forKey:@"ORGCODE"];
    if (![Util udObjectForKey:EAI_MATNR_CDATE]){
        strEAI_MANTR_CDATE = @"00000000000000000";
        [paramDic setObject:strEAI_MANTR_CDATE forKey:@"EAI_CDATE"]; //최초 한번만
    }
    else {
        strEAI_MANTR_CDATE = [Util udObjectForKey:EAI_MATNR_CDATE];
        [paramDic setObject:strEAI_MANTR_CDATE forKey:@"EAI_CDATE"];
    }
    
    [paramDic setObject:@"1" forKey:@"currentPageNo"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",nFetchCount] forKey:@"currentPageCount"];
    [paramDic setObject:@"Y" forKey:@"pageUseYN"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_MATNR_INFO withData:rootDic];
}


- (void)requestMultiMatnr:(int)pageNo fetchCount:(int)nFetchCount
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_MULT_MATNR_INFO;
    
    
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:NO];
    
    //ud 에서 사용자 정보 가져온다.
    NSDictionary* userInfoDic = [Util udObjectForKey:USER_INFO];
    
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[userInfoDic objectForKey:@"orgId"] forKey:@"ORGCODE"];
    
    
    [paramDic setObject:strEAI_MANTR_CDATE forKey:@"EAI_CDATE"];
    
    [paramDic setObject:@"00000000000000000" forKey:@"EAI_CDATE"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:@"currentPageNo"];
    [paramDic setObject:[NSString stringWithFormat:@"%d",nFetchCount] forKey:@"currentPageCount"];
    [paramDic setObject:@"Y" forKey:@"pageUseYN"];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    
    [requestMgr asychronousConnectToServer:API_MATNR_INFO withData:rootDic];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status
{
    [self performSelectorOnMainThread:@selector(hideIndicator) withObject:nil waitUntilDone:NO];
    
    if (status == 0 || status == 2){ //실패
        NSDictionary* headerDic = [resultList objectAtIndex:0];
        
        NSString* message = [headerDic objectForKey:@"detail"];
        
        if ([message length] ){
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            UIAlertView* av = [[UIAlertView alloc]
                               initWithTitle:nil
                               message:message
                               delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:@"닫기", nil];
            [av show];
        }
        
        return;
    }else if (status == -1){ //세션종료
        NSString* message = @"세션이 종료되었습니다.\n재접속 하시겠습니까?\n(저장하지 않은 자료는 재 작업 하셔야 합니다.)";
        UIAlertView* av = [[UIAlertView alloc]
                           initWithTitle:@"알림"
                           message:message
                           delegate:self
                           cancelButtonTitle:nil
                           otherButtonTitles:@"예",@"아니오" ,nil];
        av.tag = 2000;
        [av show];
        [Util playSoundWithMessage:message isError:YES];
        
        return;
    }
    
    if (pid == REQUEST_MATNR_INFO){
        [self processMATNRResponse:resultList];
    }else if (pid == REQUEST_MULT_MATNR_INFO){
        [self processMultiMATNRResponse:resultList];
    }
}


- (void)processMATNRResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        NSDictionary* dic = [resultList objectAtIndex:0];
        nTotalCount = [[dic objectForKey:@"totalCount"] integerValue];
        NSString* strCreateDate = [dic objectForKey:@"EAI_CDATE"];
        
        NSString* strSqlQuery = [NSString stringWithFormat:SELECT_ITEM_EAI_CDATE, strEAI_MANTR_CDATE];
        NSArray* sqlResultList = [[DBManager sharedInstance] executeSelectQuery:strSqlQuery];
        
        if (nTotalCount == [sqlResultList count]){
            NSString* progressMsg = @"서버에 업데이트 데이터가 없습니다.";
            
            UIAlertView* av = nil;
            av = [[UIAlertView alloc]
                  initWithTitle:@"알림"
                  message:progressMsg
                  delegate:self
                  cancelButtonTitle:nil
                  otherButtonTitles:@"닫기",nil];
            [av show];
            [Util playSoundWithMessage:progressMsg isError:NO];
            
            return;
        }
        
        
        //userDefault에 저장
        if (strCreateDate.length)
            [Util udSetObject:strCreateDate forKey:EAI_MATNR_CDATE];
        
        if (nTotalCount > 0){
            progressView.hidden = NO;
            nRemainCount = nTotalCount;
            nCurrentPageNo = 1;
            [self requestMultiMatnr:(int)nCurrentPageNo fetchCount:FETCH_COUNT];
        }
    }
    else {
        NSString* progressMsg = @"물품업데이트 완료.";
        
        UIAlertView* av = nil;
        av = [[UIAlertView alloc]
              initWithTitle:@"알림"
              message:progressMsg
              delegate:self
              cancelButtonTitle:nil
              otherButtonTitles:@"닫기",nil];
        [av show];
        [Util playSoundWithMessage:progressMsg isError:NO];
    }
    
}


- (void)processMultiMATNRResponse:(NSArray*)resultList
{
    if ([resultList count])
    {
        [self saveMatnrListToDB:resultList];
        
        nRemainCount = nRemainCount - resultList.count;
        
        NSLog(@"totalCount [%d] nRemainCount[%d]",(int)nTotalCount,(int)nRemainCount);
        float percent = (float)(nTotalCount - nRemainCount)/(float)nTotalCount;
        progressView.progress = percent;
        
        if (nRemainCount > 0){
            nCurrentPageNo++;
            [self requestMultiMatnr:(int)nCurrentPageNo fetchCount:FETCH_COUNT];
        }
        else {
            NSString* progressMsg = @"물품업데이트 완료.";
            UIAlertView* av = nil;
            av = [[UIAlertView alloc]
                  initWithTitle:@"알림"
                  message:progressMsg
                  delegate:self
                  cancelButtonTitle:nil
                  otherButtonTitles:@"닫기",nil];
            [av show];
            [Util playSoundWithMessage:progressMsg isError:NO];
            
            nCurrentPageNo = 1;
            
            [self getMATNRCount];
            [_tableView reloadData];
        }
    }
    else {
        lblProgressMsg.text = @"데이터에 업데이트 정보가 없습니다.";
    }
}
#pragma mark - DB Method
/**
 물품정보를 DB에 저장한다.
 */
- (void)saveMatnrListToDB:(NSArray*)saveList
{
    
    sqlite3 *dbObject = [[DBManager sharedInstance] getDatabaseObject];
    
    char* errorMessage;
    sqlite3_exec(dbObject, "BEGIN TRANSACTION", NULL, NULL, &errorMessage);
    
    sqlite3_stmt* stmt;

    char *sqlQuery = INSERT_MANTR;
    
    int sqlReturn = sqlite3_prepare_v2(dbObject, sqlQuery, (int)strlen(sqlQuery), &stmt, NULL);
    
    
    if(sqlReturn != SQLITE_OK) {
        NSLog(@"Error: '%s'.", sqlite3_errmsg(dbObject));
    }
    
    int successCount = 0;
    for (NSDictionary* dic in saveList){
        NSString* MATERIALSEQ = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"MATERIALSEQ"] intValue]];
        if ([MATERIALSEQ isKindOfClass:[NSNull class]]){
            continue;
        }

        NSString* MATNR;
        if ([[dic objectForKey:@"MATNR"] isKindOfClass:[NSNull class]])
            MATNR = @"";
        else
            MATNR = [dic objectForKey:@"MATNR"];

        NSString* MAKTX;
        if ([[dic objectForKey:@"MAKTX"] isKindOfClass:[NSNull class]])
            MAKTX = @"";
        else{
            MAKTX = [dic objectForKey:@"MAKTX"];

            MAKTX = [MAKTX stringByReplacingOccurrencesOfString:@"'" withString:@""];
        }
        
        NSString* ZMATGB;
        if ([[dic objectForKey:@"ZMATGB"] isKindOfClass:[NSNull class]])
            ZMATGB = @"";
        else
            ZMATGB = [dic objectForKey:@"ZMATGB"];

        NSString* BISMT;
        if ([[dic objectForKey:@"BISMT"] isKindOfClass:[NSNull class]])
            BISMT = @"";
        else
            BISMT = [dic objectForKey:@"BISMT"];

        NSString* COMPTYPE;
        if ([[dic objectForKey:@"COMPTYPE"] isKindOfClass:[NSNull class]])
            COMPTYPE = @"";
        else
            COMPTYPE = [dic objectForKey:@"COMPTYPE"];

        NSString* ZEMAFT;
        if ([[dic objectForKey:@"ZEMAFT"] isKindOfClass:[NSNull class]])
            ZEMAFT = @"";
        else
            ZEMAFT = [dic objectForKey:@"ZEMAFT"];

        NSString* ZEMAFT_NAME;
        if ([[dic objectForKey:@"ZEMAFT_NAME"] isKindOfClass:[NSNull class]])
            ZEMAFT_NAME = @"";
        else
            ZEMAFT_NAME = [dic objectForKey:@"ZEMAFT_NAME"];

        NSString* EAI_CDATE;
        if ([[dic objectForKey:@"EAI_CDATE"] isKindOfClass:[NSNull class]])
            EAI_CDATE = @"";
        else
            EAI_CDATE = [dic objectForKey:@"EAI_CDATE"];

        NSString* STATUS;
        if ([[dic objectForKey:@"STATUS"] isKindOfClass:[NSNull class]])
            STATUS = @"";
        else
            STATUS = [dic objectForKey:@"STATUS"];

        NSString* EXTWG;
        if ([[dic objectForKey:@"EXTWG"] isKindOfClass:[NSNull class]])
            EXTWG = @"";
        else
            EXTWG = [dic objectForKey:@"EXTWG"];

        NSString* MTART;
        if ([[dic objectForKey:@"MTART"] isKindOfClass:[NSNull class]])
            MTART = @"";
        else
            MTART = [dic objectForKey:@"MTART"];

        NSString* BARCD;
        if ([[dic objectForKey:@"BARCD"] isKindOfClass:[NSNull class]])
            BARCD = @"";
        else
            BARCD = [dic objectForKey:@"BARCD"];

        
        sqlite3_bind_text(stmt, 1,[MATERIALSEQ UTF8String] , -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [MATNR UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 3, [MAKTX UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 4, [ZMATGB UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 5, [BISMT UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 6, [COMPTYPE UTF8String],-1,SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 7, [ZEMAFT UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 8, [ZEMAFT_NAME UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 9, [EAI_CDATE UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 10, [STATUS UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 11, [EXTWG UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 12, [MTART UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 13, [BARCD UTF8String], -1, SQLITE_TRANSIENT);

        if (sqlite3_step(stmt) != SQLITE_DONE)
        {
            NSLog(@"failed to sqlite3_step - error : %d\n dic[%@]", sqlite3_step(stmt),dic);
        }
        else
        {
            successCount++;
        }
        sqlite3_reset(stmt);
    }
    NSLog(@"success count [%d]",successCount);
    
    sqlite3_exec(dbObject, "COMMIT TRANSACTION", NULL, NULL, &errorMessage);
    sqlite3_finalize(stmt);
}

- (void) getMATNRCount
{
    NSString* strSqlQuery = SELECT_COUNT_ITEM_ALL;

    nTotalCount = [[DBManager sharedInstance] countSelectQuery:strSqlQuery];
}


@end

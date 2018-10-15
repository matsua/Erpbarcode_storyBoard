//
//  PrintSettingViewController.m
//  erpbarcode
//
//  Created by matsua on 2015. 9. 16..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import "PrintSettingViewController.h"
#import "BarcodePrintController.h"
#import "CustomPickerView.h"

@interface PrintSettingViewController ()

@property(nonatomic,strong) IBOutlet UITextField *x_coordinateTextField;
@property(nonatomic,strong) IBOutlet UITextField *y_coordinateTextField;
@property(nonatomic,strong) IBOutlet UITextField *darknessTextField;
@property(nonatomic,weak) IBOutlet UISlider *slider;
@property(nonatomic,assign) int x_coordinate;
@property(nonatomic,assign) int y_coordinate;
@property(nonatomic,assign) int xd_coordinate;
@property(nonatomic,assign) int yd_coordinate;
@property(nonatomic,assign) int darkness;
@property(nonatomic,strong) CustomPickerView* picker;
@property(nonatomic,strong) NSString* selectedPickerData;
@property(nonatomic,strong) IBOutlet UILabel *lblCount;

@end

@implementation PrintSettingViewController

@synthesize type;
@synthesize x_coordinate;
@synthesize y_coordinate;
@synthesize xd_coordinate;
@synthesize yd_coordinate;
@synthesize darkness;
@synthesize x_coordinateTextField;
@synthesize y_coordinateTextField;
@synthesize darknessTextField;
@synthesize slider;
@synthesize picker;
@synthesize selectedPickerData;
@synthesize lblCount;


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
    
    x_coordinateTextField.delegate = self;
    y_coordinateTextField.delegate = self;
    darknessTextField.delegate = self;
    
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docRootPath = [docPath objectAtIndex:0];
    NSString *filePath = [docRootPath stringByAppendingFormat:@"/setupInfo.plist"];
    NSDictionary *stringDic = [[[NSDictionary alloc] initWithContentsOfFile:filePath] objectForKey:type];
    
//    NSDictionary *stringDicTemp = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
//    NSLog(@"stringDicTemp :: %@",stringDicTemp);
    
    xd_coordinate = x_coordinate = [[stringDic objectForKey:@"x"] intValue];
    yd_coordinate = y_coordinate = [[stringDic objectForKey:@"y"] intValue];
    darkness = [[stringDic objectForKey:@"sd"] intValue];
    
    [slider setValue:darkness animated:YES];
    
    if(![[stringDic objectForKey:@"xu"] isEqualToString:@"0"]){
        x_coordinate = [[stringDic objectForKey:@"xu"] intValue];
    }
    
    if(![[stringDic objectForKey:@"yu"] isEqualToString:@"0"]){
        y_coordinate = [[stringDic objectForKey:@"yu"] intValue];
    }
    
    x_coordinateTextField.text = [NSString stringWithFormat:@"%d",x_coordinate];
    y_coordinateTextField.text = [NSString stringWithFormat:@"%d",y_coordinate];
    darknessTextField.text =  [NSString stringWithFormat:@"%d",darkness];
    
    picker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"8",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"]];
    picker.delegate = self;
    selectedPickerData = @"";
    [picker selectPicker:0];
}

#pragma mark - IBAction : UI : touchCountPicker
- (IBAction)touchCountPicker:(id)sender {
    [picker showView];
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    [picker hideView];
}

// 피커뷰에서 항목을 선택했을 때...
- (void)onDone:(NSString *)data sender:(id)sender {
    lblCount.textColor = [UIColor blackColor];
    selectedPickerData = data;
    lblCount.text = data;
    [picker hideView];
}

#pragma mark - 사용자 좌표수정
-(IBAction)coordinateChangeBtn:(id)sender {
    int tag = (int)[sender tag];
    
    if(tag == 0)//left
        x_coordinate--;
    else if (tag == 1) //top
        y_coordinate++;
    else if (tag == 2) //bottom
        y_coordinate--;
    else //right
        x_coordinate++;
    
    x_coordinateTextField.text = [NSString stringWithFormat:@"%d",x_coordinate];
    y_coordinateTextField.text = [NSString stringWithFormat:@"%d",y_coordinate];
}

#pragma mark - 초기화, 저장
-(IBAction)settingBtn:(id)sender {
    int tag = (int)[sender tag];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"setupInfo.plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *userDic = [NSDictionary alloc];
    NSString *msg = @"";
    BOOL isWrite = NO;
    
    if(tag == 0){ //초기화
        x_coordinate = 0;
        y_coordinate = 0;
        darkness = 25;
        
        x_coordinateTextField.text = [NSString stringWithFormat:@"%d",x_coordinate];
        y_coordinateTextField.text = [NSString stringWithFormat:@"%d",y_coordinate];
        darknessTextField.text =  [NSString stringWithFormat:@"%d",darkness];
        
        msg = @"설정 초기화를";
    }else{ //저장
        msg = @"설정 저장을";
    }
    
    userDic = [[NSDictionary alloc] initWithObjectsAndKeys:
               [NSString stringWithFormat:@"%d",x_coordinate],@"xu",
               [NSString stringWithFormat:@"%d",y_coordinate],@"yu",
               [NSString stringWithFormat:@"%d",xd_coordinate],@"x",
               [NSString stringWithFormat:@"%d",yd_coordinate],@"y",
               [NSString stringWithFormat:@"%d",darkness],@"sd",
               nil];
    
    plistDict[type] = userDic;
    isWrite = [plistDict writeToFile: path atomically:YES];
    
    if(isWrite) msg = [NSString stringWithFormat:@"%@ 완료 했습니다.",msg];
    else msg = [NSString stringWithFormat:@"%@ 실패 했습니다.",msg];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:msg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 슬라이드
- (IBAction)sliderValueChanged:(id)sender {
    darkness = [[NSString stringWithFormat:@"%f", slider.value] intValue];
    darknessTextField.text =  [NSString stringWithFormat:@"%d",darkness];
}

#pragma mark - 출력
-(IBAction)printBtn:(id)sender {
    NSMutableArray *dicArray = [[NSMutableArray alloc] init];
    
//    if([type isEqualToString:@"7"]){
//        for(int i = 0; i < [selectedPickerData intValue]; i++){
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:@"P00012836970000000000" forKey:@"locationCode"];
//            [dic setObject:@"OO특별시 OO구" forKey:@"geoName"];
//            [dic setObject:@"OO동 OO건물" forKey:@"locationName"];
//            [dicArray addObject:dic];
//        }
//    }else{
//        for(int i = 0; i < [selectedPickerData intValue]; i++){
//            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:@"K23456712345678" forKey:@"newBarcode"];
//            [dic setObject:@"Unit" forKey:@"partKindName"];
//            [dic setObject:@"Test" forKey:@"itemName"];
//            [dicArray addObject:dic];
//        }
//    }
    
//    NSArray * array = [NSArray arrayWithObjects: @"011501000406070036",@"011501000706100087",@"011501000708110173",@"011501001706070387",
//                                                 @"011501001706070388",@"011501001706070389",@"011501001707010296",@"011501001709080169",
//                                                 @"011501001906070469",@"011501001906070470",@"011501001906070471",@"011501001906070472",
//                                                 @"011501002006070118",@"011501002106070193",@"011501003407051000",@"011501003407060028",
//                                                 @"011501003408030247",@"011501003408040050",@"011501003408100141",@"011501003408110809",nil]; //예비
    
//    NSArray * array = [NSArray arrayWithObjects: @"001504006010070370",@"001504006010110066",@"001504006011070038",nil]; //유휴
//    NSArray * array = [NSArray arrayWithObjects: @"011501000406070036",@"082070421006030002",@"082070422106030016",nil]; //tree
//    NSArray * array = [NSArray arrayWithObjects: @"K917962400007131",nil]; //스캐너
//    NSArray * array = [NSArray arrayWithObjects: @"B00000014690010110619",@"B00000017840010010201", nil];
    
//    NSArray * array = [NSArray arrayWithObjects: @"VS0000000000003420000",nil];
    
//    NSArray * array = [NSArray arrayWithObjects: @"VS0000000000014990000",@"VS0000000000003420000",nil];
    
//    NSArray * array = [NSArray arrayWithObjects: @"B00000030190030230640",@"B00000012300030690201",@"102270387",@"B0000381184B010010000",
//                                                 @"B0000258051B010010101",@"101505258",@"B00002324300010010102",@"000653677",
//                                                 @"VS0000000000015540000",@"VS0000000000014710000",@"K918489800012426",@"K918489800012676",
//                                                 @"K918489800012698",@"K918489800012665",nil];
    
//    NSArray * array = [NSArray arrayWithObjects: @"VS0000000000014990000!@#",@"004200100112040!@#",nil];
//    NSArray * array = [NSArray arrayWithObjects: @"SWCH9085114000109",nil];
    
//    for(int i = 0; i < [array count]; i++){
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:[array objectAtIndex:i] forKey:@"newBarcode"];
//        [dic setObject:[array objectAtIndex:i] forKey:@"barcode"];
    
    for(int i = 0; i < [selectedPickerData intValue]; i++){
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"K912345678901234" forKey:@"newBarcode"];
        [dic setObject:@"Unit" forKey:@"partKindName"];
        [dic setObject:@"LG_AGAM" forKey:@"itemName"];
        [dic setObject:@"P00012836970000000000" forKey:@"locationCode"];
        [dic setObject:@"OO특별시 OO구" forKey:@"geoName"];
        [dic setObject:@"OO동 OO건물" forKey:@"locationName"];
        [dic setObject:@"K912345678901234" forKey:@"deviceId"];
        [dic setObject:@"LG_AGAM" forKey:@"deviceName"];
        [dic setObject:@"LG_AGAM" forKey:@"barcode"];
        [dicArray addObject:dic];
    }
    
    BarcodePrintController *bpr = [[BarcodePrintController alloc] init];
    [bpr makeBarcodeAndPrint:[type intValue] sendDataList:dicArray statusMod:false];
}

#pragma delegate textField softkeyboard
- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    if(textField.tag == 0){
        if([textField.text length] < 1){
            x_coordinateTextField.text = [NSString stringWithFormat:@"%d",x_coordinate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"정확한 좌표를 입력해 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            x_coordinate = [textField.text intValue];
        }
    }else if(textField.tag == 1){
        if([textField.text length] < 1){
            y_coordinateTextField.text = [NSString stringWithFormat:@"%d",y_coordinate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"정확한 좌표를 입력해 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            y_coordinate = [textField.text intValue];
        }
    }else{
        if([textField.text intValue] > 0){
            if([textField.text intValue] > 30){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"명암의 범위는 1-30 입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alert show];
            }
            darkness = [textField.text intValue];
            slider.value = darkness;
        }else{
            darknessTextField.text =  [NSString stringWithFormat:@"%d",darkness];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"정확한 명암값을 입력해 주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)confirm:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)closeModal:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}


@end

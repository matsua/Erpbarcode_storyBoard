//
//  CancelRsViewController.m
//  erpbarcode
//
//  Created by matsua on 2015. 9. 16..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import "CancelRsViewController.h"
#import "RevisionViewController.h"
#import "ERPRequestManager.h"
#import "CustomPickerView.h"
#import "ERPAlert.h"

@interface CancelRsViewController ()
@property(nonatomic,strong) IBOutlet UILabel* lblCancelRs;
@property(nonatomic,strong) IBOutlet UITextField* txtCancelRsDt;
@property(nonatomic,strong) NSMutableArray* idResultList;
@property(nonatomic,strong) CustomPickerView* RequestIdPicker;
@property(nonatomic,strong) NSString* selectedIdPickerData;
@property(nonatomic,strong) NSString* idKey;

@end

@implementation CancelRsViewController

@synthesize delegate;
@synthesize txtCancelRsDt;
@synthesize idResultList;
@synthesize RequestIdPicker;
@synthesize selectedIdPickerData;
@synthesize idKey;

@synthesize lblCancelRs;

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
    [self requestInsDel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)confirm:(id)sender{
    [delegate popRequest:idKey cancelRsDt:txtCancelRsDt.text];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)closeModal:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 요청취소사유 dataGet
-(void)requestInsDel{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_INS_DEL;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSDictionary* bodyDic = [Util singleMessageBody:paramDic];
    NSDictionary* rootDic  = [Util defaultMessage:[Util defaultHeader] body:bodyDic];
    [requestMgr asychronousConnectToServer:API_PRT_INS_DEL withData:rootDic];
}


#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status{
    
    [self processInsDel:resultList];
}

#pragma  mark - 요청취소사유 코드 조회
- (void)processInsDel:(NSArray*)reultList
{
    NSMutableArray* tempId = [NSMutableArray array];
    
    if (reultList.count){
        idResultList = [NSMutableArray array];
        
        for (NSDictionary* dic in reultList){
            NSMutableDictionary* idDic = [NSMutableDictionary dictionary];
            
            [idDic setObject:[dic objectForKey:@"commonCode"] forKey:@"commonCode"];
            [idDic setObject:[dic objectForKey:@"commonCodeName"] forKey:@"commonCodeName"];
            [tempId addObject:[dic objectForKey:@"commonCodeName"]];
            [idResultList addObject:idDic];
        }
    }
    
    lblCancelRs.text = @"선택하세요.";
    
    RequestIdPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, PHONE_SCREEN_HEIGHT - 240, 320, 240) data:tempId];
    RequestIdPicker.delegate = self;
}

#pragma mark - IBAction : UI : touchLabelTpPicker
- (IBAction)touchRequestIdPicker:(id)sender {
    [RequestIdPicker showView];
}

#pragma mark - CustomPickerViewDelegate
- (void)onCancel:(id)sender {
    [RequestIdPicker hideView];
}

- (void)onDone:(NSString *)data sender:(id)sender {
//    if([[[idResultList objectAtIndex:RequestIdPicker.selectedIndex] objectForKey:@"commonCode"] isEqualToString:@"ETC"]){
//        if([lblCancelRs.text isEqualToString:@""]){
//            NSString* message = @"상세사항을 입력하세요.";
//            [self showMessage:message tag:0 title1:@"닫기" title2:nil];
//            return;
//        }
//    }
    
    selectedIdPickerData = data;
    lblCancelRs.text = selectedIdPickerData;
    idKey = [[idResultList objectAtIndex:RequestIdPicker.selectedIndex] objectForKey:@"commonCode"];
    [RequestIdPicker hideView];
}

#pragma mark - messegeAlert
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2
{
    [self showMessage:message tag:tag title1:title1 title2:title2 isError:NO];
}

#pragma mark - messegeAlert
- (void) showMessage:(NSString*)message tag:(NSInteger)tag title1:(NSString*)title1 title2:(NSString*)title2 isError:(BOOL)isError
{
    [[ERPAlert getInstance] showMessage:message tag:tag title1:title1 title2:title2 isError:isError isCheckComplete:YES delegate:self];
}


@end
//
//  AddInfoViewController.m
//  erpbarcode
//
//  Created by matsua on 2014. 3. 17..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "AddInfoViewController.h"
#import "RevisionViewController.h"
#import "ERPRequestManager.h"

@interface AddInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *locCdLb;
@property(nonatomic,strong) IBOutlet UITextField* txtLocNm;
@property(nonatomic,strong) IBOutlet UITextField* txtLocNmBd;
@property(nonatomic,strong) IBOutlet UITextField* txtLocNmLoad;

@end

@implementation AddInfoViewController

@synthesize delegate;
@synthesize locCd;
@synthesize locNm;
@synthesize locNmBd;
@synthesize locNmLoad;

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
    
    _locCdLb.text = locCd;
    _txtLocNm.text = locNm;
    _txtLocNmBd.text = locNmBd;
    _txtLocNmLoad.text = locNmLoad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)closeModal:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void) openModal:(NSString*)locCd_re{
    [self requestLocAddr:locCd_re];
}

- (void)requestLocAddr:(NSString*)locBarcode
{
    ERPRequestManager* requestMgr = [[ERPRequestManager alloc]init];
    
    requestMgr.delegate = self;
    requestMgr.reqKind = REQUEST_LOC_ADD;
    
    [requestMgr requestAddrInfo:locBarcode];
}

#pragma IProcessRequest delegate -- call by ERPRequestManager
- (void)processRequest:(NSArray*)resultList PID:(requestOfKind)pid Status:(NSInteger)status{
    
    [self processAddrResponse:resultList];
}

-(void)processAddrResponse:(NSArray*)resultList{
    
    NSString *roadName, *buildingMainNo, *buildingSubNo = @"";
    NSString *legalDongName, *addressTypeName, *bunji, *ho = @"";
    
    NSLog(@"==processAddrResponse result== %@", resultList);
    
    if ([resultList count]){
        for (NSDictionary* dic in resultList)
        {
            legalDongName = [dic objectForKey:@"legalDongName"];
            addressTypeName = [dic objectForKey:@"addressTypeName"];
            bunji = [dic objectForKey:@"bunji"];
            ho = [dic objectForKey:@"ho"];
            
            roadName = [dic objectForKey:@"roadName"];
            buildingMainNo = [dic objectForKey:@"buildingMainNo"];
            buildingSubNo = [dic objectForKey:@"buildingSubNo"];
        }
        
//        if(legalDongName.length > 0){
            if([addressTypeName isEqualToString:@"산"])
                legalDongName = [NSString stringWithFormat:@"%@ 산",legalDongName];
            
            legalDongName = [NSString stringWithFormat:@"%@ %@",legalDongName,bunji];
            
            if(![ho isEqualToString:@""])
                legalDongName = [NSString stringWithFormat:@"%@ - %@",legalDongName,ho];
//        }
        
//        if(roadName.length > 0){
            roadName = [NSString stringWithFormat:@"%@ %@",roadName,buildingMainNo];
            
            if(![buildingSubNo isEqualToString:@""])
                roadName = [NSString stringWithFormat:@"%@ - %@",roadName,buildingSubNo];
//        }
    }
    
    [delegate popRequest:legalDongName locAddrLoad:roadName];
}

@end

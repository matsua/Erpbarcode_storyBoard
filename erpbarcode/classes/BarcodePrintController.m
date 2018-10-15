//
//  BarcodePrintController.m
//  erpbarcode
//
//  Created by matsua on 2015. 9. 8..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import "BarcodePrintController.h"
#import "BarcodeViewController.h"

#import "ZebraPrinterConnection.h"
#import "TcpPrinterConnection.h"
#import "GraphicsUtil.h"
#import "ZebraPrinterFactory.h"
#import "MfiBtPrinterConnection.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <SystemConfiguration/CaptiveNetwork.h>

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6   /* Ethernet CSMACD */ /*111.111.111.111 6101*/
#endif

@interface BarcodePrintController ()

@property (nonatomic, retain) NSString *pathOnPrinterText;
@property (nonatomic, retain) id<ZebraPrinterConnection, NSObject> connection;
@property (nonatomic, retain) id<ZebraPrinter, NSObject> printer;

@property(nonatomic,assign) int x_coordinate;
@property(nonatomic,assign) int y_coordinate;
@property(nonatomic,assign) int darkness;

@end

@implementation BarcodePrintController

@synthesize delegate;
@synthesize pathOnPrinterText;
@synthesize connection;
@synthesize printer;

@synthesize x_coordinate;
@synthesize y_coordinate;
@synthesize darkness;

-(void) makeBarcodeAndPrint:(int)type sendDataList:(NSMutableArray*) sendDataList statusMod:(BOOL)statusMod{
    //type -> 0:6x20 pdf417, 1:6x35 pdf417, 2:20x45 qrcode, 3:30x80 qrcode, 5:6x58 pdf417, 6:7x50 pdf417
    [self printSettingValue:type];
    [self openZebraPrinter];
    
    if(printer != nil) {
        NSDictionary* printData;
        
        for (NSDictionary* dic in sendDataList){
            NSString* ZPLcommand = @"";
            ZPLcommand = [NSString stringWithFormat:@"%@~SD%d",ZPLcommand,darkness];
            ZPLcommand = [NSString stringWithFormat:@"%@^XA^PW1280^LH0,0^XZ",ZPLcommand];
            ZPLcommand = [NSString stringWithFormat:@"%@^XA^SEE:UHANGUL.DAT^FS^CWQ,E:KFONT3.FNT^FS^CI28^XZ",ZPLcommand];
//            ZPLcommand = [NSString stringWithFormat:@"%@^XA^SEE:UHANGUL.DAT^FS^CWQ,E:KFONT3.FNT^FS^CI28",ZPLcommand];
            
            NSString *barcode = @"";
            NSString *geoName = @"";
            NSString *locationName = @"";
            NSString *barcodeLabel = @"";
            NSString *barcodeSubTitle1 = @"";
            NSString *barcodeSubTitle2 = @"";
            
            if(type == 7){
                barcode = [dic objectForKey:@"locationCode"];
                barcodeLabel = [dic objectForKey:@"locationCode"];
                geoName = [[dic objectForKey:@"geoName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                locationName = [[dic objectForKey:@"locationName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }else{
                barcode = [dic objectForKey:@"newBarcode"];
                barcodeLabel = [dic objectForKey:@"newBarcode"];
                barcodeSubTitle1 = [dic objectForKey:@"partKindName"];
                barcodeSubTitle2 = [dic objectForKey:@"itemName"];
            }
            
            if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"장치바코드"]){
                barcode = [dic objectForKey:@"deviceId"];
                barcodeLabel = [dic objectForKey:@"deviceId"];
                barcodeSubTitle1 = [dic objectForKey:@"deviceName"];
                barcodeSubTitle2 = [dic objectForKey:@"deviceId"];
            }
            if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"소스마킹"]){
                barcode = [dic objectForKey:@"barcode"];
                barcodeLabel = [dic objectForKey:@"barcode"];
                barcodeSubTitle1 = [dic objectForKey:@"partKindName"];
                if(![barcodeSubTitle1 isEqualToString:@"Unit"]&&
                   ![barcodeSubTitle1 isEqualToString:@"Shelf"]&&
                   ![barcodeSubTitle1 isEqualToString:@"Rack"]){
                    barcodeSubTitle1 = @"Equip";
                }
                barcodeSubTitle2 = [dic objectForKey:@"itemName"];
            }
            
            if([[barcode substringToIndex:2] isEqualToString:@"K9"]){
                barcode = [NSString EncryptBarcode:barcode];
                barcode = [NSString stringWithFormat:@"+%@",barcode];
            }
            
            ZPLcommand = [NSString stringWithFormat:@"%@^XA",ZPLcommand];
            
            switch (type) {
                case 0:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^B7N,6,1,2,,N^FD%@^FS",ZPLcommand,x_coordinate,y_coordinate,barcode];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,20,20^FD%@^FS",ZPLcommand,x_coordinate,y_coordinate + 45,barcodeLabel];
                    break;
                case 1:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^B7N,14,1,5,,N^FD%@^FS",ZPLcommand,x_coordinate,y_coordinate,barcode];
                    if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"장치바코드"]){
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 20,y_coordinate + 40,barcodeLabel];
                    }else{
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@/^FS",ZPLcommand,x_coordinate + 20,y_coordinate + 40,[barcodeSubTitle1 substringToIndex:1]];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 50,y_coordinate + 40,barcodeLabel];
                    }
                    break;
                case 2:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^BQN,2,5^FDQA,%@^FS",ZPLcommand,x_coordinate,y_coordinate,barcode];
                    if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"장치바코드"]){
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,30,30^FD%@^FS",ZPLcommand,x_coordinate + 110,y_coordinate + 15, barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,30,30^FD%@^FS",ZPLcommand,x_coordinate + 110,y_coordinate + 55,barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 110,y_coordinate + 95,barcodeLabel];
                    }else{
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 110,y_coordinate + 10,barcodeLabel];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 110,y_coordinate + 90,barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 170,y_coordinate + 90,barcodeSubTitle2];
                    }
                    break;
                case 3:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^BQN,2,7^FDQA,%@^FS",ZPLcommand,x_coordinate,y_coordinate,barcode];
                    if([[Util udObjectForKey:USER_WORK_NAME] isEqualToString:@"장치바코드"]){
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 10, barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 65,barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 117,barcodeLabel];
                    }else{
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 6,barcodeLabel];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 61,barcodeSubTitle1];
                        ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,50,50^FD%@^FS",ZPLcommand,x_coordinate + 160,y_coordinate + 107,barcodeSubTitle2];
                    }
                    break;
                case 5:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^B7N,13,1,6,,N^FD%@^FS",ZPLcommand,x_coordinate + 20,y_coordinate,barcode];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@/^FS",ZPLcommand,x_coordinate + 40,y_coordinate + 40,[barcodeSubTitle1 substringToIndex:1]];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 70,y_coordinate + 40,barcodeLabel];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 450,y_coordinate + 23,barcodeSubTitle2];
                    break;
                case 6:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BY2,3^B7N,15,1,5,,N^FD%@^FS",ZPLcommand,x_coordinate + 5,y_coordinate,barcode];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@/^FS",ZPLcommand,x_coordinate + 20,y_coordinate + 50,[barcodeSubTitle1 substringToIndex:1]];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,25,25^FD%@^FS",ZPLcommand,x_coordinate + 50,y_coordinate + 50,barcodeLabel];
                    break;
                case 7:
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^BCN,100,N,N,N^FD%@^FS",ZPLcommand,x_coordinate - 50,y_coordinate - 15,barcode];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,30,30^FD%@^FS",ZPLcommand,x_coordinate + 40,y_coordinate + 85,barcodeLabel];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,30,30^FD%@^FS",ZPLcommand,x_coordinate - 70,y_coordinate - 150,geoName];
                    ZPLcommand = [NSString stringWithFormat:@"%@^FO%d,%d^AQN,30,30^FD%@^FS",ZPLcommand,x_coordinate - 70,y_coordinate - 120,locationName];
                    break;
                default:
                    break;
            }
            ZPLcommand = [NSString stringWithFormat:@"%@^XZ",ZPLcommand];
            printData = dic;
            
            NSError *error = nil;
            NSData *data = [ZPLcommand dataUsingEncoding:NSUTF8StringEncoding];
            [connection write:data error:&error];
            
            if(error == nil){
                if(statusMod){
                    [delegate printRequest:@"ING" completeDicData:(NSDictionary *)printData];
                }
            }else{
                [delegate printRequest:@"ERROR" completeDicData:(NSDictionary *)printData];
                break;
            }
        }
    }
     [delegate printRequest:@"END" completeDicData:(NSDictionary *)nil];
}

-(void)printSettingValue:(int)type{
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docRootPath = [docPath objectAtIndex:0];
    NSString *filePath = [docRootPath stringByAppendingFormat:@"/setupInfo.plist"];
    NSDictionary *stringDic = [[[NSDictionary alloc] initWithContentsOfFile:filePath] objectForKey:[NSString stringWithFormat:@"%d",type]];
    
    x_coordinate = [[stringDic objectForKey:@"x"] intValue];
    y_coordinate = [[stringDic objectForKey:@"y"] intValue];
    darkness = [[stringDic objectForKey:@"sd"] intValue];
    
    if(![[stringDic objectForKey:@"xu"] isEqualToString:@"0"]){
        x_coordinate = [[stringDic objectForKey:@"xu"] intValue];
    }
    
    if(![[stringDic objectForKey:@"yu"] isEqualToString:@"0"]){
        y_coordinate = [[stringDic objectForKey:@"yu"] intValue];
    }
}

-(void)printSensor{
    [self openZebraPrinter];
    
    NSString *ZPLcommand = @"~JC";
    ZPLcommand = [NSString stringWithFormat:@"%@^XA^MF^XZ",ZPLcommand];
    NSData *data = [NSData dataWithBytes:[ZPLcommand UTF8String] length:[ZPLcommand length]];
    [connection write:data error:nil];
}

-(void)openZebraPrinter{
    NSString *address = [self localIPAddress];
    NSLog(@"address :: %@",address);
    if(![address isEqualToString:@""]){
        NSString *ssid = [self getSsid];
        NSLog(@"ssid :: %@",ssid);
        if([ssid rangeOfString:@"KT_BAR_PRT"].length > 0 || [ssid rangeOfString:@"ZD500"].length > 0){
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"프린터 연결에\n\r실패 했습니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"프린터 연결에\n\r실패 했습니다." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSArray *docPath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docRootPath = [docPath objectAtIndex:0];
    NSString *filePath = [docRootPath stringByAppendingFormat:@"/setupInfo.plist"];
    NSDictionary *stringDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    if(stringDic){
        connection = [[TcpPrinterConnection alloc] initWithAddress:[stringDic objectForKey:@"IP"] andWithPort:[[stringDic objectForKey:@"PORT"] intValue]];
        
        NSError *error = nil;
        
        if([connection open]){
            printer = [ZebraPrinterFactory getInstance:connection error:&error];
            if(error != nil) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"프린터 상태를\n\r확인 하세요." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"오류" message:@"프린터 정보를\n\r설정해 주세요." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)closeZebraPrinter{
    if([connection open]){
        [connection close];
    }
}


- (NSString *)getSsid{
    CFArrayRef cfArray = CNCopySupportedInterfaces();
    CFDictionaryRef cfDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(cfArray, 0));
    NSDictionary *dic = (__bridge NSDictionary*)cfDict;
    return [dic objectForKey:@"SSID"];
}

- (NSString *)localIPAddress{
    BOOL			success;
    struct ifaddrs * addrs	= NULL;
    const struct	ifaddrs * cursor;
    NSString		*address	= @"";
    
    success = (getifaddrs(&addrs) == 0);
    if (success){
        cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0){
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"]){
                    address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return address;
    
}





@end

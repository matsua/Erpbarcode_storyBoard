//
//  BarcodePrintController.h
//  erpbarcode
//
//  Created by matsua on 2015. 9. 8..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZebraPrinter.h"
#import "ZebraPrinterConnection.h"

@protocol IPrintRequest <NSObject>
- (void)printRequest:(NSString*)kind completeDicData:(NSDictionary *)completeDicData;
@end

@interface BarcodePrintController : NSObject

@property(strong, nonatomic) id <IPrintRequest> delegate;

-(void) makeBarcodeAndPrint:(int)type sendDataList:(NSMutableArray*) sendDataList statusMod:(BOOL)statusMod;
-(void)printSensor;

@end

//
//  BarcodeEncriptController.h
//  erpbarcode
//
//  Created by matsua on 2015. 9. 18..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeEncriptController : NSObject

-(NSString*)encript:(NSString *)barcode;
-(NSString*)decript:(NSString *)barcode;

@end

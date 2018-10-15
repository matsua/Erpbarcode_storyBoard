//
//  BarcodeEncriptController.m
//  erpbarcode
//
//  Created by matsua on 2015. 9. 18..
//  Copyright (c) 2015년 ktds. All rights reserved.
//

#import "BarcodeEncriptController.h"

@interface BarcodeEncriptController ()

@end

@implementation BarcodeEncriptController


-(NSString*)encript:(NSString *)barcode{
    NSString* encriptBarcode = [NSString EncryptBarcode:[barcode uppercaseString]];
    return encriptBarcode;
}

@end

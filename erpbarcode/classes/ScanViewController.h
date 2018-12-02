//
//  ScanViewController.h
//  erpbarcode
//
//  Created by Barcode on 02/12/2018.
//  Copyright © 2018 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@protocol IScanBarcode <NSObject>
- (void)setScanBarcode:(NSString*)barcode withResult:(BOOL)result;
@end

@interface ScanViewController : CommonViewController

@property (strong, nonatomic) id<IScanBarcode> delegate;

@end

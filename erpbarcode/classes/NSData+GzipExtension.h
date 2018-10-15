//
//  NSData+GzipExtension.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 1..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GzipExtension)
// gzip compression utilities
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;

@end

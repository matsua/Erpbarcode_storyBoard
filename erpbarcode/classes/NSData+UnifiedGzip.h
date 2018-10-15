//
//  NSData+UnifiedGzip.h
//  erpbarcode
//
//  Created by Seoul Jung on 13. 8. 13..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (UnifiedGzip)
// gzip compression utilities
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;
@end

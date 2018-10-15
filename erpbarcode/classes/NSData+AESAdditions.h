//
//  NSData+AESAdditions.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AESAdditions)
- (NSData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)vector;
- (NSData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)vector;
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
+ (NSData *) md5:(NSString *) stringToHash;
@end

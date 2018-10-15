//
//  NSData+AESAdditions.m
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 26..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import "NSData+AESAdditions.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "zlib.h"

@implementation NSData (AESAdditions)

- (NSData*)AES128EncryptWithKey:(NSString*)key iv:(NSString*)vector {
    // 'key' should be 16 bytes for AES128, will be null-padded otherwise
    
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    char vectorPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(vectorPtr, sizeof(vectorPtr)); // fill with zeroes (for padding)
    
    
//    NSData* result = [NSData md5:key];

//    NSString* datakey = [[key dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//    NSString* datavector = [[vector dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];

//    NSString* basekey = [key base64EncodedString];
//    NSString* basevector = [vector base64EncodedString];
//    
//    NSLog(@"datakey :%@",basekey);
//    NSLog(@"datavector :%@",basevector);

    
    NSString* md5key = [[key md5] substringToIndex:16];
    NSString* md5vector = [[vector md5] substringToIndex:16];
    
//    NSString* md5key2 = [NSData md5:key];
//    NSString* md5vector2 = [NSData md5:vector];

    
//    NSString* basemd5key =   [md5key base64EncodedString];
//    NSString* basemd5vector = [md5vector base64EncodedString];
//    
//    NSLog(@"basemd5key :%@",basemd5key);
//    NSLog(@"basemd5vector :%@",basemd5vector);

//    NSString* emd5key = [[key md5]substringToIndex:16];
//    NSString* emd5vector = [[vector md5] substringToIndex:16];
    NSLog(@"key :%@",md5key);
    NSLog(@"vector :%@",md5vector);

    // fetch key data
//    [md5key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    [md5vector getCString:vectorPtr maxLength:sizeof(vectorPtr) encoding:NSUTF8StringEncoding];
    
    NSData* keyData = [md5key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* vectorData = [md5vector dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSLog(@"key :%s\n",keyPtr);
//    NSLog(@"vector :%s\n",vectorPtr);
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    //kCCOptionECBMode + kCCOptionPKCS7Padding
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyData.bytes, kCCKeySizeAES128,
                                          vectorData.bytes /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSLog(@"encrpt buffer %s\n",buffer);
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}


- (NSData*)AES128DecryptWithKey:(NSString*)key iv:(NSString*)vector{
    // 'key' should be 16 bytes for AES128, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    char vectorPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(vectorPtr, sizeof(vectorPtr)); // fill with zeroes (for padding)
    
    
//    NSString* md5key = [key md5];
//    NSString* md5vector = [vector md5];
    
    NSString* md5key = [[key md5] substringToIndex:16];
    NSString* md5vector = [[vector md5] substringToIndex:16];
    NSLog(@"key :%@",md5key);
    NSLog(@"vector :%@",md5vector);


//
//    strcpy(vectorPtr, "kt_erp_common_iv");
    // fetch key data
//    [md5key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    [md5vector getCString:vectorPtr maxLength:sizeof(vectorPtr) encoding:NSUTF8StringEncoding];
//    NSData* md5Data = [NSData md5:[vectorPtr];
    
//    uint8_t iv[kCCBlockSizeAES128];
    

//    NSLog(@"key :%s\n",keyPtr);
//    NSLog(@"vector :%s\n",vectorPtr);

    NSData* keyData = [md5key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* vectorData = [md5vector dataUsingEncoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    //kCCOptionECBMode + kCCOptionPKCS7Padding
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyData.bytes, kCCKeySizeAES128,
                                          vectorData.bytes /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSLog(@"decrpt buffer %s\n",buffer);
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES256EncryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData*)AES256DecryptWithKey:(NSString*)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

/*
- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData{
    
    NSData* secretKey = [Chiper md5:cipherKey];
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    uint8_t iv[kCCBlockSizeAES128];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    status = CCCryptorCreate(encryptOrDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                             [secretKey bytes], kCCKeySizeAES128, iv, &cryptor);
    
    if (status != kCCSuccess) {
        return nil;
    }
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[inputData length], true);
    
    void * buf = malloc(bufsize * sizeof(uint8_t));
    memset(buf, 0x0, bufsize);
    
    size_t bufused = 0;
    size_t bytesTotal = 0;
    
    status = CCCryptorUpdate(cryptor, [inputData bytes], (size_t)[inputData length],
                             buf, bufsize, &bufused);
    
    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    bytesTotal += bufused;
    
    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    
    if (status != kCCSuccess) {
        free(buf);
        CCCryptorRelease(cryptor);
        return nil;
    }
    
    bytesTotal += bufused;
    
    CCCryptorRelease(cryptor);
    
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}
*/

+ (NSData *) md5:(NSString *) stringToHash {
    
    const char *src = [stringToHash UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (int)strlen(src), result);
    
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}


@end

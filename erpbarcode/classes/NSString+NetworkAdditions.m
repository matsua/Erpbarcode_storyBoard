//
//  NSString+NetworkAdditions.m
//  
//

#import "NSString+NetworkAdditions.h"
#import "NSData+Base64.h"
#import "NSData+AESAdditions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (NetworkAdditions)

- (BOOL) isAlphaNumeric
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

- (BOOL) isBarcodeChar
{
    NSCharacterSet *excludeCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ+"] invertedSet];        
    return ([self rangeOfCharacterFromSet:excludeCharacterset].location == NSNotFound) ? YES : NO;
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];      
}

+ (NSString*) uniqueString
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                        (__bridge CFStringRef) self, 
                                                                        nil,
                                                                        CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "), 
                                                                        kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];    

    if(!encodedString)
        encodedString = @"";    
    
    return encodedString;
}

- (NSString*) urlDecodedString {

    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
                                                                                          (__bridge CFStringRef) self, 
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];    
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}

- (NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}


- (NSString *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)vector{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES128EncryptWithKey:key iv:vector];
    NSString *encryptedString = [encryptedData base64EncodedString];
    return encryptedString;
}

- (NSString *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)vector{
    NSData *decryptedData = [NSData dataFromBase64String:self];
    NSData *plainData = [decryptedData AES128DecryptWithKey:key iv:vector];
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return plainString;
}

+ (NSString *)HanToEngBarcode:(NSString*)value
{
    NSString* result = nil;
    NSDictionary* convertDic = [Util udObjectForKey:MAP_QWERTY];
    
    result = [convertDic objectForKey:value];
    //NSLog(@"convert [%@]->[%@]",value,result);
    if (result)
        return result;
    else
        return value;
    
}

+ (NSString *)DecryptBarcode:(NSString*)value
{
    NSDictionary* decryptDic = [Util udObjectForKey:MAP_DECRPT];
    if ([decryptDic count] == 0){
        NSLog(@"MAP_DECRPT not exist!");
        return nil;
    }
   
    NSLog(@"source barcode[%@]",value);
    [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![value hasPrefix:@"+"] && ![[value uppercaseString] hasPrefix:@"K9"]) return value;
     
    NSMutableString* decryptResult  = [NSMutableString string];
    
    if ([value hasPrefix:@"+"])
        value = [value substringFromIndex:1];
    
    for (int i = 0 ; i < [value length];i++)
    {
        NSString* strCompare = [NSString stringWithFormat:@"%C",[value characterAtIndex:i]];
  
        NSString* result = [decryptDic objectForKey:strCompare];
        //NSLog(@"result[%@]",result);
        if (result.length)
            [decryptResult appendString:result];
        else
            [decryptResult appendString:strCompare];

    }
    //add newline char
    //[decryptResult appendString:@"\n"];
    NSLog(@"decrypt Result[%@]",decryptResult);
    return decryptResult;
}

+ (NSString *)EncryptBarcode:(NSString*)value
{
    NSDictionary* encryptDic = [Util udObjectForKey:MAP_ENCRPT];
    if ([encryptDic count] == 0){
        NSLog(@"MAP_ENCRPT not exist!");
        return nil;
    }
    
    NSLog(@"source barcode[%@]",value);
    [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![value hasPrefix:@"+"] && ![[value uppercaseString] hasPrefix:@"K9"]) return value;
    
    NSMutableString* encryptResult  = [NSMutableString string];
    
    if ([value hasPrefix:@"+"])
        value = [value substringFromIndex:1];
    
    for (int i = 0 ; i < [value length];i++)
    {
        NSString* strCompare = [NSString stringWithFormat:@"%C",[value characterAtIndex:i]];
        
        NSString* result = [encryptDic objectForKey:strCompare];
        if (result.length)
            [encryptResult appendString:result];
        else
            [encryptResult appendString:strCompare];
        
    }
    NSLog(@"encrypt Result[%@]",encryptResult);
    return encryptResult;
}
@end

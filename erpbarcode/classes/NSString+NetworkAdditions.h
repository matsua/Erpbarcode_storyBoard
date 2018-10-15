//
//  NSString+NetworkAdditions.h
//  
//

@interface NSString (NetworkAdditions)
- (BOOL) isBarcodeChar;
- (BOOL) isAlphaNumeric;
- (NSString *) md5;
+ (NSString*) uniqueString;
- (NSString*) urlEncodedString;
- (NSString*) urlDecodedString;
- (NSString *)base64Encode:(NSString *)plainText;
- (NSString *)base64Decode:(NSString *)base64String;
- (NSString *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)vector;
- (NSString *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)vector;
+ (NSString *)DecryptBarcode:(NSString*)value;
+ (NSString *)EncryptBarcode:(NSString*)value;
+ (NSString *)HanToEngBarcode:(NSString*)value;
@end

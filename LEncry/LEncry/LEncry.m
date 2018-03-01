//
//  LEncry.m
//  LEncry
//
//  Created by ponted on 2018/3/1.
//  Copyright © 2018年 Shenzhen Blood Link Medical Technology Co., Ltd. All rights reserved.
//

#import "LEncry.h"
#import <CommonCrypto/CommonCrypto.h>
#import "DDRSAWrapper.h"

//初始密钥长度
size_t const kKeySize = kCCKeySizeAES128;

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH

@interface  LEncry()
{
    RSA *publicKeyRef;
    RSA *privateKeyRef;
}

@end

@implementation LEncry

+ (LEncry*) shareInstance
{
    LEncry *encry = [[LEncry alloc]init];
    
    return encry;
}


#pragma mark ============= AES加密和解密 ============

- (NSData *)encryptDataAES:(NSData *)contentData key:(NSString *)encryptkey
{
    NSString *kInitVector = encryptkey;
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kKeySize +1 ];
    memset(keyPtr, 0, sizeof(keyPtr));
    //bzero(keyPtr, sizeof(keyPtr));
    [encryptkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger diff = kKeySize - (dataLength % kKeySize);//要填充多少位
    
    NSUInteger newSize = 0;
    
    if (diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    
    memcpy(dataPtr, [contentData bytes], dataLength);
    
    for (NSUInteger i = 0; i<diff; i++)
    {
        dataPtr[i+dataLength] = 0x00;
    }
    
    
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,  // 系统默认使用 CBC, 单独使用kCCOptionPKCS7Padding 表示CBC 如果加入或者话 表示 ECB 至于其他的不太了解
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        // NSLog(@"length : %ld",[[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] length]);
        return [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
    }
    
    free(encryptedBytes);
    return nil;
    
}

//AES 加密
- (NSString *)encryptAES:(NSString *)content key:(NSString *)encryptkey
{
    NSString *kInitVector = encryptkey;
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kKeySize +1 ];
    memset(keyPtr, 0, sizeof(keyPtr));
    //bzero(keyPtr, sizeof(keyPtr));
    [encryptkey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger diff = kKeySize - (dataLength % kKeySize);//要填充多少位
    
    NSUInteger newSize = 0;
    
    if (diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    
    memcpy(dataPtr, [contentData bytes], dataLength);
    
    for (NSUInteger i = 0; i<diff; i++)
    {
        dataPtr[i+dataLength] = 0x00;
    }
    
    
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,  // 系统默认使用 CBC, 单独使用kCCOptionPKCS7Padding 表示CBC 如果加入或者话 表示 ECB 至于其他的不太了解
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        // NSLog(@"length : %ld",[[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] length]);
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:0];
    }
    
    free(encryptedBytes);
    return nil;
    
}

//AES解密
- (NSString *)decryptAES:(NSString *)content key:(NSString *)key {
    NSString *kInitVector = key;
    // 把 base64 String 转换成 Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    //    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    NSMutableString *str = [NSMutableString string];
    if (cryptStatus == kCCSuccess) {
        NSString *str1 =[[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
        [str setString:str1.length?str1:@""];
        NSString *str11 = [NSString stringWithFormat:@"%C",0x0000];
        return [str stringByReplacingOccurrencesOfString:str11 withString:@""];
    }
    free(decryptedBytes);
    return nil;
}


#pragma mark =================== RSA加密解密 ====================

//动态生成公私钥
- (NSArray *)generateRSAKeyPair:(int)keySize
{
    NSMutableArray  *array = [NSMutableArray array];
    if ([DDRSAWrapper generateRSAKeyPairWithKeySize:keySize publicKey:&publicKeyRef privateKey:&privateKeyRef]) {
        NSString *publicKeyPem = [DDRSAWrapper PEMFormatPublicKey:publicKeyRef];
        NSString *privateKeyPem = [DDRSAWrapper PEMFormatPrivateKey:privateKeyRef];
        NSString *publicKeyBase64 = [DDRSAWrapper base64EncodedFromPEMFormat:publicKeyPem];
        NSString *privateKeyBase64 = [DDRSAWrapper base64EncodedFromPEMFormat:privateKeyPem];
        
        if (publicKeyBase64.length && privateKeyBase64 )
        {
            NSMutableString *publicStr = [NSMutableString stringWithString:publicKeyBase64];
            [array addObject:[publicStr stringByReplacingOccurrencesOfString:@"\n" withString:@""]];//添加公钥
            NSMutableString *privateStr = [NSMutableString stringWithString:privateKeyBase64];
            [array addObject:[privateStr stringByReplacingOccurrencesOfString:@"\n" withString:@""]];//添加私钥
        }
        NSLog(@"%@\n%@",publicKeyPem,privateKeyPem);
        
    }
    return array;
}


//RSA公钥加密
-(NSString *)encryRSA:(NSString *)str publicKeyBase64:(NSString *)publicKey
{
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipherData = [DDRSAWrapper encryptWithPublicKey:[DDRSAWrapper RSAPublicKeyFromBase64:publicKey] plainData:plainData];
    NSString * cipherString = [cipherData base64EncodedStringWithOptions:0];
    return cipherString;
}


//RSA公钥解密
- (NSString *)decryRSAPublic:(NSString *)str publicKeyBase64:(NSString *)publicKey
{
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipherData = [DDRSAWrapper decryptWithPublicKey:[DDRSAWrapper RSAPublicKeyFromBase64:publicKey] cipherData:plainData];
    NSString * cipherString = [cipherData base64EncodedStringWithOptions:0];
    return cipherString;
}


//RSA私钥加密
- (NSString *)encryRSAPrivate:(NSString *)str privateKeyBase64:(NSString *)privateKey
{
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *cipherData = [DDRSAWrapper encryptWithPrivateRSA:[DDRSAWrapper RSAPrivateKeyFromBase64:privateKey] plainData:plainData];
    NSString * cipherString = [cipherData base64EncodedStringWithOptions:0];
    return cipherString;
}

//RSA私钥解密
- (NSString *)decryRSA:(NSString *)str privateKeyBase64:(NSString *)privateKey;
{
    NSData *cipherData1 = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *plainData1 = [DDRSAWrapper decryptWithPrivateKey:[DDRSAWrapper RSAPrivateKeyFromBase64:privateKey] cipherData:cipherData1];
    NSString *outputPlainString = [[NSString alloc] initWithData:plainData1 encoding:NSUTF8StringEncoding];
    return outputPlainString;
}

#pragma mark ======== SHA 算法 ================

//hash算法 获取某些数据的hash值
- (NSString *) sha1:(NSString *)content
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


#pragma mark --- RSA私钥SHA1签名 =================

//RSA 私钥签名
- (NSString *)sha1RSa:(NSString *)content privateKey:(NSString *)key
{
    return [DDRSAWrapper signWithkey:content Privatekey:key];
}


//RSA 公钥验签
- (BOOL)verifyString:(NSString *)string  withSign:(NSString *)signString publicKey:(NSString *)key
{
    return [DDRSAWrapper verifyString:string withSign:signString publicKey:key];
}

@end

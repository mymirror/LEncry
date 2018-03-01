//
//  LEncry.h
//  LEncry
//
//  Created by ponted on 2018/3/1.
//  Copyright © 2018年 Shenzhen Blood Link Medical Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEncry : NSObject

/**
当前类的单例

@return 当前类的对象
*/
+ (LEncry*) shareInstance;


- (NSData *)encryptDataAES:(NSData *)contentData key:(NSString *)encryptkey;

/**
 AES加密
 
 @param content     要加密的数据
 @param encryptkey  加密的KEY
 @return            加密后的数据
 */
- (NSString *)encryptAES:(NSString *)content key:(NSString *)encryptkey;



/**
 AES 解密
 
 @param content     要解密的数据
 @param key         解密的KEY
 @return            解密后的数据
 */
- (NSString *)decryptAES:(NSString *)content key:(NSString *)key;



/**
 动态获取RSA公私钥
 
 @param keySize     生成公私钥匙支持的位数 目前只有3种 512 1024 2048
 @return            数组: 包含公私钥(第一个是公钥，第二个是私钥)
 @备注: 动态获取RSA钥匙，有的时候获取钥匙为空或者只能获取到其中一个，中间必须用一个循环来获取公私钥  例如下:
 NSArray *arr = [[pontedEncry shareInstance] generateRSAKeyPair:1024];
 
 @autoreleasepool
 {
 while (![arr count])
 {
 arr = [[pontedEncry shareInstance] generateRSAKeyPair:1024];
 
 if ([arr count])
 {
 
 break;
 }
 }
 }
 */
- (NSArray *)generateRSAKeyPair:(int)keySize;



/**
 RSA公钥加密
 
 @param str         要加密的数据
 @param publicKey   RSA公钥
 @return            RSA加密后的数据
 */
-(NSString *)encryRSA:(NSString *)str publicKeyBase64:(NSString *)publicKey;


/**
 RSA公钥解密
 
 @param str         要解密的数据
 @param publicKey   RSA公钥
 @return            RSA解密后的数据
 */
- (NSString *)decryRSAPublic:(NSString *)str publicKeyBase64:(NSString *)publicKey;



/**
 RSA 私钥加密
 
 @param str         要加密的数据
 @param privateKey  RSA私钥
 @return            RSA私钥加密后的数据
 */
- (NSString *)encryRSAPrivate:(NSString *)str privateKeyBase64:(NSString *)privateKey;


/**
 RSA私钥解密
 
 @param str         要解密的数据
 @param privateKey  RSA公钥对应的私钥
 @return            RSA解密后的数据
 */
- (NSString *)decryRSA:(NSString *)str privateKeyBase64:(NSString *)privateKey;




/**
 SHA1 加密
 
 @param content     需要处理的数据
 @return            处理过后的数据
 */
- (NSString *)sha1:(NSString *)content;

- (NSString *)MD5:(NSString *)mdStr;


/**
 SHA1 RSA私钥签名
 
 @param content     要签名的数据
 @param key         签名的私钥
 @return            签名后的数据
 */
- (NSString *)sha1RSa:(NSString *)content privateKey:(NSString *)key;




/**
 验证私钥签名
 
 @param string      签名前的数据
 @param signString  签名后的数据
 @param key         签名私钥对应的公钥
 @return            1 验证成功 0 时报
 */
- (BOOL)verifyString:(NSString *)string  withSign:(NSString *)signString publicKey:(NSString *)key;

@end

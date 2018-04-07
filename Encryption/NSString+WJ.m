//
//  NSString+WJ.m
//  Encryption
//
//  Created by WJ on 2018/4/7.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "NSString+WJ.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>   // MD5 加密时使用
#import "JKEncrypt.h"      // 3des 加密时使用
#import "RSA.h"     // rsa 加密时使用

#define PUBLIC_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDf2jkCy0wrV0LHHsU7R5lZNV0njue7+7ul2HHS4KQeLZsmS/vEphUB9afpfmU2glvqfes9mABx+mioCYvCK7DIxiFAZL54dGy+Ujwiibrv7dzBGXo3u1aS3KxQ/aK7I1ny4Ul5CujruokTbATeleBsJFPGLXRbGP29DLfN+Xss0wIDAQAB"
#define PRIVATE_KEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAN/aOQLLTCtXQscexTtHmVk1XSeO57v7u6XYcdLgpB4tmyZL+8SmFQH1p+l+ZTaCW+p96z2YAHH6aKgJi8IrsMjGIUBkvnh0bL5SPCKJuu/t3MEZeje7VpLcrFD9orsjWfLhSXkK6Ou6iRNsBN6V4GwkU8YtdFsY/b0Mt835eyzTAgMBAAECgYAbmFw00vj10tEBmPJ5Z08pJyHvsXcxvkuYm0EU3Op+aeLZar6DtHGchzsG1rUFbjaEhrdMJYPQiS0DogGfkyE8s9hEiAFkXWr0LK+1nQNnFc6S3+Anqm1KQ5RhKN79dQc1D7mCIeG+bfU/eNpY+IdBatqyn5IV/FNOVHr4pumm8QJBAPhiXyr8ZOo3bi6DVowskhPp0LLjIGNcrgCHjegPIn1FNifA4wAn+NW5YfvO2ttuPRWejLt6blYQxBh5uLKuzSkCQQDmt0tunVbZancYKOVxqDhb4HnAAp65Yje5zlwPxees/9pCXz0t1dIbaxrLcZ+h+fb3w0dAldbiYbf4eqIIxu2bAkEAot7uhKNoEOU0DK/2qof3abNiNEsWy9DUEGjStp5mATrHHh4vO8T6ODsNcy7a+BQ7XdfPdIf9ndX0oBAA+roAsQJAD8ytlb2gnPL1hOoIDGiAs4oDzGphhEB9oHPJSis7WlWLFNCA2Aq0gLws8ZGuZOFBUGZHEt0wAgC/IH0Fa6Rz0QJAL/oc5wi36EhO6gFd8QLbFZmVN19UoiC10jiDIiW6zi6SribGMs7JrC00dJPdaxp3ggtZU24GlQqEmUXqTDvUiA=="

// 没有转换的私钥(不能用)
//#define PRIVATE_KEY @"MIICXAIBAAKBgQDf2jkCy0wrV0LHHsU7R5lZNV0njue7+7ul2HHS4KQeLZsmS/vEphUB9afpfmU2glvqfes9mABx+mioCYvCK7DIxiFAZL54dGy+Ujwiibrv7dzBGXo3u1aS3KxQ/aK7I1ny4Ul5CujruokTbATeleBsJFPGLXRbGP29DLfN+Xss0wIDAQABAoGAG5hcNNL49dLRAZjyeWdPKSch77F3Mb5LmJtBFNzqfmni2Wq+g7RxnIc7Bta1BW42hIa3TCWD0IktA6IBn5MhPLPYRIgBZF1q9CyvtZ0DZxXOkt/gJ6ptSkOUYSje/XUHNQ+5giHhvm31P3jaWPiHQWrasp+SFfxTTlR6+KbppvECQQD4Yl8q/GTqN24ug1aMLJIT6dCy4yBjXK4Ah43oDyJ9RTYnwOMAJ/jVuWH7ztrbbj0Vnoy7em5WEMQYebiyrs0pAkEA5rdLbp1W2Wp3GCjlcag4W+B5wAKeuWI3uc5cD8XnrP/aQl89LdXSG2say3Gfofn298NHQJXW4mG3+HqiCMbtmwJBAKLe7oSjaBDlNAyv9qqH92mzYjRLFsvQ1BBo0raeZgE6xx4eLzvE+jg7DXMu2vgUO13Xz3SH/Z3V9KAQAPq6ALECQA/MrZW9oJzy9YTqCAxogLOKA8xqYYRAfaBzyUorO1pVixTQgNgKtIC8LPGRrmThQVBmRxLdMAIAvyB9BWukc9ECQC/6HOcIt+hITuoBXfEC2xWZlTdfVKIgtdI4gyIlus4ukq4mxjLOyawtNHST3Wsad4ILWVNuBpUKhJlF6kw71Ig="

// aes 加密的 key 换成自己的
static NSString *const AES_KEY = @"AES_KEY";
// aes 加密的 向量  换成自己的
static NSString *const AES_IV = @"AES_IV";

@implementation NSString (WJ)

#pragma mark - rsa 加密
// 生成私钥和公钥
// 新建ssh 文件夹 , 在终端中 进入到该文件夹下 cd + 文件路径
// 输入命令: openssl
// 输入生成私钥命令:  genrsa -out rsa_private_key.pem 1024
// 将私钥转成PKCS8的格式(必须执行): pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt
// 将终端输出的私钥复制, 保存, 用于加/解密
// 生成公钥:  rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
// 直接用文本打开公钥, 用于加/解密
// 既可以使用公钥加密, 也可以使用私钥加密, 但是 一定要配套使用

- (NSString *)enodeByRsa{
    // 使用公钥加密
    //    return [RSA encryptString:self publicKey:PUBLIC_KEY];
    // 使用私钥加密
    return [RSA encryptString:self privateKey:PRIVATE_KEY];
}

- (NSString *)dencodeByRsa{
    
    // 使用私钥解密
    //    return [RSA decryptString:self privateKey:PRIVATE_KEY];
    // 使用公钥解密
    return [RSA decryptString:self publicKey:PUBLIC_KEY];
}

#pragma mark - 3des 加密
// 使用时 将 JKEncrypt.m 中的秘钥 和 偏移量 换成 自己的
- (NSString *)encodeBy3des{
    JKEncrypt *jk = [[JKEncrypt alloc] init];
    return [jk doEncryptStr:self];;
}

#pragma mark - 3des 解密
- (NSString *)dencodeBy3des{
    JKEncrypt *jk = [[JKEncrypt alloc] init];
    return [jk doDecEncryptStr:self];;
}


#pragma mark - md5 加密
// 使用 md5 加密时, 经常使用加盐  技术
- (NSString *)encodeBymd5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

#pragma mark - base64 编码
- (NSString *)encodeByBase64{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}

#pragma mark - base64 解码
- (NSString *)dencodeByBase64{
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


- (NSString *)encodeByAES{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:AES_KEY
                                         iv:AES_IV];
    NSString *baseStr_GTM = [self encodeBase64Data:AESData];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return baseStr_GTM;
}

- (NSString *)dencodeByAES{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baseData_GTM = [self decodeBase64Data:data];
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData_GTM = [self AES128operation:kCCDecrypt
                                           data:baseData_GTM
                                            key:AES_KEY
                                             iv:AES_IV];
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:AES_KEY
                                         iv:AES_IV];
    
    NSString *decStr_GTM = [[NSString alloc] initWithData:AESData_GTM encoding:NSUTF8StringEncoding];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
    return decStr;
    
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    
    char keyPtr[kCCKeySizeAES128 + 1];  //kCCKeySizeAES128是加密位数 可以替换成256位的
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 设置加密参数
    //（根据需求选择什么加密位数128or256，PKCS7Padding补码方式之类的_(:з」∠)_，详细的看下面吧）
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}

// Base64 编码
- (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

// Base64解码
- (NSData*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    return data;
}


@end

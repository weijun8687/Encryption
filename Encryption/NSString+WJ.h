//
//  NSString+WJ.h
//  Encryption
//
//  Created by WJ on 2018/4/7.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WJ)

//  rsa 加密
- (NSString *)enodeByRsa;
// rsa 解密
- (NSString *)dencodeByRsa;

// 3des 加密
- (NSString *)encodeBy3des;
// 3des 解密
- (NSString *)dencodeBy3des;

// md5 加密
- (NSString *)encodeBymd5;
// md5 解密
- (NSString *)dencodeBymd5;

// base64 编码
- (NSString *)encodeByBase64;
// base64 解码
- (NSString *)dencodeByBase64;

// 通过 AES 加密
- (NSString *)encodeByAES;
// 通过 AES 解密
- (NSString *)dencodeByAES;


@end

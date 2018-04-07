//
//  NSString+WJ.h
//  Encryption
//
//  Created by WJ on 2018/4/7.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WJ)

// 通过 AES 加密
- (NSString *)encodeByAES;

// 通过 AES 解密
- (NSString *)dencodeByAES;


@end

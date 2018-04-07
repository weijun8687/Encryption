//
//  DetailVC.m
//  Encryption
//
//  Created by WJ on 2018/4/6.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "DetailVC.h"
#import <CommonCrypto/CommonDigest.h>   // MD5 加密时使用
#import "JKEncrypt.h"      // 3des 加密时使用
#import "RSA.h"     // rsa 加密时使用
#import "NSString+WJ.h"

#define PUBLIC_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDf2jkCy0wrV0LHHsU7R5lZNV0njue7+7ul2HHS4KQeLZsmS/vEphUB9afpfmU2glvqfes9mABx+mioCYvCK7DIxiFAZL54dGy+Ujwiibrv7dzBGXo3u1aS3KxQ/aK7I1ny4Ul5CujruokTbATeleBsJFPGLXRbGP29DLfN+Xss0wIDAQAB"
#define PRIVATE_KEY @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAN/aOQLLTCtXQscexTtHmVk1XSeO57v7u6XYcdLgpB4tmyZL+8SmFQH1p+l+ZTaCW+p96z2YAHH6aKgJi8IrsMjGIUBkvnh0bL5SPCKJuu/t3MEZeje7VpLcrFD9orsjWfLhSXkK6Ou6iRNsBN6V4GwkU8YtdFsY/b0Mt835eyzTAgMBAAECgYAbmFw00vj10tEBmPJ5Z08pJyHvsXcxvkuYm0EU3Op+aeLZar6DtHGchzsG1rUFbjaEhrdMJYPQiS0DogGfkyE8s9hEiAFkXWr0LK+1nQNnFc6S3+Anqm1KQ5RhKN79dQc1D7mCIeG+bfU/eNpY+IdBatqyn5IV/FNOVHr4pumm8QJBAPhiXyr8ZOo3bi6DVowskhPp0LLjIGNcrgCHjegPIn1FNifA4wAn+NW5YfvO2ttuPRWejLt6blYQxBh5uLKuzSkCQQDmt0tunVbZancYKOVxqDhb4HnAAp65Yje5zlwPxees/9pCXz0t1dIbaxrLcZ+h+fb3w0dAldbiYbf4eqIIxu2bAkEAot7uhKNoEOU0DK/2qof3abNiNEsWy9DUEGjStp5mATrHHh4vO8T6ODsNcy7a+BQ7XdfPdIf9ndX0oBAA+roAsQJAD8ytlb2gnPL1hOoIDGiAs4oDzGphhEB9oHPJSis7WlWLFNCA2Aq0gLws8ZGuZOFBUGZHEt0wAgC/IH0Fa6Rz0QJAL/oc5wi36EhO6gFd8QLbFZmVN19UoiC10jiDIiW6zi6SribGMs7JrC00dJPdaxp3ggtZU24GlQqEmUXqTDvUiA=="

// 没有转换的私钥(不能用)
//#define PRIVATE_KEY @"MIICXAIBAAKBgQDf2jkCy0wrV0LHHsU7R5lZNV0njue7+7ul2HHS4KQeLZsmS/vEphUB9afpfmU2glvqfes9mABx+mioCYvCK7DIxiFAZL54dGy+Ujwiibrv7dzBGXo3u1aS3KxQ/aK7I1ny4Ul5CujruokTbATeleBsJFPGLXRbGP29DLfN+Xss0wIDAQABAoGAG5hcNNL49dLRAZjyeWdPKSch77F3Mb5LmJtBFNzqfmni2Wq+g7RxnIc7Bta1BW42hIa3TCWD0IktA6IBn5MhPLPYRIgBZF1q9CyvtZ0DZxXOkt/gJ6ptSkOUYSje/XUHNQ+5giHhvm31P3jaWPiHQWrasp+SFfxTTlR6+KbppvECQQD4Yl8q/GTqN24ug1aMLJIT6dCy4yBjXK4Ah43oDyJ9RTYnwOMAJ/jVuWH7ztrbbj0Vnoy7em5WEMQYebiyrs0pAkEA5rdLbp1W2Wp3GCjlcag4W+B5wAKeuWI3uc5cD8XnrP/aQl89LdXSG2say3Gfofn298NHQJXW4mG3+HqiCMbtmwJBAKLe7oSjaBDlNAyv9qqH92mzYjRLFsvQ1BBo0raeZgE6xx4eLzvE+jg7DXMu2vgUO13Xz3SH/Z3V9KAQAPq6ALECQA/MrZW9oJzy9YTqCAxogLOKA8xqYYRAfaBzyUorO1pVixTQgNgKtIC8LPGRrmThQVBmRxLdMAIAvyB9BWukc9ECQC/6HOcIt+hITuoBXfEC2xWZlTdfVKIgtdI4gyIlus4ukq4mxjLOyawtNHST3Wsad4ILWVNuBpUKhJlF6kw71Ig="

@interface DetailVC ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnEncode;     // 加密
@property (nonatomic, strong) UIButton *btnDencode;  // 解密
@property (nonatomic, strong) UILabel *lbText;  // 加密后数据
@property (nonatomic, strong) UILabel *lbOrigin;    // 解密数据

@end

@implementation DetailVC

//  @[@"base64加密", @"md5加密", @"3des 加密", @"rsa 非对称加密", @"aes 对称加密"];
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self initSubviews];
}

// 加密
- (void)encode{
    
    if (self.textField.text.length < 1) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入要加密的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
    if (self.selectIndex == 0) {
        
        self.lbText.text = [self encodeByBase64:self.textField.text];
    } else if (self.selectIndex == 1){
        
        self.lbText.text = [self encodeBymd5:self.textField.text];
    } else if (self.selectIndex == 2){
        
        self.lbText.text = [self encodeBy3des:self.textField.text];
    } else if (self.selectIndex == 3){
        
        self.lbText.text = [self enodeByRsa:self.textField.text];
    }else if (self.selectIndex == 4){
        self.lbText.text = [self.textField.text encodeByAES];

    }
}

// 解密
- (void)dencode{
    
    if (self.lbText.text.length < 1) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先加密再解密" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
    if (self.selectIndex == 0) {
        
        self.lbOrigin.text = [self dencodeByBase64:self.lbText.text];
    } else if (self.selectIndex == 1){
        
         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"md5 加密的数据无法解密" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else if (self.selectIndex == 2){
        
        self.lbOrigin.text = [self dencodeBy3des:self.lbText.text];
    } else if (self.selectIndex == 3){
        
        self.lbOrigin.text = [self dencodeByRsa:self.lbText.text];
    }else if (self.selectIndex == 4){
        
         self.lbOrigin.text = [self.lbText.text dencodeByAES];
    }
}

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

- (NSString *)enodeByRsa:(NSString *)string{
    // 使用公钥加密
//    return [RSA encryptString:string publicKey:PUBLIC_KEY];
    // 使用私钥加密
    return [RSA encryptString:string privateKey:PRIVATE_KEY];
}

- (NSString *)dencodeByRsa:(NSString *)string{
    
    // 使用私钥解密
//    return [RSA decryptString:string privateKey:PRIVATE_KEY];
    // 使用公钥解密
    return [RSA decryptString:string publicKey:PUBLIC_KEY];
}

#pragma mark - 3des 加密
// 使用时 将 JKEncrypt.m 中的秘钥 和 偏移量 换成 自己的
- (NSString *)encodeBy3des:(NSString *)string{
    JKEncrypt *jk = [[JKEncrypt alloc] init];
    return [jk doEncryptStr:string];;
}

#pragma mark - 3des 解密
- (NSString *)dencodeBy3des:(NSString *)string{
    JKEncrypt *jk = [[JKEncrypt alloc] init];
    return [jk doDecEncryptStr:string];;
}


#pragma mark - md5 加密
// 使用 md5 加密时, 经常使用加盐  技术
- (NSString *)encodeBymd5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    return result;
}

#pragma mark - base64 编码
- (NSString *)encodeByBase64:(NSString *)string{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}

#pragma mark - base64 解码
- (NSString *)dencodeByBase64:(NSString *)base64String{
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


// 初始化子控件
- (void)initSubviews{
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 300, 21)];
    [self.view addSubview:self.textField];
    self.textField.placeholder = @"请输入需要加密的数据";
    self.textField.backgroundColor = [UIColor whiteColor];
    
    self.btnEncode = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnEncode.frame = CGRectMake(20, 110, 300, 30);
    [self.btnEncode setTitle:@"加密" forState:UIControlStateNormal];
    [self.view addSubview:self.btnEncode];
    [self.btnEncode addTarget:self action:@selector(encode) forControlEvents:UIControlEventTouchUpInside];
    
    self.lbText = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 300, 60)];
    [self.view addSubview:self.lbText];
    self.lbText.numberOfLines = 0;
    self.lbText.backgroundColor = [UIColor whiteColor];
    
    self.btnDencode = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDencode.frame = CGRectMake(20, 220, 300, 30);
    [self.btnDencode setTitle:@"解密" forState:UIControlStateNormal];
    [self.view addSubview:self.btnDencode];
    [self.btnDencode addTarget:self action:@selector(dencode) forControlEvents:UIControlEventTouchUpInside];
    
    self.lbOrigin = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 300, 40)];
    [self.view addSubview:self.lbOrigin];
    self.lbOrigin.numberOfLines = 0;
    self.lbOrigin.backgroundColor = [UIColor whiteColor];
}

@end

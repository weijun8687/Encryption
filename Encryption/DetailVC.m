//
//  DetailVC.m
//  Encryption
//
//  Created by WJ on 2018/4/6.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "DetailVC.h"
#import "NSString+WJ.h"

@interface DetailVC ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnEncode;     // 加密
@property (nonatomic, strong) UIButton *btnDencode;  // 解密
@property (nonatomic, strong) UILabel *lbText;  // 加密后数据
@property (nonatomic, strong) UILabel *lbOrigin;    // 解密数据

@end

@implementation DetailVC

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
        
        self.lbText.text = [self.textField.text encodeByBase64];
    } else if (self.selectIndex == 1){
        
        self.lbText.text = [self.textField.text encodeBymd5];
    } else if (self.selectIndex == 2){
        
        self.lbText.text = [self.textField.text encodeBy3des];
    } else if (self.selectIndex == 3){
        
        self.lbText.text = [self.textField.text enodeByRsa];
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
        
        self.lbOrigin.text = [self.lbText.text dencodeByBase64];
    } else if (self.selectIndex == 1){
        
         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"md5 加密的数据无法解密" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }else if (self.selectIndex == 2){
        
        self.lbOrigin.text = [self.lbText.text dencodeBy3des];
    } else if (self.selectIndex == 3){
        
        self.lbOrigin.text = [self.lbText.text dencodeByRsa];
    }else if (self.selectIndex == 4){
        
         self.lbOrigin.text = [self.lbText.text dencodeByAES];
    }
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

//
//  ViewController.m
//  Encryption
//
//  Created by WJ on 2018/4/6.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "ViewController.h"
#import "DetailVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *arrData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加密";
    
    self.arrData = @[@"base64加密", @"md5加密", @"3des 加密", @"rsa 非对称加密", @"aes 对称加密"];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.arrData[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%7 / 10.0) green:(arc4random()%7 / 10.0) blue:(arc4random()%7 / 10.0) alpha:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailVC *vc = [[DetailVC alloc ]init];
    vc.selectIndex = indexPath.row;
    vc.title = self.arrData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}




@end

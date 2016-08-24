//
//  VisitorViewController.m
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "VisitorViewController.h"
#import "UIImage+Extension.h"

@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)titleLabelText:(NSString *)texttitle
{
    //NavigationItem设置属性
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@",texttitle];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)setUI
{
    [self titleLabelText:@"访客申请"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, 40, 150, 150)];
    [imgView setImage:[UIImage imageNamed:@"knock"]];
    [self.view addSubview:imgView];
    
    self.mobile = [[UITextField alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 50)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    view.backgroundColor = [UIColor clearColor];
    self.mobile.leftView = view;
    self.mobile.leftViewMode = UITextFieldViewModeAlways;
    self.mobile.placeholder = @"请输入要拜访的业主手机号码";
    self.mobile.backgroundColor = [UIColor whiteColor];
    self.mobile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.mobile];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, SCREEN_WIDTH - 40, 50)];
    [btn setTitle:@"申请钥匙" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR_PRESSED] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(makePhoneCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)makePhoneCall
{
    //TODO 调用云通讯视频通话
}

@end

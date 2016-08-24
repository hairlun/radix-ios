//
//  LoginViewController.m
//  radix
//
//  Created by patrick on 16-8-16.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+Extension.h"
#import "AppDelegate.h"
#import "AppRequest.h"
#import "NetworkConstants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [self titleLabelText:@"业主登录"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, 40, 150, 35)];
    [imgView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:imgView];

    self.username = [[UITextField alloc] initWithFrame:CGRectMake(0, 115, SCREEN_WIDTH, 50)];
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 20, 20)];
    [userImg setImage:[UIImage imageNamed:@"user_icon"]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:userImg];
    self.username.leftView = view;
    self.username.leftViewMode = UITextFieldViewModeAlways;
    self.username.placeholder = @"请输入账号";
    self.username.backgroundColor = [UIColor whiteColor];
    self.username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.username];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(0, 166, SCREEN_WIDTH, 50)];
    UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 20, 20)];
    [pwdImg setImage:[UIImage imageNamed:@"password_icon"]];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 20)];
    view2.backgroundColor = [UIColor clearColor];
    [view2 addSubview:pwdImg];
    self.password.leftView = view2;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.username.placeholder = @"请输入密码";
    self.username.backgroundColor = [UIColor whiteColor];
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.secureTextEntry = YES;
    [self.view addSubview:self.password];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 236, SCREEN_WIDTH - 30, 50)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR_PRESSED] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)login
{
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:username, REQUEST_KEY_ACCOUNT, password, REQUEST_KEY_PWD, nil];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [AppRequest request:URL_LOGIN parameters:param completion:^(id result) {
        NSLog(result);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:result];
        if ([[dic objectForKey:RESPONSE_KEY_RETCODE] intValue] == 1) {
            NSDictionary *model = [NSDictionary dictionaryWithDictionary:[dic objectForKey:RESPONSE_KEY_MODEL]];
            myDelegate.userInfo.uid = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_ID]];
            myDelegate.userInfo.account = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_ACCOUNT]];
            myDelegate.userInfo.name = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_NAME]];
            myDelegate.userInfo.areaId = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_AREA_ID]];
            myDelegate.userInfo.areaName = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_AREA_NAME]];
            myDelegate.userInfo.mobile = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_MOBILE]];
            myDelegate.userInfo.home = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_HOME]];
            myDelegate.userInfo.token = [NSString stringWithFormat:@"%@", [model objectForKey:RESPONSE_KEY_TOKEN]];
        }
    } failed:^(id error) {
        NSLog(error);
    }];
}

@end

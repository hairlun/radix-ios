//
//  SettingsViewController.m
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIImage+Extension.h"
#import "AppDelegate.h"
#import "CacheUtils.h"
#import "LoginViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refresh];
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
    [self titleLabelText:@"个人设置"];
}

- (void)refresh
{
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.userInfo.name == nil || [myDelegate.userInfo.name isEqual:@""]) {
        // 未登录
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 50)];
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn1 setImage:[UIImage imageNamed:@"setting_icon02"] forState:UIControlStateNormal];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        [btn1 setTitle:@"意见反馈" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH, 50)];
        btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn2 setImage:[UIImage imageNamed:@"setting_icon05"] forState:UIControlStateNormal];
        [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        NSString *str;
        if ([CacheUtils getStringForKey:@"lockKey"] == nil || [[CacheUtils getStringForKey:@"lockKey"] isEqual:@""]) {
            str = @"手势密码(已关闭)";
        } else {
            str = @"手势密码(已开启)";
        }
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:str];
        [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(4, 5)];
        [astr addAttribute:NSForegroundColorAttributeName value:GRAY_TEXT_COLOR range:NSMakeRange(4, 5)];
        [btn2 setAttributedTitle:astr forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn2];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, 50)];
        btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn3 setImage:[UIImage imageNamed:@"setting_icon04"] forState:UIControlStateNormal];
        [btn3 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        if (myDelegate.selectedCommunity != nil) {
            str = [NSString stringWithFormat:@"当前小区(%@)", myDelegate.selectedCommunity.name];
            astr = [[NSMutableAttributedString alloc] initWithString:str];
            [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(4, str.length - 4)];
            [astr addAttribute:NSForegroundColorAttributeName value:GRAY_TEXT_COLOR range:NSMakeRange(4, str.length - 4)];
            [btn3 setAttributedTitle:astr forState:UIControlStateNormal];
        } else {
            str = @"当前小区";
            [btn3 setTitle:str forState:UIControlStateNormal];
        }
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn3];
        
        UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 182, SCREEN_WIDTH - 30, 50)];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR_PRESSED] forState:UIControlStateHighlighted];
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginBtn];
        
    } else {
        // 已登录
        UIButton *userBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 80)];
        [userBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        [imgView setImage:[UIImage imageNamed:@"uesr_picture_default"]];
        [userBtn addSubview:imgView];
        [userBtn bringSubviewToFront:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 180, 20)];
        label.text = myDelegate.userInfo.name;
        [userBtn addSubview:label];
        [userBtn bringSubviewToFront:label];
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 25, 30, 30)];
        [arrow setImage:[UIImage imageNamed:@"arrow_right"]];
        [userBtn addSubview:arrow];
        [userBtn bringSubviewToFront:arrow];
        [self.view addSubview:userBtn];
        
        UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
        btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn0 setImage:[UIImage imageNamed:@"setting_icon01"] forState:UIControlStateNormal];
        [btn0 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        [btn0 setTitle:@"用户授权" forState:UIControlStateNormal];
        [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn0 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn0 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn0 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn0];
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 151, SCREEN_WIDTH, 50)];
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn1 setImage:[UIImage imageNamed:@"setting_icon02"] forState:UIControlStateNormal];
        [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        [btn1 setTitle:@"意见反馈" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn1];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 202, SCREEN_WIDTH, 50)];
        btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn2 setImage:[UIImage imageNamed:@"setting_icon05"] forState:UIControlStateNormal];
        [btn2 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        NSString *str;
        if ([CacheUtils getStringForKey:@"lockKey"] == nil || [[CacheUtils getStringForKey:@"lockKey"] isEqual:@""]) {
            str = @"手势密码(已关闭)";
        } else {
            str = @"手势密码(已开启)";
        }
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:str];
        [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(4, 5)];
        [astr addAttribute:NSForegroundColorAttributeName value:GRAY_TEXT_COLOR range:NSMakeRange(4, 5)];
        [btn2 setAttributedTitle:astr forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn2 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn2];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 253, SCREEN_WIDTH, 50)];
        btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn3 setImage:[UIImage imageNamed:@"setting_icon04"] forState:UIControlStateNormal];
        [btn3 setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 12)];
        if (myDelegate.selectedCommunity != nil) {
            str = [NSString stringWithFormat:@"当前小区(%@)", myDelegate.selectedCommunity.name];
            astr = [[NSMutableAttributedString alloc] initWithString:str];
            [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(4, str.length - 4)];
            [astr addAttribute:NSForegroundColorAttributeName value:GRAY_TEXT_COLOR range:NSMakeRange(4, str.length - 4)];
            [btn3 setAttributedTitle:astr forState:UIControlStateNormal];
        } else {
            str = @"当前小区";
            [btn3 setTitle:str forState:UIControlStateNormal];
        }
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 47, 0, 0)];
        [btn3 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[UIImage imageWithColor:BG_BTN_PRESSED_COLOR] forState:UIControlStateHighlighted];
        [self.view addSubview:btn3];
        
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 323, SCREEN_WIDTH - 30, 50)];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR] forState:UIControlStateNormal];
        [logoutBtn setBackgroundImage:[UIImage imageWithColor:BASE_CORLOR_PRESSED] forState:UIControlStateHighlighted];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logoutBtn];
    }
    
}

- (void)login
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)logout
{
    
}

@end

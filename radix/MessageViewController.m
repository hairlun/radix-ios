//
//  MessageViewController.m
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController

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
    [self titleLabelText:@"最新消息"];
}

@end

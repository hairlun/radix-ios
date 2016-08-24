//
//  BaseNavigationController.m
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS7_LATER) {
        
        self.navigationBar.translucent = NO;
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
        self.navigationBar.translucent = NO;
        [self.navigationBar setBarTintColor:BASE_CORLOR];
        
    } else {
        self.navigationBar.tintColor = BASE_CORLOR;
    }
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    //    if ( [SettingService isDeviceLock] ) {
    //
    //        //countCheck = 1;
    //    }
    if (viewController.navigationItem.leftBarButtonItem == nil && viewController.navigationController.viewControllers.count > 1)
    {
        viewController.navigationItem.leftBarButtonItems = [self createBackButton];
    }
}

- (NSArray *)createBackButton
{
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = IS_IOS7_LATER ? -10 : 0;
    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popself:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return @[spaceItem, someBarButtonItem];
}

- (void)popself:(id)sender
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(popViewControllerAnimated:) object:[NSNumber numberWithBool:YES]];
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  UnlockViewController.m
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "UnlockViewController.h"
#import "MBleService.h"
#import "AppDelegate.h"
#import "AppRequest.h"
#import "CacheUtils.h"
#import "NetworkConstants.h"

#define UUID_SERVICE @"0003cdd0-0000-1000-8000-00805f9b0131"

@interface UnlockViewController ()<cbDiscoveryManagerDelegate, cbCharacteristicManagerDelegate> {
    BOOL isBluetoothON;
    BOOL notifyEnable;
    NSString *csn;
    
    void(^characteristicWriteCompletionHandler)(BOOL success,NSError *error);
}

@end

@implementation UnlockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[CBManager sharedManager] disconnectPeripheral:[[CBManager sharedManager] myPeripheral]];
    [[CBManager sharedManager] setCbDiscoveryDelegate:self];
    [[CBManager sharedManager] setCbCharacteristicDelegate:self];
    
    // Start scanning for devices
    [[CBManager sharedManager] startScanning];
    [self performSelector:@selector(stopScanning) withObject:nil afterDelay:2.0f];
    if (![self.gifView isGIFPlaying]) {
        [self.gifView startGIF];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if (notifyEnable) {
        [[[CBManager sharedManager] myPeripheral] setNotifyValue:NO forCharacteristic:self.notifyCharacteristic];
    }
    if ([self.gifView isGIFPlaying]) {
        [self.gifView stopGIF];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopScanning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopScanning
{
    [[CBManager sharedManager] stopScanning];
}

/**
 *This method invoke after a new peripheral found.
 */
-(void)discoveryDidRefresh
{
    
}

#pragma mark - BlueTooth Turned Off Delegate

/*!
 *  @method bluetoothStateUpdatedToState:
 *
 *  @discussion Method to be called when state of Bluetooth changes
 *
 */

-(void)bluetoothStateUpdatedToState:(BOOL)state
{
    isBluetoothON = state;
}

- (void)setUI
{
    // 标题栏
    self.title = @"";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"choose_key_btn"] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:BASE_CORLOR];
    [rightButton addTarget:self action:@selector(selectKey) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarButton:@[rightButton]];
    
    // 播放gif
    [self showGifImage];
    
    //TODO 设置默认csn
}

- (void)showGifImage
{
    //读取gif图片数据
    NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"shake_shake" ofType:@"gif"]];
    self.gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, (SCREEN_HEIGHT - 200 - 64 - 50) / 2, 200, 200)];
    self.gifView.backgroundColor = [UIColor clearColor];
    self.gifView.gifData = gifData;
    [self.view addSubview:self.gifView];
    // notice: before start, content is nil. You can set image for yourself
    [self.gifView startGIF];
    self.gifView.userInteractionEnabled = NO;
}

- (void)setRightBarButton:(NSArray *)buttonArr
{
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = IS_IOS7_LATER ? -12 : 0;
    NSMutableArray *rightArray = [NSMutableArray array];
    if( spaceItem.width != 0 ){
        [rightArray addObject:spaceItem];
    }
    for ( NSUInteger i = 0 ; i<buttonArr.count ; i++ ) {
        UIButton *tempButton = (UIButton *)[buttonArr objectAtIndex:i];
        UIBarButtonItem *tempBarBt = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
        [rightArray addObject:tempBarBt];
    }
    [self.navigationItem setRightBarButtonItems:rightArray];
}

- (void)loadData
{
    // 若没有选小区，则获取小区列表，让用户选小区
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.selectedCommunity == nil) {
        [self getCommunityList];
    }
    if (myDelegate.selectedLock == nil) {
        [self getLockList];
    }
}

- (void)getCommunityList
{
    if ([AppRequest getNetworkStatus] == NotReachable) {
        [self getCommunityListFromCache];
    } else {
        [self getCommunityListFromServer];
    }
}

- (void)getCommunityListFromCache
{
    
}

- (void)getCommunityListFromServer
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [AppRequest request:URL_COMMUNITY_LIST parameters:nil completion:^(id result) {
        NSLog(result);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:result];
        if ([[dic objectForKey:@"retcode"] intValue] == 1) {
            myDelegate.communities = [NSMutableArray arrayWithArray:[dic objectForKey:@"communityList"]];
        }
    } failed:^(id error) {
        NSLog(error);
    }];
}

- (void)getLockList
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.locks.count == 0) {
        if ([AppRequest getNetworkStatus] == NotReachable) {
            [self getLockListFromCache];
        } else {
            [self getLockListFromServer];
        }
    } else {
        self.title = [[myDelegate.locks objectAtIndex:0] name];
        myDelegate.selectedLock = [myDelegate.locks objectAtIndex:0];
    }
}

- (void)getLockListFromCache
{
    
}

- (void)getLockListFromServer
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:myDelegate.userInfo.token, @"token", nil];
    [AppRequest request:URL_LOCK_LIST parameters:param completion:^(id result) {
        NSLog(result);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:result];
        if ([[dic objectForKey:@"retcode"] intValue] == 1) {
            myDelegate.locks = [NSMutableArray arrayWithArray:[dic objectForKey:@"lockList"]];
        }
    } failed:^(id error) {
        NSLog(error);
    }];
}

- (void)selectKey {
    //TODO 选择钥匙
    
}

@end

//
//  UnlockViewController.h
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBManager.h"
#import "YFGIFImageView.h"
#import "UIImageView+PlayGIF.h"

@interface UnlockViewController : UIViewController

@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) YFGIFImageView *gifView;

@end

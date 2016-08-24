//
//  UserInfo.h
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *home;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *token;

@end

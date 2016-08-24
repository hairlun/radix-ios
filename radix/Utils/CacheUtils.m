//
//  CacheUtils.m
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "CacheUtils.h"

#define CACHE_ACCOUNT @"account"
#define CACHE_NAME @"name"
#define CACHE_AREA_ID @"areaId"
#define CACHE_AREA_NAME @"areaName"
#define CACHE_MOBILE @"mobile"
#define CACHE_HOME @"home"
#define CACHE_TOKEN @"token"
#define CACHE_SELECTED_KEY_ID @"selectedKeyId"
#define CACHE_SELECTED_COMMUNITY_ID @"selectedCommunityId"SS

@implementation CacheUtils

+ (void)saveCache:(id)value forKey:(NSString *)key {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:value forKey:key];
    [setting synchronize];
}

+ (id)getStringForKey:(NSString *)key {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    id value = [settings objectForKey:key];
    return value;
}

+ (void)saveUserInfo:(UserInfo *)userInfo {
    [self saveCache:userInfo.account forKey:CACHE_ACCOUNT];
    [self saveCache:userInfo.name forKey:CACHE_NAME];
    [self saveCache:userInfo.areaId forKey:CACHE_AREA_ID];
    [self saveCache:userInfo.areaName forKey:CACHE_AREA_NAME];
    [self saveCache:userInfo.mobile forKey:CACHE_MOBILE];
    [self saveCache:userInfo.home forKey:CACHE_HOME];
    [self saveCache:userInfo.token forKey:CACHE_TOKEN];
}

+ (UserInfo *)getUserInfo {
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.account = [self getStringForKey:CACHE_ACCOUNT];
    userInfo.name = [self getStringForKey:CACHE_NAME];
    userInfo.areaId = [self getStringForKey:CACHE_AREA_ID];
    userInfo.areaName = [self getStringForKey:CACHE_AREA_NAME];
    userInfo.mobile = [self getStringForKey:CACHE_MOBILE];
    userInfo.home = [self getStringForKey:CACHE_HOME];
    userInfo.token = [self getStringForKey:CACHE_TOKEN];
    return userInfo;
}

@end

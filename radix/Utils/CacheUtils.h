//
//  CacheUtils.h
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface CacheUtils : NSObject

+ (void)saveCache:(id)value forKey:(NSString *)key;
+ (id)getStringForKey:(NSString *)key;

+ (void)saveUserInfo:(UserInfo *)userInfo;
+ (UserInfo *)getUserInfo;

@end

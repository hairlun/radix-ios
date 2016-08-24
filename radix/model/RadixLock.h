//
//  RadixLock.h
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadixLock : NSObject

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bleName;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *end;

@end

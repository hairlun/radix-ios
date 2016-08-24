//
//  Message.h
//  radix
//
//  Created by patrick on 16-8-14.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *nId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sentDate;
@property (nonatomic, strong) NSString *readTime;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic) Boolean hasVideo;

@end

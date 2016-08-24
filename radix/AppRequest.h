//
//  AppRequest.h
//  radix
//
//  Created by patrick on 16/7/5.
//  Copyright © 2016年 patrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

typedef void (^CompletionBlock)(id result);
typedef void (^FailedBlock)(id error);
typedef void (^ProgressBlock)(CGFloat progress);

@interface AppRequest : NSObject
+ (void)request:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion failed:(FailedBlock)failed;
+ (void)filedownload:(NSString *)attachmentid fileName:(NSString *)fileName progress:(ProgressBlock)progress completion:(CompletionBlock)completion failed:(FailedBlock)failed;
+ (NetworkStatus)getNetworkStatus;
@end

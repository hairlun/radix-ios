//
//  AppRequest.m
//  GHJ
//
//  Created by WJ on 16/7/5.
//  Copyright © 2016年 WJ. All rights reserved.
//

#import "AppRequest.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@implementation AppRequest

+ (void)finishRequest:(id)data completion:(CompletionBlock)completion failed:(FailedBlock)failed
{
    NSError *error;
    id json;
    if ([data isKindOfClass:[NSData class]]) {
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    else
    {
        json = data;
    }
    NSLog(@"%@", json);
    
    if ( (json[@"resultCode"] || json[@"resultcode"]) && [json[@"oprstatus"] integerValue] != 1 ) {
        
        if ( [json[@"resultCode"] integerValue] == 1 ) {
            
            completion(json);
            return;
        }
        if ( [json[@"resultcode"] integerValue] == 1 ) {
            
            completion(json);
            return;
        }
        
    }
    
    NSString *msgtips = @"";
    
    if ( json[@"resultMsg"] ) {
        
        msgtips = json[@"resultMsg"] ;
        
    }else{
        
        if ( json[@"resultmsg"] ) {
            
            msgtips = json[@"resultmsg"] ;
        }
    }
    
    failed([NSString stringWithFormat:@"%@", msgtips ]);
    
    if ([json[@"resultcode"] integerValue] == 2 || [json[@"resultcode"] integerValue] == 3) {
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

+ (void)request:(NSString *)url parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion failed:(FailedBlock)failed
{
    if ([url rangeOfString:@"http://"].location == 0) {
        NSString *allUrl = url;
        NSString *requestGetString = allUrl;
        NSLog(@"%@", requestGetString);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = IS_HTTPS;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 120.f;
        [manager POST:allUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppRequest finishRequest:responseObject completion:completion failed:failed];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(@"网络连接错误,请稍后再试!");
        }];
        
    } else {
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        NSString *allUrl = [NSString stringWithFormat:@"%@/%@", myDelegate.baseUrl, url];
        NSMutableDictionary *parametersAddToken = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        [parametersAddToken setValue:myDelegate.userInfo.token forKey:@"token"];
        NSString *requestGetString = allUrl;
        for (id key in parametersAddToken) {
            requestGetString = [NSString stringWithFormat:@"%@&%@=%@", requestGetString, key, parametersAddToken[key]];
        }
        NSLog(@"%@", requestGetString);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = IS_HTTPS;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 120.f;
        [manager POST:allUrl parameters:parametersAddToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [AppRequest finishRequest:responseObject completion:completion failed:failed];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failed(@"网络连接错误,请稍后再试!");
        }];
    }
}

+ (void)filedownload:(NSString *)attachmentid fileName:(NSString *)fileName progress:(ProgressBlock)progress completion:(CompletionBlock)completion failed:(FailedBlock)failed
{
//    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *getString = [NSString stringWithFormat:@"%@/flow/flow.do?action=downfile", myDelegate.baseUrl];
//    getString = [NSString stringWithFormat:@"%@&attachmentid=%@", getString, attachmentid];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"download"];
//    if (![fileManager fileExistsAtPath:path])
//    {
//        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    else{
//        path = [path stringByAppendingPathComponent:fileName];
//        if ([fileManager fileExistsAtPath:path]) {
//            completion(path);
//        }
//        else
//        {
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/flow/flow.do?action=downfile", myDelegate.baseUrl]]];
//            [request setHTTPMethod:@"POST"];
//            NSData *jsonData=[[NSString stringWithFormat:@"attachmentid=%@&token=%@", attachmentid, myDelegate.userInfo.token] dataUsingEncoding:NSUTF8StringEncoding];
//            [request setHTTPBody:jsonData];
//            
//            AFHTTPRequestOperation *downloadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//            [downloadOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//                NSLog(@"%lld / %lld\n", totalBytesRead, totalBytesExpectedToRead);
//                progress((CGFloat)totalBytesRead / totalBytesExpectedToRead);
//            }];
//            [downloadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [responseObject writeToFile:path options:NSDataWritingAtomic error:nil];
//                completion(path);
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                failed(@"附件下载失败");
//            }];
//            [downloadOperation start];
//        }
//    }
}

+ (NetworkStatus)getNetworkStatus
{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    return reach.currentReachabilityStatus;
}

@end

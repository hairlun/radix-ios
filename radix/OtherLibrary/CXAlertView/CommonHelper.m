//
//  CommonHelper.m
//  MobileOA
//
//  Created by Patrick Zhou on 14-6-4.
//  Copyright (c) 2014年 SINITECH. All rights reserved.
//

#import "CommonHelper.h"
#import "CXAlertView.h"

@implementation CommonHelper

//弹出信息
+(void)alertMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag completion:(void (^)(void))completion

{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    alert.tag = tag;
//    [alert show];
    CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"" message:message cancelButtonTitle:@"确定" completion:^{
        //提示消息消失后执行的操作
        if (completion) {
            completion();
        }
    }];
    alertViewMe.tag = tag;
    [alertViewMe show];
}

/** 弹出确认对话框 */
+ (void)confirmMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag completion:(void (^)(void))completion
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = tag;
//    [alert show];
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:message cancelButtonTitle:@"取消" completion:^{}];
    [alertView addButtonWithTitle:@"确定"
                             type:CXAlertViewButtonTypeDefault
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              if (completion) {
                                  completion();
                              }
                          }];
    alertView.tag = tag;
    [alertView show];
}

//弹出信息
+(void)alertMessage:(NSString *)message delegate:(id)delegate completion:(void (^)(void))completion
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    alert.tag = 0;
//    [alert show];
    CXAlertView *alertViewMe = [[CXAlertView alloc] initWithTitle:@"" message:message cancelButtonTitle:@"确定" completion:^{
        //提示消息消失后执行的操作
        if (completion) {
            completion();
        }
    }];
    alertViewMe.tag = 0;
    [alertViewMe show];

}

/** 弹出确认对话框 */
+ (void)confirmMessage:(NSString *)message delegate:(id)delegate completion:(void (^)(void))completion
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 0;
//    [alert show];
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:message cancelButtonTitle:@"取消" completion:^{}];
    [alertView addButtonWithTitle:@"确定"
                             type:CXAlertViewButtonTypeDefault
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              if (completion) {
                                  completion();
                              }
                          }];
    alertView.tag = 0;
    [alertView show];
}
//
//+(void)changePosition:(UIView*)titles otherTitle:(UIView*)otherTitle allView:(UIView*)allView
//{
//    //根据屏幕尺寸，调整位置
//    NSUInteger phoneResolution = [UIDevice currentResolution];
//    if (phoneResolution == 3)
//    {
//        
//    }
//    else if (phoneResolution <3)
//    {
//        titles.frame = CGRectMake(titles.frame.origin.x,titles.frame.origin.y - 45,titles.frame.size.width,titles.frame.size.height);
//        otherTitle.frame = CGRectMake(otherTitle.frame.origin.x,otherTitle.frame.origin.y - 45,otherTitle.frame.size.width,otherTitle.frame.size.height);
//        allView.frame = CGRectMake(allView.frame.origin.x,allView.frame.origin.y - 45,allView.frame.size.width,allView.frame.size.height);
//    }
//}
//
//+ (int) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
//    NSString *text;
//    if (strText == nil || [strText isEqualToString:@""]) {
//        text = @"1";
//    } else {
//        text = strText;
//    }
//    int padding = 20; // 10pt x 2
//    CGSize constraint = CGSizeMake(textView.contentSize.width - padding, CGFLOAT_MAX);
//    
//    CGSize size = [text sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    
//    int height = (int)size.height + padding;
//    
//    return height;
//}
//
///**
// @method 获取指定宽度情况下，字符串value的高度
// @param value 待计算的字符串
// @param fontSize 字体的大小
// @param andWidth 限制字符串显示区域的宽度
// @result float 返回的高度
// */
//+ (int) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
//{
//    NSString *text = [NSString stringWithString:value];
//    if ([text isEqualToString:@""]) {
//        text = @"1";
//    }
//    CGSize sizeToFit = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
//    int height = (int)sizeToFit.height + 6;
//    return height;
//}
//
//+ (BOOL)zipFiles:(NSArray *)paramFiles zipFilePath:(NSString *)zipFilePath password:(NSString *)password
//{
//    //判断文件是否存在，如果存在则删除文件
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    @try
//    {
//        if([fileManager fileExistsAtPath:zipFilePath])
//        {
//            if(![fileManager removeItemAtPath:zipFilePath error:nil])
//            {
//                NSLog(@"Delete zip file failure.");
//            }
//        }
//    }
//    @catch (NSException * exception) {
//        NSLog(@"%@",exception);
//    }
//    
//    //判断需要压缩的文件是否为空
//    if(paramFiles == nil || [paramFiles count] == 0)
//    {
//        NSLog(@"The files want zip is nil.");
//        return NO;
//    }
//    
//    //实例化并创建zip文件
//    ZipArchive * zipArchive = [[ZipArchive alloc] init];
//    [zipArchive CreateZipFile2:zipFilePath Password:password];
//    
//    //遍历文件
//    for(NSDictionary *dic in paramFiles)
//    {
//        NSString *filePath = [dic objectForKey:@"filePath"];
//        NSString *fileName = [dic objectForKey:@"fileName"];
//        if([fileManager fileExistsAtPath:filePath])
//        {   //添加文件到压缩文件
//            [zipArchive addFileToZip:filePath newname:fileName];
//        }
//    }
//    //关闭文件
//    if([zipArchive CloseZipFile2])
//    {
//        NSLog(@"Create zip file success.");
//        return YES;
//    }
//    return NO;
//}
//
//+ (BOOL)unzipFile:(NSString *)zipFilePath outPath:(NSString *)outPath password:(NSString *)password
//{
//    //判断需要解压的文件是否为空
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    @try
//    {
//        if(![fileManager fileExistsAtPath:zipFilePath])
//        {
//            NSLog(@"Zip file not exist.");
//            return NO;
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    
//    // 判断输出目录是否存在，如果不存在则创建目录
//    @try
//    {
//        if(![fileManager fileExistsAtPath:outPath])
//        {
//            NSError *error;
//            if (![fileManager createDirectoryAtPath:outPath withIntermediateDirectories:YES attributes:nil error:&error]) {
//                NSLog(@"Create output path failure. Error: %@", error);
//                return NO;
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//    
//    //实例化并打开zip文件
//    ZipArchive * zipArchive = [[ZipArchive alloc] init];
//    [zipArchive UnzipOpenFile:zipFilePath Password:password];
//    // 解压文件
//    [zipArchive UnzipFileTo:outPath overWrite:YES];
//    // 关闭文件
//    if ([zipArchive UnzipCloseFile]) {
//        NSLog(@"Unzip file success.");
//        return YES;
//    }
//    
//    return NO;
//}
//
//+ (NSData *)encryptData:(NSData *)data withKey:(NSString *)key
//{
//    uint8_t *bufPtr = NULL;
//    size_t bufSize = data.length;
//    
//    bufPtr = malloc(bufSize * sizeof(uint8_t));
//    memset((void *)bufPtr, 0x0, bufSize);
//    [data getBytes:bufPtr range:NSMakeRange(0, bufSize)];
//    
//    // 加密
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (bufSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    
//    const void *vkey = (const void *) [key UTF8String];
//    ccStatus = CCCrypt(kCCEncrypt,
//                       kCCAlgorithmAES128,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySizeAES256,
//                       nil,
//                       bufPtr,
//                       bufSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    if (ccStatus != kCCSuccess)
//        return NULL;
//    
//    NSData *ciphertext = [[NSData alloc] initWithBytes:bufferPtr length:movedBytes];
//    return ciphertext;
//}
//
//+ (NSData *)decryptData:(NSData *)data withKey:(NSString *)key
//{
//    uint8_t *bufPtr = NULL;
//    size_t bufSize = data.length;
//    
//    bufPtr = malloc(bufSize * sizeof(uint8_t));
//    [data getBytes:bufPtr range:NSMakeRange(0, bufSize)];
//    
//    
//    // 解密
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (bufSize + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    const void *vkey = (const void *) [key UTF8String];
//    ccStatus = CCCrypt(kCCDecrypt,
//                       kCCAlgorithmAES128,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySizeAES256,
//                       nil,
//                       bufPtr,
//                       bufSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    if (ccStatus != kCCSuccess)
//        return NO;
//    
//    NSData *plaintext = [[NSData alloc] initWithBytes:bufferPtr length:movedBytes];
//    return plaintext;
//}
//
//+ (BOOL)encryptFile:(NSString *)path withKey:(NSString *)key
//{
//    // 读取文件
//    NSData *reader = [NSData dataWithContentsOfFile:path];
//    NSData *data = [reader subdataWithRange:NSMakeRange(0, ENCRYPT_FILE_LENGTH)];
//    NSData *ciphertext = [self encryptData:data withKey:key];
//
//    // 写回文件
//    NSMutableData *writer = [[NSMutableData alloc] initWithData:ciphertext];
//    [writer appendData:[reader subdataWithRange:NSMakeRange(ENCRYPT_FILE_LENGTH, reader.length - ENCRYPT_FILE_LENGTH)]];
//    return [writer writeToFile:path atomically:YES];
//}
//
//+ (BOOL)decryptFile:(NSString *)path withKey:(NSString *)key
//{
//    // 读取文件
//    NSData *reader = [NSData dataWithContentsOfFile:path];
//    NSData *data = [reader subdataWithRange:NSMakeRange(0, DECRYPT_FILE_LENGTH)];
//    NSData *plaintext = [self decryptData:data withKey:key];
//
//    // 写回文件
//    NSMutableData *writer = [[NSMutableData alloc] initWithData:plaintext];
//    [writer appendData:[reader subdataWithRange:NSMakeRange(DECRYPT_FILE_LENGTH, reader.length - DECRYPT_FILE_LENGTH)]];
//    return [writer writeToFile:path atomically:YES];
//}
//
//+ (NSString *)encryptText:(NSString *)plaintext withKey:(NSString *)key
//{
//    NSData *plainData = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *cipherData = [self encryptData:plainData withKey:key];
//    NSString *ciphertext = [GTMBase64 stringByEncodingData:cipherData];
//    return ciphertext;
//}
//
//+ (NSString *)decryptText:(NSString *)ciphertext withKey:(NSString *)key
//{
//    NSData *cipherData = [GTMBase64 decodeData:[ciphertext dataUsingEncoding:NSUTF8StringEncoding]];
//    NSData *plainData = [self decryptData:cipherData withKey:key];
//    NSString *plaintext = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
//    return plaintext;
//}
//
//+ (NSString *)getUserDirectory
//{
//    NSString *userDir;
//    NSString *account = [UserInfoCache getAccount];
//    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    userDir = [NSString stringWithFormat:@"%@/%@", docDir, account];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = NO;
//    BOOL isExist = [fileManager fileExistsAtPath:userDir isDirectory:&isDir];
//    if (!(isDir && isExist)) {
//        // 目录不存在，创建
//        [fileManager createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return userDir;
//}
//
//+ (BOOL)clearCacheBeforeDate:(NSDate *)date
//{
//    // 清除数据库缓存
//    LKDBHelper *helper = [LKDBHelper getUsingLKDBHelper];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSMutableString *ms = [NSMutableString stringWithFormat:@"mTime < %@", [formatter stringFromDate:date]];
//    [helper deleteWithClass:[User class] where:ms];
//    [helper deleteWithClass:[Schedule class] where:ms];
//    [helper deleteWithClass:[MySchedule class] where:ms];
//    [helper deleteWithClass:[ScheduleDetails class] where:ms];
//    [helper deleteWithClass:[MyScheduleDetails class] where:ms];
//    [helper deleteWithClass:[Notice class] where:ms];
//    [helper deleteWithClass:[NoticeDetails class] where:ms];
//    [helper deleteWithClass:[Attach class] where:ms];
//    [helper deleteWithClass:[WorkflowAttach class] where:ms];
//    [helper deleteWithClass:[Flow class] where:ms];
//    [helper deleteWithClass:[WorkflowTodo class] where:ms];
//    [helper deleteWithClass:[WorkflowDone class] where:ms];
//    [helper deleteWithClass:[WorkflowMonitor class] where:ms];
//    [helper deleteWithClass:[WorkflowTodoDetails class] where:ms];
//    [helper deleteWithClass:[WorkflowDoneDetails class] where:ms];
//    [helper deleteWithClass:[WorkflowInitDetails class] where:ms];
//    [helper deleteWithClass:[ElementTodo class] where:ms];
//    [helper deleteWithClass:[ElementDone class] where:ms];
//    [helper deleteWithClass:[ElementInit class] where:ms];
//    [helper deleteWithClass:[RunStep class] where:ms];
//    [helper deleteWithClass:[MyCollection class] where:ms];
//    
//    // 清除附件文件
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *attachDir = [NSString stringWithFormat:@"%@/attachment/", [self getUserDirectory]];
//    BOOL isDir = NO;
//    BOOL isExist = [fileManager fileExistsAtPath:attachDir isDirectory:&isDir];
//    if (!(isExist && isDir)) {
//        // 目录不存在
//        return YES;
//    }
//    // 遍历附件文件夹
//    NSArray *tmpList = [fileManager contentsOfDirectoryAtPath:attachDir error:nil];
//    for (NSString *filename in tmpList) {
//        NSString *fullPath = [attachDir stringByAppendingString:filename];
//        isDir = NO;
//        isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
//        if (!isDir && isExist) {
//            // 查看修改日期属性
//            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullPath error:nil];
//            NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
//            if ([fileModDate earlyThan:date]) {
//                // 删除附件
//                [fileManager removeItemAtPath:fullPath error:nil];
//            }
//        }
//        
//    }
//    
//    return YES;
//}
//
//+ (NSString *)clearHtmlToString:(NSString *)html
//{
//    if (html == nil || [html isEqualToString:@""]) {
//        return @"";
//    }
//    NSScanner * scanner = [NSScanner scannerWithString:html];
//    NSString * text = nil;
//    while( [scanner isAtEnd] == NO) {
//        //找到标签的起始位置
//        [scanner scanUpToString:@"<" intoString:nil];
//        //找到标签的结束位置
//        [scanner scanUpToString:@">" intoString:&text];
//        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
//    }
//    return html;
//}

@end

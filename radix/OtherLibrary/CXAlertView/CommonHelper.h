//
//  CommonHelper.h
//  MobileOA
//
//  Created by Patrick Zhou on 14-6-4.
//  Copyright (c) 2014年 SINITECH. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIKit.h>

@interface CommonHelper : NSObject

+ (void)alertMessage:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag completion:(void (^)(void))completion
;
+ (void)alertMessage:(NSString *)message delegate:(id)delegate completion:(void (^)(void))completion;
+ (void)confirmMessage:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag completion:(void (^)(void))completion;
+ (void)confirmMessage:(NSString *)message delegate:(id)delegate completion:(void (^)(void))completion
;
//+ (void)changePosition:(UIView*)titles otherTitle:(UIView*)otherTitle allView:(UIView*)allView;
//+ (int)heightForTextView:(UITextView *)textView WithText:(NSString *)strText;
//+ (int) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
//+ (BOOL)zipFiles:(NSArray *)paramFiles zipFilePath:(NSString *)zipFilePath password:(NSString *)password;
//+ (BOOL)unzipFile:(NSString *)zipFilePath outPath:(NSString *)outPath password:(NSString *)password;
//+ (BOOL)encryptFile:(NSString *)path withKey:(NSString *)key;
//+ (BOOL)decryptFile:(NSString *)path withKey:(NSString *)key;
//+ (NSString *)encryptText:(NSString *)plaintext withKey:(NSString *)key;
//+ (NSString *)decryptText:(NSString *)ciphertext withKey:(NSString *)key;
//+ (NSString *)getUserDirectory;
//+ (BOOL)clearCacheBeforeDate:(NSDate *)date;
//+ (NSString *)clearHtmlToString:(NSString *)html;

@end

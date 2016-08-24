//
//  AppDelegate.h
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Community.h"
#import "RadixLock.h"
#import "UserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableArray *communities;
@property (nonatomic, strong) NSMutableArray *locks;
@property (nonatomic, strong) NSMutableArray *selectedLocks;
@property (nonatomic, strong) RadixLock *selectedLock;
@property (nonatomic, strong) Community *selectedCommunity;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *selectedLockId;
@property (nonatomic, strong) NSString *selectedCommunityId;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *csn;
@property (nonatomic, strong) NSString *baseUrl;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end


//
//  AppDelegate.m
//  radix
//
//  Created by patrick on 16-8-10.
//  Copyright (c) 2016年 patrick. All rights reserved.
//

#import "AppDelegate.h"
#import "UnlockViewController.h"
#import "VisitorViewController.h"
#import "MessageViewController.h"
#import "SettingsViewController.h"
#import "BaseNavigationController.h"
#import "CacheUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //a.初始化一个tabBar控制器
    UITabBarController *tbc = [[UITabBarController alloc] init];
    //设置控制器为Window的根控制器
    self.window.rootViewController = tbc;
    
    //b.创建子控制器
    UIViewController *vc1 = [[BaseNavigationController alloc] initWithRootViewController:[[UnlockViewController alloc] init]];
    vc1.view.backgroundColor = BG_GRAY_COLOR;
    vc1.tabBarItem.image = [UIImage imageNamed:@"foot_icon_01"];
    vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    
    UIViewController *vc2 = [[BaseNavigationController alloc] initWithRootViewController:[[VisitorViewController alloc] init]];
    vc2.view.backgroundColor = BG_GRAY_COLOR;
    vc2.tabBarItem.image = [UIImage imageNamed:@"foot_icon_02"];
    vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    
    UIViewController *vc3 = [[BaseNavigationController alloc] initWithRootViewController:[[MessageViewController alloc] init]];
    vc3.view.backgroundColor = BG_GRAY_COLOR;
    vc3.tabBarItem.image = [UIImage imageNamed:@"foot_icon_03"];
    vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    
    UIViewController *vc4 = [[BaseNavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
    vc4.view.backgroundColor = BG_GRAY_COLOR;
    vc4.tabBarItem.image = [UIImage imageNamed:@"foot_icon_04"];
    vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    
    //c.添加子控制器到ITabBarController中
    tbc.viewControllers = @[vc1, vc2, vc3, vc4];
    [self.window makeKeyAndVisible];

    // 初始化数据
    self.communities = [[NSMutableArray alloc] init];
    self.locks = [[NSMutableArray alloc] init];
    self.selectedLocks = [[NSMutableArray alloc] init];
    self.userInfo = [[UserInfo alloc] init];
    self.selectedCommunity = nil;
    self.selectedLock = nil;
    self.cardNum = @"FF FF FF FF ";
    self.userInfo = [CacheUtils getUserInfo];
    self.baseUrl = @"http://15fx462892.51mypc.cn:8088/surpass/mobile";
    // 从缓存读取小区列表和当前选择小区
    [self getCommunityListFromCache];
    // 从缓存读取门禁钥匙列表和当前选择门禁钥匙
    [self getLockListFromCache];
    
    return YES;
}

- (void)getCommunityListFromCache {
    //TODO
}

- (void)getLockListFromCache {
    //TODO
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.patr.radix" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"radix" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"radix.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

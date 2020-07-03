//
//  AppDelegate.m
//  DEMO_MOBILESDK
//
//  Created by mptt2 on 7/3/20.
//  Copyright © 2020 MSERVICE JSC. All rights reserved.
//

#import "AppDelegate.h"
#import "MoMoPayment.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@">>handleopenUrl iOS 9 or newest");
    [[MoMoPayment shareInstances] handleOpenUrl:url];
    return YES;
}
#else
-(BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url
{
    NSLog(@">>handleopenUrl ios < 9.0");
    [[MoMoPayment shareInstances] handleOpenUrl:url];
    return YES;
}
#endif
@end

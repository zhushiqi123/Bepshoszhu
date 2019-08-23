//
//  AppDelegate.m
//  beposh
//
//  Created by 田阳柱 on 16/7/22.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "AppDelegate.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Service.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // Override point for customization after application launch.
    //最好初始化数据(蓝牙状态判定当app进入则初始化数据)
    [TYZ_Session sharedInstance].check_BLE_status = 1;
    [TYZ_BLE_Service sharedInstance].Status_Connect = BLEConnectStatusOff;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /**
     *  断开蓝牙的回调  - BLE Disconnect
     *  @return 断开蓝牙的信息
     */
    if ([TYZ_Session sharedInstance].check_BLE_status == 0x00)
    {
        NSLog(@"APP ----- 退出活跃");
        //初始查询，发送初始查询信息
        [TYZ_BLE_Protocol initial_query];
    }
    else
    {
        [TYZ_Session sharedInstance].check_BLE_status = 1;
        
        if ([TYZ_BLE_Service sharedInstance].Status_Connect == BLEConnectStatusOn)
        {
            [TYZ_BLE_Service sharedInstance].Status_Connect = BLEConnectStatusLoding;
        }
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

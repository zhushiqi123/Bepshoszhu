//
//  AppDelegate.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//  说明：逻辑简单，没有进行分层处理
//

#import "AppDelegate.h"
#import "STW_BLE_SDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化蓝牙检测
    [STW_BLEService sharedInstance].isReadyScan = YES;
    //蓝牙还未连接
    [STW_BLEService sharedInstance].isBLEStatus = NO;
    //蓝牙断开
    [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
    //设置现在为主界面
    [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeScanRoot;
    
    //初始化数据
    [STW_BLE_SDK STW_SDK].power = 50;
    [STW_BLE_SDK STW_SDK].temperature = 280;
    [STW_BLE_SDK STW_SDK].temperatureMold = BLEProtocolTemperatureUnitFahrenheit;
    [STW_BLE_SDK STW_SDK].vaporModel = BLEProtocolModeTypePower;
    [STW_BLE_SDK STW_SDK].battery = 0;
    [STW_BLE_SDK STW_SDK].atomizer = 0;
    [STW_BLE_SDK STW_SDK].vapor_Activity = BLEProtocolDriveActivity;
    [STW_BLE_SDK STW_SDK].atomizerMold = BLEAtomizerX1;
    [STW_BLE_SDK STW_SDK].fileDeviceArrys = [NSMutableArray array];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //回调APP即将被计入后台
    switch ([STW_BLEService sharedInstance].isBLEDisType)
    {
        case STW_BLE_IsBLEDisTypeScanRoot:
        {
            //APP进入后台
            if([STW_BLEService sharedInstance].Service_StopScanRoot)
            {
                [STW_BLEService sharedInstance].Service_StopScanRoot();
            }
        }
            
            break;
            
        case STW_BLE_IsBLEDisTypeScan:
        {
            //APP进入后台
            if([STW_BLEService sharedInstance].Service_StopScanView)
            {
                [STW_BLEService sharedInstance].Service_StopScanView();
            }
        }
            
            break;
            
        case STW_BLE_IsBLEDisTypeOn:
        {
            //APP进入后台
            if([STW_BLEService sharedInstance].Service_StopHOME)
            {
                [STW_BLEService sharedInstance].Service_StopHOME();
            }
        }
            
            break;
            
        default:
            break;
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//当应用程序入活动状态执行
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if([STW_BLEService sharedInstance].isBLEStatus)
    {
        //查询所有配置信息
        [STW_BLE_Protocol the_find_all_data];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

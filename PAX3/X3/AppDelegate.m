//
//  AppDelegate.m
//  PAX3
//
//  Created by tyz on 17/5/2.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "AppDelegate.h"
#import "ChooseViewController.h"
#import "LaunchIntroductionView.h"
#import "AddDeviceViewController.h"
#import "STW_BLE.h"
#import "STW_Data_Plist.h"
#import "HomeViewController.h"
#import "ChooseViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIImageView *splashView;
@property (strong, nonatomic) UIView *backgroungView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //初始化蓝牙
    [[STW_BLE_SDK sharedInstance] STW_BLE_SDK_init];

    //获取本地信息 - 绑定的设备列表
    [STW_BLE_SDK sharedInstance].bindingDevices = [STW_Data_Plist GetDeviceData];
    
    //获取温度单位
    [STW_BLE_SDK sharedInstance].STW_BLE_Temp_model = [STW_Data_Plist GetTempModelData];
    
    if ([STW_BLE_SDK sharedInstance].bindingDevices.count > 0) {
//    if ([STW_BLE_SDK sharedInstance].bindingDevices.count == 0) {
        //跳转Home界面
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *homeViewController = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        self.window.rootViewController = homeViewController;
    }
    else
    {
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseViewController *chooseViewController = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        self.window.rootViewController = chooseViewController;
        
        //引导视图
        [LaunchIntroductionView sharedWithStoryboardName:@"Main" images:@[@"evangelize1",@"evangelize2",@"evangelize3",@"evangelize4"] buttonString:@"GET STARTED" titleString:@[@"Welcome.",@"The best vapor. Ever.",@"Personalized sessions",@"Safe and secure"] lableString:@[@"The PAX3 App is the best way to enhance your experiences with PAX.",@"Customize your temperature settings to get the taste and vapor quality you've been waiting for.",@"Customize your settings so that each session is tailored to you.",@"Your privacy will never be compromised"]];
    }

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

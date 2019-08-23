//
//  RootViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "RootViewController.h"
#import "MainTabBarViewController.h"
#import "STW_BLE_SDK.h"
#import "TYZFileData.h"
#import "fileDevice.h"
#import "YXRadarView.h"
#import "YXRadarIndictorView.h"

@interface RootViewController ()
{
    int animation_status;   //0 - 停止  1 - 旋转
    int check_nums;   //判断是否已经绑定
    NSTimer *scanTimer;
}

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏标题文字以及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor darkGrayColor]}];

    self.title = @"Connecting bluetooth, please wait";
    
    animation_status = 1;
    
    [self setupRadarView];
    
    [self addTwoButton];
    
    [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeScanRoot;
    
    //注册APP进入后台回调
    [self appToBackGround];
    
    //开始扫描蓝牙
    [self performSelector:@selector(scanBLEDevice_scan) withObject:nil afterDelay:1.0f];
}

//APP进入后台
-(void)appToBackGround
{
    [STW_BLEService sharedInstance].Service_StopScanRoot = ^()
    {
//        NSLog(@"APP - 进入后台 - ROOT");
        
        if (scanTimer)
        {
            [scanTimer invalidate];
            scanTimer = nil;
        }
        
        [self.radarView stop];
        
        [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x02;
        
        [[STW_BLEService sharedInstance] scanStop];
        
        if ([STW_BLEService sharedInstance].isBLEStatus)
        {
            //停止闪灯
            [STW_BLE_Protocol the_check_device:0x02];
            
            //断开连接
//            NSLog(@"------------- 主动断开与蓝牙的连接 2-----------------");
            [[STW_BLEService sharedInstance] disconnect];
            [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
            [STW_BLEService sharedInstance].isBLEStatus = NO;
            //断开连接的回调
            [self Ble_disconnectHandler];
        }
        
        [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
        
        //将断开连接传递给主界面
        [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeOn;
        
        MainTabBarViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"mains"];
        self.view.window.rootViewController = mainView;
    };
}

-(void)scanBLEDevice_scan
{
    if (scanTimer)
    {
        [scanTimer invalidate];
        scanTimer = nil;
    }
    
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:40.0f target:self selector:@selector(stopScan_timer:) userInfo:nil repeats:YES];
    
    [[STW_BLEService sharedInstance] scanStart];
    
    //注册扫描到设备的回调
    [STW_BLEService sharedInstance].Service_scanHandler = ^(STW_BLEDevice *device)
    {
//        NSLog(@"ROOT - 扫描到的设备-%@-%@",device.deviceName,device.deviceMac);
        if (![STW_BLEService sharedInstance].isBLEStatus && [STW_BLEService sharedInstance].isBLEType == STW_BLE_IsBLETypeOff)
        {
            [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOn;
            //有符合对象调用连接
            [[STW_BLEService sharedInstance] connect:device];
            
            [self Service_connectedHandler_scan];
        }
    };
}

//计时停止扫描
-(void)stopScan_timer:(NSTimer *)timer
{
    animation_status = 0;
    
    [self.radarView hide];
    
    [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x02;
    
    [[STW_BLEService sharedInstance] scanStop];
    
    if ([STW_BLEService sharedInstance].isBLEStatus)
    {
        //停止闪灯
        [STW_BLE_Protocol the_check_device:0x02];
        
        //断开连接
//        NSLog(@"------------- 主动断开与蓝牙的连接 3-----------------");
        [[STW_BLEService sharedInstance] disconnect];
        [STW_BLEService sharedInstance].isBLEStatus = NO;
        [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
        //断开连接的回调
        [self Ble_disconnectHandler];
    }
    
    self.title = @"Device not found";
    
    [self.btn_button_retry  setTitle:@"Retry" forState:UIControlStateNormal];
}

//连接成功的回调
-(void)Service_connectedHandler_scan
{
    [STW_BLEService sharedInstance].Service_connectedHandler = ^(void)
    {
        [STW_BLEService sharedInstance].isBLEStatus = YES;
        
        //注册断开连接回调
        [self Ble_disconnectHandler];
        
        //注册开始服务的回调
        [self start_service_scan];
    };
}

//注册断开连接的回调
-(void)Ble_disconnectHandler
{
    [STW_BLEService sharedInstance].Service_disconnectHandlerRoot = ^(void)
    {
//        NSLog(@"蓝牙断开连接 - Root");
        
        [STW_BLEService sharedInstance].isBLEStatus = NO;
        
        [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
        
        //重新开始扫描
        [[STW_BLEService sharedInstance] scanStart];
    };
}

//注册开始设备服务的回调
-(void)start_service_scan
{
    [STW_BLEService sharedInstance].Service_discoverCharacteristicsForServiceHandler = ^()
    {
//        [self connectBLE];
        //还未绑定
        [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x00;

        //获取本地数据
        [STW_BLE_SDK STW_SDK].fileDeviceArrys = [NSMutableArray array];
        
        //获取本地缓存数组
        [STW_BLE_SDK STW_SDK].fileDeviceArrys = [TYZFileData GetDeviceData];
        
        check_nums = 0;
        
        if ([STW_BLE_SDK STW_SDK].fileDeviceArrys.count > 0)
        {
            for (fileDevice *stwDevice  in  [STW_BLE_SDK STW_SDK].fileDeviceArrys)
            {
                if ([stwDevice.deviceMac isEqualToString:[STW_BLEService sharedInstance].device.deviceMac])
                {
                    check_nums = check_nums + 1;
                    break;
                }
            }
        }

//        NSLog(@"扫描 - 进行匹配 - %d",check_nums);
        
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                            [STW_BLE_Protocol the_check_device:check_nums];
                       });
        
        if (check_nums == 0)
        {
            //延时断开连接
            double delayInSeconds = 5.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               if([STW_BLE_SDK STW_SDK].check_DeviceBinding == 0x00)
                               {
                                   //停止闪灯
                                   if ([STW_BLEService sharedInstance].isBLEStatus)
                                   {
                                       //停止闪灯
                                       [STW_BLE_Protocol the_check_device:0x02];
                                   }
                                   
                                   //断开连接
//                                   NSLog(@"------------- 主动断开与蓝牙的连接 4-----------------");
                                   [[STW_BLEService sharedInstance] disconnect];
                                   
                                   [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
                                   
                                   [STW_BLEService sharedInstance].isBLEStatus = NO;
                                   
                                   //重新开始扫描
//                                   [[STW_BLEService sharedInstance] scanStart];
                                   
                                   double delayInSeconds = 1.0f;
                                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                                  {
//                                                      NSLog(@"------------- 重新蓝牙的连接 4-----------------");
                                                      //重新开始扫描
                                                      [[STW_BLEService sharedInstance] scanStart];
                                                  });
                               }
                           });
        }
        else
        {
            //延时断开连接
            double delayInSeconds = 1.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               if([STW_BLE_SDK STW_SDK].check_DeviceBinding == 0x00)
                               {
                                   //断开连接
//                                   NSLog(@"------------- 主动断开与蓝牙的连接 5-----------------");
                                   [[STW_BLEService sharedInstance] disconnect];
                                   [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
                                   [STW_BLEService sharedInstance].isBLEStatus = NO;
                                   
                                   //重新开始扫描
                                   [[STW_BLEService sharedInstance] scanStart];
                                   
                                   double delayInSeconds = 1.0f;
                                   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                   dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                                  {
//                                                      NSLog(@"------------- 重新蓝牙的连接 5-----------------");
                                                      //重新开始扫描
                                                      [[STW_BLEService sharedInstance] scanStart];
                                                  });
                               }
                           });
        }
        
        //注册匹配回调
        [self the_check_device_back_scan];
    };
}

//注册是否绑定回调
-(void)the_check_device_back_scan
{
    [STW_BLEService sharedInstance].Service_DeviceCheck = ^(int deviceType_check)
    {
        if (deviceType_check == 0xFE)
        {
            [self connectBLE];
        }
    };
}

//主动连接蓝牙
-(void)connectBLE
{
    if(scanTimer)
    {
        [scanTimer invalidate];
        scanTimer = nil;
    }
    
    //已经绑定
    [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x01;
    
    //没有记录 - 将数据存到本地
    if(check_nums == 0)
    {
        fileDevice *stwDevice = [[fileDevice alloc] init];
        
        stwDevice.deviceName = [STW_BLEService sharedInstance].device.deviceName;
        stwDevice.deviceMac = [STW_BLEService sharedInstance].device.deviceMac;
        
        NSMutableArray *arrysFile = [NSMutableArray array];
        
        if ([STW_BLE_SDK STW_SDK].fileDeviceArrys .count > 0)
        {
            arrysFile = [STW_BLE_SDK STW_SDK].fileDeviceArrys;
        }
        
        [arrysFile addObject:stwDevice];
        
        [TYZFileData SaveDeviceData:arrysFile];
    }
    
    //连接成功 - 设置等待重连
    [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeLoding;
    
    //获取连接设备的mac
    [STW_BLE_SDK STW_SDK].deviceMac = [STW_BLEService sharedInstance].device.deviceMac;
    
    //跳转
    [self.radarView stop];
    
    [[STW_BLEService sharedInstance] scanStop];
    
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //发出通知
                       if ([STW_BLEService sharedInstance].Service_ScanToFindData)
                       {
                           [STW_BLEService sharedInstance].Service_ScanToFindData();
                       }
                   });
    
    //将断开连接传递给主界面
    [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeOn;
    
    MainTabBarViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"mains"];
    self.view.window.rootViewController = mainView;
}

-(void)addTwoButton
{
    UIButton *button_retry = [UIButton buttonWithType:UIButtonTypeRoundedRect]; //绘制形状
    
    // 确定宽、高、X、Y坐标
    CGRect frame;
    frame.size.width = (SCREEN_WIDTH - 50)/2;
    frame.size.height = 44.0f;
    frame.origin.x = 20.0f;
    frame.origin.y = SCREEN_HEIGHT - 44 - 20;
    [button_retry setFrame:frame];
    
    // 设置Tag(整型)
//    button_retry.tag = 10;
    [button_retry setTitle:@"Stop" forState:UIControlStateNormal];
    [button_retry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button_retry.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    //设置按钮的圆角半径不会被遮挡
    [button_retry.layer setMasksToBounds:YES];
    [button_retry.layer setCornerRadius:2];
    
    //设置边界的宽度
    [button_retry.layer setBorderWidth:1];
    [button_retry.layer setBorderColor:[UIColor blackColor].CGColor];

    // 设置事件
    [button_retry addTarget:self action:@selector(onclick_button_retry) forControlEvents:UIControlEventTouchUpInside];

    [self.radarView addSubview:button_retry];
    
    self.btn_button_retry = button_retry;
    
    UIButton *button_Cancle = [UIButton buttonWithType:UIButtonTypeRoundedRect]; //绘制形状
    
    // 确定宽、高、X、Y坐标
    CGRect frame02;
    frame02.size.width = (SCREEN_WIDTH - 50)/2;
    frame02.size.height = 44.0f;
    frame02.origin.x = SCREEN_WIDTH - 20.0f - frame02.size.width;
    frame02.origin.y = SCREEN_HEIGHT - 44 - 20;
    [button_Cancle setFrame:frame02];
    
    // 设置标题
    [button_Cancle setTitle:@"Skip" forState:UIControlStateNormal];
    [button_Cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button_Cancle.titleLabel setFont:[UIFont systemFontOfSize:17]];
    
    //设置按钮的圆角半径不会被遮挡
    [button_Cancle.layer setMasksToBounds:YES];
    [button_Cancle.layer setCornerRadius:2];
    
    //设置边界的宽度
    [button_Cancle.layer setBorderWidth:1];
    [button_Cancle.layer setBorderColor:[UIColor blackColor].CGColor];
    
    // 设置事件
    [button_Cancle addTarget:self action:@selector(onclick_button_Cancle) forControlEvents:UIControlEventTouchUpInside];
    
    [self.radarView addSubview:button_Cancle];
    
    self.btn_button_Cancle = button_Cancle;
}

//停止开始扫描按钮
-(void)onclick_button_retry
{
    if (animation_status == 1)
    {
        if (scanTimer)
        {
            [scanTimer invalidate];
            scanTimer = nil;
        }
        animation_status = 0;
        
        [self.radarView hide];
        
        [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x02;
        
        [[STW_BLEService sharedInstance] scanStop];
        
        if ([STW_BLEService sharedInstance].isBLEStatus)
        {
            //停止闪灯
            [STW_BLE_Protocol the_check_device:0x02];
            
            //断开连接
//            NSLog(@"------------- 主动断开与蓝牙的连接 6-----------------");
            [[STW_BLEService sharedInstance] disconnect];
            [STW_BLEService sharedInstance].isBLEStatus = NO;
            [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
            //断开连接的回调
            [self Ble_disconnectHandler];
        }
        
        [self.btn_button_retry  setTitle:@"Retry" forState:UIControlStateNormal];
    }
    else if (animation_status == 0)
    {
        if (scanTimer)
        {
            [scanTimer invalidate];
            scanTimer = nil;
        }
        
        self.title = @"Connecting bluetooth, please wait";
        
        animation_status = 1;
 
       [self.radarView show];
        
        [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x02;
        
        [self scanBLEDevice_scan];
        
       [self.btn_button_retry  setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

//取消按钮
-(void)onclick_button_Cancle
{
    if (scanTimer)
    {
        [scanTimer invalidate];
        scanTimer = nil;
    }
    
    [self.radarView stop];
    
    [STW_BLE_SDK STW_SDK].check_DeviceBinding = 0x02;
    
    [[STW_BLEService sharedInstance] scanStop];
    
    if ([STW_BLEService sharedInstance].isBLEStatus)
    {
        //停止闪灯
        [STW_BLE_Protocol the_check_device:0x02];

        //断开连接
//        NSLog(@"------------- 主动断开与蓝牙的连接 7-----------------");
        [[STW_BLEService sharedInstance] disconnect];
        [STW_BLEService sharedInstance].isBLEStatus = NO;
        [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
        //断开连接的回调
        [self Ble_disconnectHandler];
    }
    
    [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
    
    //将断开连接传递给主界面
    [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeOn;
    
    MainTabBarViewController *mainView = [self.storyboard instantiateViewControllerWithIdentifier:@"mains"];
    self.view.window.rootViewController = mainView;
}

- (void)setupRadarView
{
//    CGRect frame = self.view.bounds;
//    frame.size.height = frame.size.height - 65.0f;
    YXRadarView *radarView = [[YXRadarView alloc] initWithFrame:self.view.bounds];
//    radarView.radius = 150;
    radarView.radius = (SCREEN_WIDTH - 20.0f)/2;
    radarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:radarView];
    
    self.radarView = radarView;
    
    // 目标点位置
    [self.radarView scan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

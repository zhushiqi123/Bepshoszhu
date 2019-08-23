//
//  ViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/22.
//  Copyright © 2016年 TYZ. All rights reserved.
//
//
//  If you need to add more features or command, You should to update the STW_BLE_SDK.a
//  We will continue to provide support for you, So please do not edit file of TYZ_BLE.
//

#import "ViewController.h"
#import "TYZ_BLE_Service.h"
#import "TYZ_BLE_Protocol.h"
#import "TYZ_Session.h"
#import "ProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //layout  size
    [self.vapedView1_width setConstant:(ViewWidth/2)];
    [self.vapedView1_height setConstant:((ViewWidth/3))];
    [self.vapedBtn1_width setConstant:(((ViewWidth/2)/3))];
    [self.vapedBtn1_height setConstant:(((ViewWidth/2)/3))];
    
    [self.flavourView2_width setConstant:(ViewWidth/2)];
    [self.flavourView2_height setConstant:((ViewWidth/3))];
    [self.flavourBtn2_width setConstant:(((ViewWidth/2)/3))];
    [self.flavourBtn2_height setConstant:(((ViewWidth/2)/3))];
    
    [self.dashView3_width setConstant:(ViewWidth/2)];
    [self.dashView3_height setConstant:((ViewWidth/3))];
    [self.dashBtn3_width setConstant:(((ViewWidth/2)/3))];
    [self.dashBtn3_height setConstant:(((ViewWidth/2)/3))];
    
    [self.shopView4_width setConstant:(ViewWidth/2)];
    [self.shopView4_height setConstant:((ViewWidth/3))];
    [self.shopBtn4_width setConstant:(((ViewWidth/2)/3))];
    [self.shopBtn4_height setConstant:(((ViewWidth/2)/3))];
    
    [self build_ble_status];
    
    [self check_BLE_TYPE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Them all on the main thread
    /**
     *  蓝牙连接成功之后的回调
     *
     *  @return 连接蓝牙成功的信息 此时可以进行数据的初始查询操作
     */
    [TYZ_BLE_Service sharedInstance].discoverCharacteristicsForServiceHandler = ^()
    {
        NSLog(@"deviceMac - %@",[TYZ_BLE_Service sharedInstance].device.deviceMac);
        
        //The Ble is Connect Success
        [TYZ_BLE_Service sharedInstance].Status_Connect = BLEConnectStatusOn;
        //connect ble MAC
        [TYZ_BLE_Service sharedInstance].disonnect_deviceMac = [TYZ_BLE_Service sharedInstance].device.deviceMac;
        
        [self build_ble_status];
        //初始查询，发送初始查询信息
        [TYZ_BLE_Protocol initial_query];
        
        //设置时间 - 延时 100ms 执行
        double delayInSeconds = 0.1f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           //延时方法
                           [TYZ_BLE_Protocol sendData_D6];
                       });
    };
    
    /**
     *  断开蓝牙的回调  - Should be placed your need
     *  但是我们已经做了处理  - But we have done a deal with, so you don't need to worry about sudden disconnect.
     *  @return 断开蓝牙的信息
     */
    [TYZ_BLE_Service sharedInstance].disconnectHandler = ^()
    {
        NSLog(@"BLE Disconnect");
        
//        [ProgressHUD showError:@"BLE Disconnect"];
        
        [TYZ_Session sharedInstance].check_BLE_status = 1;
        
        //The Ble is disconnect,We need reconnect it
        if ([TYZ_BLE_Service sharedInstance].Status_Connect == BLEConnectStatusOn)
        {
            [self reconnect_ble];
        }
        
        [self build_ble_status];
    };
    
    /**
     *  预设吸烟口数
     *
     *  @param smoke_bools  预设吸烟口数使能
     *  @param smoke_actual 吸烟口预设数值 1 ~ 30
     *  @param smoke_expect 吸烟口数实际值 0 ~ 255
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD1 = ^(int smoke_bools,int smoke_actual,int smoke_expect)
    {
        NSLog(@"smoke_bools - %d,smoke_actual - %d,smoke_expect - %d",smoke_bools,smoke_actual,smoke_expect);
        [TYZ_Session sharedInstance].tion_alarm = smoke_bools;
        [TYZ_Session sharedInstance].tion_alarm_num = smoke_expect;
    };
    
    /**
     *  设置输出电压
     *
     *  @param output_voltage 输出电压 3.2V ~ 4.2V (32 - 42)
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD2 = ^(int output_voltage)
    {
        NSLog(@"output_voltage - %d",output_voltage);
        [TYZ_Session sharedInstance].power_mode = output_voltage;
    };
    
    /**
     *  电池信息管理
     *
     *  @param battery        电池电压 0V ~ 4.2V (0 - 42)
     *  @param battery_status 电池状态 0:正常 1:充电 2:充满
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD3 = ^(int battery,int battery_status)
    {
        NSLog(@"电池电量 - battery - %d,battery_status - %d",battery,battery_status);
        [TYZ_Session sharedInstance].battery = battery;
        [TYZ_Session sharedInstance].battery_status = battery_status;
    };
    
    /**
     *  吸烟总口数
     *
     *  @param smoke_all_number 吸烟总口数 (0x2075 = 8309)
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD4 = ^(int smoke_all_number)
    {
        NSLog(@"smoke_all_number - %d",smoke_all_number);
        [TYZ_Session sharedInstance].smoke_all_number = smoke_all_number;
    };
    
    /**
     *  电子烟是否锁机  - device -lock
     *
     *  @param lock     开锁机状态 0:开机 1:锁机
     *  @param lock_way 锁机方式 0:蓝牙锁机 1:按键锁机
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD5 = ^(int lock,int lock_way)
    {
        NSLog(@"lock - %d,lock_way - %d",lock,lock_way);
        [TYZ_Session sharedInstance].lock_device = lock;
    };
    
    /**
     *  设置时间 - set time
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD6 = ^(NSArray *array)
    {
        //no back data
    };
    
    /**
     *  读取历史数据 - get record
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD7 = ^(NSString *strings,int recordNum)
    {
        //back data for ChartViewController
    };
    
    /**
     *  修改设备名称  update deviceName
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD8 = ^(int checkNum)
    {
        //If you want to get the back data, You need implement this method (The above are all the same)
    };
}

/**
 *  构建蓝牙连接状态图标显示
 */
-(void)build_ble_status
{
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        [self.btn_find setBackgroundImage:[UIImage imageNamed:@"icon_search_on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btn_find setBackgroundImage:[UIImage imageNamed:@"icon_search_off"] forState:UIControlStateNormal];
    }
}

-(void)check_BLE_TYPE
{
    if ([TYZ_BLE_Service sharedInstance].Status_Connect == BLEConnectStatusLoding)
    {
        [self reconnect_ble];
    }
}

/**
 *  重新连接 - reconnect
 */
-(void)reconnect_ble
{
    NSLog(@"reconnect - BLEDeice");
    //waiting BLE Connect - 等待蓝牙连接
    [TYZ_BLE_Service sharedInstance].Status_Connect = BLEConnectStatusLoding;
    //start scan the BLE - 开始扫描蓝牙
    [[TYZ_BLE_Service sharedInstance] scanStart];
    //connect BLE
    [self addBleConnect];
}

//连接设备
-(void)addBleConnect
{
    //get Device to Scan
    [TYZ_BLE_Service sharedInstance].scanHandler = ^(TYZ_BLE_Device *device)
    {
        if ([TYZ_BLE_Service sharedInstance].Status_Connect == BLEConnectStatusLoding)
        {
            NSLog(@"device.deviceMac - %@",device.deviceMac);
            NSLog(@"disonnect_deviceMac - %@",[TYZ_BLE_Service sharedInstance].disonnect_deviceMac);
            if ([device.deviceMac isEqualToString: [TYZ_BLE_Service sharedInstance].disonnect_deviceMac])
            {
                //connect Device
                [[TYZ_BLE_Service sharedInstance] connect:device];
            }
        };
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

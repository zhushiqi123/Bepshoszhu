//
//  BLEHomeRightViewController.m
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "BLEHomeRightViewController.h"
#import "STW_BLE.h"
#import "HomeViewController.h"
#import "STW_DeviceData.h"
#import "STW_Data_Plist.h"
#import "HomeViewController.h"
#import "ChooseViewController.h"

@interface BLEHomeRightViewController ()

@end

@implementation BLEHomeRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置Sider的最大最小值
    self.brightness_sider.minimumValue = 1;
    self.brightness_sider.maximumValue = 100;
    //这个属性设置为YES则在滑动时，其value就会随时变化，设置为NO，则当滑动结束时，value才会改变。
    self.brightness_sider.continuous = YES;
    
    //设置颜色视图
    [self setColorView];

    //设置游戏按钮点击事件
    [self addGameOnclick];
    
    //设置震动强度按钮样式
    self.vibrate_btn.layer.borderWidth = 1.5f;
    self.vibrate_btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.vibrate_btn.layer.cornerRadius = 15.0f;
    [self.vibrate_btn.layer setMasksToBounds:YES];
    
    //设置移除设备按钮样式
    [self.remove_btn setTitleColor:RGBCOLOR(183, 36, 28) forState:UIControlStateNormal];
    
    self.remove_btn.layer.borderWidth = 1.5f;
    self.remove_btn.layer.borderColor = [RGBCOLOR(183, 36, 28) CGColor];
    
    self.remove_btn.layer.cornerRadius = 10.0f;
    [self.remove_btn.layer setMasksToBounds:YES];
    
    //设置视图上面的信息
    //亮灯模式
    [self setColorViewBackground:[STW_BLE_SDK sharedInstance].deviceData.lamp_model];
    
    //亮度设置
    int key_brightness = [STW_BLE_SDK sharedInstance].deviceData.brightness_value;
    [self.brightness_sider setValue:key_brightness];
    self.brightness_lable.text = [NSString stringWithFormat:@"BRIGHTNESS - %d%%",key_brightness];
    [self.brightness_sider addTarget:self action:@selector(end_slider:) forControlEvents:UIControlEventTouchUpInside];
    [self.brightness_sider addTarget:self action:@selector(end_slider:) forControlEvents:UIControlEventTouchUpOutside];
    [self.brightness_sider addTarget:self action:@selector(end_slider:) forControlEvents:UIControlEventTouchCancel];
    
    //游戏模式
    [self setGameImage:[STW_BLE_SDK sharedInstance].deviceData.game_model];
    
    //是否锁机
    [self set_lock_func:[STW_BLE_SDK sharedInstance].deviceData.boot_status];
    
    //震动强度
    [self set_vibrate_func:[STW_BLE_SDK sharedInstance].deviceData.vibration_value];
    
    //设置蓝牙监听
    [self setBLELestion];
}

-(void)setBLELestion
{
    //亮灯的颜色模式
    [STW_BLE_SDK sharedInstance].BLEServiceLampModel = ^(int LampModel)
    {
        [STW_BLE_SDK sharedInstance].deviceData.lamp_model = LampModel;
        //亮灯模式
        [self setColorViewBackground:[STW_BLE_SDK sharedInstance].deviceData.lamp_model];
    };
    
    //亮度百分比
    [STW_BLE_SDK sharedInstance].BLEServicebBrightness = ^(int brightness_value)
    {
        [STW_BLE_SDK sharedInstance].deviceData.brightness_value = brightness_value;
        //亮度设置
        int key_brightness = [STW_BLE_SDK sharedInstance].deviceData.brightness_value;
        [self.brightness_sider setValue:key_brightness];
        self.brightness_lable.text = [NSString stringWithFormat:@"BRIGHTNESS - %d%%",key_brightness];
    };
    
    //开关机信息
    [STW_BLE_SDK sharedInstance].BLEServiceDeviceRoot = ^(BootStatus Root)
    {
        [STW_BLE_SDK sharedInstance].deviceData.boot_status = Root;
        [self set_lock_func:[STW_BLE_SDK sharedInstance].deviceData.boot_status];
    };
    
    //震动强度百分比
    [STW_BLE_SDK sharedInstance].BLEServiceVibration = ^(int vibration)
    {
        [STW_BLE_SDK sharedInstance].deviceData.vibration_value = vibration;
         [self set_vibrate_func:[STW_BLE_SDK sharedInstance].deviceData.vibration_value];
    };
    
    //游戏模式
    [STW_BLE_SDK sharedInstance].BLEServiceGameModel = ^(int game_model)
    {
        [STW_BLE_SDK sharedInstance].deviceData.game_model = game_model;
        [self setGameImage:game_model];
    };
}

//设置颜色视图
-(void)setColorView
{
    //第一个视图
    self.color_view_01.layer.borderWidth = 3.0f;
    self.color_view_01.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.color_view_01.layer.cornerRadius = 17.0f;
    [self.color_view_01.layer setMasksToBounds:YES];
    self.color_view_01.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_color_01 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(color_function_01)];
    [self.color_view_01 addGestureRecognizer:onclick_color_01];
    
    //第二个视图
    self.color_view_02.layer.borderWidth = 3.0f;
    self.color_view_02.layer.borderColor = [RGBCOLOR(50, 34, 192) CGColor];
    self.color_view_02.layer.cornerRadius = 17.0f;
    [self.color_view_02.layer setMasksToBounds:YES];
    self.color_view_02.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_color_02 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(color_function_02)];
    [self.color_view_02 addGestureRecognizer:onclick_color_02];
    
    //第三个视图
    self.color_view_03.layer.borderWidth = 3.0f;
    self.color_view_03.layer.borderColor = [RGBCOLOR(251, 218, 102) CGColor];
    self.color_view_03.layer.cornerRadius = 17.0f;
    [self.color_view_03.layer setMasksToBounds:YES];
    self.color_view_03.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_color_03 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(color_function_03)];
    [self.color_view_03 addGestureRecognizer:onclick_color_03];
    
    //第四个视图
    self.color_view_04.layer.borderWidth = 3.0f;
    self.color_view_04.layer.borderColor = [RGBCOLOR(226, 11, 16) CGColor];
    self.color_view_04.layer.cornerRadius = 17.0f;
    [self.color_view_04.layer setMasksToBounds:YES];
    self.color_view_04.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_color_04 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(color_function_04)];
    [self.color_view_04 addGestureRecognizer:onclick_color_04];
    
}

//第一个颜色
-(void)color_function_01
{
    if([STW_BLE_SDK sharedInstance].deviceData.lamp_model != 0)
    {
        //发送蓝牙命令
        [STW_BLE_SDK sharedInstance].deviceData.lamp_model = 0;
        [[STW_BLE_SDK sharedInstance] the_lamp_mode:0];
        [self setColorViewBackground:0];
    }
}

//第二个颜色
-(void)color_function_02
{
    if([STW_BLE_SDK sharedInstance].deviceData.lamp_model != 1)
    {
        //发送蓝牙命令
        [STW_BLE_SDK sharedInstance].deviceData.lamp_model = 1;
        [self setColorViewBackground:1];
        [[STW_BLE_SDK sharedInstance] the_lamp_mode:1];
    }
}

//第三个颜色
-(void)color_function_03
{
    if([STW_BLE_SDK sharedInstance].deviceData.lamp_model != 2)
    {
        //发送蓝牙命令
        [STW_BLE_SDK sharedInstance].deviceData.lamp_model = 2;
        [self setColorViewBackground:2];
        [[STW_BLE_SDK sharedInstance] the_lamp_mode:2];
    }
}

//第四个颜色
-(void)color_function_04
{
    if([STW_BLE_SDK sharedInstance].deviceData.lamp_model != 3)
    {
        //发送蓝牙命令
        [STW_BLE_SDK sharedInstance].deviceData.lamp_model = 3;
        [self setColorViewBackground:3];
        [[STW_BLE_SDK sharedInstance] the_lamp_mode:3];
    }
}

//选择灯的颜色
-(void)setColorViewBackground:(int)num
{
    //第一个视图
    if (num == 0) {
        self.color_view_01.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.color_view_01.backgroundColor = [UIColor clearColor];
    }
    //第二个视图
    if (num == 1) {
        self.color_view_02.backgroundColor = RGBCOLOR(50, 34, 192);
    }
    else
    {
        self.color_view_02.backgroundColor = [UIColor clearColor];
    }
    //第三个视图
    if (num == 2) {
        self.color_view_03.backgroundColor = RGBCOLOR(251, 218, 102);
    }
    else
    {
        self.color_view_03.backgroundColor = [UIColor clearColor];
    }
    //第四个视图
    if (num == 3) {
        self.color_view_04.backgroundColor = RGBCOLOR(226, 11, 16);
    }
    else
    {
        self.color_view_04.backgroundColor = [UIColor clearColor];
    }
}

//为游戏添加点击事件
-(void)addGameOnclick
{
    //游戏模式1
    self.game_image_01.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_game_image_01 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(game_image_function_01)];
    [self.game_image_01 addGestureRecognizer:onclick_game_image_01];
    
    //游戏模式2
    self.game_image_02.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_game_image_02 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(game_image_function_02)];
    [self.game_image_02 addGestureRecognizer:onclick_game_image_02];
    
    //游戏模式3
    self.game_image_03.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_game_image_03 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(game_image_function_03)];
    [self.game_image_03 addGestureRecognizer:onclick_game_image_03];
}

//游戏模式1
-(void)game_image_function_01
{
    if([STW_BLE_SDK sharedInstance].deviceData.game_model != 1)
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:1];
        [self setGameImage:1];
    }
    else
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:0];
        [self setGameImage:0];
    }
}

//游戏模式2
-(void)game_image_function_02
{
    if([STW_BLE_SDK sharedInstance].deviceData.game_model != 2)
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:2];
        [self setGameImage:2];
    }
    else
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:0];
        [self setGameImage:0];
    }
}

//游戏模式2
-(void)game_image_function_03
{
    if([STW_BLE_SDK sharedInstance].deviceData.game_model != 3)
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:3];
        [self setGameImage:3];
    }
    else
    {
        //发送蓝牙命令
        [[STW_BLE_SDK sharedInstance] the_set_game_model:0];
        [self setGameImage:0];
    }
}


//游戏模式刷新
-(void)setGameImage:(int)num
{
    NSLog(@"游戏模式 - %d",num);
    //游戏模式1
    if (num == 1) {
        self.game_image_01.image = [UIImage imageNamed:@"game_paxrun"];
    }
    else{
        self.game_image_01.image = [UIImage imageNamed:@"game_paxrun_off"];
    }
    
    //游戏模式2
    if (num == 2) {
        self.game_image_02.image = [UIImage imageNamed:@"game_paxsays"];
    }
    else{
        self.game_image_02.image = [UIImage imageNamed:@"game_paxsays_off"];
    }
    
    //游戏模式3
    if (num == 3) {
        self.game_image_03.image = [UIImage imageNamed:@"game_paxspin"];
    }
    else{
        self.game_image_03.image = [UIImage imageNamed:@"game_paxspin_off"];
    }
}

//视图 - 开关机
-(void)set_lock_func:(int)key_num
{
    if(key_num == 0x00)
    {
        //关机
        [_lock_btn setOn:YES];
    }
    else
    {
        //开机
        [_lock_btn setOn:NO];
    }
}

//视图 - 震动强度
-(void)set_vibrate_func:(int)key_num
{
    if(key_num == 0)
    {
        [_vibrate_btn setTitle:@"OFF" forState:UIControlStateNormal];
    }else if(key_num > 0 && key_num <= 50)
    {
        [_vibrate_btn setTitle:@"SOFT" forState:UIControlStateNormal];
    }
    else
    {
        [_vibrate_btn setTitle:@"HIGH" forState:UIControlStateNormal];
    }
}

//开锁机方法
- (IBAction)lock_btn_onclick:(id)sender {
    //进行开锁机
    NSLog(@"进行开锁机");
    //发送开锁机命令
    if ([STW_BLE_SDK sharedInstance].deviceData.boot_status == 0x00) {
        //开机
        [STW_BLE_SDK sharedInstance].deviceData.boot_status = 0x01;
        [[STW_BLE_SDK sharedInstance] the_boot_bool:0x01];
    }
    else
    {
        //关机
        [STW_BLE_SDK sharedInstance].deviceData.boot_status = 0x00;
        [[STW_BLE_SDK sharedInstance] the_boot_bool:0x00];
    }
}

//震动强度方法
- (IBAction)vibrate_btn_onclick:(id)sender {
    //设置震动强度
    NSLog(@"设置震动强度");
    int key_num = [STW_BLE_SDK sharedInstance].deviceData.vibration_value;
    
    if(key_num == 0)
    {
        //发送命令
        [[STW_BLE_SDK sharedInstance] the_motor:50];
        [STW_BLE_SDK sharedInstance].deviceData.vibration_value = 50;
        
    }else if(key_num > 0 && key_num <= 50)
    {
        [STW_BLE_SDK sharedInstance].deviceData.vibration_value = 100;
        //发送命令
        [[STW_BLE_SDK sharedInstance] the_motor:100];
    }
    else
    {
        //发送命令
        [[STW_BLE_SDK sharedInstance] the_motor:0];
        [STW_BLE_SDK sharedInstance].deviceData.vibration_value = 0;
    }
}

//移除设备的方法
- (IBAction)remove_btn_onclick:(id)sender {
    NSLog(@"移除设备");
    //删除设备
    //保存
    NSMutableArray *arrysFile = [NSMutableArray array];
    
    for(STW_DeviceData *deviceData in [STW_BLE_SDK sharedInstance].bindingDevices)
    {
        if (![deviceData.device_mac isEqualToString:[STW_BLE_SDK sharedInstance].device.deviceMac]) {
            [arrysFile addObject:deviceData];
        }
    }
    
    //重新将数据写入列表
    [STW_BLE_SDK sharedInstance].bindingDevices = [NSMutableArray array];
    [STW_BLE_SDK sharedInstance].bindingDevices = arrysFile;
    
    [STW_Data_Plist SaveDeviceData:arrysFile];
    
    //断开蓝牙连接
    [[STW_BLE_SDK sharedInstance] disconnect];
    
    if (arrysFile!=NULL && arrysFile.count >0) {
        //返回Home 界面
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    }
    else
    {
        //返回绑定界面
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    }
}

- (IBAction)brightness_sider_func:(id)sender {
    int key_value = (int)[self.brightness_sider value];
    self.brightness_lable.text = [NSString stringWithFormat:@"BRIGHTNESS - %d%%",key_value];
}

-(void)end_slider:(id)sender {
    int key_value = (int)[self.brightness_sider value];
    self.brightness_lable.text = [NSString stringWithFormat:@"BRIGHTNESS - %d%%",key_value];
    
    //发送数据
    [STW_BLE_SDK sharedInstance].deviceData.brightness_value = key_value;
    [[STW_BLE_SDK sharedInstance] the_brightness:key_value];
}

- (void)didReceiveMemoryWarning {
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

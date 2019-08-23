//
//  AddDeviceViewController.m
//  PAX3
//
//  Created by tyz on 17/5/3.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "STW_BLE.h"
#import "STW_DeviceData.h"
#import "ChangeNameViewController.h"
#import "HomeViewController.h"
#import "UIView+MJAlertView.h"

@interface AddDeviceViewController ()
{
    UIImageView *pairingImageView;
    
    UIImageView *pairingImageView_01;
    
    UIImageView *pairingImageView_02;
    
    float shakView_height;
    float pairingView_height;
    float pairingView_width;
    
    CGPoint pairingView_center;
    
    //循环动画
    NSTimer *animation_timer;
    
    //页面是否已经跳转一次
    BOOL Modal_status;
}

@end

@implementation AddDeviceViewController

//页面即将出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始动画
    if(animation_timer)
    {
        [animation_timer invalidate];
        animation_timer=nil;
    }
    
    //主动延时 - GDC
    double delayInSeconds = 1.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [self animation_timer_func];
                       //4秒之后再次执行
                       animation_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(animation_timer_func) userInfo:nil repeats:YES];
                   });
}

//页面即将隐藏
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //结束动画
    if(animation_timer)
    {
        [animation_timer invalidate];
        animation_timer=nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Modal_status = NO;
    
    shakView_height = (SCREEN_HEIGHT - 234.0f);
    pairingView_height = shakView_height - 16.0f;
    pairingView_width = (pairingView_height * 382.0f)/1042.0f;
    pairingView_center = CGPointMake((SCREEN_WIDTH - 16.0f)/2.0f, (SCREEN_HEIGHT - 250.0f)/2.0f);
    
    //添加底部按钮
    [self addpaxButton];
    //添加摇晃视图
    [self add_shakingView];
}

//添加摇晃视图
-(void)add_shakingView
{
    pairingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pairingView_width, pairingView_height)];
    pairingImageView.center = CGPointMake(pairingView_center.x, pairingView_center.y + (pairingView_height/2.0f));
    pairingImageView.image = [UIImage imageNamed:@"pairing_pax3"];
    pairingImageView.layer.anchorPoint= CGPointMake(0.5, 1);
    
    //闪烁视图1
    pairingImageView_01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pairingView_width, pairingView_height)];
    pairingImageView_01.center = pairingView_center;
    pairingImageView_01.image = [UIImage imageNamed:@"pairing_pax3_lights1"];
    
    //闪烁视图2
    pairingImageView_02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pairingView_width, pairingView_height)];
    pairingImageView_02.center = pairingView_center;
    pairingImageView_02.image = [UIImage imageNamed:@"pairing_pax3_lights2"];
    
    
    [self.add_animation_view addSubview:pairingImageView];
    [self.add_animation_view addSubview:pairingImageView_01];
    [self.add_animation_view addSubview:pairingImageView_02];
    
    /***** 闪烁动画 *************************************************/
    CABasicAnimation *flashing_animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    flashing_animation.fromValue = [NSNumber numberWithFloat:0.0f];
    flashing_animation.toValue = [NSNumber numberWithFloat:1.0f];//这是透明度。
    flashing_animation.autoreverses = YES;
    flashing_animation.duration = 0.05;
    flashing_animation.repeatCount = 1;
    flashing_animation.removedOnCompletion = NO;
    flashing_animation.fillMode = kCAFillModeForwards;
    flashing_animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    
    [pairingImageView_01.layer addAnimation:flashing_animation forKey:nil];
    [pairingImageView_02.layer addAnimation:flashing_animation forKey:nil];
}

//底部按钮
-(void)addpaxButton
{
    UIButton *paxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220,50.0f)];
    paxButton.backgroundColor = [UIColor whiteColor];
    paxButton.center = CGPointMake(SCREEN_WIDTH/2.0f, 30.0f);
    [paxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [paxButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    
    paxButton.layer.borderWidth = 1.5f;
    paxButton.layer.borderColor = [[UIColor blackColor] CGColor];
    
    paxButton.layer.cornerRadius = 5.0f;
    [paxButton.layer setMasksToBounds:YES];
    
    [paxButton setTitle:@"Don't hava a PAX?" forState:UIControlStateNormal];
    [paxButton addTarget:self action:@selector(paxButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.end_view addSubview:paxButton];
}

//为PairingView添加动画
-(void)addPairingAnimation
{
    float times_shake = 0.3f;
    float times_flashing = 0.2f;
    
    /***** 摇晃动画 *************************************************/
    CAKeyframeAnimation * shakeAnimaion = [CAKeyframeAnimation animation];
    shakeAnimaion.keyPath = @"transform.rotation";
    shakeAnimaion.values = @[@(0 / 180.0 * M_PI),@(10 / 180.0 * M_PI),@(0 / 180.0 * M_PI),@(-10 /180.0 * M_PI),@(0/ 180.0 * M_PI)];//度数转弧度
    shakeAnimaion.removedOnCompletion = NO;
    shakeAnimaion.fillMode = kCAFillModeRemoved;
    shakeAnimaion.duration = times_shake;
    shakeAnimaion.repeatCount = 4;
    
    /***** 闪烁动画 *************************************************/
    CABasicAnimation *flashing_animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    flashing_animation.fromValue = [NSNumber numberWithFloat:0.0f];
    flashing_animation.toValue = [NSNumber numberWithFloat:1.0f];//这是透明度。
    flashing_animation.autoreverses = YES;
    flashing_animation.duration = times_flashing;
    flashing_animation.repeatCount = 1;
    flashing_animation.removedOnCompletion = NO;
    flashing_animation.fillMode = kCAFillModeForwards;
    flashing_animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    
    [pairingImageView.layer addAnimation:shakeAnimaion forKey:nil];
    

    //主动延时
    double delayInSeconds8 = times_flashing * 5.0f;
    dispatch_time_t popTime8 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds8 * NSEC_PER_SEC));
    dispatch_after(popTime8, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_01.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds = (times_flashing * 5.0f) + (times_flashing * 1.0f);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_02.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds2 = (times_flashing * 5.0f) + (times_flashing * 2.0f);
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_01.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds3 = (times_flashing * 5.0f) + (times_flashing * 3.0f);
    dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds3 * NSEC_PER_SEC));
    dispatch_after(popTime3, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_02.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds4 = (times_flashing * 5.0f) + (times_flashing * 4.0f);
    dispatch_time_t popTime4 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds4 * NSEC_PER_SEC));
    dispatch_after(popTime4, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_01.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds5 = (times_flashing * 5.0f) + (times_flashing * 5.0f);
    dispatch_time_t popTime5 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds5 * NSEC_PER_SEC));
    dispatch_after(popTime5, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_02.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds6 = (times_flashing * 5.0f) + (times_flashing * 6.0f);
    dispatch_time_t popTime6 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds6 * NSEC_PER_SEC));
    dispatch_after(popTime6, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_01.layer addAnimation:flashing_animation forKey:nil];
                   });
    
    //主动延时
    double delayInSeconds7 = (times_flashing * 5.0f) + (times_flashing * 7.0f);
    dispatch_time_t popTime7 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds7 * NSEC_PER_SEC));
    dispatch_after(popTime7, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [pairingImageView_02.layer addAnimation:flashing_animation forKey:nil];
                   });
}

-(void)paxButtonClick
{
//    NSLog(@"paxButtonClick");
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:view animated:YES completion:nil];
//    [UIView addMJNotifierWithText:@"Frist,Make a PAX?" dismissAutomatically:YES];
}

//循环动画
-(void)animation_timer_func
{
    if ([STW_BLE_SDK sharedInstance].stw_isBLEType == STW_BLE_IsBLETypeOff) {
         NSLog(@"手动扫描蓝牙 - AddDevice");
        //开始进行蓝牙扫描
        [[STW_BLE_SDK sharedInstance] scanStart];
        //注册扫描到设备的回调
        [self scanDeviceListen];
        
        [self addPairingAnimation];
    }
}

-(void)scanDeviceListen
{
    //扫描到蓝牙设备的回调
    [STW_BLE_SDK sharedInstance].BLEServiceScanHandler = ^(STW_BLE_Device *device)
    {
//        NSLog(@"device - %@",device.deviceName);
        if ([STW_BLE_SDK sharedInstance].bindingDevices.count > 0) {
            BOOL isDevice = YES;
            //判断是否已经存在此设备
            for (STW_DeviceData *deviceData in [STW_BLE_SDK sharedInstance].bindingDevices) {
                if ([deviceData.device_mac isEqualToString:device.deviceMac]) {
                    isDevice = NO;
                    break;
                }
            }
            
            if (isDevice) {
                //开始进行连接 - 列表不存在设备
                [[STW_BLE_SDK sharedInstance] connect:device];
            }
        }
        else
        {
            //开始进行连接 - 列表为空
            [[STW_BLE_SDK sharedInstance] connect:device];
        }
    };
    
    //获取所有信息的回调
    [STW_BLE_SDK sharedInstance].BLEServiceAllDatas = ^(int work_model,int tmp_model,int tmp_max,int tmp_now,int lamp_model,int brightness_value,int game_model,int boot_status,int vibration_value,int pax_color ,int pax_battery){
        [STW_BLE_SDK sharedInstance].device.deviceColor = pax_color;
        [STW_BLE_SDK sharedInstance].deviceData = [STW_BLE_Model STW_BLE_ModelInit:work_model tmp_model:tmp_model tmp_max:tmp_max tmp_now:tmp_now lamp_model:lamp_model brightness_value:brightness_value game_model:game_model boot_status:boot_status vibration_value:vibration_value pax_color:pax_color pax_battery:pax_battery];
    };
    
    //蓝牙连接成功的回调
    [STW_BLE_SDK sharedInstance].BLEServiceDiscoverCharacteristicsForServiceHandler = ^(int deviceColor)
    {
        if(!Modal_status)
        {
            //已经进行跳转
            Modal_status = YES;
            
//            NSLog(@"蓝牙已经连接");
            //开始动画
            if(animation_timer)
            {
                [animation_timer invalidate];
                animation_timer=nil;
            }
            
            [STW_BLE_SDK sharedInstance].deviceData.pax_color = deviceColor;
            
            NSLog(@"机身颜色 -- %d",deviceColor);
            //跳转进行名称修改
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChangeNameViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ChangeNameViewController"];
            [view setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            view.color_device = deviceColor;
            
            UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
            
            // 在这里加一个这个样式的循环
            while (topRootViewController.presentedViewController)
            {
                // 这里固定写法
                topRootViewController = topRootViewController.presentedViewController;
            }
            // 然后再进行present操作
            [topRootViewController presentViewController:view animated:YES completion:nil];
        }
    };
}

//返回按钮事件
- (IBAction)back_btn_onclick:(id)sender {
    //跳转返回
    [self dismissViewControllerAnimated:YES completion:nil];
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

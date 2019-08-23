//
//  BLEHomeViewController.m
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "BLEHomeViewController.h"
#import "HomeViewController.h"
#import "BLEHomeRightViewController.h"
#import "BELHomeBackgroundView.h"
#import "CLPresent.h"
#import "ChooseModelViewCards.h"
#import "ChooseTempView.h"
#import "STW_BLE.h"

@interface BLEHomeViewController ()
{
    int index_path_row;
}

//模式背景
@property (nonatomic,strong) UIImageView *model_imageView;
//选择模式
@property (nonatomic,strong) UIImageView *ChooseModelImage;
//选择加热模式视图
@property (nonatomic,strong) ChooseModelViewCards *chooseModel_cardSwitchView;
//选择加热最高温度视图
@property (nonatomic,strong) ChooseTempView *chooseTempView;
//模式列表
@property (nonatomic,strong) NSArray *chooseModel_dicAry;
//模式列表
@property (nonatomic,strong) NSTimer *battery_animation_time;

@property (nonatomic,strong) NSArray *lable1_dicAry;
@property (nonatomic,strong) NSArray *lable2_dicAry;
@property (nonatomic,strong) NSArray *lable3_dicAry;

@end

@implementation BLEHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //查询所有配置信息
    [[STW_BLE_SDK sharedInstance] the_work_mode];
    
    //主动延时
//    double delayInSeconds = 1.0f;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//                   {
//                       //延时方法
//                       [[STW_BLE_SDK sharedInstance] the_find_battery];
//                   });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _battery_animation_time = nil;
    
    //设置背景视图
    self.backView = [[BELHomeBackgroundView alloc] initWithFrame:self.view.bounds :RGBCOLOR(56, 13, 58) :RGBCOLOR(2, 27, 218)];
    [self.view addSubview:self.backView];
    //将视图放到最底层
    [self.view sendSubviewToBack:self.backView];
    
    //电池视图设置透明
    self.battery_view.alpha = 0.6;
    self.battery_view.image = [UIImage imageNamed:[self battery_view_key:[STW_BLE_SDK sharedInstance].deviceData.pax_battery]];
    
    //设置电子烟名称
    self.device_name_lable.text = [STW_BLE_SDK sharedInstance].device.deviceName;
    
    //添加模式背景视图
    [self setModelViewBlackgroung];
    
    //添加加热模式选择
    [self addChooseImage];
    
    //温度调节视图
    [self tmp_model_view];
    
    //注册回调
    [self setListenFunc];
}

//设置背景视图
-(void)setModelViewBlackgroung
{
    self.lable1_dicAry = @[@"Easy",@"Boost",@"Efficiency",@"Stealth",@"Flavor"];
    self.lable3_dicAry = @[@"The default setting for PAX 3.",@"Keeps your device in high gear.",@"Don’t waste a drop.",@"For ultimate discretion.",@"The most delicious possible."];
    self.lable2_dicAry = @[@"Temp boosts when you draw, auto-cools when you don't.The perfect Standard.",@"Temp boosts aggressively and auto-cools slower.Get what you need with speed.",@"Temp setting ramps up gradually throughout your session in addition to Standard temp boost and auto-cooling.Economic and long-lasting.",@"LEDs dim, auto-cools fast.Reduced material odor means increased privacy.",@"Temp boosts more during draw and decreases quickly after draw.The most on-demand heating ever."];
    
    float view_height = SCREEN_WIDTH/3.0f + 20.0f;
    self.model_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, view_height, view_height)];
    self.model_imageView.center = CGPointMake(SCREEN_WIDTH/2.0f,(view_height/2.0f + 54.0f));
    self.model_imageView.image = [UIImage imageNamed:@"loadingx"];
    self.model_imageView.alpha = 0.6;
    self.model_imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.model_imageView];
    
    self.title_lableView.alpha = 0.0;
    self.title2_lableView.alpha = 0.0;
    self.title3_lableView.alpha = 0.0;
}

//温度调节视图
-(void)tmp_model_view
{
    self.choose_tmp_view.backgroundColor = [UIColor clearColor];
    _chooseTempView = [[ChooseTempView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT/2.0f - 120.f)) :[STW_BLE_SDK sharedInstance].deviceData.tmp_max :[STW_BLE_SDK sharedInstance].deviceData.tmp_now :[STW_BLE_SDK sharedInstance].deviceData.tmp_model];
    
//   _chooseTempView = [[ChooseTempView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT/2.0f - 120.f)) :400 :500 :1];
    
    [self.choose_tmp_view addSubview:_chooseTempView];
}

-(void)addChooseImage
{
    _chooseModel_cardSwitchView = [[ChooseModelViewCards alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0f)];
    _chooseModel_cardSwitchView.backgroundColor = [UIColor clearColor];
    [_chooseModel_cardSwitchView setCardSwitchViewAry:[self ittemsCardSwitchViewAry] delegate:self];
    [self.choose_modelView addSubview:_chooseModel_cardSwitchView];
    
    //刷新界面
    [_chooseModel_cardSwitchView SetChooviewNum:[STW_BLE_SDK sharedInstance].deviceData.work_model];
}

/**
 *  准备添加到卡片切换View上的View数组
 */
- (NSArray *)ittemsCardSwitchViewAry
{
    _chooseModel_dicAry = @[@"dynamic_easy_white",
                @"dynamic_boost_white",
                @"dynamic_efficiency_white",
                @"dynamic_stealth_white",
                @"dynamic_extraction_white"];
    
    float view_height = 60.0f;
    float view_width = 80.0f;
    
    NSMutableArray *ary = [NSMutableArray new];
    
    for (NSString *felicityDic in _chooseModel_dicAry) {
        NSInteger index = [_chooseModel_dicAry indexOfObject:felicityDic];
 
        NSString *imageStr = felicityDic;
       
        UIView *backImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.tag = index;
        
        UIImageView *chooseImageViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45.0f, 45.0f)];
        chooseImageViews.center = CGPointMake(view_width/2.0f, view_height/2.0f);
        chooseImageViews.image = [UIImage imageNamed:imageStr];
        [backImageView addSubview:chooseImageViews];
        
        [ary addObject:backImageView];
    }
    return ary;
}

#pragma mark HXCardSwitchViewDelegate
- (void)cardSwitchViewDidScroll:(ChooseModelViewCards *)cardSwitchView index:(NSInteger)index {
    if (index_path_row != index) {
        index_path_row = (int)index;
        NSLog(@"选中的加热模式为 - %d",index_path_row);
        //设置加热模式
        [self setWorkModelBLE:index_path_row];
        
        //变暗的动画
        for (UIView *view in cardSwitchView.cardSwitchScrollView.subviews) {
            NSInteger index = [cardSwitchView.cardSwitchScrollView.subviews indexOfObject:view];
            float view_apla = view.alpha;
            if (view_apla == 1.0) {
                if (index != cardSwitchView.currentIndex) {
                    //变暗动画
                    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
                    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
                    opacityAnimation.duration = 0.5f;
                    opacityAnimation.removedOnCompletion = NO;
                    [view.layer addAnimation:opacityAnimation forKey:nil];
                    
                    //主动延时
                    double delayInSeconds = 0.3f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                   {
                                       //延时方法
                                       view.alpha = 0.0;
                                   });
                }
            }
        }
    }
}

//Lable 显示
- (void)changeAplaToLable :(int)viewNum
{
    if (viewNum == -1) {
        //结束Lable 显示
        [self lableView_animation_on_off:NO];
    }
    else if(viewNum <= 4 && viewNum >= 0)
    {
        //显示Lable 5 数据
        [self setlableText:viewNum];
        [self lableView_animation_on_off:YES];
    }
}

- (void)changeArcNums :(int)viewNum
{
    //主动延时
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       //结束Lable 显示
                       self.model_imageView.alpha = 0.6;
                       self.title_lableView.alpha = 0.0;
                       self.title2_lableView.alpha = 0.0;
                       self.title3_lableView.alpha = 0.0;
                       
                       for (UIView *view in _chooseModel_cardSwitchView.cardSwitchScrollView.subviews) {
                           NSInteger index = [_chooseModel_cardSwitchView.cardSwitchScrollView.subviews indexOfObject:view];
                           if(index != viewNum){
                               view.alpha = 0.0;
                           }
                       }
                   });
}

-(void)setlableText :(int) nums
{
    self.title_lableView.text = _lable1_dicAry[nums];
    self.title2_lableView.text = _lable2_dicAry[nums];
    self.title3_lableView.text = _lable3_dicAry[nums];
}

-(void)lableView_animation_on_off :(BOOL)status_value
{
    if (status_value) {
//        NSLog(@"self.model_imageView.alpha - %f",self.model_imageView.alpha);
        if (self.model_imageView.alpha == 0.6) {
            [self.model_imageView.layer addAnimation:[self animation_lable:0.6f :0.0f] forKey:nil];
        }
//        [self.model_imageView.layer addAnimation:[self animation_lable:0.6f :0.0f] forKey:nil];
        [self.title_lableView.layer addAnimation:[self animation_lable:0.0f :1.0f] forKey:nil];
        [self.title2_lableView.layer addAnimation:[self animation_lable:0.0f :1.0f] forKey:nil];
        [self.title3_lableView.layer addAnimation:[self animation_lable:0.0f :1.0f] forKey:nil];
        
        //主动延时
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           //延时方法
                           self.model_imageView.alpha = 0.0;
                           self.title_lableView.alpha = 1.0;
                           self.title2_lableView.alpha = 1.0;
                           self.title3_lableView.alpha = 1.0;
                       });
    }
    else
    {
        [self.model_imageView.layer addAnimation:[self animation_lable:0.0f :0.6f] forKey:nil];
        [self.title_lableView.layer addAnimation:[self animation_lable:1.0f :0.0f] forKey:nil];
        [self.title2_lableView.layer addAnimation:[self animation_lable:1.0f :0.0f] forKey:nil];
        [self.title3_lableView.layer addAnimation:[self animation_lable:1.0f :0.0f] forKey:nil];
        
        //主动延时
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                            self.model_imageView.alpha = 0.6;
                            self.title_lableView.alpha = 0.0;
                            self.title2_lableView.alpha = 0.0;
                            self.title3_lableView.alpha = 0.0;
                       });
    }
}

-(CABasicAnimation *)animation_lable :(float)start_float :(float)end_float
{
    //变亮动画
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:start_float];
    opacityAnimation.toValue = [NSNumber numberWithFloat:end_float];
    opacityAnimation.duration = 0.5f;
    opacityAnimation.removedOnCompletion = NO;
    
    return opacityAnimation;
}

//选择加热模式的按钮
//-(void)setChooseImage:(int)num
//{
//    NSString *string_image = @"";
//    switch (num) {
//        case 1:
//            string_image = @"dynamic_easy_white";
//            break;
//        case 2:
//            string_image = @"dynamic_boost_white";
//            break;
//        case 3:
//            string_image = @"dynamic_efficiency_white";
//            break;
//        case 4:
//            string_image = @"dynamic_stealth_white";
//            break;
//        case 5:
//            string_image = @"dynamic_extraction_white";
//            break;
//        default:
//            break;
//    }
//}

//电池视图
-(NSString *)battery_view_key:(int)key_num
{
    NSString *ket_str;
    switch (key_num) {
        case 0:
            ket_str = @"battery_0";
            break;
        case 1:
            ket_str = @"battery_1";
            break;
        case 2:
            ket_str = @"battery_2";
            break;
        case 3:
            ket_str = @"battery_3";
            break;
        case 4:
            ket_str = @"battery_4";
            break;
            
        default:
            ket_str = @"battery_0";
            break;
    }
    
    return ket_str;
}

-(void)setWorkModelBLE:(int)key_num
{
    //设置加热模式
    [[STW_BLE_SDK sharedInstance] the_work_mode_setting:key_num];
}

-(void)setListenFunc
{
    //设置回调操作
    //断开蓝牙
    [STW_BLE_SDK sharedInstance].BLEServiceDisconnectHandler = ^()
    {
        //清空所有连接信息
        [STW_BLE_SDK sharedInstance].device = nil;
        [STW_BLE_SDK sharedInstance].deviceData = nil;
        
        //返回主页面
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    };
    
    //获取所有信息的回调
    [STW_BLE_SDK sharedInstance].BLEServiceAllDatas = ^(int work_model,int tmp_model,int tmp_max,int tmp_now,int lamp_model,int brightness_value,int game_model,int boot_status,int vibration_value,int pax_color ,int pax_battery){
        [STW_BLE_SDK sharedInstance].device.deviceColor = pax_color;
        [STW_BLE_SDK sharedInstance].deviceData = [STW_BLE_Model STW_BLE_ModelInit:work_model tmp_model:tmp_model tmp_max:tmp_max tmp_now:tmp_now lamp_model:lamp_model brightness_value:brightness_value game_model:game_model boot_status:boot_status vibration_value:vibration_value pax_color:pax_color pax_battery:pax_battery];
    };
    
    //加热模式
    [STW_BLE_SDK sharedInstance].BLEServiceWorkModel = ^(BLEProtocolModeType model_value){
        if ([STW_BLE_SDK sharedInstance].deviceData.work_model != model_value) {
            [STW_BLE_SDK sharedInstance].deviceData.work_model = model_value;
            //刷新界面
            [_chooseModel_cardSwitchView SetChooviewNum:[STW_BLE_SDK sharedInstance].deviceData.work_model];
        }
    };
    
    //发热杯最高温度
    [STW_BLE_SDK sharedInstance].BLEServiceTempMax = ^(int temp_model,int temp_value){
        if ([STW_BLE_SDK sharedInstance].deviceData.tmp_max != temp_value) {
            [STW_BLE_SDK sharedInstance].deviceData.tmp_max = temp_value;
            [STW_BLE_SDK sharedInstance].deviceData.tmp_model = temp_model;
            //刷新界面
            [_chooseTempView view_refresh:temp_value :[STW_BLE_SDK sharedInstance].deviceData.tmp_now :temp_model];
        }
    };
    
    //发热杯当前温度
    [STW_BLE_SDK sharedInstance].BLEServiceTempNow = ^(int temp_model,int temp_value)
    {
        if ([STW_BLE_SDK sharedInstance].deviceData.tmp_now != temp_value) {
            [STW_BLE_SDK sharedInstance].deviceData.tmp_now = temp_value;
            
            //刷新界面
            [_chooseTempView view_refresh:[STW_BLE_SDK sharedInstance].deviceData.tmp_max :temp_value :temp_model];
        }
    };
    
    //亮灯的颜色模式
    [STW_BLE_SDK sharedInstance].BLEServiceLampModel = ^(int LampModel)
    {
        if([STW_BLE_SDK sharedInstance].deviceData.lamp_model != LampModel)
        {
            [STW_BLE_SDK sharedInstance].deviceData.lamp_model = LampModel;
        }
    };
    
    //亮度百分比
    [STW_BLE_SDK sharedInstance].BLEServicebBrightness = ^(int brightness_value)
    {
        if([STW_BLE_SDK sharedInstance].deviceData.brightness_value != brightness_value)
        {
            [STW_BLE_SDK sharedInstance].deviceData.brightness_value = brightness_value;
        }
    };
    
    //开关机信息
    [STW_BLE_SDK sharedInstance].BLEServiceDeviceRoot = ^(BootStatus Root)
    {
        if([STW_BLE_SDK sharedInstance].deviceData.boot_status != Root)
        {
            [STW_BLE_SDK sharedInstance].deviceData.boot_status = Root;
        }
    };
    
    //震动强度百分比
    [STW_BLE_SDK sharedInstance].BLEServiceVibration = ^(int vibration)
    {
        if([STW_BLE_SDK sharedInstance].deviceData.vibration_value != vibration)
        {
            [STW_BLE_SDK sharedInstance].deviceData.vibration_value = vibration;
        }
    };
    
    //返回电池电量信息
    [STW_BLE_SDK sharedInstance].BLEServiceDeviceBattery = ^(int battery_status,int battery)
    {
        if (battery_status == 0x00) {
            //停止动画效果
            if(_battery_animation_time)
            {
                [_battery_animation_time invalidate];
                _battery_animation_time = nil;
            }
            
            self.battery_view.image = [UIImage imageNamed:[self battery_view_key:battery]];
        }
        else if (battery_status == 0x01)
        {
            //正在充电
            NSLog(@"正在充电");
            if (_battery_animation_time == nil) {
                //处理充电逻辑
                self.battery_view.image = [UIImage imageNamed:[self battery_view_key:battery]];
                //开始充电动画
                [self setBattery_animation];
                
                _battery_animation_time = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(setBattery_animation) userInfo:nil repeats:YES];
            }
        }
        else if (battery_status == 0x02)
        {;
            //停止动画效果
            if(_battery_animation_time)
            {
                [_battery_animation_time invalidate];
                _battery_animation_time = nil;
            }
            //低电压
            self.battery_view.image = [UIImage imageNamed:[self battery_view_key:battery]];
        }
    };
}

-(void)setBattery_animation{
    if (_battery_animation_time) {
        //动画数组
        NSArray *array = [NSArray arrayWithObjects:
                 [UIImage imageNamed:@"battery_0"],
                 [UIImage imageNamed:@"battery_1"],
                 [UIImage imageNamed:@"battery_2"],
                 [UIImage imageNamed:@"battery_3"],
                 [UIImage imageNamed:@"battery_4"],
                 nil];
        [self.battery_view setAnimationImages:array];
        // 设置时间间隔(播放完整一次10秒)
        self.battery_view.animationDuration = 2.5f;
        // 设置重复次数(零代表无限次)
        self.battery_view.animationRepeatCount = 1;
        // 让动画开始
        [self.battery_view startAnimating];
    }
}

//返回主页面
- (IBAction)home_btn_onclick:(id)sender {
    
    if ([STW_BLE_SDK sharedInstance].stw_isBLEType == STW_BLE_IsBLETypeOff) {
        //清空所有连接信息
        [STW_BLE_SDK sharedInstance].device = nil;
        [STW_BLE_SDK sharedInstance].deviceData = nil;
        
        //返回主页面
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    }
    else
    {
        //断开蓝牙连接
        [[STW_BLE_SDK sharedInstance] disconnect];
    }
}

//设置界面
- (IBAction)setting_btn_onclick:(id)sender {
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BLEHomeRightViewController *setVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"BLEHomeRightViewController"];
    
    CLPresent *present = CLPresent.sharedCLPresent;
    present.leftAndRight = false;
    setVC.transitioningDelegate = present;
    setVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:setVC animated:YES completion:nil];
    
    present.HomeViewLeftBool = ^()
    {
        //右侧界面 - 蓝牙已经断开
        if ([STW_BLE_SDK sharedInstance].stw_isBLEType == STW_BLE_IsBLETypeOff) {
            //返回主页面
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:view animated:YES completion:nil];
        }
        else
        {
            //查询所有信息
            [[STW_BLE_SDK sharedInstance] the_work_mode];
        }
    };
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

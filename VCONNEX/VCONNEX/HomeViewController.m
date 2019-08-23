//
//  HomeViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//
// 9d9d9d  58ffd0  00bea4

#import "HomeViewController.h"
#import "ScanBLEViewController.h"
#import "TCRSettingViewController.h"
#import "TempCurveViewController.h"
#import "STW_BLE_SDK.h"
#import "UIView+MJAlertView.h"
#import "AlertViewNewAtomizer.h"
#import "PowerVolumeBar.h"
#import "TempVolumeBar.h"
#import "ModeChooseXibView.h"
#import "TempTypeChooseXibView.h"
#import "TCRChooseXibView.h"
#import "UIWeiget.h"


@interface HomeViewController ()
{
    //模式切换视图
    ModeChooseXibView *ModeViewXib;
    
    //功率模式视图
    PowerVolumeBar *powerVolumeBar;
    
    //温度模式视图
    TempVolumeBar *tempVolumeBar;
    
    //温度单位选择视图
    TempTypeChooseXibView *TempTypeChooseViewXib;
    
    //雾化器阻值
    UIWeiget *UIweightXib01;
    //雾化器类型
    UIWeiget *UIweightXib02;
    //电池电量
    UIWeiget *UIweightXib03;
    
    //TCR 温度曲线视图
    TCRChooseXibView *TCRChooseViewXib;
    
    //大仪表坐标
    int bar_x;
    int bar_y;
    float bar_width;
    float bar_height;
    
    //雾化器类型切换是否可以点击
    BOOL Atomizer_model_touch;
    
    //TCR 温度曲线是否可用
    BOOL TCR_model_touch;
    
    //蓝牙按钮
    UIButton *setButton;
    
    //提示是否是新的雾化器
    AlertViewNewAtomizer* alertViewNewAtomizer_view;
    //是否锁定雾化器
    AlertViewNewAtomizer* alertViewLockAtomizer_view;
}

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [[STW_BLEService sharedInstance] scanStop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.title = @"VCONNEX";
    //
    [self addTitleLeftButton];
    
    if (iPhone4)
    {
        //大仪表图
        bar_x = (SCREEN_WIDTH - 220.0f)/2.0f;
        bar_y = 64.0f + 40.0f;
        bar_width = 220.0f;
        bar_height = 180.0f;
        
        //圆心
        CGPoint circle_center_power;
        circle_center_power.x = bar_width/2;
        circle_center_power.y = bar_width/2;
        
        //开始、结束角度
        float start_Angle_power = 0.91;
        float end_Angle_power = 0.09;
        
        //半径
        float circle_radius_power = (bar_width - 40.0f)/2;
        
        /*----------------------------模式切换按钮视图--------------------------------*/
        ModeViewXib = [[[NSBundle mainBundle]loadNibNamed:@"ModeChooseXibView" owner:self options:nil]lastObject];
        CGRect ModeView_Frame = ModeViewXib.frame;
        
        ModeView_Frame.size.width = 220.0f;
        ModeView_Frame.size.height = 35.0f;
        
        ModeViewXib.frame = ModeView_Frame;
        
        ModeViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, 64.0f + 25.0f);
        
        ModeViewXib.backgroundColor = [UIColor clearColor];
        
        ModeViewXib.view_temp.backgroundColor = [UIColor clearColor];
        ModeViewXib.view_power.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:ModeViewXib];
        
        /*----------------------------功率调节窗口视图--------------------------------*/
        powerVolumeBar = [[PowerVolumeBar alloc]initWithFrame:CGRectMake(bar_x, bar_y,bar_width, bar_height) :circle_center_power :start_Angle_power :end_Angle_power :circle_radius_power];
        
        powerVolumeBar.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:powerVolumeBar];

        /*----------------------------温度调节窗口视图--------------------------------*/
        //开始、结束角度
        float start_Angle_temp = 0.83;
        float end_Angle_temp = 0.17;
        
        //温度调节窗口视图
        tempVolumeBar = [[TempVolumeBar alloc]initWithFrame:CGRectMake(bar_x, bar_y,bar_width, bar_height) :circle_center_power :start_Angle_temp :end_Angle_temp :circle_radius_power];
        
        tempVolumeBar.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:tempVolumeBar];

        /*---------------------温度单位切换视图---------------------------*/
        TempTypeChooseViewXib = [[[NSBundle mainBundle]loadNibNamed:@"TempTypeChooseXibView" owner:self options:nil]lastObject];
        CGRect TempChooseView_Frame = TempTypeChooseViewXib.frame;
        
        TempChooseView_Frame.size.width = 180.0f;
        TempChooseView_Frame.size.height = 25.0f;
        
        TempTypeChooseViewXib.frame = TempChooseView_Frame;
        
        TempTypeChooseViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, 64.0f + 40.0f + bar_height + 12.5f);
        
        TempTypeChooseViewXib.backgroundColor = [UIColor clearColor];
        
        TempTypeChooseViewXib.temp_view_Celsius.backgroundColor = [UIColor whiteColor];
        TempTypeChooseViewXib.temp_view_Fahrenheit.backgroundColor = [UIColor blackColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TempTypeChooseViewXib.temp_view_Celsius.layer setMasksToBounds:YES];
        [TempTypeChooseViewXib.temp_view_Celsius.layer setCornerRadius:2];
        
        //设置边界的宽度
        [TempTypeChooseViewXib.temp_view_Celsius.layer setBorderWidth:1];
        [TempTypeChooseViewXib.temp_view_Celsius.layer setBorderColor:[UIColor blackColor].CGColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setMasksToBounds:YES];
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setCornerRadius:2];
        
        //设置边界的宽度
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setBorderWidth:1];
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setBorderColor:[UIColor blackColor].CGColor];
        
        [self.view addSubview:TempTypeChooseViewXib];

        /*---------------------显示雾化器、雾化器材料、电池电量数据的三个视图---------------------------*/
        float threeView_height1 =  64.0f + 40.0f + bar_height + 25.0f;
        float threeView_height2 =  SCREEN_HEIGHT - threeView_height1 - 44.0f - 35.0f - 10.0f;
        float threeView_weight =  0;
        
        float boxSize_width = 0;
        
        if (threeView_height2 > 100)
        {
            boxSize_width = 100.0f;
            threeView_height2 = (threeView_height2 - 100)/2.0f;
        }
        else
        {
            boxSize_width = threeView_height2;
            threeView_height2 = 0;
        }
        
        threeView_weight = (SCREEN_WIDTH - (boxSize_width * 3))/4.0f;

        /*-------------------------第1个视图----------------------------*/
        UIweightXib01 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib01_Frame = UIweightXib01.frame;
        
        UIweightXib01_Frame.size.width = boxSize_width;
        UIweightXib01_Frame.size.height = boxSize_width;
        
        UIweightXib01_Frame.origin.x = threeView_weight;
        UIweightXib01_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib01.frame = UIweightXib01_Frame;
        
        UIweightXib01.lable_title.text = @"-.--Ω";
        UIweightXib01.image_view.image = [UIImage imageNamed:@"icon_whq_resistance"];
        
        UIweightXib01.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib01];
        
        /*-------------------------第2个视图----------------------------*/
        UIweightXib02 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib02_Frame = UIweightXib02.frame;
        
        UIweightXib02_Frame.size.width = boxSize_width;
        UIweightXib02_Frame.size.height = boxSize_width;
        
        UIweightXib02_Frame.origin.x = threeView_weight * 2 + boxSize_width;
        UIweightXib02_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib02.frame = UIweightXib02_Frame;
        
        UIweightXib02.lable_title.text = @"Ni";
        UIweightXib02.image_view.image = [UIImage imageNamed:@"icon_whq"];
        
        UIweightXib02.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib02];
        
        /*-------------------------第3个视图----------------------------*/
        UIweightXib03 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib03_Frame = UIweightXib03.frame;
        
        UIweightXib03_Frame.size.width = boxSize_width;
        UIweightXib03_Frame.size.height = boxSize_width;
        
        UIweightXib03_Frame.origin.x = SCREEN_WIDTH - boxSize_width - threeView_weight;
        UIweightXib03_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib03.frame = UIweightXib03_Frame;
        
        UIweightXib03.lable_title.text = @"0%";
        UIweightXib03.image_view.image = [UIImage imageNamed:@"icon_battery_0"];
        
        UIweightXib03.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib03];
        
        /*----------------------------温度曲线和TCR切换视图--------------------------------*/
        TCRChooseViewXib = [[[NSBundle mainBundle]loadNibNamed:@"TCRChooseXibView" owner:self options:nil]lastObject];
        CGRect TCRChooseXibView_Frame = TCRChooseViewXib.frame;
        
        TCRChooseXibView_Frame.size.width = SCREEN_WIDTH;
        TCRChooseXibView_Frame.size.height = 35.0f;
        
        TCRChooseViewXib.frame = TCRChooseXibView_Frame;
        
        TCRChooseViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT - 17.5f - 54.0f);
        
        TCRChooseViewXib.backgroundColor = [UIColor clearColor];
        
        //00bea4
        TCRChooseViewXib.TempCoefficientView.backgroundColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
        TCRChooseViewXib.TempCurveView.backgroundColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
        
        //    TCRChooseXibView.TempCoefficientView.backgroundColor = [UIColor lightGrayColor];
        //    TCRChooseXibView.TempCurveView.backgroundColor = [UIColor lightGrayColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TCRChooseViewXib.TempCoefficientView.layer setMasksToBounds:YES];
        [TCRChooseViewXib.TempCoefficientView.layer setCornerRadius:2];
        
        //设置按钮的圆角半径不会被遮挡
        [TCRChooseViewXib.TempCurveView.layer setMasksToBounds:YES];
        [TCRChooseViewXib.TempCurveView.layer setCornerRadius:2];
        
        [self.view addSubview:TCRChooseViewXib];
    }
    else
    {
        //大仪表图
        bar_x = 20.0f;
        bar_y = 64.0f + 40.0f;
        bar_width = SCREEN_WIDTH - 40.0f;
        bar_height = SCREEN_WIDTH - 80.0f;
        
        //圆心
        CGPoint circle_center_power;
        circle_center_power.x = bar_width/2;
        circle_center_power.y = bar_width/2;
        
        //开始、结束角度
        float start_Angle_power = 0.91;
        float end_Angle_power = 0.09;
        
        //半径
        float circle_radius_power = (bar_width - 40.0f)/2;
        
        /*----------------------------模式切换按钮视图--------------------------------*/
        ModeViewXib = [[[NSBundle mainBundle]loadNibNamed:@"ModeChooseXibView" owner:self options:nil]lastObject];
        CGRect ModeView_Frame = ModeViewXib.frame;
        
        ModeView_Frame.size.width = 220.0f;
        ModeView_Frame.size.height = 35.0f;
        
        ModeViewXib.frame = ModeView_Frame;
        
        ModeViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, 64.0f + 25.0f);
        
        ModeViewXib.backgroundColor = [UIColor clearColor];
        
        ModeViewXib.view_temp.backgroundColor = [UIColor clearColor];
        ModeViewXib.view_power.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:ModeViewXib];
        
        /*----------------------------功率调节窗口视图--------------------------------*/
        powerVolumeBar = [[PowerVolumeBar alloc]initWithFrame:CGRectMake(bar_x, bar_y,bar_width, bar_height) :circle_center_power :start_Angle_power :end_Angle_power :circle_radius_power];
        
        powerVolumeBar.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:powerVolumeBar];
        
        /*----------------------------温度调节窗口视图--------------------------------*/
        //开始、结束角度
        float start_Angle_temp = 0.83;
        float end_Angle_temp = 0.17;
        
        //温度调节窗口视图
        tempVolumeBar = [[TempVolumeBar alloc]initWithFrame:CGRectMake(bar_x, bar_y,bar_width, bar_height) :circle_center_power :start_Angle_temp :end_Angle_temp :circle_radius_power];
        
        tempVolumeBar.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:tempVolumeBar];
        
        /*---------------------温度单位切换视图---------------------------*/
        TempTypeChooseViewXib = [[[NSBundle mainBundle]loadNibNamed:@"TempTypeChooseXibView" owner:self options:nil]lastObject];
        CGRect TempChooseView_Frame = TempTypeChooseViewXib.frame;
        
        TempChooseView_Frame.size.width = 180.0f;
        TempChooseView_Frame.size.height = 25.0f;
        
        TempTypeChooseViewXib.frame = TempChooseView_Frame;
        
        TempTypeChooseViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, 64.0f + 40.0f + SCREEN_WIDTH - 80.0f + 12.5f);
        
        TempTypeChooseViewXib.backgroundColor = [UIColor clearColor];
        
        TempTypeChooseViewXib.temp_view_Celsius.backgroundColor = [UIColor whiteColor];
        TempTypeChooseViewXib.temp_view_Fahrenheit.backgroundColor = [UIColor blackColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TempTypeChooseViewXib.temp_view_Celsius.layer setMasksToBounds:YES];
        [TempTypeChooseViewXib.temp_view_Celsius.layer setCornerRadius:2];
        
        //设置边界的宽度
        [TempTypeChooseViewXib.temp_view_Celsius.layer setBorderWidth:1];
        [TempTypeChooseViewXib.temp_view_Celsius.layer setBorderColor:[UIColor blackColor].CGColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setMasksToBounds:YES];
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setCornerRadius:2];
        
        //设置边界的宽度
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setBorderWidth:1];
        [TempTypeChooseViewXib.temp_view_Fahrenheit.layer setBorderColor:[UIColor blackColor].CGColor];
        
        [self.view addSubview:TempTypeChooseViewXib];
        
        /*---------------------显示雾化器、雾化器材料、电池电量数据的三个视图---------------------------*/
        float threeView_height1 =  64.0f + 40.0f + SCREEN_WIDTH - 80.0f + 25.0f;
        float threeView_height2 =  SCREEN_HEIGHT - threeView_height1 - 44.0f - 44.0f - 20.0f;
        float threeView_weight =  0;
        
        float boxSize_width = 0;
        
        if (threeView_height2 > 100)
        {
            boxSize_width = 100.0f;
            threeView_height2 = (threeView_height2 - 100)/2.0f;
        }
        else
        {
            boxSize_width = threeView_height2;
            threeView_height2 = 0;
        }
        
        threeView_weight = (SCREEN_WIDTH - (boxSize_width * 3))/4.0f;
        
        /*-------------------------第1个视图----------------------------*/
        UIweightXib01 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib01_Frame = UIweightXib01.frame;
        
        UIweightXib01_Frame.size.width = boxSize_width;
        UIweightXib01_Frame.size.height = boxSize_width;
        
        UIweightXib01_Frame.origin.x = threeView_weight;
        UIweightXib01_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib01.frame = UIweightXib01_Frame;
        
        UIweightXib01.lable_title.text = @"-.--Ω";
        UIweightXib01.image_view.image = [UIImage imageNamed:@"icon_whq_resistance"];
        
        UIweightXib01.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib01];
        
        /*-------------------------第2个视图----------------------------*/
        UIweightXib02 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib02_Frame = UIweightXib02.frame;
        
        UIweightXib02_Frame.size.width = boxSize_width;
        UIweightXib02_Frame.size.height = boxSize_width;
        
        UIweightXib02_Frame.origin.x = threeView_weight * 2 + boxSize_width;
        UIweightXib02_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib02.frame = UIweightXib02_Frame;
        
        UIweightXib02.lable_title.text = @"Ni";
        UIweightXib02.image_view.image = [UIImage imageNamed:@"icon_whq"];
        
        UIweightXib02.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib02];
        
        /*-------------------------第3个视图----------------------------*/
        UIweightXib03 = [[[NSBundle mainBundle]loadNibNamed:@"UIWeiget" owner:self options:nil]lastObject];
        CGRect UIweightXib03_Frame = UIweightXib03.frame;
        
        UIweightXib03_Frame.size.width = boxSize_width;
        UIweightXib03_Frame.size.height = boxSize_width;
        
        UIweightXib03_Frame.origin.x = SCREEN_WIDTH - boxSize_width - threeView_weight;
        UIweightXib03_Frame.origin.y = threeView_height1 + threeView_height2;
        
        UIweightXib03.frame = UIweightXib03_Frame;
        
        UIweightXib03.lable_title.text = @"0%";
        UIweightXib03.image_view.image = [UIImage imageNamed:@"icon_battery_0"];
        
        UIweightXib03.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:UIweightXib03];
        
        /*----------------------------温度曲线和TCR切换视图--------------------------------*/
        TCRChooseViewXib = [[[NSBundle mainBundle]loadNibNamed:@"TCRChooseXibView" owner:self options:nil]lastObject];
        CGRect TCRChooseXibView_Frame = TCRChooseViewXib.frame;
        
        TCRChooseXibView_Frame.size.width = SCREEN_WIDTH;
        TCRChooseXibView_Frame.size.height = 44.0f;
        
        TCRChooseViewXib.frame = TCRChooseXibView_Frame;
        
        TCRChooseViewXib.center = CGPointMake( SCREEN_WIDTH / 2.0f, SCREEN_HEIGHT - 22.0f - 64.0f);
        
        TCRChooseViewXib.backgroundColor = [UIColor clearColor];
        
        //00bea4
        TCRChooseViewXib.TempCoefficientView.backgroundColor = VCONNEX_COLOR;// RGBCOLOR(0x00, 0xbe, 0xa4);
        TCRChooseViewXib.TempCurveView.backgroundColor = VCONNEX_COLOR;// RGBCOLOR(0x00, 0xbe, 0xa4);
        
        //    TCRChooseXibView.TempCoefficientView.backgroundColor = [UIColor lightGrayColor];
        //    TCRChooseXibView.TempCurveView.backgroundColor = [UIColor lightGrayColor];
        
        //设置按钮的圆角半径不会被遮挡
        [TCRChooseViewXib.TempCoefficientView.layer setMasksToBounds:YES];
        [TCRChooseViewXib.TempCoefficientView.layer setCornerRadius:2];
        
        //设置按钮的圆角半径不会被遮挡
        [TCRChooseViewXib.TempCurveView.layer setMasksToBounds:YES];
        [TCRChooseViewXib.TempCurveView.layer setCornerRadius:2];
        
        [self.view addSubview:TCRChooseViewXib];
    }
    
    self.ModeView = ModeViewXib;
    self.Bar_uiViewPower = powerVolumeBar;
    self.Bar_uiViewTemp = tempVolumeBar;
    self.TempTypeChooseView = TempTypeChooseViewXib;
    self.UIWeiget01 = UIweightXib01;
    self.UIWeiget02 = UIweightXib02;
    self.UIWeiget03 = UIweightXib03;
    self.TCRChooseView = TCRChooseViewXib;
    
    /*-----------------------添加点击事件-----------------------*/
    //切换温度模式
    self.ModeView.view_temp.userInteractionEnabled=YES;
    UITapGestureRecognizer *ModeView_view_temp =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickModeView_view_temp)];
    [self.ModeView.view_temp addGestureRecognizer:ModeView_view_temp];
    
    //切换功率模式
    self.ModeView.view_power.userInteractionEnabled=YES;
    UITapGestureRecognizer *ModeView_view_power =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickModeView_view_power)];
    [self.ModeView.view_power addGestureRecognizer:ModeView_view_power];
    
    //摄氏度切换
    self.TempTypeChooseView.temp_view_Celsius.userInteractionEnabled=YES;
    UITapGestureRecognizer *Temp_view_Celsius_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTemp_view_Celsius_touch)];
    [self.TempTypeChooseView.temp_view_Celsius addGestureRecognizer:Temp_view_Celsius_touch];
    
    //华氏度切换
    self.TempTypeChooseView.temp_view_Fahrenheit.userInteractionEnabled=YES;
    UITapGestureRecognizer *Temp_view_Fahrenheit_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTemp_view_Fahrenheit_touch)];
    [self.TempTypeChooseView.temp_view_Fahrenheit addGestureRecognizer:Temp_view_Fahrenheit_touch];
    
    //是否锁定雾化器阻值
    self.UIWeiget01.userInteractionEnabled=YES;
    UITapGestureRecognizer *UIWeiget01_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUIWeiget01_touch)];
    [self.UIWeiget01 addGestureRecognizer:UIWeiget01_touch];
    
    //切换雾化器类型
    self.UIWeiget02.userInteractionEnabled=YES;
    UITapGestureRecognizer *UIWeiget02_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUIWeiget02_touch)];
    [self.UIWeiget02 addGestureRecognizer:UIWeiget02_touch];
    
    //TCR调节
    self.TCRChooseView.TempCoefficientView.userInteractionEnabled=YES;
    UITapGestureRecognizer *TempCoefficientView_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTempCoefficientView_touch)];
    [self.TCRChooseView.TempCoefficientView addGestureRecognizer:TempCoefficientView_touch];

    //温度曲线调节
    self.TCRChooseView.TempCurveView.userInteractionEnabled=YES;
    UITapGestureRecognizer *TempCurveView_touch =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTempCurveView_touch)];
    [self.TCRChooseView.TempCurveView addGestureRecognizer:TempCurveView_touch];
    
    //初始化
    [self setTheHomeView:[STW_BLE_SDK STW_SDK].vaporModel :[STW_BLE_SDK STW_SDK].temperatureMold :[STW_BLE_SDK STW_SDK].atomizerMold :[STW_BLE_SDK STW_SDK].power];
    
    //注册可以扫描的通知
    [self Service_ScanToFindData];
    
    //注册APP进入后台的回调
    [self appToBackGround];
}

//APP进入后台
-(void)appToBackGround
{
    [STW_BLEService sharedInstance].Service_StopHOME = ^()
    {
        //APP 即将进入后台
        NSLog(@"APP 即将进入后台 - HOME");
    };
}


-(void)Service_ScanToFindData
{
    [STW_BLEService sharedInstance].Service_ScanToFindData = ^()
    {
        //连接成功
        [UIView addMJNotifierWithText:@"Connect Success" dismissAutomatically:YES];
        
        //注册断开连接回调
        [self Ble_disconnectHandler_HOME];
        
        //查询所有配置信息
        [self find_all_data_HOME];
    };
}

//添加蓝牙扫描按钮
-(void)addTitleLeftButton
{
    //设置右边button
    setButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 5, 35, 35)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setButton];
    
    [setButton setBackgroundImage:[UIImage imageNamed:@"icon_BLE_off"] forState:UIControlStateNormal];
    
    [setButton addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchDown];
}

//蓝牙扫描事件
-(void)clickAddBtn
{
    if([STW_BLEService sharedInstance].isBLEStatus)
    {
//        NSLog(@"主动断开");
        //主动断开
        [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;

        [STW_BLEService sharedInstance].isBLEStatus = NO;
        
        [self refreshRightBtn:[STW_BLEService sharedInstance].isBLEStatus];
        [self cleanMainUI];
        
//        NSLog(@"------------- 主动断开与蓝牙的连接 1-----------------");
        [[STW_BLEService sharedInstance] disconnect];
    }
    else
    {
//        NSLog(@"开始扫描");
        
        [STW_BLEService sharedInstance].isBLEDisType = STW_BLE_IsBLEDisTypeScan;
        
        ScanBLEViewController *ScanBLEView = [[ScanBLEViewController alloc] init];
        
        self.tabBarController.tabBar.hidden = YES;
        
        ScanBLEView.navigationItem.hidesBackButton = YES;
        
        //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
        [self.navigationController pushViewController: ScanBLEView animated:true];
    }
}

//切换功率模式
-(void)onClickModeView_view_power
{
//    [self setTheHomeView:0x00 :0x01 :0x00 :200];
    [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypePower :[STW_BLE_SDK STW_SDK].power :[STW_BLE_SDK STW_SDK].temperatureMold :[STW_BLE_SDK STW_SDK].atomizerMold];
}

//切换温度模式
-(void)onClickModeView_view_temp
{
//    [self setTheHomeView:0x01 :0x00 :0x00];
//    [UIView addMJNotifierWithText:@"Please Connect Bluetooth" dismissAutomatically:YES];
    [self LookGraph];
}

//切换摄氏度
-(void)onClickTemp_view_Celsius_touch
{
//    [self setTheHomeView:0x01 :0x00 :0x00 :200];
    if ([STW_BLE_SDK STW_SDK].temperatureMold == BLEProtocolTemperatureUnitFahrenheit)
    {
        int temps_num = [STW_BLE_Protocol temperatureUnitFahrenheitToCelsius:[STW_BLE_SDK STW_SDK].temperature];
        
        if (temps_num > 314)
        {
            temps_num = 314;
        }
        else if (temps_num < 138)
        {
            temps_num = 138;
        }
        
        //发送切换数据
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :temps_num :BLEProtocolTemperatureUnitCelsius :[STW_BLE_SDK STW_SDK].atomizerMold];
    }
}

//切换华氏度
-(void)onClickTemp_view_Fahrenheit_touch
{
//    [self setTheHomeView:0x01 :0x01 :0x00 :200];
    if ([STW_BLE_SDK STW_SDK].temperatureMold == BLEProtocolTemperatureUnitCelsius)
    {
        int temps_num = [STW_BLE_Protocol temperatureUnitCelsiusToFahrenheit:[STW_BLE_SDK STW_SDK].temperature];
        
        if (temps_num > 600)
        {
            temps_num = 600;
        }
        else if (temps_num < 280)
        {
            temps_num = 280;
        }

        //发送切换数据
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :temps_num :BLEProtocolTemperatureUnitFahrenheit :[STW_BLE_SDK STW_SDK].atomizerMold];
    }
}

//锁定和解锁雾化器
-(void)onClickUIWeiget01_touch
{
    if ([STW_BLE_SDK STW_SDK].vaporModel == BLEProtocolModeTypeTemperature)
    {
        if([STW_BLE_SDK STW_SDK].Lock_Atomizer == 0x00)
        {
            if ([STW_BLE_SDK STW_SDK].atomizer >= 100 && [STW_BLE_SDK STW_SDK].atomizer <= 5000)
            {
                //弹出选择框
                alertViewLockAtomizer_view = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewNewAtomizer" owner:self options:nil] lastObject];
                
                NSString *messageStr = [NSString stringWithFormat:@"Lock the atomizer %.2fΩ,Please select YES or NO.",([STW_BLE_SDK STW_SDK].atomizer/1000.0f)];
                
                [alertViewLockAtomizer_view showViewWith:messageStr :@"YES" :@"NO"];
                //设置回调
                alertViewLockAtomizer_view.new_old_AtomizerBox = ^(int new_old_Atomizer)
                {
                    if (new_old_Atomizer == 0x01)
                    {
                        //锁定雾化器
                        [STW_BLE_Protocol the_Set_Atomizer_Lock:0x01 :[STW_BLE_SDK STW_SDK].atomizer];
                    }
                };
            }
            else
            {
                [UIView addMJNotifierWithText:@"Resistance Error" dismissAutomatically:YES];
            }

        }
        else
        {
            //解锁雾化器
            [STW_BLE_Protocol the_Set_Atomizer_Lock:0x00 :[STW_BLE_SDK STW_SDK].atomizer];
        }
    }
}

//切换雾化器类型
-(void)onClickUIWeiget02_touch
{
    if (Atomizer_model_touch)
    {
//        NSLog(@"切换雾化器模式");
        [self LookGraph];
    }
}

//TCR调节
-(void)onClickTempCoefficientView_touch
{
    if (TCR_model_touch)
    {
        //发送数据查询
        [STW_BLE_Protocol the_find_atomizer];
        
        //注册回调
        [self the_find_atomizer_back];
    }
}

//查询TCR回调
-(void)the_find_atomizer_back
{
    [STW_BLEService sharedInstance].Service_TCRData = ^(int ChangeRate_Ni,int ChangeRate_Ss,int ChangeRate_Ti,int ChangeRate_TCR)
    {
        [STW_BLE_SDK STW_SDK].tcrArrys = [NSMutableArray array];
        
        [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ni]];
        [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ss]];
        [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ti]];
        [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_TCR]];
        
        NSLog(@"TCR调节");
        
        self.tabBarController.tabBar.hidden = YES;
        
        TCRSettingViewController *TcrSetView = [[TCRSettingViewController alloc] init];
        //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
        [self.navigationController pushViewController: TcrSetView animated:true];

    };
}

//温度曲线调节
-(void)onClickTempCurveView_touch
{
    if (TCR_model_touch)
    {
        //进行查询
        [STW_BLE_Protocol the_find_CCTData];
        
        //注册回调
        [self the_find_CCTData_back];
    }
}

-(void)the_find_CCTData_back
{
    [STW_BLEService sharedInstance].Service_CCTData = ^(NSMutableArray *CCTArrys)
    {
        [STW_BLE_SDK STW_SDK].cctArrys = [NSMutableArray array];
        
        [STW_BLE_SDK STW_SDK].cctArrys = CCTArrys;
        
        self.tabBarController.tabBar.hidden = YES;
        
        TempCurveViewController *TempCurveView = [[TempCurveViewController alloc] init];
        //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
        [self.navigationController pushViewController: TempCurveView animated:true];
    };
}

/**
 *  设置界面内容
 *
 *  @param workStatus 工作模式
 *  @param workUnit   温度单位
 *  @param workType   雾化器类型
 *  @param workNums   工作数值
 */
-(void)setTheHomeView:(int)workStatus :(int)workUnit :(int)workType :(int)workNums
{
    if (workStatus == BLEProtocolModeTypePower)
    {
        Atomizer_model_touch = NO;
        TCR_model_touch = NO;
        //功率模式
        self.Bar_uiViewPower.hidden = NO;
        self.Bar_uiViewTemp.hidden = YES;
        self.TempTypeChooseView.hidden = YES;
        
        self.ModeView.ImageView01.image = [UIImage imageNamed:@"icon_mode_left2"];
        self.ModeView.ImageView02.image = [UIImage imageNamed:@"icon_mode_right1"];
        
        //58ffd0
        self.ModeView.Lable_temp.textColor = [UIColor blackColor];
        self.ModeView.Lable_Power.textColor = VCONNEX_COLOR;  //RGBCOLOR(0x58, 0xff, 0xd0);
        
        self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_resistance"];
        self.UIWeiget02.image_view.image = [UIImage imageNamed:@"icon_whq_2"];
        self.UIWeiget02.lable_title.textColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
        
        self.TCRChooseView.TempCoefficientView.backgroundColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
        self.TCRChooseView.TempCurveView.backgroundColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
        
        [self.Bar_uiViewPower refreshUI:workNums];
    }
    else if (workStatus == BLEProtocolModeTypeTemperature)
    {
        Atomizer_model_touch = YES;
        TCR_model_touch = YES;
        //温度模式
        if (workUnit == BLEProtocolTemperatureUnitCelsius)
        {
            //摄氏度
            self.TempTypeChooseView.temp_view_Celsius.backgroundColor = [UIColor blackColor];
            self.TempTypeChooseView.temp_view_Fahrenheit.backgroundColor = [UIColor whiteColor];
            
            self.TempTypeChooseView.lable_Celsius.textColor = VCONNEX_COLOR;  //RGBCOLOR(0x58, 0xff, 0xd0);
            self.TempTypeChooseView.lable_Fahrenheit.textColor = [UIColor blackColor];
        }
        else if (workUnit == BLEProtocolTemperatureUnitFahrenheit)
        {
            //华氏度
            self.TempTypeChooseView.temp_view_Celsius.backgroundColor = [UIColor whiteColor];
            self.TempTypeChooseView.temp_view_Fahrenheit.backgroundColor = [UIColor blackColor];
            
            self.TempTypeChooseView.lable_Celsius.textColor = [UIColor blackColor];
            self.TempTypeChooseView.lable_Fahrenheit.textColor = VCONNEX_COLOR;  //RGBCOLOR(0x58, 0xff, 0xd0);
        }
        
        switch (workType)
        {
            case BLEAtomizerX1:
            {
                //Ni
                self.UIWeiget02.lable_title.text = @"Ni";
            }
                break;
            case BLEAtomizerX4:
            {
                //Ss
                self.UIWeiget02.lable_title.text = @"Ss";
            }
                break;
                
            case BLEAtomizerX2:
            {
                //Ti
                self.UIWeiget02.lable_title.text = @"Ti";
            }
                break;
                
            case BLEAtomizersM1:
            {
                //TCR
                self.UIWeiget02.lable_title.text = @"Tcr";
            }
                break;

            default:
            {
                //Ni
                self.UIWeiget02.lable_title.text = @"Ni";
            }
                break;
        }
        
        //设置雾化器是否锁定的图标 - 查询雾化器是否锁定
        [STW_BLE_Protocol the_Find_Atomizer_Lock];
//        self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_unlock"];
        
        self.Bar_uiViewPower.hidden = YES;
        self.Bar_uiViewTemp.hidden = NO;
        self.TempTypeChooseView.hidden = NO;
        
        self.ModeView.ImageView01.image = [UIImage imageNamed:@"icon_mode_left1"];
        self.ModeView.ImageView02.image = [UIImage imageNamed:@"icon_mode_right2"];
        
        self.ModeView.Lable_temp.textColor = VCONNEX_COLOR;  //RGBCOLOR(0x58, 0xff, 0xd0);
        self.ModeView.Lable_Power.textColor = [UIColor blackColor];
        
        self.UIWeiget02.image_view.image = [UIImage imageNamed:@"icon_whq"];
        self.UIWeiget02.lable_title.textColor = [UIColor blackColor];
        
        self.TCRChooseView.TempCoefficientView.backgroundColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
        self.TCRChooseView.TempCurveView.backgroundColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
        
//        NSLog(@"workUnit - %d workNums - %d",workUnit,workNums);
        
        [self.Bar_uiViewTemp refreshUI:workNums :workUnit];
    }
}

//弹出温度选择框
- (void)LookGraph
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Select atomizer material" message:@"Make sure the atomizer at room temperature" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Ni" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        //进行温度设置切换
//        [self setTheHomeView:BLEProtocolModeTypeTemperature :0x00 :BLEAtomizerX1 :200];
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :[STW_BLE_SDK STW_SDK].temperature :[STW_BLE_SDK STW_SDK].temperatureMold :BLEAtomizerX1];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Ss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
//        [self setTheHomeView:BLEProtocolModeTypeTemperature :0x00 :BLEAtomizerX4 :200];
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :[STW_BLE_SDK STW_SDK].temperature :[STW_BLE_SDK STW_SDK].temperatureMold :BLEAtomizerX4];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Ti" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
//        [self setTheHomeView:BLEProtocolModeTypeTemperature :0x00 :BLEAtomizerX2 :200];
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :[STW_BLE_SDK STW_SDK].temperature :[STW_BLE_SDK STW_SDK].temperatureMold :BLEAtomizerX2];
    }]];

    [ac addAction:[UIAlertAction actionWithTitle:@"Tcr" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
//        [self setTheHomeView:BLEProtocolModeTypeTemperature :0x00 :BLEAtomizersM1 :200];
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypeTemperature :[STW_BLE_SDK STW_SDK].temperature :[STW_BLE_SDK STW_SDK].temperatureMold :BLEAtomizersM1];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
    {
//        NSLog(@"取消");
    }]];
    
    if ([ac.actions valueForKey:@"titleTextColor"])
    {
        [ac.actions setValue:RGBCOLOR(0x74, 0x74, 0x74) forKey:@"titleTextColor"];
    }
    
    [self presentViewController:ac animated:YES completion:nil];
}

//连接成功的回调
-(void)Service_connectedHandler_HOME
{
    [STW_BLEService sharedInstance].Service_connectedHandler = ^(void)
    {
        [STW_BLEService sharedInstance].isBLEStatus = YES;
        
        //注册开始服务的回调
        [self start_service_HOME];
    };
}

//注册开始设备服务的回调
-(void)start_service_HOME
{
    [STW_BLEService sharedInstance].Service_discoverCharacteristicsForServiceHandler = ^()
    {
        if ([STW_BLEService sharedInstance].isBLEType == STW_BLE_IsBLETypeLoding)
        {
            //查询所有配置信息
            [self find_all_data_HOME];
        }
    };
}

//查询所有配置信息
-(void)find_all_data_HOME
{
    //查询
    [STW_BLE_Protocol the_find_all_data];
    //延时设置设备时间
    //    [self performSelector:@selector(setDeviceTime) withObject:nil afterDelay:0.2f];
    
    [self refreshRightBtn:[STW_BLEService sharedInstance].isBLEStatus];
    
    //获取连接设备的mac
    [STW_BLE_SDK STW_SDK].deviceMac = [STW_BLEService sharedInstance].device.deviceMac;
    
    //注册所有用到数据的BLE回调
    [self BleReceiveData];
}

//注册断开连接的回调
-(void)Ble_disconnectHandler_HOME
{
    [STW_BLEService sharedInstance].Service_disconnectHandlerOn = nil;
    
    [STW_BLEService sharedInstance].Service_disconnectHandlerOn = ^(void)
    {
//        NSLog(@"蓝牙断开连接 HOME - %ld",(long)[STW_BLEService sharedInstance].isBLEType);
        
        [STW_BLEService sharedInstance].isBLEStatus = NO;
        
        if([STW_BLEService sharedInstance].isBLEType == STW_BLE_IsBLETypeLoding)
        {
            [[STW_BLEService sharedInstance] scanStart];
            
            //注册扫描到蓝牙的连接
            [self scanBLEDeviceMain_HOME];
            
            double delayInSeconds = 3.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               if (![STW_BLEService sharedInstance].isBLEStatus)
                               {
                                   [[STW_BLEService sharedInstance] scanStop];
                                   
                                   [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
                                   
                                   [self refreshRightBtn:[STW_BLEService sharedInstance].isBLEStatus];
                                   
                                   [UIView addMJNotifierWithText:@"Lost Connect" dismissAutomatically:YES];
                                   
                                   //清空UI
//                                   NSLog(@"清空UI - Loding");
                                   
                                   [self cleanMainUI];
                               }
                           });
        }
        else if([STW_BLEService sharedInstance].isBLEType == STW_BLE_IsBLETypeOff)
        {
            [self refreshRightBtn:[STW_BLEService sharedInstance].isBLEStatus];
            
            [UIView addMJNotifierWithText:@"Lost Connect" dismissAutomatically:YES];
            
            //清空UI
//            NSLog(@"清空UI - Lost");
            
            [self cleanMainUI];
        }
        else if([STW_BLEService sharedInstance].isBLEType == STW_BLE_IsBLETypeUpdate)
        {
            //清空UI
//            NSLog(@"清空UI - Update");
            
            [self cleanMainUI];
            
            [[STW_BLEService sharedInstance] scanStart];
            //注册扫描到蓝牙的连接
            [self scanBLEDeviceMain_HOME];
            
            double delayInSeconds = 8.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               if (![STW_BLEService sharedInstance].isBLEStatus)
                               {
                                   [[STW_BLEService sharedInstance] scanStop];
                                   
                                   [STW_BLEService sharedInstance].isBLEType = STW_BLE_IsBLETypeOff;
                                   
                                   [self refreshRightBtn:[STW_BLEService sharedInstance].isBLEStatus];
                               }
                           });
        }
    };
}

-(void)scanBLEDeviceMain_HOME
{
    //注册扫描到设备的回调
    [STW_BLEService sharedInstance].Service_scanHandler = ^(STW_BLEDevice *device)
    {
//        NSLog(@"HONE - 扫描到的设备-%@-%@",device.deviceName,device.deviceMac);
        if ([[STW_BLE_SDK STW_SDK].deviceMac isEqualToString:device.deviceMac])
        {
            //有符合对象调用连接
            [[STW_BLEService sharedInstance] connect:device];
            
            //注册回调
            [self Service_connectedHandler_HOME];
        }
    };
}

//刷新右侧小按钮UI
-(void)refreshRightBtn:(int)btnCheck_num
{
    if(btnCheck_num)
    {
        [setButton setBackgroundImage:[UIImage imageNamed:@"icon_BLE_on"] forState:UIControlStateNormal];
    }
    else
    {
        [setButton setBackgroundImage:[UIImage imageNamed:@"icon_BLE_off"] forState:UIControlStateNormal];
    }
}

//蓝牙信息接收
-(void)BleReceiveData
{
    //电池电量信息
    [STW_BLEService sharedInstance].Service_Battery = ^(int battery)
    {
        self.UIWeiget03.lable_title.text = [NSString stringWithFormat:@"%d%%",battery];
        //电池电量
        [STW_BLE_SDK STW_SDK].battery = battery;
        
        if (battery && battery == 0)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_0"];
        }
        else if (0 < battery && battery <= 10)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_10"];
        }
        else if(10 < battery && battery <= 20)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_25"];
        }
        else if(20 < battery && battery <= 50)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_50"];
        }
        else if(50 < battery && battery <= 80)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_75"];
        }
        else if(80 < battery && battery <= 100)
        {
            self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_100"];
        }
    };
    
    //从机数据-雾化器负载和大小
    [STW_BLEService sharedInstance].Service_AtomizerData = ^(int resistance,int atomizerMold)
    {
        [STW_BLE_SDK STW_SDK].atomizer = resistance;
        [STW_BLE_SDK STW_SDK].atomizerMold = atomizerMold;
        
//        NSLog(@"updateAtomizerUIWeiget01 ------ 01");
        //更新雾化器阻值
        [self updateAtomizerUIWeiget01:resistance];
        
        switch (atomizerMold)
        {
            case BLEAtomizerX1:
            {
                //Ni
                self.UIWeiget02.lable_title.text = @"Ni";
            }
                break;
            case BLEAtomizerX4:
            {
                //Ss
                self.UIWeiget02.lable_title.text = @"Ss";
            }
                break;
                
            case BLEAtomizerX2:
            {
                //Ti
                self.UIWeiget02.lable_title.text = @"Ti";
            }
                break;
                
            case BLEAtomizersM1:
            {
                //TCR
                self.UIWeiget02.lable_title.text = @"Tcr";
            }
                break;
                
            default:
            {
                //Ni
                self.UIWeiget02.lable_title.text = @"Ni";
            }
                break;
        }
    };

    //从机数据-功率
    [STW_BLEService sharedInstance].Service_Power = ^(int power)
    {
        [STW_BLE_SDK STW_SDK].power = power;
        [STW_BLE_SDK STW_SDK].vaporModel = BLEProtocolModeTypePower;
        
        [self setTheHomeView:BLEProtocolModeTypePower :0x00 :[STW_BLE_SDK STW_SDK].atomizerMold :power];
    };
    
    //从机数据-温度/温度单位
    [STW_BLEService sharedInstance].Service_Temp = ^(int temp,int tempModel)
    {
        [STW_BLE_SDK STW_SDK].temperature = temp;
        [STW_BLE_SDK STW_SDK].temperatureMold = tempModel;
        
        [STW_BLE_SDK STW_SDK].vaporModel = BLEProtocolModeTypeTemperature;
        
        [self setTheHomeView:BLEProtocolModeTypeTemperature :tempModel :[STW_BLE_SDK STW_SDK].atomizerMold :temp];
    };
    
    //从机数据-吸烟状态
    [STW_BLEService sharedInstance].Service_VaporStatus = ^(int vapor_status)
    {
        [STW_BLE_SDK STW_SDK].vaporStatus = vapor_status;
        
        switch (vapor_status)
        {
            case BLEProtocolVaporStatus00:
//                NSLog(@"停止吸烟");
                break;
            case BLEProtocolVaporStatus01:
//                NSLog(@"开始吸烟");
                break;
            case BLEProtocolVaporStatus02:
                [UIView addMJNotifierWithText:@"LOW ATOMIZER" dismissAutomatically:YES];
                break;
            case BLEProtocolVaporStatus03:
                [UIView addMJNotifierWithText:@"HIGH ATOMIZER" dismissAutomatically:YES];
                break;
            case BLEProtocolVaporStatus04:
                [UIView addMJNotifierWithText:@"CHECK ATOMIZER" dismissAutomatically:YES];
                break;
            case BLEProtocolVaporStatus05:
                [UIView addMJNotifierWithText:@"ATOMIZER SHORT" dismissAutomatically:YES];
                break;
            case BLEProtocolVaporStatus06:
                [UIView addMJNotifierWithText:@"10S OVER" dismissAutomatically:YES];
                break;
            case BLEProtocolVaporStatus07:
            {
//                NSLog(@"设置成功 - 是否是新的雾化器");
            }
                break;
            case BLEProtocolVaporStatus08:
            {
                //过温保护
                [UIView addMJNotifierWithText:@"PCBA TOO HOT" dismissAutomatically:YES];
            }
                break;
            case BLEProtocolVaporStatus09:
            {
                //电池电压低
                [UIView addMJNotifierWithText:@"LOW BATTERY" dismissAutomatically:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
    //从机设置数据返回 - 是否是新的雾化器
    [STW_BLEService sharedInstance].Service_AtomizerNew = ^(int Atomizer_old ,int Atomizer_new)
    {
//        NSLog(@"新的雾化器");
        
        if (100 <= Atomizer_new && Atomizer_new <=50000 && 100 <= Atomizer_old && Atomizer_old <=50000)
        {
            [STW_BLE_SDK STW_SDK].new_Atomizer = Atomizer_new;
            [STW_BLE_SDK STW_SDK].old_Atomizer = Atomizer_old;
            
            if(alertViewNewAtomizer_view)
            {
                if (alertViewNewAtomizer_view.timers)
                {
                    [alertViewNewAtomizer_view.timers invalidate];
                    alertViewNewAtomizer_view.timers = nil;
                }
                [alertViewNewAtomizer_view remove];
            }
            
            //弹出选择框
            alertViewNewAtomizer_view = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewNewAtomizer" owner:self options:nil] lastObject];
            
            int D1_num = Atomizer_new/1000;
            int D2_num = (Atomizer_new%1000)/10;
            
            int D3_num = Atomizer_old/1000;
            int D4_num = (Atomizer_old%1000)/10;
            
            NSString *str_new;
            NSString *str_old;
            
            if (D2_num < 10)
            {
                str_new = [NSString stringWithFormat:@"%d.0%dΩ",D1_num,D2_num];
            }
            else
            {
                str_new = [NSString stringWithFormat:@"%d.%dΩ",D1_num,D2_num];
            }
            
            if (D4_num < 10)
            {
                str_old = [NSString stringWithFormat:@"%d.0%dΩ",D3_num,D4_num];
            }
            else
            {
                str_old = [NSString stringWithFormat:@"%d.%dΩ",D3_num,D4_num];
            }
            
            NSString *messageStr = [NSString stringWithFormat:@"Replacement atomizer,Please select:New %@,Old %@.",str_new,str_old];
            
            //造成回调循环引用警告，只需要避免强引用到self，用__weak把self重新引用一下就行了
            __weak __typeof(self) weakSelf = self;
            
            //设置回调
            alertViewNewAtomizer_view.new_old_AtomizerBox = ^(int new_old_Atomizer)
            {
                if (new_old_Atomizer == 0x01)
                {
//                    NSLog(@"new_old_Atomizer - %d ,[STW_BLE_SDK STW_SDK].new_Atomizer - %d",new_old_Atomizer,[STW_BLE_SDK STW_SDK].new_Atomizer);
                    //更新雾化器阻值
                    //                NSLog(@"updateAtomizerUIWeiget01 ------ 02");
                    [weakSelf updateAtomizerUIWeiget01:[STW_BLE_SDK STW_SDK].new_Atomizer];
                    //设置新的雾化器
                    [STW_BLE_Protocol the_set_new_old_Atomizer:[STW_BLE_SDK STW_SDK].new_Atomizer];
                }
                else
                {
                    //更新雾化器阻值
                    //                NSLog(@"updateAtomizerUIWeiget01 ------ 03");
                    [weakSelf updateAtomizerUIWeiget01:[STW_BLE_SDK STW_SDK].old_Atomizer];
                    //设置旧的雾化器
                    [STW_BLE_Protocol the_set_new_old_Atomizer:0x00];
                }
            };
            
            [alertViewNewAtomizer_view showViewWith:messageStr :@"NEW" :@"OLD"];
        }
        else
        {
            //设置旧的雾化器
            [STW_BLE_Protocol the_set_new_old_Atomizer:0x00];
        }
    };
    
    //蓝牙数据锁定雾化器
    [STW_BLEService sharedInstance].Service_AtomizerLock = ^(int Lock_type,int Lock_Atomizer)
    {
        switch (Lock_type)
        {
            case 0x00:
            {
                //解锁
                self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_unlock"];
                [STW_BLE_SDK STW_SDK].Lock_Atomizer = 0x00;
            }
                
                break;
            case 0x01:
            {
                //锁定
                self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_lock"];
                [STW_BLE_SDK STW_SDK].Lock_Atomizer = 0x01;
            }
                break;
            case 0x02:
            {
                [UIView addMJNotifierWithText:@"Atomizer unlock" dismissAutomatically:YES];
                //解锁
                self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_unlock"];
                [STW_BLE_SDK STW_SDK].Lock_Atomizer = 0x00;
            }
                
                break;
            case 0x03:
            {
                [UIView addMJNotifierWithText:@"Atomizer lock" dismissAutomatically:YES];
                //锁定
                self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_lock"];
                [STW_BLE_SDK STW_SDK].Lock_Atomizer = 0x01;
            }
                break;
                
            default:
                break;
        }
    };
    
    //设备状态
    [STW_BLEService sharedInstance].Service_Activity = ^(int vapor_Activity)
    {
        [STW_BLE_SDK STW_SDK].vapor_Activity = vapor_Activity;
        
        switch (vapor_Activity)
        {
            case BLEProtocolDriveActivity:
                //Lock
                [UIView addMJNotifierWithText:@"Vapor Lock" dismissAutomatically:YES];
                break;
                
            case BLEProtocolDriveSleep:
                //Lock
                [UIView addMJNotifierWithText:@"Vapor Boot" dismissAutomatically:YES];
                break;
                
            default:
                break;
        }
    };
}

//更新雾化器阻值
-(void)updateAtomizerUIWeiget01:(int)AtomizerUIWeiget01
{
//    NSLog(@"AtomizerUIWeiget01 - %d",AtomizerUIWeiget01);
    int D1_num = AtomizerUIWeiget01/1000;
    int D2_num = (AtomizerUIWeiget01%1000)/10;
    
    [STW_BLE_SDK STW_SDK].atomizer = AtomizerUIWeiget01;
    
    NSString *strAtom;
    
    if (D2_num < 10)
    {
        strAtom = [NSString stringWithFormat:@"%d.0%dΩ",D1_num,D2_num];
    }
    else
    {
        strAtom = [NSString stringWithFormat:@"%d.%dΩ",D1_num,D2_num];
    }
    
    self.UIWeiget01.lable_title.text = [NSString stringWithFormat:@"%@",strAtom];
}

-(void)cleanMainUI
{
    //初始化数据
    [STW_BLE_SDK STW_SDK].power = 50;
    [STW_BLE_SDK STW_SDK].temperature = 280;
    [STW_BLE_SDK STW_SDK].temperatureMold = BLEProtocolTemperatureUnitFahrenheit;
    [STW_BLE_SDK STW_SDK].vaporModel = BLEProtocolModeTypePower;
    [STW_BLE_SDK STW_SDK].battery = 0;
    [STW_BLE_SDK STW_SDK].atomizer = 0;
    [STW_BLE_SDK STW_SDK].vapor_Activity = BLEProtocolDriveActivity;
    [STW_BLE_SDK STW_SDK].atomizerMold = BLEAtomizerX1;
    
    //初始化
    [self setTheHomeView:[STW_BLE_SDK STW_SDK].vaporModel :[STW_BLE_SDK STW_SDK].temperatureMold :[STW_BLE_SDK STW_SDK].atomizerMold :[STW_BLE_SDK STW_SDK].power];
    
    self.UIWeiget01.lable_title.text = @"-.--Ω";
    self.UIWeiget01.image_view.image = [UIImage imageNamed:@"icon_whq_resistance"];
    
    self.UIWeiget03.lable_title.text = @"0%";
    self.UIWeiget03.image_view.image = [UIImage imageNamed:@"icon_battery_0"];
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

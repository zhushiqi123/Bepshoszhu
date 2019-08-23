//
//  HomeViewController.m
//  Vapesoul
//
//  Created by tyz on 17/7/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "HomeViewController.h"
#import "BindingViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏返回按钮
    [self setRebackImageViewHiden:YES];
    //蓝牙加载状态栏
    [self setStatusBLEView];
    //连接设备的状态视图
    [self setBleVapeView];
    //按钮视图
    [self setBtnView];
    //APP 版本视图
    [self setAppVersionView];
}

//蓝牙加载状态栏
-(void)setStatusBLEView
{
    float statusBLEView_height = (SCREEN_HEIGHT * 6.5)/100.0f;
    float statusBLEView_x = (SCREEN_HEIGHT * 9.5)/100.0f;
    float btn_height = (SCREEN_HEIGHT * 3.5)/100.0f;
    float btn_margin_x = (SCREEN_HEIGHT * 2.5)/100.0f;
    float btn_margin_y = (SCREEN_HEIGHT * 1.5)/100.0f;
    float bleLable_width = (SCREEN_WIDTH * 40)/100.0f;
    
    //背景视图
    UIView *statusBLEView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBLEView_x,(SCREEN_WIDTH/2.0f), statusBLEView_height)];
    statusBLEView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:statusBLEView];
    
    UIView *statusDeviceView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2.0f), statusBLEView_x, (SCREEN_WIDTH/2.0f), statusBLEView_height)];
    statusDeviceView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:statusDeviceView];
    
    //蓝牙开关
    UIImageView *bleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(btn_margin_x, btn_margin_y, btn_height, btn_height)];
    bleImageView.image = [UIImage imageNamed:@"ble_on"];
    [statusBLEView addSubview:bleImageView];
    
    UILabel *bleLableView = [[UILabel alloc] initWithFrame:CGRectMake((btn_margin_x * 2 + btn_height), btn_margin_y, bleLable_width, btn_height)];
    bleLableView.backgroundColor = [UIColor clearColor];
    bleLableView.textColor = RGBACOLOR(0, 160, 233,0.8);
    bleLableView.font = [UIFont systemFontOfSize:(btn_height * 0.618)];
    bleLableView.text = @"蓝牙已开启";
    [statusBLEView addSubview:bleLableView];
    
    //已绑定的设备
    UIImageView *deviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(btn_margin_x, btn_margin_y, btn_height, btn_height)];
    deviceImageView.image = [UIImage imageNamed:@"icon_ binding"];
    [statusDeviceView addSubview:deviceImageView];
    
    UILabel *deviceLableView = [[UILabel alloc] initWithFrame:CGRectMake(((btn_margin_x * 2) + btn_height), btn_margin_y, bleLable_width, btn_height)];
    deviceLableView.backgroundColor = [UIColor clearColor];
    deviceLableView.textColor = RGBACOLOR(0, 160, 233,0.8);
    deviceLableView.font = [UIFont systemFontOfSize:(btn_height * 0.618)];
    deviceLableView.text = @"已绑定设备";
    [statusDeviceView addSubview:deviceLableView];
}

//连接设备的状态视图
-(void)setBleVapeView
{
    float vapeView_height = (SCREEN_HEIGHT * 18.0f)/100.0f;
    
    float vapeImageView_center_x = SCREEN_WIDTH/2.0f;
    float vapeImageView_center_y = (SCREEN_HEIGHT * 29.0f)/100.0f;
    float vapeImageView_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float vapeImageView_width = (vapeImageView_height * 5.0f)/11.0f;
    
    float threePointView_width = (vapeImageView_height * 4.0f)/39.0f;
    float threePointView_center_y = (SCREEN_HEIGHT * 45.0f)/100.0f;
    
    float phoneImageView_height = vapeImageView_height;
    float phoneImageView_width = (vapeImageView_height * 6.0f)/11.0f;
    float phoneImageView_center_y = (SCREEN_HEIGHT * 55.0f)/100.0f;
    
    float connectStatusLableView_height = (SCREEN_HEIGHT * 5.0f)/100.0f;
    float connectStatusLableView_y = (SCREEN_HEIGHT * 63.0f)/100.0f;
    
    //背景视图
    UIImageView *vapeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, vapeView_height, vapeView_height)];
    vapeView.center = CGPointMake(vapeImageView_center_x, vapeImageView_center_y);
    vapeView.image = [UIImage imageNamed:@"icon_cicle_add"];
    [self.view addSubview:vapeView];
    
    //image 视图
    UIImageView *vapeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, vapeImageView_width, vapeImageView_height)];
    vapeImageView.center = CGPointMake(vapeImageView_center_x, vapeImageView_center_y);
    vapeImageView.image = [UIImage imageNamed:@"vape_connect"];
    [self.view addSubview:vapeImageView];
    
    //三个圆点视图
    UIImageView *threePointView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, threePointView_width, vapeImageView_height)];
    threePointView.center = CGPointMake(vapeImageView_center_x, threePointView_center_y);
    threePointView.image = [UIImage imageNamed:@"icon_point_on"];
    [self.view addSubview:threePointView];
    
    //手机视图
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, phoneImageView_width, phoneImageView_height)];
    phoneImageView.center = CGPointMake(vapeImageView_center_x, phoneImageView_center_y);
    phoneImageView.image = [UIImage imageNamed:@"icon_phone"];
    [self.view addSubview:phoneImageView];
    
    //连接状态 Lable
    UILabel *connectStatusLableView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, connectStatusLableView_height)];
    connectStatusLableView.center = CGPointMake(vapeImageView_center_x, connectStatusLableView_y);
    connectStatusLableView.textAlignment = NSTextAlignmentCenter;
    connectStatusLableView.text = @"与设备：Vapesoul_V7连接成功!";
    connectStatusLableView.font = [UIFont systemFontOfSize:(connectStatusLableView_height * 0.5)];
    connectStatusLableView.textColor = RGBACOLOR(0x66, 0xac, 0xed, 0.8);
    connectStatusLableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:connectStatusLableView];
}

//设置按钮视图
-(void)setBtnView
{
    float btn_width = (SCREEN_WIDTH * 40.0f)/100.0f;
    float btn_height = (SCREEN_HEIGHT * 6.5f)/100.0f;
    
    float findDeviceButton_center_x = SCREEN_WIDTH/2.0f;
    float findDeviceButton_center_y = (SCREEN_HEIGHT * 75.0f)/100.0f;
    
    float bindingDeviceButton_center_x = SCREEN_WIDTH/2.0f;
    float bindingDeviceButton_center_y = (SCREEN_HEIGHT * 83.5f)/100.0f;
    
    /*** 发现设备按钮 ***/
    UIButton *findDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, btn_height)];
    findDeviceButton.backgroundColor = RGBCOLOR(102, 172, 237);
    findDeviceButton.center = CGPointMake(findDeviceButton_center_x, findDeviceButton_center_y);
    //设置圆角
    [findDeviceButton.layer setMasksToBounds:YES];
    findDeviceButton.layer.cornerRadius = 5.0f;
    
    //按钮文字
    findDeviceButton.titleLabel.font = [UIFont systemFontOfSize: (btn_height * 0.35)];
    [findDeviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findDeviceButton setTitle:@"发现设备" forState:UIControlStateNormal];
    
    //添加点击事件
    [findDeviceButton addTarget:self action:@selector(onclick_findBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:findDeviceButton];
    
    /*** 绑定新设备的按钮 ***/
    UIButton *bindingDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, btn_height)];
    bindingDeviceButton.backgroundColor = [UIColor clearColor];
    //设置圆角
    [bindingDeviceButton.layer setMasksToBounds:YES];
    bindingDeviceButton.layer.cornerRadius = 5.0f;
    //设置线宽
    bindingDeviceButton.layer.borderWidth = 1;
    bindingDeviceButton.layer.borderColor = RGBCOLOR(0, 160, 233).CGColor;
    
    //按钮文字
    bindingDeviceButton.titleLabel.font = [UIFont systemFontOfSize: (btn_height * 0.35)];
    [bindingDeviceButton setTitleColor:RGBCOLOR(102, 172, 237) forState:UIControlStateNormal];
    [bindingDeviceButton setTitle:@"绑定设备" forState:UIControlStateNormal];
    
    //添加点击事件
    [bindingDeviceButton addTarget:self action:@selector(onclick_bindingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    bindingDeviceButton.center = CGPointMake(bindingDeviceButton_center_x, bindingDeviceButton_center_y);
    [self.view addSubview:bindingDeviceButton];
}

//发现设备点击事件
-(void)onclick_findBtn
{
    NSLog(@"发现设备");
}

//绑定按钮点击事件
-(void)onclick_bindingBtn
{
    //Modal跳转
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BindingViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"BindingViewController"];
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:view animated:YES completion:nil];
}

//APP 版本视图
-(void) setAppVersionView
{
    float appVersionLableView_width = SCREEN_WIDTH;
    float appVersionLableView_height = (SCREEN_HEIGHT * 10.0f)/100.0f;
    
    float appVersionLableView_center_x = SCREEN_WIDTH/2.0f;
    float appVersionLableView_center_y = (SCREEN_HEIGHT * 95.0f)/100.0f;
    
    UILabel *appVersionLableView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, appVersionLableView_width, appVersionLableView_height)];
    appVersionLableView.center = CGPointMake(appVersionLableView_center_x, appVersionLableView_center_y);
    appVersionLableView.backgroundColor = [UIColor clearColor];
    appVersionLableView.textAlignment = NSTextAlignmentCenter;
    appVersionLableView.text = @"版本信息:V1.1";
    appVersionLableView.font = [UIFont systemFontOfSize:12];
    appVersionLableView.textColor = RGBACOLOR(209, 209, 209, 1);
    [self.view addSubview:appVersionLableView];
};

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

//
//  DeviceInfoViewController.m
//  Vapesoul
//
//  Created by tyz on 17/7/11.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "DeviceInfoViewController.h"

@interface DeviceInfoViewController ()

//蓝牙是否连接
@property (nonatomic,assign) Boolean LOOSE_DEVICE;
//声音是否打开
@property (nonatomic,assign) Boolean VOICE_DEVICE;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化信息
    [self init_data];
    //给按钮添加点击返回的事件
    [self setRebackOnclick];
    //添加设备标签栏
    [self addUseTitleView];
    //添加设备名称视图
    [self setDeviceNameView];
    //添加功能视图
    [self setUtilsView];
    //添加声音选择视图
    [self setChooseVoiceView];
    //添加绑定设备按钮
    [self setBtnView];
    //APP 版本视图
    [self setAppVersionView];
}

-(void)init_data
{
    _LOOSE_DEVICE = YES;
    _VOICE_DEVICE = NO;
}

//添加可用设备标签栏
-(void)addUseTitleView
{
    float devieListTitleLabel_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float devieListTitleLabel_width = SCREEN_WIDTH - 14.0f;
    
    float devieListTitleLabel_y = (SCREEN_HEIGHT * 9.5f)/100.0f;
    
    UILabel *devieListTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, devieListTitleLabel_y, devieListTitleLabel_width, devieListTitleLabel_height)];
    
    devieListTitleLabel.text = @"设备:";
    devieListTitleLabel.backgroundColor = [UIColor clearColor];
    devieListTitleLabel.textColor = RGBCOLOR(51, 51, 51);
    devieListTitleLabel.font = [UIFont systemFontOfSize:(devieListTitleLabel_height*0.4)];
    [self.view addSubview:devieListTitleLabel];
}

//添加设备名称视图
-(void)setDeviceNameView
{
    float backView_width = SCREEN_WIDTH;
    float backView_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float backView_center_y = (SCREEN_HEIGHT * 16.5f)/100.0f;
    
    float devieListTitleLabel_width = (SCREEN_WIDTH * 80.0f)/100.0f - 14.0f;
    
    //添加背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, backView_center_y, backView_width, backView_height)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //名字视图
    UILabel *devieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, 0, devieListTitleLabel_width, backView_height)];
    
    devieNameLabel.text = @"Vapesoul_V7";
    devieNameLabel.backgroundColor = [UIColor clearColor];
    devieNameLabel.textColor = RGBCOLOR(51, 51, 51);
    devieNameLabel.font = [UIFont systemFontOfSize:(backView_height*0.3)];
    
    [backView addSubview:devieNameLabel];
    
    //修改按钮
    float changeNameLable_width = (SCREEN_WIDTH * 20.0f)/100.0f -14.0f;
    float changeNameLable_center_x = (SCREEN_WIDTH * 80.0f)/100.0f;
    
    UILabel *changeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(changeNameLable_center_x, 0, changeNameLable_width, backView_height)];
    changeNameLable.text = @"修改";
    changeNameLable.textAlignment = NSTextAlignmentRight;
    changeNameLable.backgroundColor = [UIColor clearColor];
    changeNameLable.textColor = RGBCOLOR(102, 172, 237);
    changeNameLable.font = [UIFont systemFontOfSize:(backView_height*0.3)];
    [backView addSubview:changeNameLable];
    
    //修改名称的点击事件
    backView.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_change_name:)];
    [backView addGestureRecognizer:onclick_view];
}

//添加功能视图
-(void)setUtilsView
{
    float backView_width = SCREEN_WIDTH;
    float backView_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float backView1_center_y = (SCREEN_HEIGHT * 25.5f)/100.0f;
    float backView2_center_y = (SCREEN_HEIGHT * 32.5f)/100.0f + 0.5f;
    
    //按钮 布局
    float btn_height = (SCREEN_HEIGHT * 4.5f)/100.0f;
    float btn_weight = (btn_height * 51.0f)/31.0f;
    
    float btn_center_x = (SCREEN_WIDTH - 14.0f - (btn_weight/2.0f));
    float btn_center_y = (backView_height / 2.0f);
    
    float devieListTitleLabel_width = SCREEN_WIDTH - 28.0f - btn_weight;
    //添加背景视图 1
    UIView *backView01 = [[UIView alloc] initWithFrame:CGRectMake(0, backView1_center_y, backView_width, backView_height)];
    backView01.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView01];
    
    //按钮1
    _btnImage01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_weight, btn_height)];
    _btnImage01.center = CGPointMake(btn_center_x, btn_center_y);
    _btnImage01.image = [UIImage imageNamed:@"icon_btn_on"];
    [backView01 addSubview:_btnImage01];
    
    //防丢视图
    UILabel *losseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, 0, devieListTitleLabel_width, backView_height)];
    losseNameLabel.text = @"防丢功能";
    losseNameLabel.backgroundColor = [UIColor clearColor];
    losseNameLabel.textColor = RGBCOLOR(51, 51, 51);
    losseNameLabel.font = [UIFont systemFontOfSize:(backView_height*0.3)];
    [backView01 addSubview:losseNameLabel];
    
    //添加背景视图 2
    UIView *backView02 = [[UIView alloc] initWithFrame:CGRectMake(0, backView2_center_y, backView_width, backView_height)];
    backView02.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView02];
    
    //按钮2
    _btnImage02 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn_weight, btn_height)];
    _btnImage02.center = CGPointMake(btn_center_x, btn_center_y);
    _btnImage02.image = [UIImage imageNamed:@"icon_btn_off"];
    [backView02 addSubview:_btnImage02];
    
    //震动视图
    UILabel *phoneShakeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, 0, devieListTitleLabel_width, backView_height)];
    
    phoneShakeLabel.text = @"手机震动";
    phoneShakeLabel.backgroundColor = [UIColor clearColor];
    phoneShakeLabel.textColor = RGBCOLOR(51, 51, 51);
    phoneShakeLabel.font = [UIFont systemFontOfSize:(backView_height*0.3)];
    
    [backView02 addSubview:phoneShakeLabel];
    
    //防丢点击事件
    backView01.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick01_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_loose_device:)];
    [backView01 addGestureRecognizer:onclick01_view];
    
    //震动点击事件
    backView02.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick02_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_shake_device:)];
    [backView02 addGestureRecognizer:onclick02_view];
}

//添加声音选择视图
-(void)setChooseVoiceView
{
    float backView_width = SCREEN_WIDTH;
    float backView_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float backView_center_y = (SCREEN_HEIGHT * 41.5f)/100.0f;
    
    float rightImageView_height = (SCREEN_HEIGHT * 3.0f)/100.0f;
    float rightImageView_width = (rightImageView_height * 13.0f)/24.0f;
    float rightImageView_center_x = SCREEN_WIDTH - 14.0f - (rightImageView_width/2.0f);
    float rightImageView_center_y = (backView_height / 2.0f);
    
    float devieListTitleLabel_width = SCREEN_WIDTH - 28.0f - rightImageView_width;
    //添加背景视图
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, backView_center_y, backView_width, backView_height)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //向右箭头
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rightImageView_width, rightImageView_height)];
    rightImageView.center = CGPointMake(rightImageView_center_x, rightImageView_center_y);
    rightImageView.image = [UIImage imageNamed:@"btn_right"];
    [backView addSubview:rightImageView];
    
    //lable
    UILabel *messageVoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, 0, devieListTitleLabel_width, backView_height)];
    messageVoiceLabel.text = @"提示铃声选择";
    messageVoiceLabel.backgroundColor = [UIColor clearColor];
    messageVoiceLabel.textColor = RGBCOLOR(51, 51, 51);
    messageVoiceLabel.font = [UIFont systemFontOfSize:(backView_height*0.3)];
    [backView addSubview:messageVoiceLabel];
    
    //提示铃声选择点击事件
    backView.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_voice_device:)];
    [backView addGestureRecognizer:onclick_view];
}

//添加绑定设备按钮
-(void)setBtnView
{
    float btn_width = (SCREEN_WIDTH * 40.0f)/100.0f;
    float btn_height = (SCREEN_HEIGHT * 6.5f)/100.0f;
    
    float findDeviceButton_center_x = SCREEN_WIDTH/2.0f;
    float findDeviceButton_center_y = (SCREEN_HEIGHT * 75.0f)/100.0f;
    
    /*** 发现设备按钮 ***/
    UIButton *findDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, btn_height)];
    findDeviceButton.backgroundColor = [UIColor clearColor];
    findDeviceButton.center = CGPointMake(findDeviceButton_center_x, findDeviceButton_center_y);
    //设置圆角
    [findDeviceButton.layer setMasksToBounds:YES];
    findDeviceButton.layer.cornerRadius = 5.0f;
    //设置线宽
    findDeviceButton.layer.borderWidth = 1;
    findDeviceButton.layer.borderColor = RGBCOLOR(0, 160, 233).CGColor;
    
    //按钮文字
    findDeviceButton.titleLabel.font = [UIFont systemFontOfSize: (btn_height * 0.35)];
    [findDeviceButton setTitleColor:RGBCOLOR(102, 172, 237) forState:UIControlStateNormal];
    [findDeviceButton setTitle:@"绑定此设备" forState:UIControlStateNormal];
    
    //添加点击事件
    [findDeviceButton addTarget:self action:@selector(onclick_findBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:findDeviceButton];
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

//修改名称的点击事件
-(void)onclick_change_name:(id)sender
{
    NSLog(@"修改名称");
}

//防丢功能的点击事件
-(void)onclick_loose_device:(id)sender
{
    if (_LOOSE_DEVICE) {
        _LOOSE_DEVICE = NO;
        _btnImage01.image = [UIImage imageNamed:@"icon_btn_off"];
    }
    else
    {
        _LOOSE_DEVICE = YES;
        _btnImage01.image = [UIImage imageNamed:@"icon_btn_on"];
    }
}

//手机震动的点击事件
-(void)onclick_shake_device:(id)sender
{
    if (_VOICE_DEVICE) {
        _VOICE_DEVICE = NO;
        _btnImage02.image = [UIImage imageNamed:@"icon_btn_off"];
    }
    else
    {
        _VOICE_DEVICE = YES;
        _btnImage02.image = [UIImage imageNamed:@"icon_btn_on"];
    }
}

//提示铃声的点击事件
-(void)onclick_voice_device:(id)sender
{
    NSLog(@"提示铃声");
}

//发现设备点击事件
-(void)onclick_findBtn
{
    NSLog(@"绑定此设备");
}

//给按钮添加点击返回的事件
-(void)setRebackOnclick
{
    //给设备视图添加点击事件
    self.rebackImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_function:)];
    [self.rebackImageView addGestureRecognizer:onclick_view];
}

//点击事件
-(void)onclick_function:(id)sender
{
    //返回事件 - 暂时使用默认动画
    [self dismissViewControllerAnimated:YES completion:NULL];
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

//
//  AppDelegateViewController.m
//  Vapesoul
//
//  Created by tyz on 17/7/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "AppDelegateViewController.h"

@interface AppDelegateViewController ()

@end

@implementation AppDelegateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载头部
    float headview_height = (SCREEN_HEIGHT * 9.5)/100.0f;
    _headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headview_height)];
    _headview.backgroundColor = RGBCOLOR(49, 49, 49);
    [self.view addSubview:_headview];
    
    //加载头部文字
    float text_height = ((SCREEN_HEIGHT * 9.5)/100.0f) - 20.0f;
    float text_x = (SCREEN_WIDTH * 50)/100.0f;
    float text_y = (text_height/2.0f) + 15.0f;
    _headLableView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, text_height)];
    _headLableView.center = CGPointMake(text_x, text_y);
    _headLableView.text = @"Vapesoul";
    _headLableView.backgroundColor = [UIColor clearColor];
    _headLableView.textColor = [UIColor whiteColor];
    _headLableView.textAlignment = NSTextAlignmentCenter;
    _headLableView.font = [UIFont systemFontOfSize:(text_height*0.5)];
    [self.view addSubview:_headLableView];
    
    //返回按钮
    float rebackImageView_height = (SCREEN_HEIGHT * 3.0f)/100.0f;
    float rebackImageView_width = (rebackImageView_height * 13.0f)/24.0f;
    
    float rebackImageView_center_x = (SCREEN_WIDTH * 2.5f)/100.0f;
    float rebackImageView_center_y = (SCREEN_HEIGHT * 5.0f)/100.0f;
    
    _rebackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rebackImageView_center_x, rebackImageView_center_y, rebackImageView_width, rebackImageView_height)];
    _rebackImageView.image = [UIImage imageNamed:@"btn_left"];
    [self.view addSubview:_rebackImageView];
    
    //设置背景
    [self.view setBackgroundColor:RGBACOLOR(241,241,241,0.95)];
}

-(void)setRebackImageViewHiden: (Boolean)hiden
{
    if (hiden)
    {
        _rebackImageView.hidden = YES;
    }
    else
    {
        _rebackImageView.hidden = NO;
    }
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

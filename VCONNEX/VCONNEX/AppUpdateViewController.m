//
//  AppUpdateViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "AppUpdateViewController.h"

@interface AppUpdateViewController ()

@end

@implementation AppUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"App Update";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addlogoView];
}

-(void)addlogoView
{
    float view_width = (SCREEN_WIDTH * 2.0f)/3.0f;
    float view_height = view_width * (260.0f / 450.0f);
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view_width, view_height)];
    
    logoImage.center = CGPointMake((SCREEN_WIDTH/2.0f), 64 + 10.0f + (view_height / 2.0f));
    
    logoImage.image = [UIImage imageNamed:@"icon_logo"];
    
    [self.view addSubview:logoImage];
    
    //添加Lable
    UILabel *lableView = [[UILabel alloc]initWithFrame:CGRectMake(0,(64 + 30.0f + view_height), SCREEN_WIDTH, 30)];
    
    lableView.textAlignment = NSTextAlignmentCenter;
    
    lableView.text = @"1.0.1 (App version)";
    
    [self.view addSubview:lableView];
    
    //添加Lable
    UILabel *lableViewUpdate = [[UILabel alloc]initWithFrame:CGRectMake(0,(64 + 30.0f + 30.0f + view_height), SCREEN_WIDTH, 30)];
    
    lableViewUpdate.textAlignment = NSTextAlignmentCenter;
    
    lableViewUpdate.text = @"Go to the App Store";
    
    [self.view addSubview:lableViewUpdate];
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

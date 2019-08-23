//
//  delegateViewController.m
//  uVapour
//
//  Created by 田阳柱 on 16/9/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

/**
 *  在delegateViewController里面设置统一性的界面元素
 */

#import "DelegateViewController.h"
#import "TitleView.h"

@interface DelegateViewController ()

@end

@implementation DelegateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置设备的名字的view
//    _titleView = [[[NSBundle mainBundle]loadNibNamed:@"TitleView" owner:self options:nil]lastObject];
//    _titleView.backgroundColor = [UIColor clearColor];
//    [self.navigationItem setTitleView:_titleView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
//    //去掉返回按钮上的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮颜色 58ffd0
    self.navigationController.navigationBar.tintColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
    
//    //改变返回按钮颜色为白色
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    //设置导航栏标题文字以及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //设置电池为白色
    [self preferredStatusBarStyle];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置导航栏背景图片
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_fooder"]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//    imageview.image = [UIImage imageNamed:@"icon_background"];
    
//    [self.view addSubview:imageview];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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

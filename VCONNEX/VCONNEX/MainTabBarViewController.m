//
//  MainTabBarViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

// 根据16位RBG值转换成颜色，格式:UIColorFrom16RGB(0xFF0000)

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //默认选中第二个
    self.selectedIndex = 1;
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

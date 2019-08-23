//
//  BatteryViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "BatteryViewController.h"
#import "TYZ_BLE_Protocol.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Service.h"
#import "ProgressHUD.h"

@interface BatteryViewController ()

@end

@implementation BatteryViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        //查询电池电量
        [TYZ_BLE_Protocol sendData_D3];
    }
    else
    {
        [ProgressHUD showError:@"No device to connect"];
    }
    
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
}

- (IBAction)btn_home_onclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
    }];
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

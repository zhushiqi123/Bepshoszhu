//
//  VapedViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "VapedViewController.h"
#import "ChartViewController.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Service.h"
#import "ProgressHUD.h"

@interface VapedViewController ()

@end

@implementation VapedViewController

//页面即将加载，调用蓝牙查询
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        //发送查询吸烟口数信息
        [TYZ_BLE_Protocol sendData_D4:0x01];
    }
    else
    {
        NSLog(@"No device to connect");
    }
    
    //layout size
    [self.puffsView1_width setConstant:(ViewWidth/2)];
    [self.puffsView1_height setConstant:((ViewWidth/3))];
    [self.puffsBtn1_width setConstant:(((ViewWidth/2)/3))];
    [self.puffsBtn1_height setConstant:(((ViewWidth/2)/3))];
    
    [self.moneyView2_width setConstant:(ViewWidth/2)];
    [self.moneyView2_height setConstant:((ViewWidth/3))];
    [self.moneyBtn2_width setConstant:(((ViewWidth/2)/3))];
    [self.moneyBtn2_height setConstant:(((ViewWidth/2)/3))];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
    
    [TYZ_BLE_Service sharedInstance].notifyHandlerD4 = ^(int smoke_all_number)
    {
        NSLog(@"smoke_all_number - %d",smoke_all_number);
        [TYZ_Session sharedInstance].smoke_all_number = smoke_all_number;
        
        _num_text.text = [NSString stringWithFormat:@"%d",[TYZ_Session sharedInstance].smoke_all_number];
    };
    
    if ([TYZ_Session sharedInstance].smoke_all_number)
    {
        _num_text.text = [NSString stringWithFormat:@"%d",[TYZ_Session sharedInstance].smoke_all_number];
    }
    else
    {
        _num_text.text = @"0";
    }
}

- (IBAction)btn_home_onclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
    }];
}

- (IBAction)btn_puffs_onclick:(id)sender
{
    _title_text.text = @"VAPING DATA";
    if ([TYZ_Session sharedInstance].smoke_all_number) {
        _num_text.text = [NSString stringWithFormat:@"%d",[TYZ_Session sharedInstance].smoke_all_number];
    }
    else
    {
        _num_text.text = @"0";
    }
    _today_text.text = @"PUFFS TAKEN TODAY";
//    NSLog(@"btn_puffs_onclick");
}

- (IBAction)btn_money_onclick:(id)sender
{
    _title_text.text = @"MONEY SAVED";
    _num_text.text = @"27";
    _today_text.text = @"MONEY SAVED TODAY";
//    NSLog(@"btn_money_onclick");
}

- (IBAction)onclick_clean_puffs:(id)sender
{
    //Clean PUFFS
//    [TYZ_Session sharedInstance].smoke_all_number = 0;
//    _num_text.text = [NSString stringWithFormat:@"%d",[TYZ_Session sharedInstance].smoke_all_number];
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        //发送清除口数命令
        [TYZ_BLE_Protocol sendData_D1:0x00];
    }
    else
    {
        [ProgressHUD showError:@"No device to connect"];
    }
}

- (IBAction)onclick_clean_all:(id)sender
{
    //Clean ALL
    [TYZ_Session sharedInstance].smoke_all_number = 0;
    _num_text.text = [NSString stringWithFormat:@"%d",[TYZ_Session sharedInstance].smoke_all_number];
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        //发送清除口数命令
        [TYZ_BLE_Protocol sendData_D4:0x00];
    }
    else
    {
        [ProgressHUD showError:@"No device to connect"];
    }
}

- (void)didReceiveMemoryWarning
{
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

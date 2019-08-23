//
//  DemoViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/8/26.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "DemoViewController.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Protocol.h"
#import "TYZ_BLE_Service.h"
#import "ProgressHUD.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
    
    //接收数据
    [TYZ_BLE_Service sharedInstance].notifyHandlerD8 = ^(int checkNum)
    {
        //If you want to get the back data, you need implement this method
        if (checkNum == 0)
        {
            [ProgressHUD showSuccess:nil];
        }
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:@"Update Device Name Error"];
        }
    };
}

- (IBAction)sendDeviceName:(id)sender
{
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        NSString *deviceName = self.textName.text;
        
//        NSLog(@"deviceName - > %@",deviceName);
        
        if (![deviceName isEqualToString:@""])
        {
            [ProgressHUD show:nil];
            //发送设备名称
            [TYZ_BLE_Protocol sendData_D8:deviceName];
        }
    }
    else
    {
        [ProgressHUD showError:@"No device to connect"];
    }
}

- (IBAction)btn_home_onclick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
    }];
}

//find device ID
- (IBAction)onclick_btn_findId:(id)sender
{
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        [TYZ_BLE_Protocol sendData_D9];
        
        [TYZ_BLE_Service sharedInstance].notifyHandlerD9 = ^(NSString *ID_str)
        {
            NSLog(@"Device ID is -> %@",ID_str);
            self.deviceIDText.text = ID_str;
        };
    }
    else
    {
        [ProgressHUD showError:@"No device to connect"];
    }
}

//- (IBAction)SetID:(id)sender
//{
//    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
//    {
//        NSString *deviceID = self.setDeviceIdText.text;
//        
//        //        NSLog(@"deviceName - > %@",deviceName);
//        
//        if (![deviceID isEqualToString:@""])
//        {
//            [ProgressHUD show:nil];
//            //发送设备名称
//            [TYZ_BLE_Protocol sendData_D9_ID:deviceID];
//            
//            [TYZ_BLE_Service sharedInstance].notifyHandlerD9 = ^(NSString *str_id)
//            {
//                if ([str_id isEqualToString:@"SUCCESS"])
//                {
//                    [ProgressHUD showSuccess:str_id];
//                }
//            };
//        }
//    }
//    else
//    {
//        [ProgressHUD showError:@"No device to connect"];
//    }
//}


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

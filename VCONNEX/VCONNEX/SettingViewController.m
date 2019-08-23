//
//  SettingViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewTableViewCell.h"
#import "AboutUsViewController.h"
#import "AfterServiceViewController.h"
#import "FirmwareUpdateViewController.h"
#import "AppUpdateViewController.h"
#import "STW_BLE_SDK.h"
#import "AlertViewInputBoxView.h"
#import "UIView+MJAlertView.h"
#import "TYZFileData.h"
#import "ProgressHUD.h"

@interface SettingViewController ()
{
    NSArray *tableViewData_arry;
    NSArray *tableViewCell_title_arry_en;
    NSArray *tableViewCell_image_arry;
    
    
    //防止连续点击  0 - 空闲  1 - 繁忙状态
    int  check_btn_type;
}

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    check_btn_type = 0;
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Setting";
    
    check_btn_type = 0;
    
    //设置tableview 结构信息
    tableViewData_arry =  [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    
    tableViewCell_title_arry_en = [NSArray arrayWithObjects:@"Turn on/off",@"About us",@"After service",@"Firmware update",@"App update",@"Clean Cache" ,nil];
    
    tableViewCell_image_arry = [NSArray arrayWithObjects:@"icon_turn_off",@"icon_about",@"icon_service",@"icon_update",@"icon_app_update",@"icon_clean_cache",nil];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    
    _tableview.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableview];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.tableview.tableFooterView=[[UIView alloc]init];//关键语句
    
    //在viewDidLoad设置tableview分割线
    [self.tableview setSeparatorColor:[UIColor groupTableViewBackgroundColor]];
    self.tableview.separatorInset = UIEdgeInsetsMake(0,51, 0, 0);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
//    //设置右边button
//    UIButton *setButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, 5, 35, 35)];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setButton];
//    
//    [setButton setBackgroundImage:[UIImage imageNamed:@"icon_BLE_off"] forState:UIControlStateNormal];
//    
//    [setButton addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchDown];
}

//-(void)clickAddBtn
//{
//    NSLog(@"ww");
//}

#pragma tyz - Table View
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableViewData_arry.count;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableViewData_arry[section] intValue];
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"SettingViewTableViewCell";
    SettingViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    int pageNum = [self return_pagenum:(int)indexPath.section :(int)indexPath.row];
    
    //名称
    NSString *lable_str = [NSString stringWithFormat:@"%@",tableViewCell_title_arry_en[pageNum]];
    cell.cellLable.text = lable_str;
    
    NSString *lable_image = [NSString stringWithFormat:@"%@",tableViewCell_image_arry[pageNum]];
    cell.cellImage.image = [UIImage imageNamed:lable_image];
    
    if (pageNum == 0)
    {
        if ([STW_BLE_SDK STW_SDK].keys_num >= 3)
        {
            cell.keyNums_lable.text = [NSString stringWithFormat:@"%d",[STW_BLE_SDK STW_SDK].keys_num];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //设置间隔高度
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //设置间隔高度
    return 0.00001f;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int nums = [self return_pagenum:(int)indexPath.section :(int)indexPath.row];
    
    if([self check_btn_type_function])
    {
        switch (nums)
        {
            case 0:
            {
                if ([STW_BLEService sharedInstance].isBLEStatus)
                {
                    [ProgressHUD show:nil];
                }
                
                //设置开关机按键次数 - 发送查询命令
                [STW_BLE_Protocol the_find_keyNum];
                //注册查询回调
                [self the_find_keyNum_back];
            }
                break;
                
            case 1:
            {
                self.tabBarController.tabBar.hidden = YES;
                
                AboutUsViewController *AboutUsView = [[AboutUsViewController alloc] init];
                //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
                [self.navigationController pushViewController: AboutUsView animated:true];
            }
                break;
                
            case 2:
            {
                self.tabBarController.tabBar.hidden = YES;
                
                AfterServiceViewController *AfterServiceView = [[AfterServiceViewController alloc] init];
                //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
                [self.navigationController pushViewController: AfterServiceView animated:true];
            }
                break;
                
            case 3:
            {
                if ([STW_BLEService sharedInstance].isBLEStatus)
                {
                    [ProgressHUD show:nil];
                }
                
                //向APP查询硬件版本
                [STW_BLE_Protocol the_Find_deviceData];
                
                //注册查询回调
                [STW_BLEService sharedInstance].Service_Find_DeviceData = ^(int Device_Version,int Soft_Version)
                {
                    self.tabBarController.tabBar.hidden = YES;
                    
                    FirmwareUpdateViewController *FirmwareUpdateView = [[FirmwareUpdateViewController alloc] init];
                    
                    FirmwareUpdateView.deviceVersion = Device_Version;
                    //                FirmwareUpdateView.deviceVersion = 8697;
                    
                    [ProgressHUD dismiss];
                    //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
                    [self.navigationController pushViewController: FirmwareUpdateView animated:true];
                };
            }
                break;
                
            case 4:
            {
                self.tabBarController.tabBar.hidden = YES;
                
                AppUpdateViewController *AppUpdateView = [[AppUpdateViewController alloc] init];
                //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
                [self.navigationController pushViewController: AppUpdateView animated:true];
            }
                break;
            case 5:
            {
                //清除缓存
                NSMutableArray *arrysFile = [NSMutableArray array];
                [TYZFileData SaveDeviceData:arrysFile];
                
                [UIView addMJNotifierWithText:@"Clean Cache Success" dismissAutomatically:YES];
            }
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        [ProgressHUD showError:@"Click too often"];
    }
}

-(void)the_find_keyNum_back
{
    [STW_BLEService sharedInstance].Service_SetKeyNums = ^(int keys_num)
    {
        [ProgressHUD dismiss];
        
        if (keys_num == -1)
        {
            [UIView addMJNotifierWithText:[NSString stringWithFormat:@"Save Success %d",[STW_BLE_SDK STW_SDK].keys_num] dismissAutomatically:YES];
            
            //刷新UI
            [self.tableview  reloadData];
        }
        else
        {
            [STW_BLE_SDK STW_SDK].keys_num = keys_num;
            
            //弹出修改界面
            AlertViewInputBoxView* view = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewInputBoxView" owner:self options:nil] lastObject];
            [view showViewWith:keys_num];
            //设置回调
            view.keyInput = ^(int keyNums)
            {
                [STW_BLE_SDK STW_SDK].keys_num = keyNums;
                //得到key
                NSLog(@"keyNum - %d",keyNums);
                //设置锁机次数
                [STW_BLE_Protocol the_set_keyNum:[STW_BLE_SDK STW_SDK].keys_num];
            };
        }
    };
}

//返回当前的格数
-(int)return_pagenum:(int)setion :(int)row
{
    int pagenum = 0;
    
    switch (setion)
    {
        case 0:
            pagenum = row;
            break;
        case 1:
            pagenum = row + 1;
            break;
        case 2:
            pagenum = row + 3;
            break;
            
        default:
            break;
    }
    
    return pagenum;
}

-(BOOL)check_btn_type_function
{
    if (check_btn_type == 0)
    {
        //check_btn_type 不可点击状态
        check_btn_type = 1;
        
        double delayInSeconds = 3.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [ProgressHUD dismiss];
                           //check_btn_type 退回可点击状态
                           check_btn_type = 0;
                       });
        return YES;
    }
    
    return NO;
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

//
//  DashboardViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCell.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Protocol.h"
#import "TYZ_BLE_Service.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController
{
    NSArray *arry_title;
    NSArray *arry_lable_big;
    NSArray *arry_lable_small;
    NSArray *arry_btn;
    NSMutableArray *arry_btn_text;
    
    NSArray *arry_switch;
    NSMutableArray *check_arry_switch;
    
    NSArray *arry_tion_alarm;
    NSArray *arry_power;
    NSArray *arry_language;
    
    NSMutableArray *array_pick;
    
    int check_btn;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.pickerView.hidden = YES;
    
    if (!check_btn)
    {
        arry_title = [NSArray arrayWithObjects:@"lock_icon",@"vibration_icon",@"power_icon",@"language_icon",nil];
        
        arry_lable_big = [NSArray arrayWithObjects:@"LOCK DEVICE",@"SET VIBRA TION ALARM",@"POWER MODE",@"LANGUAGE SETTINGS",nil];
        
        arry_lable_small = [NSArray arrayWithObjects:@"This setting allows you to lock your be posh Pro",@"Select your puff limit alarm here",@"Select your preferred power mode",@"Select your preferred Display language",nil];
        
        arry_btn_text = [NSMutableArray arrayWithObjects:@"0",@"30",@"DEFAULT",@"DEUTSCH",nil];
        
        arry_btn = [NSArray arrayWithObjects:@"0",@"1",@"1",@"1",nil];
        
        arry_switch = [NSArray arrayWithObjects:@"1",@"1",@"0",@"0",nil];
        
        check_arry_switch = [NSMutableArray arrayWithObjects:@"1",@"1",@"0",@"0",nil];
        
        arry_tion_alarm = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",nil];
        
        arry_power = [NSArray arrayWithObjects:@"FULL POWER",@"DEFAULT",@"SAVER",@"ECO",nil];
        
        arry_language = [NSArray arrayWithObjects:@"DEUTSCH",@"ENGLISH",nil];
        
        if ([TYZ_Session sharedInstance].lock_device)
        {
            switch ([TYZ_Session sharedInstance].lock_device) {
                case 0:
                    check_arry_switch[0] = @"1";
                    break;
                case 1:
                    check_arry_switch[0] = @"0";
                    break;
                    
                default:
                    break;
            }
        }
        
        if ([TYZ_Session sharedInstance].tion_alarm)
        {
            switch ([TYZ_Session sharedInstance].tion_alarm) {
                case 0:
                    check_arry_switch[1] = @"1";
                    break;
                case 1:
                    check_arry_switch[1] = @"0";
                    break;
                default:
                    break;
            }
        }
        
        if ([TYZ_Session sharedInstance].tion_alarm_num)
        {
            arry_btn_text[1] = arry_tion_alarm[[TYZ_Session sharedInstance].tion_alarm_num - 1];
        }
        
        if ([TYZ_Session sharedInstance].power_mode)
        {
            switch ([TYZ_Session sharedInstance].power_mode)
            {
                case 0xa9:
                    arry_btn_text[2] = arry_power[3];
                    break;
                    
                case 0xCD:
                     arry_btn_text[2] = arry_power[2];
                    break;
                case 0xD7:
                     arry_btn_text[2] = arry_power[0];
                    break;
                default:
                     arry_btn_text[2] = arry_power[1];
                    break;
            }
        }
        
        if ([TYZ_Session sharedInstance].language_type)
        {
            arry_btn_text[3] = arry_language[[TYZ_Session sharedInstance].language_type];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    //写到viewDidLoad的方法里面
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView=[[UIView alloc]init];//关键语句
    
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
    
    /**
     *  电子烟是否锁机  - device -lock
     *
     *  @param lock     开锁机状态 0:开机 1:锁机
     *  @param lock_way 锁机方式 0:蓝牙锁机 1:按键锁机
     *
     */
    [TYZ_BLE_Service sharedInstance].notifyHandlerD5 = ^(int lock,int lock_way)
    {
        NSLog(@"DashboardViewController - lock - %d,lock_way - %d",lock,lock_way);
        
        [TYZ_Session sharedInstance].lock_device = lock;
        
        switch (lock)
        {
            case 0:
                check_arry_switch[0] = @"1";
                break;
                
            case 1:
                check_arry_switch[0] = @"0";
                break;
                
            default:
                break;
        }
        
        [_tableView reloadData];
    };
}

- (IBAction)btn_home_onclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
    }];
}

#pragma tyz - PickView
//设置PickerView一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//设置PickerView行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

//返回设置PickerView一列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return array_pick.count;
}

//显示数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",array_pick[row]];
}

//滚动PickView的时候调用
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"选中 -- %d列",row);
    
    switch (check_btn)
    {
        case 1:
            arry_btn_text[1] = arry_tion_alarm[row];
            //发送数据
            int nums =  [arry_btn_text[1] intValue];
            [TYZ_Session sharedInstance].tion_alarm_num = nums;
            [TYZ_BLE_Protocol sendData_D1:nums];
            break;
        case 2:
            arry_btn_text[2] = arry_power[row];
            //发送数据
            switch (row) {
                case 0:
                    [TYZ_Session sharedInstance].power_mode = 0xD7;
                    [TYZ_BLE_Protocol sendData_D2:[TYZ_Session sharedInstance].power_mode];
                    break;
                case 1:
                    [TYZ_Session sharedInstance].power_mode = 0xBD;
                    [TYZ_BLE_Protocol sendData_D2:[TYZ_Session sharedInstance].power_mode];
                    break;
                case 2:
                    [TYZ_Session sharedInstance].power_mode = 0xCD;
                    [TYZ_BLE_Protocol sendData_D2:[TYZ_Session sharedInstance].power_mode];
                    break;
                case 3:
                    [TYZ_Session sharedInstance].power_mode = 0xa9;
                    [TYZ_BLE_Protocol sendData_D2:[TYZ_Session sharedInstance].power_mode];
                    break;
                default:
                    break;
            }
            break;
        case 3:
            arry_btn_text[3] = arry_language[row];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];

    self.pickerView.hidden = YES;
}

#pragma tyz - Table View
//[tableview reloadData];   //刷新列表

//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Cell = @"DashboardCell";
    
    DashboardCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    
    if (cell == nil)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:Cell owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    int row = (int)[indexPath row];
    
    cell.title_lable.image = [UIImage imageNamed:arry_title[row]];
    
    cell.lable_big.text = arry_lable_big[row];
    
    cell.lable_small.text = arry_lable_small[row];
    
    int btn_num = [arry_btn[row] intValue];
    
    int switch_num = [arry_switch [row] intValue];
    
    if (btn_num == 0)
    {
        cell.btn_onclick.hidden = YES;
    }
    else if (btn_num == 1)
    {
        [cell.btn_onclick setTitle:arry_btn_text[row] forState:UIControlStateNormal] ;
        cell.btn_onclick.tag = indexPath.row;
        [cell.btn_onclick addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchDown];
    }
    
    if (switch_num == 0)
    {
        cell.switch_cell.hidden = YES;
    }
    else
    {
        cell.switch_cell.tag = indexPath.row;
        
        int check_num = [check_arry_switch[indexPath.row] intValue];
        
        if (check_num == 1)
        {
            [cell.switch_cell setBackgroundImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.switch_cell setBackgroundImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        }
        
        [cell.switch_cell addTarget:self action:@selector(switch_click:) forControlEvents:UIControlEventTouchDown];
    }
    return cell;
}

//按钮点击事件
-(void)btn_click:(id)sender
{
    check_btn = [sender tag];
//    NSLog(@"按钮 -- > %d",check_btn);
    array_pick = [NSMutableArray array];
    
    switch (check_btn)
    {
        case 1:
            array_pick = [arry_tion_alarm copy];
            break;
        case 2:
            array_pick = [arry_power copy];
            break;
        case 3:
            array_pick = [arry_language copy];
            break;
        default:
            break;
    }

    [self.pickerView reloadComponent:0];
    self.pickerView.hidden = NO;
}

//开关按钮点击事件
-(void)switch_click:(id)sender
{
    NSLog(@"第 -> %ld 开关",(long)[sender tag]);
    int row_num = [sender tag];
    int check_num_btn = [check_arry_switch[row_num] intValue];
    
    if (check_num_btn == 1)
    {
        check_arry_switch[row_num] = @"0";
        [self buildData_btn:row_num :0];
    }
    else
    {
        check_arry_switch[row_num] = @"1";
        [self buildData_btn:row_num :1];
    }
    
    check_btn = 4;
    
    [_tableView reloadData];
}

//按钮改变的方法
-(void)buildData_btn:(int)row_num :(int)check_num
{
    switch (row_num)
    {
        case 0:
        {
            if (check_num == 1)
            {
                [TYZ_Session sharedInstance].lock_device = 0;
                [TYZ_BLE_Protocol sendData_D5:0];
            }
            else
            {
                [TYZ_Session sharedInstance].lock_device = 1;
                [TYZ_BLE_Protocol sendData_D5:1];
            }
        }
            break;
        case 1:
            if (check_num == 1)
            {
                [TYZ_Session sharedInstance].tion_alarm = 0;
                int nums =  [arry_btn_text[1] intValue];
                [TYZ_BLE_Protocol sendData_D1:nums];
            }
            else
            {
                [TYZ_Session sharedInstance].tion_alarm = 1;
                [TYZ_BLE_Protocol sendData_D1:0xFF];
            }
            break;
            
        default:
            break;
    }
}

/*****************Align on each line*****************/
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
/*************************************************/

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

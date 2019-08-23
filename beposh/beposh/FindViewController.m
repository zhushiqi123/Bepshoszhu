//
//  FindViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "FindViewController.h"
#import "TYZ_BLE_Service.h"
#import "TYZ_BLE_Service.h"
#import "AlertView.h"
#import "TYZ_Session.h"

@interface FindViewController ()
{
    int check_BLE_btn;
    UIActivityIndicatorView* _activityIndicatorView;
}

@end

@implementation FindViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    check_BLE_btn = 0;
    [TYZ_BLE_Service sharedInstance].scanedDevices = [NSMutableArray array];
    [[TYZ_BLE_Service sharedInstance] scanStop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];

    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    self.tableVIew.tableFooterView=[[UIView alloc]init];
}

#pragma tyz - Table View
//[tableview reloadData];   //刷新列表
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//设置每个Cell的高度 - cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([TYZ_BLE_Service sharedInstance].scanedDevices.count)
    {
        return [TYZ_BLE_Service sharedInstance].scanedDevices.count;
    }
    else
    {
        return 0;
    }
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    NSUInteger row = [indexPath row];
    TYZ_BLE_Device *device = [TYZ_BLE_Service sharedInstance].scanedDevices[row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",device.deviceName];
    return cell;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[TYZ_BLE_Service sharedInstance] scanStop];
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"-->第%d行",(int)indexPath.row);
    
    //调用蓝牙连接方法
    TYZ_BLE_Device *device = [TYZ_BLE_Service sharedInstance].scanedDevices[indexPath.row];
    [[TYZ_BLE_Service sharedInstance] connect:device];
    
    AlertView* view = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] lastObject];
    [view showViewWith:[NSString stringWithFormat:@"%@:Connected",device.deviceName]];

    //跳转主页面
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"向蓝牙发送查询命令 - Find Data");
    }];
}

/******************分割线对齐左右两端*****************/
-(void)viewDidLayoutSubviews {
    
    if ([self.tableVIew respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableVIew setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableVIew respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableVIew setLayoutMargins:UIEdgeInsetsZero];
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


- (IBAction)btn_home_onclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
        [[TYZ_BLE_Service sharedInstance] scanStop];
    }];
}

- (IBAction)btn_scan_onclick:(id)sender
{
    //如果有蓝牙连接先断开所有设备
    [[TYZ_BLE_Service sharedInstance] disconnect:[TYZ_BLE_Service sharedInstance].device.peripheral];
    [TYZ_Session sharedInstance].check_BLE_status = 1;
    
    [TYZ_BLE_Service sharedInstance].Status_Connect = BLEConnectStatusOff;
    
    if(check_BLE_btn == 0)
    {
        NSLog(@"Start Scan");
        
        //扫描列表置为空
        [TYZ_BLE_Service sharedInstance].scanedDevices = [NSMutableArray array];
        //刷新列表
        [_tableVIew reloadData];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.color = [UIColor whiteColor];
        _activityIndicatorView.center = self.view.center;
        [self.view addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
        
        check_BLE_btn = 1;
        [[TYZ_BLE_Service sharedInstance] scanStart];
        [_btn_scan setTitle:@"STOP" forState:UIControlStateNormal];
        
        [self performSelector:@selector(stop_scan) withObject:nil afterDelay:5.0f];
        
        [TYZ_BLE_Service sharedInstance].scanHandler = ^(TYZ_BLE_Device *device)
        {
            //刷新列表
            [_tableVIew reloadData];
        };
    }
    else
    {
        check_BLE_btn = 0;
        
        [_activityIndicatorView stopAnimating];
        [_activityIndicatorView hidesWhenStopped];
        
        //结束扫描蓝牙
        [[TYZ_BLE_Service sharedInstance] scanStop];
        [_btn_scan setTitle:@"SCAN" forState:UIControlStateNormal];
    }
}

- (void)stop_scan
{
    check_BLE_btn = 0;
    
    [_activityIndicatorView stopAnimating];
    [_activityIndicatorView hidesWhenStopped];
    
    //结束扫描蓝牙
    [[TYZ_BLE_Service sharedInstance] scanStop];
    [_btn_scan setTitle:@"SCAN" forState:UIControlStateNormal];
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

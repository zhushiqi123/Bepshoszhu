//
//  ChartViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "ChartViewController.h"
#import "TYZ_BLE_Protocol.h"
#import "TYZ_BLE_Service.h"
#import "ODRefreshControl.h"
#import "TYZ_Session.h"
#import "ProgressHUD.h"

@interface ChartViewController ()
{
    NSMutableArray *recordStringsArry;
    NSMutableArray *recordNumArry;
    int table_count;
}

@end

@implementation ChartViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        recordStringsArry = [NSMutableArray array];
        recordNumArry = [NSMutableArray array];
        
//        [TYZ_BLE_Protocol sendData_D3];
//        
//        double delayInSeconds = 2.0f;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//                       {
//                           //延时方法
//                           //发送数据查询信息
//                           [TYZ_BLE_Protocol sendData_D7];
//                       });
        //发送数据查询信息
        [TYZ_BLE_Protocol sendData_D7];
    }
    else
    {
        NSLog(@"No device to connect");
//        [ProgressHUD showError:@"No device to connect"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    table_count = 0;
    
    //写到viewDidLoad的方法里面
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView=[[UIView alloc]init];//关键语句

    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view.
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
    
    //接收返回的历史信息 - get record
    [TYZ_BLE_Service sharedInstance].notifyHandlerD7 = ^(NSString *strings,int recordNum)
    {
        //You can get record in this founction - > string - time YYYY-MM-DD   -> recordNum - num %d
        [recordStringsArry addObject:strings];
        [recordNumArry addObject:[NSString stringWithFormat:@"%d",recordNum]];
    };
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        //弹出进度条
        double delayInSeconds = 2.0f;    //需要加载更快可以减少时间 - Wait for the time
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [ProgressHUD showSuccess:nil];
                       
                       table_count = recordStringsArry.count;
                       
                       //刷新列表
                       [_tableView reloadData];   //刷新列表   - Also you can draw curve of the record.
                   });

    }
    else
    {
        NSLog(@"No device to connect");
//        [ProgressHUD showError:@"No device to connect"];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if ([TYZ_Session sharedInstance].check_BLE_status == 0) {
        [ProgressHUD show:nil];
    }
    else
    {
        NSLog(@"No device to connect");
//        [ProgressHUD showError:@"No device to connect"];
    }
}

#pragma tyz - Table View
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return table_count;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Cell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Cell];
        cell.backgroundColor = [UIColor clearColor];
    }
    int row = (int)indexPath.row;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (recordStringsArry.count > row)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",recordStringsArry[row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",recordNumArry[row]];
    }

//    cell.textLabel.text = [NSString stringWithFormat:@"%@",recordDataS.recordTimes];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",recordDataS.recordNum];
    
    return cell;
}


//下拉刷新****************************
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    if ([TYZ_Session sharedInstance].check_BLE_status == 0)
    {
        recordStringsArry = [[NSMutableArray alloc] init];
        recordNumArry = [[NSMutableArray alloc] init];
        
//        //发送数据查询信息
//        [TYZ_BLE_Protocol sendData_D3];
//        
//        double delayInSeconds1 = 2.0f;
//        dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
//        dispatch_after(popTime1, dispatch_get_main_queue(), ^(void)
//                       {
//                           //延时方法
//                           //发送数据查询信息
//                           [TYZ_BLE_Protocol sendData_D7];
//                       });
        
        //发送数据查询信息
       [TYZ_BLE_Protocol sendData_D7];
        
        double delayInSeconds = 3.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           table_count = recordStringsArry.count;
                           //刷新tableView
                           [_tableView reloadData];   //刷新列表
                           
                           [refreshControl endRefreshing];
                       });

    }
    else
    {
        double delayInSeconds = 2.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                            [refreshControl endRefreshing];
                       });
    }
}

/******************分割线对齐左右两端*****************/
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


- (IBAction)btn_home_onclick:(id)sender
{
    //返回
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

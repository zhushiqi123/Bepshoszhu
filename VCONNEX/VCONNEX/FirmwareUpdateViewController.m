//
//  FirmwareUpdateViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "FirmwareUpdateViewController.h"
#import "MJExtension.h"
#import "DownLoadSoftBinViewController.h"
#import "ODRefreshControl.h"
#import "ProgressHUD.h"
#import "AFNetworking.h"
#import "softUpdateBean.h"
#import "STW_BLE_SDK.h"
#import "UpdateSoftCell.h"
#import "UIView+MJAlertView.h"

@interface FirmwareUpdateViewController ()
{
    NSMutableArray *softUpdateArray;
}

@end

@implementation FirmwareUpdateViewController

- (void)viewDidLoad
{
    [ProgressHUD show:nil];
    
    [self getNetData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Firmware Update";
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,64.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f) style:UITableViewStylePlain];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableview];
    
    [self addErrorView];
    
    //设置UItableView
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView=[[UIView alloc]init];//关键语句
    //无分割线
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

-(void)addErrorView
{
    UILabel *errorLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    errorLable.center = self.view.center;
    
    //设置背景
    errorLable.backgroundColor = [UIColor whiteColor];
    
    //设置文字对齐方式
    errorLable.textAlignment = NSTextAlignmentCenter;
    
    //设置文字颜色
    errorLable.textColor =  [UIColor blackColor];      //RGBCOLOR(0x58, 0xff, 0xd0); //0x58ffd0
    
    //设置文字属性
    errorLable.font = [UIFont systemFontOfSize:17.0f];
    
    errorLable.text = @"Refresh";
    
    //设置圆角
    errorLable.layer.cornerRadius = 5.0f;
    
    errorLable.layer.borderWidth = 2;
    
    errorLable.layer.borderColor = [UIColor blackColor].CGColor;
    
    errorLable.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickErrorLable)];
    [errorLable addGestureRecognizer:singleTap];
    
    [self.view addSubview:errorLable];
    
    self.errorLableView = errorLable;
    
    self.errorLableView.hidden = YES;
}

-(void)onClickErrorLable
{
    self.errorLableView.hidden = YES;
    
    [ProgressHUD show:nil];
    
    [self getNetData];
}

-(void)getNetData
{
    //网络获取程序升级信息
    if (self.deviceVersion > 0)
    {
        //测试数据
//        self.deviceVersion = ;
        
        softUpdateArray = [NSMutableArray array];
        
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] init];
        
        [httpSessionManager POST:@"http://www.uvapour.com:8080/stwServices/stw/web/getbinbyid" parameters:@{@"deviceid":@(self.deviceVersion)} progress:^(NSProgress * _Nonnull uploadProgress)
         {
//             NSLog(@"查询适合的升级文件");
         }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
//             NSLog(@"json - %@",responseObject);
             
             int code = [[responseObject objectForKey:@"code"] intValue];
             
             if (code == 1)
             {
                 [ProgressHUD dismiss];
                 
//                 NSLog(@"存在可用的跟新");
                 
                 NSMutableDictionary *dictPowerLineArray = [responseObject objectForKey:@"data"];
                 
                 // 将字典数组转为Device模型数组
                 softUpdateArray = [softUpdateBean mj_objectArrayWithKeyValuesArray:dictPowerLineArray];
                 
                 [self.tableview reloadData];
             }
             else
             {
                 [ProgressHUD dismiss];
//                 NSLog(@"没有可用的更新");
                 
                 [UIView addMJNotifierWithText:@"Not Found Update Package" dismissAutomatically:YES];
//                 self.errorLableView.text = @"Not Found Update Package";
                 
                 self.errorLableView.hidden = NO;
             }

         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             [ProgressHUD dismiss];
             
//             self.errorLableView.text = @"Network Error";
             [UIView addMJNotifierWithText:@"Network Timeout" dismissAutomatically:YES];
             
             self.errorLableView.hidden = NO;

         } ];
    }
}

#pragma tyz - Table View
//[tableview reloadData];   //刷新列表

//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return softUpdateArray.count;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Cell = @"UpdateSoftCell";
    UpdateSoftCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:Cell owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.TitleView.backgroundColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
    
    //设置圆角
    cell.update_view.backgroundColor = [UIColor whiteColor];
    cell.update_view.layer.cornerRadius = 10.0f;
    [cell.update_view.layer setMasksToBounds:YES];
    
    softUpdateBean *softUpdate = [softUpdateArray objectAtIndex:indexPath.row];
    
    NSString *lable_str = [NSString stringWithFormat:@"%@",softUpdate.softName];
    cell.lable_name.text = lable_str;
    
    cell.lable_name.tintColor =  VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);  //0x00bea4
    
    NSString *str_lable_text = [NSString stringWithFormat:@"1.Soft Name：%@\n\n2.Device Version：%@\n\n3.File Name：%@\n",softUpdate.softName,softUpdate.devieName,softUpdate.binname];
    
    cell.lable_data_title.editable = NO;
    cell.lable_data_title.selectable = NO;
    
    cell.lable_data_title.text = str_lable_text;
    
    return cell;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [STW_BLE_SDK STW_SDK].softUpdate_bean = [[softUpdateBean alloc] init];
    
    //取得点击的数据
    [STW_BLE_SDK STW_SDK].softUpdate_bean = [softUpdateArray objectAtIndex:indexPath.row];
    
    DownLoadSoftBinViewController *view = [[DownLoadSoftBinViewController alloc] init];
    //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
    [self.navigationController pushViewController:view animated:true];
}

//下拉刷新****************************
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
//        NSLog(@"1");
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
//        NSLog(@"2");
        return YES;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    //刷新
    [self getNetData];
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //下拉刷新实现的方法
                       [refreshControl endRefreshing];
                       
                       [self.tableview reloadData];
                   });
}
/**********************************************/

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

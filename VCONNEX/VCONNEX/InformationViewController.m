//
//  InformationViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "ODRefreshControl.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
#import "UIView+MJAlertView.h"
#import "informationBean.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "URLWebViewController.h"

@interface InformationViewController ()
{
    AFHTTPSessionManager *httpSessionManager;
}

@end

@implementation InformationViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化
    httpSessionManager = [[AFHTTPSessionManager alloc] init];
    
    // 设置超时时间
    [httpSessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    httpSessionManager.requestSerializer.timeoutInterval = 10.0f;
    [httpSessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    _informationArray = [NSMutableArray array];
    
    self.title = @"Information";
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f - 44.0f) style:UITableViewStylePlain];
    
    _tableview.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableview];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //无分割线
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    [ProgressHUD show:nil];
    [self getNetData];
}

#pragma tyz - Table View
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _informationArray.count;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"InformationTableViewCell";
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.cellBackground.backgroundColor = [UIColor whiteColor];
    cell.cellBackground.layer.cornerRadius = 10.0f;
    [cell.cellBackground.layer setMasksToBounds:YES];
    
    informationBean *inforBean = [_informationArray objectAtIndex:indexPath.row];
    
    cell.lable_title.text = inforBean.title;
    cell.lable_time.text = inforBean.createTime;
    cell.lable_name.text = inforBean.title;
//    cell.news_images.image = [UIImage imageNamed:@"news"];
    NSString *url_str = [NSString stringWithFormat:@"http://www.iccpp.com:8080%@",inforBean.filePath];
    
//    NSURL *urlFilePash = [NSURL URLWithString:url_str];
//    
//    cell.news_images.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:urlFilePash]];
    
    [cell.news_images sd_setImageWithURL:[NSURL URLWithString:url_str]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    informationBean *inforBean = [_informationArray objectAtIndex:indexPath.row];
    
    URLWebViewController *WebView = [[URLWebViewController alloc] init];
    
    WebView.lable_title = inforBean.title;
    WebView.id = inforBean.id;
    
    self.tabBarController.tabBar.hidden = YES;
    
    //解决push跳转卡顿问题就是保证跳转的view是有背景颜色的
    [self.navigationController pushViewController: WebView animated:true];
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
    [self getNetData];
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //下拉刷新实现的方法
                       [refreshControl endRefreshing];
                   });
}
//********************************************

//获取网络数据
-(void)getNetData
{
    [httpSessionManager GET:@"http://www.iccpp.com:8080/mobile/news/list?pagerNo=1&pageSize=10&token=" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
//        NSLog(@"查询新的推荐信息");
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
//        NSLog(@"json - %@",responseObject);
        
        BOOL code = [[responseObject objectForKey:@"common_return"] intValue];
        
        if (code)
        {
            [ProgressHUD dismiss];
            
            NSMutableDictionary *informationLineArray = [responseObject objectForKey:@"return_info"];
            
            // 将字典数组转为Device模型数组
            _informationArray = [informationBean mj_objectArrayWithKeyValuesArray:informationLineArray];
            
            [self.tableview reloadData];
        }
        else
        {
            [ProgressHUD dismiss];
            
            [UIView addMJNotifierWithText:@"Not found information" dismissAutomatically:YES];
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [ProgressHUD dismiss];
        
        [UIView addMJNotifierWithText:@"Network Timeout" dismissAutomatically:YES];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    httpSessionManager = [[AFHTTPSessionManager alloc] init];
    [ProgressHUD dismiss];
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

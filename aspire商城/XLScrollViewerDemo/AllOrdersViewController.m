//
//  AllOrdersViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/21.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "AllOrdersViewController.h"
#import "OrderCell.h"
#import "User.h"
#import "Session.h"
#import "StwClient.h"
#import "ProgressHUD.h"
#import "UserLoginViewController.h"
#import "APViewController.h"
#import "EvaluateViewController.h"

@interface AllOrdersViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *order_idList;
    NSMutableArray *nameList;
    NSMutableArray *goods_numList;
    NSMutableArray *priceList;
    NSMutableArray *timeList;
    NSMutableArray *order_statusList;
    NSMutableArray *order_goods_id;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AllOrdersViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [User order_index:[Session sharedInstance].user.accesskey success:^(NSString *data)
    {
        NSLog(@"data==>%@",data);
    }
    failure:^(NSString *message)
    {
        order_idList = [NSMutableArray array];
        nameList = [NSMutableArray array];
        goods_numList = [NSMutableArray array];
        priceList = [NSMutableArray array];
        timeList = [NSMutableArray array];
        order_statusList = [NSMutableArray array];
        order_goods_id = [NSMutableArray array];
        
        NSLog(@"message==>%@",message);
        
        NSDictionary *data = [StwClient jsonParsing:message];
        NSDictionary *datas = [data objectForKey:@"data"];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        if ([check_code isEqualToString:@"0"])
        {
            NSArray *list = [datas objectForKey:@"list"];
            if (list.count > 0) {
                for (int i = 0; i<[list count]; i++)
                {
                    NSString *name;
                    NSString *goods_id;
                    NSString *goods_num;
                    NSString *price;
                    NSString *order_id;
                    NSString *time;
                    NSString *order_status;
                    //按数组中的索引取出对应的字典
                    NSDictionary *listdic = [list objectAtIndex:i];
                    NSLog(@"---->listdic%@",listdic);
                    //通过字典中的key取出对应value，并且强制转化为NSString类型
                    NSArray *products = [listdic objectForKey:@"products"];

                    for (int j = 0; j < products.count; j++)
                    {
                        order_id = (NSString *)[listdic objectForKey:@"order_id"];
                        time = (NSString *)[listdic objectForKey:@"add_time"];
                        order_status = (NSString *)[listdic objectForKey:@"order_status"];
                        price = (NSString *)[listdic objectForKey:@"goods_amount"];
                        
                        NSDictionary *listdic = [products objectAtIndex:j];
                        
                        name = (NSString *)[listdic objectForKey:@"goods_name"];
//                        NSLog(@"name-->%d%@",j,name);
                        goods_num = (NSString *)[listdic objectForKey:@"goods_number"];
                        goods_id = [listdic objectForKey:@"goods_id"];
                        
                        //将获取的value值放到数组容器中
                        if (![order_id isEqualToString:@""] && order_id)
                        {
                            [order_idList addObject:order_id];
                            [nameList addObject:name];
                            [goods_numList addObject:goods_num];
                            [priceList addObject:price];
                            [timeList addObject:time];
                            [order_statusList addObject:order_status];
                            [order_goods_id addObject:goods_id];
                        }
                    }
                }
                [ProgressHUD dismiss];
                [self.tableView reloadData];
            }
            else
            {
                [ProgressHUD dismiss];
                [ProgressHUD showError:@"没有查找到订单信息"];
            }
        }
        else
        {
//            NSLog(@"message-->%@",message);
            [ProgressHUD dismiss];
            [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
        }
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [ProgressHUD show:nil];
    // Do any additional setup after loading the view.
    self.title = @"我的订单";
    
    _tableView.dataSource = self;    //设置数据代理不设置不会显示数据
    _tableView.delegate = self;
    //设置行高为60，并且取消列表线
    _tableView.rowHeight = 60;
    //    _shopCartUITableView.separatorStyle = NO;
//    _tableView.separatorStyle = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    
    //ios7新特性
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  order_idList.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加可重标示符
    static NSString *ID = @"OrderCell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }

//    NSMutableArray *order_idList;
//    NSMutableArray *nameList;
//    NSMutableArray *goods_numList;
//    NSMutableArray *priceList;
//    NSMutableArray *timeList;
//    NSMutableArray *order_statusList;
    
    cell.order_id.text = order_idList[indexPath.row];
    cell.order_name.text = nameList[indexPath.row];
    cell.order_num.text = goods_numList[indexPath.row];
    cell.order_price.text = priceList[indexPath.row];
    
    int time = [timeList[indexPath.section] intValue];
    
    NSDate *timers = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    NSString *times = [formatter1 stringFromDate:timers];
    
    cell.order_time.text = times;
    
    if ([order_statusList[indexPath.row] isEqualToString:@"0"]) {
        cell.order_state.text = @"未付款";
        cell.order_state.textColor = [UIColor redColor];
    }
    else
    {
        cell.order_state.text = @"已付款";
        cell.order_state.textColor = [UIColor blueColor];
    }
    
    //取消cell选中状态颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    // 实例化TableViewCell时，使用initWithStyle方法来进行实例化
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    //    //设置字体颜色
    //
    //    cell.textLabel.text = @"2222";
    //    // 明细信息
    //    cell.detailTextLabel.text = @"1111";
    
    
    //    shopCartLableCell *shopLableCell = self.
    // 实例化TableViewCell时，使用initWithStyle方法来进行实例化
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([order_statusList[indexPath.row] isEqualToString:@"0"])
    {
        return @"支付";
    }
    else
    {
        return @"评价";
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"====删除第%@行的数据====",indexPath);
    
    if ([order_statusList[indexPath.row] isEqualToString:@"0"])
    {
        NSLog(@"去支付");
        [Session sharedInstance].order_add_id = order_idList[indexPath.row];
        [Session sharedInstance].order_add_price = priceList[indexPath.row];
        NSLog(@"订单提交跳转");
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        APViewController *aPViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"APViewController"];
        [self.navigationController pushViewController:aPViewController animated:YES];
    }
    else
    {
        NSLog(@"去评价");
        NSLog(@"%@",order_goods_id[indexPath.row]);
        [Session sharedInstance].details.goods_id = [order_goods_id[indexPath.row] intValue];
//        [Session sharedInstance].details.goods_id = 51;
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EvaluateViewController *EvaluateViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"EvaluateViewController"];
        [self.navigationController pushViewController:EvaluateViewController animated:YES];
    }
    //    [self delectDevice:[detailTextLabelList objectAtIndex:indexPath.row]];
    //    // 1. 删除self.dataList中indexPath对应的数据
//    [[Session sharedInstance].shopCarss removeObjectAtIndex:indexPath.row];
//    
//    //
//    //    // 2. 刷新表格(重新加载数据)
//    //    //     重新加载所有数据
//    //    //     [self.tableView reloadData];
//    [self.shopCartUITableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    
//    //本地化存储购物车数据
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    [def setObject:[Session sharedInstance].shopCarss forKey:@"data_shopCarss"];
//    
//    [ProgressHUD showSuccess:@"删除成功"];
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

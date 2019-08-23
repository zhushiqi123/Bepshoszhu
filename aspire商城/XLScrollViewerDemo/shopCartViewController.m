//
//  shopCartViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/2.
//  Copyright © 2015年 stw. All rights reserved.
//
#import <UIKit/UIKit.h>  
#import "shopCartViewController.h"
#import "shopCartLableCell.h"
#import "Session.h"
#import "ShopCars.h"
#import "ProgressHUD.h"
#import "IndentViewController.h"

@interface shopCartViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UISegmentedControl *shopCartUISegmented;
@property (nonatomic,retain) IBOutlet UITableView *shopCartUITableView;
@property (nonatomic,retain) IBOutlet UIButton *shopCartNext_btn;
@property (nonatomic,retain) IBOutlet UIButton *shopCartClear_btn;
@property (nonatomic,retain) IBOutlet UIButton *shopCartClose_btn;

@end

@implementation shopCartViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if([Session sharedInstance].shopCarss.count > 0)
    {
        [self.shopCartUITableView reloadData];
    }
    else
    {
        [ProgressHUD showError:@"购物车是空的!"];
        //返回上一页
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.shopCartNext_btn setTitle:@"继续购物" forState:UIControlStateNormal];
    [self.shopCartClear_btn setTitle:@"清空购物车" forState:UIControlStateNormal];
    [self.shopCartClose_btn setTitle:@"结算中心" forState:UIControlStateNormal];
    
    _shopCartUITableView.dataSource = self;    //设置数据代理不设置不会显示数据
    _shopCartUITableView.delegate = self;
    //设置行高为60，并且取消列表线
    _shopCartUITableView.rowHeight = 60;
//    _shopCartUITableView.separatorStyle = NO;

    
    //ios7新特性
    [_shopCartUITableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    /**
     自定义table
     */
    // Do any additional setup after loading the view.
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
    return  [Session sharedInstance].shopCarss.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加可重标示符
    static NSString *ID = @"shopCartLableCell";
    shopCartLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    //取消cell选中状态颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"*****%@",[Session sharedInstance].shopCarss[indexPath.section]);
    
    NSDictionary *shopDatas = [Session sharedInstance].shopCarss[indexPath.row];
    //dataDetails objectForKey:@"goods_sn"]
    cell.goodsName.text = [shopDatas objectForKey:@"goods_name"];
    cell.goodsprice.text  = [shopDatas objectForKey:@"price"];
    cell.goodsNum.text  = [NSString stringWithFormat:@"%@",[shopDatas objectForKey:@"num"]];
    cell.goodsPrices.text  = [shopDatas objectForKey:@"allPrices"];
//
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
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"====删除第%@行的数据====",indexPath);
//    [self delectDevice:[detailTextLabelList objectAtIndex:indexPath.row]];
//    // 1. 删除self.dataList中indexPath对应的数据
    [[Session sharedInstance].shopCarss removeObjectAtIndex:indexPath.row];

//
//    // 2. 刷新表格(重新加载数据)
//    //     重新加载所有数据
//    //     [self.tableView reloadData];
    [self.shopCartUITableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    //本地化存储购物车数据
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[Session sharedInstance].shopCarss forKey:@"data_shopCarss"];
    
    [ProgressHUD showSuccess:@"删除成功"];
}
- (IBAction)ago_next:(id)sender {
    //返回个人中心
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)clean_shopCar:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清空购物车吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > 0)
    {
        [Session sharedInstance].shopCarss = [NSMutableArray array];
        //本地化存储购物车数据
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[Session sharedInstance].shopCarss forKey:@"data_shopCarss"];
        
        [self.shopCartUITableView reloadData];
        [ProgressHUD showSuccess:nil];
    }
}

- (IBAction)orderList_btn:(id)sender
{
    if ([Session sharedInstance].user.accesskey)
    {
        if([Session sharedInstance].shopCarss.count > 0)
        {
//            NSLog(@"订单提交跳转");
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            IndentViewController *IndentViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"IndentViewController"];
            [self.navigationController pushViewController:IndentViewController animated:YES];
        }
        else
        {
            [ProgressHUD showError:@"您的购物车还是空的!"];
        }
    }
    else
    {
        [ProgressHUD showError:@"请先登录!"];
    }
  
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

//
//  AddressListViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/22.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "AddressListViewController.h"
#import "ChangeAddressViewController.h"
#import "addressCell.h"
#import "User.h"
#import "Session.h"
#import "StwClient.h"
#import "ProgressHUD.h"

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *address_id_List;
    NSMutableArray *username_List;
    NSMutableArray *phone_List;
    NSMutableArray *address_list;
    NSMutableArray *addressAA_list;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_newAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation AddressListViewController
-(void)viewDidAppear:(BOOL)animated
{
    [ProgressHUD show:nil];
    [super viewDidAppear:YES];
    [User address_index:[Session sharedInstance].user.accesskey success:^(NSString *data)
     {
         [ProgressHUD dismiss];
         NSLog(@"data==>%@",data);
     }
     failure:^(NSString *message)
     {
         [ProgressHUD dismiss];
         NSLog(@"message===>%@",message);
         address_id_List= [NSMutableArray array];
         username_List = [NSMutableArray array];
         phone_List = [NSMutableArray array];
         address_list = [NSMutableArray array];
         addressAA_list = [NSMutableArray array];
//
//         //        NSLog(@"message==>%@",message);
//         
         NSDictionary *data = [StwClient jsonParsing:message];
         NSDictionary *datas = [data objectForKey:@"data"];
         NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
         if ([check_code isEqualToString:@"0"])
         {
             NSArray *list = [datas objectForKey:@"list"];
             if (list.count > 0) {
                 for (int i = 0; i<[list count]; i++)
                 {
                     //按数组中的索引取出对应的字典
                     NSDictionary *listdic = [list objectAtIndex:i];
                     //通过字典中的key取出对应value，并且强制转化为NSString类型
                     NSString *address_id = (NSString *)[listdic objectForKey:@"address_id"];  //地址列表id
                     NSString *consignee = (NSString *)[listdic objectForKey:@"consignee"];   //收件人姓名
                     NSString *mobile = (NSString *)[listdic objectForKey:@"mobile"];      //收件人电话
                     NSString *country = (NSString *)[listdic objectForKey:@"country"];
                     NSString *province = (NSString *)[listdic objectForKey:@"province"];
                     NSString *city = (NSString *)[listdic objectForKey:@"city"];
                     NSString *district = (NSString *)[listdic objectForKey:@"district"];
                     NSString *address = (NSString *)[listdic objectForKey:@"address"];
                     //将获取的value值放到数组容器中
                     if (![address_id isEqualToString:@""] && address_id)
                     {
                         [address_id_List addObject:address_id];
                         [username_List addObject:consignee];
                         [phone_List addObject:mobile];
                         [address_list addObject:[NSString stringWithFormat:@"%@%@%@%@%@",country,province,city,district,address]];
                         [addressAA_list addObject:[NSString stringWithFormat:@"%@%@%@%@",country,province,city,district]];
                     }
                 }
                 [ProgressHUD dismiss];
                 [self.tableview reloadData];
             }
             else
             {
                 [ProgressHUD dismiss];
                 [ProgressHUD showError:@"没有查询到收货地址信息"];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.btn_newAddress.layer.cornerRadius = 10;
    
    _tableview.dataSource = self;    //设置数据代理不设置不会显示数据
    _tableview.delegate = self;
    //设置行高为60，并且取消列表线
    _tableview.rowHeight = 60;
    //    _shopCartUITableView.separatorStyle = NO;
//        _tableView.separatorStyle = NO;
    _tableview.showsVerticalScrollIndicator = NO;

    //ios7新特性
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    return  address_list.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加可重标示符
    static NSString *ID = @"addressCell";
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.address_name.text = username_List[indexPath.row];
    cell.address_phone.text = phone_List[indexPath.row];
    cell.address.text = address_list[indexPath.row];
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
    
    //取消cell选中状态颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return @"删除";
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *address_id = address_id_List[indexPath.row];
    NSString *addressA = addressAA_list[indexPath.row];
    [Session sharedInstance].address_id = address_id;
    [Session sharedInstance].addressA = addressA;
    
    NSLog(@"被点击了%d->%@",indexPath.row,[Session sharedInstance].address_id);

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChangeAddressViewController *changeAddressViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ChangeAddressViewController"];
    [self.navigationController pushViewController:changeAddressViewController animated:YES];
    
//    ChangeAddressViewController *changeAddressViewController = [[ChangeAddressViewController alloc] init];
//    [self.navigationController pushViewController: changeAddressViewController animated:true];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ProgressHUD show:nil];
    NSLog(@"====删除第%@行的数据====",indexPath);
    [User address_delete:[Session sharedInstance].user.accesskey :[address_id_List[indexPath.row] intValue] success:^(NSString *data)
     {
         NSLog(@"data--->%@",data);
     }
     failure:^(NSString *message)
     {
         NSLog(@"data--->%@",message);
         NSDictionary *data = [StwClient jsonParsing:message];
         NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
         if ([check_code isEqualToString:@"0"])
         {
            [ProgressHUD dismiss];
             // 1. 删除self.dataList中indexPath对应的数据
             [address_id_List removeObjectAtIndex:indexPath.row];
             [username_List removeObjectAtIndex:indexPath.row];
             [phone_List removeObjectAtIndex:indexPath.row];
             [address_list removeObjectAtIndex:indexPath.row];
            [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [ProgressHUD showSuccess:@"删除成功"];
//            //重新加载所有数据
//            [self.tableview reloadData];
         }
         else
         {
             //            NSLog(@"message-->%@",message);
             [ProgressHUD dismiss];
             [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
         }

     }];
    //    [self delectDevice:[detailTextLabelList objectAtIndex:indexPath.row]];
    //    // 1. 删除self.dataList中indexPath对应的数据
    //    [[Session sharedInstance].shopCarss removeObjectAtIndex:indexPath.row];
    //
    //    //
    //    //    // 2. 刷新表格(重新加载数据)
    //    //    //     重新加载所有数据
    //    //    //     [self.tableView reloadData];
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

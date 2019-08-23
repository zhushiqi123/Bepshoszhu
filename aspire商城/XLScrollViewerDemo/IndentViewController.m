//
//  IndentViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/2.
//  Copyright © 2015年 stw. All rights reserved.
//

#import "IndentViewController.h"
#import "STWMyView.h"
#import "goods_listCell.h"
#import "addressCell.h"
#import "Session.h"
#import "ProgressHUD.h"
#import "StwClient.h"
#import "UserAddressViewController.h"
#import "MLTableAlert.h"
#import "APViewController.h"

@interface IndentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *address_id_List;
    NSMutableArray *username_List;
    NSMutableArray *phone_List;
    NSMutableArray *address_list;
    NSMutableArray *addressAA_list;
    
    NSString *name;
    NSString *phone;
    NSString *address_more;
    NSString *addressId;

    float shipping_price; //运费
    
    NSString *string; //商品数量
    NSString *goods_iid; //商品ID
    int shipping_id; //运输方式
    int pay_idd; //支付方式
    int address_idd; //送货地址
    NSString *goods_types; //商品附加属性
    float priceAll;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSArray *title_arrayData;
@property (nonatomic, retain) NSArray *arrayData;
@end

@implementation IndentViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if ([Session sharedInstance].shopCarss.count > 0)
    {
        name = @"收货人姓名";
        phone = @"收货人电话";
        address_more = @"收货人联系地址";
        addressId = @"0";
        goods_types = @"";
        address_idd = [addressId intValue];
        //    NSLog(@"----->初始收货ID%@",addressId);
        [ProgressHUD show:nil];
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
                     if (username_List.count > 0)
                     {
                         name = username_List[0];
                         phone = phone_List[0];
                         address_more = address_list[0];
                         addressId = address_id_List[0];
                         address_idd = [addressId intValue];
    //                     NSLog(@"----->初始收货ID-->%@",addressId);
                     }
                     [ProgressHUD dismiss];
                     [self.tableview reloadData];
                 }
             }
             else
             {
                 //            NSLog(@"message-->%@",message);
                 [ProgressHUD dismiss];
                 [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
             }
         }];
        
        shipping_id = 2; //运输方式
        for (int i = 0; i < [Session sharedInstance].shopCarss.count; i++)
        {
            NSDictionary *shopDatas = [Session sharedInstance].shopCarss[i];
            //dataDetails objectForKey:@"goods_sn"]  attribute_id
    //        NSLog(@"shopDatas--->%@",shopDatas);
            NSString *attribute_idd = [shopDatas objectForKey:@"attribute_id"];
            NSString *num  = [shopDatas objectForKey:@"num"];
            NSString *goods_id = [shopDatas objectForKey:@"goods_id"];
            if (string)
            {
                string = [NSString stringWithFormat:@"%@,%@",string,num];
                goods_iid = [NSString stringWithFormat:@"%@,%@",goods_iid,goods_id];
                if (![attribute_idd isEqualToString:@""]) {
                    goods_types = [NSString stringWithFormat:@"%@,%@",goods_types,attribute_idd];
                }
            }
            else
            {
                string = [NSString stringWithFormat:@"%@",num];
                goods_iid = [NSString stringWithFormat:@"%@",goods_id];
                if (![attribute_idd isEqualToString:@""]) {
                    goods_types = [NSString stringWithFormat:@"%@",attribute_idd];
                }
            }
        }
    //    NSLog(@"goods_types--->%@",goods_types);
        
        //获取运费
        [self get_freight];
    }
    else
    {
        //返回个人中心
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _title_arrayData = [NSArray arrayWithObjects:@"商品列表",@"收货人",@"运输方式",@"支付方式",nil];
    _arrayData = [NSArray arrayWithObjects:@"商品列表",@"收货人",@"顺丰速运",@"支付宝",nil];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = NO;
    _tableview.rowHeight = 180;
    
    [self.btn_price setTitle:@"正在计算" forState:UIControlStateNormal];
    
    [self.btn_freight setTitle:@"运费:加载中..." forState:UIControlStateNormal];
    [self.btn_getClose setTitle:@"下单" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_title_arrayData count];
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    if (indexPath.section == 0)
    {
        int cellH = [Session sharedInstance].shopCarss.count * 60 + 40;
        return cellH;
    }
    else if (indexPath.section == 1)
    {
        return 65;
    }
    else
    {
        return 44;
    }
}

// 返回分组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _title_arrayData[section];
    //    return @"我的";
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //添加可重标示符
        static NSString *ID = @"goods_listCell";
        goods_listCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        }
        //取消cell选中状态颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        //添加可重标示符
        static NSString *ID = @"addressCell";
        addressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        }
        //取消cell选中状态颜色
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.address_name.text = name;
        cell.address_phone.text = phone;
        cell.address.text = address_more;
        
        return cell;
    }
    else
    {
         // 可重用标示符
        static NSString *ID = @"Cell";
        // 让表格缓冲区查找可重用cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 如果没有找到可重用cell
        if (cell == nil)
        {
            // 实例化cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text= _arrayData[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        pay_idd = 1;
        return cell;
    }
   
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            {
                if(username_List.count > 0)
                {
                    [self showTableAlert:@"":@"收货人信息" :(int)username_List.count];
                }
                else
                {
                    [ProgressHUD showError:@"没有查询到收货人信息，请添加新的收货人信息"];
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UserAddressViewController *userAddressViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"UserAddressViewController"];
                    [self.navigationController pushViewController:userAddressViewController animated:YES];
                }
            }
            break;
        case 2:
            {
//                NSLog(@"弹出地址选择");
                [self showTableAlert:@"顺丰速运" :@"运输方式" :1];
            }
            break;
        case 3:
            {
                [self showTableAlert:@"支付宝" :@"支付方式" :1];
            }
            break;
        default:
            break;
    }
}

-(void)showTableAlert:(NSString *)checkPlist :(NSString *)title :(int)num
{
    // create the alert
    self.alert = [MLTableAlert tableAlertWithTitle:title cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                  {
                    return num;
                  }
                  andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                  {
                      if ([checkPlist isEqualToString:@""])
                      {
                          //添加可重标示符
                          static NSString *ID = @"addressCell";
                          addressCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:ID];
                          if (!cell)
                          {
                              //从xlb加载内容
                              cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
                          }
                          
                          cell.address_name.text = username_List[indexPath.row];
                          cell.address_phone.text = phone_List[indexPath.row];
                          cell.address.text = address_list[indexPath.row];
            
                          cell.selectionStyle = UITableViewCellSelectionStyleNone;
                          
                          return cell;
                      }
                      else
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil)
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          
                          cell.textLabel.text = [NSString stringWithFormat:@"%@",checkPlist];
                          
                          return cell;

                      }
                  }];
    
    // Setting custom alert height
    self.alert.height = 350;
    
    // configure actions to perform
    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex)
    {
        if ([checkPlist isEqualToString:@""])
        {
            name = username_List[selectedIndex.row];
            phone = phone_List[selectedIndex.row];
            address_more = address_list[selectedIndex.row];
            addressId = address_id_List[selectedIndex.row];
//            NSLog(@"----->选择的收货ID-->%@",addressId);
            address_idd = [addressId intValue];
            [self.tableview reloadData];
        }
//        NSLog(@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row);
    }
    andCompletionBlock:^{
        NSLog(@"Cancel Button Pressed\nNo Cells Selected");
    }];
    // show the alert
    [self.alert show];
}

- (IBAction)addOrders_btn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认收货地址以及订单信息正确" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(buttonIndex > 0)
    {
        [ProgressHUD show:nil];
        //提交订单并且支付
        NSLog(@"提交订单并且支付");
        //商品ID
        NSLog(@"商品ID->%@",goods_iid);
        //商品数量
        NSLog(@"商品数量->%@",string);
        //运输方式
        NSLog(@"运输方式->%d",shipping_id);
        //商品属性
        NSLog(@"商品属性->%@",goods_types);
        //收货地址id
        NSLog(@"收货地址id->%d",address_idd);
        //支付方式
        NSLog(@"支付方式->%d",pay_idd);
        Order *order = [[Order alloc] init];
        order.goods_id = goods_iid;
        order.goods_quantity = string;
        order.shipping_id = shipping_id;
        order.attribute_id = goods_types;
        order.address_id = address_idd;
        order.pay_id = pay_idd;
        if ([Session sharedInstance].user.accesskey)
        {
            if (order)
            {
                [User order_submit:[Session sharedInstance].user.accesskey :order success:^(NSString *data)
                {
                    NSLog(@"%@",data);
                }
                failure:^(NSString *message)
                {
                    NSLog(@"返回的数据message-->%@",message);
                    NSDictionary *data = [StwClient jsonParsing:message];
                    NSDictionary *datas = [data objectForKey:@"data"];
                    NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
                    if ([check_code isEqualToString:@"0"])
                    {
//                        NSString *order_id = [datas objectForKey:@"data"];
//                        NSString *order_price = [datas objectForKey:@"amount"];
                        [Session sharedInstance].order_add_id = [datas objectForKey:@"data"];
                        [Session sharedInstance].order_add_price = [datas objectForKey:@"amount"];
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        //持久化保存数据
                        if ([Session sharedInstance].order_add_id)
                        {
                             [def setObject:[Session sharedInstance].order_add_id forKey:@"order_add_id"];
                             [def setObject:[Session sharedInstance].order_add_price forKey:@"order_add_price"];
                        }
                        
                        [Session sharedInstance].order_add_id = [def objectForKey:@"order_add_id"];
                        [Session sharedInstance].order_add_price = [def objectForKey:@"order_add_price"];

//                        [Session sharedInstance].order_add_id = @"522";
//                        [Session sharedInstance].order_add_price = @"200";
                        NSLog(@"获取返回订单信息%@--%@",[Session sharedInstance].order_add_id,[Session sharedInstance].order_add_price);
                        if ([Session sharedInstance].order_add_id && [Session sharedInstance].order_add_price)
                        {
                            
                             //订单提交清空
                             [Session sharedInstance].shopCarss = [NSMutableArray array];
                             //本地化存储购物车数据
                             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                             [def setObject:[Session sharedInstance].shopCarss forKey:@"data_shopCarss"];
                            
                              NSLog(@"订单提交跳转");
                            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            APViewController *aPViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"APViewController"];
                            [self.navigationController pushViewController:aPViewController animated:YES];
                        }
                        else
                        {
                            [ProgressHUD showError:@"数据有误"];
                        }
                    }
                    else
                    {
                         [ProgressHUD dismiss];
                        NSString *msg = [datas objectForKey:@"msg"];
                        [ProgressHUD showError:msg];
                    }
                }];
            }
            else
            {
                [ProgressHUD showError:@"请先添加商品"];
            }
        }
        else
        {
            [ProgressHUD showError:@"请先登录!"];
        }
    }
}
- (IBAction)onclick_freight:(id)sender
{
    NSLog(@"获取运费。。。");
    self.btn_freight.selected = NO;
    [self get_freight];
}

-(void)get_freight
{
    //获取运费
    [User order_get_shipping_fee:[Session sharedInstance].user.accesskey :goods_iid :string :shipping_id success:^(NSString *data) {
        NSLog(@"data返回数据--->%@",data);
    } failure:^(NSString *message)
     {
         NSLog(@"message返回数据--->%@",message);
         NSDictionary *data = [StwClient jsonParsing:message];
         NSDictionary *datas = [data objectForKey:@"data"];
         NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
         if ([check_code isEqualToString:@"0"])
         {
             NSString *prices = [datas objectForKey:@"data"];
             shipping_price = [prices floatValue];
             [self.btn_freight setTitle:[NSString stringWithFormat:@"运费:%.2f",shipping_price] forState:UIControlStateNormal];
             
             priceAll = 0;
             for (int i = 0;i < [Session sharedInstance].shopCarss.count; i++) {
                 NSDictionary *shopDatas = [Session sharedInstance].shopCarss[i];
                 //dataDetails objectForKey:@"goods_sn"]
                 priceAll+= [[shopDatas objectForKey:@"allPrices"] floatValue];
             }
             NSString *pricess = [NSString stringWithFormat:@"￥%.2f",priceAll];
             [self.btn_price setTitle:pricess forState:UIControlStateNormal];
         }
         else
         {
             [self.btn_freight setTitle:@"运费:点击刷新" forState:UIControlStateNormal];
             self.btn_freight.selected = YES;
         }
     }];

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

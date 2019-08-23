//
//  APViewController.m
//  aspire商城
//
//  Created by tyz on 16/1/8.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "APViewController.h"
#import "Session.h"
#import "User.h"
#import "StwClient.h"
#import "UIImageView+WebCache.h"
#import "order_payCell.h"
#import "ProgressHUD.h"
#import "ApayOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface APViewController ()
{
    NSArray *titleArray;
    
    NSMutableArray *order_nameList;
    NSMutableArray *order_attrList;
    NSMutableArray *order_numList;
    NSMutableArray *order_imageList;
    NSString *best_time;
    NSString *order_ids;  //订单ID
    NSString *order_prices; //订单价格
}
@end

@implementation APViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //取得沙河文件的订单编号以及价格
    order_ids = [Session sharedInstance].order_add_id;
    NSLog(@"获取到的数据%@--%@", [Session sharedInstance].order_add_id,[Session sharedInstance].order_add_price);
    int order_id = [[Session sharedInstance].order_add_id intValue];
    //获取本次订单详情
    [User order_detail:[Session sharedInstance].user.accesskey :order_id success:^(NSString *data) {
        NSLog(@"返回的订单数据-->%@",data);
    }
    failure:^(NSString *message)
    {
        NSLog(@"返回的订单数据-->%@",message);
        NSDictionary *data = [StwClient jsonParsing:message];
        NSDictionary *datas = [data objectForKey:@"data"];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        if ([check_code isEqualToString:@"0"])
        {
            order_nameList = [[NSMutableArray alloc]init];
            order_attrList = [[NSMutableArray alloc]init];
            order_numList = [[NSMutableArray alloc]init];
            order_imageList = [[NSMutableArray alloc]init];

            NSDictionary *datass = [datas objectForKey:@"data"];
            best_time = [datass objectForKey:@"best_time"];
            order_prices = [datass objectForKey:@"goods_amount"];
            NSArray *product = [datass objectForKey:@"product"];
//            NSLog(@"product->%d",product.count);
            if (product.count > 0)
            {
                for (int i = 0; i<[product count]; i++)
                {
                    //按数组中的索引取出对应的字典
                    NSDictionary *products = [product objectAtIndex:i];
                    //通过字典中的key取出对应value，并且强制转化为NSString类型
                    NSString *order_name = [products objectForKey:@"goods_name"];
                    NSString *order_attr = [products objectForKey:@"goods_attr"];
                    NSString *order_num = [products objectForKey:@"goods_number"];
                    NSString *order_image = [products objectForKey:@"goods_image_100"];
                   
                    //将获取的value值放到数组容器中
                    if (order_name)
                    {
                        [order_nameList addObject:order_name];
                        [order_attrList addObject:order_attr];
                        [order_numList addObject:order_num];
                        [order_imageList addObject:order_image];
                    }
                }
                [ProgressHUD dismiss];
                //刷新
                [self.tableview reloadData];
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btn_Alipay.layer.cornerRadius = 10;
    self.tableview.dataSource = self;    //设置数据代理不设置不会显示数据
    self.tableview.delegate = self;
    //设置行高为60，并且取消列表线
        _tableview.rowHeight = 80;
    //    _shopCartUITableView.separatorStyle = NO;
    //    _tableView.separatorStyle = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    self.title = @"支付宝";
    
    titleArray = [NSArray arrayWithObjects:@"订单信息",@"订单描述",@"订单总价",nil];;
    
    //ios7新特性
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return order_nameList.count;
    }
    else
    {
        return  1;
    }
}

- (CGFloat)tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    if (indexPath.section == 0)
    {
//        int cellH = order_nameList.count * 80;
        return 80;
    }
    else
    {
        return 44;
    }
}

// 返回分组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@",titleArray[section]];
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
        static NSString *ID = @"order_payCell";
        order_payCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //异步加载网络图片
            NSURL *url = [NSURL URLWithString:[order_imageList objectAtIndex:indexPath.row]];
            [cell.order_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
            
            //        NSLog(@"图片网址--->%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageList objectAtIndex:indexPath.row]]]);
            
            cell.order_name.text = [NSString stringWithFormat:@"%@",[order_nameList objectAtIndex:indexPath.row]];
            cell.order_type.text = [NSString stringWithFormat:@"%@数量:%@",[order_attrList objectAtIndex:indexPath.row],[order_numList objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    else if (indexPath.section == 2)
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
        
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = [NSString stringWithFormat:@"合计:￥%@",order_prices];
        
        //取消cell选中状态颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
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
        
        if (best_time)
        {
            cell.textLabel.text = best_time;
        }
        else
        {
            cell.textLabel.text = @"没有查询到订单描述";
        }
        //取消cell选中状态颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        return cell;
    }
}

- (IBAction)onClick_pay:(id)sender
{
    if (order_nameList.count > 0 && order_prices > 0) {
        [self ALI_Pay];
    }
}

//调取支付宝进行支付
-(void)ALI_Pay
{
    NSLog(@"调用支付...");
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088021985830303";   // 商户PID
    NSString *seller = @"aspiregf@163.com";    // 商户收款账号
    NSString *privateKey = @"MIICWwIBAAKBgQDPtO1wDvSsmU9cACxNosu2GMxpe3Pf2RVe9kTRkybbpoLGCNVeVaPoheZb3b/C+jxwLSH0umo21lp6hdEzu/nt2WHI/JCpDIZI4tpy8ocJGmBEY0HXRWrf6us3f8kK6pwZrFjO/Zl0EaG5VeaCi98iqrnrhZm3OorXSlSjJd7UVQIDAQABAoGAWyL0G/sz+Je8bo3U4qvP3rK63n3AtjO2YNiGEb8TicViFCrEFIRXSyuVjDGcdpz97+qdv5gcCru7L4+P37dXTe8fIDowb5B8WzCXkgJTwA2Zf934XenIrEzHHxrBvvEH5HUaQqjE1f0YhJEdx7xXgRGEN84vfvZNT49QvXLfxYECQQD01EM8YSIqktiOAmPFroYcl38W1I4rry7YhfLdRg1ueBchPCM1iitcQUB3sj8iFgcfsY9XxCXeqgUjPjzadeYpAkEA2S8OFuz0zWeZ83Y3LxLR0d0FC4sgsx4rl8KRNxGg6PCBMv0famj2AUZkDqX+dBVoPOSYjVisaA3sEjenCXMKTQJAMJRdswFjEieJKMR4n6T9n3bAFPugKjLcjMInapiX2a+ih0mzgtAjwm6AKEAKHu1YBIXq93NIQGJkGpYi5QY34QJAQTHP3+/nmJVF8ICHFjlnBMF9Fzb/bOVcnqTIZKiFDgfMMNstCAtT9ZQEyyTnGj+m18ijRqLctiuftuQ/3yVKbQJAKBQqUYZ+pZGLx/uUPNGNWhA8VzPkXcOjlasQF9EOwbpvJauxWAjErihA7XEKNRuWH54oQMUyOxCKT4VhYTOhjg==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0 || [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    ApayOrder *order = [[ApayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = order_ids; //订单ID（由商家自行制定）
    NSString *ali_order_name = order_nameList[0];
    for (int i = 1; i < order_nameList.count; i++)
    {
        ali_order_name = [NSString stringWithFormat:@"%@,%@",ali_order_name,order_nameList[i]];
    }
    order.productName = ali_order_name; //商品标题
    order.productDescription = best_time; //商品描述
    order.amount = order_prices; //商品价格
    order.notifyURL =  @"http://www.aspirecig.cn/api/index.php/pay/return_url"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"aspireIosShopApp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"ALI--->orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    NSLog(@"---privateKey--->%@",privateKey);
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        {
            NSLog(@"ALI--->reslut = %@",resultDic);
            NSString *memo = [resultDic objectForKey:@"memo"];
            NSString *result = [resultDic objectForKey:@"result"];
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            NSLog(@"支付宝返回数据--->memo:%@--->result:%@--->resultStatus:%@",memo,result,resultStatus);
            if ([resultStatus isEqualToString:@"9000"])   //9000代表支付成功
            {
                [ProgressHUD showError:@"支付成功"];
                //返回上一页
                [[self navigationController] popViewControllerAnimated:YES];
            }
            else
            {
                // “8000”代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
                if ([resultStatus isEqualToString:@"8000"])
                {
                    [ProgressHUD showError:@"支付结果等待确认中,最终交易是否成功以支付宝交易记录为准"];
                    //返回上一页
                    [[self navigationController] popViewControllerAnimated:YES];
                }
                // 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
                else
                {
                    [ProgressHUD showError:@"支付失败"];
                }
            }
        }];
    }
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

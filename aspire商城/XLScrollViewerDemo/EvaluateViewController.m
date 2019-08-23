//
//  EvaluateViewController.m
//  aspire商城
//
//  Created by tyz on 16/1/11.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "EvaluateViewController.h"
#import "Session.h"
#import "User.h"
#import "StwClient.h"
#import "UIImageView+WebCache.h"
#import "order_payCell.h"
#import "ProgressHUD.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Goods.h"
@interface EvaluateViewController ()
{
    NSArray *titleArray;
    
    NSString *order_name;
    NSString *order_attr;
    NSString *order_image;
    
    int num;
    NSString *content;
    int IDs;
    
    int checkmessage;
}
@end

@implementation EvaluateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [ProgressHUD show:nil];
    num = 1;
    IDs = [Session sharedInstance].details.goods_id;
    [Goods product_detail:IDs success:^(id data)
    {
        NSLog(@"--------->详情页数据返回1%@",data);
    }
    failure:^(NSString *message)
    {
        NSLog(@"--------->详情页数据返回%@",message);
        NSDictionary *data = [StwClient jsonParsing:message];
        NSDictionary *datas = [data objectForKey:@"data"];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        if ([check_code isEqualToString:@"0"])
        {
            [ProgressHUD dismiss];
            NSDictionary *datass = [datas objectForKey:@"data"];
            order_name = [datass objectForKey:@"goods_name"];
            order_attr = [datass objectForKey:@"goods_sn"];
            order_image = [datass objectForKey:@"goods_image"];
            [self.tableview reloadData];
        }
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:@"网络访问失败请检查您的网络设置"];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btn_Evaluate.layer.cornerRadius = 10;
    self.tableview.dataSource = self;    //设置数据代理不设置不会显示数据
    self.tableview.delegate = self;
    
    self.assessmentText.delegate = self;//设置它的委托方法
    
    checkmessage = 0;
    
    //设置行高为60，并且取消列表线
    _tableview.rowHeight = 80;
    _tableview.separatorStyle = NO;
    //    _tableView.separatorStyle = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    
    self.title = @"发表评价";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    titleArray = [NSArray arrayWithObjects:@"商品信息",nil];
    
    self.assessmentText.text = @"请写下对宝贝的感受吧，对他人帮助很大哦!";

    //ios7新特性
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    return  1;
}

//// 返回分组的标题文字
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@",titleArray[section]];
//    //    return @"我的";
//}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"order_payCell";
    order_payCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //异步加载网络图片
        NSURL *url = [NSURL URLWithString:order_image];
        [cell.order_image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        
        //        NSLog(@"图片网址--->%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageList objectAtIndex:indexPath.row]]]);
        
        cell.order_name.text = [NSString stringWithFormat:@"%@",order_name];
        cell.order_type.text = [NSString stringWithFormat:@"型号:%@",order_attr];
    }
    return cell;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑了");
    checkmessage = 1;
    self.assessmentText.text = @"";
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"焦点变化");
    if ([self.assessmentText.text isEqualToString:@""])
    {
        checkmessage = 0;
        self.assessmentText.text = @"请写下对宝贝的感受吧，对他人帮助很大哦!";
    }
    return YES;
}

- (IBAction)evaluate_btn:(id)sender
{
    NSLog(@"开始评价");
    [ProgressHUD show:nil];
    if (checkmessage == 1) {
        content = self.assessmentText.text;
        NSLog(@"提交的评价参数%@-%d-%@-%d",[Session sharedInstance].user.accesskey,IDs,content,num);
        [User reviews_add:[Session sharedInstance].user.accesskey :IDs :content :num success:^(NSString *data)
         {
             NSLog(@"返回的数据-->%@",data);
         }
                  failure:^(NSString *message)
         {
             NSLog(@"返回的数据-->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSString *msg = [data objectForKey:@"msg"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 [ProgressHUD dismiss];
                 [ProgressHUD showSuccess:@"评价成功"];
                 //返回个人中心
                 [[self navigationController] popViewControllerAnimated:YES];
             }
             else
             {
                 [ProgressHUD dismiss];
                 [ProgressHUD showError:msg];
             }
         }];
    }
    else
    {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"评价内容不能为空！"];
    }
}

- (IBAction)evaluate_0nbtn_1:(id)sender
{
    num = 1;
    NSLog(@"点击了--->1");
    [self.evaluate_btn_1 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_2 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_3 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_4 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_5 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
}

- (IBAction)evaluate_0nbtn_2:(id)sender
{
    num = 2;
    NSLog(@"点击了--->2");
    [self.evaluate_btn_1 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_2 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_3 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_4 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_5 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];

}
- (IBAction)evaluate_0nbtn_3:(id)sender
{
    num = 3;
    NSLog(@"点击了--->3");
    [self.evaluate_btn_1 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_2 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_3 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_4 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];
    [self.evaluate_btn_5 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];

}
- (IBAction)evaluate_0nbtn_4:(id)sender
{
    num = 4;
    NSLog(@"点击了--->4");
    [self.evaluate_btn_1 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_2 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_3 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_4 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_5 setImage:[UIImage imageNamed:@"star_empty"] forState:UIControlStateNormal];

}
- (IBAction)evaluate_0nbtn_5:(id)sender
{
    num = 5;
    NSLog(@"点击了--->5");
    [self.evaluate_btn_1 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_2 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_3 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_4 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];
    [self.evaluate_btn_5 setImage:[UIImage imageNamed:@"star_full"] forState:UIControlStateNormal];

}

//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [ProgressHUD dismiss];
    [self cleanKeyBoard];
}

-(void)cleanKeyBoard
{
    [self.assessmentText resignFirstResponder];
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

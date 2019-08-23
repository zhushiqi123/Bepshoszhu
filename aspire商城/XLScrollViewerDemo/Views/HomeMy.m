//
//  View3.m
//  XLScrollViewerDemo
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
//

#import "HomeMy.h"
#import "STWMyView.h"
#import "MyButtonCell.h"
#import "UserLoginViewController.h"
#import "NumberQueryViewController.h"
#import "UpdatePwdViewController.h"
#import "ContactUsViewController.h"
#import "AfterSalesViewController.h"
#import "UpdateUserViewController.h"
#import "AddressListViewController.h"
#import "AllOrdersViewController.h"
#import "Session.h"
#import "ProgressHUD.h"
#import "StwClient.h"

@interface HomeMy()
{
    NSArray *arry;
}
@property (nonatomic, retain) NSMutableArray *arrayData;
@end

@implementation HomeMy

-(instancetype)initWithFrame:(CGRect)frame
{
    STWMyView *my1 = [[STWMyView alloc] initWithMy:@"我的" strings:@[@"全部订单",@"收货地址"]];
    STWMyView *my2 = [[STWMyView alloc] initWithMy:@"查询" strings:@[@"防伪码查询"]];
    STWMyView *my3 = [[STWMyView alloc] initWithMy:@"修改" strings:@[@"修改登录密码",@"修改用户信息"]];
    STWMyView *my4 = [[STWMyView alloc] initWithMy:@"服务" strings:@[@"关于我们",@"售后政策",@"联系我们"]];
    STWMyView *my5 = [[STWMyView alloc] initWithMy:@"" strings:@[@""]];
    self.arrayData=[NSMutableArray arrayWithObjects:my1,my2,my3,my4,my5,nil];
    
    //通知中心是个单例
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    
    // 注册一个监听事件。第三个参数的事件名， 系统用这个参数来区别不同事件。
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"btn_back" object:nil];
    
    self =[super initWithFrame:frame];
    if (_tableView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        //在view里面区新建一个tableview最好取得手机屏幕的宽高
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+20+10)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 35;
        _tableView.separatorStyle = NO;
        [self addSubview:_tableView];
    }
    return self;
}

// @selector(receiveNotification:)方法， 即受到通知之后的事件
- (void)receiveNotification:(NSNotification *)noti
{
    if([noti.name isEqualToString:@"btn_back"])
    {
        //通过接收到通知消息刷新页面
        NSLog(@"页面刷新。。。。");
        [self.tableView reloadData];
        //NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
        //    NSLog(@"%@ === %@ === %@", noti.object, noti.userInfo, noti.name);
    }
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayData count];
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        STWMyView *mynum = [self.arrayData objectAtIndex:section];
        return mynum.strings.count+1;
    }
    else
    {
        STWMyView *mynum = [self.arrayData objectAtIndex:section];
        return mynum.strings.count;
    }
}

// 返回分组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    STWMyView *mynum = [self.arrayData objectAtIndex:section];
    return [NSString stringWithFormat:@"%@", mynum.tittle];
//    return @"我的";
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 1)
    {
        static NSString *ID = @"MyButtonCell";
        MyButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.btn_myCell.layer.cornerRadius = 10;
            //获取accesskey
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            if ([def objectForKey:@"aspireAccesskey"])
            {
                [cell.btn_myCell setTitle:@"退出" forState:UIControlStateNormal];
            }
            else
            {
                [cell.btn_myCell setTitle:@"登录" forState:UIControlStateNormal];
            }
        }
        [cell.btn_myCell addTarget:self action:@selector(btn_my)forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        
        //设置字体内容
        STWMyView *mynum = [self.arrayData objectAtIndex:indexPath.section];
        if(indexPath.section < 4)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont fontWithName:@"STHeiti-Medium" size:17];
        cell.textLabel.text= [NSString stringWithFormat:@"%@",mynum.strings[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //我的
//    if (indexPath.section == 0 && indexPath.row ==0)
    if (indexPath.section == 0 && [Session sharedInstance].user.accesskey)
    {
//        UserLoginViewController *loginView = [[UserLoginViewController alloc] initWithNibName:@"UserLoginViewController"bundle:[NSBundle mainBundle]];
        //
        if (indexPath.row == 0)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            AllOrdersViewController *AllOrdersViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"AllOrdersViewController"];
            [navigationController pushViewController:AllOrdersViewController animated:YES];

        }
        if (indexPath.row == 1)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            AddressListViewController *UserAddressView = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewController"];
            [navigationController pushViewController:UserAddressView animated:YES];
        }
    }
    else if(indexPath.section == 0 && ![Session sharedInstance].user.accesskey)
    {
        [self UserLoginView];
    }
    
    //查询
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        NumberQueryViewController *NumberQueryView = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"NumberQueryViewController"];
        [navigationController pushViewController:NumberQueryView animated:YES];
    }
    //修改
    if(indexPath.section == 2 && [Session sharedInstance].user.accesskey)
    {
        if(indexPath.row == 0)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            UpdatePwdViewController *UpdatePwdView = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"UpdatePwdViewController"];
            [navigationController pushViewController:UpdatePwdView animated:YES];
        }
        if (indexPath.row == 1) {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            UpdateUserViewController *UpdateUserView = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"UpdateUserViewController"];
            [navigationController pushViewController:UpdateUserView animated:YES];
        }
    }
    else if(indexPath.section == 2 && ![Session sharedInstance].user.accesskey)
    {
        [self UserLoginView];
    }
    
    //服务
    if (indexPath.section == 3)
    {
//        NSLog(@"%d%d",indexPath.section,indexPath.row);
        //关于我们
        if(indexPath.row == 0)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            UserLoginViewController *AboutViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
            [navigationController pushViewController:AboutViewController animated:YES];
        }
         //售后政策
        if(indexPath.row == 1)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            AfterSalesViewController *AfterSalesViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"AfterSalesViewController"];
            [navigationController pushViewController:AfterSalesViewController animated:YES];
        }
        //联系我们
        if(indexPath.row == 2)
        {
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            ContactUsViewController *ContactUsViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [navigationController pushViewController:ContactUsViewController animated:YES];
        }
    }
}

-(void)UserLoginView
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    UserLoginViewController *LoginViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
    
    [navigationController pushViewController:LoginViewController animated:YES];
}

-(void)btn_my{
    [ProgressHUD show:nil];
    if ([Session sharedInstance].user.accesskey)
    {
        [ProgressHUD dismiss];
        [ProgressHUD show:nil];
        [User outLogin:[Session sharedInstance].user.accesskey success:^(NSString *data)
         {
             NSLog(@"data%@",data);
         }
        failure:^(NSString *message)
         {
             NSLog(@"商品查询返回数据2--->%@",message);
             [ProgressHUD dismiss];
             NSDictionary *data = [StwClient jsonParsing:message];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             NSLog(@"data------>%@",data);
             if ([check_code isEqualToString:@"0"])
             {
                 [ProgressHUD dismiss];
                 [ProgressHUD showSuccess:@"退出成功"];
                 [Session sharedInstance].user.accesskey = NULL;
                 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                 [def setObject:[Session sharedInstance].user.accesskey forKey:@"aspireAccesskey"];
                 [self.tableView reloadData];
             //             NSLog(@"message%@",message);
             }
             else
             {
                 NSString *msg = [NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]];
                 [ProgressHUD showError:msg];
             }
         }];
    }
    else
    {
        [ProgressHUD dismiss];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        
        UserLoginViewController *LoginViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
        
        [navigationController pushViewController:LoginViewController animated:YES];
    }
}



@end

//
//  UserLoginViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "UserLoginViewController.h"
#import "User.h"
#import "StwClient.h"
#import "ProgressHUD.h"
#import "Session.h"

@interface UserLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameUilable;
@property (weak, nonatomic) IBOutlet UILabel *passWordUILable;
@property (weak, nonatomic) IBOutlet UITextField *usweNameText;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIButton *btn_registered;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;
@property (weak, nonatomic) IBOutlet UILabel *forgotUILabel;

@end

@implementation UserLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    self.btn_login.layer.cornerRadius = 10;
    self.btn_registered.layer.cornerRadius = 10;
    
    //给忘记密码加上点击事件
    self.forgotUILabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickUILable)];
    [self.forgotUILabel addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}
- (IBAction)btn_loginOnClick:(id)sender
{
    [ProgressHUD show:nil];
    if ([self.usweNameText.text isEqualToString:@""] || [self.passWordText.text isEqualToString:@""])
    {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"账号密码不能为空"];
    }
    else
    {
        [User login:self.usweNameText.text :self.passWordText.text success:^(id data) {
            NSLog(@"成功---->%@",data);
        }
        failure:^(NSString *message)
         {
             NSLog(@"失败---->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 //持久化保存账号密码
                 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                 [def setObject:self.usweNameText.text forKey:@"aspireUsername"];
                 [def setObject:self.passWordText.text forKey:@"aspirePassword"];
                 
                 [ProgressHUD dismiss];
                 [ProgressHUD showSuccess:@"登录成功"];
                 NSDictionary *datas = [data objectForKey:@"data"];
                 NSString *accesskey = [datas objectForKey:@"accesskey"];
                 [Session sharedInstance].user.accesskey = accesskey;
                 
                 //持久化保存 Accesskey
                 [def setObject:accesskey forKey:@"aspireAccesskey"];
                 
                 //从本地取出accesskey
                 if ([def objectForKey:@"aspireAccesskey"]) {
                     [Session sharedInstance].user.accesskey = [def objectForKey:@"aspireAccesskey"];
                 }
                 
                 [Session sharedInstance].user.username = self.usweNameText.text;
                 [Session sharedInstance].user.password = self.passWordText.text;
                 
                 //登录成功获取用户信息 暂时放置2015/12/16 by tyz
                 //            [User account_index:accesskey success:^(NSString *data) {
                 //                NSLog(@"成功--->%@",data);
                 //            } failure:^(NSString *message) {
                 //                NSLog(@"失败--->%@",message);
                 //            }];
                 //            NSLog(@"accesskey--->%@",accesskey);
                 
                 // 创建一个通知中心
                 NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                 // 发送通知. 其中的Name填写第一界面的Name， 系统知道是第一界面来相应通知， object就是要传的值。 UserInfo是一个字典， 如果要用的话，提前定义一个字典， 可以通过这个来实现多个参数的传值使用。
                 [center postNotificationName:@"btn_back" object:@"btn_back" userInfo:nil];
                 
                 //返回个人中心
                 [[self navigationController] popViewControllerAnimated:YES];
             }
             else
             {
                 [ProgressHUD dismiss];
                 [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
             }
             
         }];
    }
}

-(void)onClickUILable
{
    [ProgressHUD showError:@"功能暂未开放"];
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

//
//  UpdateUserViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "UpdateUserViewController.h"
#import "ProgressHUD.h"
#import "User.h"
#import "Session.h"
#import "StwClient.h"
@interface UpdateUserViewController ()

@end

@implementation UpdateUserViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [ProgressHUD show:nil];
    [self getUsers];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改用户信息";
    self.btn_updateUser.layer.cornerRadius = 10;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onclick_btn:(id)sender
{
    if ([self.year.text isEqualToString:@""]||[self.mouth.text isEqualToString:@""]||[self.day.text isEqualToString:@""]||[self.msn.text isEqualToString:@""]||[self.qq.text isEqualToString:@""]||[self.mobile_phone.text isEqualToString:@""])
    {
        [ProgressHUD showError:@"所有输入均不能为空"];
    }
    else
    {
        int sex = 1;
        if ([self.sexLable.text isEqualToString:@"男"])
        {
            sex = 1;
        }
        else
        {
            sex = 2;
        }
        NSString *birthday = [NSString stringWithFormat:@"%@-%@-%@",self.year.text,self.mouth.text,self.day.text];
        [User account_update:[Session sharedInstance].user.accesskey :sex :birthday :self.msn.text :self.qq.text :self.mobile_phone.text :self.office_phone.text :self.home_phone.text success:^(NSString *data)
        {
            NSLog(@"返回的数据------->%@",data);
        }
        failure:^(NSString *message)
        {
            NSLog(@"返回的数据------->%@",message);
            NSDictionary *data = [StwClient jsonParsing:message];
            NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
            if ([check_code isEqualToString:@"0"])
            {
                [ProgressHUD dismiss];
                [ProgressHUD showSuccess:@"修改成功"];
                
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

- (IBAction)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        self.sexLable.text = @"男";
    }
    else
    {
       self.sexLable.text = @"女";
    }
}

-(void)getUsers
{
    [User account_index:[Session sharedInstance].user.accesskey success:^(NSString *data)
    {
        NSLog(@"返回的数据----->%@",data);
    }
    failure:^(NSString *message)
    {
        NSLog(@"返回的数据----->%@",message);
        NSDictionary *data = [StwClient jsonParsing:message];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        NSDictionary *datas = [data objectForKey:@"data"];
        if ([check_code isEqualToString:@"0"])
        {
            [ProgressHUD dismiss];
            NSDictionary *dataUser = [datas objectForKey:@"data"];
            NSString *birthday = [dataUser objectForKey:@"birthday"];
            self.year.text = [birthday substringWithRange:NSMakeRange(0,4)];
            self.mouth.text = [birthday substringWithRange:NSMakeRange(5,2)];
            self.day.text = [birthday substringWithRange:NSMakeRange(8,2)];
            self.msn.text = [dataUser objectForKey:@"msn"];
            self.qq.text = [dataUser objectForKey:@"qq"];
            self.office_phone.text = [dataUser objectForKey:@"office_phone"];
            self.home_phone.text = [dataUser objectForKey:@"home_phone"];
            self.mobile_phone.text = [dataUser objectForKey:@"mobile_phone"];
            NSString *sexs = [dataUser objectForKey:@"sex"];
            if ([sexs isEqualToString:@"1"])
            {
                self.update_sex.on = YES;
                self.sexLable.text = @"男";
            }
            else
            {
                self.update_sex.on = NO;
                self.sexLable.text = @"女";
            }
        }
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
        }
    }];
}

//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self cleanKeyBoard];
}

-(void)cleanKeyBoard
{
    [self.year resignFirstResponder];
    [self.mouth resignFirstResponder];
    [self.day resignFirstResponder];
    [self.msn resignFirstResponder];
    [self.qq resignFirstResponder];
    [self.office_phone resignFirstResponder];
    [self.home_phone resignFirstResponder];
    [self.mobile_phone resignFirstResponder];
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

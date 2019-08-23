//
//  UpdatePwdViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "ProgressHUD.h"
#import "User.h"
#import "Session.h"
#import "StwClient.h"
@interface UpdatePwdViewController ()

@end

@implementation UpdatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.btn_updatePwd.layer.cornerRadius = 10;
    // Do any additional setup after loading the view.
}

- (IBAction)onClick_btn:(id)sender
{
    if ([self.UIText_oldPwd.text isEqualToString:@""] || [self.UIText_newPwd.text isEqualToString:@""] || [self.UIText_repeatPwd.text isEqualToString:@""])
    {
        [ProgressHUD showError:@"密码不能为空"];
    }
    else
    {
        if ([self.UIText_newPwd.text isEqualToString:self.UIText_repeatPwd.text])
        {
            [ProgressHUD show:nil];
            [User account_updatepwd:[Session sharedInstance].user.accesskey :self.UIText_oldPwd.text :self.UIText_newPwd.text :self.UIText_repeatPwd.text success:^(NSString *data)
            {
                NSLog(@"返回的数据1----->%@",data);
            }
            failure:^(NSString *message)
            {
                NSLog(@"返回的数据2----->%@",message);
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
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:@"两次输入密码不一致"];
        }
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

//
//  RegisterTableViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "User.h"
#import "StwClient.h"
#import "Keys.h"
#import "ProgressHUD.h"
#import "UserLoginViewController.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.btn_register.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_register:(id)sender
{
    if(self.register_username.text.length>=6 && self.register_username.text.length<=18)
    {
        
        if(![self.register_email.text isEqualToString:@""])
        {
            if (self.register_password.text.length >=6 && self.register_password.text.length<=20)
            {
                if ([self.register_password.text isEqualToString:self.register_passwords.text])
                {
                    [User regist:self.register_username.text :self.register_password.text :self.register_email.text success:^(id data)
                    {
                         NSLog(@"访问成功-->%@",data);
                    }
                    failure:^(NSString *message)
                    {
//                        NSLog(@"访问失败-->%@",message);
                        //解析json数据
                        NSDictionary *data = [StwClient jsonParsing:message];
                        NSLog(@"data---->%@",data);
                        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
                        //如果ret标记为0则是正常成功返回
                        if ([check_code isEqualToString:@"0"])
                        {
                            [ProgressHUD showSuccess:@"注册成功"];
                            //返回登陆界面
                            [[self navigationController] popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
                        }
                    }];
                }
                else
                {
                    [ProgressHUD showError:@"两次密码输入不一致"];
                }

            }
            else
            {
                [ProgressHUD showError:@"密码为6到20位字符"];
            }
        }
        else
        {
            [ProgressHUD showError:@"邮箱不能为空"];
        }
    }
    else
    {
        [ProgressHUD showError:@"用户名为6到18位"];
    }
    
//    [User login:self.register_username.text :self.register_password.text success:^(id arr) {
//        NSLog(@"-->成功%@",arr);
//    } failure:^(NSString *message) {
//        NSLog(@"-->失败%@",message);
//    }];
    
//    NSString *token = @"common";
//    [User getAddress:token success:^(id arr) {
//        NSLog(@"-->成功%@",arr);
//    } failure:^(id message) {
//        NSLog(@"-->失败%@",message);
//    }];
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

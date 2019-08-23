//
//  ChangeAddressViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/24.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "ChangeAddressViewController.h"
#import "AddressChoicePickerView.h"
#import "User.h"
#import "StwClient.h"
#import "Address.h"
#import "ProgressHUD.h"
#import "Session.h"

@interface ChangeAddressViewController ()<UITextFieldDelegate>
{
    int address_id;
    Address *address;
}

@end

@implementation ChangeAddressViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    address = [[Address alloc] init];
    [ProgressHUD show:nil];
    if (![[Session sharedInstance].address_id isEqualToString:@"0"])
    {
        [User address_detail:[Session sharedInstance].user.accesskey :[[Session sharedInstance].address_id intValue] success:^(NSString *data)
        {
            [ProgressHUD dismiss];
            NSLog(@"data--->%@",data);
        }
        failure:^(NSString *message)
        {
            [ProgressHUD dismiss];
            address_id = [[Session sharedInstance].address_id intValue];
            NSString *addressAA = [Session sharedInstance].addressA;
            [Session sharedInstance].address_id = @"0";
            [Session sharedInstance].addressA = @"0";
            NSLog(@"message--->%@",message);
            NSDictionary *data = [StwClient jsonParsing:message];
            NSDictionary *datas = [data objectForKey:@"data"];
            NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
            if ([check_code isEqualToString:@"0"])
            {
                NSDictionary *dataDetails = [datas objectForKey:@"data"];
                NSString *name = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"consignee"]];
                self.change_name.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"consignee"]];
                self.change_phone.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"mobile"]];
                self.change_email.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"email"]];
                self.change_addressB.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"address"]];
                self.change_zipcode.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"zipcode"]];
                self.change_more.text = [NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"best_time"]];
                self.change_addressA.text = addressAA;
                
                address.country = [[NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"country"]] intValue];
                address.province = [[NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"province"]] intValue];
                address.city = [[NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"city"]] intValue];
                address.district = [[NSString stringWithFormat:@"%@",[dataDetails objectForKey:@"district"]] intValue];
                
                NSLog(@"name===>%@",name);
            }
        }];
    }
    else
    {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"数据错误"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.change_btn.layer.cornerRadius = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    self.title = @"修改收货地址";
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeLable_onclick:(id)sender
{
    [self cleanKeyBoard];
    NSLog(@"========被点击了========");
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate)
    {
        self.change_addressA.text = [NSString stringWithFormat:@"%@%@%@",[self returnString:locate.province],[self returnString:locate.city],[self returnString:locate.area]];
        address.country = 1;
        address.province = [self returnInt:locate.province];
        address.city = [self returnInt:locate.city];
        if(address.district)
        {
            address.district = [self returnInt:locate.area];
            NSLog(@"add---->%d",address.district);
        }
        else
        {
            address.district = 0;
        }
        //邮政编码
        //        self.addressZip.text = [NSString stringWithFormat:@"%@",locate.zipCode];
        self.change_addressA.textColor = [UIColor blackColor];
    };
    [addressPickerView show];

}

//按钮点击事件
- (IBAction)btn_onclick:(id)sender
{
    NSLog(@"被点击了");
    [ProgressHUD show:nil];
    if (self.change_name.text.length > 1)
    {
        if (self.change_phone.text.length > 1)
        {
            if (self.change_email.text.length > 1)
            {
                if (self.change_addressA.text.length > 1)
                {
                    if (self.change_addressB.text.length > 1)
                    {
                        if (self.change_zipcode.text.length > 1)
                        {
                            [User address_update:[Session sharedInstance].user.accesskey :address_id :address :self.change_name.text :self.change_email.text :self.change_addressB.text :self.change_zipcode.text  :self.change_phone.text :self.change_more.text success:^(NSString *data)
                             {
                                NSLog(@"%@",data);
                             }
                             failure:^(NSString *message)
                             {
                                 [ProgressHUD dismiss];
                                 NSLog(@"%@",message);
                                 NSDictionary *data = [StwClient jsonParsing:message];
                                 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
                                 if ([check_code isEqualToString:@"0"])
                                 {
                                     [ProgressHUD showSuccess:@"修改成功"];
                                     //返回登陆界面
                                     [[self navigationController] popViewControllerAnimated:YES];
                                 }
                                 else
                                 {
                                     //NSLog(@"message-->%@",message);
                                     [ProgressHUD dismiss];
                                     [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
                                 }
                             }];
                        }
                        else
                        {
                            [ProgressHUD showError:@"邮政编码不能为空"];
                        }
                    }
                    else
                    {
                        [ProgressHUD showError:@"请填写详细地址"];
                    }
                }
                else
                {
                    [ProgressHUD showError:@"请点击输入地址"];
                }
            }
            else
            {
                [ProgressHUD showError:@"Email不能为空"];
            }
        }
        else
        {
            [ProgressHUD showError:@"电话码不能为空"];
        }
    }
    else
    {
        [ProgressHUD showError:@"收货人姓名不能为空"];
    }
}

//键盘自适应移动
- (void)tfChange:(UITextField *)sender
{
    //    NSLog(@"Keyboard change");
    //    [UIView animateWithDuration:0.3f animations:^{
    //        CGRect curFrame=self.view.frame;
    //        curFrame.origin.y = self.view.frame.origin.y -98.0;
    //        self.view.frame=curFrame;
    //    }];
}

//输入完成
-(void)tfEnd:(UITextField *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = [UIScreen mainScreen ].bounds;
    }];
    [self cleanKeyBoard];
}

//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self cleanKeyBoard];
}

-(void)cleanKeyBoard
{
    [self.change_name resignFirstResponder];
    [self.change_phone resignFirstResponder];
    [self.change_zipcode resignFirstResponder];
    [self.change_email resignFirstResponder];
    [self.change_addressB resignFirstResponder];
    [self.change_more resignFirstResponder];
}

//解析成字符
-(NSString *)returnString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSString *box = array[0];
    return box;
}
//解析成数字
-(int)returnInt:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSString *box = array[1];
    return [box intValue];
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

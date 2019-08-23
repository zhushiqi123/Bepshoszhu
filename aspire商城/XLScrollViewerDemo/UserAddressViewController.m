//
//  UserAddressViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/8.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "UserAddressViewController.h"
#import "AddressChoicePickerView.h"
#import "User.h"
#import "StwClient.h"
#import "Address.h"
#import "ProgressHUD.h"
#import "Session.h"
@interface UserAddressViewController ()<UITextFieldDelegate>
{
    NSMutableArray *region_id_list;
    NSMutableArray *parent_id_list;
    NSMutableArray *region_name_list;
    NSMutableArray *region_type_list;
    Address *address;
}

@end

@implementation UserAddressViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     address = [[Address alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressButton.layer.cornerRadius = 10;
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    self.title = @"添加收货地址";
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.addressEmail addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingDidBegin];
    [self.addressMore addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (IBAction)tapPress:(UITapGestureRecognizer *)sender
{
    [self cleanKeyBoard];
    NSLog(@"========被点击了========");
    AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc]init];
    addressPickerView.block = ^(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate)
    {
        self.addressLable.text = [NSString stringWithFormat:@"%@%@%@",[self returnString:locate.province],[self returnString:locate.city],[self returnString:locate.area]];
        address.country = 1;
        address.province = [self returnInt:locate.province];
        address.city = [self returnInt:locate.city];
        if(locate.area)
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
        self.addressLable.textColor = [UIColor blackColor];
    };
    [addressPickerView show];
}

- (IBAction)onClick_btn:(id)sender
{
//    address.consignee = self.addressName.text;
//    address.email = self.addressEmail.text;
//    address.addressa = self.addressStreet.text;
//    address.zipcode = self.addressZip.text;
//    address.best_time = self.addressMore.text;
//    address.mobile = self.addressPhone.text;
    [ProgressHUD show:nil];
    if (self.addressName.text.length > 1)
    {
        if (self.addressPhone.text.length > 1)
        {
             if (self.addressEmail.text.length > 1)
            {
                if (self.addressStreet.text.length > 1)
                {
                    if (self.addressZip.text.length > 1)
                    {
                        [User address_add:[Session sharedInstance].user.accesskey :address :self.addressName.text :self.addressEmail.text :self.addressStreet.text :self.addressZip.text  :self.addressPhone.text :self.addressMore.text success:^(NSString *data) {
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
                                [ProgressHUD showSuccess:@"添加成功"];
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

         //    [User common_region:^(NSString *data)
//     {
//         NSLog(@"data---->%@",data);
//     }
//     failure:^(NSString *message)
//     {
//         region_id_list = [[NSMutableArray alloc] init];
//         parent_id_list = [[NSMutableArray alloc] init];
//         region_name_list = [[NSMutableArray alloc] init];
//         region_type_list = [[NSMutableArray alloc] init];
//         NSLog(@"message---->%@",message);
//         NSDictionary *data = [StwClient jsonParsing:message];
//         NSDictionary *datas = [data objectForKey:@"data"];
//         NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
//         if ([check_code isEqualToString:@"0"])
//         {
//             NSArray *list = [datas objectForKey:@"list"];
//             if (list.count > 0)
//             {
//                 NSLog(@"长度%d",list.count);
//                 for (int i = 0; i<list.count; i++)
//                 {
//                     NSLog(@"i--->%d",i);
//                     //按数组中的索引取出对应的字典
//                     NSDictionary *listdic = [list objectAtIndex:i];
//                     //通过字典中的key取出对应value，并且强制转化为NSString类型
//                     NSString *region_id = (NSString *)[listdic objectForKey:@"region_id"];
//                     NSString *parent_id = (NSString *)[listdic objectForKey:@"parent_id"];
//                     NSString *region_name = (NSString *)[listdic objectForKey:@"region_name"];
//                     NSString *region_type = (NSString *)[listdic objectForKey:@"region_type"];
//                     
//                     [region_id_list addObject:region_id];
//                     [parent_id_list addObject:parent_id];
//                     [region_name_list addObject:region_name];
//                     [region_type_list addObject:region_type];
//                 }
//                 NSLog(@"===-%@",region_id_list[0]);
////                 NSLog(@"-%@",parent_id_list);
////                 NSLog(@"-%@",region_name_list);
////                 NSLog(@"-%@",region_type_list);
//                 [self performSelector:@selector(checkJiexi) withObject:nil afterDelay:2.0f];
//             }
//         }
//     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.addressName resignFirstResponder];
    [self.addressPhone resignFirstResponder];
    [self.addressEmail resignFirstResponder];
    [self.addressStreet resignFirstResponder];
    [self.addressZip resignFirstResponder];
    [self.addressMore resignFirstResponder];
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

//测试解析生成了plist文件
//-(void)checkJiexi
//{
//    NSLog(@"开始解析");
//    for (int i = 0; i < region_name_list.count; i++)
//    {
//        if ([region_type_list[i] isEqualToString:@"1"])
//        {
//            NSLog(@"<dict><key>province</key><string>%@-%@</string><key>cities</key><array>",region_name_list[i],region_id_list[i]);
//            for (int j = 0; j < region_name_list.count;j++)
//            {
//                if ([region_type_list[j] isEqualToString:@"2"] && [parent_id_list[j] isEqualToString:region_id_list[i]])
//                {
//                    NSLog(@"<dict><key>city</key><string>%@-%@</string><key>areas</key><array>",region_name_list[j],region_id_list[j]);
//                    for (int k = 0 ; k < region_name_list.count; k++)
//                    {
//                        if ([region_type_list[k] isEqualToString:@"3"] &&[parent_id_list[k] isEqualToString:region_id_list[j]]) {
//                            NSLog(@"<string>%@-%@</string>",region_name_list[k],region_id_list[k]);
//                        }
//                    }
//                    NSLog(@"</array></dict>");
//                }
//            }
//            NSLog(@"</array></dict>");
//        }
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  NumberQueryViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "NumberQueryViewController.h"
#import "User.h"
#import "StwClient.h"
#import "ProgressHUD.h"

@interface NumberQueryViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberQuery_result;
@property (weak, nonatomic) IBOutlet UISearchBar *numberQuery_search;

@end

@implementation NumberQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"防伪查询";
    self.numberQuery_search.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *code = self.numberQuery_search.text;
    NSLog(@"开始搜索");
    [ProgressHUD show:nil];
    [User common_security_code:code :^(NSString *data)
    {
        NSLog(@"返回的数据data---->%@",data);
    }
    failure:^(NSString *message)
    {
        NSLog(@"返回的数据message---->%@",message);
        NSDictionary *data = [StwClient jsonParsing:message];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        NSDictionary *datas = [data objectForKey:@"data"];
        if ([check_code isEqualToString:@"0"])
        {
            [ProgressHUD dismiss];
            NSDictionary *checkDictionary = [datas objectForKey:@"data"];
            NSLog(@"checkDictionary---->%@",checkDictionary);
            NSString *checkText1;
            NSString *checkText2;
//            id object = [checkDictionary objectForKey:@"id"];
            if(![checkDictionary isKindOfClass:[NSNull class]])
            {
                checkText1 = [checkDictionary objectForKey:@"hits"];
                checkText2 = [checkDictionary objectForKey:@"id"];
            }
            NSLog(@"checkText--->%@",checkText1);
            if(checkText1)
            {
                [ProgressHUD showSuccess:nil];
                self.numberQuery_result.text = [NSString stringWithFormat:@"恭喜您,已验证是官方正品,唯一编号为:%@,已经查询次数为:%@,谨防假冒!",checkText2,checkText1];
            }
            else
            {
                self.numberQuery_result.text = @"没查询到产品编号,您还可以联系客服人工进行查询,谨防假冒!";
                [ProgressHUD showError:@"没有查询到相关信息"];
            }
        }
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:@"网络访问失败请检查您的网络设置"];
        }
    }];
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

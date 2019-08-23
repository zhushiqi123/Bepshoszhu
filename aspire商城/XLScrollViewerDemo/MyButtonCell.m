//
//  MyButtonCell.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "MyButtonCell.h"
#import "ProgressHUD.h"
#import "User.h"
#import "Session.h"
#import "UserLoginViewController.h"
@implementation MyButtonCell

- (void)awakeFromNib {
    // Initialization code
}
//- (IBAction)onclick_login:(id)sender {
//    [ProgressHUD show:nil];
//    if ([Session sharedInstance].user.accesskey)
//    {
//        [User outLogin:[Session sharedInstance].user.accesskey success:^(NSString *data)
//         {
//             NSLog(@"data%@",data);
//         }
//         failure:^(NSString *message)
//         {
//             [ProgressHUD dismiss];
//             [ProgressHUD showSuccess:@"退出成功"];
//             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//             [def setObject:nil forKey:@"aspireAccesskey"];
//             [_btn_myCell setTitle:@"退出" forState:UIControlStateNormal];
////             NSLog(@"message%@",message);
//         }];
//    }
//    else
//    {
//        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        
//        UserLoginViewController *LoginViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"UserLoginViewController"];
//        
//        [navigationController pushViewController:LoginViewController animated:YES];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

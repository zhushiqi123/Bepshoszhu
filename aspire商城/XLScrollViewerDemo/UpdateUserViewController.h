//
//  UpdateUserViewController.h
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_updateUser;
@property (weak, nonatomic) IBOutlet UISwitch *update_sex;
@property (weak, nonatomic) IBOutlet UILabel *sexLable;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UITextField *mouth;
@property (weak, nonatomic) IBOutlet UITextField *day;
@property (weak, nonatomic) IBOutlet UITextField *msn;
@property (weak, nonatomic) IBOutlet UITextField *qq;
@property (weak, nonatomic) IBOutlet UITextField *office_phone;
@property (weak, nonatomic) IBOutlet UITextField *home_phone;
@property (weak, nonatomic) IBOutlet UITextField *mobile_phone;

@end

//
//  UpdatePwdViewController.h
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *UILable_oldPwd;
@property (weak, nonatomic) IBOutlet UILabel *UILable_newPwd;
@property (weak, nonatomic) IBOutlet UILabel *UILable_repeatPwd;
@property (weak, nonatomic) IBOutlet UITextField *UIText_oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *UIText_newPwd;
@property (weak, nonatomic) IBOutlet UITextField *UIText_repeatPwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_updatePwd;

@end

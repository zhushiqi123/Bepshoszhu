//
//  ChangeAddressViewController.h
//  aspire商城
//
//  Created by tyz on 15/12/24.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *change_name;
@property (weak, nonatomic) IBOutlet UITextField *change_phone;
@property (weak, nonatomic) IBOutlet UITextField *change_email;
@property (weak, nonatomic) IBOutlet UILabel *change_addressA;
@property (weak, nonatomic) IBOutlet UITextField *change_addressB;
@property (weak, nonatomic) IBOutlet UITextField *change_zipcode;
@property (weak, nonatomic) IBOutlet UITextField *change_more;
@property (weak, nonatomic) IBOutlet UIButton *change_btn;

@end

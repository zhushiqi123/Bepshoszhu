//
//  UserAddressViewController.h
//  aspire商城
//
//  Created by tyz on 15/12/8.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addressName;
@property (weak, nonatomic) IBOutlet UITextField *addressPhone;
@property (weak, nonatomic) IBOutlet UITextField *addressEmail;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UITextField *addressStreet;
@property (weak, nonatomic) IBOutlet UITextField *addressZip;
@property (weak, nonatomic) IBOutlet UITextField *addressMore;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@end

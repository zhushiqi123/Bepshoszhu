//
//  VapedViewController.h
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VapedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *title_text;

@property (weak, nonatomic) IBOutlet UILabel *num_text;

@property (weak, nonatomic) IBOutlet UILabel *today_text;

@property (weak, nonatomic) IBOutlet UIView *topBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *puffsView1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *puffsView1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *puffsBtn1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *puffsBtn1_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyView2_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyView2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyBtn2_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyBtn2_height;

@property (weak, nonatomic) IBOutlet UIButton *btn_clean_puffs;

@end

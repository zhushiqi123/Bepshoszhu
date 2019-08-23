//
//  BLEHomeRightViewController.h
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEHomeRightViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *lable_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_device_name;
@property (weak, nonatomic) IBOutlet UILabel *lable_device_version;
@property (weak, nonatomic) IBOutlet UIButton *remove_btn;

@property (weak, nonatomic) IBOutlet UILabel *color_lable;
@property (weak, nonatomic) IBOutlet UILabel *brightness_lable;
@property (weak, nonatomic) IBOutlet UILabel *game_lable;


@property (weak, nonatomic) IBOutlet UIView *color_view_01;
@property (weak, nonatomic) IBOutlet UIView *color_view_02;
@property (weak, nonatomic) IBOutlet UIView *color_view_03;
@property (weak, nonatomic) IBOutlet UIView *color_view_04;


@property (weak, nonatomic) IBOutlet UISlider *brightness_sider;

@property (weak, nonatomic) IBOutlet UIImageView *game_image_01;
@property (weak, nonatomic) IBOutlet UIImageView *game_image_02;
@property (weak, nonatomic) IBOutlet UIImageView *game_image_03;


//是否锁机按钮
@property (weak, nonatomic) IBOutlet UISwitch *lock_btn;

//震动强度按钮
@property (weak, nonatomic) IBOutlet UIButton *vibrate_btn;

@end

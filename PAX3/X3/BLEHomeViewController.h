//
//  BLEHomeViewController.h
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BELHomeBackgroundView;

@interface BLEHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (retain,nonatomic) BELHomeBackgroundView *backView;

@property (weak, nonatomic) IBOutlet UIView *model_view;
@property (weak, nonatomic) IBOutlet UIView *choose_modelView;
@property (weak, nonatomic) IBOutlet UIView *choose_tmp_view;
@property (weak, nonatomic) IBOutlet UIImageView *battery_view;
@property (weak, nonatomic) IBOutlet UILabel *device_name_lable;

@property (weak, nonatomic) IBOutlet UILabel *title_lableView;
@property (weak, nonatomic) IBOutlet UILabel *title2_lableView;
@property (weak, nonatomic) IBOutlet UILabel *title3_lableView;

@end

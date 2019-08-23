//
//  ModeChooseXibView.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/18.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeChooseXibView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *ImageView01;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView02;

@property (weak, nonatomic) IBOutlet UILabel *Lable_temp;
@property (weak, nonatomic) IBOutlet UILabel *Lable_Power;

@property (weak, nonatomic) IBOutlet UIView *view_temp;
@property (weak, nonatomic) IBOutlet UIView *view_power;

@end

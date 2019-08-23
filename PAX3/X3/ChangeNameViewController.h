//
//  ChangeNameViewController.h
//  PAX3
//
//  Created by tyz on 17/5/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lable_name;
@property (weak, nonatomic) IBOutlet UIView *pax_image_view;
@property (weak, nonatomic) IBOutlet UIView *end_view;
@property (weak, nonatomic) IBOutlet UIView *lable_name_view;

@property (nonatomic,assign) int color_device;

@end

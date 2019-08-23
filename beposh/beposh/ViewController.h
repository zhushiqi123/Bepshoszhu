//
//  ViewController.h
//  beposh
//
//  Created by 田阳柱 on 16/7/22.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_find;

@property (weak, nonatomic) IBOutlet UIView *topBarView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vapedView1_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vapedView1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vapedBtn1_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vapedBtn1_width;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flavourView2_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flavourView2_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flavourBtn2_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flavourBtn2_height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashView3_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashView3_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashBtn3_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashBtn3_height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopView4_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopView4_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopBtn4_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopBtn4_height;


@end


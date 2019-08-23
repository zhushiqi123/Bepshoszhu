//
//  TempTypeChooseXibView.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/18.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempTypeChooseXibView : UIView

@property (weak, nonatomic) IBOutlet UIView *temp_view_Celsius;
@property (weak, nonatomic) IBOutlet UIView *temp_view_Fahrenheit;

@property (weak, nonatomic) IBOutlet UILabel *lable_Celsius;
@property (weak, nonatomic) IBOutlet UILabel *lable_Fahrenheit;

@end

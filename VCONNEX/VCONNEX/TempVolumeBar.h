//
//  TempVolumeBar.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/18.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempVolumeBar : UIView
{
@private
    CGPoint box_circle_center;
    float box_start_Angle;
    float box_end_Angle;
    float box_circle_radius;
    float point_arc;
    BOOL checkTouchType;
    CGPoint start_circle_point;  //0角度的点
    CGPoint touch_circle_point;  //触摸的点
    //当前仪表功率值
    int temp_num;
    
    UIImageView *backgroundImage;
}

/**
 *  初始化设置
 *
 *  @param frame         window 大小
 *  @param circle_center 圆心
 *  @param start_Angle   开始角度
 *  @param end_Angle     结束角度
 *  @param circle_radius 半径
 */
- (id)initWithFrame:(CGRect)frame :(CGPoint)circle_center :(float)start_Angle :(float)end_Angle :(float)circle_radius;

@property(nonatomic,retain) UILabel *power_lable;
@property(nonatomic,retain) UILabel *powerStrLable;

//刷新UI
-(void)refreshUI:(int)temp :(int)model;

@end

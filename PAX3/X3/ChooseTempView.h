//
//  ChooseTempView.h
//  PAX3
//
//  Created by tyz on 17/5/6.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseTempViewCards;

@interface ChooseTempView : UIView

- (id)initWithFrame:(CGRect)frame :(int)trmp_value :(int)temp_value_now :(int)trmp_model;

-(void)view_refresh:(int)trmp_value :(int)temp_value_now :(int)trmp_model;

@property (nonatomic, retain) UIView *choose_view;
//左右滑动温度选择
@property (nonatomic, strong) ChooseTempViewCards *choose_temp_sliding;

@property (nonatomic, retain) UILabel *temp_lable_now;
@property (nonatomic, retain) UILabel *temp_lable_set;
@property (nonatomic, retain) UILabel *temp_lable_mode;

@property (nonatomic, assign) float tmpview_width;
@property (nonatomic, assign) float tmpview_height;

@property (nonatomic, assign) int temp_value;  //最高温度
@property (nonatomic, assign) int temp_model;  //温度类型
@property (nonatomic, assign) int temp_value_now;  //实时温度

@property (nonatomic, assign) int tmp_value_nums;

@property (nonatomic, assign) CGPoint start_point;
@property (nonatomic, assign) CGPoint end_point;

//模式列表
@property (nonatomic,strong) NSArray *chooseTemp_dicAry;

@end

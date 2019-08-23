//
//  zsq_GaugePanel.h
//  GaugePanel
//
//  Created by 朱世琦 on 17/12/11.
//  Copyright © 2017年 zsq. All rights reserved.
//
#import <React/RCTConvert.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>
#import <UIKit/UIKit.h>
//自定义结构体 进行数据传递
typedef struct {
    float minValue;
    float maxValue;
    float startAngle ;//开始度数
    float sweepAngle;//绘制度数
   __unsafe_unretained NSString *  unit; //单位
   __unsafe_unretained  NSString * format ;//格式化值
     float mSection; //刻度分割数量
     float  defaultValue; //默认值
} valueconfig;

/*属性chuangzh*/
@interface zsq_GaugePanel : UIView
@property (nonatomic) valueconfig valueconfig;  // 返回结构体的属性
  //定义值
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;


@end

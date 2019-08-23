//
//  Animation Panel.h
//  GaugePanel
//
//  Created by 朱世琦 on 17/12/2.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTConvert.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>

//自定义结构体 进行数据传递
typedef struct {
  float minValue;
  float maxValue;
  float startAngle ;//开始度数
  float sweepAngle ;//绘制度数
  __unsafe_unretained NSString *  unit; //单位
  __unsafe_unretained  NSString * format ;//格式化值
  float mSection; //刻度分割数量
  float  defaultValue; //默认值
} valueconfigConnection;

@interface Animation_Panel : UIView
@property(nonatomic) valueconfigConnection  valueconfig;

+(void) startAroundAnim;
+(void) stopAroundAnim;
- (void ) startAnimation;
- (void) endAnimation;
//属性传值
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;
// 动态的设置中心的文字

@end

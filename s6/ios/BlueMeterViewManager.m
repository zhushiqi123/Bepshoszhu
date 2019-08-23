//
//  BlueMeterViewManager.m
//  s6
//
//  Created by xie on 17/12/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <React/RCTViewManager.h>
#import "zsq_GaugePanel.h"
#import "RCTConvert+TextDemo.h"
@interface BlueMeterViewManager : RCTViewManager
@end
// 温度监测
@implementation BlueMeterViewManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(changeValue,BOOL)
RCT_EXPORT_VIEW_PROPERTY(point,BOOL)
RCT_EXPORT_VIEW_PROPERTY(unitDirection,NSString)
RCT_EXPORT_VIEW_PROPERTY(value,float)

/*
 startAroundAnim //开始指针旋转动画
 stopAroundAnim //停止指针旋转动画
 startColorAnim //开始蓝牙连接成功动画
 cleanColorAnim //清除蓝牙连接成功动画
 */
RCT_CUSTOM_VIEW_PROPERTY(valueconfig, valueConfigStruct , zsq_GaugePanel)
{
    [view setValueconfig:json ? [RCTConvert valueConfigStruct:json] : defaultView.valueconfig ];
}
- (UIView *)view
{
  
       
  return [[zsq_GaugePanel alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

@end

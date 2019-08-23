//
//  AnimMeterViewManager.m
//  s6
//
//  Created by xie on 17/12/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <React/RCTViewManager.h>
#import "Animation Panel.h"
#import "RCTConvert+Animation.h"
#import "AnimMeterViewManager.h"
//@interface AnimMeterViewManager : RCTViewManager
//
//
//@end
//   连接的视图
@implementation AnimMeterViewManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(changeValue,BOOL)
RCT_EXPORT_VIEW_PROPERTY(point,BOOL)
RCT_EXPORT_VIEW_PROPERTY(unitDirection,NSString)
RCT_EXPORT_VIEW_PROPERTY(value,NSInteger)
/*
 startAroundAnim //开始指针旋转动画
 stopAroundAnim //停止指针旋转动画
 startColorAnim //开始蓝牙连接成功动画
 cleanColorAnim //清除蓝牙连接成功动画
 */
// Both of these methods needs to be called from the main thread so the
// UI can clear out the signature.
// 结束动画

RCT_EXPORT_METHOD(startAroundAnim:(nonnull NSNumber *)reactTag) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.ap startAnimation];
  });
 // [self.ap startAnimation];
}
// 开始动画
RCT_EXPORT_METHOD(stopAroundAnim:(nonnull NSNumber *)reactTag) {
  dispatch_async(dispatch_get_main_queue(), ^{
    
    
    
   [self.ap endAnimation];
  });
}


RCT_EXPORT_METHOD(startColorAnim:(nonnull NSNumber *)reactTag) {
  
 
}
// 开始动画
RCT_EXPORT_METHOD(cleanColorAnim:(nonnull NSNumber *)reactTag) {
  
}
RCT_CUSTOM_VIEW_PROPERTY(valueconfig, valueconfigElectric , Animation_Panel)
{
    [view setValueconfig:json ? [RCTConvert valueConfigStructConnection:json] : defaultView.valueconfig ];
}
- (UIView *)view
{
  self.ap =[[Animation_Panel alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
  return self.ap;
}

@end

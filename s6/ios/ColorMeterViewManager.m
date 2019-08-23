//
//  ColorMeterViewManager.m
//  s6
//
//  Created by xie on 17/12/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <React/RCTViewManager.h>
#import "ElectricQuantity.h"
#import "RCTConvert+ElectricQuantity.h"
@interface ColorMeterViewManager : RCTViewManager
@end
// 电量监测
@implementation ColorMeterViewManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(changeValue,BOOL)
RCT_EXPORT_VIEW_PROPERTY(point,BOOL)
RCT_EXPORT_VIEW_PROPERTY(unitDirection,NSString)
RCT_EXPORT_VIEW_PROPERTY(value,float)

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
/*
 startAroundAnim //开始指针旋转动画
 stopAroundAnim //停止指针旋转动画
 startColorAnim //开始蓝牙连接成功动画
 cleanColorAnim //清除蓝牙连接成功动画
 */

// Both of these methods needs to be called from the main thread so the
// UI can clear out the signature.


//RCT_EXPORT_METHOD(resetImage:(nonnull NSNumber *)reactTag) {
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [ElectricQuantity erase];
//  });
//}

//-(void) publishSaveImageEvent:(NSString *) aTempPath withEncoded: (NSString *) aEncoded {
//  [self.bridge.eventDispatcher
//   sendDeviceEventWithName:@"onSaveEvent"
//   body:@{
//          @"pathName": aTempPath,
//          @"encoded": aEncoded
//          }];
//}
//
//-(void) publishDraggedEvent {
//  [self.bridge.eventDispatcher
//   sendDeviceEventWithName:@"onDragEvent"
//   body:@{@"dragged": @YES}];
//}



RCT_CUSTOM_VIEW_PROPERTY(valueconfig, valueConfigStructElectric , ElectricQuantity)
{
    [view setValueconfig:json ? [RCTConvert valueConfigStructElectric:json] : defaultView.valueconfig ];
}
- (UIView *)view
{
  
  return [[ElectricQuantity alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

@end

//
//  STW_DeviceData.h
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STW_DeviceData : NSObject

//设备ID
@property (nonatomic,copy) NSString *device_mac;
//设备名称
@property (nonatomic,copy) NSString *device_name;
//设备颜色
@property (nonatomic,assign) int pax_color;
//设备型号
@property (nonatomic,assign) int device_model;

//返回设备对象
+(STW_DeviceData *)STW_DeviceDataInit:(NSString *)device_mac device_name:(NSString *)device_name pax_color:(int)pax_color device_model:(int)device_model;

@end

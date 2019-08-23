//
//  STW_DeviceData.m
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "STW_DeviceData.h"

@implementation STW_DeviceData

//返回设备对象
+(STW_DeviceData *)STW_DeviceDataInit:(NSString *)device_mac device_name:(NSString *)device_name pax_color:(int)pax_color device_model:(int)device_model
{
    STW_DeviceData *device_data = [[STW_DeviceData alloc] init];
    device_data.device_mac = device_mac;
    device_data.device_name = device_name;
    device_data.pax_color = pax_color;
    device_data.device_model = device_model;
    return device_data;
}

@end

//
//  STW_Data_Plist.h
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STW_DeviceData.h"
#import "MJExtension.h"

@interface STW_Data_Plist : NSObject

//保存用户设备信息
+(int)SaveDeviceData:(NSMutableArray *)deviceArray;

//获取本地缓存的用户设备信息
+(NSMutableArray *)GetDeviceData;

//保存用户设置的温度单位信息
+(int)SaveTempModelData:(int)temp_model;

//获取用户设置的温度单位信息
+(int)GetTempModelData;

@end

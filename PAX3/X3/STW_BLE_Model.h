//
//  STW_BLE_Model.h
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STW_BLE_Model : NSObject

//加热模式 – D4
@property (nonatomic,assign) int work_model;
//温度模式 – D5
@property (nonatomic,assign) int tmp_model;
//发热杯最高温度 – D6 D7
@property (nonatomic,assign) int tmp_max;
//发热杯当前温度 – D8 D9
@property (nonatomic,assign) int tmp_now;
//亮灯的颜色模式 – D10
@property (nonatomic,assign) int lamp_model;
//亮度百分比 – D11
@property (nonatomic,assign) int brightness_value;
//游戏模式 – D12
@property (nonatomic,assign) int game_model;
//是否锁机 – D13
@property (nonatomic,assign) int boot_status;
//震动强度百分比 – D14
@property (nonatomic,assign) int vibration_value;
//机身颜色 - D15
@property (nonatomic,assign) int pax_color;
//电池电量 - D16
@property (nonatomic,assign) int pax_battery;

//返回设备对象
+(STW_BLE_Model *)STW_BLE_ModelInit:(int)work_model tmp_model:(int)tmp_model tmp_max:(int)tmp_max tmp_now:(int)tmp_now lamp_model:(int)lamp_model brightness_value:(int)brightness_value game_model:(int)game_model boot_status:(int)boot_status vibration_value:(int)vibration_value pax_color:(int)pax_color pax_battery:(int)pax_battery;

@end

//
//  STW_BLE_Model.m
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "STW_BLE_Model.h"

@implementation STW_BLE_Model

//返回设备对象
+(STW_BLE_Model *)STW_BLE_ModelInit:(int)work_model tmp_model:(int)tmp_model tmp_max:(int)tmp_max tmp_now:(int)tmp_now lamp_model:(int)lamp_model brightness_value:(int)brightness_value game_model:(int)game_model boot_status:(int)boot_status vibration_value:(int)vibration_value pax_color:(int)pax_color pax_battery:(int)pax_battery
{
    STW_BLE_Model *stw_model = [[STW_BLE_Model alloc] init];
    //加热模式 – D4
    stw_model.work_model = work_model;
    //温度模式 – D5
    stw_model.tmp_model = tmp_model;
    //发热杯最高温度 – D6 D7
    stw_model.tmp_max = tmp_max;
    //发热杯当前温度 – D8 D9
    stw_model.tmp_now = tmp_now;
    //亮灯的颜色模式 – D10
    stw_model.lamp_model = lamp_model;
    //亮度百分比 – D11
    stw_model.brightness_value = brightness_value;
    //游戏模式 – D12
    stw_model.game_model = game_model;
    //是否锁机 – D13
    stw_model.boot_status = boot_status;
    //震动强度百分比 – D14
    stw_model.vibration_value = vibration_value;
    //机身颜色 - D15
    stw_model.pax_color = pax_color;
    //电池电量 - D16
    stw_model.pax_battery = pax_battery;
    
    return stw_model;
}

@end

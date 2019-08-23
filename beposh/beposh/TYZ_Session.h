//
//  TYZ_Session.h
//
//  Created by 田阳柱 on 16/7/30.
//  Copyright © 2016年 TYZ. All rights reserved.
//
//  If you need to add more features or command, You should to update the STW_BLE_SDK.a
//  We will continue to provide support for you

#import <Foundation/Foundation.h>

@interface TYZ_Session : NSObject

/**
 *  Whether Bluetooth is connecting
 *  0 connection
 *  1 disconnect
 */
@property(nonatomic,assign) int check_BLE_status;

/**
 *  device lock
 *  0 ON
 *  1 OFF
 */
@property(nonatomic,assign) int lock_device;

/**
 *  prediction lock
 *  0 ON
 *  1 OFF
 */
@property(nonatomic,assign) int tion_alarm;

/**
 *  prediction num
 *  tion_alarm_num（1 - 30）
 */
@property(nonatomic,assign) int tion_alarm_num;

/**
 *  power mode
 *  power_mode (0  1  2  3)
 */
@property(nonatomic,assign) int power_mode;

/**
 *  Language
 *  0 DEUTSCH
 *  1 ENGLISH
 */
@property(nonatomic,assign) int language_type;


/**
 *  prediction alarm num
 *  tion_alarm_num（1 - 30）
 */
@property(nonatomic,assign) int smoke_all_number;

/**
 *  the battery
 *  battery（0 - 100）
 */
@property(nonatomic,assign) int battery;

/**
 *  battery status
 *  0 normal
 *  1 Charging
 *  2 full
 */
@property(nonatomic,assign) int battery_status;

+(TYZ_Session *)sharedInstance;

@end

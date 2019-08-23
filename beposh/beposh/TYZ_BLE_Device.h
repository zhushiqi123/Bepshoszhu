//
//  TYZ_BLE_Device.h
//
//  Created by 田阳柱 on 16/7/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TYZ_BLE_Device : NSObject

@property (nonatomic,retain) CBPeripheral *peripheral;           //外围设备
@property (nonatomic,assign) NSNumber *RSSI;                     //信号强度RSSI
@property (nonatomic,retain) NSDictionary *advertisementData;    //广播数据
@property (nonatomic,copy) NSString *deviceName;               //设备名字

@property (nonatomic,retain) CBCharacteristic *characteristic;   //特征UUID
@property (nonatomic,copy) NSString *deviceMac;                //设备mac地址
@property (nonatomic,assign) int deviceModel;                    //设备型号

@end

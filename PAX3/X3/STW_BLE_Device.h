//
//  STW_BLEDevice.h
//  STW_BLE_SDK
//
//  Created by TYZ on 16/4/18.
//  Copyright © 2016 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface STW_BLE_Device : NSObject

@property (nonatomic,retain) CBPeripheral *peripheral;           //外围设备
@property (nonatomic,assign) NSNumber *RSSI;                     //信号强度RSSI - 意义不大
@property (nonatomic,retain) CBCharacteristic *characteristic;   //特征值(SDK内部使用)
@property (nonatomic,copy) NSString *deviceMac;                  //设备唯一ID(每一个设备都会不同)
@property (nonatomic,copy) NSString *deviceName;                 //设备名字 - (用于连接之前名称显示)
@property (nonatomic,assign) int deviceModel;                    //设备型号_配置文件中有说明(请厂商自行使用)
@property (nonatomic,assign) int deviceColor;                    //设备机身的颜色

@end

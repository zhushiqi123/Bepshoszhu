//
//  TYZ_BLE_Service.h
//
//  Created by 田阳柱 on 16/7/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TYZ_BLE_Device.h"
#import "TYZ_BLE_Protocol.h"

typedef NS_ENUM(NSInteger, BLEConnectStatus)
{
    BLEConnectStatusOn = 0x00,         //连接  Connect
    BLEConnectStatusLoding = 0x01,     //等待连接 waiting Connect
    BLEConnectStatusOff = 0x02,        //断开 disconnect
};

@interface TYZ_BLE_Service : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
//中心角色 - centralManager
@property (strong,nonatomic) CBCentralManager *centralManager;

//扫描到的设备所有数据数组 - all scaned Devices
@property(nonatomic,strong) NSMutableArray *scanedDevices;

//蓝牙设备所有的数据封装到TYZ_BLE_Device - device Model
@property(nonatomic,retain) TYZ_BLE_Device *device;

//蓝牙设备当前缓存数据封装到BLE_Device_data_more
@property(nonatomic,retain) NSMutableData *BLE_Device_data_more;

//是否断线重连 - reconnect
@property(nonatomic,assign)BLEConnectStatus Status_Connect;

//断开连接的设备 - disonnect device MAC
@property(nonatomic,copy)NSString *disonnect_deviceMac;

//蓝牙全局（单例）方法 - Bluetooth Global (singleton) method
+(TYZ_BLE_Service *)sharedInstance;

//蓝牙是否可用（true 可用  false 不可用） - Bluetooth is Ready Scan （true - YES  false - NO）
@property(nonatomic,assign) BOOL isReadyScan;

//扫描蓝牙的方法 - Bluetooth scanning method
-(void)scanStart;

//结束蓝牙扫描 - End Bluetooth scanning
-(void)scanStop;

//主动调取蓝牙连接 - Active Bluetooth connection retrieval
-(void)connect:(TYZ_BLE_Device *)device;

//主动断开设备 - disconnect Bluetooth
-(void)disconnect:(CBPeripheral *)periphera;

//向设备发送信息 - sendData to Device
-(void)sendData:(NSData *)data;

/* Scan to a bluetooth device will be call it */
typedef void (^BLEServiceScanHandler)(TYZ_BLE_Device *device);
@property(nonatomic,copy) BLEServiceScanHandler scanHandler;

/* Bluetooth connection success will be call it */
typedef void (^BLEServiceConnectedHandler)(void);
@property(nonatomic,copy) BLEServiceConnectedHandler connectedHandler;

/* Bluetooth connection success you need get the device more data */
typedef void (^BLEServiceDiscoverCharacteristicsForServiceHandler)(void);
@property(nonatomic,copy) BLEServiceDiscoverCharacteristicsForServiceHandler discoverCharacteristicsForServiceHandler;

/*--------------------------------------------------Bluetooth Get Data D0*/
//初始查询命令 -  Initial inquiries back
typedef void (^BLEServiceNotifyHandlerD0)(int check_ble);
@property(nonatomic,copy) BLEServiceNotifyHandlerD0 notifyHandlerD0;

/*--------------------------------------------------Bluetooth Get Data D1*/
//预设吸烟口数命令 - smoke plan
typedef void (^BLEServiceNotifyHandlerD1)(int smoke_bools,int smoke_actual,int smoke_expect);
@property(nonatomic,copy) BLEServiceNotifyHandlerD1 notifyHandlerD1;

/*--------------------------------------------------Bluetooth Get Data D2*/
//输出电压命令 - output voltage
typedef void (^BLEServiceNotifyHandlerD2)(int output_voltage);
@property(nonatomic,copy) BLEServiceNotifyHandlerD2 notifyHandlerD2;

/*--------------------------------------------------Bluetooth Get Data D3*/
//电池电量&充电显示 - battery
typedef void (^BLEServiceNotifyHandlerD3)(int battery,int battery_status);
@property(nonatomic,copy) BLEServiceNotifyHandlerD3 notifyHandlerD3;

/*--------------------------------------------------Bluetooth Get Data D4*/
//当前口数 - smoke_all_number
typedef void (^BLEServiceNotifyHandlerD4)(int smoke_all_number);
@property(nonatomic,copy) BLEServiceNotifyHandlerD4 notifyHandlerD4;

/*--------------------------------------------------Bluetooth Get Data D5*/
//开锁机 - lock
typedef void (^BLEServiceNotifyHandlerD5)(int lock,int lock_way);
@property(nonatomic,copy) BLEServiceNotifyHandlerD5 notifyHandlerD5;

/*--------------------------------------------------Bluetooth Get Data D6*/
//设置电子烟时间  - set the time back
typedef void (^BLEServiceNotifyHandlerD6)(NSArray *array);
@property(nonatomic,copy) BLEServiceNotifyHandlerD6 notifyHandlerD6;

/*--------------------------------------------------Bluetooth Get Data D7*/
//读取历史数据 - Get the Record back
typedef void (^BLEServiceNotifyHandlerD7)(NSString *strings,int recordNum);
@property(nonatomic,copy) BLEServiceNotifyHandlerD7 notifyHandlerD7;

/*--------------------------------------------------Bluetooth Get Data D8*/
//修改设备名称 checkNum 0 - success  1 - error
typedef void (^BLEServiceNotifyHandlerD8)(int checkNum);
@property(nonatomic,copy) BLEServiceNotifyHandlerD8 notifyHandlerD8;

/*--------------------------------------------------Bluetooth Get Data D9*/
//返回设备唯一ID ID_str - 设置唯一ID
typedef void (^BLEServiceNotifyHandlerD9)(NSString *ID_str);
@property(nonatomic,copy) BLEServiceNotifyHandlerD9 notifyHandlerD9;

/*-蓝牙断开时候调用 - when the Bluetooth connection is lost will be Block*/
typedef void (^BLEServiceDisconnectHandler)(void);
@property(nonatomic,copy) BLEServiceDisconnectHandler disconnectHandler;

/*--------------------------------------------------All Error Block*/
typedef void (^BLEServiceErrorHandler)(NSString *message);
@property(nonatomic,copy) BLEServiceErrorHandler errorHandler;

@end

/*************************************************/
/*******   STW ECIG uVapor BLE Framework   *******/
/******************** V1.0.1 *********************/
/*************************************************/

//****************   V1.0.1    ********************/
// V1.0.1
// 2016/04/18
// Author-STW_TYZ
// **************    所用变量说明     **************/
// *1.电压 - Voltage
// *2.电流 - Electricity
// *3.功率 - Power
// *4.温度 - Temp(temperature 简写)
// *5.类型 - Type
// *6.种类 - Mode
// *7.电池 - Battery
// *8.雾化器 - Atomizer
// *9.状态 - Status
//*************************************************/


//  STW_BLE_SDK.h
//  STW_BLE_SDK
//
//  Created by TYZ on 16/4/18.
//  Copyright © 2016 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "STW_BLEService.h"
#import "STW_BLEDevice.h"
#import "STW_BLE_Protocol.h"
#import "softUpdateBean.h"

@interface STW_BLE_SDK : NSObject

+(STW_BLE_SDK *)STW_SDK;

/*-------------      全局需要使用的变量    ---------------*/
@property (nonatomic,assign) int power;            //功率
@property (nonatomic,assign) int temperature;      //温度
@property (nonatomic,assign) int battery;          //电池电量
@property (nonatomic,assign) int atomizer;         //雾化器阻值
@property (nonatomic,assign) int vaporStatus;      //吸烟状态
@property (nonatomic,assign) int vapor_Activity;   //设备活动状态

@property (nonatomic,assign) int temperatureMold;  //温度类型
@property (nonatomic,assign) int atomizerMold;     //雾化器类型
@property (nonatomic,assign) int vaporModel;        //工作类型（温度模式,功率模式,电压模式,手动温控模式）

@property (nonatomic,retain) NSMutableArray *tcrArrys;     //tcr数据数组
@property (nonatomic,retain) NSMutableArray *cctArrys;     //cct数据数组

@property (nonatomic,assign) int keys_num;        //按键次数
@property (nonatomic,retain) NSString *deviceMac;  //正在连接设备的mac地址
@property (nonatomic,assign) int check_DeviceBinding;  //检测是否已经绑定

@property (nonatomic,retain) NSMutableArray *fileDeviceArrys;     //本地设备数组

//升级数据信息
@property(nonatomic,assign) int Update_Now;          //是否正在升级 0 - 否 1 - 是
@property(nonatomic,retain) softUpdateBean *softUpdate_bean;   //当前选择的升级数据信息
@property(nonatomic,retain) NSMutableArray *softUpdate_lostPage;   //所丢失的包数

//锁定雾化器阻值
@property(nonatomic,assign) int Lock_Atomizer;       //是否锁定雾化器阻值  0 - 否 1 - 是
@property(nonatomic,assign) int new_Atomizer;        //新的雾化器阻值
@property(nonatomic,assign) int old_Atomizer;        //旧的雾化器阻值
@end

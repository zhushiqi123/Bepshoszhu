//
//  STW_BLEService.h
//  STW_BLE_SDK
//
//  Created by 田阳柱 on 16/4/18.
//  Copyright © 2016年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "STW_BLEDevice.h"
#import "STW_BLEservice.h"

/*-------------------------------------     全局变量     ----------------------------------*/
//数据包头
typedef NS_ENUM(NSInteger, BLEProtocolHeader)
{
    BLEProtocolHeader01 = 0xa8
};

//设备型号
typedef NS_ENUM(NSInteger, BLEDerviceModel)
{
    BLEDerviceModelSTW01 = 0x01,       //40W
    BLEDerviceModelSTW02 = 0x02,       //50W
    BLEDerviceModelSTW03 = 0x03,       //60W
    BLEDerviceModelSTW04 = 0x04,       //70W
    BLEDerviceModelSTW05 = 0x05,       //80W
    BLEDerviceModelSTW06 = 0x06,       //90W
    BLEDerviceModelSTW07 = 0x07,       //100W
    BLEDerviceModelSTW08 = 0x08,       //150W
};

//雾化器材料
typedef NS_ENUM(NSInteger, BLEAtomizerModel)
{
    BLEAtomizerX1 = 0x01,     //Ni
    BLEAtomizerX2 = 0x02,     //Ti
    BLEAtomizerX3 = 0x03,     //Fe
    BLEAtomizerX4 = 0x04,     //SS
    BLEAtomizerX5 = 0x05,      //Nicr
    
    BLEAtomizersM1 = 0x81,    //M1
    BLEAtomizersM2 = 0x82,    //M2
    BLEAtomizersM3 = 0x83,    //M3
};

//宏定义Custom曲线选择集合
typedef NS_ENUM(NSInteger,BLEProtocolCustomLineCommand)
{
    BLEProtocolCustomLineCommand01 = 0x01,  //曲线1
    BLEProtocolCustomLineCommand02 = 0x02,  //曲线2
    BLEProtocolCustomLineCommand03 = 0x03,  //曲线3
};

//吸烟状态
typedef NS_ENUM(NSInteger,BLEProtocolVaporStatus)
{
    BLEProtocolVaporStatus00 = 0x00, //开始吸烟
    BLEProtocolVaporStatus01 = 0x01, //停止吸烟
    BLEProtocolVaporStatus02 = 0x02, //LOW ATOMIZER(雾化器阻值低于0.1Ω)
    BLEProtocolVaporStatus03 = 0x03, //HIGH ATOMIZER(雾化器阻值高于5Ω)
    BLEProtocolVaporStatus04 = 0x04, //CHECK ATOMIZER(雾化器开路/没哟雾化器)
    BLEProtocolVaporStatus05 = 0x05, //ATOMIZER SHORT(雾化器短路)
    BLEProtocolVaporStatus06 = 0x06, //10S OVER(吸烟超时)
    BLEProtocolVaporStatus07 = 0x07, //雾化器接入提示
    BLEProtocolVaporStatus08 = 0x08, //过温保护 PCB TOO HOT
    BLEProtocolVaporStatus09 = 0x09, //电池电压过低 LOW BATTARY
};

//是否禁止抽烟
typedef NS_ENUM(NSInteger, BLEProtocolStatusType)
{
    BLEProtocolStatusTypeEnable = 0x00,      //禁止吸烟
    BLEProtocolStatusTypeDisable = 0x01      //不禁止吸烟
};

//调节模式0功率调节1电压调节2温度调节
//宏定义Custom 温度曲线选择集合
typedef NS_ENUM(NSInteger,BLEProtocolTempLineCommand)
{
    BLEProtocolCustomLineTemp01 = 0x01,  //温度曲线1
    BLEProtocolCustomLineTemp02 = 0x02,  //温度曲线2
    BLEProtocolCustomLineTemp03 = 0x03,  //温度曲线3
};

//温度类型
typedef NS_ENUM(NSInteger, BLEProtocolTemperatureUnit)
{
    BLEProtocolTemperatureUnitCelsius = 0x00,      //摄氏度
    BLEProtocolTemperatureUnitFahrenheit = 0x01    //华氏度
};

typedef NS_ENUM(NSInteger, BLEProtocolModeType)
{
    BLEProtocolModeTypePower = 0x00,            //功率模式
    BLEProtocolModeTypeVoltage = 0x01,          //电压模式
    BLEProtocolModeTypeTemperature = 0x02,      //温度模式 _ Temp
    BLEProtocolModeTypeBypas = 0x03,            //直接输出模式 - ByPass
    BLEProtocolModeTypeCustom = 0x04,           //自定义模式 - Custom
};

//设备是否处于休眠状态
typedef NS_ENUM(NSInteger, BLEProtocolSleep)
{
    BLEProtocolDriveActivity = 0x00,    //活跃
    BLEProtocolDriveSleep = 0x01,       //睡眠
};

//TCR
typedef NS_ENUM(NSInteger, BLETCRBool)
{
    BLETCRBoolNO = 0x00,    //不支持TCR
    BLETCRBoolYES = 0x01,   //支持TCR
};

typedef NS_ENUM(NSInteger, STW_BLECommand)
{
    STW_BLECommand000 = 0x00,           //检测电子烟是否已经绑定
    STW_BLECommand001 = 0x01,           //查询所有配置信息
    STW_BLECommand002 = 0x02,           //设置系统时间
    STW_BLECommand003 = 0x03,           //查询、设置工作模式
    STW_BLECommand004 = 0x04,           //查询、设置TCR（雾化器）
    STW_BLECommand005 = 0x05,           //查询、主动发送电池电量
    STW_BLECommand006 = 0x06,           //查询、主动发送雾化器阻值
    STW_BLECommand007 = 0x07,           //查询、设置（CCT）手动温度补偿 - 11个点按照百分比发送
    STW_BLECommand008 = 0x08,           //查询、设置按键进步
    STW_BLECommand009 = 0x09,           //传输吸烟状态
    STW_BLECommand00A = 0x0A,           //激活设备、设备休眠发送设备状态
    STW_BLECommand00B = 0x0B,           //无线升级
    STW_BLECommand00C = 0x0C,           //设备信息、软件硬件版本
    STW_BLECommand00D = 0x0D,           //锁定、解锁雾化器
};

typedef NS_ENUM(NSInteger, STW_isBLEType)
{
    STW_BLE_IsBLETypeOff = 0x01,   //断开
    STW_BLE_IsBLETypeOn = 0x02,   //连接
    STW_BLE_IsBLETypeLoding = 0x03,   //等待重连
    STW_BLE_IsBLETypeUpdate = 0x04,   //正在升级
};

typedef NS_ENUM(NSInteger, STW_isBLEDisType)
{
    STW_BLE_IsBLEDisTypeScanRoot = 0x01,  //扫描01
    STW_BLE_IsBLEDisTypeScan = 0x02,      //扫描02
    STW_BLE_IsBLEDisTypeOn = 0x03,      //扫描02
};

@interface STW_BLEService : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

/*---------------------------------------   判定数据   ------------------------------------*/
/**
 *  蓝牙是否正在连接
 */
@property(nonatomic,assign) BOOL isBLEStatus;

/**
 *  蓝牙连接状态
 */
@property(nonatomic,assign) STW_isBLEType isBLEType;

/**
 *  蓝牙断开接收状态
 */
@property(nonatomic,assign) STW_isBLEDisType isBLEDisType;

/**
 *  扫描到的设备列表
 */
@property(nonatomic,retain) NSMutableArray *scanedDevices;

/**
 *  蓝牙是否可用
 */
@property(nonatomic,assign) BOOL isReadyScan;

/*----------------------------------   蓝牙 Manager连接数据   -----------------------------*/
/**
 *  错误处理
 *
 *  @param message 错误信息
 */
typedef void (^BLEServiceErrorHandler)(NSString *message);
@property(nonatomic,copy) BLEServiceErrorHandler Service_errorHandler;

/**
 *  扫描到了蓝牙设备
 *
 *  @param device 蓝牙设备广播信息 STW_BLEDevice 对象
 */
typedef void (^BLEServiceScanHandler)(STW_BLEDevice *device);
@property(nonatomic,copy) BLEServiceScanHandler Service_scanHandler;

/**
 *  连接蓝牙之后执行的方法
 */
typedef void (^BLEServiceConnectedHandler)(void);
@property(nonatomic,copy) BLEServiceConnectedHandler Service_connectedHandler;

/*------------------------------ VCONNEX 处理蓝牙断开方法 ---------------------------------*/
/**
 *  断开连接扫描01
 */
typedef void (^BLEServiceDisconnectHandlerRoot)(void);
@property(nonatomic,copy) BLEServiceDisconnectHandlerRoot Service_disconnectHandlerRoot;

/**
 *  断开连接扫描02
 */
typedef void (^BLEServiceDisconnectHandlerScan)(void);
@property(nonatomic,copy) BLEServiceDisconnectHandlerScan Service_disconnectHandlerScan;

/**
 *  断开连接正在连接
 */
typedef void (^BLEServiceDisconnectHandlerOn)(void);
@property(nonatomic,copy) BLEServiceDisconnectHandlerOn Service_disconnectHandlerOn;

/**
 *  APP进入后台 Root
 */
typedef void (^BLEServiceStopScanRoot)(void);
@property(nonatomic,copy) BLEServiceStopScanRoot Service_StopScanRoot;

/**
 *  APP进入后台 ScanView
 */
typedef void (^BLEServiceStopScanView)(void);
@property(nonatomic,copy) BLEServiceStopScanView Service_StopScanView;

/**
 *  APP进入后台 HOME
 */
typedef void (^BLEServiceStopScanHOME)(void);
@property(nonatomic,copy) BLEServiceStopScanHOME Service_StopHOME;

/*------------------------------ VCONNEX 处理蓝牙断开方法 ---------------------------------*/

/**
 *  通知查询所有信息
 */
typedef void (^BLEServiceScanToFindData)(void);
@property(nonatomic,copy) BLEServiceScanToFindData Service_ScanToFindData;

/**
 *  调用该方法进行初始查询
 */
typedef void (^BLEServiceDiscoverCharacteristicsForServiceHandler)(void);
@property(nonatomic,copy) BLEServiceDiscoverCharacteristicsForServiceHandler Service_discoverCharacteristicsForServiceHandler;

/*-------------------------------------   获取从机数据   ----------------------------------*/
/**
 *  从机数据-设备绑定回调
 *
 *  @param deviceType_check 设备状态
 */
typedef void (^BLEServiceDeviceTypeCheck)(int deviceType_check);
@property(nonatomic,copy) BLEServiceDeviceTypeCheck Service_DeviceCheck;

/**
 *  从机数据-电池电量
 *
 *  @param battery 电池电量 0 - 100
 */
typedef void (^BLEServiceDeviceBattery)(int battery);
@property(nonatomic,copy) BLEServiceDeviceBattery Service_Battery;

/**
 *  从机数据-雾化器负载和大小
 *
 *  @param resistance   负载大小
 *  @param atomizerMold 负载类型
 */
typedef void (^BLEServiceDeviceAtomizerData)(int resistance,int atomizerMold);
@property(nonatomic,copy) BLEServiceDeviceAtomizerData Service_AtomizerData;

/**
 *  从机数据-功率
 *
 *  @param power 功率值
 */
typedef void (^BLEServiceDevicePower)(int power);
@property(nonatomic,copy) BLEServiceDevicePower Service_Power;

/**
 *  从机数据-温度/温度单位
 *
 *  @param temp      温度值
 *  @param tempModel 温度单位
 */
typedef void (^BLEServiceDeviceTemp)(int temp,int tempModel);
@property(nonatomic,copy) BLEServiceDeviceTemp Service_Temp;

/**
 *  从机数据-设置时间
 *
 *  @param time_status 应答值 0xFE - 接收成功  0x01 校验错误 0xEE 其他错误
 */
typedef void (^BLEServiceDeviceSetTime)(int time_status);
@property(nonatomic,copy) BLEServiceDeviceSetTime Service_SetTime;

/**
 *  从机数据-返回TCR信息
 *
 *  @param ChangeRate_Ni  Ni的变化率
 *  @param ChangeRate_Ss  Ss变化率
 *  @param ChangeRate_Ti  Ti的变化率
 *  @param ChangeRate_TCR TCR的变化率
 */
typedef void (^BLEServiceDeviceTCRData)(int ChangeRate_Ni,int ChangeRate_Ss,int ChangeRate_Ti,int ChangeRate_TCR);
@property(nonatomic,copy) BLEServiceDeviceTCRData Service_TCRData;

/**
 *  从机数据 - 返回CCT (温度补偿) 信息
 *
 *  @param CCTArrys 从机数组数据
 */
typedef void (^BLEServiceDeviceCCTData)(NSMutableArray *CCTArrys);
@property(nonatomic,copy) BLEServiceDeviceCCTData Service_CCTData;

/**
 *  从机数据 - 返回按键次数
 *
 *  @param keys_num 按键次数
 */
typedef void (^BLEServiceDeviceSetKeyNums)(int keys_num);
@property(nonatomic,copy) BLEServiceDeviceSetKeyNums Service_SetKeyNums;

/**
 *  从机数据 - 设备硬件信息
 *
 *  @param Device_Version 硬件版本编号
 *  @param Soft_Version   软件版本编号
 */
typedef void (^BLEServiceFind_DeviceData)(int Device_Version,int Soft_Version);
@property(nonatomic,copy) BLEServiceFind_DeviceData Service_Find_DeviceData;

/**
 *  从机数据 - 雾化器是否锁定
 *
 *  @param Lock_type 雾化器锁定状态
 */
typedef void (^BLEServiceAtomizerLock)(int Lock_type,int Lock_Atomizer);
@property(nonatomic,copy) BLEServiceAtomizerLock Service_AtomizerLock;

/**
 *  从机数据 - 雾化器更新确认
 *
 *  @param Atomizer_new_old 是否是新的雾化器
 */
typedef void (^BLEServiceAtomizerNew)(int Atomizer_old ,int Atomizer_new);
@property(nonatomic,copy) BLEServiceAtomizerNew Service_AtomizerNew;

/**
 *  从机数据-升级程序
 *
 *  @param pageNum 当前传输包数
 */
typedef void (^BLEServiceSoftUpdate)(int pageNum);
@property(nonatomic,copy) BLEServiceSoftUpdate Service_Soft_Update;

/**
 *  从机数据-吸烟状态
 *
 *  0x00 – 开始吸烟
 *  0x01 – 停止吸烟
 *  0x02 – LOW ATOMIZER(雾化器阻值低于0.1Ω)
 *  0x03 – HIGH ATOMIZER(雾化器阻值高于5Ω)
 *  0x04 – CHECK ATOMIZER(雾化器开路/没哟雾化器)
 *  0x05 – ATOMIZER SHORT(雾化器短路)
 *  0x06 – 10S OVER(吸烟超时)
 *
 */
typedef void (^BLEServiceDeviceVaporStatus)(int vapor_status);
@property(nonatomic,copy) BLEServiceDeviceVaporStatus Service_VaporStatus;

/**
 *  设备状态
 *
 *  @param vapor_Activity 设备状态
 */
typedef void (^BLEServiceDeviceActivity)(int vapor_Activity);
@property(nonatomic,copy) BLEServiceDeviceActivity Service_Activity;

/**
 *  中心角色
 */
@property (strong,nonatomic) CBCentralManager *centralManager;

/**
 *  设备数据
 */
@property(nonatomic,retain) STW_BLEDevice *device;

/**
 *  蓝牙全局方法
 *
 *  @return 静态方法
 */
+(STW_BLEService *)sharedInstance;

/**
 *  开始扫描蓝牙
 */
-(void)scanStart;

/**
 *  停止扫描蓝牙
 */
-(void)scanStop;

/**
 *  连接设备
 *
 *  @param device 需要连接设备信息
 */
-(void)connect:(STW_BLEDevice *)device;

/**
 *  主动断开当前连接的蓝牙设备
 */
-(void)disconnect;

/**
 *  向从机发送数据
 *
 *  @param data 需要发送的数据
 */
-(void)sendData:(NSData *)data;

/**
 *  向从机发送大数据
 *
 *  @param data 需要发送的数据
 */
-(void)sendBigData:(NSData *)data :(int)type;

@end

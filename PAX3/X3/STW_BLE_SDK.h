//
//  STW_BLE_SDK.h
//  STW_BLE_SDK
//
//  Created by tyz on 17/2/24.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class STW_BLE_Device;
@class STW_BLE_Model;


//温度类型
typedef NS_ENUM(NSInteger, BLEProtocolTemperatureUnit)
{
    BLEProtocolTemperatureUnitCelsius = 0x00,      //摄氏度
    BLEProtocolTemperatureUnitFahrenheit = 0x01    //华氏度
};

//电子烟开关机
typedef NS_ENUM(NSInteger, BootStatus)
{
    BootStatusSleep = 0x00,       //关机
    BootStatusActivity = 0x01,    //开机
};

//工作模式
typedef NS_ENUM(NSInteger, BLEProtocolModeType){
    BLEProtocolModeTypeStandard = 0x00,  //Standard模式
    BLEProtocolModeTypeBoost = 0x01,     //Boost模式
    BLEProtocolModeTypeEfficency = 0x02, //Efficency模式
    BLEProtocolModeTypeSteath = 0x03,    //Steath模式
    BLEProtocolModeTypeFlavor = 0x04,    //Flavor模式
    BLEProtocolModeTypeFD = 0xFD         //查询当前模式
};

//游戏模式
typedef NS_ENUM(NSInteger, BLEGameModeType){
    BLEGameModeTypeNO = 0x00,              //关闭游戏
    BLEGameModeTypePaxMan = 0x01,          //猫捉老鼠
    BLEGameModeTypeSimon = 0x02,           //跟着走
    BLEGameModeTypeAplinThePax = 0x03,     //随机
    BLEGameModeTypeFD = 0xFD,              //查询当前游戏模式
};

//亮灯模式
typedef NS_ENUM(NSInteger, BLELampModeType){
    BLELampModeTypeWhite = 0x00,              //白色
    BLELampModeTypeBlue = 0x01,               //蓝色
    BLELampModeTypeYellow = 0x02,             //黄色
    BLELampModeTypeRed = 0x03,                //红色
    BLELampModeTypeFD = 0xFD,                 //查询当前颜色模式
};

typedef NS_ENUM(NSInteger, STW_isBLEType)
{
    STW_BLE_IsBLETypeOff = 0x01,      //断开
    STW_BLE_IsBLETypeOn = 0x02,       //连接
    STW_BLE_IsBLETypeLoding = 0x03,   //等待重连
    STW_BLE_IsBLEUpdateNow = 0x04,    //正在OAD升级
};

@interface STW_BLE_SDK : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma STW BLE SDK 查询/设置接口定义
/************************ *STW BLE SDK 查询/设置接口定义 ******************************/
/**
 1.开始扫描电子烟
 *在5秒钟之内没有连，SDK会自动停止扫描,以免资源浪费.
 */
-(void)scanStart;

/**
 2.结束扫描电子烟
 */
-(void)scanStop;

/**
 3.连接蓝牙 - 需要携带
 @param device 扫描到的蓝牙设备
 */
-(void)connect:(STW_BLE_Device *)device;

/**
 4.断开蓝牙连接
 */
-(void)disconnect;

/**
 5.查询电池电量 - 电量百分比
 */
-(void)the_find_battery;

/**
 6.查询当前所有信息
 */
-(void)the_work_mode;

/**
 7.查询设置烤烟发热杯最高温度
 @param temp_mode 温度模式
 @param temp 温度值
 */
-(void)the_work_temp_max:(BLEProtocolTemperatureUnit)temp_mode :(int)temp;

/**
 8.设置电子烟开关机状态
 @param boot 开关机
 */
-(void)the_boot_bool:(BootStatus)boot;

/**
 9.设置温度模式
 @param temp_mode 温度类型 - 华氏度 - 摄氏度
 */
-(void)the_work_mode_temp:(BLEProtocolTemperatureUnit)temp_mode;

/**
 10.设置系统时间 - 需要向电子烟同步时间的时候使用（SDK已经进行同步，APP开发人员不需要进行操作）
 */
-(void)the_set_time;

/*
 11.设置电子烟名称
 @param deviceName 电子烟名称  (1 - 16字节，过长部分自动裁剪)
 */
-(void)the_set_device_name:(NSString *)deviceName;


/**
 12.设置、查询游戏模式
 @param gameModel 游戏模式 - 查询游戏模式 0xFD
 */
-(void)the_set_game_model:(BLEGameModeType)gameModel;

/**
 13.设置、查询加热模式
 */
-(void)the_work_mode_setting:(BLEProtocolModeType)work_model;

/**
 14.设置、查询亮灯模式
 */
-(void)the_lamp_mode:(BLELampModeType)lamp_model;

/**
 15.亮度百分比设置
 @param brightness_value 亮度 - 0xFD 查询当前亮度
 */
-(void)the_brightness:(int)brightness_value;

/**
 16.马达强度百分比设置
 @param motor_value 强度 - 0xFD 查询当前马达震动强度
 */
-(void)the_motor:(int)motor_value;

/**
 机身颜色设置、查询
 @param pax_color 机身颜色 - 0xFD 查询当前机身颜色
 */
-(void)the_pax_color:(int)pax_color;

/**
 17.查询硬件信息（返回思拓微设备唯一编号，通过思拓微数据库查询硬件设备的信息）
 */
-(void)the_Find_deviceData;

/**
 18.OAD升级
 @param BinDataFromBinFile Bin文件数据
 @param softVersion 软件版本 - 通过思拓微数据库查询
 @param deviceVersion 硬件版本 - 通过思拓微数据库查询
 */
-(void)send_OAD_File:(NSData *) BinDataFromBinFile :(NSString *)softVersion :(NSString *)deviceVersion;

/**
 19.停止OAD升级
 */
-(void)stop_OAD;

#pragma STW BLE SDK 数据实时接收定义
/************************ *STW BLE SDK 数据实时接收定义 ******************************/
/**
 1.返回扫描到的蓝牙设备
 @param device 蓝牙设备对象
 */
typedef void (^BLEServiceScanHandler)(STW_BLE_Device *device);
@property(nonatomic,copy) BLEServiceScanHandler BLEServiceScanHandler;

/**
 2.返回蓝牙正式连接成功信息
 */
typedef void (^BLEServiceDiscoverCharacteristicsForServiceHandler)(int deviceColor);
@property(nonatomic,copy) BLEServiceDiscoverCharacteristicsForServiceHandler BLEServiceDiscoverCharacteristicsForServiceHandler;

/**
 3.返回蓝牙断开连接的信息
 */
typedef void (^BLEServiceDisconnectHandler)(void);
@property(nonatomic,copy) BLEServiceDisconnectHandler BLEServiceDisconnectHandler;

//加热模式
typedef void (^BLEServiceWorkModel)(BLEProtocolModeType model_value);
@property(nonatomic,copy) BLEServiceWorkModel BLEServiceWorkModel;

//温度模式
typedef void (^BLEServiceTempModel)(BLEProtocolTemperatureUnit temp_model);
@property(nonatomic,copy) BLEServiceTempModel BLEServiceTempModel;

//发热杯最高温度
typedef void (^BLEServiceTempMax)(int temp_model,int temp_value);
@property(nonatomic,copy) BLEServiceTempMax BLEServiceTempMax;

//发热杯当前温度
typedef void (^BLEServiceTempNow)(int temp_model,int temp_value);
@property(nonatomic,copy) BLEServiceTempNow BLEServiceTempNow;

//亮灯的颜色模式
typedef void (^BLEServiceLampModel)(int LampModel);
@property(nonatomic,copy) BLEServiceLampModel BLEServiceLampModel;

//亮度百分比
typedef void (^BLEServicebBrightness)(int brightness_value);
@property(nonatomic,copy) BLEServicebBrightness BLEServicebBrightness;

//游戏模式
typedef void (^BLEServiceGameModel)(int game_model);
@property(nonatomic,copy) BLEServiceGameModel BLEServiceGameModel;

//开关机信息
typedef void (^BLEServiceDeviceRoot)(BootStatus Root);
@property(nonatomic,copy) BLEServiceDeviceRoot BLEServiceDeviceRoot;

//震动强度百分比
typedef void (^BLEServiceVibration)(int vibration);
@property(nonatomic,copy) BLEServiceVibration BLEServiceVibration;

//机身颜色
typedef void (^BLEServicePaxColor)(int pax_color);
@property(nonatomic,copy) BLEServicePaxColor BLEServicePaxColor;

//返回所有配置信息
typedef void (^BLEServiceAllDatas)(int work_model,int tmp_model,int tmp_max,int tmp_now,int lamp_model,int brightness_value,int game_model,int boot_status,int vibration_value,int pax_color,int pax_battery);
@property(nonatomic,copy) BLEServiceAllDatas BLEServiceAllDatas;

//返回电池电量信息
typedef void (^BLEServiceDeviceBattery)(int battery_status,int battery);
@property(nonatomic,copy) BLEServiceDeviceBattery BLEServiceDeviceBattery;

/**
 设置设备名称是否成功 0x00 - 接收成功  0x01 校验错误 0xEE 其他错误
*/
typedef void (^BLEServiceDeviceName)(int num);
@property(nonatomic,copy) BLEServiceDeviceName BLEServiceDeviceName;

/**
 15.获取设备硬件软件版本信息
 @param Device_Version 硬件版本
 @param Soft_Version 软件版本
 */
typedef void (^BLEServiceFine_DeviceData)(int Device_Version,int Soft_Version);
@property(nonatomic,copy) BLEServiceFine_DeviceData BLEServiceFine_DeviceData;

/**
 16.OAD升级进度
 */
typedef void (^BLEServiceOADProgress)(int stw_oad_progress,int oad_status);
@property(nonatomic,copy) BLEServiceOADProgress BLEServiceOADProgress;

/**
 *  中心角色
 */
@property (nonatomic,strong) CBCentralManager *centralManager;

/**
 *  扫描到的设备列表
 */
@property(nonatomic,strong) NSMutableArray *scanedDevices;

/**
 *  已经绑定的设备列表
 */
@property(nonatomic,strong) NSMutableArray *bindingDevices;

/**
 *  连接的设备
 */
@property(nonatomic,retain) STW_BLE_Device *device;

/**
 *  连接设备的信息
 */
@property(nonatomic,retain) STW_BLE_Model *deviceData;

//BLE - 状态
@property(nonatomic,assign)STW_isBLEType stw_isBLEType;

//BLE - 温度单位
@property(nonatomic,assign)int STW_BLE_Temp_model;

//蓝牙是否可用
@property(nonatomic,assign)BOOL BLE_Status;

/**
 初始化STW_BLE_SDK
 此方法需要在APP加载的时候进行初始化，有且仅一次
 */
-(Boolean)STW_BLE_SDK_init;

/**
 *  蓝牙全局方法
 *  @return 静态方法 - 蓝牙单例
 */
+(STW_BLE_SDK *)sharedInstance;

@end

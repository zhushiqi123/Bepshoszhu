//
//  TYZ_BLE_Protocol.h
//
//  Created by 田阳柱 on 16/7/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEData : NSObject

//--0x01--吸烟记录设置
@property (nonatomic,assign) int smoke_bools;          //吸烟口数记录使能 0:false  1:true
@property (nonatomic,assign) int smoke_expect;         //吸烟口预设数值 1 ~ 30
@property (nonatomic,assign) int smoke_actual;         //吸烟口数实际值 0 ~ 255

//--0x02--输出电压设置
@property (nonatomic,assign) int output_voltage;       //输出电压 3.2V ~ 4.2V (32 - 42)

//--0x03--电池管理
@property (nonatomic,assign) int battery;              //电池电压 0V ~ 4.2V (0 - 42)
@property (nonatomic,assign) int battery_status;       //电池状态 0:正常 1:充电 2:充满

//--0x04--吸烟口数管理
@property (nonatomic,assign) int smoke_all_number;     //吸烟总口数 (0x2075 = 8309)

//--0x05--开锁机设置
@property (nonatomic,assign) int lock;                 //开锁机状态 0:开机 1:锁机
@property (nonatomic,assign) int lock_way;             //锁机方式 0:蓝牙锁机 1:按键锁机

//--0x06--抽烟记录
@property (nonatomic,strong) NSMutableArray *record_arry; //吸烟记录数组

-(void)setData:(BLEData *)data;

@end

@interface TYZ_BLE_Protocol : NSObject

/**
 *  接受数据命令类型
 *  @param intValue 接受命令的类型
 */
@property(nonatomic,assign)  int intValue;

/**
 *  数据部分第1位
 *  @param bleData_byte1
 */
@property(nonatomic,assign)  int bleData_byte1;

/**
 *  数据部分第2位
 *  @param bleData_byte2
 */
@property(nonatomic,assign)  int bleData_byte2;

/**
 *  数据部分第3位
 *  @param bleData_byte3
 */
@property(nonatomic,assign)  int bleData_byte3;

/**
 *  获取数据 - get Data
 */
+(TYZ_BLE_Protocol *)initdata:(NSData *)data;

/**
 *  初始查询 - initial query
 */
+(void)initial_query;

/**
 *  发送数据命令D1
 *  预设口数
 *  @param num 发送的数据
 *
 *  num = 0xFF: 设备关闭吸烟口数功能。
 *  num = 0x(01~1E): 开启功能并置预设值。
 *  num = 0x00: 清吸烟计数值。
 *  num = 0xF0: 查询实际口数及预设值
 */
+(void)sendData_D1:(int)num;

/**
 *  发送数据命令D2
 *
 *  设置输出电压
 *
 *  @param num 发送的数据
 *
 *  num = 3.2V ~ 4.2V
 */
+(void)sendData_D2:(int)num;

/**
 *  发送数据命令D3
 *
 *  电量查询命令
 *
 *  40 03 00 00 00 FC 0D 0A 代表查询电池电量
 */
+(void)sendData_D3;

/**
 *  发送数据命令D4
 *
 *  吸烟口数清零/查询当前口数
 *
 *  num = 0x00  清除当前口数
 *  num = 0x01  查询当前口数
 */
+(void)sendData_D4:(int) num;

/**
 *  发送数据命令D5
 *
 *  蓝牙开锁机
 *
 *  @param num 0 开机  1 锁机
 */
+(void)sendData_D5:(int)num;

/**
 *  发送数据命令D5
 *
 *  设置电子烟时间
 *
 *  D2年高位 D3年低位 D4月 D5日 D6时 D7分 D8秒
 */
+(void)sendData_D6;

/**
 *  发送数据命令D7
 *
 *  读取历史数据
 *
 *  40 07 00 00 00 xx 0d 0a
 */
+(void)sendData_D7;

/**
 *  发送数据命令D8
 *
 *  修改设备名称
 *
 *  @param string 输入的设备名称
 */
+(void)sendData_D8:(NSString *)string;

/**
 *  查询设备唯一ID
 */
+(void)sendData_D9;

/**
 *  解析蓝牙数据
 *
 *  @param data 解析的数据
 */
-(void)parse_ble_data:(NSData *)data;

+(NSData *)getDatastr:(NSString *)str;

@end

//
//  STW_BLE_Protocol.h
//  STW_BLE_SDK
//
//  Created by 田阳柱 on 16/8/29.
//  Copyright © 2016年 tyz. All rights reserved.
//
//取得32位var数据中（ByteNum）字节数据 ByteNum ->0~3   3为最高位字节  0为最低位字节
#define BREAK_UINT32( var, ByteNum ) \
(uint8_t)((uint32_t)(((var) >>((ByteNum) * 8)) & 0x00FF))

//4个字节整合为32位数据
#define BUILD_UINT32(Byte0, Byte1, Byte2, Byte3) \
((uint32_t)((uint32_t)((Byte0) & 0x00FF) \
+ ((uint32_t)((Byte1) & 0x00FF) << 8) \
+ ((uint32_t)((Byte2) & 0x00FF) << 16) \
+ ((uint32_t)((Byte3) & 0x00FF) << 24)))

//两个字节转化为16位数据 hiByte 为16位高位 loByte 为16位低
#define BUILD_UINT16(hiByte, loByte)\
((uint16)(((loByte) & 0x00FF) + (((hiByte) & 0x00FF) << 8)))

//两个字节转换为8进制
#define BUILD_UINT8(hiByte, loByte) \
((Byte)(((loByte) & 0x0F) + (((hiByte) & 0x0F) << 4)))

//16进制数据提取高位字节
#define HI_UINT16(a) (((a) >> 8) & 0xFF)
//16进制数据提取低位字节
#define LO_UINT16(a) ((a) & 0xFF)

#import <Foundation/Foundation.h>

@interface STW_BLE_Protocol : NSObject

/**
 *  0x00 匹配蓝牙是否已经连接
 */
+(void)the_check_device:(int)deviceType;

/**
 *  0x01 查询所有配置信息
 */
+(void)the_find_all_data;

/*
 *  0x02 设置系统时间
 */
+(void)the_set_time;

/**
 *  0x03 查询工作模式
 */
+(void)the_find_work_mode;

/**
 *  0x03 设置工作模式
 *
 *  @param workModel     工作模式
 *  @param work_nums     温度 / 功率数值
 *  @param workType      温度模式单位 - 功率 0x00
 *  @param Atomizer_mode 雾化器类型 - 功率 0x00
 */
+(void)the_set_work_mode:(int)workModel :(int)work_nums :(int)workType :(int)Atomizer_mode;

/**
 *  0x04 查询TCR设置
 */
+(void)the_find_atomizer;

/**
 *  0x04 设置TCR信息
 *
 *  @param ChangeRate_Ni  Ni的变化率
 *  @param ChangeRate_Ss  Ss变化率
 *  @param ChangeRate_Ti  Ti的变化率
 *  @param ChangeRate_TCR TCR的变化率
 */
+(void)the_set_atomizer:(int)ChangeRate_Ni :(int) ChangeRate_Ss :(int) ChangeRate_Ti :(int) ChangeRate_TCR;

/**
 *  0x05 查询电池电量
 */
+(void)the_find_Battery;

/**
 *  0x06 传输雾化器阻值
 *  由电子烟主动发送
 */

/**
 *  0x07 查询CCT数据
 */
+(void)the_find_CCTData;

/**
 *  0x07 设置CCT数据
 */
+(void)the_set_CCTData:(NSMutableArray *)cctArrys;

/**
 *  0x08 查询按键锁机次数
 */
+(void)the_find_keyNum;

/**
 *  0x08 设置按键锁机次数
 */
+(void)the_set_keyNum:(int)keyNum;

/**
 *  0x09 传输吸烟状态
 *  由电子烟主动发送
 */

/**
 *  0x09 确认是否是新的雾化器
 *
 *  @param new_old_Atomizer 0x00 - 旧的  0x01 - 新的
 */
+(void)the_set_new_old_Atomizer :(int)new_old_Atomizer;

/**
 *  0x0A 激活电子烟
 */
+(void)the_set_Activity;

/**
 *  0x0B无线升级
 */

/**
 *  0x0C 查询设备硬件设备信息
 */
+(void)the_Find_deviceData;

/**
 *  0x0D 查询雾化器是否被锁定
 */
+(void)the_Find_Atomizer_Lock;

/**
 *  0x0D 锁定、解锁雾化器阻值
 */
+(void)the_Set_Atomizer_Lock:(int) atomizer_lock :(int) atomizer_resistance;

/**
 *  无线升级第一包数据
 */
+(void)the_soft_update_page01:(uint16_t)checkAllNum :(uint16_t)checkAllNum_decryption;

//直接从bin文件中获取数据发送
+(void)the_soft_update_page01_bin:(NSData *)datas;

//升级过程激活命令
+(void)the_update_update_Reply;

/**
 *  自定义命令
 *
 *  @param arrys 自定义命令数据
 */
//+(void)the_Custom_command:(NSArray *)arrys;

/**
 *  NSString - 转换成十六进制数据
 */
+(NSString *)the_nsstring_16:(NSString *)strs;
/**
 *  双个转换 - 转换成十六进制数据
 *
 *  @param strs 需要转换的字符串
 */
+(NSString *)nsstring_16:(NSString *)strs;
/**
 *  单个转换 - 转换成十六进制数据
 *
 *  @param strs 需要转换的字符串
 */
+(int)str_16:(NSString *)strs;

//STM32--CRC32校验
+(uint32_t)check_crc32:(NSData*)data_data :(BOOL)check;
//int类型数据按字节倒叙
+(uint32_t)rev_data:(uint32_t) dat;

//进行CRC16校验
+(uint16_t)CRC16_1:(NSData *)datas;

//进行CRC16帧校验
+(uint16_t)CRC16_page:(NSData *)datas;

//校验文件是否满足68K，补齐68K数据
+(NSData *)check_data_68K:(NSData *)datas;

//解密A5
+(int)decryption_A5:(int)data_a5;

//解密A5
+(NSMutableData *)decryption_A5_NsData:(NSData *)a5_data;

//摄氏度转换为华氏度
+(int)temperatureUnitCelsiusToFahrenheit:(int)celsius;
//华氏度转摄氏度
+(int)temperatureUnitFahrenheitToCelsius:(int)fahrenheit;
@end

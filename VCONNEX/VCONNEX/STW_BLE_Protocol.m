//
//  STW_BLE_Protocol.m
//  STW_BLE_SDK
//
//  Created by 田阳柱 on 16/8/29.
//  Copyright © 2016年 tyz. All rights reserved.
//

#define BINLENG 0xE000

#import "STW_BLE_Protocol.h"
#import "STW_BLEService.h"

@implementation STW_BLE_Protocol
/**
 *  0x00 匹配蓝牙是否已经连接
 */
+(void)the_check_device:(int)deviceType
{
    int checknum = 0xFE ^ deviceType ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand000,0x06,0xFE,deviceType,checknum};
    NSData *datas = [NSData dataWithBytes:c length:6];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x01 查询所有配置信息
 */
+(void)the_find_all_data
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand001,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/*
 *  0x02 设置系统时间
 */
+(void)the_set_time
{
    //获取当前系统的时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *timeString = [dateformatter stringFromDate:senddate];
    
    int year = [[timeString substringToIndex:4] intValue];
    int mouth = [[timeString substringWithRange:NSMakeRange(4,2)] intValue];
    int day = [[timeString substringWithRange:NSMakeRange(6,2)] intValue];
    int h = [[timeString substringWithRange:NSMakeRange(8,2)] intValue];
    int m = [[timeString substringWithRange:NSMakeRange(10,2)] intValue];
    int s = [[timeString substringWithRange:NSMakeRange(12,2)] intValue];
    
    int checknum = (year >> 8) ^ year ^ mouth ^ day ^ h ^  m ^ s;
    
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand002,0x0B,year >> 8,(Byte)year,(Byte)mouth,(Byte)day,(Byte)h,(Byte)m,(Byte)s,(Byte)checknum};
    //发送系统的时间给电子烟
    NSData *datas = [NSData dataWithBytes:c length:11];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x03 查询工作模式
 */
+(void)the_find_work_mode
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand003,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x03 设置工作模式
 *
 *  @param workModel     工作模式
 *  @param work_nums     温度 / 功率数值
 *  @param workType      温度模式单位 - 功率 0x00
 *  @param Atomizer_mode 雾化器类型 - 功率 0x00
 */
+(void)the_set_work_mode:(int)workModel :(int)work_nums :(int)workType :(int)Atomizer_mode
{
    int checknum = 0xFE ^ workModel ^ (work_nums >> 8) ^ work_nums ^ workType ^ Atomizer_mode ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand003,0x0A,0xFE,workModel,(work_nums >> 8),work_nums,workType,Atomizer_mode,checknum};
    NSData *datas = [NSData dataWithBytes:c length:10];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x04 查询TCR设置
 */
+(void)the_find_atomizer
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand004,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x04 设置TCR信息
 *
 *  @param ChangeRate_Ni  Ni的变化率
 *  @param ChangeRate_Ss  Ss变化率
 *  @param ChangeRate_Ti  Ti的变化率
 *  @param ChangeRate_TCR TCR的变化率
 */
+(void)the_set_atomizer:(int)ChangeRate_Ni :(int) ChangeRate_Ss :(int) ChangeRate_Ti :(int) ChangeRate_TCR
{
    int checknum = 0xFE ^ (ChangeRate_Ni >> 8) ^ ChangeRate_Ni ^ (ChangeRate_Ss >> 8)^ ChangeRate_Ss ^ (ChangeRate_Ti >> 8) ^ ChangeRate_Ti ^ (ChangeRate_TCR >> 8)^ ChangeRate_TCR ^ 0xA6;
    
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand004,0x0D,0xFE,(ChangeRate_Ni >> 8),ChangeRate_Ni,(ChangeRate_Ss >> 8),ChangeRate_Ss, (ChangeRate_Ti >> 8),ChangeRate_Ti,(ChangeRate_TCR >> 8),ChangeRate_TCR,checknum};
    
    NSData *datas = [NSData dataWithBytes:c length:13];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x05 查询电池电量
 */
+(void)the_find_Battery
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand005,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x06 传输雾化器阻值
 *  由电子烟主动发送
 */

/**
 *  0x07 查询CCT数据
 */
+(void)the_find_CCTData
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand007,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x07 设置CCT数据
 */
+(void)the_set_CCTData:(NSMutableArray *)cctArrys
{
//    int checknum = 0xFE ^ 0xA6;
//    Byte c[] = {BLEProtocolHeader01,STW_BLECommand007,0x05,0xFF,checknum};
//    NSData *datas = [NSData dataWithBytes:c length:5];
//    [[STW_BLEService sharedInstance] sendData:datas];
    
    unsigned char buf[16];
    
    //帧头
    buf[0] = BLEProtocolHeader01;
    //命令
    buf[1] = STW_BLECommand007;
    //本帧长度
    buf[2] = 16;
    
    buf[3] = 0xFE;
    
    //数据部分字节
    for (int i = 0; i < 11; i++)
    {
        NSString *cctPoint = [cctArrys objectAtIndex:i];
        
        buf[i + 4] = (20 - [cctPoint intValue]) * 10;
    }
    
    //计算校验和
    Byte checknum = 0x00;
    
    for (int i = 0; i < 12; i++)
    {
        checknum = checknum ^ buf[i + 3];
    }
    
    checknum = checknum ^ 0xA6;
    
    buf[15] = checknum;
    
    //向设备发送数据
    NSMutableData *datas = [[NSMutableData alloc] init];
    [datas appendBytes:buf length:(16)];
    
    [[STW_BLEService sharedInstance] sendData:datas];
    
}

/**
 *  0x08 查询按键锁机次数
 */
+(void)the_find_keyNum
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand008,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x08 设置按键锁机次数
 */
+(void)the_set_keyNum:(int)keyNum
{
    int checknum = 0xFE ^ keyNum ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand008,0x06,0xFE,keyNum,checknum};
    NSData *datas = [NSData dataWithBytes:c length:6];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x09 传输吸烟状态
 *  由电子烟主动发送
 */

/**
 *  0x09 确认是否是新的雾化器
 *
 *  @param new_old_Atomizer 0x00 - 旧的  0x01 - 新的
 */
+(void)the_set_new_old_Atomizer :(int)new_old_Atomizer
{
    int checknum = 0xFE^ 0x07 ^ new_old_Atomizer >> 8 ^ new_old_Atomizer ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand009,0x08,0xFE,0x07,new_old_Atomizer >> 8,new_old_Atomizer,checknum};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x0A 激活电子烟
 */
+(void)the_set_Activity
{
    int checknum = 0x00 ^ 0x01 ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand00A,0x06,0x00,0x01,checknum};
    NSData *datas = [NSData dataWithBytes:c length:6];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x0C 查询设备硬件设备信息
 */
+(void)the_Find_deviceData
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand00C,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x0D 查询雾化器是否被锁定
 */
+(void)the_Find_Atomizer_Lock
{
    int checknum = 0xFF ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand00D,0x05,0xFF,checknum};
    NSData *datas = [NSData dataWithBytes:c length:5];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  0x0D 锁定、解锁雾化器阻值
 */
+(void)the_Set_Atomizer_Lock:(int) atomizer_lock :(int) atomizer_resistance
{
    int checknum = 0xFE ^ atomizer_lock ^ atomizer_resistance >> 8 ^ atomizer_resistance ^ 0xA6;
    Byte c[] = {BLEProtocolHeader01,STW_BLECommand00D,0x08,0xFE,atomizer_lock,atomizer_resistance >> 8,atomizer_resistance,checknum};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[STW_BLEService sharedInstance] sendData:datas];
}

/**
 *  无线升级第一包数据
 */
+(void)the_soft_update_page01:(uint16_t)checkAllNum :(uint16_t)checkAllNum_decryption
{
    //    Byte c[] = {0x6D,0x4B,0xff,0xff,0x00,0x00,0x00,0x44,0x45,0x45,0x45,0x45,0x0,0x04,0x01,0xff,0xce,0x2c};
    
    Byte c[] = {checkAllNum_decryption,checkAllNum_decryption>>8,0xff,0xff,0x00,0x00,0x00,0x44,0x45,0x45,0x45,0x45,0x0,0x04,0x01,0xff,0xce,0x2c};
    
    //    Byte c[] = {checkAllNum,checkAllNum>>8,0xff,0xff,0x00,0x00,0x00,0x44,checkAllNum_decryption,checkAllNum_decryption >> 8,0x45,0x45,0x0,0x04,0x01,0xff,0xce,0x2c};
    
    NSData *datas = [NSData dataWithBytes:c length:18];
    
    [[STW_BLEService sharedInstance] sendBigData:datas :0];
}

//直接从bin文件中获取数据发送
+(void)the_soft_update_page01_bin:(NSData *)datas
{
    [[STW_BLEService sharedInstance] sendBigData:datas :0];
}

//升级过程激活命令
+(void)the_update_update_Reply
{
    Byte c1[] = {0x88,0x88,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *datas1 = [NSData dataWithBytes:c1 length:20];
    
    Byte c2[] = {0x88,0x88,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *datas2 = [NSData dataWithBytes:c2 length:20];
    
    [[STW_BLEService sharedInstance] sendBigData:datas1 :0];
    
    double delayInSeconds = 0.01f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [[STW_BLEService sharedInstance] sendBigData:datas2 :1];
                   });
}

/**
 *  NSString 转换成十六进制数据
 */
+(NSString *)the_nsstring_16:(NSString *)strs
{
    NSArray *send_data_arry = [strs componentsSeparatedByString:@","];
    
    NSString *data_str = [STW_BLE_Protocol nsstring_16:send_data_arry[0]];
    
    for (int i = 1; i < send_data_arry.count; i++)
    {
        data_str = [NSString stringWithFormat:@"%@,%@",data_str,[STW_BLE_Protocol nsstring_16:send_data_arry[i]]];
    }
    
    return data_str;
}

//双个转换
+(NSString *)nsstring_16:(NSString *)strs
{
    int num_01 = 0;
    int num_02 = 0;
    int nums = 0;
    
    if(strs.length >= 2)
    {
        num_01 = [STW_BLE_Protocol str_16:[strs substringWithRange:NSMakeRange(0,1)]];
        num_02 = [STW_BLE_Protocol str_16:[strs substringWithRange:NSMakeRange(1,1)]];
        
        nums = (num_01 << 4) + num_02;
    }
    else
    {
        num_01 = [STW_BLE_Protocol str_16:[strs substringWithRange:NSMakeRange(0,1)]];
        nums = num_01;
    }
    
    strs = [NSString stringWithFormat:@"%d",nums];

    return strs;
}

//单个转换
+(int)str_16:(NSString *)strs
{
    int str_num = 0;
    
    if ([strs isEqualToString:@"0"])
    {
        str_num = 0x00;
    }
    else if ([strs isEqualToString:@"1"])
    {
        str_num = 0x01;
    }
    else if ([strs isEqualToString:@"2"])
    {
        str_num = 0x02;
    }
    else if ([strs isEqualToString:@"3"])
    {
        str_num = 0x03;
    }
    else if ([strs isEqualToString:@"4"])
    {
        str_num = 0x04;
    }
    else if ([strs isEqualToString:@"5"])
    {
        str_num = 0x05;
    }
    else if ([strs isEqualToString:@"6"])
    {
        str_num = 0x06;
    }
    else if ([strs isEqualToString:@"7"])
    {
        str_num = 0x07;
    }
    else if ([strs isEqualToString:@"8"])
    {
        str_num = 0x08;
    }
    else if ([strs isEqualToString:@"9"])
    {
        str_num = 0x09;
    }
    else if ([strs isEqualToString:@"A"])
    {
        str_num = 0x0A;
    }
    else if ([strs isEqualToString:@"B"])
    {
        str_num = 0x0B;
    }
    else if ([strs isEqualToString:@"C"])
    {
        str_num = 0x0C;
    }
    else if ([strs isEqualToString:@"D"])
    {
        str_num = 0x0D;
    }
    else if ([strs isEqualToString:@"E"])
    {
        str_num = 0x0E;
    }
    else if ([strs isEqualToString:@"F"])
    {
        str_num = 0x0F;
    }
    
    return str_num;
}

//STM32--CRC32校验
+(uint32_t)check_crc32:(NSData*) data_data :(BOOL) check
{
    uint32_t len = (int)data_data.length/4;
    
    uint32_t crc[len];
    
    [data_data getBytes:&crc length: sizeof(crc)];
    
    uint32_t *ptr = crc;
    
    uint32_t xbit = 0;
    uint32_t data = 0;
    uint32_t CRC11 = 0xFFFFFFFF;    // init
    
    while(len--)
    {
        xbit = 1 << 31;
        
        if (check) {
            data = [STW_BLE_Protocol rev_data:*ptr++];
        }
        else
        {
            data = *ptr++;
        }
        
        for(int bits = 0; bits < 32; bits++)
        {
            if (CRC11 & 0x80000000)
            {
                CRC11 <<= 1;
                CRC11 ^= 0x04c11db7;
            }
            else
                CRC11 <<= 1;
            if (data & xbit)
                CRC11 ^= 0x04c11db7;
            
            xbit >>= 1;
        }
    }
    return CRC11;
}

//int类型数据按字节倒叙
+(uint32_t)rev_data:(uint32_t) dat
{
    uint32_t rev_dat = 0;
    
    rev_dat = BUILD_UINT32(BREAK_UINT32(dat,3),BREAK_UINT32(dat,2),BREAK_UINT32(dat,1),BREAK_UINT32(dat,0));
    
    return rev_dat;
}

//进行CRC16校验
+(uint16_t)CRC16_1:(NSData *)datas
{
    int wDataLen = (int)datas.length;
    
    uint16_t CRC_16 = 0;
    
    const unsigned char* bytes_datas = [datas bytes];
    
    for (int i = 4; i < wDataLen; i++)
    {
        //        NSLog(@"bytes_datas - %d - %d - CRC_16 - %d",i,bytes_datas[i],CRC_16);
        CRC_16 = crc16(CRC_16, bytes_datas[i]);
    }
    
    CRC_16 = crc16(CRC_16,0);
    CRC_16 = crc16(CRC_16,0);
    
    return CRC_16;
}

//进行CRC16帧校验
+(uint16_t)CRC16_page:(NSData *)datas
{
    int wDataLen = (int)datas.length;
    
    uint16_t CRC_16 = 0;
    
    const unsigned char* bytes_datas = [datas bytes];
    
    for (int i = 0; i < wDataLen; i++)
    {
        //        NSLog(@"bytes_datas - %d - %d - CRC_16 - %d",i,bytes_datas[i],CRC_16);
        CRC_16 = crc16(CRC_16, bytes_datas[i]);
    }
    
    return CRC_16;
}

static uint16_t crc16(uint16_t crc, uint8_t val)
{
    const uint16_t poly = 0x1021;
    uint8_t cnt;
    
    for (cnt = 0; cnt < 8; cnt++, val <<= 1)
    {
        uint8_t msb = (crc & 0x8000) ? 1 : 0;
        
        crc <<= 1;
        
        if (val & 0x80)
        {
            crc |= 0x0001;
        }
        
        if (msb)
        {
            crc ^= poly;
        }
    }
    
    return crc;
}

//校验文件是否满足56K，补齐56K数据
+(NSData *)check_data_68K:(NSData *)datas
{
    int lengs = (int)datas.length;
    
    const unsigned char* bytes_datas = [datas bytes];
    
    Byte buf[BINLENG];
    
    for (int i = 0;i < lengs; i++)
    {
        buf[i] = bytes_datas[i];
    }
    
    if (lengs < BINLENG)
    {
        for (int i = lengs;i < BINLENG; i++)
        {
            buf[i] = 0xFF;
        }
    }
    
    NSMutableData *datas_ns = [[NSMutableData alloc] init];
    [datas_ns appendBytes:buf length:(BINLENG)];
    
    return datas_ns;
}

//解密A5
+(int)decryption_A5:(int)data_a5
{
    int num;
    if (data_a5 != 0xFF && data_a5 != 0x00 && data_a5 != 0xA5 && data_a5 != 0x5A)
    {
        num = data_a5 ^ 0xA5;
    }
    else
    {
        num = data_a5;
    }
    return num;
}

//解密A5
+(NSMutableData *)decryption_A5_NsData:(NSData *)a5_data
{
    int lengs = (int)a5_data.length;
    
    const unsigned char* bytes_datas = [a5_data bytes];
    
    Byte buf[lengs];
    
    for (int i = 0;i < lengs; i++)
    {
        buf[i] = [STW_BLE_Protocol decryption_A5:bytes_datas[i]];
    }
    
    NSMutableData *datas_ns = [[NSMutableData alloc] init];
    [datas_ns appendBytes:buf length:(lengs)];
    
    return datas_ns;
}

+(int)temperatureUnitCelsiusToFahrenheit:(int)celsius
{
    float cel = celsius * 9.0f/5.0f + 32.0f;       //摄氏度转换为华氏度
    return cel;
}

+(int)temperatureUnitFahrenheitToCelsius:(int)fahrenheit
{
    float cel =5.0f/9.0f*(fahrenheit - 32.0f);    //华氏度转摄氏度
    return cel;
}

@end

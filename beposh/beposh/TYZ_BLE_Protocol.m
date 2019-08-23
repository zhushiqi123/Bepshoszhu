//
//  TYZ_BLE_Protocol.m
//
//  Created by 田阳柱 on 16/7/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TYZ_BLE_Protocol.h"
#import "TYZ_BLE_Service.h"

//协议命令
typedef NS_ENUM(NSInteger, BLEProtocolCommand)
{
    BLEProtocolCommand00 = 0x00,         //初始查询
    BLEProtocolCommand01 = 0x01,         //预设吸烟口数命令
    BLEProtocolCommand02 = 0x02,         //输出电压命令
    BLEProtocolCommand03 = 0x03,         //电池电量&充电显示
    BLEProtocolCommand04 = 0x04,         //当前口数
    BLEProtocolCommand05 = 0x05,         //开锁机
    BLEProtocolCommand06 = 0x06,         //设置时间
    BLEProtocolCommand07 = 0x07,         //读取历史数据
    BLEProtocolCommand08 = 0x08,         //修改设备名称
    BLEProtocolCommand09 = 0x09,         //查询设备唯一ID
};

@implementation BLEData

-(void)setData:(BLEData *)data
{
    self.smoke_bools = data.smoke_bools;
    self.smoke_actual = data.smoke_actual;
    self.smoke_actual = data.smoke_actual;
    self.output_voltage = data.output_voltage;
    self.battery = data.battery;
    self.battery_status = data.battery_status;
    self.smoke_all_number = data.smoke_all_number;
    self.lock = data.lock;
    self.lock_way = data.lock_way;
}

@end

@implementation TYZ_BLE_Protocol

+(TYZ_BLE_Protocol *)initdata:(NSData *)data
{
    TYZ_BLE_Protocol *ble_object = [[TYZ_BLE_Protocol alloc] init];
    [ble_object parse_ble_data:data];
    return ble_object;
}

//初始查询
+(void)initial_query
{
    int checknum = ~(BLEProtocolCommand00+0x00+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand00,0x00,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}


/**
 *  发送数据命令D1
 *
 *  @param num 发送的数据
 *
 *  num = 0xFF: 设备关闭吸烟口数功能。
 *  num = 0x(01~1E): 开启功能并置预设值。
 *  num = 0x00: 清吸烟计数值。
 *  num = 0xF0: 查询实际口数及预设值
 */
+(void)sendData_D1:(int)num
{
    int checknum = ~(BLEProtocolCommand01+num+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand01,num,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D2
 *
 *  @param num 发送的数据
 *
 *  num = 3.2V ~ 4.2V
 */
+(void)sendData_D2:(int)num
{
    int checknum = ~(BLEProtocolCommand02+num+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand02,num,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D3
 *
 *  电量查询命令
 */
+(void)sendData_D3
{
    NSLog(@"查询电池电量");
    int checknum = ~(BLEProtocolCommand03+0x00+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand03,0x00,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}


/**
 *  发送数据命令D4
 *
 *  吸烟口数清零
 *
 *  num = 0x00  清除当前口数
 *  num = 0x01  查询当前口数
 */
+(void)sendData_D4:(int) num
{
    int checknum = ~(BLEProtocolCommand04+num+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand04,num,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D5
 *
 *  蓝牙开锁机
 *
 *  @param num 0 开机  1 锁机
 */
+(void)sendData_D5:(int)num
{
    int checknum = ~(BLEProtocolCommand05+num+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand05,num,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D5
 *
 *  设置电子烟时间
 *
 *  D2年高位 D3年低位 D4月 D5日 D6时 D7分 D8秒
 */
+(void)sendData_D6
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
    
    int checknum = ~(BLEProtocolCommand06+(year >> 8) + year + mouth + day + h + m + s);
    
    Byte c[] = {0x40,BLEProtocolCommand06,year >> 8,(Byte)year,(Byte)mouth,(Byte)day,(Byte)h,(Byte)m,(Byte)s,(Byte)checknum,(Byte)0x0D,(Byte)0x0A};
    //发送系统的时间给电子烟
    NSData *datas = [NSData dataWithBytes:c length:12];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D7
 *
 *  读取历史数据
 *
 *  40 07 00 00 00 xx 0d 0a
 */
+(void)sendData_D7
{
    int checknum = ~(BLEProtocolCommand07+0x00+0x00+0x00);
    Byte c[] = {0x40,BLEProtocolCommand07,0x00,0x00,0x00,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:8];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  发送数据命令D8
 *
 *  修改设备名称
 *
 *  @param string 输入的设备名称
 */
+(void)sendData_D8:(NSString *)string
{
    //将字符转换成ASII码
    NSData *nameData = [TYZ_BLE_Protocol getDatastr:string];
    Byte *NumeStrs = (Byte *)[nameData bytes];
    //组装数据发送给电子烟
    int len_num = NumeStrs[0];
    
    unsigned char buf[20];
    
    //帧头
    buf[0] = 0x40;
    
    //命令
    buf[1] = BLEProtocolCommand08;
    
    if(len_num > 15)
    {
        len_num = 15;
    }
    
    for (int i = 2; i < len_num + 2; i++)
    {
        buf[i] = NumeStrs[(i-2)+1];
    }
    
    //不足十五位补全空格
    for (int i = len_num + 2 ; i < 15 + 2; i++)
    {
        buf[i] = 0x00;
    }
    
    Byte check_num = 0;
    
    for (int i = 1; i < 17; i++)
    {
//        NSLog(@"iii - >%d",i);
        check_num +=  buf[i];
    }
    
    //校验位
    buf[17] = ~check_num;
    //帧尾
    buf[18] = 0x0D;
    buf[19] = 0x0A;
    //向设备发送数据
    NSMutableData *datas = [[NSMutableData alloc] init];
    [datas appendBytes:buf length:20];
    
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

+(void)sendData_D9_ID:(NSString *)string
{
    //将字符转换成ASII码
    NSData *nameData = [TYZ_BLE_Protocol getDatastr:string];
    
    NSLog(@"nameData - %@",nameData);
    
    Byte *NumeStrs = (Byte *)[nameData bytes];
    //组装数据发送给电子烟
    int len_num = NumeStrs[0];
    
    unsigned char buf[18];
    
    //帧头
    buf[0] = 0x40;
    
    //命令
    buf[1] = BLEProtocolCommand09;
    
    buf[2] = 0xFE;
    
    if(len_num > 14)
    {
        len_num = 14;
    }
    
    for (int i = 3; i < len_num + 3; i++)
    {
        buf[i] = NumeStrs[i-2];
    }
    
    Byte check_num = 0;
    
    for (int i = 1; i < 17; i++)
    {
        //        NSLog(@"iii - >%d",i);
        check_num +=  buf[i];
    }
    
    //校验位
    buf[17] = ~check_num;

    //向设备发送数据
    NSMutableData *datas = [[NSMutableData alloc] init];
    [datas appendBytes:buf length:18];
    
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

/**
 *  查询设备唯一ID
 */
+(void)sendData_D9
{
    int checknum = ~(BLEProtocolCommand09+0xFF);
    Byte c[] = {0x40,BLEProtocolCommand09,0xFF,checknum,0x0D,0x0A};
    NSData *datas = [NSData dataWithBytes:c length:6];
    [[TYZ_BLE_Service sharedInstance] sendData:datas];
}

-(void)parse_ble_data:(NSData *)data
{
    const unsigned char* bytes = [data bytes];
    switch (bytes[1])
    {
        case BLEProtocolCommand00:
            self.intValue = BLEProtocolCommand00;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        case BLEProtocolCommand01:
            self.intValue = BLEProtocolCommand01;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        case BLEProtocolCommand02:
            self.intValue = BLEProtocolCommand02;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        case BLEProtocolCommand03:
            self.intValue = BLEProtocolCommand03;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        case BLEProtocolCommand04:
            self.intValue = BLEProtocolCommand04;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        case BLEProtocolCommand05:
            self.intValue = BLEProtocolCommand05;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        //设置时间
        case BLEProtocolCommand06:
            self.intValue = BLEProtocolCommand06;
            self.bleData_byte1 = bytes[2];
            self.bleData_byte2 = bytes[3];
            self.bleData_byte3 = bytes[4];
            break;
        default:
            break;
    }
}

//组装设备名字的数据
+(NSData *)getDatastr:(NSString *)str
{
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    int length = (int)data.length;
    NSMutableData *newData = [NSMutableData data];
    Byte byte[] = {length};
    NSData *sizeData = [[NSData alloc] initWithBytes:byte length:1];
    [newData appendData:sizeData];
    [newData appendData:data];
    return newData;
}

@end

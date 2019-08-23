//
//  STW_BLE_SDK.m
//  STW_BLE_SDK
//
//  Created by tyz on 17/2/24.
//  Copyright © 2017年 tyz. All rights reserved.
//

//厂商ID
#define VendorId 0x11   //0x11 - 奥德

//厂商编号
#define VendorId_01 'S'
#define VendorId_02 'T'
#define VendorId_03 'W'

#define STSRTDRESS 0xA0
#define PAGE01BIN 0x60

//bin文件数据长度 - 需要从配置文件中读取
#define BINLENG 0x11000

#import "STW_BLE_SDK.h"
#import "STW_BLE_Device.h"
#import "STW_BLE_Model.h"

//service的UUID
NSString * const UUIDDeviceService = @"7AAC6AC0-AFCA-11E1-9FEB-0002A5D5C51B";
//update_service的UUID
NSString * const UUIDDeviceUpdateSoftService = @"F000FFC0-0451-4000-B000-000000000000";

//设备名称UUID（只用于修改设备名称）
NSString * const UUIDDeviceName = @"51e6e800-afc9-11e1-9103-0002a5d5c51b";
//从机发送命令UUID
NSString * const UUIDDeviceData = @"aed04e80-afc9-11e1-a484-0002a5d5c51b";
//主机发送命令UUID
NSString * const UUIDDeviceSetup = @"19575ba0-b20d-11e1-b0a5-0002a5d5c51b";

//发送soft Update第一包数据
NSString * const UUIDDeviceSoftUpdatePage01 = @"F000FFC1-0451-4000-B000-000000000000";
//发送soft Update bin文件数据
NSString * const UUIDDeviceSoftUpdateBinPage = @"F000FFC2-0451-4000-B000-000000000000";

/*-------------------------------------     全局宏定义     ----------------------------------*/
//数据包头
typedef NS_ENUM(NSInteger, BLEProtocolHeader)
{
    BLEProtocolHeader01 = 0xa8
};

//设备型号
typedef NS_ENUM(NSInteger, BLEDerviceModel)
{
    BLEDerviceModelSTW01 = 0x0A, //烤烟
    BLEDerviceModelSTW02 = 0x0B
};

//设备是否处于休眠状态
typedef NS_ENUM(NSInteger, BLEProtocolSleep)
{
    BLEProtocolDriveActivity = 0x00,    //活跃
    BLEProtocolDriveSleep = 0x01,       //睡眠
};

typedef NS_ENUM(NSInteger, STW_BLECommand)
{
    STW_BLECommand001 = 0x01,           //查询烤烟发热杯温度
    STW_BLECommand002 = 0x02,           //设置、查询烤烟加热杯最高温度
    STW_BLECommand003 = 0x03,           //发送电池电量
    STW_BLECommand004 = 0x04,           //开关机
    STW_BLECommand005 = 0x05,           //设置温度模式
    STW_BLECommand006 = 0x06,           //传输当前时间
    STW_BLECommand007 = 0x07,           //设置电子烟名称
    STW_BLECommand008 = 0x08,           //游戏模式
    STW_BLECommand009 = 0x09,           //加热模式
    STW_BLECommand00A = 0x0A,           //亮灯的颜色模式
    STW_BLECommand00B = 0x0B,           //亮度设置
    STW_BLECommand00C = 0x0C,           //马达震动强度设置
    STW_BLECommand00D = 0x0D,           //机身颜色
    STW_BLECommand00E = 0x0E,           //激活设备
    STW_BLECommand00F = 0x0F,           //查询全部信息
    STW_BLECommand01E = 0x1E,           //设备信息查询
    STW_BLECommand01F = 0x1F,           //OAD升级
};

@interface STW_BLE_SDK()
{
    CBCharacteristic *characateristicDeviename;
    CBCharacteristic *characateristicSoftUpdatePage01;
    CBCharacteristic *characateristicSoftUpdateBinPage;
    //蓝牙是否处于连接状态
    BOOL isBLEStatus;
    
    //当前传输的OAD数据掉包
    NSMutableArray *softUpdate_lostPage;
    //是否正在进行OAD升级
    int Update_Now;
    
    //CRC校验和
    uint16_t check_all;  //加密
    uint16_t checkAllNum_decryption;  //解密
    
    //网络获取的数据包
    NSData *soft_data;
    //升级数据总字节数
    int data_all_byte_bin;
    //升级包数
    int text_n;
    //固件是否需要添加0发送，取得余数
    int data_all_remainder;
    //固件数据包数
    int data_n;
    //正在升级的包数
    int data_n_now;
    //将要发送的总包数
    int data_nums;
    
    //分段
    int check01;
    int check02;
    int check03;
    int check04;
    
    //检测蓝牙是否重启
    int checkRefsh;
    //检测下载是否成功
    int checkDownloadSuccess;
    //检测下载过程是否出错
    int checkDownLoadError;
    //检测下载程序是否可以应答
    int checkReplyAllPage;
    //检测安装程序是否可以启动
    int checkStartDownLoad;
    
    NSData *device_datas_soft;
    NSData *device_check_crc16;
    
    //OAD升级第一包bin数据文件
    NSData *soft_update_page01_bin;
    
    //扫描蓝牙信号
    NSTimer *timerRSSI;
    
    //是否按按钮离开页面
    int our_btn;  //0 - 取消升级  1 - 主动退出
    
    //是否有蓝牙在请求电子烟连接 YES - 没有  NO - 有
    Boolean check_ble_status;
}
@end

@implementation STW_BLE_SDK

//sdk是否初始化成功
static STW_BLE_SDK *shareInstance = nil;

/**
 初始化STW_BLE_SDK
 */
-(Boolean)STW_BLE_SDK_init
{
    //初始化蓝牙连接状态 - off
    _stw_isBLEType = STW_BLE_IsBLETypeOff;
    return YES;
}

+(STW_BLE_SDK *)sharedInstance
{
    if (!shareInstance)
    {
        shareInstance = [[STW_BLE_SDK alloc] init];
        shareInstance.centralManager = [[CBCentralManager alloc] initWithDelegate:shareInstance queue:nil];
        shareInstance.scanedDevices = [NSMutableArray array];
        shareInstance.bindingDevices = [NSMutableArray array];
    }
    return shareInstance;
}

#pragma mark 蓝牙发送数据接口
/************************ *STW BLE SDK 查询接口定义 ******************************/
/**
 1.开始扫描电子烟
 */
-(void)scanStart
{
    if (_BLE_Status) {
        isBLEStatus = NO;
        
        _stw_isBLEType = STW_BLE_IsBLETypeOff;
        
        //初始化扫描设备数组
        [self.scanedDevices removeAllObjects];
        //检测所有信道
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerScanOptionAllowDuplicatesKey ,nil];
        
        [self.centralManager scanForPeripheralsWithServices:nil options:options];
        
        //主动延时
        double delayInSeconds = 4.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           if (isBLEStatus == NO)
                           {
                               //结束扫描
                               NSLog(@"结束扫描");
                               //结束蓝牙扫描
                               [self scanStop];
                           }
                       });
    }
    else
    {
        NSLog(@"蓝牙没有打开");
        //提醒蓝牙没有打开
    }
}

-(void)scanStart_to_loading
{
    isBLEStatus = NO;
    _stw_isBLEType = STW_BLE_IsBLETypeLoding;
    //初始化扫描设备数组
    [self.scanedDevices removeAllObjects];
    //检测所有信道
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerScanOptionAllowDuplicatesKey ,nil];
    
    [self.centralManager scanForPeripheralsWithServices:nil options:options];
}

/**
 2.结束扫描电子烟
 */
-(void)scanStop
{
    [self.centralManager stopScan];
}

/**
 3.连接蓝牙 - 需要携带
 @param device 扫描到的蓝牙设备
 */
-(void)connect:(STW_BLE_Device *)device
{
    //停止扫描蓝牙
    [self scanStop];
    
    if (device.peripheral == nil)
    {
//        NSLog(@"连接蓝牙 - 参数出现错误");
    }
    else
    {
        if(isBLEStatus)
        {
//            NSLog(@"有蓝牙正在连接");
        }
        else
        {
//            NSLog(@"连接设备 - %@",device.deviceMac);
            self.device = device;
            device.peripheral.delegate = self;
            [self.centralManager connectPeripheral:device.peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        }
    }
}

/**
 4.断开蓝牙连接
 */
-(void)disconnect
{
    if (self.device)
    {
//        NSLog(@"主动断开蓝牙");
        //主动断开蓝牙
        _stw_isBLEType = STW_BLE_IsBLETypeOff;
        [self.centralManager cancelPeripheralConnection:self.device.peripheral];
    }
    else
    {
//        NSLog(@"没有设备连接");
    }
}

/**
 5.查询电池电量 - 电量百分比
 */
-(void)the_find_battery
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = 0xFD ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand003,0x05,0xFD,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 6.查询当前所有信息
 */
-(void)the_work_mode
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = 0xFD ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand00F,0x05,0xFD,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 7.查询设置烤烟发热杯最高温度
 @param temp_mode 温度模式
 @param temp 温度值
 */
-(void)the_work_temp_max:(BLEProtocolTemperatureUnit)temp_mode :(int)temp
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = temp_mode ^ (temp >> 8) ^ temp ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand002,0x07,temp_mode,(temp >> 8),temp,checknum};
        NSData *datas = [NSData dataWithBytes:c length:7];
        
        [self sendData:datas];
    }
}

/**
 8.设置电子烟开关机状态
 @param boot 开关机
 */
-(void)the_boot_bool:(BootStatus)boot
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = (Byte)boot ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand004,0x05,(Byte)boot,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 9.设置温度模式
 @param temp_mode 温度类型 - 华氏度 - 摄氏度
 */
-(void)the_work_mode_temp:(BLEProtocolTemperatureUnit)temp_mode
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = temp_mode ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand005,0x05,temp_mode,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 10.设置系统时间 - 需要向电子烟同步时间的时候使用（SDK已经进行同步，APP开发人员不需要进行操作）
 */
-(void)the_set_time
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        //        [self the_activate_device];
        
        //获取当前系统的时间
        //        NSLog(@"获取当前系统的时间");
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
        
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand006,0x0B,year >> 8,(Byte)year,(Byte)mouth,(Byte)day,(Byte)h,(Byte)m,(Byte)s,(Byte)checknum};
        //发送系统的时间给电子烟
        NSData *datas = [NSData dataWithBytes:c length:11];
        
        [self sendData:datas];
    }
}

/*
 11.设置电子烟名称
 @param deviceName 电子烟名称  (1 - 16字节，过长部分自动裁剪)
 */
-(void)the_set_device_name:(NSString *)deviceName
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        //将字符转换成ASII码
        NSData *nameData = [self getDatastr:deviceName];
        
        Byte *NumeStrs = (Byte *)[nameData bytes];
        //组装数据发送给电子烟
        int len_num = NumeStrs[0];
        
        //            NSLog(@"len_num - %d",len_num);
        
        unsigned char buf[20];
        
        //帧头
        buf[0] = BLEProtocolHeader01;
        
        //命令
        buf[1] = STW_BLECommand007;
        
        //长度
        buf[2] = 20;
        
        if(len_num > 16)
        {
            len_num = 16;
        }
        
        for (int i = 3; i < len_num + 3; i++)
        {
            buf[i] = NumeStrs[(i-3)+1];
        }
        
        //不足16位补全空格
        for (int i = len_num + 3 ; i < 16 + 3; i++)
        {
            buf[i] = 0x00;
        }
        
        //校验位
        Byte check_num = 0;
        
        for (int i = 3; i < 19; i++)
        {
            check_num =  check_num ^ buf[i];
        }
        
        //校验位
        buf[19] = check_num ^ 0xA6;
        
        NSMutableData *datas = [[NSMutableData alloc] init];
        [datas appendBytes:buf length:20];
        
        [self sendData:datas];
    }
}

//组装设备名字的数据
-(NSData *)getDatastr:(NSString *)str
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

/**
 12.设置、查询游戏模式
 @param gameModel 游戏模式 - 查询游戏模式 0xFD
 */
-(void)the_set_game_model:(BLEGameModeType)gameModel
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = gameModel ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand008,0x05,gameModel,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 13.设置、查询加热模式
 */
-(void)the_work_mode_setting:(BLEProtocolModeType)work_model
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = work_model ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand009,0x05,work_model,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 14.设置、查询亮灯模式
 */
-(void)the_lamp_mode:(BLELampModeType)lamp_model
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = lamp_model ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand00A,0x05,lamp_model,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 15.亮度百分比设置
 @param brightness_value 亮度 - 0xFD 查询当前亮度
 */
-(void)the_brightness:(int)brightness_value
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = brightness_value ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand00B,0x05,brightness_value,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 16.马达强度百分比设置
 @param motor_value 亮度 - 0xFD 查询当前马达震动强度
 */
-(void)the_motor:(int)motor_value
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = motor_value ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand00C,0x05,motor_value,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 机身颜色设置、查询
 @param pax_color 机身颜色 - 0xFD 查询当前机身颜色
 */
-(void)the_pax_color:(int)pax_color
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = pax_color ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand00D,0x05,pax_color,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 17.查询硬件信息（返回思拓微设备唯一编号，通过思拓微数据库查询硬件设备的信息）
 */
-(void)the_Find_deviceData
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        int checknum = 0xFD ^ 0xA6;
        Byte c[] = {BLEProtocolHeader01,STW_BLECommand01E,0x05,0xFD,checknum};
        NSData *datas = [NSData dataWithBytes:c length:5];
        
        [self sendData:datas];
    }
}

/**
 18.OAD升级
 @param BinDataFromBinFile Bin文件数据
 @param softVersion 软件版本 - 通过思拓微数据库查询
 @param deviceVersion 硬件版本 - 通过思拓微数据库查询
 */
-(void)send_OAD_File:(NSData *) BinDataFromBinFile :(NSString *)softVersion :(NSString *)deviceVersion
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeOn)
    {
        //激活设备
        [self the_activate_device];
        
        soft_data = [[NSData alloc] init];
        soft_data = BinDataFromBinFile;
        
        int lengs = (int)soft_data.length;
        
        if (lengs > 160)
        {
            //获取bin文件头部信息
            soft_update_page01_bin = [[NSData alloc] init];
            
            soft_update_page01_bin = [soft_data subdataWithRange:NSMakeRange(PAGE01BIN,16)];
            
            
            device_datas_soft = [soft_data subdataWithRange:NSMakeRange(STSRTDRESS,lengs - STSRTDRESS)];
            
            device_check_crc16 = [self check_data_68K:device_datas_soft];
            
            //解密
            NSMutableData *A5_datas = [self decryption_A5_NsData:device_check_crc16];
            
            check_all = 0;  //加密校验
            
            checkAllNum_decryption = [self CRC16_1:A5_datas];   //解密校验
            
            data_all_byte_bin = (int)device_check_crc16.length;
            
            const unsigned char* bytes_datas_check_bin = [soft_update_page01_bin bytes];
            uint16_t checkCrc16_bin = bytes_datas_check_bin[1] * 256 +  bytes_datas_check_bin[0];
            
            //        NSLog(@"计算校验和 - %d - 获取bin校验和 - %d",checkAllNum_decryption,checkCrc16_bin);
            
            //判断文件是否有误
            if (checkAllNum_decryption == checkCrc16_bin)
            {
                //数据封装
                text_n = 0;
                data_n_now = 0;
                
                data_all_remainder = data_all_byte_bin%16;
                
                data_n = data_all_byte_bin/16;
                
                if (data_all_remainder > 0)
                {
                    data_nums = data_n + 1;
                }
                
                check01 = (data_n * 1)/5;
                check02 = (data_n * 2)/5;
                check03 = (data_n * 3)/5;
                check04 = (data_n * 4)/5;
                
                checkStartDownLoad = 0;
                //@"验证安装包!";
                
                double delayInSeconds = 5.0f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   if (checkStartDownLoad == 0)
                                   {
                                       //@"安装包验证超时!";
                                       Update_Now = 0;
                                       //报告错误
                                       if (self.BLEServiceOADProgress)
                                       {
//                                           self.BLEServiceOADProgress([STW_BLE_OADProgress error:0 :BLERMsg_OAD01]);
                                       }
                                   }
                               });
                
                //点亮屏幕
                [self the_activate_device];
                
                //发送第一包沟通数据
                Byte byte[4];
                
                NSMutableData *datas_c1 = [[NSMutableData alloc] init];
                
                byte[0] = 0x00;
                byte[1] = 0x00;
                byte[2] = 0x04;
                byte[3] = 0x00;
                
                [datas_c1 appendBytes:byte length:4];
                
                Update_Now = 1;
                checkDownLoadError = 0;
                
                [self sendBigData:datas_c1 :0];
                
//                    return [STW_BLE_RMsg success:BLERMsg_message11];
            }
            else
            {
                //@"安装包校验出错!";
                Update_Now = 0;
//                    return [STW_BLE_RMsg error:BLERMsg_message12];
            }
        }
        else
        {
            //@"安装包校验出错!";
            Update_Now = 0;
//                return [STW_BLE_RMsg error:BLERMsg_message13];
        }
    }
}

/**
 19.停止OAD升级
 */
-(void)stop_OAD
{
    if (Update_Now == 1)
    {
        //停止OAD升级
        Update_Now = 0;
    }
}

#pragma mark 蓝牙数据发送
//发送少量的数据
-(void)sendData:(NSData *)data
{
    if(self.device.characteristic)
    {
        NSLog(@"向设备发送的信息--->%@",data);
//        NSMutableData *datas = [self command_lock:data];
//        NSLog(@"向设备发送的加密信息--->%@",datas);
        //模式一  读写
        [self.device.peripheral writeValue:data forCharacteristic:self.device.characteristic type:CBCharacteristicWriteWithResponse];
    }
}

//发送大量的数据
-(void)sendBigData:(NSData *)data :(int)type
{
    if (type == 0)
    {
//        NSLog(@"向设备发送的信息--->%@\n%@",data,characateristicSoftUpdatePage01);
//        NSMutableData *datas = [self command_lock:data];
//        NSLog(@"向设备发送的加密信息--->%@",datas);
        //模式二  只写不读 - 发送第一包数据
        [self.device.peripheral writeValue:data forCharacteristic:characateristicSoftUpdatePage01 type:CBCharacteristicWriteWithoutResponse];
    }
    else if (type == 1)
    {
//        NSLog(@"向设备发送的信息--->%@\n%@",data,characateristicSoftUpdateBinPage);
        //模式二  只写不读 - 发送bin文件数据
        [self.device.peripheral writeValue:data forCharacteristic:characateristicSoftUpdateBinPage type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark CBCentralManagerDelegate     -- >  实现蓝牙代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch ([central state])
    {
        case CBManagerStateUnsupported:
//            NSLog(@"蓝牙设备不支持的状态");
            _BLE_Status = NO;
            break;
        case CBManagerStateUnauthorized:
//            NSLog(@"蓝牙设备未授权状态");
            _BLE_Status = NO;
            break;
        case CBManagerStatePoweredOff:
//            NSLog(@"蓝牙关闭状态");
            _BLE_Status = NO;
            break;
        case CBManagerStatePoweredOn:
//            NSLog(@"蓝牙可用状态");
            _BLE_Status = YES;
            break;
        case CBManagerStateUnknown:
//            NSLog(@"手机蓝牙设备未知错误");
            _BLE_Status = NO;
            break;
        default:
//            NSLog(@"手机蓝牙设备未知错误");
            _BLE_Status = NO;
            break;
    }
}

/*!
 *  @method centralManager:willRestoreState:
 *
 *  @param central      The central manager providing this information.
 *  @param dict			A dictionary containing information about <i>central</i> that was preserved by the system at the time the app was terminated.
 *
 *  @discussion			For apps that opt-in to state preservation and restoration, this is the first method invoked when your app is relaunched into
 *						the background to complete some Bluetooth-related task. Use this method to synchronize your app's state with the state of the
 *						Bluetooth system.
 *
 *  @seealso            CBCentralManagerRestoredStatePeripheralsKey;
 *  @seealso            CBCentralManagerRestoredStateScanServicesKey;
 *  @seealso            CBCentralManagerRestoredStateScanOptionsKey;
 *
 */

//central提供信息，dict包含了应用程序关闭是系统保存的central的信息，用dic去恢复central
//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
//{
//        NSLog(@"willRestoreState - %@",dict);
//}

/*!
 *  @method centralManager:didRetrievePeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects.
 *
 *  @discussion         This method returns the result of a {@link retrievePeripherals} call, with the peripheral(s) that the central manager was
 *                      able to match to the provided UUID(s).
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    //    NSLog(@"didRetrievePeripherals");
}

/*!
 *  @method centralManager:didRetrieveConnectedPeripherals:
 *
 *  @param central      The central manager providing this information.
 *  @param peripherals  A list of <code>CBPeripheral</code> objects representing all peripherals currently connected to the system.
 *
 *  @discussion         This method returns the result of a {@link retrieveConnectedPeripherals} call.
 *
 */
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    //    NSLog(@"didRetrieveConnectedPeripherals");
}

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *								was not available.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */

//扫描到了设备执行此方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //过滤规则
    NSString *name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *BLEId = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    Byte *BLEStrs = (Byte *)[BLEId bytes];
    int Ble = 0;
    if (BLEStrs != nil)
    {
        if (BLEStrs[0] == VendorId_01 && BLEStrs[1] == VendorId_02 && BLEStrs[2] == VendorId_03)
        {
            //检测到来自厂商的电子烟
            Ble = 1;
        }
        else
        {
            Ble = 0;
        }
    }
    
    if (Ble == 1 && name != nil)
    {
        //将获取所有外围蓝牙设备数据封装到扫描列表
        STW_BLE_Device *BLEDevice = [[STW_BLE_Device alloc]init];
        BLEDevice.peripheral = peripheral;
        BLEDevice.RSSI = RSSI;
//        BLEDevice.advertisementData = advertisementData;
        BLEDevice.deviceName = name;
        BLEDevice.deviceMac = [NSString stringWithFormat:@"%d%d%d%d%d%d%d",BLEStrs[3],BLEStrs[4],BLEStrs[5],BLEStrs[6],BLEStrs[7],BLEStrs[8],VendorId];
        BLEDevice.deviceModel = BLEStrs[9];
        BLEDevice.deviceColor = BLEStrs[10];
        
//        NSLog(@"deviceColor ===> %d",BLEDevice.deviceColor);
        
        if ([self check_plist_device:BLEDevice.deviceModel])
        {
            int n = 0;
            
            if(self.scanedDevices.count > 0)
            {
                for (int i = 0; i < self.scanedDevices.count; i++)
                {
                    STW_BLE_Device *BLEDevice_arrrys = [self.scanedDevices objectAtIndex:i];
                    if ([BLEDevice.deviceMac isEqualToString:BLEDevice_arrrys.deviceMac])
                    {
                        n += 1;
                        break;
                    }
                }
            }
            
            if(n == 0)
            {
                [self.scanedDevices addObject:BLEDevice];
                //延时发送扫描到了设备数据
                if(self.BLEServiceScanHandler)
                {
                    self.BLEServiceScanHandler(BLEDevice);
                }
                
            }
        }
        else
        {
            //配置文件不存在这样的设备
            NSLog(@"配置文件不存在这样的设备");
        }
    }
}

//让其他设备可以再次请求
-(void)check_ble_status_delay
{
    check_ble_status = YES;
}
/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */

//连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"外设开始连接");
    _stw_isBLEType = STW_BLE_IsBLETypeOn;
    isBLEStatus = YES;
    
    //开始发现服务
    [peripheral discoverServices:nil];
}

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@"didFailToConnectPeripheral");
}

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */

//设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"断开连接蓝牙 - %@",peripheral);
    //蓝牙断开连接回调
    [self didDisconnect];
}

-(void)didDisconnect
{
    isBLEStatus = NO;
    
    if(Update_Now == 1)
    {
        [self Service_Soft_Update:0xEE];
        //蓝牙断开连接回调
        if(self.BLEServiceDisconnectHandler)
        {
            self.BLEServiceDisconnectHandler();
        }
    }
    else
    {
        _stw_isBLEType = STW_BLE_IsBLETypeOff;
        //蓝牙断开连接回调
        if(self.BLEServiceDisconnectHandler)
        {
            self.BLEServiceDisconnectHandler();
        }
    }
}

-(void)addLodingDevice
{
    if (_stw_isBLEType == STW_BLE_IsBLETypeLoding)
    {
        //结束蓝牙扫描
        [self scanStop];
        
        self.device = nil;
        
        _stw_isBLEType = STW_BLE_IsBLETypeOff;
        //蓝牙断开连接回调
        if(self.BLEServiceDisconnectHandler)
        {
            self.BLEServiceDisconnectHandler();
        }
    }
}

#pragma mark  CBPeripheralDelegate
/*!
 *  @method peripheralDidUpdateName:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link name @/link of <i>peripheral</i> changes.
 */
//- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0);

/*!
 *  @method peripheralDidInvalidateServices:
 *
 *  @param peripheral	The peripheral providing this update.
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed. At this point,
 *						all existing <code>CBService</code> objects are invalidated. Services can be re-discovered via @link discoverServices: @/link.
 *
 *	@deprecated			Use {@link peripheral:didModifyServices:} instead.
 */
- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral NS_DEPRECATED(NA, NA, 6_0, 7_0)
{
    //    NSLog(@"peripheralDidInvalidateServices");
}

/*!
 *  @method peripheral:didModifyServices:
 *
 *  @param peripheral			The peripheral providing this update.
 *  @param invalidatedServices	The services that have been invalidated
 *
 *  @discussion			This method is invoked when the @link services @/link of <i>peripheral</i> have been changed.
 *						At this point, the designated <code>CBService</code> objects have been invalidated.
 *						Services can be re-discovered via @link discoverServices: @/link.
 */
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices NS_AVAILABLE(NA, 7_0)
{
    //    NSLog(@"didModifyServices");
}

/*!
 *  @method peripheralDidUpdateRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 *
 *  @deprecated			Use {@link peripheral:didReadRSSI:error:} instead.
 */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error NS_DEPRECATED(NA, NA, 5_0, 8_0)
{
//        NSLog(@"peripheralDidUpdateRSSI");
}

/*!
 *  @method peripheral:didReadRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *  @param RSSI			The current RSSI of the link.
 *  @param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error NS_AVAILABLE(NA, 8_0)
{
//    NSLog(@"didReadRSSI--读取设备信号 -- > %@ ->%@",RSSI,error);
//    if(self.Service_RSSIHandler)
//    {
//        self.Service_RSSIHandler(RSSI);
//    }
}

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //蓝牙连接上之后执行的方法
    int ChickUUID = 1;
    
    NSLog(@"蓝牙开始连接 - 1");
    
    if (error)
    {
        NSLog(@"设备->%@ 出现错误->%@,请联系思拓微", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services)
    {
        //设备服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceService]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
            
            ChickUUID = ChickUUID + 1;
        }
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceUpdateSoftService]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
            
            ChickUUID = ChickUUID + 1;
        }
    }
    
    if(ChickUUID < 3)
    {
//        NSLog(@"思拓微提醒，此设备不属于思拓微 --> 拒绝服务，断开连接！");
        [self disconnect];
    }
    else
    {
        //设备开始连接
//        NSLog(@"该服务来自于思拓微");
        _stw_isBLEType = STW_BLE_IsBLETypeOn;
        isBLEStatus = YES;
    }
}

/*!
 *  @method peripheral:didDiscoverIncludedServicesForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the included services.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    //    NSLog(@"didDiscoverIncludedServicesForService");
}

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */
//开始服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"设备%@ 出现错误: %@，请联系思拓微", service.UUID, [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        //        NSLog(@"characteristic.UUID - %@",characteristic.UUID);
        //接收数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceData]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        //发送数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSetup]])
        {
            [peripheral readValueForCharacteristic:characteristic];
            self.device.characteristic = characteristic;
            
            //在此延时发送命令即可（可以考虑使用串行队列）
            //主动延时
            double delayInSeconds = 0.3f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               //延时方法
                               [self the_work_mode_temp:self.STW_BLE_Temp_model];
                           });
            
            //主动延时
            double delayInSeconds3 = 0.7f;
            dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds3 * NSEC_PER_SEC));
            dispatch_after(popTime3, dispatch_get_main_queue(), ^(void)
                           {
                               //延时方法
                               [self the_work_mode];
                           });
        }
        //设置设备名字
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceName]])
        {
            characateristicDeviename = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        //发送soft Update第一包数据
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSoftUpdatePage01]])
        {
            characateristicSoftUpdatePage01 = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        //发送soft Update bin文件数据
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSoftUpdateBinPage]])
        {
            characateristicSoftUpdateBinPage = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    NSLog(@"蓝牙开始连接 - 2");
    
    double delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       if(self.BLEServiceDiscoverCharacteristicsForServiceHandler)
                       {
//                           NSLog(@"机身颜色 -- %d",self.device.deviceColor);
                           int deviceColor = self.device.deviceColor;
                           [STW_BLE_SDK sharedInstance].deviceData.pax_color = deviceColor;
                           //设备刚刚连接设备可以进行初始化查询等操作
                           self.BLEServiceDiscoverCharacteristicsForServiceHandler(deviceColor);
                       }
                   });
}




//设置系统时间
-(void)init_rootTime
{
    [self the_set_time];
}

//初始查询
-(void)init_findAll_model
{
    [self the_work_mode];
}

//设置系统温度
-(void)init_setTemp_model
{
    [self the_work_mode_temp:self.STW_BLE_Temp_model];
}

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //蓝牙数据接收
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceData]])
    {
        //需要在此处进行解密操作
        NSLog(@"接收的数据 - > %@",characteristic.value);
        NSData *data = characteristic.value;
        //解密
//        NSMutableData *datas = [self command_unlock:data];
//        NSLog(@"接收解密的数据 - > %@",datas);
        
        [self  build_bleData:data];
    }
}

#pragma mark 蓝牙接收数据接口
//开始解析数据
- (void)build_bleData:(NSData*)ble_data
{
    //接收到的数据部分，数据加密在此解密
    NSMutableData *mdata = [NSMutableData dataWithData:ble_data];
    
    const unsigned char* bytes = [mdata bytes];
    
    if (bytes[0] == BLEProtocolHeader01)
    {
        //命令解析
        switch (bytes[1])
        {
            case STW_BLECommand001:
            {
                //当前发热杯温度
                if (bytes[3] != 0xEE) {
                    int tmp_model = bytes[3];
                    int tmp_value = bytes[4] * 256 + bytes[5];
                    if (self.BLEServiceTempNow) {
                        self.BLEServiceTempNow(tmp_model,tmp_value);
                    }
                }
            }
                break;
                
            case STW_BLECommand002:
            {
                //发热杯最高温度
                if (bytes[3] != 0xEE) {
                    int tmp_model = bytes[3];
                    int tmp_value = bytes[4] * 256 + bytes[5];
//                    NSLog(@"发热杯最高温度-%d,%d",tmp_model,tmp_value);
                    if (self.BLEServiceTempMax) {
                        self.BLEServiceTempMax(tmp_model,tmp_value);
                    }
                }
            }
                break;
                
            case STW_BLECommand003:
            {
                //电池电量
                if (bytes[3] != 0xEE)
                {
                    if (self.BLEServiceDeviceBattery)
                    {
                        int battery_status = bytes[3];
                        int battery_value = bytes[4];
                        self.BLEServiceDeviceBattery(battery_status,battery_value);
                    }
                }
            }
                break;
                
            case STW_BLECommand004:
            {
                //开关机状态
                if (bytes[3] != 0xEE)
                {
                    if (self.BLEServiceDeviceRoot)
                    {
                        int boot_status = bytes[3];
                        self.BLEServiceDeviceRoot(boot_status);
                    }
                }
            }
                break;
                
            case STW_BLECommand005:
            {
                //温度单位设置
                if (bytes[3] != 0xEE)
                {
                    if (self.BLEServiceTempModel)
                    {
                        int tmp_model = bytes[3];
                        self.BLEServiceTempModel(tmp_model);
                    }
                }
            }
                break;
                
            case STW_BLECommand006:
            {
                //当前时间
                if (bytes[3] != 0xEE)
                {
                    
                }
            }
                break;
                
            case STW_BLECommand007:
            {
                //电子烟名称设置
                if (bytes[3] != 0xEE)
                {
                    if (self.BLEServiceDeviceName) {
                        self.BLEServiceDeviceName(0x00);
                    }
                }
                else
                {
                    if (self.BLEServiceDeviceName) {
                        self.BLEServiceDeviceName(bytes[3]);
                    }
                }
            }
                break;
                
            case STW_BLECommand008:
            {
               //游戏模式
                if (bytes[3] != 0xEE)
                {
                    int game_model = bytes[3];
                    if (self.BLEServiceGameModel) {
                        self.BLEServiceGameModel(game_model);
                    }
                }
            }
                break;
                
            case STW_BLECommand009:
            {
               //加热模式
                if (bytes[3] != 0xEE)
                {
                    int work_model = bytes[3];
                    if (self.BLEServiceWorkModel) {
                        self.BLEServiceWorkModel(work_model);
                    }
                }
            }
                break;
                
            case STW_BLECommand00A:
            {
               //亮灯的颜色模式
                if (bytes[3] != 0xEE)
                {
                    int lamp_model = bytes[3];
                    if (self.BLEServiceLampModel) {
                        self.BLEServiceLampModel(lamp_model);
                    }
                }
            }
                break;
                
            case STW_BLECommand00B:
            {
                //亮度设置
                if (bytes[3] != 0xEE)
                {
                    int brightness_value = bytes[3];
                    if (self.BLEServicebBrightness) {
                        self.BLEServicebBrightness(brightness_value);
                    }
                }
            }
                break;
                
            case STW_BLECommand00C:
            {
                //马达震动强度设置
                if (bytes[3] != 0xEE)
                {
                    int vibration_value = bytes[3];
                    if (self.BLEServiceVibration) {
                        self.BLEServiceVibration(vibration_value);
                    }
                }
            }
                break;
                
            case STW_BLECommand00D:
            {
                //机身颜色设置查询
                if (bytes[3] != 0xEE)
                {
                    int pax_color = bytes[3];
                    if (self.BLEServicePaxColor) {
                        self.BLEServicePaxColor(pax_color);
                    }
                }
            }
                break;
                
            case STW_BLECommand00E:
            {

            }
                break;
                
            case STW_BLECommand00F:
            {
                //查询所有信息
                if (bytes[3] == 0x00) {
                    //加热模式 – 4
                    int work_model = bytes[4];
                    //温度模式 – 5
                    int tmp_model = bytes[5];
                    //发热杯最高温度 – D6 D7
                    int tmp_max = bytes[6] * 256 + bytes[7];
                    //发热杯当前温度 – D8 D9
                    int tmp_now = bytes[8] * 256 + bytes[9];
                    //亮灯的颜色模式 – D10
                    int lamp_model = bytes[10];
                    //亮度百分比 – D11
                    int brightness_value = bytes[11];
                    //游戏模式 – D12
                    int game_model = bytes[12];
                    //是否锁机 – D13
                    int boot_status = bytes[13];
                    //震动强度百分比 – D14
                    int vibration_value = bytes[14];
                    //机身颜色
                    int pax_color = bytes[15];
                    //电池电量
                    int pax_battery = bytes[16];
                    
                    if (self.BLEServiceAllDatas) {
                        self.BLEServiceAllDatas(work_model, tmp_model, tmp_max, tmp_now, lamp_model, brightness_value, game_model, boot_status, vibration_value,pax_color,pax_battery);
                    }
                }
            }
                break;
                
            case STW_BLECommand01E:           //查询硬件设备信息
            {
                if (bytes[3] == 0)
                {
                    int Device_Version = bytes[4] * 256 + bytes[5];
                    int Soft_Version = bytes[6] * 256 + bytes[7];
                    
                    if (self.BLEServiceFine_DeviceData)
                    {
                        self.BLEServiceFine_DeviceData(Device_Version,Soft_Version);
                    }
                }
            }
                break;
            case STW_BLECommand01F:           //传输当前下载包数 - OAD升级
            {
                if (bytes[3] == 0)
                {
                    int pageNum = bytes[4] * 256 + bytes[5];

                    [self Service_Soft_Update:pageNum];

                }
                else if (bytes[3] == 0x88)
                {
                    //升级成功
                    [self Service_Soft_Update:0x88];

                }
                else if (bytes[3] == 0xE1)
                {
                    int checkNums = 0;
                    int bytes5 = bytes[5];
                    
//                    NSLog(@"bytes5 - %d",bytes5);
                    
                    switch (bytes5)
                    {
                        case 0x00:
                            checkNums = 0xE0;  //设备不匹配
                            break;
                        case 0x01:
                            checkNums = 0xE1;  //软件版本过低
                            break;
                        case 0x02:
                            checkNums = 0xE2;  //掉包过多
                            break;
                            
                        default:
                            break;
                    }
                    
                    [self Service_Soft_Update:checkNums];

                }
                else if(bytes[3] == 0xE8)
                {
                    int lost_page = bytes[4] * 256 + bytes[5];
                    //记录所丢失包数
                    [softUpdate_lostPage addObject:[NSString stringWithFormat:@"%d",lost_page]];
                }
                else if(bytes[3] == 0xF0)
                {
                    //发送一共丢失了多少包
                    int lowPage = bytes[4] * 256 + bytes[5];
                    
                    if(lowPage == softUpdate_lostPage.count)
                    {
                        [self Service_Soft_Update:0xE8];
                    }
                }
                else if(bytes[3] == 0x87)
                {
                    //数据全部发送成功
                    [self Service_Soft_Update:0x87];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

//解析蓝牙返回的数据 0x00 - 0x1D


/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //蓝牙数据发送
//    if (error)
//    {
//        NSLog(@"error.userInfo:%@",error.userInfo);
//        NSLog(@"发送数据失败->UUID:%@-\n失败数据->%@",characteristic.UUID,characteristic.value);
//    }
//    else
//    {
//        NSLog(@"发送数据成功->UUID:%@-\n成功数据->%@",characteristic.UUID,characteristic.value);
//    }
}

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //    NSLog(@"didUpdateNotificationStateForCharacteristic");
}

/*!
 *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
 *							they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //    NSLog(@"didDiscoverDescriptorsForCharacteristic");
}

/*!
 *  @method peripheral:didUpdateValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link readValueForDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    //    NSLog(@"didUpdateValueForDescriptor");
}

/*!
 *  @method peripheral:didWriteValueForDescriptor:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param descriptor		A <code>CBDescriptor</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link writeValue:forDescriptor: @/link call.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    //    NSLog(@"didWriteValueForDescriptor");
}

//设置设备名字的方法(修改)
-(void)setDeviceNname:(NSData *)namedata
{
//    NSLog(@"修改的设备名字%@",namedata);
    [self.device.peripheral writeValue:namedata forCharacteristic:characateristicDeviename type:CBCharacteristicWriteWithResponse];
}

/*************************加密/解密 start ********************************/
//命令位加密
//-(NSMutableData *)command_lock:(NSData *)unlockdata
//{
//    int data_leng = (int)unlockdata.length;
//    
//    NSMutableData *mdata=[[NSMutableData alloc]init];
//    mdata = [NSMutableData dataWithData:unlockdata];
//    const unsigned char* bytes = [mdata bytes];
//    unsigned char buf[data_leng];
//    
//    for (int i = 0; i < data_leng; i++)
//    {
//        buf[i] = [self jiami:bytes[i] :KEY_COMMAND[i]];
//    }
//    
//    NSMutableData *out_datas = [[NSMutableData alloc] init];
//    [out_datas appendBytes:buf length:data_leng];
//    
//    return out_datas;
//}
//
////命令位解密
//-(NSMutableData *)command_unlock:(NSData *)lockdata
//{
//    int data_leng = (int)lockdata.length;
//    
//    NSMutableData *mdata=[[NSMutableData alloc]init];
//    mdata = [NSMutableData dataWithData:lockdata];
//    const unsigned char* bytes = [mdata bytes];
//    unsigned char buf[data_leng];
//    
//    for (int i = 0; i < data_leng; i++)
//    {
//        buf[i] = [self jiemi:bytes[i] :KEY_COMMAND[i]];
//    }
//    
//    NSMutableData *out_datas = [[NSMutableData alloc] init];
//    [out_datas appendBytes:buf length:data_leng];
//    
//    return out_datas;
//}
//
////加密 data_random 需要加密的数值：data_random 秘钥：data_key
//-(int)jiami:(int)data_random :(int)data_key
//{
//    int nums = data_random;
//    nums = [self decryption_random:nums :data_key];
//    nums = [self decryption_rules_lock:nums];
//    return nums;
//}
//
////解密 data_random 需要解密的数值：data_random 秘钥：data_key
//-(int)jiemi:(int)data_random :(int)data_key
//{
//    int nums = data_random;
//    nums = [self decryption_rules_unlock:nums];
//    nums = [self decryption_random:nums :data_key];
//    return nums;
//}
//
////加密/解密按字节异或随机数
//-(int)decryption_random:(int)data_random :(int)data_key
//{
//    int nums = data_random;
//    if (nums != 0x00 && nums != 0xFF && nums != data_key && (nums ^ data_key) != 0xFF)
//    {
//        nums =  data_random ^ data_key;
//    }
//    return nums;
//}
//
////加密倒置0x01 - 0xFF
//-(int)decryption_rules_lock:(int)data_rules
//{
//    int nums = 0x00;
//    
//    if (data_rules == 0x00 || data_rules == 0x40 || data_rules == 0x80 || data_rules == 0xc0)
//    {
//        //0x80 0x00不需要操作
//        nums = data_rules;
//    }
//    else if(data_rules > 0x00 && data_rules < 0x40)
//    {
//        nums = data_rules + 0x80;
//    }
//    else if(data_rules > 0x40 && data_rules < 0x80)
//    {
//        nums = data_rules + 0x80;
//    }
//    else if(data_rules > 0x80 && data_rules < 0xc0)
//    {
//        nums = data_rules - 0x40;
//    }
//    else
//    {
//        //data_rules > 0xc0
//        nums = data_rules - 0xc0;
//    }
//    
//    return nums;
//}
//
////解密倒置0x01 - 0xFF
//-(int)decryption_rules_unlock:(int)data_rules
//{
//    int nums = 0x00;
//    
//    if (data_rules == 0x00 || data_rules == 0x40 || data_rules == 0x80 || data_rules == 0xc0)
//    {
//        //0x80 0x00不需要操作
//        nums = data_rules;
//    }
//    else if(data_rules > 0x00 && data_rules < 0x40)
//    {
//        nums = data_rules + 0xc0;
//    }
//    else if(data_rules > 0x40 && data_rules < 0x80)
//    {
//        nums = data_rules + 0x40;
//    }
//    else if(data_rules > 0x80 && data_rules < 0xc0)
//    {
//        nums = data_rules - 0x80;
//    }
//    else
//    {
//        //data_rules > 0xc0
//        nums = data_rules - 0x80;
//    }
//    
//    return nums;
//}
/*************************加密/解密 end ********************************/

/***************************OAD升级****************************/
//处理OAD升级过程的方法
-(void)Service_Soft_Update:(int)pageNum
{
    switch (pageNum)
    {
        case 0:
            //发送产品名称
        {
            checkStartDownLoad = 1;
            //@"检测文件名称!";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,1);
            }
            NSMutableData *sendData = [self head_data_send:0 :16 :1 :18];
            [self sendBigData:sendData :0];
        }
            
            break;
        case 1:
            //发送软件版本
        {
            //@"检测软件版本!";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,1);
            }
            NSMutableData *sendData = [self head_data_send:16 :16 :2 :18];
            [self sendBigData:sendData :0];
        }
            break;
        case 2:
            //发送硬件版本
        {
            //@"检测硬件!";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,1);
            }
            NSMutableData *sendData = [self head_data_send:32 :16 :3 :18];
            [self sendBigData:sendData :0];
        }
            break;
        case 3:
            //发送文件名称
        {
            //@"检测文件!";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,1);
            }
            NSMutableData *sendData = [self head_data_send:48 :16 :4 :18];
            [self sendBigData:sendData :0];
        }
            break;
        case 4:
        {
            //设置标志
            Update_Now = 1;
            
            //开始发送升级文件
            //@"下载安装包";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,1);
            }
            
            //发送第一包数据
            [self the_soft_update_page01_bin:soft_update_page01_bin];

            //开始下载
            checkDownloadSuccess = 0;
            //下载开始
            checkDownLoadError = 0;
            //初始化掉包设置
            softUpdate_lostPage = [NSMutableArray array];
            
            //延时开始发送接下来的数据
            [self performSelector:@selector(send_device_datas) withObject:nil afterDelay:0.01f];
        }
            break;
        case 0x87:
        {
            checkReplyAllPage = 1;
            //@"数据接收完成，等待写入!";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(99,1);
            }
        }
            break;
        case 0x88:
        {
            checkReplyAllPage = 1;
            //@"设备正在重启,等待重连!";
            checkDownloadSuccess = -1;
            
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(100,1);
            }
        }
            break;
        case 0xE0:
        {
            checkDownLoadError = 1;
            //@"文件不匹配,请重新下载!";
            Update_Now = 0;
            
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,0);
            }
        }
            break;
        case 0xE1:
        {
            checkDownLoadError = 1;
            //@"软件版本过低,请重新下载!";
            Update_Now = 0;
            
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,0);
            }
        }
            break;
        case 0xE2:
        {
            checkDownLoadError = 1;
            //@"蓝牙信号不稳定,请重新下载!";
            Update_Now = 0;
            
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(0,0);
            }
        }
            break;
        case 0xE8:
        {
            checkReplyAllPage = 1;

            checkRefsh = 1;
            
            //补发所掉的数据包
            int low_page_nums = (int)softUpdate_lostPage.count;
            
            for (int i = 0; i < low_page_nums; i++)
            {
                NSString *str_nums = [softUpdate_lostPage objectAtIndex:i];
                int now_loePages = [str_nums intValue];
                
                double delayInSeconds = 0.01f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   //数据发送函数 frame_start->开始截取位置  frame_len->截取长度 frame_nums->帧序列 frame_length->帧长度  add_0->是否需要添加0
                                   [self send_data_add:(now_loePages * 16) :16 :now_loePages :18 :false];
                               });
            }
            
            //@"设备正在写入程序";
            if(self.BLEServiceOADProgress)
            {
                self.BLEServiceOADProgress(99,1);
            }
            
            double delayInSeconds = 10.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               //延时方法
                               if (checkRefsh == 1)
                               {
                                   //@"设备写入程序失败！";
                                   Update_Now = 0;
                                   
                                   if(self.BLEServiceOADProgress)
                                   {
                                       self.BLEServiceOADProgress(99,0);
                                   }
                               }
                           });
        }
            break;
        case 0xEE:
        {
            checkDownLoadError = 1;

            if(checkDownloadSuccess > 0)
            {
                if (data_n_now == data_n)
                {
                    checkRefsh = -1;
                    
                    //@"设备重启等待重连";
                    if(self.BLEServiceOADProgress)
                    {
                        self.BLEServiceOADProgress(100,1);
                    }
                    
                    //需要指定为断线重连,开始扫描蓝牙
                    [self scanStart_to_loading];

                    double delayInSeconds = 10.0f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                   {
                                       //延时方法
                                       [self scanStop];
                                       
                                       if(isBLEStatus && checkDownloadSuccess == 1)
                                       {
                                           checkDownloadSuccess = -1;
                                           //@"升级成功！";
                                           Update_Now = 0;
                                           
                                           if(self.BLEServiceOADProgress)
                                           {
                                               self.BLEServiceOADProgress(100,1);
                                           }
                                       }
                                       else if(!isBLEStatus && checkDownloadSuccess == 1)
                                       {
                                           checkDownloadSuccess = -1;
                                           //@"升级成功，请手动连接电子烟";
                                           Update_Now = 0;
                                           
                                           if(self.BLEServiceOADProgress)
                                           {
                                               self.BLEServiceOADProgress(100,1);
                                           }
                                       }
                                       else if(!isBLEStatus && checkDownloadSuccess == -1)
                                       {
                                           checkDownloadSuccess = -1;
                                           //@"连接失败，请手动连接电子烟";
                                           Update_Now = 0;
                                           
                                           if(self.BLEServiceOADProgress)
                                           {
                                               self.BLEServiceOADProgress(100,1);
                                           }
                                       }
                                   });
                }
                else
                {
                    checkDownloadSuccess = -1;
                    //@"蓝牙断开，请重新下载！";
                    Update_Now = 0;
                    
                    if(self.BLEServiceOADProgress)
                    {
                        self.BLEServiceOADProgress(0,0);
                    }
                }
            }
            else if(checkDownloadSuccess == 0)
            {
                checkDownloadSuccess = -1;
                //@"蓝牙断开，请保持设备距离!";
                Update_Now = 0;
                
                if(self.BLEServiceOADProgress)
                {
                    self.BLEServiceOADProgress(0,0);
                }
            }
        }
            break;
        default:
            break;
    }
}

//循环发送固件部分数据
-(void)send_device_datas
{
    //发送固件的包数
//    _pageNumLableView.text = [NSString stringWithFormat:@"%d/%d",data_n_now,data_n];
    
    float num = (data_n_now * 100.0f)/data_n;
    
    if(self.BLEServiceOADProgress)
    {
        self.BLEServiceOADProgress(num,1);
    }
    
    if (checkDownLoadError == 0 && Update_Now == 1)
    {
        if (data_n_now < data_n)
        {
            //数据发送函数 frame_start->开始截取位置  frame_len->截取长度 frame_nums->帧序列 frame_length->帧长度  add_0->是否需要添加0
            [self send_data_add:(data_n_now * 16) :16 :data_n_now :18 :false];
            
            data_n_now++;
            
            //延时10ms继续发送数据
            //            if ((data_n_now%5) == 0)
            //            {
            [self performSelector:@selector(send_device_datas) withObject:nil afterDelay:0.01f];
            //            }
            //            else
            //            {
            //                [self send_device_datas];
            //            }
        }
        else
        {
            if (data_all_remainder > 0)
            {
                //计算最后一帧的长度
                int len_nums = (int)device_check_crc16.length - ((data_n_now - 1)*16);
                
                //需要补齐0xFF发送
                [self send_data_add:(data_n_now * 16) :len_nums :data_n_now :18 :TRUE];
                
                data_n_now++;
                
                //延时20ms继续发送数据
                [self performSelector:@selector(send_device_datas) withObject:nil afterDelay:0.01f];
            }
            else
            {
                checkRefsh = 0;
                
                checkDownloadSuccess = 1;
                
                //@"正在进行程序总校验";
                
                checkReplyAllPage = 0;
                double delayInSecondsReply = 0.5f;
                dispatch_time_t popTimeReply = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecondsReply * NSEC_PER_SEC));
                dispatch_after(popTimeReply, dispatch_get_main_queue(), ^(void)
                               {
                                   if (checkReplyAllPage == 0)
                                   {
                                       //发送重新激活命令
                                       [self the_update_update_Reply];
                                   }
                               });
                
                double delayInSeconds = 15.0f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   //延时方法
                                   if (checkRefsh == 0)
                                   {
                                       //@"设备写入程序失败！";
                                       if(self.BLEServiceOADProgress)
                                       {
                                           self.BLEServiceOADProgress(99,0);
                                       }
                                   }
                               });
            }
        }
    }
    else
    {
        //@"升级失败！";
        if(self.BLEServiceOADProgress)
        {
            self.BLEServiceOADProgress(num,1);
        }
    }
}

//头信息数据发送函数 frame_start->开始截取位置  frame_len->截取长度 frame_nums->帧序列 frame_length->帧长度
-(NSMutableData *)head_data_send:(int)frame_start :(int)frame_len :(int)frame_nums :(int)frame_length
{
    //发送数据部分数据
    NSData *device_version = [soft_data subdataWithRange:NSMakeRange(frame_start,frame_len)];
    
    const unsigned char* bytes = [device_version bytes];
    
    NSMutableData *datas = [[NSMutableData alloc] init];
    
    //本帧长度int frame_length = 18;
    Byte byte[frame_length];
    //将byte元素全置为0
    memset(byte,0x00,sizeof(byte));
    
    byte[0] = frame_nums;
    byte[1] = frame_nums >> 8;
    //从第3位数据开始进行添加数据
    int check_n = 2;
    
    //不需要添加零数据在后面
    for (int i = check_n; i < frame_length; i++)
    {
        byte[i] = bytes[i - check_n];
    }
    
    [datas appendBytes:byte length:frame_length];
    
    return datas;
}

//数据发送函数 frame_start->开始截取位置  frame_len->截取长度 frame_nums->帧序列 frame_length->帧长度  add_0->是否需要添加0
-(void)send_data_add:(int)frame_start :(int)frame_len :(int)frame_nums :(int)frame_length :(BOOL)add_0
{
    //    NSLog(@"data_n - %d data_n_now - %d",data_n,frame_nums);
    //发送数据部分数据
    NSData *device_version = [device_check_crc16 subdataWithRange:NSMakeRange(frame_start,frame_len)];
    
    const unsigned char* bytes = [device_version bytes];
    
    NSMutableData *datas = [[NSMutableData alloc] init];
    
    //本帧长度int frame_length = 18;
    Byte byte[20];
    //将byte元素全置为0
    memset(byte,0x00,sizeof(byte));
    
    byte[0] = frame_nums;
    byte[1] = frame_nums >> 8;
    //从第3位数据开始进行添加数据
    int check_n = 2;
    
    if (add_0)
    {
        //需要添加 0xFF 据在后面
        for (int i = 0; i < frame_len; i++)
        {
            byte[i + check_n] = bytes[i];
        }
        
        for (int i = frame_len; i < frame_length; i++)
        {
            byte[1] = 0xFF;
        }
    }
    else
    {
        //不需要添加零数据在后面
        for (int i = check_n; i < frame_length; i++)
        {
            byte[i] = bytes[i - check_n];
        }
    }
    
    Byte check_byte[16];
    
    for (int i = 0; i < 16; i++)
    {
        check_byte[i] = byte[i + 2];
    }
    
    NSMutableData *check_datas = [[NSMutableData alloc] init];
    [check_datas appendBytes:check_byte length:16];
    
    uint16_t check_crc_page = [self CRC16_page:check_datas];  //加密校验
    
    byte[18] = check_crc_page;
    byte[19] = check_crc_page >> 8;
    
    [datas appendBytes:byte length:20];
    
    //数据发送接口
    [self sendBigData:datas :1];
}

//直接从bin文件中获取数据发送
-(void)the_soft_update_page01_bin:(NSData *)datas
{
    [self sendBigData:datas :0];
}

//升级过程激活命令
-(void)the_update_update_Reply
{
    Byte c1[] = {0x88,0x88,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *datas1 = [NSData dataWithBytes:c1 length:20];
    
    Byte c2[] = {0x88,0x88,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *datas2 = [NSData dataWithBytes:c2 length:20];
    
    [self sendBigData:datas1 :0];
    
    double delayInSeconds = 0.01f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self sendBigData:datas2 :1];
                   });
}

//进行CRC16帧校验
-(uint16_t)CRC16_page:(NSData *)datas
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

//校验文件是否满足68K，补齐68K数据
-(NSData *)check_data_68K:(NSData *)datas
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
-(int)decryption_A5:(int)data_a5
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
-(NSMutableData *)decryption_A5_NsData:(NSData *)a5_data
{
    int lengs = (int)a5_data.length;
    
    const unsigned char* bytes_datas = [a5_data bytes];
    
    Byte buf[lengs];
    
    for (int i = 0;i < lengs; i++)
    {
        buf[i] = [self decryption_A5:bytes_datas[i]];
    }
    
    NSMutableData *datas_ns = [[NSMutableData alloc] init];
    [datas_ns appendBytes:buf length:(lengs)];
    
    return datas_ns;
}

//进行CRC16校验
-(uint16_t)CRC16_1:(NSData *)datas
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
/***************************OAD升级****************************/

//激活
/**
 *  0x0E 激活设备
 */
-(void)the_activate_device
{
//    int checknum = 0x00 ^ 0xA6;
//    Byte c[] = {BLEProtocolHeader01,STW_BLECommand00E,0x05,0x00,checknum};
//    NSData *datas = [NSData dataWithBytes:c length:5];
//    [self sendData:datas];
}

/*
 *检测配置文件是否存在这样的设备
 */
-(Boolean)check_plist_device:(int)device_version
{
    Boolean rmg = YES;
    if (device_version > 0x00) {
        rmg = YES;
    }
    else
    {
        rmg = NO;
    }
    
    return rmg;
}


@end

//
//  TYZ_BLE_Service.m
//
//  Created by 田阳柱 on 16/7/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TYZ_BLE_Service.h"
#import "TYZ_BLE_Device.h"
#import "TYZ_Session.h"
#import <CoreBluetooth/CoreBluetooth.h>

//service的UUID
NSString * const UUIDDeviceService = @"1000";
//从机发送命令UUID
NSString * const UUIDDeviceData = @"1002";
//主机发送命令UUID
NSString * const UUIDDeviceSetup = @"1001";

@interface TYZ_BLE_Service()
{
    //是否有设备正在进行蓝牙连接  YES  - 是  NO - 不是
    Boolean CheckBLEAddStatus;
}

@end


@implementation TYZ_BLE_Service

static TYZ_BLE_Service *shareInstance = nil;

//构造全局单例
+(TYZ_BLE_Service *)sharedInstance
{
    if (!shareInstance)
    {
        shareInstance = [[TYZ_BLE_Service alloc] init];
        //构造蓝牙中心角色
        shareInstance.centralManager = [[CBCentralManager alloc] initWithDelegate:shareInstance queue:nil];
        //扫描设备列表
        shareInstance.scanedDevices = [NSMutableArray array];
        //构建临时缓存数组
        shareInstance.BLE_Device_data_more = [NSMutableData data];
    }
    return shareInstance;
}

//扫描蓝牙的方法
-(void)scanStart
{
    //如果有设备连接断开设备
    if (self.device)
    {
        [self disconnect:self.device.peripheral];
        
        //清空device
        self.device = [[TYZ_BLE_Device alloc] init];
    }
    
    //将设备的连接设置为 断开连接
    [TYZ_Session sharedInstance].check_BLE_status =  1;
    
    //开始扫描 - 没有设备正在请求连接
    CheckBLEAddStatus = NO;
    
    if(self.isReadyScan)
    {
        //初始化设备数组变量
        [self.scanedDevices removeAllObjects];
        
        //开始进行蓝牙扫描
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
//        self.errorHandler(@"蓝牙设备无法访问，请确认蓝牙已经开启？");
    }
}

//时间过长可以让别的设备进行连接
-(void)CheckBLEAddStatusNO
{
    CheckBLEAddStatus = NO;
}

//结束蓝牙扫描
-(void)scanStop
{
    [self.centralManager stopScan];
}

//主动调取蓝牙连接
-(void)connect:(TYZ_BLE_Device *)devices
{
    if (!CheckBLEAddStatus)
    {
        CheckBLEAddStatus = YES;

        self.device = devices;
        devices.peripheral.delegate = self;
        [self.centralManager connectPeripheral:devices.peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
    else
    {
        //2秒之后恢复 - 他人连接可以连接
        [self performSelector:@selector(CheckBLEAddStatusNO) withObject:nil afterDelay:2.0f];
    }
}

//主动断开设备
-(void)disconnect:(CBPeripheral *)peripheral
{
    if (peripheral)
    {
        [self.centralManager cancelPeripheralConnection:peripheral];
        self.device = nil;
    }
}

//向设备发送信息
-(void)sendData:(NSData *)data
{
//    NSLog(@"--向设备发送的信息-->%@",data);
    [self.device.peripheral writeValue:data forCharacteristic:self.device.characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark CBCentralManagerDelegate     -- >  实现蓝牙代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
//            NSLog(@"蓝牙设备设备不支持的状态");
            self.isReadyScan = NO;
            break;
        case CBCentralManagerStateUnauthorized:
//            NSLog(@"蓝牙设备未授权状态");
            self.isReadyScan = NO;
            break;
        case CBCentralManagerStatePoweredOff:
//            NSLog(@"-- > 蓝牙关闭状态");
//            self.errorHandler(@"-- > 蓝牙关闭状态");
            self.isReadyScan = NO;
            break;
        case CBCentralManagerStatePoweredOn:
//            NSLog(@"-- > 蓝牙可用状态");
            self.isReadyScan = YES;
            [self.scanedDevices removeAllObjects];
            [central scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStateUnknown:
//            NSLog(@"手机蓝牙设备未知错误");
            self.isReadyScan = NO;
            break;
        default:
//            NSLog(@"手机蓝牙设备未知错误");
            self.isReadyScan = NO;
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

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
//    NSLog(@"willRestoreState");
}

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
//    NSLog(@"advertisementData - > %@",advertisementData);
    
    NSString *name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    
//    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData *BLEId = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    
    Byte *BLEStrs = (Byte *)[BLEId bytes];
    
    int Ble = 0;
    
    if (BLEStrs != nil)
    {
        if (BLEStrs[0] == 'M' && BLEStrs[1] == 'A' && BLEStrs[2] == 'D')
        {
            //检测到来自MAD的电子烟
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
        TYZ_BLE_Device *BLEDevice = [[TYZ_BLE_Device alloc]init];
        
        BLEDevice.peripheral = peripheral;
        BLEDevice.RSSI = RSSI;
        BLEDevice.advertisementData = advertisementData;
        BLEDevice.deviceName = name;
        BLEDevice.deviceMac = [NSString stringWithFormat:@"%d%d%d%d%d%d",BLEStrs[3],BLEStrs[4],BLEStrs[5],BLEStrs[6],BLEStrs[7],BLEStrs[8]];
        BLEDevice.deviceModel = BLEStrs[9];
        
        int n = 0;
        
        if(self.scanedDevices.count > 0)
        {
            for (int i = 0; i < self.scanedDevices.count; i++)
            {
                TYZ_BLE_Device *BLEDevice_arrrys = [self.scanedDevices objectAtIndex:i];
                if ([BLEDevice.deviceMac isEqualToString:BLEDevice_arrrys.deviceMac])
                {
                    n += 1;
                    break;
                }
            }
        }
        
        if(n == 0)
        {
            //延时发送扫描到了设备数据
            [self.scanedDevices addObject:BLEDevice];
            
            //延时发送扫描到了设备数据
            if(self.scanHandler)
            {
                self.scanHandler(BLEDevice);
            }
        }
    }
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
    //结束蓝牙扫描
    [self scanStop];
    
    //开始发现服务
    [peripheral discoverServices:nil];
    
    //设置连接成功回调
    if(self.connectedHandler)
    {
        self.connectedHandler();
    }
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
    [TYZ_Session sharedInstance].check_BLE_status = 1;
//    NSLog(@"断开的设备: %@-->\n%@", peripheral.name,peripheral);
    //蓝牙断开连接回调
    if(self.disconnectHandler)
    {
        self.disconnectHandler();
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
//    NSLog(@"peripheralDidUpdateRSSI");
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
//    NSLog(@"didReadRSSI--读取设备信号 -- > %@",RSSI);
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
//    NSLog(@"开始设备服务！！！");
//    NSLog(@"获取所有服务UUID：%@",peripheral.services);
    
//    int ChickUUID = 1;
    
    if (error)
    {
//        NSLog(@"设备->%@ 出现错误->%@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services)
    {
        //设备服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceService]])
        {
//            NSLog(@"服务UUID: %@", service.UUID);
            
            [peripheral discoverCharacteristics:nil forService:service];
            
//            ChickUUID = ChickUUID + 1;
        }
    }
//    if(ChickUUID < 2)
//    {
//        NSLog(@"UUID出现错误--->拒绝服务，断开连接！");
//        [[TYZ_BLE_Service sharedInstance] disconnect:peripheral];
//    }
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
    [TYZ_Session sharedInstance].check_BLE_status = 0;
//    NSLog(@"开始设备特征！！！");
//    NSLog(@"特征：%@",service.characteristics);
    if (error)
    {
//        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
//        NSLog(@"特征UUID：%@",characteristic.UUID);
        
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
        }
    }
    if(self.discoverCharacteristicsForServiceHandler)
    {
        //设备刚刚连接设备可以进行初始化查询等操作
        self.discoverCharacteristicsForServiceHandler();
    }
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
//        NSLog(@"接收的数据 - > %@",characteristic.value);
        [self  build_bleData:characteristic.value];
    }
}

- (void)build_bleData:(NSData*)ble_data
{
    NSMutableData *mdata=[[NSMutableData alloc]init];
    mdata = [NSMutableData dataWithData:ble_data];
    
    const unsigned char* bytes = [mdata bytes];
    
    if(bytes[1] < 6)
    {
        int len = (int)mdata.length;
        
        TYZ_BLE_Protocol *protocol;
        
        if (len >= 8)
        {
            int len_8 = len/8;
            
            for (int i = 1; i <= len_8; i++)
            {
                protocol = [[TYZ_BLE_Protocol alloc] init];
                
                NSData *datas1 = [[NSData alloc] init];
                
                datas1 = [ble_data subdataWithRange:NSMakeRange((i - 1) * 8,8)];
                
                //            NSLog(@"datas -- >%@",datas1);
                
                protocol = [TYZ_BLE_Protocol initdata:datas1];
                
                [self parsing_BLEData:protocol];
            }
            //多余数据放入缓存
            NSData *moredata = [ble_data subdataWithRange:NSMakeRange((len_8 * 8),(len - (len_8 * 8)))];
            [[TYZ_BLE_Service sharedInstance].BLE_Device_data_more appendData:moredata];
        }
        else
        {
            //放入缓存
            NSData *moredata = [ble_data subdataWithRange:NSMakeRange(0,len)];
            [[TYZ_BLE_Service sharedInstance].BLE_Device_data_more appendData:moredata];
        }
        //处理缓存数据
        if ([TYZ_BLE_Service sharedInstance].BLE_Device_data_more.length >= 8)
        {
            protocol = [[TYZ_BLE_Protocol alloc] init];
            
            NSData *datas1 = [[NSData alloc] init];
            
            datas1 = [[TYZ_BLE_Service sharedInstance].BLE_Device_data_more subdataWithRange:NSMakeRange(0,8)];
            
            //        NSLog(@"datas -- >%@",datas1);
            
            protocol = [TYZ_BLE_Protocol initdata:datas1];
            
            //释放缓存数据
            [TYZ_BLE_Service sharedInstance].BLE_Device_data_more = [NSMutableData data];
            
            [self parsing_BLEData:protocol];
        }
    }
    else
    {
        switch (bytes[1])
        {
            case 6:
//                NSLog(@"no data back");
                break;
                
            case 7:
                if (self.notifyHandlerD7)
                {
                    NSString *strings = [NSString stringWithFormat:@"%d-%d-%d",(bytes[2]*256 + bytes[3]) ,bytes[4],bytes[5]];
                    int recordNum = bytes[6]*256 + bytes[7];
                    self.notifyHandlerD7(strings,recordNum);
                }
                break;
                
            case 8:
//                NSLog(@"名称设置返回");
                if (self.notifyHandlerD8)
                {
                    int checkNum = bytes[2];
                    
                    if (checkNum == 0x00)
                    {
                        checkNum = 0;
                    }
                    else
                    {
                        checkNum = 1;
                    }
                    
                    self.notifyHandlerD8(checkNum);
                }
                break;
                
            case 9:
            {
                if (bytes[2] == 0xFF)
                {
                    //mdata
                    NSData *DeviceID = [mdata subdataWithRange:NSMakeRange(3,8)];
                    NSString *DeviceID_String = [[NSString alloc] initWithData:DeviceID encoding:NSUTF8StringEncoding];
                    if (self.notifyHandlerD9)
                    {
                        self.notifyHandlerD9(DeviceID_String);
                    }
                }
                else if(bytes[2] == 0xEE)
                {
                    if (self.notifyHandlerD9)
                    {
                        self.notifyHandlerD9(@"ERROR");
                    }
                }
                else if(bytes[2] == 0xFE)
                {
                    if (self.notifyHandlerD9)
                    {
                        self.notifyHandlerD9(@"SUCCESS");
                    }
                }
            }
            
            break;
//            case 10:
//                //                NSLog(@"名称设置返回");
//                if (self.notifyHandlerD10)
//                {
//                    int checkNum = bytes[2];
//                    NSString *strs = @"未知错误";
//                    
//                    switch (checkNum)
//                    {
//                        case 0xEF:
//                            strs = @"设置成功";
//                            break;
//                        case 0xEE:
//                            strs = @"命令错误";
//                            break;
//                        case 0xED:
//                            strs = @"数值不在误差范围内，需要检测";
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    
//                    self.notifyHandlerD10(strs);
//                }
//                break;
                
            default:
                break;
        }
    }
}

//解析蓝牙返回的数据
- (void)parsing_BLEData:(TYZ_BLE_Protocol*)protocol
{
    switch (protocol.intValue)
    {
        case 0:
            if (self.notifyHandlerD0)
            {
                int check_ble = protocol.bleData_byte1;
                self.notifyHandlerD0(check_ble);
            }
            break;
        case 1:
            if (self.notifyHandlerD1)
            {
                int smoke_bools;
                int smoke_actual = protocol.bleData_byte1;
                int smoke_expect = protocol.bleData_byte2;
                
                if (protocol.bleData_byte1 == 0xff && protocol.bleData_byte2 <= 30)
                {
                    smoke_bools = 1;
                     self.notifyHandlerD1(smoke_bools,smoke_actual,smoke_expect);
                }
                else if(protocol.bleData_byte1 != 0xff )
                {
                    smoke_bools = 0;
                     self.notifyHandlerD1(smoke_bools,smoke_actual,smoke_expect);
                }
            }
            break;
        case 2:
            if (self.notifyHandlerD2)
            {
                if (protocol.bleData_byte1 != 0xff)
                {
                    int output_voltage = protocol.bleData_byte1;
                    self.notifyHandlerD2(output_voltage);
                }
            }
            break;
        case 3:
            if (self.notifyHandlerD3)
            {
                if (protocol.bleData_byte1 != 0xff)
                {
                    int battery = protocol.bleData_byte1;
                    int battery_status = protocol.bleData_byte2;
                    self.notifyHandlerD3(battery,battery_status);
                }
            }
            break;
        case 4:
            if (self.notifyHandlerD4)
            {
                int smoke_all_number = protocol.bleData_byte1 * 256 + protocol.bleData_byte2;
                self.notifyHandlerD4(smoke_all_number);
            }
            break;
        case 5:
            if (self.notifyHandlerD5)
            {
                int lock;
                int lock_way;
                if (protocol.bleData_byte1 == 0x00)
                {
                    lock = 0;
                    lock_way = 0;
                }
                else
                {
                    lock = 1;
                    lock_way = protocol.bleData_byte1;
                }
                self.notifyHandlerD5(lock,lock_way);
            }
            break;
        default:
            break;
    }
}

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
//        NSLog(@"发送数据失败->UUID:%@-\n失败数据->%@",characteristic.UUID,characteristic.value);
//    }
//    else
//    {
//        NSLog(@"发送数据成功->UUID:%@-\n成功数据->%@",characteristic.UUID,characteristic.value);
//        NSLog(@"发送数据成功->UUID:%@",characteristic.UUID);
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

@end

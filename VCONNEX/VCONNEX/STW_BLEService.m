//
//  STW_BLEService.m
//  STW_BLE_SDK
//
//  Created by 田阳柱 on 16/4/18.
//  Copyright © 2016年 tyz. All rights reserved.

#import "STW_BLE_SDK.h"
#import "CCTPoint.h"
#import "UIView+MJAlertView.h"

#define VendorId 0x01   //STW

//service的UUID
NSString * const UUIDDeviceService = @"7AAC6AC0-AFCA-11E1-9FEB-0002A5D5C51B";
//update_service的UUID
NSString * const UUIDDeviceUpdateSoftService = @"F000FFC0-0451-4000-B000-000000000000";

//从机发送命令UUID
NSString * const UUIDDeviceData = @"aed04e80-afc9-11e1-a484-0002a5d5c51b";
//主机发送命令UUID
NSString * const UUIDDeviceSetup = @"19575ba0-b20d-11e1-b0a5-0002a5d5c51b";

//发送soft Update第一包数据
NSString * const UUIDDeviceSoftUpdatePage01 = @"F000FFC1-0451-4000-B000-000000000000";
//发送soft Update bin文件数据
NSString * const UUIDDeviceSoftUpdateBinPage = @"F000FFC2-0451-4000-B000-000000000000";

@interface STW_BLEService()
{
    CBCharacteristic *characateristicSoftUpdatePage01;
    CBCharacteristic *characateristicSoftUpdateBinPage;
    
    //检测Service是否正常
    int check_ServiceUUID_nums;
    //检测UUID是否正常
    int check_UUID_nums;
}
@end

@implementation STW_BLEService

static STW_BLEService *shareInstance = nil;

+(STW_BLEService *)sharedInstance
{
    if (!shareInstance)
    {
        shareInstance = [[STW_BLEService alloc] init];
        shareInstance.centralManager = [[CBCentralManager alloc] initWithDelegate:shareInstance queue:nil];
        shareInstance.scanedDevices = [NSMutableArray array];
    }
    return shareInstance;
}

//主动扫描蓝牙
-(void)scanStart
{
    if(self.isReadyScan)
    {
        [self.scanedDevices removeAllObjects];      //初始化设备数组变量
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        [UIView addMJNotifierWithText:@"Please turn on the Bluetooth" dismissAutomatically:YES];
//        if(self.Service_errorHandler)
//        {
//            self.Service_errorHandler(@"蓝牙设备无法访问，请确认蓝牙已经开启？");
//        }
    }
}

//主动停止扫描蓝牙
-(void)scanStop
{
    [self.centralManager stopScan];
}

//主动连接设备
-(void)connect:(STW_BLEDevice *)device
{
    self.device = device;
    device.peripheral.delegate = self;
    [self.centralManager connectPeripheral:device.peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

//主动断开连接
-(void)disconnect
{
//    NSLog(@"------------- 主动断开与蓝牙的连接 -----------------");
    
    if (self.device)
    {
        [self.centralManager cancelPeripheralConnection:self.device.peripheral];
        self.device = nil;
    }
}

//发送少量的数据
-(void)sendData:(NSData *)data
{
    if(self.isBLEStatus || [STW_BLEService sharedInstance].isBLEType != STW_BLE_IsBLETypeOff)
    {
//        NSLog(@"向设备发送的信息1--->%@",data);
        
        if (self.device.characteristic)
        {
            //模式一  读写
            [self.device.peripheral writeValue:data forCharacteristic:self.device.characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
    else
    {
//        NSLog(@"Please connect Bluetooth");
        [UIView addMJNotifierWithText:@"Please Connect Bluetooth" dismissAutomatically:YES];
    }
}

//发送大量的数据
-(void)sendBigData:(NSData *)data :(int)type
{
    if (type == 0)
    {
        if (characateristicSoftUpdatePage01)
        {
//            NSLog(@"向设备发送的信息2--->%@",data);
//             NSLog(@"向设备发送的信息--->%@\n%@",data,characateristicSoftUpdatePage01);
            //模式二  只写不读 - 发送第一包数据
            [self.device.peripheral writeValue:data forCharacteristic:characateristicSoftUpdatePage01 type:CBCharacteristicWriteWithoutResponse];
        }
        
    }
    else if (type == 1)
    {
        if(characateristicSoftUpdateBinPage)
        {
//            NSLog(@"向设备发送的信息3--->%@",data);
//             NSLog(@"向设备发送的信息--->%@\n%@",data,characateristicSoftUpdateBinPage);
            //模式二  只写不读 - 发送bin文件数据
            [self.device.peripheral writeValue:data forCharacteristic:characateristicSoftUpdateBinPage type:CBCharacteristicWriteWithoutResponse];
        }
    }
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

//- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
//{
//    //    NSLog(@"willRestoreState");
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
//        NSLog(@"didRetrievePeripherals");
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
//    NSLog(@"扫描到的设备 - > %@",advertisementData);
    
    NSString *name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData *BLEId = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    
    Byte *BLEStrs = (Byte *)[BLEId bytes];
    
    int Ble = 0;
    
    if (BLEStrs != nil)
    {
        if (BLEStrs[0] == 'S' && BLEStrs[1] == 'M' && BLEStrs[2] == 'R')
        {
            //检测到来自SMR的电子烟
            Ble = 1;
        }
        else
        {
            Ble = 0;
        }
    }
    
    if (Ble == 1 && name != nil)
    {
//        NSLog(@"扫描到的设备 - > %@",advertisementData);
        
        //将获取所有外围蓝牙设备数据封装到扫描列表
        STW_BLEDevice *BLEDevice = [[STW_BLEDevice alloc]init];
        BLEDevice.peripheral = peripheral;
        BLEDevice.RSSI = RSSI;
        BLEDevice.advertisementData = advertisementData;
        BLEDevice.deviceName = name;
        BLEDevice.deviceMac = [NSString stringWithFormat:@"%d%d%d%d%d%d%d",BLEStrs[3],BLEStrs[4],BLEStrs[5],BLEStrs[6],BLEStrs[7],BLEStrs[8],VendorId];
        BLEDevice.deviceModel = BLEStrs[9];
        
        [self.scanedDevices addObject:BLEDevice];
        
        //延时发送扫描到了设备数据
        if(self.Service_scanHandler)
        {
            self.Service_scanHandler(BLEDevice);
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
    if(self.Service_connectedHandler)
    {
        self.Service_connectedHandler();
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
    //设置蓝牙状态为断开
    //[TYZ_Session sharedInstance].check_BLE_status = 1;
    //    NSLog(@"断开的设备: %@-->\n%@", peripheral.name,peripheral);
    if([STW_BLE_SDK STW_SDK].Update_Now == 1)
    {
        if (self.Service_Soft_Update)
        {
            self.Service_Soft_Update(0xEE);
        }
    }
    
    switch (self.isBLEDisType)
    {
        case STW_BLE_IsBLEDisTypeScanRoot:
        {
            //蓝牙断开连接回调
            if(self.Service_disconnectHandlerRoot)
            {
                self.Service_disconnectHandlerRoot();
            }
        }
            
            break;
            
        case STW_BLE_IsBLEDisTypeScan:
        {
            //蓝牙断开连接回调
            if(self.Service_disconnectHandlerScan)
            {
                self.Service_disconnectHandlerScan();
            }
        }
            
            break;
            
        case STW_BLE_IsBLEDisTypeOn:
        {
            //蓝牙断开连接回调
            if(self.Service_disconnectHandlerOn)
            {
                self.Service_disconnectHandlerOn();
            }
        }
            
            break;
            
        default:
            break;
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
    
    int ChickUUID = 1;
    
    check_ServiceUUID_nums = 0;
    check_UUID_nums = 0;
    
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
            [peripheral discoverCharacteristics:nil forService:service];
            
            ChickUUID = ChickUUID + 1;
        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceUpdateSoftService]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
            ChickUUID = ChickUUID + 1;
        }
    }
    
    if(ChickUUID != 3)
    {
//        NSLog(@"UUID出现错误--->拒绝服务，断开连接！");
        [self disconnect];
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
    //蓝牙对接成功 蓝牙状态改为已经连接
//    [TYZ_Session sharedInstance].check_BLE_status = 0;
    if (error)
    {
//        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
//     NSLog(@"service.characteristics - %@",service.characteristics);
    
    check_ServiceUUID_nums += 1;

    for (CBCharacteristic *characteristic in service.characteristics)
    {
//        NSLog(@"characteristic.UUID - %@",characteristic.UUID);
        
        //接收数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceData]])
        {
            check_UUID_nums += 1;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        //发送数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSetup]])
        {
            check_UUID_nums += 1;
            [peripheral readValueForCharacteristic:characteristic];
            self.device.characteristic = characteristic;
        }
        //发送soft Update第一包数据
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSoftUpdatePage01]])
        {
            check_UUID_nums += 1;
            characateristicSoftUpdatePage01 = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
        //发送soft Update bin文件数据
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUIDDeviceSoftUpdateBinPage]])
        {
            check_UUID_nums += 1;
            characateristicSoftUpdateBinPage = characteristic;
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
    
    if (check_ServiceUUID_nums == 2 && check_UUID_nums == 4)
    {
        if(self.Service_discoverCharacteristicsForServiceHandler)
        {
            //设备刚刚连接设备可以进行初始化查询等操作
            self.Service_discoverCharacteristicsForServiceHandler();
        }
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

//开始解析数据
- (void)build_bleData:(NSData*)ble_data
{
    //接收到的数据部分，数据加密在此解密
    NSMutableData *mdata=[[NSMutableData alloc]init];
    mdata = [NSMutableData dataWithData:ble_data];
    
    const unsigned char* bytes = [mdata bytes];
    
    if (bytes[0] == BLEProtocolHeader01)
    {
        //命令解析
        switch (bytes[1])
        {
            case STW_BLECommand000:           //返回是否匹配成功
            {
                if(bytes[3] == 0xFE)
                {
                    if (self.Service_DeviceCheck)
                    {
                        self.Service_DeviceCheck(bytes[3]);
                    }
                }
                else
                {
//                    NSLog(@"Identification error device - disconnect");
                    [self disconnect];
                }
            }
                break;
            case STW_BLECommand001:           //返回所有配置信息
            {
                if (bytes[3] == 0xFF)
                {
                    //返回所有配置信息
                    
                    //电池电量 bytes[4] - 返回电池信息回调
                    if (self.Service_Battery)
                    {
                        self.Service_Battery(bytes[4]);
                    }
                    
                    if(self.Service_AtomizerData)
                    {
                        int atomizerNum = bytes[9] * 256 + bytes[10];
                        int atomizerMold = bytes[11];
                        self.Service_AtomizerData(atomizerNum,atomizerMold);
                    }
                    
                    //工作模式
                    switch (bytes[5])
                    {
                        case BLEProtocolModeTypePower:
                        {
                            int power = bytes[6] * 256 + bytes[7];
                            
                            if (self.Service_Power)
                            {
                                self.Service_Power(power);
                            }
                        }
                            break;
                            
                        case BLEProtocolModeTypeTemperature:
                        {
                            int tempNum = bytes[6] * 256 + bytes[7];
                            int tempMold = bytes[8];
                            
                            if (self.Service_Temp)
                            {
                                self.Service_Temp(tempNum,tempMold);
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            break;
                
            case STW_BLECommand002:           //设置系统时间
            {
              if(bytes[3] == 0xFE)
              {
                  if (self.Service_SetTime)
                  {
                      self.Service_SetTime(0x01);
                  }
              }
            }
            break;
                
            case STW_BLECommand003:           //查询、设置工作模式
            {
                if (bytes[3] == 0xFF || bytes[3] ==0xFE)
                {
                    if(self.Service_AtomizerData)
                    {
                        int atomizerNum = [STW_BLE_SDK STW_SDK].atomizer;
                        int atomizerMold = bytes[8];
                        self.Service_AtomizerData(atomizerNum,atomizerMold);
                    }
                    
                    switch (bytes[4])
                    {
                        case BLEProtocolModeTypePower:
                        {
                            int power = bytes[5] * 256 + bytes[6];

                            if (self.Service_Power)
                            {
                                self.Service_Power(power);
                            }
                        }
                            break;
                            
                        case BLEProtocolModeTypeTemperature:
                        {
                            int tempNum = bytes[5] * 256 + bytes[6];
                            int tempMold = bytes[7];
                            
                            if (self.Service_Temp)
                            {
                                self.Service_Temp(tempNum,tempMold);
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                else
                {
                    [STW_BLE_Protocol the_find_work_mode];
                }
            }
            break;
                
            case STW_BLECommand004:           //查询、设置TCR雾化器信息
            {
                if (bytes[3] == 0xFF)
                {
                    int ChangeRate_Ni = bytes[4]*256 + bytes[5];
                    int ChangeRate_Ss = bytes[6]*256 + bytes[7];
                    int ChangeRate_Ti = bytes[8]*256 + bytes[9];
                    int ChangeRate_TCR = bytes[10]*256 + bytes[11];
                    
                    if(self.Service_TCRData)
                    {
                        self.Service_TCRData(ChangeRate_Ni,ChangeRate_Ss,ChangeRate_Ti,ChangeRate_TCR);
                    }
                }
                else if(bytes[3] == 0xFE)
                {
//                    NSLog(@"设置成功");
                    if(self.Service_TCRData)
                    {
                        self.Service_TCRData(-1,-1,-1,-1);
                    }
                }
            }
            break;
                
            case STW_BLECommand005:           //查询、传输电池电量
            {
                if (bytes[3] == 0x00 || bytes[3] == 0xFF)
                {
                    if (self.Service_Battery)
                    {
                        self.Service_Battery(bytes[4]);
                    }
                }
            }
            break;
                
            case STW_BLECommand006:           //传输雾化器阻值
            {
                if (bytes[3] == 0x00)
                {
                    int resistance = bytes[4] * 256 + bytes[5];
                    int atomizerMold =  bytes[6];
                    
                    if (self.Service_AtomizerData)
                    {
                        self.Service_AtomizerData(resistance,atomizerMold);
                    }
                }
            }
                
            case STW_BLECommand007:           //查询、设置CCT温度补偿
            {
                if (bytes[3] == 0xFF)
                {
                    NSMutableArray *CCTArrys = [NSMutableArray array];
                    
                    for (int i = 0; i < 11; i++)
                    {
                        CCTPoint *cctPoint = [[CCTPoint alloc] init];
                        cctPoint.point_x = i;
                        cctPoint.point_y = (bytes[i + 4]/10);
                        
                        [CCTArrys addObject:cctPoint];
                    }
                    
                    if (self.Service_CCTData)
                    {
                        self.Service_CCTData(CCTArrys);
                    }
                }
                else if(bytes[3] == 0xFE)
                {
                    if (self.Service_CCTData)
                    {
                        self.Service_CCTData(nil);
                    }
                }
            }
            break;
                
            case STW_BLECommand008:           //查询、设置按键进步信息
            {
                if (bytes[3] == 0xFF)
                {
                    //按键次数
                    int keys_num = bytes[4];
                    
                    if (self.Service_SetKeyNums)
                    {
                        self.Service_SetKeyNums(keys_num);
                    }
                }
                else if(bytes[3] == 0xFE)
                {
                    if (self.Service_SetKeyNums)
                    {
                        self.Service_SetKeyNums(-1);
                    }
                }
            }
            break;
                
            case STW_BLECommand009:           //传输电子烟提醒状态
            {
                if(bytes[3] == 0x00)
                {
                    if (bytes[4] == 0x07)
                    {
                        int Atomizer_old = bytes[5] * 256 + bytes[6];
                        int Atomizer_new = bytes[7] * 256 + bytes[8];

                        if (self.Service_AtomizerNew)
                        {
                            self.Service_AtomizerNew(Atomizer_old,Atomizer_new);
                        }
                    }
                    else
                    {
                        if (self.Service_VaporStatus)
                        {
                            self.Service_VaporStatus(bytes[4]);
                        }
                    }
                }
                else if(bytes[3] == 0xFE)
                {
                    if (self.Service_VaporStatus)
                    {
                        self.Service_VaporStatus(bytes[4]);
                    }
                }
            }
            break;
                
            case STW_BLECommand00A:           //激活、传输设备信息
            {
                if (bytes[3] == 0x00)
                {
                    if (self.Service_Activity)
                    {
                        self.Service_Activity(bytes[4]);
                    }
                }
            }
            break;
                
            case STW_BLECommand00B:           //无线升级
            {
                if (bytes[3] == 0)
                {
                    int pageNum = bytes[4] * 256 + bytes[5];
                    
                    if (self.Service_Soft_Update)
                    {
                        self.Service_Soft_Update(pageNum);
                    }
                }
                else if (bytes[3] == 0x88)
                {
                    //升级成功
                    if (self.Service_Soft_Update)
                    {
                        self.Service_Soft_Update(0x88);
                    }
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
                    
                    if (self.Service_Soft_Update)
                    {
                        self.Service_Soft_Update(checkNums);
                    }
                }
                else if(bytes[3] == 0xE8)
                {
                    int lost_page = bytes[4] * 256 + bytes[5];
                    //记录所丢失包数
                    [[STW_BLE_SDK STW_SDK].softUpdate_lostPage addObject:[NSString stringWithFormat:@"%d",lost_page]];
                }
                else if(bytes[3] == 0xF0)
                {
                    //发送一共丢失了多少包
                    int lowPage = bytes[4] * 256 + bytes[5];
                    
                    if(lowPage == [STW_BLE_SDK STW_SDK].softUpdate_lostPage.count)
                    {
                        if (self.Service_Soft_Update)
                        {
                            self.Service_Soft_Update(0xE8);
                        }
                    }
                }
                else if(bytes[3] == 0x87)
                {
                    //数据全部发送成功
                    if (self.Service_Soft_Update)
                    {
                        self.Service_Soft_Update(0x87);
                    }
                }
            }
            break;
                
            case STW_BLECommand00C:           //设备信息、软件硬件版本
            {
                if (bytes[3] == 0xFF)
                {
                    if (self.Service_Find_DeviceData)
                    {
                        int Device_Version = bytes[4] * 256 + bytes[5];
                        int Soft_Version = bytes[6] * 256 + bytes[7];
                        self.Service_Find_DeviceData(Device_Version,Soft_Version);
                    }
                }
            }
                break;
                
            case STW_BLECommand00D:           //锁定、解锁雾化器 锁定 – 0x00 / 解锁 – 0x01
            {
                if (bytes[3] == 0xFF)
                {
                    if (self.Service_AtomizerLock)
                    {
                        self.Service_AtomizerLock(bytes[4],(bytes[5] * 256 + bytes[6]));
                    }
                }
                else if(bytes[3] == 0xFE)
                {
                    if (self.Service_AtomizerLock)
                    {
                        int check_num = bytes[4] + 2;
                        self.Service_AtomizerLock(check_num,(bytes[5] * 256 + bytes[6]));
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
//        NSLog(@"帧头错误不做任何响应 接收数据 -> %@",mdata);
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

@end

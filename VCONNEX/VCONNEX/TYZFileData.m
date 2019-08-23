//
//  TYZFileData.m
//  uVapour
//
//  Created by 田阳柱 on 16/9/21.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TYZFileData.h"
#import <objc/runtime.h>

@implementation TYZFileData

//保存用户设备信息
+(int)SaveDeviceData:(NSMutableArray *)deviceArray
{
    int check_num = 0;
    
    NSString *plistPath = [self getSaveFilePash:@"device.plist"];
    
    NSMutableDictionary *dictplist = [[NSMutableDictionary alloc] init];
    
    NSArray *dictDeviceArray = [fileDevice mj_keyValuesArrayWithObjectArray:deviceArray];
    
//    NSLog(@"dictDeviceArray - %@",dictDeviceArray);
    
    NSString *deviceDictarry = @"DeviceArray";
    
    //设置属性值
    [dictplist setObject:dictDeviceArray forKey:deviceDictarry];
    
    //写入文件
    [dictplist writeToFile:plistPath atomically:YES];
    
    return check_num;
}

//获取本地缓存的用户设备信息
+(NSMutableArray *)GetDeviceData
{
    //获取绝对路径 user.plist
    NSString *plistPath = [self getSaveFilePash:@"device.plist"];
    
    //根据路径获取device.plist的全部内容
    NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] mutableCopy];
    
    //获取信息
    NSString *deviceDictarry = @"DeviceArray";
    
    NSMutableDictionary *dictDeviceArray = [infolist objectForKey:deviceDictarry];
    
    // 将字典数组转为Device模型数组
    NSMutableArray *deviceArray = [fileDevice mj_objectArrayWithKeyValuesArray:dictDeviceArray];
    
    return deviceArray;
}

//返回文件缓存目录
+(NSString *)getSaveFilePash:(NSString *)fileName
{
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return plistPath;
}

@end

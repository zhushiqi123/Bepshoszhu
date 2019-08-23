//
//  STW_Data_Plist.m
//  PAX3
//
//  Created by tyz on 17/5/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "STW_Data_Plist.h"
#import <objc/runtime.h>

@implementation STW_Data_Plist

//保存用户设备信息
+(int)SaveDeviceData:(NSMutableArray *)deviceArray
{
    int check_num = 0;
    
    NSString *plistPath = [self getSaveFilePash:@"device.plist"];
    
    NSMutableDictionary *dictplist = [[NSMutableDictionary alloc] init];
    
    NSArray *dictDeviceArray = [STW_DeviceData mj_keyValuesArrayWithObjectArray:deviceArray];
    
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
    NSMutableArray *deviceArray = [STW_DeviceData mj_objectArrayWithKeyValuesArray:dictDeviceArray];
    
    return deviceArray;
}

//保存用户设置的温度单位信息
+(int)SaveTempModelData:(int)temp_model
{
    int check_num = 0;
    
    NSString *plistPath = [self getSaveFilePash:@"temp_model.plist"];
    
    NSMutableDictionary *dictplist = [[NSMutableDictionary alloc] init];
    
    NSString *temp_model_str = [NSString stringWithFormat:@"%d",temp_model];
    
    //    NSLog(@"dictDeviceArray - %@",dictDeviceArray);
    
    NSString *temp_modelStr = @"temp_model";
    
    //设置属性值
    [dictplist setObject:temp_model_str forKey:temp_modelStr];
    
    //写入文件
    [dictplist writeToFile:plistPath atomically:YES];
    
    return check_num;
}

//获取用户设置的温度单位信息
+(int)GetTempModelData
{
    //获取绝对路径 user.plist
    NSString *plistPath = [self getSaveFilePash:@"temp_model.plist"];
    
    //根据路径获取device.plist的全部内容
    NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] mutableCopy];
    
    //获取信息
    NSString *temp_modelStr = @"temp_model";
    
    NSString *temp_model = [infolist objectForKey:temp_modelStr];
    
    if (temp_model == NULL || [temp_model isEqualToString:@""]) {
        temp_model = @"1";
    }
    
    return [temp_model intValue];
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

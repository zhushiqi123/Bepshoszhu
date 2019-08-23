//
//  TYZFileData.h
//  uVapour
//
//  Created by 田阳柱 on 16/9/21.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fileDevice.h"
#import "MJExtension.h"

@interface TYZFileData : NSObject

//保存用户设备信息
+(int)SaveDeviceData:(NSMutableArray *)deviceArray;

//获取本地缓存的用户设备信息
+(NSMutableArray *)GetDeviceData;

@end

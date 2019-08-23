//
//  fileDevice.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/26.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileDevice : NSObject

@property (nonatomic,copy) NSString *deviceName;               //设备名字
@property (nonatomic,copy) NSString *deviceMac;                //设备mac地址

@end

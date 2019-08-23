//
//  STW_PAXChooseViewModel.h
//  PAX3
//
//  Created by tyz on 17/5/11.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STW_PAXChooseViewModel : NSObject

@property (nonatomic,copy) NSString *imageStr;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,copy) NSString *device_mac;

@property (nonatomic,assign) BOOL connectStatus;
@property (nonatomic,assign) int device_model;

@end

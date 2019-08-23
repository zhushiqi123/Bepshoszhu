//
//  softUpdateBean.h
//  uVapour
//
//  Created by 田阳柱 on 16/10/8.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface softUpdateBean : NSObject

@property (assign,nonatomic) int id;

@property (copy,nonatomic) NSString *softId;
@property (copy,nonatomic) NSString *mainId;
@property (copy,nonatomic) NSString *deviceId;
@property (copy,nonatomic) NSString *updatePath;
@property (copy,nonatomic) NSString *devieName;
@property (copy,nonatomic) NSString *softName;
@property (copy,nonatomic) NSString *vendor;
@property (copy,nonatomic) NSString *binname;
@property (copy,nonatomic) NSString *md5;

@property (retain,nonatomic) NSNumber *updateTime;

@end

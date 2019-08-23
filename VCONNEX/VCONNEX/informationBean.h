//
//  informationBean.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/31.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface informationBean : NSObject

@property (copy,nonatomic) NSString *createTime;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSNumber *id;
//@property (retain,nonatomic) NSString *description;
@property (copy,nonatomic) NSString *filePath;

@end

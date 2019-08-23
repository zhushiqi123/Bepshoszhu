//
//  AreaObject.m
//  Wujiang
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
#import "AreaObject.h"

@implementation AreaObject

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ %@ %@ %@",self.region,self.province,self.city,self.area];
}

@end

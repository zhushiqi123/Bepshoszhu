//
//  RCTConvert+Animation.m
//  AwesomeProject
//
//  Created by 朱世琦 on 17/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+Animation.h"

@implementation RCTConvert (Animation)
+(valueconfigConnection)valueConfigStructConnection:(id)json{
    json= [self NSDictionary:json]; // 将字典保存在了结构体中
    NSString   * min=  [json objectForKey:@"minValue"];  //最小值
    CGFloat  minvalue= [min floatValue];
    NSString   * max=  [json objectForKey:@"maxValue"]; // 最大值
    CGFloat  maxvalue= [max floatValue];
    NSString   * startAngle=  [json objectForKey:@"startAngle"]; //开始的角度
    CGFloat  startAngleF= [startAngle floatValue];
    NSString   * sweepAngle=  [json objectForKey:@"sweepAngle"]; //绘制的角度
    CGFloat  sweepAngleF= [sweepAngle floatValue];
    NSString   * unit = [json  objectForKey:@"unit"]; //要显示的单位
    NSString * format= [json  objectForKey:@"format"]; // 显示的格式
    NSString  * msenction= [json objectForKey:@"mSection"]; // 需要分割的数量
    CGFloat  msectionF= [msenction floatValue];
    NSString  * defaultValue= [json objectForKey:@"defaultValue"]; // 需要分割的数量
    CGFloat  defaultValueF= [defaultValue floatValue];
    
    
    //  NSLog(@"deom结构体中的值%f",maxvalue);
    return (valueconfigConnection){ maxvalue,minvalue,startAngleF ,sweepAngleF, unit,format, msectionF,defaultValueF};
}

@end

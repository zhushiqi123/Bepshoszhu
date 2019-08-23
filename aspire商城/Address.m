//
//  Address.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Address.h"
#import "NSDictionary+Stwid.h"
@implementation Address

+(Address *)initdata:(id)data{
    Address *obj = [[Address alloc]init];
//    obj.consignee = [data stringForKey:@"consignee"];
//    obj.email = [data stringForKey:@"email"];
    obj.country = [data intForKey:@"country"];
    obj.province = [data intForKey:@"province"];
    obj.city = [data intForKey:@"city"];
    obj.district = [data intForKey:@"district"];
//    obj.addressa = [data stringForKey:@"addressa"];
//    obj.zipcode = [data stringForKey:@"zipcode"];
//    obj.mobile = [data stringForKey:@"mobile"];
//    obj.best_time = [data stringForKey:@"best_time"];
    
    return obj;
}

@end

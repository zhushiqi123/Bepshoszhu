//
//  ShopCars.m
//  aspire商城
//
//  Created by tyz on 16/1/4.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "ShopCars.h"
#import "NSDictionary+Stwid.h"
@implementation ShopCars

+(ShopCars *)initdata:(id)data
{
    ShopCars *obj = [[ShopCars alloc]init];

    obj.num = [data intForKey:@"num"];
    obj.goods_id = [data intForKey:@"goods_id"];
    obj.goods_name = [data stringForKey:@"goods_name"];
    obj.price = [data stringForKey:@"price"];
    obj.good_price = [data floatForKey:@"good_price"];
    obj.attribute_id = [data stringForKey:@"attribute_id"];
    obj.attribute_price = [data stringForKey:@"attribute_price"];
    obj.allPrices = [data stringForKey:@"allPrices"];
    return obj;
}

@end

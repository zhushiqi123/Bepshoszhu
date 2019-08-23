//
//  HomeAGoods.m
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "HomeAGoods.h"
#import "NSDictionary+Stwid.h"
@implementation HomeAGoods

+(HomeAGoods *)initdata:(id)data
{
    HomeAGoods *obj = [[HomeAGoods alloc]init];
    obj.id = [data intForKey:@"id"];
    obj.title = [data stringForKey:@"title"];
    obj.goods_id = [data intForKey:@"goods_id"];
    obj.sort = [data intForKey:@"sort"];
    obj.image = [data stringForKey:@"image"];
    obj.url = [data stringForKey:@"url"];
    obj.date = [data stringForKey:@"date"];
    obj.goods_name = [data stringForKey:@"goods_name"];
    obj.goods_sn = [data stringForKey:@"goods_sn"];
    obj.market_price = [data floatForKey:@"market_price"];
    obj.shop_price = [data floatForKey:@"shop_price"];
    obj.image_140 = [data stringForKey:@"image_140"];
    return obj;
}

@end

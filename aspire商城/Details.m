//
//  Details.m
//  aspire商城
//
//  Created by tyz on 15/12/19.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Details.h"
#import "NSDictionary+Stwid.h"

@implementation Details

+(Details *)initdata:(id)data
{
    Details *obj = [[Details alloc]init];
    obj.goods_id = [data intForKey:@"goods_id"];
    obj.goods_sn = [data stringForKey:@"goods_sn"];
    obj.goods_name = [data stringForKey:@"goods_name"];
    obj.price = [data stringForKey:@"price"];
    return obj;
}

@end

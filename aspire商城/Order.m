//
//  Order.m
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Order.h"
#import "NSDictionary+Stwid.h"
@implementation Order

+(Order *)initdata:(id)data{
    Order *obj = [[Order alloc]init];
    obj.goods_id = [data stringForKey:@"goods_id"];
    obj.goods_quantity = [data stringForKey:@"goods_quantity"];
    obj.shipping_id = [data intForKey:@"shipping_id"];
    obj.attribute_id = [data stringForKey:@"attribute_id"];
    obj.address_id = [data intForKey:@"address_id"];
    obj.pay_id = [data intForKey:@"pay_id"];
    return obj;
}

@end

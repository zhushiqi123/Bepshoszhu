//
//  Order.h
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property(nonatomic,assign) NSString *goods_id;
@property(nonatomic,assign) NSString *goods_quantity;
@property(nonatomic,assign) int shipping_id;
@property(nonatomic,assign) NSString *attribute_id;
@property(nonatomic,assign) int address_id;
@property(nonatomic,assign) int pay_id;

+(Order *)initdata:(id)data;

@end

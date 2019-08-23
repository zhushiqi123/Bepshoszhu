//
//  ShopCars.h
//  aspire商城
//
//  Created by tyz on 16/1/4.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCars : NSObject

@property(nonatomic,assign) int num;
@property(nonatomic,assign) int goods_id;
@property(nonatomic,assign) NSString *goods_name;
@property(nonatomic,assign) NSString *price;
@property(nonatomic,assign) float good_price;

@property(nonatomic,assign) NSString *attribute_id; //配件id
@property(nonatomic,assign) NSString *attribute_price; //配件价格
@property(nonatomic,assign) NSString *allPrices;

+(ShopCars *)initdata:(id)data;
@end

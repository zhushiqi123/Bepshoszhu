//
//  HomeAGoods.h
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeAGoods : NSObject

@property(nonatomic,assign) int id;
@property(nonatomic,assign) NSString *title;
@property(nonatomic,assign) int goods_id;
@property(nonatomic,assign) int sort;
@property(nonatomic,assign) NSString *image;
@property(nonatomic,assign) NSString *url;
@property(nonatomic,assign) NSString *date;
@property(nonatomic,assign) NSString *goods_name;
@property(nonatomic,assign) NSString *goods_sn;
@property(nonatomic,assign) float market_price;
@property(nonatomic,assign) float shop_price;
@property(nonatomic,assign) NSString *image_140;

+(HomeAGoods *)initdata:(id)data;
@end

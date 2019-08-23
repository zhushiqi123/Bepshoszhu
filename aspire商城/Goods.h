//
//  Goods.h
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StwClient.h"
#import "Keys.h"

@interface Goods : NSObject

//获取首页焦点图
+(void)banner_index:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品分类
+(void)category_index:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品列表
+(void)product_index:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品详情
+(void)product_detail:(int)goodsId success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//产品搜索
+(void)product_search:(NSString *)keyword success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//产品检查修改
+(void)product_checkupdate:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品评论
+(void)product_reviews:(int)goodsId success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品推荐
+(void)product_category:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取产品热卖
+(void)product_category2:(void (^)(id))success failure:(void (^)(NSString *))failure;

@end

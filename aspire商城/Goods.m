//
//  Goods.m
//  aspire商城
//
//  Created by tyz on 15/12/16.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Goods.h"

@implementation Goods

//获取首页焦点图
+(void)banner_index:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"banner"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"banner/index?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品分类
+(void)category_index:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"category"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"category/index?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品列表
+(void)product_index:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/index?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品详情
+(void)product_detail:(int)goodsId success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/detail?token=%@",token] parameters:@{@"id":@(goodsId)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//产品搜索
+(void)product_search:(NSString *)keyword success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/search?token=%@",token] parameters:@{@"keyword":keyword} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//产品检查修改
+(void)product_checkupdate:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/checkupdate?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品评论
+(void)product_reviews:(int)goodsId success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/reviews?token=%@",token] parameters:@{@"id":@(goodsId)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品推荐
+(void)product_category:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/category?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//获取产品推荐2
+(void)product_category2:(void (^)(id))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"product"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"product/category?token=%@&type=1&limit=10",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

@end

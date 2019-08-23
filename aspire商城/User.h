//
//  User.h
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "User.h"
#import "Order.h"

@interface User : NSObject

@property(nonatomic,assign) int userid;
@property(nonatomic,assign) NSString *accesskey;
@property(nonatomic,assign) NSString *username;
@property(nonatomic,assign) NSString *password;
@property(nonatomic,assign) NSString *email;
@property(nonatomic,assign) int sex;
@property(nonatomic,assign) NSString *birthday;
@property(nonatomic,assign) NSString *msn;
@property(nonatomic,assign) NSString *qq;
@property(nonatomic,assign) NSString *phone;
@property(nonatomic,assign) NSString *office_phone;
@property(nonatomic,assign) NSString *home_phone;

+(User *)initdata:(id)data;

//用户登录
+(void)login:(NSString *)username :(NSString *)password success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//用户注册
+(void)regist:(NSString *)username :(NSString *)password :(NSString *)email success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//获取地区
+(void)getAddress:(void (^)(id))success failure:(void (^)(NSString *))failure;

//退出登录
+(void)outLogin:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取用户信息
+(void)account_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取用户地址
+(void)address_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户密码修改
+(void)account_updatepwd:(NSString *)accesskey :(NSString *)oldpassword :(NSString *)password1 :(NSString *)password2 success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户信息修改
+(void)account_update:(NSString *)accesskey :(int)sex :(NSString *)birthday :(NSString *)msn :(NSString *)qq :(NSString *)phone :(NSString *)office_phone :(NSString *)home_phone success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户地址添加
+(void)address_add:(NSString *)accesskey :(Address *)address :(NSString *)consignee :(NSString *)email :(NSString *)addressa :(NSString *)zipcode :(NSString *)mobile :(NSString *)best_time success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户地址修改
+(void)address_update:(NSString *)accesskey :(int)addressId :(Address *)address :(NSString *)consignee :(NSString *)email :(NSString *)addressa :(NSString *)zipcode :(NSString *)mobile :(NSString *)best_time success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取用户地址详情
+(void)address_detail:(NSString *)accesskey :(int)addressId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户地址删除
+(void)address_delete:(NSString *)accesskey :(int)addressId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户添加产品评论
+(void)reviews_add:(NSString *)accesskey :(int)goodsId :(NSString *)content :(int)comment_rank success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取用户订单
+(void)order_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取用户订单详情
+(void)order_detail:(NSString *)accesskey :(int)orderId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//用户订单提交
+(void)order_submit:(NSString *)accesskey :(Order *)order success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取运费
+(void)order_get_shipping_fee:(NSString *)accesskey :(NSString *)goods_id :(NSString *)goods_quantity :(int)shipping_id success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取支付方式
+(void)common_payment:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取运输方式
+(void)common_shipping:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//获取运输地址
+(void)common_region:(void (^)(NSString *))success failure:(void (^)(NSString *))failure;

//防伪查询
+(void)common_security_code:(NSString *)code :(void (^)(NSString *))success failure:(void (^)(NSString *))failure;
@end

//
//  User.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "User.h"
#import "StwClient.h"
#import "Keys.h"
#import "NSDictionary+Stwid.h"
@implementation User

+(User *)initdata:(id)data
{
    User *obj = [[User alloc]init];
    obj.userid = [data intForKey:@"userid"];
    obj.accesskey = [data stringForKey:@"accesskey"];
    obj.username = [data stringForKey:@"username"];
    obj.password = [data stringForKey:@"password"];
    obj.email = [data stringForKey:@"email"];
    obj.sex = [data intForKey:@"sex"];
    obj.birthday = [data stringForKey:@"birthday"];
    obj.msn = [data stringForKey:@"msn"];
    obj.qq = [data stringForKey:@"qq"];
    obj.phone = [data stringForKey:@"phone"];
    obj.office_phone = [data stringForKey:@"office_phone"];
    obj.home_phone = [data stringForKey:@"home_phone"];
    return obj;
}
//用户注册
+(void)regist:(NSString *)username :(NSString *)password :(NSString *)email success:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"account/register?token=%@",token] parameters:@{@"username":username,@"password":password,@"email":email} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         failure([operation responseString]);
     }];
}

//用户登录
+(void)login:(NSString *)username :(NSString *)password success:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"account/login?token=%@",token] parameters:@{@"username":username,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         success(responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"返回的数据-->%@",operation);
//         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
    }];
}

//获取地区
+(void)getAddress:(void (^)(id))success failure:(void (^)(NSString *))failure
{
    NSString *token = @"common";
    [[StwClient sharedInstance] GET:@"common/region" parameters:@{@"token":token} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
//         NSLog(@"-->error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//退出登录
+(void)outLogin:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"account/logout?token=%@",token] parameters:@{@"accesskey":accesskey} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

////获取用户信息
+(void)account_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/account/index?token=%@",token] parameters:@{@"accesskey":accesskey} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取用户地址
+(void)address_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"address"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/address/index?token=%@",token] parameters:@{@"accesskey":accesskey} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户密码修改
+(void)account_updatepwd:(NSString *)accesskey :(NSString *)oldpassword :(NSString *)password1 :(NSString *)password2 success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/account/updatepwd?token=%@&accesskey=%@",token,accesskey] parameters:@{@"oldpassword":oldpassword,@"password1":password1,@"password2":password2} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户信息修改
+(void)account_update:(NSString *)accesskey :(int)sex :(NSString *)birthday :(NSString *)msn :(NSString *)qq :(NSString *)phone :(NSString *)office_phone :(NSString *)home_phone success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"account"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/account/update?token=%@&accesskey=%@",token,accesskey] parameters:@{@"sex":@(sex),@"birthday":birthday,@"msn":msn,@"qq":qq,@"office_phone":office_phone,@"home_phone":home_phone,@"mobile_phone":phone} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户地址添加
+(void)address_add:(NSString *)accesskey :(Address *)address :(NSString *)consignee :(NSString *)email :(NSString *)addressa :(NSString *)zipcode :(NSString *)mobile :(NSString *)best_time success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"address"];
//    NSLog(@">.%@-%@-%d-%d-%d-%d-%@-%@-%@",address.consignee,address.email,address.country,address.province,address.city,
//          address.district,address.addressa,address.zipcode,address.best_time);
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/address/add?token=%@&accesskey=%@",token,accesskey] parameters:@{@"consignee":consignee,@"email":email,@"country":@(address.country),@"province":@(address.province), @"city":@(address.city),@"district":@(address.district),@"address":addressa,@"zipcode":zipcode,@"mobile":mobile,@"tel":mobile,@"sign_building":@"building",@"best_time":best_time} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户地址修改
+(void)address_update:(NSString *)accesskey :(int)addressId :(Address *)address :(NSString *)consignee :(NSString *)email :(NSString *)addressa :(NSString *)zipcode :(NSString *)mobile :(NSString *)best_time success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"address"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/address/update?token=%@&accesskey=%@",token,accesskey] parameters:@{@"id":@(addressId),@"consignee":consignee,@"email":email,@"country":@(address.country),@"province":@(address.province), @"city":@(address.city),@"district":@(address.district),@"address":addressa, @"zipcode":zipcode,@"mobile":mobile,@"tel":mobile,@"sign_building":@"building",@"best_time":best_time} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取用户地址详情
+(void)address_detail:(NSString *)accesskey :(int)addressId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSString *token = [Keys saveKeys:@"address"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/address/detail?token=%@",token] parameters:@{@"accesskey":accesskey,@"id":@(addressId)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户地址删除
+(void)address_delete:(NSString *)accesskey :(int)addressId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"address"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/address/delete?token=%@",token] parameters:@{@"accesskey":accesskey,@"id":@(addressId)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户添加产品评论
+(void)reviews_add:(NSString *)accesskey :(int)goodsId :(NSString *)content :(int)comment_rank success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"reviews"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/reviews/add?token=%@",token] parameters:@{@"accesskey":accesskey,@"id":@(goodsId),@"content":content,@"comment_rank":@(comment_rank)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取用户订单
+(void)order_index:(NSString *)accesskey success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"order"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/order/index?token=%@",token] parameters:@{@"accesskey":accesskey} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取用户订单详情
+(void)order_detail:(NSString *)accesskey :(int)orderId success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"order"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"user/order/detail?token=%@",token] parameters:@{@"accesskey":accesskey,@"id":@(orderId)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//用户订单提交
+(void)order_submit:(NSString *)accesskey :(Order *)order success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"order"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/order/submit?token=%@&accesskey=%@",token,accesskey] parameters:@{@"goods_id":order.goods_id,@"goods_quantity":order.goods_quantity,@"shipping_id":@(order.shipping_id),@"attribute_id":order.attribute_id,@"address_id":@(order.address_id),@"pay_id":@(order.pay_id)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取运费
+(void)order_get_shipping_fee:(NSString *)accesskey :(NSString *)goods_id :(NSString *)goods_quantity :(int)shipping_id success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"order"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"user/order/get_shipping_fee?token=%@&accesskey=%@",token,accesskey] parameters:@{@"goods_id":goods_id,@"goods_quantity":goods_quantity,@"shipping_id":@(shipping_id)} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//获取支付方式
+(void)common_payment:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"common"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"common/payment?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];

}

//获取运输方式
+(void)common_shipping:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{
    NSString *token = [Keys saveKeys:@"common"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"common/shipping?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];

}

//获取运输地址
+(void)common_region:(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSString *token = [Keys saveKeys:@"common"];
    [[StwClient sharedInstance] GET:[NSString stringWithFormat:@"common/region?token=%@",token] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}

//防伪查询
+(void)common_security_code:(NSString *)code :(void (^)(NSString *))success failure:(void (^)(NSString *))failure
{
    NSString *token = [Keys saveKeys:@"common"];
    [[StwClient sharedInstance] POST:[NSString stringWithFormat:@"common/security_code?token=%@",token] parameters:@{@"code":code} success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回的数据-->%@",operation);
         //         NSLog(@"error %@",[operation responseString]);
         failure([operation responseString]);
     }];
}


@end

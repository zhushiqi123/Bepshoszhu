//
//  BctClient.m
//  pospad
//
//  Created by stw01 on 15/1/28.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "StwClient.h"
#import "NSString+OGCryptoHash.h"
#import "ProgressHUD.h"
#import "Goods.h"
#import "Details.h"
#import "Session.h"
#import <objc/runtime.h>

@interface StwClient()
@end

@implementation StwClient

static StwClient *shareInstance = nil;

+(StwClient *) sharedInstance
{
    if (!shareInstance)
    {
        NSLog(@"STW Client 没有初始化");
    }
    return shareInstance;
}

+(void)initInstance:(NSString *)url
{
    if (!shareInstance)
    {
        shareInstance = [[StwClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
//        [shareInstance updateAuthorization];
    }
}

+(NSDictionary *)jsonParsing:(NSString *)message
{
    if (message)
    {
        NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        return data;
    }
    else
    {
        NSString *jsonString = @"{\"ret\":-404,\"msg\":\"网络连接失败请检查您的网络设置\"}";
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        return object;
    }
}

+(void)getGoodsDetial
{
    int ID = [Session sharedInstance].details.goods_id;
    //初始化数据
    [Session sharedInstance].details_imagesList = [NSMutableArray array];
    [Session sharedInstance].details_typeListA = [NSMutableArray array];
    [Session sharedInstance].details_typeListB = [NSMutableArray array];
    [Session sharedInstance].details_typeListC = [NSMutableArray array];
    [Session sharedInstance].details_typeListD = [NSMutableArray array];
    [Session sharedInstance].details_typeListB_attrId = [NSMutableArray array];
    [Session sharedInstance].details_typeListC_attrId = [NSMutableArray array];
    [Session sharedInstance].details_typeListD_attrId = [NSMutableArray array];
    [Session sharedInstance].details_typeListB_attrPrice = [NSMutableArray array];
    [Session sharedInstance].details_typeListC_attrPrice = [NSMutableArray array];
    [Session sharedInstance].details_typeListD_attrPrice = [NSMutableArray array];

    [Goods product_detail:ID success:^(id data)
    {
        NSLog(@"--------->详情页数据返回1%@",data);
    }
    failure:^(NSString *message)
    {
//        NSLog(@"--------->详情页数据返回2%@",message);
        NSDictionary *data = [StwClient jsonParsing:message];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        NSDictionary *datas = [data objectForKey:@"data"];
        NSLog(@"--------详情----------->%@",datas);
        if ([check_code isEqualToString:@"0"])
        {
            NSDictionary *dataDetails = [datas objectForKey:@"data"];
//            [Session sharedInstance].details_name = [dataDetails objectForKey:@"goods_name"];
//            [Session sharedInstance].homeACell_price = [dataDetails objectForKey:@"shop_price"];
//            [Session sharedInstance].details.goods_sn =  [dataDetails objectForKey:@"goods_sn"];
//            NSLog(@"-=-=->>%@",[Session sharedInstance].details_goods_sn);
            
            NSDictionary *description = [dataDetails objectForKey:@"description"];
            if(![description isKindOfClass:[NSNull class]])
            {
                [Session sharedInstance].goods_content  = [description objectForKey:@"goods_content"];
            }
            else
            {
                [Session sharedInstance].goods_content  = @"<h3>暂无详情数据</h3>";
            }
            
            NSArray *images = [dataDetails objectForKey:@"images"];
            NSArray *attributes = [dataDetails objectForKey:@"attributes"];
            
//            NSLog(@"[Session sharedInstance].goods_content%@",[Session sharedInstance].goods_content);
//            NSLog(@"=images=%lu",(unsigned long)images.count);
//            NSLog(@"=images=%@",images);
            for (int i = 0; i<images.count; i++)
            {
                 NSDictionary *ImgList = [images objectAtIndex:i];
//                NSLog(@"=images=%@",ImgList);
                NSString *imgUrl = [ImgList objectForKey:@"thumb400"];
//                NSLog(@"=imgUrl=%@",imgUrl);
                [[Session sharedInstance].details_imagesList addObject:imgUrl];
            }
            
            for (int i = 0; i<attributes.count; i++)
            {
                NSDictionary *TypeList = [attributes objectAtIndex:i];
                //属性  attr_id attr_name attr_value goods_attr_id goods_id attr_price
                NSString *attr_type = [TypeList objectForKey:@"attr_type"];
//                NSString *attr_id = [TypeList objectForKey:@"attr_id"];
                NSString *attr_name = [TypeList objectForKey:@"attr_name"];
                NSString *attr_value = [TypeList objectForKey:@"attr_value"];
                NSString *attr_price = [TypeList objectForKey:@"attr_price"];
                NSString *goods_attr_id = [TypeList objectForKey:@"goods_attr_id"];
                if ([attr_price isEqualToString:@""]) {
                    attr_price = @"+0.00";
                }
//                NSString *goods_id = [TypeList objectForKey:@"goods_id"];
                
                if([attr_type isEqualToString:@"0"])
                {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",attr_name,attr_value];
                    [[Session sharedInstance].details_typeListA addObject:str];
                }
                else
                {
                    if ([attr_name isEqualToString:@"颜色"] || [attr_name isEqualToString:@"阻值"])
                    {
                        [[Session sharedInstance].details_typeListB_attrPrice addObject:attr_price];
                        [[Session sharedInstance].details_typeListB_attrId addObject:goods_attr_id];
                        NSString *str = [NSString stringWithFormat:@"%@:%@(￥%@)",attr_name,attr_value,attr_price];
                        [[Session sharedInstance].details_typeListB addObject:str];
                    }
                    else if([attr_name isEqualToString:@"容量"] || [attr_name isEqualToString:@"型号选择"])
                    {
                        [[Session sharedInstance].details_typeListC_attrPrice addObject:attr_price];
                        [[Session sharedInstance].details_typeListC_attrId addObject:goods_attr_id];
                        NSString *str = [NSString stringWithFormat:@"%@:%@(￥%@)",attr_name,attr_value,attr_price];
                        [[Session sharedInstance].details_typeListC addObject:str];
                    }
                    else
                    {
                        [[Session sharedInstance].details_typeListD_attrPrice addObject:attr_price];
                        [[Session sharedInstance].details_typeListD_attrId addObject:goods_attr_id];
                        NSString *str = [NSString stringWithFormat:@"%@:%@(￥%@)",attr_name,attr_value,attr_price];
                        [[Session sharedInstance].details_typeListD addObject:str];
                    }
                }
            }
//            NSLog(@"=imgUrl=%@",[Session sharedInstance].details_imagesList);
        }
        else
        {
            [ProgressHUD showError:@"数据获取失败!请检查网络设置"];
        }
    }];
}

//对象转换字典
+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}


+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
//NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//[def setInteger:details.goods_id forKey:@"details_goods_id"];
//[def setObject:details.goods_name forKey:@"details_goods_name"];
//[def setObject:details.goods_sn forKey:@"details_goods_sn"];
//[def setObject:details.images forKey:@"details_images"];

//
//-(void)setUserID:(int)uid
//{
//    self.uid = uid;
//    [self updateAuthorization];
//}
//
//-(void)updateAuthorization
//{
//    self.requestSerializer = [AFHTTPRequestSerializer serializer];
//}
@end

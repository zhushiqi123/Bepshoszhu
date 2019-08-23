//
//  BctidClient.h
//  pospad
//
//  Created by stw01 on 15/1/28.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Details.h"

@interface StwClient : AFHTTPRequestOperationManager
@property(nonatomic,assign) int uid;

+(StwClient *)sharedInstance;

//网络访问初始化
+(void)initInstance:(NSString *)url;

//JSON解析
+(NSDictionary *)jsonParsing:(NSString *)message;

//获取商品详情
+(void)getGoodsDetial;
//-(void)setUserID:(int)uid;

+(NSDictionary*)getObjectData:(id)obj;
@end

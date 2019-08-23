//
//  Keys.m
//  aspire商城
//
//  Created by tyz on 15/12/15.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "Keys.h"
#import "NSString+OGCryptoHash.h"

@implementation Keys

static Keys *shareInstance = nil;

+(Keys *)sharedInstance
{
    if (!shareInstance)
    {
        NSLog(@"Keys 没有初始化");
    }
    return shareInstance;
}

+(void)initInstance
{
    if (!shareInstance)
    {
        shareInstance = [[Keys alloc] init];
    }
}

+(NSString *)saveKeys :(NSString *)tokenStrings
{
    NSString *tokenString;
    NSString *token;
    NSString *aspire = @"aspire";
    NSString *timers = [NSString stringWithFormat:@"%@",[Keys getTimer]];
    tokenString = [NSString stringWithFormat:@"%@%@%@",tokenStrings,timers,aspire];
    token = [tokenString og_stringUsingCryptoHashFunction:OGCryptoHashFunctionMD5];
    return token;
}

//获取时间
+(NSString *)getTimer
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
    return locationString;
}

@end

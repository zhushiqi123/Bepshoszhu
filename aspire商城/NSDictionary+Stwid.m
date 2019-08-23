//
//  NSDictionary+Bctid.m
//  Bctid
//
//  Created by stw01 on 15/1/28.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import "NSDictionary+Stwid.h"

@implementation NSDictionary (Stwid)

- (id)safeObjectForKey:(id)key {
	id value = [self valueForKey:key];
	if (value == [NSNull null]) {
		return nil;
	}
	return value;
}

-(NSString *)stringForKey:(id)key
{
    id v = [self safeObjectForKey:key];
    if(v == nil) return @"";
    return v;
}

-(int)intForKey:(id)key
{
    return [[self safeObjectForKey:key] intValue];
}

-(BOOL)boolForKey:(id)key
{
    return [[self safeObjectForKey:key] integerValue] == 1 ? YES : NO;
}

-(NSDate *)dateForKey:(id)key
{
    return [NSDate dateWithTimeIntervalSince1970:[[self safeObjectForKey:key] intValue]];
}

-(NSArray *)arrayForKey:(id)key
{
    id rs = [self safeObjectForKey:key];
    if([rs isKindOfClass:[NSArray class]]){
        return rs;
    }
    return nil;
}
@end


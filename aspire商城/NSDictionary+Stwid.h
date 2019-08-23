//
//  NSDictionary+Bctid.h
//  bctid
//
//  Created by stw01 on 15/1/28.
//  Copyright (c) 2015年 bct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Stwid)

-(NSString *)stringForKey:(id)key;

-(int)intForKey:(id)key;

-(BOOL)boolForKey:(id)key;

-(NSDate *)dateForKey:(id)key;

-(NSArray *)arrayForKey:(id)key;

@end

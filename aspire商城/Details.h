//
//  Details.h
//  aspire商城
//
//  Created by tyz on 15/12/19.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Details : NSObject

@property(nonatomic,assign) int goods_id;

@property(nonatomic,assign) NSString *goods_name;
@property(nonatomic,assign) NSString *goods_sn;
@property(nonatomic,assign) NSString *price;

+(Details *)initdata:(id)data;
@end

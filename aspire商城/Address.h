//
//  Address.h
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

//@property(nonatomic,assign) NSString *consignee;
//@property(nonatomic,assign) NSString *email;
@property(nonatomic,assign) int country;
@property(nonatomic,assign) int province;
@property(nonatomic,assign) int city;
@property(nonatomic,assign) int district;
//@property(nonatomic,assign) NSString *addressa;
//@property(nonatomic,assign) NSString *zipcode;
//@property(nonatomic,assign) NSString *mobile;
//@property(nonatomic,assign) NSString *best_time;

+(Address *)initdata:(id)data;
@end

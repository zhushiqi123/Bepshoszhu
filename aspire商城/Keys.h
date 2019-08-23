//
//  Keys.h
//  aspire商城
//
//  Created by tyz on 15/12/15.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keys : NSObject

+(void)initInstance;
+(Keys *)sharedInstance;
+(NSString *)saveKeys :(NSString *)tokenStrings;

@end

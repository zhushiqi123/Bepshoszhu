//
//  TYZ_Session.m
//
//  Created by 田阳柱 on 16/7/30.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TYZ_Session.h"

@implementation TYZ_Session

static TYZ_Session *shareInstance = nil;

+(TYZ_Session *)sharedInstance
{
    if (!shareInstance)
    {
        shareInstance = [[TYZ_Session alloc] init];
    }
    return shareInstance;
}
@end

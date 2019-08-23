//
//  STWMyView.m
//  aspire商城
//
//  Created by tyz on 15/12/4.
//  Copyright © 2015年 stw. All rights reserved.
//

#import "STWMyView.h"

@implementation STWMyView

-(id)initWithMy:(NSString*)tittle strings:(NSArray*)strings {
    if (self = [super init])
    {
        self.tittle = tittle;
        self.strings = strings;
    }
    return self;
}


//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"<%@: %p> {name: %@, icon: %@}", self.class, self,self.name, self.icon];
//}

@end

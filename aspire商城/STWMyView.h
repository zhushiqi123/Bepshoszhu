//
//  STWMyView.h
//  aspire商城
//
//  Created by tyz on 15/12/4.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STWMyView : NSObject
@property (nonatomic, copy) NSString *tittle;
@property (nonatomic, copy) NSArray *strings;

- (id)initWithMy:(NSString*)tittle strings:(NSArray*)strings;

@end

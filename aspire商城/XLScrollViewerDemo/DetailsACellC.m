//
//  DetailsACellC.m
//  aspire商城
//
//  Created by tyz on 16/1/6.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "DetailsACellC.h"
#import "Session.h"

@implementation DetailsACellC

- (void)awakeFromNib
{
//    if ([Session sharedInstance].details_goods_sn) {
        self.goods_sn.text = [NSString stringWithFormat:@"型号:%@",[Session sharedInstance].details.goods_sn];
//            self.goods_sn.text = [NSString stringWithFormat:@"型号:%@",@"11111"];
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

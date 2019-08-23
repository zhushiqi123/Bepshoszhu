//
//  DetailsACellD.m
//  aspire商城
//
//  Created by tyz on 16/1/6.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "DetailsACellD.h"
#import "Session.h"

@implementation DetailsACellD

- (void)awakeFromNib {
    self.goods_price.text = [NSString stringWithFormat:@"价格:%@",[Session sharedInstance].homeACell_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

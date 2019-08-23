//
//  DetailsACellB.m
//  aspire商城
//
//  Created by tyz on 16/1/6.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "DetailsACellB.h"
#import "Session.h"

@implementation DetailsACellB

- (void)awakeFromNib {
    self.goods_name.text = [Session sharedInstance].details_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

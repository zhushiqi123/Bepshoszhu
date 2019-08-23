//
//  MultilevelTableViewCell.m
//  MultilevelMenu
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
//

#import "MultilevelTableViewCell.h"

@implementation MultilevelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setZero{
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins=UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        self.separatorInset=UIEdgeInsetsZero;
    }

}
@end

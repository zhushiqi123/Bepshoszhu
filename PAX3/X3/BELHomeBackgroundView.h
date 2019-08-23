//
//  BELHomeBackgroundView.h
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BELHomeBackgroundView : UIView

- (id)initWithFrame:(CGRect)frame :(UIColor *)start_color  :(UIColor *)end_color;

//刷新color
-(void)updateColor:(UIColor *)start_color  :(UIColor *)end_color;


@property (nonatomic, retain)UIColor *start_color;
@property (nonatomic, retain)UIColor *end_color;

@end

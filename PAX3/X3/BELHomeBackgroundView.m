//
//  BELHomeBackgroundView.m
//  PAX3
//
//  Created by tyz on 17/5/4.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "BELHomeBackgroundView.h"

@implementation BELHomeBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame :(UIColor *)start_color  :(UIColor *)end_color
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _start_color = start_color;
        _end_color = end_color;
    }
    return self;
}

//刷新color
-(void)updateColor:(UIColor *)start_color  :(UIColor *)end_color
{
    _start_color = start_color;
    _end_color = end_color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    /**
     *  1.通过CAGradientLayer 设置渐变的背景。
     */
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组
    layer.colors=@[(__bridge id)_end_color.CGColor,(__bridge id)_start_color.CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0.5, 1);
    layer.endPoint = CGPointMake(0.5, 0);
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

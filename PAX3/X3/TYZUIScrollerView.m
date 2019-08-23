//
//  TYZUIScrollerView.m
//  PAX3
//
//  Created by tyz on 17/5/5.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "TYZUIScrollerView.h"

@implementation TYZUIScrollerView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
    
    // 通知代理
    if ([self.TYZTouch_delegate respondsToSelector:@selector(TYZTouchStausFuc:)]) {
        [self.TYZTouch_delegate TYZTouchStausFuc:1];
    }
    
//    NSLog(@"MyScrollView touch Began");
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
    
    // 通知代理
    if ([self.TYZTouch_delegate respondsToSelector:@selector(TYZTouchStausFuc:)]) {
        [self.TYZTouch_delegate TYZTouchStausFuc:2];
    }
    
//    NSLog(@"MyScrollView touch END");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

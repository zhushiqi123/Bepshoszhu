//
//  HXCardSwitchView.m
//  HXFelicity
//
//  Created by tyz on 17/5/3.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "HXCardSwitchView.h"

@implementation HXCardSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cardSwitchScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _cardSwitchScrollView.backgroundColor = [UIColor clearColor];
        _cardSwitchScrollView.showsHorizontalScrollIndicator = NO;
        _cardSwitchScrollView.decelerationRate = 1.0;
        _cardSwitchScrollView.delegate = self;
        [self addSubview:_cardSwitchScrollView];
    }
    return self;
}

- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry delegate:(id)delegate {
    _delegate = delegate;

    float space = 0;
    float width = 0;
    float viewWidth = 0;
    for (UIView *view in cardSwitchViewAry) {
        
        NSInteger index = [cardSwitchViewAry indexOfObject:view];
        
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        
        space = self.frame.size.width - viewWidth;
        width = viewWidth;
        
        //设置View 显示的位置
        view.frame = CGRectMake(space/2 + (view.frame.size.width)*index, 0, viewWidth, view.frame.size.height);
        
        CGFloat y = index * width;
        CGFloat value = (0-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/5));
        
        view.transform = CGAffineTransformMakeScale(1.0, scale);
        
        [_cardSwitchScrollView addSubview:view];
    }
    
    //设置_cardSwitchScrollView 总的长宽
    _cardSwitchScrollView.contentSize = CGSizeMake((space + width*cardSwitchViewAry.count), _cardSwitchScrollView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0) {
        return;
    }
    
//    float space = 0;
    float viewWidth = 0;
    for (UIView *view in _cardSwitchScrollView.subviews) {
        NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
        
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
//        space = self.frame.size.width - viewWidth;
        CGFloat width = viewWidth;
        CGFloat y = index * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/5));
        
        view.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    
    float a = offset/(viewWidth);
    
    if (a - (int)a > 0.5) {
        _currentIndex = (int)a + 1;
    } else {
        _currentIndex = (int)a;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scollNum = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scollNum = 1;
   //延时方法
   [self scrollToViewCenter : 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.scollNum = 2;
    //主动延时
    double delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       //延时方法
                       [self scrollToViewCenter : 2];
                   });
}

- (void)scrollToViewCenter : (int)status_num{
    if (status_num == self.scollNum){
//        float space = 0;
        float viewWidth = 0;
        for (UIView *view in _cardSwitchScrollView.subviews) {
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            
            if (index == 0) {
                viewWidth = view.frame.size.width;
            }
//            space = self.frame.size.width - viewWidth;
        }
        
        [_cardSwitchScrollView scrollRectToVisible:CGRectMake(_currentIndex*(viewWidth), 0, _cardSwitchScrollView.frame.size.width, _cardSwitchScrollView.frame.size.height) animated:YES];
        
        if (_delegate && [_delegate respondsToSelector:@selector(cardSwitchViewDidScroll:index:)]) {
            [_delegate cardSwitchViewDidScroll:self index:_currentIndex];
        }

    }
}

@end

//
//  ChooseTempViewCards.m
//  X3
//
//  Created by tyz on 17/6/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "ChooseTempViewCards.h"

@implementation ChooseTempViewCards

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        _cardSwitchScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _cardSwitchScrollView.backgroundColor = [UIColor clearColor];
        _cardSwitchScrollView.showsHorizontalScrollIndicator = NO;
        _cardSwitchScrollView.delegate = self;
        _cardSwitchScrollView.decelerationRate = 0.2;
        _currentIndex_end = -1;
        _currentIndex_moved = -1;
        _scrollerView_status = 1;
        self.TouchType = -1;
        [self addSubview:_cardSwitchScrollView];
    }
    return self;
}

- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry delegate:(id)delegate :(float)viewWidth{
    _delegate = delegate;
    
    _viewWidths = viewWidth;
    
    float space = 0;
    float width = 0;
    for (UIView *view in cardSwitchViewAry) {
        
        NSInteger index = [cardSwitchViewAry indexOfObject:view];
        
        space = self.frame.size.width - viewWidth;
        width = _viewWidths;
        
        //设置View 显示的位置
        view.frame = CGRectMake(space/2 + (view.frame.size.width)*index, 0, _viewWidths, view.frame.size.height);
        
        CGFloat y = index * width;
        CGFloat value = (0-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/5));
        
        view.transform = CGAffineTransformMakeScale(scale, scale);
        view.alpha = 0.0;

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

    for (UIView *view in _cardSwitchScrollView.subviews) {
        NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];

//        space = self.frame.size.width - _viewWidths;
        CGFloat width = _viewWidths;
        CGFloat y = index * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/4));
        
        view.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    float a = offset/(_viewWidths);
    
    if (a - (int)a > 0.5) {
        _currentIndex = (int)a + 1;
    } else {
        _currentIndex = (int)a;
    }

    _currentIndex_moved = _currentIndex;
    if (_scrollerView_status != -1) {
        for (UIView *view in _cardSwitchScrollView.subviews) {
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            //透明度改变
            if(index == _currentIndex){
                view.alpha = 1.0;
            }
            else{
                view.alpha = 0.5;
            }
        }

//        NSLog(@"发送改变指令 - %d",_currentIndex);    
        if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
            [_delegate changeAplaToLable:_currentIndex];
        }
    }
    else
    {
        _scrollerView_status = 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self off_animation:YES];
    self.scollNum = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollToViewCenter : 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //一旦出现2 就可以认为结束
    self.scollNum = -1;
    [self scrollToViewCenter : 2];
}

- (void)scrollToViewCenter : (int)status_num{
    if (self.scollNum != -1) {
        //主动延时
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           //延时方法
                           if (self.scollNum != -1)
                           {
                               self.scollNum = -1;
                               //等到最后才刷新
                               [self fresh_view :_viewWidths];
                               
                               if (_delegate && [_delegate respondsToSelector:@selector(cardSwitchViewDidScroll:index:)]) {
                                   [_delegate cardSwitchViewDidScroll:self index:_currentIndex];
                               }
                           }
                       });
    }
    else
    {
        //等到最后才刷新
        [self fresh_view :_viewWidths];
        
        if (_delegate && [_delegate respondsToSelector:@selector(cardSwitchViewDidScroll:index:)]) {
            [_delegate cardSwitchViewDidScroll:self index:_currentIndex];
        }
    }
}

//刷新界面
-(void)fresh_view :(float)viewWidth
{
    //重新绘图
    [_cardSwitchScrollView scrollRectToVisible:CGRectMake(_currentIndex*(viewWidth), 0, _cardSwitchScrollView.frame.size.width, _cardSwitchScrollView.frame.size.height) animated:YES];
    
    [self off_animation:NO];
    
    //发送改变指令
    if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
        [_delegate changeAplaToLable:-1];
    }
}

- (void)SetChooviewNum:(int)key_num
{
    if (key_num != _currentIndex)
    {
        _currentIndex = key_num;
        //重新绘图
//        NSLog(@"_currentIndex*(_viewWidths) - %f",_currentIndex*(_viewWidths));
        //告诉Scroller view 这个不回调
        _scrollerView_status = -1;
        _cardSwitchScrollView.contentOffset = CGPointMake(_currentIndex*(_viewWidths),0);
    }
}

-(void)off_animation :(BOOL) status_off_on
{
    if (status_off_on)
    {
        //变亮动画
        
        for (UIView *view in _cardSwitchScrollView.subviews) {
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            if(index == _currentIndex)
            {
                view.alpha = 1.0;
            }
            else
            {
                view.alpha = 0.0;
            }
        }
    }
    else
    {
//        NSLog(@"变暗动画");
        for (UIView *view in _cardSwitchScrollView.subviews) {
            //主动延时
            double delayInSeconds = 0.5f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                           {
                               if(self.scollNum == -1)
                               {
                                   view.alpha = 0.0;
                               }
                           });
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

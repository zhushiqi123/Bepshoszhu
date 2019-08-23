//
//  ChooseModelViewCards.m
//  PAX3
//
//  Created by tyz on 17/5/5.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "ChooseModelViewCards.h"

@implementation ChooseModelViewCards

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cardSwitchScrollView = [[TYZUIScrollerView alloc] initWithFrame:frame];
        _cardSwitchScrollView.backgroundColor = [UIColor clearColor];
        _cardSwitchScrollView.showsHorizontalScrollIndicator = NO;
        _cardSwitchScrollView.delegate = self;
        _cardSwitchScrollView.TYZTouch_delegate = self;
        _cardSwitchScrollView.decelerationRate = 0.2;
        _currentIndex_end = -1;
        _currentIndex_moved = -1;
        self.TouchType = -1;
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
            _viewWidths = viewWidth;
        }
        
        space = self.frame.size.width - viewWidth;
        width = viewWidth;
        
        //设置View 显示的位置
        view.frame = CGRectMake(space/2 + (view.frame.size.width)*index, 0, viewWidth, view.frame.size.height);
        
        if(index == (_currentIndex = 0))
        {
            view.alpha = 1.0;
        }
        else
        {
            view.alpha = 0.0;
        }

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
    
    float viewWidth = 0;

    for (UIView *view in _cardSwitchScrollView.subviews) {
        NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
    
        if (index == 0)
        {
            viewWidth = view.frame.size.width;
            
            float a = offset/(viewWidth);

            if (a - (int)a > 0.5) {
                _currentIndex = (int)a + 1;
            } else {
                _currentIndex = (int)a;
            }
        }
    }
    
    if (_currentIndex_moved != _currentIndex) {
        //发送改变指令
        if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
            [_delegate changeAplaToLable:_currentIndex];
        }
        
        _currentIndex_moved = _currentIndex;
        for (UIView *view in _cardSwitchScrollView.subviews) {
//            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            //透明度改变
//            if(index == _currentIndex){
                view.alpha = 1.0;
//            }
//            else{
//                view.alpha = 0.5;
//            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.TouchType != 1) {
        [self off_animation:YES];
    }
    self.scollNum = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scollNum = 1;
    //延时方法
    double delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
    [self scrollToViewCenter : 1];
                   });
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
        float viewWidth = 0;
        
        for (UIView *view in _cardSwitchScrollView.subviews) {
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            
            if (index == 0) {
                viewWidth = view.frame.size.width;
                break;
            }
        }
        
//        NSLog(@"刷新界面");
        
        [self fresh_view:_currentIndex_end :viewWidth];
        
        if (_delegate && [_delegate respondsToSelector:@selector(cardSwitchViewDidScroll:index:)]) {
            [_delegate cardSwitchViewDidScroll:self index:_currentIndex];
        }
    }
}

//刷新界面
-(void)fresh_view:(int)num :(float)viewWidth
{
    if (num != _currentIndex)
    {
        //重新绘图
        [_cardSwitchScrollView scrollRectToVisible:CGRectMake(_currentIndex*(viewWidth), 0, _cardSwitchScrollView.frame.size.width, _cardSwitchScrollView.frame.size.height) animated:YES];
        
        //发送改变指令
        if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
            [_delegate changeAplaToLable:-1];
        }
    }
}

- (void)SetChooviewNum:(int)key_num
{
    if (key_num != _currentIndex)
    {
        _currentIndex = key_num;
        //重新绘图
        [_cardSwitchScrollView scrollRectToVisible:CGRectMake(_currentIndex*(_viewWidths), 0, _cardSwitchScrollView.frame.size.width, _cardSwitchScrollView.frame.size.height) animated:YES];
    
        //发送改变指令
        if (_delegate && [_delegate respondsToSelector:@selector(changeArcNums:)]) {
            [_delegate changeArcNums:_currentIndex];
        }
    }
}

-(void)TYZTouchStausFuc:(int)TouchStatus
{
//    NSLog(@"TouchStatus - %d",TouchStatus);
    if (TouchStatus == 1) {
        self.TouchType = 1;
        [self off_animation:YES];
    }
    else
    {
        self.TouchType = 2;
        [self off_animation:NO];
    }
}

-(void)off_animation :(BOOL) status_off_on
{
    if (status_off_on) {
        
        //发送改变指令
        if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
            [_delegate changeAplaToLable:_currentIndex];
        }
        
        for (UIView *view in _cardSwitchScrollView.subviews) {
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            if (index != _currentIndex)
            {
                //变暗动画
                CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
                opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
                opacityAnimation.duration = 0.5f;
                opacityAnimation.removedOnCompletion = NO;
                [view.layer addAnimation:opacityAnimation forKey:nil];
                
                //主动延时
                double delayInSeconds = 0.3f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   //延时方法
                                   view.alpha = 1.0;
                               });
            }
        }
    }
    else
    {
        //发送改变指令
        if (_delegate && [_delegate respondsToSelector:@selector(changeAplaToLable:)]) {
            [_delegate changeAplaToLable:-1];
        }
        
        for (UIView *view in _cardSwitchScrollView.subviews) {
            
            NSInteger index = [_cardSwitchScrollView.subviews indexOfObject:view];
            if (index != _currentIndex)
            {
                //变暗动画
                CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
                opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
                opacityAnimation.duration = 0.5f;
                opacityAnimation.removedOnCompletion = NO;
                [view.layer addAnimation:opacityAnimation forKey:nil];
                
                //主动延时
                double delayInSeconds = 0.3f;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   //延时方法
                                   view.alpha = 0.0;
                               });
            }
        }
    }
}

@end

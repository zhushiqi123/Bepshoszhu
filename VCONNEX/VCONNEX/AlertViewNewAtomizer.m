//
//  AlertViewNewAtomizer.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/29.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "AlertViewNewAtomizer.h"
#import "AppDelegate.h"

@implementation AlertViewNewAtomizer

- (void)awakeFromNib
{
    self.backgroundColor = RGBACOLOR(0x00, 0x00, 0x00, 0.5);
    self.clipsToBounds = YES;
}

- (void)showViewWith:(NSString *)message :(NSString *)btn_yes_str :(NSString *)btn_no_str
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2));
    
    [self addInputBoxView:message :btn_yes_str :btn_no_str];
    
    _timers = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(stopSelect_timer) userInfo:nil repeats:YES];
    
    [delegate.window addSubview:self];
}

//选择默情况
-(void)stopSelect_timer
{
    if (_timers)
    {
        [_timers invalidate];
        _timers = nil;
    }
    
    //设置回调 - 默认选择YES
    if(self.new_old_AtomizerBox)
    {
        self.new_old_AtomizerBox(0x01);
        
        [self remove];
    }
}

//加载Edit部分
-(void)addInputBoxView:(NSString *)message :(NSString *)btn_yes_str :(NSString *)btn_no_str
{
    _NewAtomizerBoxView = [[[NSBundle mainBundle]loadNibNamed:@"NewAtomizerXIB" owner:self options:nil] lastObject];
    
    CGRect frame = _NewAtomizerBoxView.frame;
    
    frame.size.width = SCREEN_WIDTH - 20.0f;
    frame.size.height = 150.0f;
    
    _NewAtomizerBoxView.frame = frame;
    
    _NewAtomizerBoxView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2));
    
    _NewAtomizerBoxView.backgroundColor = [UIColor whiteColor];
    
    _NewAtomizerBoxView.layer.cornerRadius = 5.0f;
    
    _NewAtomizerBoxView.btn_no.layer.cornerRadius = 2.0f;
    _NewAtomizerBoxView.btn_yes.layer.cornerRadius = 2.0f;
    
    _NewAtomizerBoxView.atom_lable.text = message;
    
    [_NewAtomizerBoxView.btn_yes setTitle:btn_yes_str forState:UIControlStateNormal];
    [_NewAtomizerBoxView.btn_no setTitle:btn_no_str forState:UIControlStateNormal];
    
//    //设置边界的宽度
//    [_NewAtomizerBoxView.btn_no.layer setBorderWidth:1];
//    [_NewAtomizerBoxView.btn_no.layer setBorderColor:[UIColor blackColor].CGColor];
//    
//    //设置边界的宽度
//    [_NewAtomizerBoxView.btn_yes.layer setBorderWidth:1];
//    [_NewAtomizerBoxView.btn_yes.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //添加点击事件
    [_NewAtomizerBoxView.btn_no addTarget:self action:@selector(onclick_btn_no) forControlEvents:UIControlEventTouchUpInside];
    [_NewAtomizerBoxView.btn_yes addTarget:self action:@selector(onclick_btn_yes) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_NewAtomizerBoxView];
}

-(void)onclick_btn_yes
{
    if (_timers)
    {
        [_timers invalidate];
        _timers = nil;
    }
    
    //设置回调
    if(self.new_old_AtomizerBox)
    {
        self.new_old_AtomizerBox(0x01);
        
        [self remove];
    }
}

-(void)onclick_btn_no
{
    if (_timers)
    {
        [_timers invalidate];
        _timers = nil;
    }
    
    //设置回调
    if(self.new_old_AtomizerBox)
    {
        self.new_old_AtomizerBox(0x00);
        
        [self remove];
    }
}

- (void)remove
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

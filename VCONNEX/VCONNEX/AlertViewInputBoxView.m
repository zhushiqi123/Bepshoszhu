//
//  AlertViewInputBoxView.m
//  uVapour
//
//  Created by 田阳柱 on 16/10/6.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "AlertViewInputBoxView.h"
#import "AppDelegate.h"
#import "KeyNumInPutView.h"

@implementation AlertViewInputBoxView

- (void)awakeFromNib
{
    self.backgroundColor = RGBACOLOR(0x00, 0x00, 0x00, 0.5);
    self.clipsToBounds = YES;
}

- (void)showViewWith:(int)keyNums
{
    _keyNums = keyNums;

    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2));
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [self addInputBoxView:keyNums];
    
    [delegate.window addSubview:self];
}

//加载Edit部分
-(void)addInputBoxView:(int)keyNums
{
    _KeyinpuBoxView = [[[NSBundle mainBundle]loadNibNamed:@"KeyNumInPutView" owner:self options:nil] lastObject];
    
    CGRect frame = _KeyinpuBoxView.frame;

    frame.size.width = SCREEN_WIDTH - 20.0f;
    frame.size.height = 136.0f;
    
    _KeyinpuBoxView.frame = frame;
    
    _KeyinpuBoxView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2) - 70);
    
    _KeyinpuBoxView.backgroundColor = [UIColor whiteColor];
    
    _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
    
    _KeyinpuBoxView.layer.cornerRadius = 10.0f;
    
    _KeyinpuBoxView.btn_cancel.layer.cornerRadius = 2.0f;
    _KeyinpuBoxView.btn_confirm.layer.cornerRadius = 2.0f;
    
    //设置边界的宽度
    [_KeyinpuBoxView.btn_cancel.layer setBorderWidth:1];
    [_KeyinpuBoxView.btn_cancel.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //设置边界的宽度
    [_KeyinpuBoxView.btn_confirm.layer setBorderWidth:1];
    [_KeyinpuBoxView.btn_confirm.layer setBorderColor:[UIColor blackColor].CGColor];
    
    [_KeyinpuBoxView.btn_add addTarget:self action:@selector(btn_add_onclick) forControlEvents:UIControlEventTouchUpInside];
    [_KeyinpuBoxView.btn_low addTarget:self action:@selector(btn_low_onclick) forControlEvents:UIControlEventTouchUpInside];
    
    [_KeyinpuBoxView.btn_cancel addTarget:self action:@selector(cancle_btn) forControlEvents:UIControlEventTouchUpInside];
    [_KeyinpuBoxView.btn_confirm addTarget:self action:@selector(confirm_btn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_KeyinpuBoxView.input_text addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_KeyinpuBoxView.input_text addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self addSubview:_KeyinpuBoxView];
}

//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [_KeyinpuBoxView.input_text resignFirstResponder];
}

//改变监听
- (void)tfChange:(UITextField *)sender
{
    if ([sender isEqual:_KeyinpuBoxView.input_text])
    {
        if([_KeyinpuBoxView.input_text.text isEqualToString:@""])
        {
            _keyNums = 3;
//            NSLog(@"不做处理");
        }
        else
        {
            int nums = [_KeyinpuBoxView.input_text.text intValue];
            
            if (nums > 10)
            {
                _keyNums = 10;
                
                _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
            }
            else if(nums < 3)
            {
                _keyNums = 3;
                _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
            }
            else
            {
                _keyNums = nums;
            }

        }
    }
}

//结束监听
- (void)tfEnd:(UITextField *)sender
{
    if ([sender isEqual:_KeyinpuBoxView.input_text])
    {
        if([_KeyinpuBoxView.input_text.text isEqualToString:@""])
        {
            _keyNums = 3;
            _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
        }
        else
        {
             int nums = [_KeyinpuBoxView.input_text.text intValue];
        
             _keyNums = nums;
        
             _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
        }
    }
}

//按钮增加
-(void)btn_add_onclick
{
    if (_keyNums < 10)
    {
        _keyNums = _keyNums + 1;
        
        _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
    }
}

//按钮减小
-(void)btn_low_onclick
{
    if (_keyNums > 3)
    {
        _keyNums = _keyNums - 1;
        
        _KeyinpuBoxView.input_text.text = [NSString stringWithFormat:@"%d",_keyNums];
    }
}

-(void)confirm_btn
{
    //按键次数
    int keyNums = _keyNums;
    //进行回调
    if (self.keyInput)
    {
        self.keyInput(keyNums);
    }
    
    [self remove];
}

-(void)cancle_btn
{
    [self remove];
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

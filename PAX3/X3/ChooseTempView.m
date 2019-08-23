//
//  ChooseTempView.m
//  PAX3
//
//  Created by tyz on 17/5/6.
//  Copyright © 2017年 tyz. All rights reserved.
//
#import "ChooseTempView.h"
#import <QuartzCore/QuartzCore.h>  
#import "ChooseTempViewCards.h"
#import "STW_BLE.h"

@implementation ChooseTempView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _tmp_value_nums = -1;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame :(int)trmp_value :(int)temp_value_now  :(int)trmp_model
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _temp_model = trmp_model;
        _temp_value = trmp_value;
        _temp_value_now = temp_value_now;
        
        if (_temp_value_now > _temp_value) {
            _temp_value_now = _temp_value;
        }
        
        _tmpview_width = (frame.size.width/3.0f);
        _tmpview_height = frame.size.height;

        //设置左右滑动视图
        [self add_choose_temp_sliding_view];
        
        //圆形的视图
        _choose_view = [[UIView alloc] initWithFrame:CGRectMake(0,0, _tmpview_width, _tmpview_width)];
        _choose_view.center = CGPointMake(frame.size.width/2.0f, _tmpview_height/2.0f + 20.0f);
        //设置_choose_view背景
        _choose_view.backgroundColor = [self setChooseViewBackColor];
        _choose_view.layer.cornerRadius = (_tmpview_width/2.0f);
        [_choose_view.layer setMasksToBounds:YES];
        [self addSubview:_choose_view];
        
        _temp_lable_now = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tmpview_width,20.0f)];
        _temp_lable_now.center = CGPointMake(frame.size.width/2.0f, (_tmpview_height/2.0f - 10.0f - (_tmpview_width/2.0f)) + 10.0f);
        _temp_lable_now.textAlignment = NSTextAlignmentCenter;
        _temp_lable_now.font = [UIFont boldSystemFontOfSize:16.0f];
        _temp_lable_now.textColor = RGBCOLOR(158, 170, 186);
        _temp_lable_now.backgroundColor = [UIColor clearColor];
        _temp_lable_now.text = [NSString stringWithFormat:@"%d",_temp_value_now];
//        temp_lable_now.alpha = 0.5;
        [self addSubview:_temp_lable_now];
        
        _temp_lable_set = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tmpview_width, _tmpview_width/2.0f)];
        _temp_lable_set.center = CGPointMake(frame.size.width/2.0f, _tmpview_height/2.0f + 15.0f);
        _temp_lable_set.textAlignment = NSTextAlignmentCenter;
        float text_size = _tmpview_width/3.0f;
        _temp_lable_set.font = [UIFont systemFontOfSize:text_size];
        _temp_lable_set.textColor = RGBCOLOR(23, 5, 0);//[UIColor blackColor];
        _temp_lable_set.backgroundColor = [UIColor clearColor];
//        temp_lable_set.alpha = 0.6;
        _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
        [self addSubview:_temp_lable_set];
        
        _temp_lable_mode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tmpview_width, _tmpview_width/4.0f)];
        _temp_lable_mode.center = CGPointMake(frame.size.width/2.0f, (_tmpview_height/2.0f + _tmpview_width/2.0f - (_tmpview_width/8.0f)) + 20.0f);
        _temp_lable_mode.textAlignment = NSTextAlignmentCenter;
        _temp_lable_mode.font = [UIFont boldSystemFontOfSize:16.0f];
        _temp_lable_mode.textColor = RGBCOLOR(23, 5, 0);//[UIColor blackColor];
        _temp_lable_mode.backgroundColor = [UIColor clearColor];
        if (_temp_model == 0) {
            _temp_lable_mode.text = @"℃";
        }
        else
        {
            _temp_lable_mode.text = @"℉";
        }
        
        [self addSubview:_temp_lable_mode];
    }
    return self;
}

-(void)add_choose_temp_sliding_view
{
    _choose_temp_sliding = [[ChooseTempViewCards alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _tmpview_width)];
    _choose_temp_sliding.backgroundColor = [UIColor clearColor];
    _choose_temp_sliding.center = CGPointMake(SCREEN_WIDTH/2.0f, _tmpview_height/2.0f + 20.0f);
    [_choose_temp_sliding setCardSwitchViewAry:[self ittemsCardSwitchViewAry] delegate:self :_tmpview_width];
    [self addSubview:_choose_temp_sliding];
}

/**
 *  准备添加到卡片切换View上的View数组
 */
- (NSArray *)ittemsCardSwitchViewAry
{
    if (_temp_model == 0) {
        //摄氏度
        _chooseTemp_dicAry = @[@"184",@"186",@"188",@"190",@"192",@"194",@"196",@"198",@"200",@"202",@"204",@"206",@"208",@"210",@"212",@"214"];
    }
    else
    {
        //华氏度
        _chooseTemp_dicAry = @[@"360",@"365",@"370",@"375",@"385",@"385",@"390",@"395",@"400",@"405",@"410",@"415",@"420"];
    }
    
    float view_height = _tmpview_width;
    float view_width = _tmpview_width;
    
    NSMutableArray *ary = [NSMutableArray new];
    
    for (NSString *felicityDic in _chooseTemp_dicAry) {
        NSInteger index = [_chooseTemp_dicAry indexOfObject:felicityDic];
        
        UIView *backImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.tag = index;
        
        UIView *choose_view_list = [[UIView alloc] initWithFrame:CGRectMake(0,0, _tmpview_width, _tmpview_width)];
        choose_view_list.center = backImageView.center;
        //设置_choose_view背景
        int value_num = [felicityDic intValue];
        choose_view_list.backgroundColor = [self setBackgroundColor:_temp_model :value_num];
        choose_view_list.layer.cornerRadius = (_tmpview_width/2.0f);
        [choose_view_list.layer setMasksToBounds:YES];
        [backImageView addSubview:choose_view_list];
        
        NSString *imageStr = @"";
        
        if (_temp_model == 0) {
            //摄氏度
            switch (value_num) {
                case 184:
                    imageStr = @"icon_temp_value_1";
                    break;
                case 194:
                    imageStr = @"icon_temp_value_2";
                    break;
                case 204:
                    imageStr = @"icon_temp_value_3";
                    break;
                case 214:
                    imageStr = @"icon_temp_value_4";
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            //华氏度
            switch (value_num) {
                case 360:
                    imageStr = @"icon_temp_value_1";
                    break;
                case 380:
                    imageStr = @"icon_temp_value_2";
                    break;
                case 400:
                    imageStr = @"icon_temp_value_3";
                    break;
                case 420:
                    imageStr = @"icon_temp_value_4";
                    break;
                    
                default:
                    break;
            }
        }
        
        if (![imageStr isEqualToString:@""]) {
            UIImageView *chooseImageViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
            chooseImageViews.center = CGPointMake(view_width/2.0f, view_height/2.0f);
            chooseImageViews.image = [UIImage imageNamed:imageStr];
            [backImageView addSubview:chooseImageViews];
        }
       
        [ary addObject:backImageView];
    }
    return ary;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //画一个圈
    //边框圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,153, 163, 214,0.8);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度  
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度   
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    
    //计算划线的 - 弧度  摄氏度 -> max =184 -  214  华氏度 -> max = 360 - 420
    float context_arc = 0;
    if(_temp_value_now > _temp_value)
    {
        context_arc = 1;
    }
    else
    {
        context_arc = _temp_value_now / (_temp_value * 1.0f);
    }
    

    CGContextAddArc(context, (SCREEN_WIDTH/2.0f), (_tmpview_height/2.0f + 20.0f),((_tmpview_width + 8.0f)/2.0f), (3.0f/2.0f) * M_PI, [self getArc:context_arc],NO); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

-(float)getArc:(float)key_num
{
    float con_arc = (2*key_num) - 0.5f;
    return con_arc * M_PI - 0.001f;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self doTouchFunc:point :1];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self doTouchFunc:point :2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self doTouchFunc:point :3];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    [self doTouchFunc:point :3];
}

-(void)doTouchFunc:(CGPoint) point :(int)status
{
    if (status == 1) {
        self.start_point = point;
        self.end_point = point;
    }
    else
    {
        self.end_point = point;
        if (self.start_point.x != -1) {
            //判断手指是怎么滑动的
            //上下滑动优先  184 - 214   360 - 420
            if(fabs(self.start_point.x - self.end_point.x) > (_tmpview_width/2.0f))
            {
                
            }
            else if(fabs(self.start_point.y - self.end_point.y) > (_tmpview_width/2.0f))
            {
                if(_temp_model == 0x00)
                {
                    if(self.start_point.y > self.end_point.y)
                    {
                        if (_temp_value < 214) {
                            _temp_value = _temp_value + 1;
                            
                            //出现动画
                            _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
                            [self animationFlip:3];
                        }
                    }
                    else
                    {
                        if (_temp_value > 184) {
                            _temp_value = _temp_value - 1;
                            
                            //出现动画
                            _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
                            [self animationFlip:4];
                        }
                    }
                    
                    //刷新滚动视图
                    [_choose_temp_sliding SetChooviewNum:((_temp_value - 184)/2)];
                }
                else
                {
                    if(self.start_point.y > self.end_point.y)
                    {
                        if (_temp_value < 420) {
                            _temp_value = _temp_value + 1;
                            
                            //出现动画
                            _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
                            [self animationFlip:3];
                        }
                    }
                    else
                    {
                        if (_temp_value > 360) {
                            _temp_value = _temp_value - 1;
                            
                            //出现动画
                            _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
                            [self animationFlip:4];
                        }
                    }
                    
                    //刷新滚动视图
                    [_choose_temp_sliding SetChooviewNum:((_temp_value - 360)/5)];
                }
                
                self.start_point = CGPointMake(-1, -1);
            }
        }
    }
}

-(void)animationFlip:(int)animationModel
{
    switch (animationModel) {
        case 1:
            [self anition_left_right:UIViewAnimationTransitionFlipFromLeft];
            break;
        case 2:
            [self anition_left_right:UIViewAnimationTransitionFlipFromRight];
            break;
        case 3:
            [self anition_up_down:0];
            break;
        case 4:
            [self anition_up_down:1];
            break;
            
        default:
            break;
    }
    
    //发送最高温度设置
    [[STW_BLE_SDK sharedInstance] the_work_temp_max:_temp_model :_temp_value];
    
    //设置_choose_view背景
    _choose_view.backgroundColor = [self setChooseViewBackColor];
}

-(void)anition_left_right:(UIViewAnimationTransition)models
{
    //开始动画
    [UIView beginAnimations:@"doflip" context:nil];
    //设置时长度
    [UIView setAnimationDuration:0.3];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置翻转方向
    [UIView setAnimationTransition:models forView:_choose_view cache:YES];
    //动画结束
    [UIView commitAnimations];
}

-(void)anition_up_down:(int)models
{
    CATransition *anima = [CATransition animation];
    anima.type = @"oglFlip";//设置动画的类型
    if (models == 1) {
        anima.subtype = kCATransitionFromTop; //设置动画的方向
    }
    else
    {
        anima.subtype = kCATransitionFromBottom; //设置动画的方向
    }
    
    anima.duration = 0.3f;
    [_choose_view.layer addAnimation:anima forKey:@"oglFlipAnimation"];
}

-(void)view_refresh:(int)tmpe_max :(int)temp_value_now :(int)tmpe_model
{
    int key_num = 0;
    
    if(_temp_value_now != temp_value_now)
    {
        if (_temp_value_now < temp_value_now)
        {
            _temp_value_now = temp_value_now;
            
            if (_temp_value_now > tmpe_max) {
                _temp_value_now = tmpe_max;
            }
            //需要刷新
            _temp_lable_now.text = [NSString stringWithFormat:@"%d",_temp_value_now];
            
            key_num = key_num + 1;
        }
        else
        {
            if (temp_value_now >= tmpe_max) {
                //温度最大了
                _temp_value_now = tmpe_max;
                //需要刷新
                _temp_lable_now.text = [NSString stringWithFormat:@"%d",_temp_value_now];
                
                key_num = key_num + 1;
            }
            else
            {
                //消除抖动
                if(abs(temp_value_now - _temp_value_now) >= 5)
                {
                    _temp_value_now = temp_value_now;
                    
                    if (_temp_value_now > tmpe_max) {
                        _temp_value_now = tmpe_max;
                    }
                    //需要刷新
                    _temp_lable_now.text = [NSString stringWithFormat:@"%d",_temp_value_now];
                    
                    key_num = key_num + 1;
                }
            }
        }
    }
    
    if (_temp_model != tmpe_model)
    {
        _temp_model = tmpe_model;
        
        if (_temp_model == 0) {
            _temp_lable_mode.text = @"℃";
        }
        else
        {
            _temp_lable_mode.text = @"℉";
        }
    }
    
    if (_temp_value != tmpe_max)
    {
        _temp_value = tmpe_max;
        _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
        //这里需要刷新ScrollerView
        if(_temp_model == 0)
        {
            //刷新滚动视图
            [_choose_temp_sliding SetChooviewNum:((_temp_value - 184)/2)];
        }
        else
        {
            //刷新滚动视图
            [_choose_temp_sliding SetChooviewNum:((_temp_value - 360)/5)];
        }
        
        key_num = key_num + 1;
    }
    
    if (key_num > 0)
    {
        //设置_choose_view背景
        _choose_view.backgroundColor = [self setChooseViewBackColor];
        //刷新界面
        [self setNeedsDisplay];
    }
}

-(UIColor *)setChooseViewBackColor
{
    NSLog(@"最高温度 - %d  当前温度 - %d",[STW_BLE_SDK sharedInstance].deviceData.tmp_max,[STW_BLE_SDK sharedInstance].deviceData.tmp_now);
    if (_temp_model == 0) {
        return [self getUIColor:184 :215 :_temp_value];//RGBCOLOR(254, 237, 1);//[UIColor greenColor];
    }
    else
    {
        return [self getUIColor:360 :420 :_temp_value];//RGBCOLOR(254, 237, 1);//[UIColor greenColor];
    }
}

-(UIColor*)setBackgroundColor :(int)model :(int)value
{
    if (model == 0) {
        return [self getUIColor:184 :214 :value];//RGBCOLOR(254, 237, 1);//[UIColor greenColor];
    }
    else
    {
        return [self getUIColor:360 :420 :value];//RGBCOLOR(254, 237, 1);//[UIColor greenColor];
    }
}

-(UIColor *)getUIColor :(int)min :(int)max :(int)key_num
{
    int max_min = max - min;
    int num_min = 0;
    
    if(key_num > min)
    {
        num_min = key_num - min;
    }
    else
    {
        num_min = 0;
    }
    
    float num_reat = num_min/(max_min * 1.0f);
    
    int Key_R = 0;
    int Key_G = 0;
    int Key_B = 0;
    
    if (num_reat >= 0.5)
    {
        Key_R = 255;
        Key_G = 255 * (1 - num_reat) * 2;
        Key_B = 0;
    }
    else
    {
        Key_R = 255 * num_reat * 2;
        Key_G = 255;
        Key_B = 0;
    }
    
    return RGBCOLOR(Key_R, Key_G, Key_B);
}

//设置代理
- (void)cardSwitchViewDidScroll:(ChooseTempViewCards *)cardSwitchView index:(NSInteger)index
{
//    NSLog(@"cardSwitchViewDidScroll - %d",index);
    if (index >= 0) {
        if(_temp_model == 0)
        {
            _temp_value = (int)(184 + (index * 2));
            if(_temp_value > 214)
            {
                _temp_value = 214;
            }
        }
        else
        {
            _temp_value = (int)(360 + (index * 5));
            if(_temp_value > 420)
            {
                _temp_value = 420;
            }
        }
        
        _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
        _choose_view.backgroundColor = [self setBackgroundColor:_temp_model :_temp_value];
        
        if (_tmp_value_nums != _temp_value) {
            _tmp_value_nums = _temp_value;
            //发送温度
//            NSLog(@"向设备发送温度2 - %d",_temp_value);
            [[STW_BLE_SDK sharedInstance] the_work_temp_max:_temp_model :_temp_value];
        }
    }
}

- (void)changeAplaToLable :(int)viewNum
{
//    NSLog(@"changeAplaToLable - %d",viewNum);
//    int tmp_value_nums = _temp_value;
    
    if (viewNum >= 0) {
        //变亮的动画
        _choose_view.alpha = 0.0f;
        
        if(_temp_model == 0)
        {
            _temp_value = 184 + (viewNum * 2);
            if(_temp_value > 214)
            {
                _temp_value = 214;
            }
        }
        else
        {
            _temp_value = 360 + (viewNum * 5);
            if(_temp_value > 420)
            {
                _temp_value = 420;
            }
        }
        
        _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
        _choose_view.backgroundColor = [self setBackgroundColor:_temp_model :_temp_value];
        
//        if (tmp_value_nums != _temp_value) {
//            //发送温度
//            NSLog(@"向设备发送温度1 - %d",_temp_value);
//        }
    }
    else
    {
        //变暗动画
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           //延时方法
                           _choose_view.alpha = 1.0f;
                       });
    }
}

- (void)changeArcNums :(int)viewNum
{
//    NSLog(@"changeArcNums - %d",viewNum);
    if(_temp_model == 0)
    {
        _temp_value = 184 + (viewNum * 2);
        if(_temp_value > 214)
        {
            _temp_value = 214;
        }
    }
    else
    {
        _temp_value = 360 + (viewNum * 5);
        if(_temp_value > 420)
        {
            _temp_value = 420;
        }
    }
    
    _temp_lable_set.text = [NSString stringWithFormat:@"%d",_temp_value];
    _choose_view.backgroundColor = [self setBackgroundColor:_temp_model :_temp_value];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

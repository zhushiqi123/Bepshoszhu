//
//  PowerVolumeBar.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/17.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "PowerVolumeBar.h"
#import "STW_BLE_SDK.h"

@implementation PowerVolumeBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
//        int bar_size;
        self.backgroundColor = [UIColor darkGrayColor];
        
        int image_width = (box_circle_radius - 10) * 2;
        int image_height = image_width;
        
        float image_x = (self.bounds.size.width - image_width) / 2.0f;
        float image_y = image_x;

        /*--------------------------设置背景图片--------------------------*/
        UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(image_x,image_y,image_width,image_height)];
        backgroundImage.image = [UIImage imageNamed:@"icon_VBar_P40"];
        
        [self addSubview:backgroundImage];
        
        /*--------------------------设置显示数据Lable--------------------------------*/
        UILabel *powerLableView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, image_width, image_height)];
        powerLableView.center = box_circle_center;
        
//        powerLableView.font = [UIFont systemFontOfSize:60];
        powerLableView.font = [UIFont boldSystemFontOfSize:30]; //加粗方法
        powerLableView.textAlignment = NSTextAlignmentCenter;
        power_num = 5;
        powerLableView.text = @"5W";
        
        [self addSubview:powerLableView];
        
        self.power_lable = powerLableView;
        
        /*---------------------------设置 显示Power Lable-------------------------------*/
        float lable_height = 0;
        float lable_size = 0;
        
        if (iPhone4)
        {
            lable_height = 20.0f;
            lable_size = 24.0f;
        }
        else
        {
            lable_height = 40.0f;
            lable_size = 28.0f;
        }
        
        UILabel *powerStrLableView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, image_width, lable_height)];
        
        powerStrLableView.center = CGPointMake(box_circle_center.x,image_height - (lable_height / 2));
        
        powerStrLableView.font = [UIFont systemFontOfSize:lable_size];
//        powerStrLableView.font = [UIFont boldSystemFontOfSize:20]; //加粗方法
        powerStrLableView.textAlignment = NSTextAlignmentCenter;
        powerStrLableView.text = @"Power";
        
        [self addSubview:powerStrLableView];
        
        self.powerStrLable = powerStrLableView;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame :(CGPoint)circle_center :(float)start_Angle :(float)end_Angle :(float)circle_radius
{
    box_circle_center.x = circle_center.x;
    box_circle_center.y = circle_center.y;
    box_start_Angle = start_Angle;
    box_end_Angle = end_Angle;
    box_circle_radius = circle_radius;
    point_arc = start_Angle;
    
    start_circle_point = [self Arc_to_Point:box_circle_center andWithAngle:0 andWithRadius:circle_radius];
    
    touch_circle_point = start_circle_point;
    
    self = [self initWithFrame:frame];

//    NSLog(@"%f-%f-%f-%f-%f",box_circle_center.x,
//          box_circle_center.y,
//          box_start_Angle,
//          box_end_Angle,
//          box_circle_radius);
    
    if (self)
    {

    }
    
    return self;
}

//手指触摸的状态
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    checkTouchType = [self checkTouchStatus:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (checkTouchType)
    {
//        NSLog(@"画点");
        [self drawing_point_arc:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (checkTouchType)
    {
        [STW_BLE_Protocol the_set_work_mode:BLEProtocolModeTypePower :power_num * 10 :[STW_BLE_SDK STW_SDK].temperatureMold :[STW_BLE_SDK STW_SDK].atomizerMold];
    }
}

-(BOOL)checkTouchStatus:(NSSet *)touches withEvent:(UIEvent *)event
{
    checkTouchType = NO;
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    if (point.x < (touch_circle_point.x + 20) && point.x > (touch_circle_point.x - 20) && point.y < (touch_circle_point.y + 20) && point.y > (touch_circle_point.y - 20))
    {
        checkTouchType = YES;
    }

    return checkTouchType;
}

//由点计算出当前的角度
-(void)drawing_point_arc:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    CGFloat check_arc_point = [self point_to_Arc:box_circle_center :point :start_circle_point];
    
//    NSLog(@"check_arc_point - %f - %f - %f",check_arc_point,box_start_Angle,box_end_Angle);
    
    
    if (check_arc_point > box_end_Angle && check_arc_point < box_start_Angle)
    {
//        NSLog(@"check_arc_point - %f",check_arc_point);
        float nums_check = (box_start_Angle - box_end_Angle) / 2.0f;
        
        if (check_arc_point > nums_check)
        {
            point_arc = box_start_Angle;
            [self refreshTheView];
            [self setNeedsDisplay];
        }
        else
        {
            point_arc = box_end_Angle;
            [self refreshTheView];
            [self setNeedsDisplay];
        }
    }
    else
    {
        point_arc = check_arc_point;
        
        [self refreshTheView];
            
//        NSLog(@"point_arc - %f - %f - %f - %f - %f ",point_arc,box_circle_center.x,box_circle_center.y,point.x,point.y);
        
        [self setNeedsDisplay];
    }
}

//刷新UI
-(void)refreshUI:(int)power
{
    CGFloat power_angle = 0;
    
    if (power == 400)
    {
        power_angle = box_end_Angle;
    }
    else if(power == 50)
    {
        power_angle = box_start_Angle;
    }
    else
    {
        power_angle = [self Progress_to_Arc:power];
    }
    
    point_arc = power_angle;
    
    power_num = power/10;
    
    self.power_lable.text = [NSString stringWithFormat:@"%dW",power_num];
    
    [self setNeedsDisplay];
}

-(void)refreshTheView
{
    CGFloat progress_send = [self Arc_to_Progress:point_arc];
    
    power_num = progress_send * (40 - 5) + 5;
    
    self.power_lable.text = [NSString stringWithFormat:@"%dW",power_num];
}

//绘制背景
- (void)drawRect:(CGRect)rect
{
    /*-------------------------- 绘制调节框的圆弧背 --------------------------------*/
    CGContextRef context_arc = UIGraphicsGetCurrentContext();
    //ffb6c4
    [RGBCOLOR(0xff,0xb6,0xc4) setStroke];
    
    CGContextSetLineWidth(context_arc, 4.0);//线的宽度

    CGContextAddArc(context_arc, box_circle_center.x, box_circle_center.y, box_circle_radius, box_start_Angle*M_PI, box_end_Angle *M_PI,NO);
    
    CGContextStrokePath(context_arc);
    
    /*--------------------------  绘制调节红点  --------------------------------*/
    CGContextRef context_point = UIGraphicsGetCurrentContext();
    //ffb6c4
    [[UIColor redColor] setStroke];
    
    CGContextSetFillColorWithColor(context_point, [UIColor redColor].CGColor);//填充颜色
    
    CGContextSetLineWidth(context_point, 4.0);//线的宽度
    
    CGPoint point_point = [self Arc_to_Point:box_circle_center andWithAngle:point_arc andWithRadius:box_circle_radius];
    
    touch_circle_point = point_point;
    
    float point_max = 10.0f;
    
    if (iPhone4)
    {
        point_max = 8.0f;
    }
    
    CGContextAddArc(context_point, point_point.x, point_point.y, point_max, 0, 2 * M_PI, NO);
    
    CGContextDrawPath(context_point, kCGPathFillStroke); //绘制路径加填充
    
    CGContextStrokePath(context_point);
    /*--------------------------------------------------------------------------*/
}


/**
*  三个点计算角度
*
*  @param point_center 圆心
*  @param point_01     起始的点
*  @param point_02     画的点
*
*  @return 返回角度
*/
-(CGFloat)point_to_Arc:(CGPoint)point_center :(CGPoint)point_01 :(CGPoint)point_02
{
    CGFloat x1 = point_01.x - point_center.x;
    CGFloat y1 = point_01.y - point_center.y;
    CGFloat x2 = point_02.x - point_center.x;
    CGFloat y2 = point_02.y - point_center.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
//    NSLog(@"point_01.y - %f - %f",point_01.y,point_center.y);
    if (point_01.y < point_center.y)
    {
        angle = 2 - angle/M_PI;
    }
    else
    {
        angle = angle/M_PI;
    }
    
    return angle;
}

//由角度转换为百分比
-(CGFloat)Arc_to_Progress:(CGFloat)point_arc_float
{
    CGFloat back_progress;
    
    if (point_arc_float >= box_start_Angle)
    {
        back_progress = ( point_arc_float - box_start_Angle) / (2 - (box_start_Angle - box_end_Angle));
    }
    else
    {
        back_progress = ((2 - box_start_Angle) + point_arc_float) / (2 - (box_start_Angle - box_end_Angle));
        back_progress = back_progress + 0.01;
    }
    
//    NSLog(@"back_progress - %f",back_progress);
    
    return back_progress;
}

//由百分比转换成角度
-(CGFloat)Progress_to_Arc:(int)power_nums
{
    CGFloat back_progress = (power_nums / 10 - 5.0f) / (40.0f - 5.0f);
    
    CGFloat All_angle = 2 - (box_start_Angle - box_end_Angle);
    
    CGFloat back_angle = back_progress * All_angle + box_start_Angle;
  
    return back_angle;
}

/**
 *  由角度计算出第三个点
 *
 *  @param center 圆心
 *  @param angle  角度
 *  @param radius 半径
 *
 *  @return 返回需要画的点
 */
-(CGPoint)Arc_to_Point:(CGPoint)center  andWithAngle:(CGFloat)angle andWithRadius:(CGFloat)radius
{
    CGFloat x2 = radius * cosf((2 - angle) * M_PI);
    CGFloat y2 = radius * sinf((2 - angle) * M_PI);
    return CGPointMake(center.x+x2, center.y-y2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CurveChartBGXIBView.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/21.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "CurveChartBGXIBView.h"
#import "CCTPoint.h"

@implementation CurveChartBGXIBView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//绘制背景
- (void)drawRect:(CGRect)rect
{
    /**---------------------------------------------绘制背景---------------------------------------------**/
    CGContextRef context = UIGraphicsGetCurrentContext();

    int curve_linWidth = 2;
    
    if (iPhone4 || iPhone5)
    {
        curve_linWidth = 1.5f;
    }
    
    //绘制坐标系
    CGContextSetLineWidth(context, curve_linWidth);
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(0x74, 0x74, 0x74).CGColor);
    
    //绘制横坐标
    CGContextMoveToPoint(context, 1, PowerView_Height - 10.0f);
    CGContextAddLineToPoint(context, PowerView_Width,PowerView_Height - 10.0f);
    CGContextStrokePath(context);
    
    //绘制纵坐标
    CGContextMoveToPoint(context, 10.0f, 1);
    CGContextAddLineToPoint(context, 10.0f, PowerView_Height);
    CGContextStrokePath(context);
    
    //绘制纵坐标点
    CGFloat pos_x_coordinates = PowerView_Height - 10.0f;
    
    int n_x = 3;
    
    for (int i = 1; i <= 21; i ++)
    {
        CGContextSetLineWidth(context, curve_linWidth);
        
        if (i == n_x)
        {
            n_x += 4;
            CGContextMoveToPoint(context, 1.0f, pos_x_coordinates);
        }
        else
        {
            CGContextMoveToPoint(context, 4.0f, pos_x_coordinates);
        }
        
        CGContextAddLineToPoint(context, 10.0f, pos_x_coordinates);
        pos_x_coordinates = pos_x_coordinates - box_Side_height;
        
        CGContextStrokePath(context);
    }
    
    //绘制横坐标点
    int pos_y_coordinates = 10.0f;
    
    int n_y = 0;
    
    for (int i = 0; i <= 10; i++)
    {
        if (i == n_y)
        {
            n_y += 5;
            CGContextMoveToPoint(context, pos_y_coordinates, PowerView_Height - 1);
        }
        else
        {
            CGContextMoveToPoint(context, pos_y_coordinates, PowerView_Height - 4.0f);
        }
        
        CGContextAddLineToPoint(context, pos_y_coordinates, (PowerView_Height - 10.0f));
        
        pos_y_coordinates += box_Side_width;
        
        CGContextStrokePath(context);
    }

    //绘制虚线
    int dotted_lines = 10.0f + box_Side_width;
    
    float dotted_lines_height = 0;
    
    //手指选中的线
    int red_dotted_lines = Drawing_arry_type;
    
    for (int i = 1; i <= 10; i++)
    {
        CGContextSetLineWidth(context, curve_linWidth);
        
        if (i == red_dotted_lines)
        {
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        }
        else
        {
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        }
        
        float dotted_line = dotted_lines_height;
        
        while (dotted_line < PowerView_Height - 10.0f)
        {
            CGContextMoveToPoint(context, dotted_lines, dotted_line);
            
            float height_lines = dotted_line + (box_Side_width / 3.0f);
            
            if (height_lines > (PowerView_Height - 10.0f))
            {
                height_lines = PowerView_Height - 12.0f;
            }
            
            CGContextAddLineToPoint(context, dotted_lines, height_lines);
            
            dotted_line = dotted_line + (box_Side_width * 2.0f / 3.0f);
            
            CGContextStrokePath(context);
        }
        
        dotted_lines += box_Side_width;
    }
    /*--------------------------------画线--------------------------------*/
    _point_start = CGPointMake(0,0);
    _point_end = CGPointMake(0,0);
    
    //枚举遍历  相当于java中的增强for循环
    for (CCTPoint *linePoint in _array_CCT)
    {
        CGContextRef cxt = UIGraphicsGetCurrentContext();
        
        CGPoint retrievedPoint = CGPointMake(linePoint.point_x, linePoint.point_y);
        
        CGPoint check_pointd;

        if (_point_end.x == 0)
        {
            check_pointd = retrievedPoint;
        }
        else
        {
            check_pointd = CGPointMake(_point_end.x, _point_end.y);
        }

        /*-------画两点之间的连线------*/
        _point_start = check_pointd;
        _point_end = retrievedPoint;
        
        if(_point_end.x >= _point_start.x)
        {
            float Bezier_point_x = (_point_start.x + _point_end.x)/2.0f;
//            float Bezier_point_y = (_point_start.y + _point_end.y)/2.0f;
            
            UIColor *color = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
            [color set];  //设置线条颜色
            
            UIBezierPath* aPath = [UIBezierPath bezierPath];
            
            aPath.lineWidth = 2.0;
            aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
            aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
            
            [aPath moveToPoint:CGPointMake(_point_start.x, _point_start.y)];
            
            [aPath addCurveToPoint:CGPointMake(_point_end.x, _point_end.y) controlPoint1:CGPointMake(Bezier_point_x, _point_start.y) controlPoint2:CGPointMake(Bezier_point_x, _point_end.y)];
            
            [aPath stroke];

//            // 2.拼接图形(路径)
//            // 设置线段宽度
//            CGContextSetLineWidth(cxt,2);
//            CGContextSetStrokeColorWithColor(cxt, RGBCOLOR(0x00, 0xbe, 0xa4).CGColor);
//            
//            // 设置线段头尾部的样式
//            CGContextSetLineCap(cxt,kCGLineCapRound);
//            
//            // 设置线段转折点的样式
//            CGContextSetLineJoin(cxt,kCGLineJoinRound);
//            
//            // 设置一个起点
//            CGContextMoveToPoint(cxt, _point_start.x,_point_start.y);
//            
//            CGContextAddCurveToPoint(cxt, _point_start.x, _point_start.y, _point_end.x, _point_end.y, Bezier_point_x, Bezier_point_y);
//            
//            // 添加一条线段
//            CGContextAddLineToPoint(cxt,_point_end.x,_point_end.y);
//            // 渲染一次
//            CGContextStrokePath(cxt);
        }
        /*-------画两点之间的连线------*/
        
        //画图每个点
        UIColor*aColor = VCONNEX_COLOR;//RGBCOLOR(0x00, 0xbe, 0xa4);
        
        CGContextSetFillColorWithColor(cxt, aColor.CGColor);//填充颜色
        
        CGContextSetLineWidth(cxt, 2.0);//线的宽度
        
        CGContextAddArc(cxt, retrievedPoint.x, retrievedPoint.y, 6.0, 0, 2*PI, 0); //添加一个圆
        
        CGContextDrawPath(cxt, kCGPathFillStroke); //绘制路径加填充
        
        CGContextStrokePath(cxt);
    }
}

//初始化设置
- (id)initWithFrame:(CGRect)frame :(int)box_width :(int)box_height :(int)arry_type :(NSMutableArray *)setArrys
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        //初始化，表盘所表示的最大最小值
        box_Side_width = box_width;
        box_Side_height = box_height;
        
        Drawing_Width = box_width * 10;
        Drawing_Height = box_height * 20;
        
        PowerView_Width = frame.size.width;
        PowerView_Height = frame.size.height;
        
        Drawing_arry_type = arry_type;

        if (setArrys.count == 11)
        {
            _array_CCT = [NSMutableArray array];
            
            for(CCTPoint *chosePoint in setArrys)
            {
                float chose_x = chosePoint.point_x * box_Side_width + 10.0f;
                    
                float chose_y = (20 - chosePoint.point_y) * box_Side_height + (PowerView_Height - box_Side_height * 20 - 10.0f);
                    
                CCTPoint *CCTchosePoint = [[CCTPoint alloc] init];
                    
                CCTchosePoint.point_x = chose_x;
                CCTchosePoint.point_y = chose_y;
                    
                [_array_CCT addObject:CCTchosePoint];
            }
        }
        else
        {
            _array_CCT = [NSMutableArray array];
            
            for (int i = 0; i < 11; i++)
            {
                CCTPoint *linePoint = [[CCTPoint alloc] init];
                linePoint.point_x = i * box_Side_width + 10.0f;
                linePoint.point_y = 10 * box_Side_height + (PowerView_Height - box_Side_height * 20 - 10.0f);
                
                [_array_CCT addObject:linePoint];
            }
        }
    }
    
    return self;
}

//手指触摸的状态
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self check_point_line:touches :event :0];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self check_point_line:touches :event :1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self check_point_line:touches :event :2];
}

-(void)check_point_line:(NSSet *)touches :(UIEvent *)event :(int)touch_type
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    NSLog(@"(%d - %f,%f)",touch_type,point.x,point.y);
    
    switch (touch_type)
    {
        case 0:
        {
            [self checkStartTouch:point];
        }
            break;
        case 1:
        {
            if (start_touch_Bool)
            {
                [self checkMoveTouch:point];
            }
        }
            
            break;
        case 2:
        {
            if (start_touch_Bool)
            {
                [self checkEndTouch:point];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)checkStartTouch:(CGPoint)touch_points
{
    float start_touch_x = touch_points.x;
    float start_touch_y = touch_points.y;
    
    int checkNum = (start_touch_x) / box_Side_width;
    
    CCTPoint *check_point = [_array_CCT objectAtIndex:checkNum];
    
    float check_y = check_point.point_y;
    
    if (check_y > (start_touch_y - 10.0f) && check_y < (start_touch_y + 10.0f))
    {
//        NSLog(@"start_touch_x - %d",checkNum);
        start_touch_Bool = YES;
        
        Drawing_arry_type = checkNum;
        
        int checkNum = (check_y - (PowerView_Height - box_Side_height * 20 - 10.0f)) / box_Side_height;
        
        [self refreshUICurve:Drawing_arry_type :checkNum];
    }
    else
    {
        start_touch_Bool = NO;
    }
}

-(void)checkMoveTouch:(CGPoint)touch_points
{
    float move_touch_y = touch_points.y;
    
    int checkNum = (move_touch_y - (PowerView_Height - box_Side_height * 20 - 10.0f)) / box_Side_height;
    
//    NSLog(@"checkNum - %d - %d",Drawing_arry_type,checkNum);
    
    if (checkNum < 0)
    {
        checkNum = 0;
    }
    
    if (checkNum > 20)
    {
        checkNum = 20;
    }

    CCTPoint *check_point_obj = [[CCTPoint alloc]init];
    
    check_point_obj.point_x = Drawing_arry_type * box_Side_width + 10.0f;
    check_point_obj.point_y = checkNum * box_Side_height + (PowerView_Height - box_Side_height * 20 - 10.0f);
    
    [_array_CCT replaceObjectAtIndex:Drawing_arry_type withObject:check_point_obj];
    
    [self refreshUICurve:Drawing_arry_type :checkNum];
}

//刷新UI
-(void)refreshUICurve:(int)x_nums :(int)y_nums
{
    //进行回调
    if (self.CCTCurveData)
    {
        self.CCTCurveData(x_nums,y_nums);
    }
    
    //刷新界面
    [self setNeedsDisplay];
}

-(void)checkEndTouch:(CGPoint)touch_points
{
//    NSLog(@"手指抬起");
}

//刷新界面
-(void)refreshUI:(int)arry_type :(NSMutableArray *)setArrys
{
    Drawing_arry_type = arry_type;
    
    if (setArrys.count == 11)
    {
        _array_CCT = [NSMutableArray array];
        
        for(CCTPoint *chosePoint in setArrys)
        {
            float chose_x = chosePoint.point_x * box_Side_width + 10.0f;
            
            float chose_y = (20 - chosePoint.point_y) * box_Side_height + (PowerView_Height - box_Side_height * 20 - 10.0f);
            
            CCTPoint *CCTchosePoint = [[CCTPoint alloc] init];
            
            CCTchosePoint.point_x = chose_x;
            CCTchosePoint.point_y = chose_y;
            
            [_array_CCT addObject:CCTchosePoint];
        }
    }
    
    //刷新界面
    [self setNeedsDisplay];
}

//获取曲线数据
-(NSMutableArray *)getCCTData
{
    NSMutableArray *getCCTArrts = [NSMutableArray array];
    
    for(CCTPoint *chosePoint in _array_CCT)
    {
        int checkNum = (chosePoint.point_y - (PowerView_Height - box_Side_height * 20 - 10.0f)) / box_Side_height;
        
        //    NSLog(@"checkNum - %d - %d",Drawing_arry_type,checkNum);
        
        if (checkNum < 0)
        {
            checkNum = 0;
        }
        
        if (checkNum > 20)
        {
            checkNum = 20;
        }
        
        [getCCTArrts addObject:[NSString stringWithFormat:@"%d",checkNum]];
    }
    
    return getCCTArrts;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  Animation Panel.m
//  GaugePanel
//
//  Created by 朱世琦 on 17/12/2.
//  Copyright © 2017年 zsq. All rights reserved.
//

/*
  实现带动画的圆  盘
    一共有7个圆圈 
     一个渐变的动画
      一个渐变的圆心 
      一个图片加动画
 
 */

#import "RCTConvert+Animation.h"
#import "Animation Panel.h"
#define degreesToRadians(x) (M_PI*(x)/180.0) //角度转换的宏
#define angleToFloat(x)   (180.0*(x)/M_PI)
#define sameWithValue angleToFloat(degreesToRadians(270)/100);

@interface Animation_Panel ()
{
    CGPoint _centerPoint; // 定义中心点的位置
    float _scale; //设置拉伸的比例
    CGFloat  _angle;
    bool flag;
   BOOL  change_Value;//是否可以触摸改动值
    BOOL  ispoint ; // 是否显示指针
  NSString  * isunitDirection; // 单位的位置(right,bottom)
  CGFloat isvalue; // 要显示的值
  CGFloat  ispadding;// 设置外边距
}

@property (nonatomic,strong) CAShapeLayer *progressLayer;// 使用CAshapeLayer 实现颜色的渐变
@property (nonatomic  ,strong) UIImageView * image; // 定义imageview
@property (nonatomic ,weak)NSTimer * nstimer;//设置定时器
/** 当前的秒针 */
@property (nonatomic, weak)   CALayer *secL;
@end
#define FoltToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
static const float kPROGRESS_LINE_WIDTH=10.0; //  设置圆环的宽度

@implementation Animation_Panel

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher{
  if (self = [super init]) {
    
    flag= false;
        self.opaque=NO;
        self.backgroundColor=[UIColor clearColor];
  }
  
  return self;
}


// 属性传值    传递过来的值
- (void)setChangeValue:(BOOL)changeValue{// 是否可以触摸改变值显示指针
  NSLog(@"xxx=%@",changeValue);
  
}
-  (void)setPoint:(BOOL)point{ // 是否显示指针
//  NSLog(@"xxx=%@",point);
  ispoint= point;
  [self setNeedsDisplay];
}

+(void)startAroundAnim{
 
  NSLog(@"开始动画");

}
+ (void)stopAroundAnim{

  NSLog(@"结束动画");

}
-   (void)setUnitDirection:(NSString *)unitDirection{ // 单位显示的位置
  NSLog(@"xxx=%@",unitDirection);
  isunitDirection=unitDirection;
}

- (void)setValue:(NSInteger)value{//设置值的多少
  NSLog(@"xxx=%ld",(long)value);
  isvalue= value;
}

-(void)setValueconfig:(valueconfigConnection)valueconfig{
  CGFloat min=  valueconfig.maxValue; // 最大值
  CGFloat max=  valueconfig.minValue; // 最小值
  float  startAngle= valueconfig.sweepAngle;  // 开始的角度
  float  sweepAngel= valueconfig.sweepAngle;// 绘制度数的角度
  NSString  * unit= valueconfig.unit;   // 单位
  NSString * format= valueconfig.format;  // 格式化值
  float  mSection= valueconfig.mSection;   // 刻度分割数
  float defaultValue= valueconfig.defaultValue;// 默认值
  NSLog(@"结构体输出的值是min==%f",min);
  NSLog(@"结构体输出的值是max==%f",max);
  NSLog(@"结构体输出的值是startAngle==%f",startAngle);
  NSLog(@"结构体输出的值是sweepAngel==%f",sweepAngel);
  NSLog(@"结构体输出的值是unit==%@",unit);
  NSLog(@"结构体输出的值是format==%@",format);
  NSLog(@"结构体输出的值是mSection==%f",mSection);
  NSLog(@"结构体输出的值是defaultValue==%f",defaultValue);
  // 刻度的间隔
  
  // 视图的重绘
  [self setNeedsDisplay];
  //实时的刷新数据 电量的数据显示
  


}

- (void)drawRect:(CGRect)rect {
    /* 初始化中心点的位置 */
    CGFloat  mainWeight=[UIScreen mainScreen ].bounds.size.width;
    //CGFloat  mainHeight=[UIScreen mainScreen].bounds.size.width;
    _centerPoint= CGPointMake(rect.size.width/2, rect.size.height/2);
         CGFloat scaleWeight=414;
       _scale=rect.size.width/scaleWeight; // 根据宽的比例进行缩放 // 根据宽的比例进行缩放

   NSLog(@"连接的缩放比例%f",_scale);
    //开始绘图
    [self  drawAnimation_Panel:_scale centerPoint:_centerPoint];

 
}
  /* 画圆通用的的方法 */
- (void)drawCircle :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint  crilePath:(UIBezierPath *) path{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* rimPath1 =path;
    [rimPath1 stroke];
    CGContextRestoreGState(context);
}
// 画圆弧的方法
- (void)drawArc :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint  ArcPath:(UIBezierPath *) path
{
    CGContextSaveGState(context);
    UIBezierPath *arcpath= path;
    [arcpath stroke];
    
    CGContextRestoreGState(context);

}
//绘制的主要方法
- (void)drawAnimation_Panel: (CGFloat)scale centerPoint:(CGPoint)centerPoint{

    CGContextRef context = UIGraphicsGetCurrentContext(); // 获取上下文对象
   /*画出7个圆 由外围到中心*/

    
    //// 画出边框第4个
    UIBezierPath* rimPath4 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-200, -200, 200*2, 200*2)];
    
    [[UIColor colorWithRed:  153/255.0 green: 172/255.0 blue: 178/255.0 alpha: 1] setStroke];
    //设置线宽
    rimPath4.lineWidth = 10;
    [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath4];
    

    //// 画出边框第5个
    UIBezierPath* rimPath5 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-193, -193, 193*2, 193*2)];
    
    [[UIColor colorWithRed:  124/255.0 green: 155/255.0 blue: 165/255.0 alpha: 1] setStroke];
    //设置线宽
    rimPath5.lineWidth = 5;
    [ self  drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath5];

    //// 画出边框第6个
    UIBezierPath* rimPath6 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-188, -188, 188*2, 188*2)];
    
    [[UIColor colorWithRed:  23/255.0 green: 116/255.0 blue: 143/255.0 alpha: 1] setStroke];
    //设置线宽
    rimPath6.lineWidth = 4;
    [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath6];
    //// 画出边框第7个
    UIBezierPath* rimPath7 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-160, -160, 160*2, 160*2)];
    
    [[UIColor colorWithRed:  44/255.0 green: 218/255.0 blue: 244/255.0 alpha: 1] setStroke];
    //设置线宽
    rimPath7.lineWidth = 12;
    [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath7];
    //// 画出边框第8个
    UIBezierPath* rimPath8 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-125, -125, 125*2, 125*2)];
    
    [[UIColor colorWithRed:  129/255.0 green: 142/255.0 blue: 146/255.0 alpha: 1] setStroke];
    //设置线宽
    rimPath8.lineWidth = 6;
    [self  drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath8];
     // 绘制颜色渐变的一个圆 由中心想四周进行渐变

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    UIBezierPath* rimPath9 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-120, -120, 120*2, 120*2)];
    UIColor  *startColor =[UIColor colorWithRed:  47/255.0 green: 88/255.0 blue: 94/255.0 alpha: 1];
    UIColor *endColor=[UIColor colorWithRed:  0/255.0 green: 0/255.0 blue: 0/255.0 alpha: 1];
    // 调用方法 画渐变的方法
    [self  drawRadialGradient:context path:rimPath9.CGPath startColor:startColor.CGColor endColor:endColor.CGColor];
    CGContextRestoreGState(context);
    /*绘制一个圆弧 动态的圆弧  右边的 */
    UIBezierPath* arcpath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                           radius:160*scale
                                                       startAngle:degreesToRadians(315)
                                                         endAngle:degreesToRadians(360)
                                                        clockwise:YES];
    
    [[UIColor yellowColor] set];

    arcpath.lineWidth     = 20.f*scale;
    arcpath.lineCapStyle  = kCGLineCapSquare;
    arcpath.lineJoinStyle = kCGLineCapSquare;
    [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath];

   
    
    UIBezierPath* arcpath2 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                           radius:160*scale
                                                       startAngle:degreesToRadians(360)
                                                         endAngle:degreesToRadians(45)
                                                        clockwise:YES];
    [[UIColor redColor] set];

    arcpath2.lineWidth     = 20.f*scale;
    arcpath2.lineCapStyle  = kCGLineCapSquare;
    arcpath2.lineJoinStyle = kCGLineCapSquare;
    [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath2];
    
    // 添加黑色的线条
    // 画出刻度盘
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context,_scale, _scale);
    for (int i=0; i<13; i++) {
        
        
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 5);
        //设置颜色
        CGContextSetRGBStrokeColor(context,  0, 0, 0,1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context, 74+35, -65-35);
        //下一点
        CGContextAddLineToPoint(context, 84+40, -75-40);
        //下一点
        //绘制完成
        CGContextRotateCTM(context, M_PI/13.3333/2);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
  
       /*绘制一个圆弧 动态的圆弧  左边的*/
    UIBezierPath* arcpath3 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                           radius:160*scale
                                                       startAngle:degreesToRadians(135)
                                                         endAngle:degreesToRadians(180)                                                        clockwise:YES];
    
    arcpath3.lineWidth     = 20.f*scale;
    arcpath3.lineCapStyle  = kCGLineCapSquare;
    arcpath3.lineJoinStyle = kCGLineCapSquare;
     [[UIColor redColor] set];
    [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath3];
    UIBezierPath* arcpath4 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                            radius:160*scale
                                                        startAngle:degreesToRadians(180)                                                          endAngle:degreesToRadians(225)
                                                         clockwise:YES];
    
    arcpath4.lineWidth     = 20.f*scale;
    arcpath4.lineCapStyle  = kCGLineCapSquare;
    arcpath4.lineJoinStyle = kCGLineCapSquare;
    [[UIColor yellowColor] set];
    [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath4];
    // 添加黑色的线条
    // 画出刻度盘
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context,_scale, _scale);
    for (int i=0; i<13; i++) {
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 5);
        //设置颜色
        CGContextSetRGBStrokeColor(context,  0, 0, 0,1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
        CGContextMoveToPoint(context, -74-35, 65+35);
        //下一点
        CGContextAddLineToPoint(context, -84-40, 75+40);
        //下一点
        //绘制完成
        CGContextRotateCTM(context, M_PI/13.3333/2);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
     NSLog(@"ispoint value: %@" ,ispoint?@"YES":@"NO");
  
 
       // 控制指针是否显示
    if (ispoint) {
      self.image.hidden= NO;
      [self.image.layer  setHidden:NO] ;
        //  添加图片到 视图中去
      if (texyt==0) {
        [self imaageViewToTransform:context Scale:scale CenterPoint:centerPoint];
        texyt++;
      }
    }else{
       // 清除到图层
      self.image.hidden= YES;
      [self.image.layer  setHidden:YES] ;
    }
  
    if (self.nstimer==nil) {
    _nstimer= [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    

  }
  
      }

- (void)dealloc{
  [_nstimer timeInterval];
}
- (void)timeChange {
  
  if(flag){
    
    self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
    _angle += degreesToRadians(1); // 控制指针旋转的间隔
    
  }
  
  
  
}



int texyt=0;
// 添加旋转的图片到圆心
- (void)imaageViewToTransform :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint {
    UIImageView  *imgage= [[UIImageView alloc] init];
    UIImage  *origImage= [UIImage imageNamed:@"pointer"];
    CGFloat orWeigth= origImage.size.width;
    CGFloat orHeight= origImage.size.height;
    origImage=[self imageCompressWithSimple:origImage scale:scale];
    imgage.image= origImage;
    
    
    imgage.layer.bounds=CGRectMake(0, 0, orWeigth, orHeight);
    
    imgage.layer.anchorPoint = CGPointMake(0.5*scale, 1.05*scale);
    imgage.layer.position = CGPointMake(centerPoint.x, centerPoint.y);
    
    [self.layer addSublayer:imgage.layer];
    _image= imgage;
    _angle=degreesToRadians(0);  // 定义默认的角度
   

}
/*开始动画*/



- (void ) startAnimation{
  flag=true;
    NSLog(@"开始动画===");
}
// 触摸时结束动画

- (void) endAnimation{
  // 结束动画
  flag=false;
  
  [self setNeedsDisplay];
   NSLog(@"touchesBegan结束动画===");
}

 //  图片的等比例缩放
- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(size); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 半径方向的渐变
 参数的说明   上下文对象
 绘制的路径
 开始的颜色
 结束时的颜色
 
 */
- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}




@end

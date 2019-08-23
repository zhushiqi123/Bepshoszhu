//
//  ElectricQuantity.m
//  GaugePanel
//
//  Created by 朱世琦 on 17/12/4.
//  Copyright © 2017年 zsq. All rights reserved.
//

#import "ElectricQuantity.h"



//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define degreesToRadians(x) (M_PI*(x)/180.0)
#define PaddingToChange_value(x) (ceil(sqrt((pow(x, 2)/2))))  // 计算坐标点的公式
#define PADDING_2  (paddingM*2)  // padding  的双倍公式
#define degreesToRadians(x) (M_PI*(x)/180.0) //将值换成角度
#define angleToFloat(x)   (180.0*(x)/M_PI)// 将角度换成值
#define sameWithValue angleToFloat(degreesToRadians(270)/100) // 一个刻度对应的角度
@interface ElectricQuantity ()

{
        int reacpt; // 指针的方法调用一次
         float _scale; //设置拉伸的比例
         CGPoint _centerPoint; // 定义中心点的位置
         CGFloat  _angle;  // 指针旋转的度数
         CGFloat paddingM; // 圆与四周的距离
         float  scaleImage; // 图片适应边距的变化
         // 实时的更新数据 电量的数据
         float  realElectricValue;
    
         // 刻度的间隔
    float  spaceValue;
         // 旋转的次数
    NSInteger rotateCount;
    NSInteger  minValue; //最小值
    NSInteger maxValue; // 最大值
    // 计算显示的值
    NSInteger value1;
    NSInteger value2;
    NSInteger value3;
    NSInteger value4;
    NSInteger value5;
    NSInteger value6;
    NSInteger value7;
    NSInteger value8;
    NSInteger value9;
    NSInteger value10;
    NSInteger value11;
    
     // 设置中间的文字
     NSInteger  centerValue;
     // 设置单位
     NSString *centerUnit;
     // 显示的格式
     NSString  * format;
  BOOL  change_Value;//是否可以触摸改动值
  BOOL  ispoint ; // 是否显示指针
  NSString  * isunitDirection; // 单位的位置(right,bottom)
  CGFloat isvalue; // 要显示的值
  CGFloat  ispadding;// 设置外边距
}
@property (nonatomic  ,strong) UIImageView * image; // 定义imageview

@property (nonatomic ,strong)UIPanGestureRecognizer  *pan;
@end
@implementation ElectricQuantity
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher{
    if ((self = [super init])) {
            self.opaque=NO;
            self.backgroundColor=[UIColor clearColor];
    [self setup];
      }
    
    return self;
}

// 触摸改变值 添加手势

-(void) setup{
   // 添加手势
//  UIPanGestureRecognizer   pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//  pan.delegate=self;
  
 _pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  
 [self addGestureRecognizer:_pan];
}

//触摸改变值
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

  if (!change_Value) {
    self.onChange(@{@"event":@"click"  ,   @"value":@(centerValue) });
  }
  NSLog(@"touchesBegan value: %@" ,change_Value?@"YES":@"NO");

 NSLog(@"手势状态单机触摸事件");
}
- (void) handlePan: (UIPanGestureRecognizer *) gesture
{
  if ( gesture.state== UIGestureRecognizerStateBegan) {
    
//    self.onChange(@{@"event":@"click"  ,   @"value":@(centerValue) });
  
  }

  if (gesture.state == UIGestureRecognizerStateEnded) {//停止滑动
    
  self.onChange(@{@"event":@"onValueChange"  ,   @"value":@(centerValue) });
    [self valueRefesh];
    [self setNeedsDisplay];
  }
  
  CGPoint currentPosition = [gesture locationInView:self]; //锁定当前的判定点
  
  if (gesture.state == UIGestureRecognizerStateChanged) //正在改变
  {
    NSLog(@"手势正在改变");
    NSLog (@"手势正在改变  [%f,%f]",currentPosition.x, currentPosition.y);
    // 计算间隔的位置 计算位置的变化
           // 如果x 的值在增大  则加    否则减去
           // 根据x y 到圆心的距离 算出弧度
    CGFloat    distancex= currentPosition.x-_centerPoint.x;
    CGFloat    distanccey= currentPosition.y- _centerPoint.y;
      //  double atan2(double a, double b)
    float  xy= atan2(distancex, distanccey);  // 等到一个弧度
    CGFloat   anglexy  =  RADIANS_TO_DEGREES(xy);
      NSLog(@"坐标的反正切值%f",xy);
    //NSLog(@"坐标的反正切值==%f",anglexy);
        // 根据正负 进行判断
    if (anglexy<0) {
      
      /*最大值和最小值的差  除以  270度 等于每个值占了多少度数 */
      CGFloat ge= (float)(maxValue-minValue)/270;// 每个值间隔的度数
      NSLog(@"ge=jiange输出间隔%f",ge);
      //当前值减去最小值 算出一共有多少个间隔
      CGFloat  jiange=    centerValue-minValue;
      NSLog(@"jiange输出间隔%f",jiange);
      //  算出一共宽了多少度
      CGFloat total= ge* jiange;
      NSLog(@"输出间隔=======%f",total);
       // NSLog(@"坐标的反正切值==%f",(360-(anglexy+360)+90-135)*0.28f+149);
       NSLog(@"坐标的反正切值==%f",(360-(anglexy+360)+90-135)*0.28f+149);
      centerValue  =(360-(anglexy+360)+90-135)*ge+minValue;
      
      
    }else{
      /*最大值和最小值的差  除以  270度 等于每个值占了多少度数 */
      CGFloat ge= (float)(maxValue-minValue)/270;// 每个值间隔的度数
      NSLog(@"ge=jiange输出间隔%f",ge);
       centerValue  =(360-anglexy+90-135)*ge+minValue;
     NSLog(@"坐标的反正切值==%f",(360-anglexy+90-135)*ge+minValue );
      //centerValue =360-anglexy+90
      
    }
     [self valueRefesh];
     [self setNeedsDisplay];
 
    
  }
}




 //   使用属性传值
- (void)setChangeValue:(BOOL)changeValue{// 是否可以触摸改变值显示指针
    NSLog(@"xxx=%@",changeValue);
    // change_Value= changeValue;
    change_Value= changeValue;
  
      //根据值禁用手势
  if(changeValue){
    [self.pan setEnabled:YES];
  
  }else{
    [self.pan setEnabled:NO];
  
  }
  
  
  NSLog(@"ifReadOnly 是否可以触摸改gb变值value: %@" ,changeValue?@"YES":@"NO");
  [self setNeedsDisplay] ;
  
}
-  (void)setPoint:(BOOL)point{ // 是否显示指针
    NSLog(@"xxx=%@",point);
    ispoint =point;
}


-   (void)setUnitDirection:(NSString *)unitDirection{ // 单位显示的位置
    NSLog(@"xxx=%@",unitDirection);
    isunitDirection=unitDirection;
}

- (void)setValue:(float)value{//设置值的多少
    NSLog(@"xxx值是value=%f",value);
  
  
   centerValue= value+0.5;
  NSLog(@"_isvalue==%f",centerValue);
  [self setNeedsDisplay];
   [self valueRefesh];
}
- (void)setValueconfig:(valueconfigElectric)region{
    CGFloat min=  region.maxValue; // 最大值
    CGFloat max=  region.minValue; // 最小值
    float  startAngle= region.sweepAngle;  // 开始的角度
    float  sweepAngel= region.sweepAngle;// 绘制度数的角度
    NSString  * unit= region.unit;   // 单位
    NSString * format= region.format;  // 格式化值
    float  mSection= region.mSection;   // 刻度分割数
    float defaultValue= region.defaultValue;// 默认值
    NSLog(@"结构体输出的值是min==%f",min);
    NSLog(@"结构体输出的值是max==%f",max);
    NSLog(@"结构体输出的值是startAngle==%f",startAngle);
    NSLog(@"结构体输出的值是sweepAngel==%f",sweepAngel);
    NSLog(@"结构体输出的值是unit==%@",unit);
    NSLog(@"结构体输出的值是format==%@",format);
    NSLog(@"结构体输出的值是mSection==%f",mSection);
    NSLog(@"结构体输出的值是defaultValue==%f",defaultValue);
       // 刻度的间隔
    if (mSection<10) {
        mSection=10;
      }
     minValue  = min;
     maxValue= max;
     spaceValue  = (maxValue-minValue)/mSection;// 刻度的间隔
  
    NSLog(@"spaceValue间隔的值是%f",spaceValue);
       // 旋转的次数
     rotateCount =mSection+2;
      // 算出 要显示的值
     value1= minValue+(spaceValue*0);
     value2= minValue+(spaceValue*1);
     value3= minValue+(spaceValue*2);
     value4= minValue+(spaceValue*3);
     value5= minValue+(spaceValue*4);
     value6= minValue+(spaceValue*5);
     value7= minValue+(spaceValue*6);
     value8= minValue+(spaceValue*7);
     value9= minValue+(spaceValue*8);
     value10= minValue+(spaceValue*9);
     value11= minValue+(spaceValue*10);
    
     //设置中间的文字
//    _isvalue= region.defaultValue;
     // 设置中间的单位
    centerUnit = region.unit;
    // 显示的格式
    format= region.format;
       // 视图的重绘
   [self setNeedsDisplay];
    //实时的刷新数据 电量的数据显示
    [self valueRefesh];
}
// 设置刻度值
- (void)setupKeDuValue{
  
}
    reacpt=0;
- (void)drawRect:(CGRect)rect {
       /* 初始化中心点的位置 */
       CGFloat  mainWeight=[UIScreen mainScreen ].bounds.size.width;
  
       _centerPoint= CGPointMake(rect.size.width/2, rect.size.width/2);
        CGFloat scaleWeight=414;
       _scale=rect.size.width/scaleWeight; // 根据宽的比例进行缩放
  NSLog(@"比例的宽度%f",mainWeight); // 414;
       NSLog(@"输出原始的比例%f",_scale);
 
       // 开始绘制
      [self drawElectricQuantity:_scale centerPoint:_centerPoint];
}
/*根据电量确定指针的位置*/


/* 画圆通用的的方法 */
- (void)drawCircle :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint  crilePath:(UIBezierPath *) path{
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
        UIBezierPath* rimPath1 =path;

      [rimPath1 stroke];
      CGContextRestoreGState(context);
}
// 画圆弧的方法
- (void)drawArc :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint  ArcPath:(UIBezierPath *) path
{
      CGContextSaveGState(context);
      UIBezierPath *arcpath= path;
      arcpath.lineCapStyle  = kCGLineCapSquare;
      arcpath.lineJoinStyle = kCGLineCapSquare;
      [arcpath stroke];
      
      CGContextRestoreGState(context);
      
}
//绘制的主要方法
- (void)drawElectricQuantity: (CGFloat)scale centerPoint:(CGPoint)centerPoint{
         // 打印屏幕的宽和高
  
       /* 一共需要画8个圆*/
      CGContextRef context= UIGraphicsGetCurrentContext();  // 获取上下文对象
  
      // 绘制一个黑色的圆
  // 画一个黑色的圆
     CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
   UIBezierPath* blcak = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-125-75 +paddingM, -125-75+paddingM, 250+75+75-PADDING_2, 250+75+75-PADDING_2)];
  
  [[UIColor colorWithRed:  0/255.0 green: 0/255.0 blue:0/255.0 alpha: 1] setFill];
  //设置线宽
  blcak.lineWidth = 15;
  [blcak fill];
  CGContextRestoreGState(context);
      //第一个圆
  
      UIBezierPath* rimPath1 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-125-75 +paddingM, -125-75+paddingM, 250+75+75-PADDING_2, 250+75+75-PADDING_2)];
      
      [[UIColor colorWithRed:  153/255.0 green: 172/255.0 blue: 178/255.0 alpha: 1] setStroke];
      //设置线宽
      rimPath1.lineWidth = 12;
      [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath1 ];
      
      //// 画出边框第2个
      UIBezierPath* rimPath2 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-123-70+paddingM, -123-70+paddingM, 246+70+70-PADDING_2, 246+70+70-PADDING_2)];
      
      [[UIColor colorWithRed:  124/255.0 green: 155/255.0 blue: 165/255.0 alpha: 1] setStroke];
      //设置线宽
      rimPath2.lineWidth = 3;
      [self  drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath2];
      // 第三个圆
      UIBezierPath* rimPath3 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-120-68+paddingM, -120-68+paddingM, 240+68+68-PADDING_2, 240+68+68-PADDING_2)];
      
      [[UIColor colorWithRed:  23/255.0 green: 116/255.0 blue: 143/255.0 alpha: 1] setStroke];
      //设置线宽
      rimPath3.lineWidth = 5;
      [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath3];
      
      //// 画出边框第4个
      UIBezierPath* rimPath4 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-112-57+paddingM, -112-57+paddingM, 224+57+57-PADDING_2, 224+57+57-PADDING_2)];
      
      [[UIColor colorWithRed:  44/255.0 green: 218/255.0 blue: 244/255.0 alpha: 1] setStroke];
      //设置线宽
      rimPath4.lineWidth = 12;
      [self drawCircle:context Scale:scale CenterPoint:centerPoint crilePath:rimPath4];
      
      // 化第一个圆弧个圆弧
      UIBezierPath* arcpath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                          radius:(88+37-paddingM)*scale
                                                                                      startAngle:degreesToRadians(135)
                                                                                        endAngle:degreesToRadians(45)
                                                                                       clockwise:YES];
      
      arcpath.lineWidth     = 1.f;
      arcpath.lineCapStyle  = kCGLineCapSquare;
      arcpath.lineJoinStyle = kCGLineCapSquare;
      [[UIColor colorWithRed:  45/255.0 green: 239/255.0 blue: 255/255.0 alpha: 1] set];
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath];
       // 画第二个圆弧
      UIBezierPath* arcpath2 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                           radius:(84+37-paddingM)*scale
                                                                                       startAngle:degreesToRadians(120)
                                                                                         endAngle:degreesToRadians(60)
                                                                                        clockwise:YES];
      
      arcpath2.lineWidth     = 1.5f;
      arcpath2.lineCapStyle  = kCGLineCapSquare;
      arcpath2.lineJoinStyle = kCGLineCapSquare;
      [[UIColor colorWithRed:  38/255.0 green: 216/255.0 blue: 245/255.0 alpha: 1] set];
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath2];
      
       // 画第三个圆弧
      UIBezierPath* arcpath3 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                           radius:(72+30-paddingM)*scale
                                                                                       startAngle:degreesToRadians(135)                                                         endAngle:degreesToRadians(45)
                                                                                        clockwise:YES];
      
      arcpath3.lineWidth     = 1.2f;
      arcpath3.lineCapStyle  = kCGLineCapSquare;
      arcpath3.lineJoinStyle = kCGLineCapSquare;
      [[UIColor whiteColor] set];
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:arcpath3];
      // 绘制颜色渐变的一个圆 由中心想四周进行渐变
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
      
      UIBezierPath* rimPath9 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-71-30+paddingM, -71-30+paddingM, 142+30+30-PADDING_2, 142+30+30-PADDING_2)];
      
      
      UIColor  *startColor =[UIColor colorWithRed:  47/255.0 green: 88/255.0 blue: 94/255.0 alpha: 1];
      UIColor *endColor=[UIColor colorWithRed:  0/255.0 green: 0/255.0 blue: 0/255.0 alpha: 1];
      // 调用方法 画渐变的方法
      [self  drawRadialGradient:context path:rimPath9.CGPath startColor:startColor.CGColor endColor:endColor.CGColor];
      CGContextRestoreGState(context);
      
  //    // 绘制中心的文字
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
    //   CGRect text12Rect = CGRectMake(-75, -50, 150, 100);
      CGRect text12Rect = CGRectMake(-75, -50, 150, 100);
      {

//         NSString * textContent= [format isEqualToString:@"0.0"]? [NSString stringWithFormat:@"%.1f",centerValue]:[NSString stringWithFormat:@"%.0f",centerValue];
    
    if (centerValue >maxValue) {
      centerValue  = maxValue;
    }
    if (centerValue <minValue) {
      centerValue= minValue;
    }
    
          NSString * textContent= [NSString stringWithFormat:@"%li",centerValue];
            NSMutableParagraphStyle* text12Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            text12Style.alignment = NSTextAlignmentCenter;
            
            NSDictionary* text12FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:58], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: text12Style};
            
            [textContent drawInRect: CGRectOffset(text12Rect, 0, (CGRectGetHeight(text12Rect) - [textContent boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes context: nil].size.height) / 2) withAttributes: text12FontAttributes];
        }
      
      CGContextRestoreGState(context);
    //    // 绘制中心的单位
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    //   CGRect text12Rect = CGRectMake(-75, -50, 150, 100);
    CGRect text12Rectunit = CGRectMake(15, 20, 50, 50);
    {
        //NSString* textContent = self.titleCenter!=nil? self.titleCenter: @"19%";
        NSString * textContentunit=centerUnit;
        //NSString* textContent =[NSString stringWithFormat:@""]; ;
        NSMutableParagraphStyle* text12Styleunit = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12Styleunit.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributesunit = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:23], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: text12Styleunit};
        
        [textContentunit drawInRect: CGRectOffset(text12Rectunit, 0, (CGRectGetHeight(text12Rectunit) - [textContentunit boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributesunit context: nil].size.height) / 2) withAttributes: text12FontAttributesunit];
      }
    
    CGContextRestoreGState(context);
  
      // 画出刻度值
      /* 画出零*/
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
      
       NSString* textContent =@"50";
      for (int i=0 ; i<=rotateCount; i++) {
           
            CGRect text12Rect0 = CGRectMake(-12.5, -110-45+paddingM, 40, 25);
            {
         
                  
                  switch (i) {
                          case 0:
                              
                              textContent =[NSString stringWithFormat:@"%li",value6];
                          
                              break;
                          case 1:
                             textContent = [NSString stringWithFormat:@"%li",value7];
                              break;
                          case 2:
                             textContent = [NSString stringWithFormat:@"%li",value8];
                              break;
                          case 3:
                              textContent = [NSString stringWithFormat:@"%li",value9];
                              break;
                          case 4:
                          textContent =[NSString stringWithFormat:@"%li",value10];
          
                              break;
                          case 5:
                          textContent =[NSString stringWithFormat:@"%li",value11];
          
                              break;
                          case 6:
                              textContent =@"";
                              break;
                          case 7:
                              textContent =@"";
                              break;
                          case 8:
                              textContent = [NSString stringWithFormat:@"%li",value1];
                              break;
                          case 9:
                             textContent =[NSString stringWithFormat:@"%li",value2];
                              break;
                          case 10:
                             textContent = [NSString stringWithFormat:@"%li",value3];
                              break;
                          case 11:
                               textContent =[NSString stringWithFormat:@"%li",value4];
                              break;
                          case 12:
                              textContent = [NSString stringWithFormat:@"%li",value5];
                              break;
          
                          default:
                              textContent =@"50";
                              break;
                    }
                  
                  NSMutableParagraphStyle* text12Style0 = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                  text12Style0.alignment = NSTextAlignmentCenter;
                  
                  NSDictionary* text12FontAttributes0 = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:23], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: text12Style0};
                  
                  [textContent drawInRect: CGRectOffset(text12Rect0, 0, (CGRectGetHeight(text12Rect0) - [textContent boundingRectWithSize: text12Rect0.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes0 context: nil].size.height) / 2) withAttributes: text12FontAttributes0];
              }
            
            // 开始旋转
            CGContextRotateCTM(context, M_PI/6.5);
        }
      
      CGContextRestoreGState(context);
        // 画出刻度盘
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context,_scale, _scale);
      for (int i=0; i<21; i++) {
            
                    //指定直线样式
            CGContextSetLineCap(context, kCGLineCapSquare);
            //直线宽度
            CGContextSetLineWidth(context, 1.5);
            //设置颜色
            CGContextSetRGBStrokeColor(context,  255, 255, 255,1.0);
            //开始绘制
            CGContextBeginPath(context);
            //画笔移动到点(31,170)
                   CGContextMoveToPoint(context, -51-22+PaddingToChange_value(paddingM), 51+22-PaddingToChange_value(paddingM));
            //下一点
            CGContextAddLineToPoint(context, -56-25+PaddingToChange_value(paddingM), 56+25 -PaddingToChange_value(paddingM));
            //下一点
            //绘制完成
            CGContextRotateCTM(context, M_PI/13.3333);
            CGContextStrokePath(context);
        }
      CGContextRestoreGState(context);
      
      // 画出刻度盘精细的刻度
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context,_scale, _scale);
      for (int i=0; i<81; i++) {
            //指定直线样式
            CGContextSetLineCap(context, kCGLineCapSquare);
            //直线宽度
            CGContextSetLineWidth(context, 1);
            //设置颜色
            CGContextSetRGBStrokeColor(context,  255, 255, 255,1.0);
            //开始绘制
            CGContextBeginPath(context);
            //画笔移动到点(31,170)
            CGContextMoveToPoint(context, -54-25+PaddingToChange_value(paddingM), 54+25-PaddingToChange_value(paddingM));
            //下一点
            CGContextAddLineToPoint(context, -56-26.5+PaddingToChange_value(paddingM), 56+26.5-PaddingToChange_value(paddingM));
            //下一点
            //绘制完成
            CGContextRotateCTM(context, M_PI/13.3333/4);
            CGContextStrokePath(context);
        }
      CGContextRestoreGState(context);
      
      
       // 实现颜色动态的渐变
      /*绘制一个圆弧*/
      UIBezierPath* path1 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                        radius:(111+57-paddingM)*scale
                                                                                    startAngle:degreesToRadians(135)
                                                                                      endAngle:degreesToRadians(150)
                                                                                     clockwise:YES];
      
      path1.lineWidth     = 12.f*scale;
      path1.lineCapStyle  = kCGLineCapRound;
      path1.lineJoinStyle = kCGLineCapRound;
      [[UIColor redColor] set];
      // 2
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:path1];
      UIBezierPath* path2 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                     radius:(111+57-paddingM)*scale
                                                                                 startAngle:degreesToRadians(150)
                                                                                   endAngle:degreesToRadians(180)                                                     clockwise:YES];
      
      path2.lineWidth     = 12.f*scale;
      path2.lineCapStyle  = kCGLineCapRound;
      path2.lineJoinStyle = kCGLineCapRound;
      [[UIColor blueColor] set];
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:path2];
      
      //3
      UIBezierPath* path3 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                     radius:(111+57-paddingM)*scale
                                                                                 startAngle:degreesToRadians(180)                                                      endAngle:degreesToRadians(225)
                                                                                  clockwise:YES];
      
      path3.lineWidth     = 12.f*scale;
      path3.lineCapStyle  = kCGLineCapRound;
      path3.lineJoinStyle = kCGLineCapRound;
      [[UIColor yellowColor] set];
      [self drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:path3];
      /*绘制一个圆弧*/
      [[UIColor yellowColor] set];
      UIBezierPath* path4 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                         radius:(111+57-paddingM)*scale
                                                                                     startAngle:degreesToRadians(315)
                                                                                       endAngle:degreesToRadians(45)
                                                                                      clockwise:YES];
      
       path4.lineWidth     = 12.f*scale;
       path4.lineCapStyle  = kCGLineCapRound;
       path4.lineJoinStyle = kCGLineCapRound;
       [path4 stroke];
      [self  drawArc:context Scale:scale CenterPoint:centerPoint ArcPath:path4];
      scaleImage= (111*scale)/(111+60-paddingM)*scale;
       // 添加分割线
      // 添加渐变色
          CGContextSaveGState(context);
          CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
          CGContextScaleCTM(context, scale, scale);
      for (int i=0; i<25; i++) {
            
            
            //指定直线样式
            CGContextSetLineCap(context, kCGLineCapSquare);
            //直线宽度
            CGContextSetLineWidth(context, 3);
            //设置颜色23/255.0 green: 116/255.0 blue: 143/255.0
            CGContextSetRGBStrokeColor(context,  23/255.0, 116/255.0, 143/255.0,1.0);
            //开始绘制
            CGContextBeginPath(context);
            //画笔移动到点(31,170)
            CGContextMoveToPoint(context, -76.5-38+PaddingToChange_value(paddingM), 76.5+38-PaddingToChange_value(paddingM));
            //下一点
            CGContextAddLineToPoint(context, -80-42.3+PaddingToChange_value(paddingM), 80+42.3-PaddingToChange_value(paddingM));
            //下一点
            //绘制完成
            CGContextRotateCTM(context, M_PI/13.3333/3.6);
            CGContextStrokePath(context);
        }
          CGContextRestoreGState(context);
      // 添加渐变色 右边
      CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
      for (int i=0; i<25; i++) {
            
            
            //指定直线样式
            CGContextSetLineCap(context, kCGLineCapSquare);
            //直线宽度
            CGContextSetLineWidth(context, 3);
            //设置颜色23/255.0 green: 116/255.0 blue: 143/255.0
            CGContextSetRGBStrokeColor(context,  23/255.0, 116/255.0, 143/255.0,1.0);
            //开始绘制
            CGContextBeginPath(context);
            //画笔移动到点(31,170)
            CGContextMoveToPoint(context, 76.5+38-PaddingToChange_value(paddingM), -76.5-38+PaddingToChange_value(paddingM));
            //下一点
            CGContextAddLineToPoint(context, 80+42.3-PaddingToChange_value(paddingM), -80-42.3+PaddingToChange_value(paddingM));
            //下一点
            //绘制完成
            CGContextRotateCTM(context, M_PI/13.3333/3.6);
            CGContextStrokePath(context);
        }
      CGContextRestoreGState(context);
        //中间指针的旋转  控制指针是否显示[_ispoint isEqualToString:@"true"]
  
  
      if (true) {

          if (reacpt==0) {
              [self imaageViewToTransform:context Scale:scale CenterPoint:centerPoint];
              reacpt++;
            }
          
        }
    [self valueRefesh];
    [self setNeedsDisplay];
}

//  设置图片的旋转
- (void)imaageViewToTransform :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint {
      UIImageView  *imgage= [[UIImageView alloc] init];
      UIImage  *origImage= [UIImage imageNamed:@"pointer"];
      origImage=[self imageCompressWithSimple:origImage scale:scale];
      imgage.image= origImage;
      
      
      imgage.layer.bounds=CGRectMake(0, 0, origImage.size.width, origImage.size.height);
      
      imgage.layer.anchorPoint = CGPointMake(0.5*scale*scaleImage, 1.1*scale*scaleImage+(scaleImage!=1? 0.15:0));
      imgage.layer.position = CGPointMake(centerPoint.x, centerPoint.y);
      
      
      
      [self.layer addSublayer:imgage.layer];
      _image= imgage;
 
       _angle = DEGREES_TO_RADIANS(180+45); // 角度转弧度
        // 获取到蓝牙数据的值
      self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
  //[self startAnimation];
}

 // 将保存好的imageview  进行反复的操作
-(void )valueRefesh{
    if (self.image!=nil) {
      
     /*最大值和最小值的差  除以  270度 等于每个值占了多少度数 */
    CGFloat ge= (float)270/(maxValue-minValue);// 每个值间隔的度数
         NSLog(@"ge=jiange输出间隔%f",ge);
      //当前值减去最小值 算出一共有多少个间隔
   CGFloat  jiange=    centerValue-minValue;
     NSLog(@"jiange输出间隔%f",jiange);
    //  算出一共宽了多少度
    CGFloat total= ge* jiange;
    NSLog(@"输出间隔=======%f",total);
    _angle=DEGREES_TO_RADIANS( 225+total);
     self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
      }
    
}
- (void ) startAnimation{
  // 增加动画
  CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  pathAnimation.duration = 6;
  pathAnimation.repeatCount= HUGE_VALF;
  pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  pathAnimation.fromValue=[NSNumber numberWithFloat:-2.2f];
  pathAnimation.toValue=[NSNumber numberWithFloat:2.2f];
  pathAnimation.autoreverses=NO;
  
  [self.image.layer addAnimation:pathAnimation forKey:@"Animation"];
  
}
  // 触摸时结束动画

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//  [self endAnimation];
//}
- (void) endAnimation{
  // 结束动画
  [self.image.layer  removeAllAnimations];
  
}
- (void)timeChange {
      self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
       _angle += degreesToRadians(1); // 控制指针旋转的间隔
}

//  图片的等比例缩放
- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
      CGSize size = image.size;
      CGFloat width = size.width-PaddingToChange_value(paddingM);
      CGFloat height = size.height-PaddingToChange_value(paddingM);
      CGFloat  biLi= width/ size.width;
      scaleImage =biLi;
      NSLog(@"缩放的比例%f",biLi);
      CGFloat scaledWidth = (width * scale);
      CGFloat scaledHeight = (height * scale);
      UIGraphicsBeginImageContext(size); // this will crop
      [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
      UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      return newImage;
}
/**
  半径方向的渐变
  参数的说明   上下文对象
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

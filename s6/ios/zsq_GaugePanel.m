//
//  zsq_GaugePanel.m
//  GaugePanel
//
//  Created by 朱世琦 on 17/12/11.
//  Copyright © 2017年 zsq. All rights reserved.
//


#import "RCTConvert+TextDemo.h"
#import "zsq_GaugePanel.h"

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define PaddingToChange_value(x) (ceil(sqrt((pow(x, 2)/2))))  // 计算坐标点的公式
#define PADDING_2  (paddingM*2)  // padding  的双倍公式
#define degreesToRadians(x) (M_PI*(x)/180.0) //角度转换的宏
#define angleToFloat(x)   (180.0*(x)/M_PI)
#define sameWithValue angleToFloat(degreesToRadians(270)/100);
@interface zsq_GaugePanel ()
{
    float _scale; //设置拉伸的比例
    CGPoint _centerPoint; // 定义中心点的位置
    CGPoint _centerPointSmall; // 定义小的圆盘中心点的位置
    CGFloat  _angle;
    CGFloat  _angle1;
    
    // 改变中间的值
    //设置中间的单位
    NSString * unitCenterText;
    // 开始的角度
    CGFloat startAngle1;
    //结束的角度
    CGFloat endAngle;
    //间隔的角度
    CGFloat sweepAngle1;
    CGFloat sweepAngle2;
    CGFloat sweepAngle3;
    CGFloat paddingM; // 圆与四周的距离
    float  scaleImage; // 图片适应边距的变化;
     /*角度相关*/
    float _startAngule;//开始的角度
    float _sweepAngle; // 间隔的角度
    /*设置刻度的值相关的参数*/
    float  spaceValue;// 刻度的间隔
    NSInteger rotateCount; // 旋转的次数
    NSInteger  minValue; //最小值
    NSInteger maxValue; // 最大值
    NSInteger sectionNumber; //刻度分割数
    NSString * isFormat; // 格式化显示
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
  
  BOOL  change_Value;//是否可以触摸改动值
  BOOL   ispoint ; // 是否显示指针
  NSString  * isunitDirection; // 单位的位置(right,bottom)
  CGFloat isvalue; // 要显示的值
  CGFloat  ispadding;// 设置外边距
}
@property (nonatomic  ,strong) UIImageView * image; // 定义imageview
@property (nonatomic  ,strong) UIImageView * image1; // 定义imageview
@property (nonatomic ,weak)NSTimer * nstimer;//设置定时器
 // 让绘制指针的方法只调用一次
@end
@implementation zsq_GaugePanel
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher{
    if ((self = [super init])) {
        self.opaque=NO;
        self.backgroundColor=[UIColor clearColor];
      }
    
    return self;
}

// 在touchbegan 中进行重绘
//数性设置值
- (void)setChangeValue:(BOOL)changeValue{// 是否可以触摸改变值显示指针
    NSLog(@"xxx=%@",changeValue);
  change_Value= changeValue;
  
}
-  (void)setPoint:(BOOL)point{ // 是否显示指针
     point=true;
  if(point==nil){
    point=true;
  }
    ispoint= point;
  [self setNeedsDisplay];
}
-   (void)setUnitDirection:(NSString *)unitDirection{ // 单位显示的位置
      NSLog(@"xxx=%@",unitDirection);
  isunitDirection=unitDirection;
}

- (void)setValue:(float)value{//设置值的多少
      NSLog(@"xxx=%ld",(long)value);
       isvalue=value;
  [self valueRefesh];
  [self setNeedsDisplay];
}

-(void)setValueconfig:(valueconfig)region{
    CGFloat max=  region.maxValue; // 最大值
    CGFloat min=  region.minValue; // 最小值
  
  
   _startAngule=  region.startAngle;  // 开始的角度
   _sweepAngle= region.sweepAngle;// 绘制度数的角度
    NSString  * unit= region.unit;   // 单位
    NSString * format= region.format;  // 格式化值
    float  mSection= region.mSection;   // 刻度分割数
    float defaultValue= region.defaultValue;// 默认值
   
  // 设置默认的值
  if ( region.minValue==0) {
    maxValue= 0;
  }
  if (region.maxValue==0) {
    maxValue=800;
  }
  if (region.startAngle==0) {
   _startAngule=135;
  }
  if (region.sweepAngle==0) {
    _sweepAngle= 270;
  }
  if ([unit isEqualToString:@""]) {
    unit=@"";
  }
  if (region.mSection==0) {
    mSection=10;
    sectionNumber=10;
    
  }
  if ([region.format isEqualToString:@""]) {
    format= @"#";
  }
  if (region.defaultValue==0) {
    defaultValue=-1;
  }
     //  设置值 ;
     /*设置刻度值*/
     minValue= min;
     maxValue=max;
     sectionNumber= mSection;
     spaceValue= (maxValue-minValue)/mSection;
  
  NSLog(@"spaceValue间隔值%f",spaceValue);
     rotateCount= mSection+2;
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
     /*设置单位*/
    unitCenterText= unit;
     /* 格式化值  根据格式设置是显示小数 还是整数 */
     isFormat = region.format;
    if ([isFormat isEqualToString:@"0.0"]) { // 显示小数
    //_isvalue = [NSString  stringWithFormat:@"%f",_isvalue];
        
        CGFloat  text= 99;
        NSString *deom= [NSString stringWithFormat:@"%0.1f",text];
        NSLog(@"format值%@",deom);
    
      }
    else{ // 显示整数
          }
        /*设置起始的角度*/
          /*
             角度传值的构思
               知道开始绘制的角度 就会知道结束的角度
               明白三个刻度之间的关系
                 文字绘制的度数等于  总的刻度值除以 分割数
                 大刻度的分割数等于  总刻度除以分割数除以2
            */
  
  
  NSLog(@"结构体输出的值是xmin==%f", region.minValue);
    NSLog(@"结构体输出的值是xmax==%f", region.maxValue);
  
  
  
    NSLog(@"结构体输出的值是xstartAngle==%f",region.startAngle);
    NSLog(@"结构体输出的值是xsweepAngel==%f",region.sweepAngle);
    NSLog(@"结构体输出的值是xunit==%@",unit);
    NSLog(@"结构体输出的值是xformat==%@",format);
    NSLog(@"结构体输出的值是xmSection==%f",mSection);
    NSLog(@"结构体输出的值是xdefaultValue==%f",defaultValue);
   // 设置默认的值
  isunitDirection=@"bottom";
  ispoint=true;
    // 调用重绘的方法
   [self setNeedsDisplay];
    NSLog(@"setregin什么时候22211");
}
- (void)drawRect:(CGRect)rect {
     /* 初始化中心点的位置 */
    paddingM=55; // 初始化边距
    CGFloat  mainWeight=[UIScreen mainScreen ].bounds.size.width;
    _centerPoint= CGPointMake(rect.size.width/2, rect.size.height/2);
    //  根据外边距调整缩放的比例   加50 的外边距
      CGFloat scaleWeight=414;
       _scale=rect.size.width/scaleWeight; // 根据宽的比例进行缩放
    if (sectionNumber==5) {
        [self setUpangleSmall];
    
      }else{
      [self setUpangle];
                 }
    // 绘制圆盘
    [self drawElectricQuantity:_scale centerPoint:_centerPoint];
  ispoint=true;
}
//  大圆角度相关
- (void) setUpangle{
  
    // 大刻度盘间隔的度数
    CGFloat big= degreesToRadians(13.3333);
    sweepAngle1=big;
    
    // 小刻度盘间隔的度数
    CGFloat small= degreesToRadians(13.3333/4);
    sweepAngle2= small;
    //  旋转文字间隔的度数
    CGFloat textangle=degreesToRadians(27.7);
    sweepAngle3=textangle;
    
    
}
// 小圆角度相关
- (void) setUpangleSmall{
    /** 初始化开始的角度*/
  //  startAngle1= 180;
  //  endAngle= 315;
  //
    // 大刻度盘间隔的度数
    CGFloat big= degreesToRadians(13.3333);
    sweepAngle1=big;
    
    // 小刻度盘间隔的度数
    CGFloat small= degreesToRadians(13.3333/4);
    sweepAngle2= small;
    //  旋转文字间隔的度数
    CGFloat textangle=degreesToRadians(27.7);
    sweepAngle3=textangle;
    
    
}


/* 绘制小圆的大刻度 */

/* 绘制小圆的小刻度 */
- (void)drawCustomDialBigandSmall:(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
    // 画出刻度盘
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context,_scale, _scale);
    for (int i=0; i<11; i++) {
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 1.5);
        //设置颜色
        CGContextSetRGBStrokeColor(context,  255, 255, 255,1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
    // 根据角度算出坐标
    CGFloat jiao= degreesToRadians(_startAngule);
    
    CGFloat  centerPadding;
    if(_startAngule==180){
      centerPadding=116;
    }else{
      centerPadding=130;
    }

    CGFloat bainjing;
    if(_startAngule==180){
      bainjing= centerPadding+8;
      NSLog(@"中心点的值%f",centerPadding);
    }
    if(_startAngule==270){
      bainjing= centerPadding-1;
    }
    
    CGFloat Y = sin(jiao)*bainjing;
    CGFloat X= cos(jiao)*bainjing;
    NSLog(@"根据坐标算出来的值%fy",Y);
    NSLog(@"根据坐标算出来的值%fx",X);
    CGContextMoveToPoint(context, X, Y);
    //下一点
    if(_startAngule==180){
      
      CGContextAddLineToPoint(context,X+10,Y);
    }
    if( _startAngule==270){
      CGContextAddLineToPoint(context,X,Y+10);
    }
    
    
    //下一点
    //绘制完成
    CGContextRotateCTM(context, sweep);
    CGContextStrokePath(context);
  }
    CGContextRestoreGState(context);
}

//根据需求绘制小刻度
- (void)drawCustomDialSmallandSamall :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
    // 画出刻度盘精细的刻度
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context,_scale, _scale);
    for (int i=0; i<41; i++) {
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 1.3);
        //设置颜色
        CGContextSetRGBStrokeColor(context,  255, 255, 255,1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
    // 根据角度算出坐标
    CGFloat jiao= degreesToRadians(_startAngule);
    CGFloat  centerPadding;
    if(_startAngule==180){
      centerPadding=116;
    }else{
      centerPadding=130;
    }

    CGFloat bainjing;
    if(_startAngule==180){
      bainjing= centerPadding+13;
    }
    if(_startAngule==270){
      bainjing= centerPadding;
    }
    
    
    CGFloat Y = sin(jiao)*bainjing;
    CGFloat X= cos(jiao)*bainjing;
    NSLog(@"根据坐标算出来的值%fy",Y);
    NSLog(@"根据坐标算出来的值%fx",X);
    CGContextMoveToPoint(context, X, Y);
    //下一点
    if(_startAngule==180){
      CGContextAddLineToPoint(context,X+5,Y);
    }
    if(_startAngule==270){
      CGContextAddLineToPoint(context,X,Y+5);
    }
    
    //下一点
    //绘制完成
    CGContextRotateCTM(context, sweep);
    CGContextStrokePath(context);
      }
    CGContextRestoreGState(context);
    
    
}
// 支持 横屏的刻度值显示
- (void)drawCustomScaleValueAndSmallWithHeng :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
  
  if(_startAngule==270){
    
    CGContextSaveGState(context);
      CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
      CGContextScaleCTM(context, scale, scale);
        NSString* textContent =@"300";
    
      for (int i=0 ; i<=5; i++) {
      CGFloat  centerPadding=130;
      CGFloat bainjing= centerPadding+28;
      CGFloat jiao= degreesToRadians(270);
      CGFloat Y = sin(jiao)*bainjing;
      CGFloat X= cos(jiao)*bainjing;
      NSLog(@"根据坐标算出来的值%fy",Y);
      NSLog(@"根据坐标算出来的值%fx",X);
      
      
      CGRect text12Rect0 = CGRectMake(X-17, Y-10, 35, 25);
         // CGRect text12Rect0 = CGRectMake(-35.5, -165-6, 35, 25);
          {
              
              // 对传入数组的判断 显示的是大圆的值还是小圆的值
              switch (i) {
          case 0:
            
            textContent = @"0";
            break;
          case 1:
            //textContent =@"360";
            textContent =@"1";
            break;
          case 2:
            // textContent =@"420";
            textContent = @"2";
            break;
          case 3:
            // textContent =@"480";
            textContent =@"3";
            break;
          case 4:
            //textContent =@"540";
            textContent =@"4";
            break;
          case 5:
            //textContent =@"600";
            textContent = @"5";
            break;
                    default:
                      textContent =@"50";
                      break;
                }
              
              NSMutableParagraphStyle* text12Style0 = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
              text12Style0.alignment = NSTextAlignmentCenter;
              
              NSDictionary* text12FontAttributes0 = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:23], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12Style0};
              
              [textContent drawInRect: CGRectOffset(text12Rect0, 0, (CGRectGetHeight(text12Rect0) - [textContent boundingRectWithSize: text12Rect0.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes0 context: nil].size.height) / 2) withAttributes: text12FontAttributes0];
            }
          
          // 开始旋转
          CGContextRotateCTM(context,sweep);
        }
      
      CGContextRestoreGState(context);
    
    
  }
  
  
  
}

// 根据需求绘制刻度值
- (void)drawCustomScaleValueAndSmall :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
    // 画出刻度值
    /* 画出零*/
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
      NSString* textContent =@"300";
  
    for (int i=0 ; i<=12; i++) {
    
        CGRect text12Rect0 = CGRectMake(-35.5, -165-6, 35, 25);
        {
            
            // 对传入数组的判断 显示的是大圆的值还是小圆的值
            switch (i) {
                  case 0:
                    
                   // textContent = @"3";
                     textContent = [NSString stringWithFormat:@"%li",value4];
                    break;
                  case 1:
                   
                  //  textContent =@"4";
                     textContent = [NSString stringWithFormat:@"%li",value5];
                    break;
                  case 2:
                   
                  //  textContent = @"5";
                     textContent = [NSString stringWithFormat:@"%li",value6];
                    break;
                  case 3:
                   
                    textContent =@"";
                    break;
                  case 4:
                    textContent =@"";
                    break;
                  case 5:
                    
                    textContent = @"";
                    break;
                  case 6:
                    textContent =@"";
                    break;
                  case 7:
                    textContent =@"";
                    
                    break;
                  case 8:
                   
                    textContent =@"";
                    break;
                  case 9:
                    
                    textContent =@"";
                    break;
                  case 10:
                    
                   // textContent =@"0";
                    textContent = [NSString stringWithFormat:@"%li",value1];
                    break;
                  case 11:
                    //textContent =@"1";
                     textContent = [NSString stringWithFormat:@"%li",value2];
                    break;
                  case 12:
                    //textContent =@"2";
                     textContent = [NSString stringWithFormat:@"%li",value3];
                    break;
                    
                  default:
                    textContent =@"50";
                    break;
              }
            
            NSMutableParagraphStyle* text12Style0 = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            text12Style0.alignment = NSTextAlignmentCenter;
            
            NSDictionary* text12FontAttributes0 = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:23], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12Style0};
            
            [textContent drawInRect: CGRectOffset(text12Rect0, 0, (CGRectGetHeight(text12Rect0) - [textContent boundingRectWithSize: text12Rect0.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes0 context: nil].size.height) / 2) withAttributes: text12FontAttributes0];
          }
        
        // 开始旋转
        CGContextRotateCTM(context,sweep);
      }
    
    CGContextRestoreGState(context);
  
}
/*
  单位的显示    底部   右边*/
-(void)setupUnitTextBottom:(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text12RectBottom = CGRectMake(10, 25, 35, 30);
    
    
    {
        NSString* textContentBotton = unitCenterText;
        NSMutableParagraphStyle* text12StyleBotton = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12StyleBotton.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributesBottom = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:20], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12StyleBotton};
        
        [textContentBotton drawInRect: CGRectOffset(text12RectBottom, 0, (CGRectGetHeight(text12RectBottom) - [textContentBotton boundingRectWithSize: text12RectBottom.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributesBottom context: nil].size.height) / 2) withAttributes: text12FontAttributesBottom];
      }
    
    CGContextRestoreGState(context);
    
}
-(void)setupUnitTextRight:(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text12RectRight = CGRectMake(43, -8, 35, 30);
    
    
    {
        
        
        NSString* textContentRight = unitCenterText;
        NSMutableParagraphStyle* text12StyleRight = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12StyleRight.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributesRight = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:20], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12StyleRight};
        
        [textContentRight drawInRect: CGRectOffset(text12RectRight, 0, (CGRectGetHeight(text12RectRight) - [textContentRight boundingRectWithSize: text12RectRight.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributesRight context: nil].size.height) / 2) withAttributes: text12FontAttributesRight];
      }
    
    CGContextRestoreGState(context);
    
}


// 根据需求绘制圆弧 (白色的圆弧)
-(void)drawCustomArc :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint startAngle:(CGFloat) start endAngle:(CGFloat) end{
    // 画第三个圆弧
    CGContextSaveGState(context);
    [[UIColor whiteColor] set];
    CGFloat   beginValue;
    CGFloat  endvalue;
    if (sectionNumber==5) {
    beginValue= degreesToRadians(_startAngule);
        CGFloat spaceSmall= degreesToRadians(135); //一共旋转的度数
        endvalue= degreesToRadians(_startAngule)+spaceSmall;
    
       
      }else{
      
      beginValue= degreesToRadians(135);
          CGFloat space= degreesToRadians(270); //一共旋转的度数
         endvalue= degreesToRadians(135)+space;
                }
    
    
    
    UIBezierPath* arcpath3 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                        radius:(117)*scale
                                                                                    startAngle:beginValue
                                                                                    endAngle:endvalue
                                                                                     clockwise:YES];
    
    arcpath3.lineWidth     = 1.2f;
    arcpath3.lineCapStyle  = kCGLineCapRound;
    arcpath3.lineJoinStyle = kCGLineCapRound;
    
    [arcpath3 stroke];
    
    CGContextRestoreGState(context);
    
    
    
}
//根据需求绘制大刻度盘
- (void)drawCustomDialBig :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
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
    // 根据角度算出坐标
    CGFloat  centerPadding=130;
    CGFloat bainjing= centerPadding-4;
    CGFloat jiao= degreesToRadians(135);
    CGFloat Y = sin(jiao)*bainjing;
    CGFloat X= cos(jiao)*bainjing;
    NSLog(@"根据坐标算出来的值%fy",Y);
    NSLog(@"根据坐标算出来的值%fx",X);
    CGContextMoveToPoint(context, X, Y);
    //下一点
    CGContextAddLineToPoint(context,X+8,Y-8);
    //下一点
    //绘制完成
    CGContextRotateCTM(context, sweep);
    CGContextStrokePath(context);
    
      }
    CGContextRestoreGState(context);
}

//根据需求绘制小刻度
- (void)drawCustomDialSmall :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
    // 画出刻度盘精细的刻度
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context,_scale, _scale);
    for (int i=0; i<81; i++) {
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapSquare);
        //直线宽度
        CGContextSetLineWidth(context, 1.3);
        //设置颜色
        CGContextSetRGBStrokeColor(context,  255, 255, 255,1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点(31,170)
    NSLog(@"大圆的中心点%f",centerPoint.x);
    CGFloat  centerPadding=130;
    CGFloat bainjing= centerPadding-1;
    CGFloat jiao= degreesToRadians(135);
    CGFloat Y = sin(jiao)*bainjing;
    CGFloat X= cos(jiao)*bainjing;
    NSLog(@"根据坐标算出来的值%fy",Y);
    NSLog(@"根据坐标算出来的值%fx",X);
    CGContextMoveToPoint(context, X, Y);
    //下一点
    CGContextAddLineToPoint(context, X+5, Y-5);
    //下一点
    //绘制完成
    CGContextRotateCTM(context, sweep);
    CGContextStrokePath(context);
      }
    CGContextRestoreGState(context);
    
    
}

// 根据需求绘制刻度值
- (void)drawCustomScaleValue :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint sweepAngle:(CGFloat) sweep{
    // 画出刻度值
    /* 画出零*/
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    for (int i=0 ; i<=12; i++) {
        
        NSString* textContent =@"300";
        CGRect text12Rect0 = CGRectMake(-17.5, -165-6, 35, 25);
        {
            
            // 对传入数组的判断 显示的是大圆的值还是小圆的值
            switch (i) {
                  case 0:
                    // textContent =@"300";
                    textContent = [NSString stringWithFormat:@"%li",value6];
                    break;
                  case 1:
                    //textContent =@"360";
                    textContent = [NSString stringWithFormat:@"%li",value7];
                    break;
                  case 2:
                    // textContent =@"420";
                   textContent = [NSString stringWithFormat:@"%li",value8];
                    break;
                  case 3:
                    // textContent =@"480";
                    textContent = [NSString stringWithFormat:@"%li",value9];
                    break;
                  case 4:
                    //textContent =@"540";
                    textContent = [NSString stringWithFormat:@"%li",value10];
                    break;
                  case 5:
                    //textContent =@"600";
                    textContent = [NSString stringWithFormat:@"%li",value11];
                    break;
                  case 6:
                    textContent =@"";
                    break;
                  case 7:
                    textContent =@"";
                    
                    break;
                  case 8:
                    //textContent =@"0";
                    textContent = [NSString stringWithFormat:@"%li",value1];
                    break;
                  case 9:
                    //textContent =@"60";
                  textContent = [NSString stringWithFormat:@"%li",value2];
                    break;
                  case 10:
                    //textContent =@"120";
                   textContent = [NSString stringWithFormat:@"%li",value3];
                    break;
                  case 11:
                    // textContent =@"180";
                    textContent = [NSString stringWithFormat:@"%li",value4];
                  break;
                  case 12:
                    //textContent =@"240";
                     textContent = [NSString stringWithFormat:@"%li",value5];
                    break;
                  default:
                    textContent =@"50";
                    break;
              }
            
            NSMutableParagraphStyle* text12Style0 = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            text12Style0.alignment = NSTextAlignmentCenter;
            
            NSDictionary* text12FontAttributes0 = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:18], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12Style0};
            
            [textContent drawInRect: CGRectOffset(text12Rect0, 0, (CGRectGetHeight(text12Rect0) - [textContent boundingRectWithSize: text12Rect0.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes0 context: nil].size.height) / 2) withAttributes: text12FontAttributes0];
          }
        
        // 开始旋转
        CGContextRotateCTM(context,sweep);
      }
    
    CGContextRestoreGState(context);
}

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
    // CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    
    UIBezierPath *arcpath= path;
    [arcpath stroke];
    
    CGContextRestoreGState(context);
    
}

//绘制的主要方法
- (void)drawElectricQuantity: (CGFloat)scale centerPoint:(CGPoint)centerPoint{
    /* 一共需要画8个圆*/
    CGContextRef context= UIGraphicsGetCurrentContext();  // 获取上下文对象
  // 画一个黑色的圆
     CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
  UIBezierPath* blcak = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-125-20-paddingM, -125-20-paddingM, 250+PADDING_2+20*2, 250+PADDING_2+20*2)];
  
  [[UIColor colorWithRed:  0/255.0 green: 0/255.0 blue:0/255.0 alpha: 1] setFill];
  //设置线宽
  blcak.lineWidth = 15;
  [blcak fill];
  CGContextRestoreGState(context);
    //第一个圆
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
  UIBezierPath* rimPath1 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-125-20-paddingM, -125-20-paddingM, 250+PADDING_2+20*2, 250+PADDING_2+20*2)];
  
  [[UIColor colorWithRed:  153/255.0 green: 172/255.0 blue: 178/255.0 alpha: 1] setStroke];
  //设置线宽
  rimPath1.lineWidth = 15;
  [rimPath1 stroke];
  CGContextRestoreGState(context);
  //// 画出边框第2个
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
  UIBezierPath* rimPath2 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-120-13-paddingM, -120-13-paddingM, 240+PADDING_2+13*2, 240+PADDING_2+13*2)];
  
  [[UIColor colorWithRed:  23/255.0 green: 116/255.0 blue: 143/255.0 alpha: 1] setStroke];
  //设置线宽
  rimPath2.lineWidth = 5;
  [rimPath2 stroke];
  CGContextRestoreGState(context);
  
  
  // 第三个圆
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
  UIBezierPath* rimPath3 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-115-12-(paddingM), -115-12-paddingM, 230+PADDING_2+12*2, 230+PADDING_2+12*2)];
  
  [[UIColor colorWithRed:  17/255.0 green: 82/255.0 blue: 92/255.0 alpha: 1] setStroke];
  //设置线宽
  rimPath3.lineWidth = 3;
  [rimPath3 stroke];
  CGContextRestoreGState(context);
  
  
  //// 画出边框第4个
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
  CGContextScaleCTM(context, scale, scale);
  
  UIBezierPath* rimPath4 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-102-5-(paddingM), -102-5-(paddingM), 204+(PADDING_2)+5*2, 204+(PADDING_2)+5*2)];
  
  [[UIColor colorWithRed:  17/255.0 green: 82/255.0 blue: 92/255.0 alpha: 1] setStroke];
  //设置线宽
  rimPath4.lineWidth = 14;
  [rimPath4 stroke];
  CGContextRestoreGState(context);
  
    
    // 化第一个圆弧个圆弧
    CGContextSaveGState(context);
    // CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    // CGContextScaleCTM(context, scale, scale);
    
    
    [[UIColor colorWithRed:  32/255.0 green: 126/255.0 blue: 140/255.0 alpha: 1] set];
    
    UIBezierPath* arcpath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                      radius:(85+paddingM)*scale
                                                                                  startAngle:3.1415926 * 3/ 4
                                                                                    endAngle:3.1415926  /4
                                                                                   clockwise:YES];
    
    arcpath.lineWidth     = 1.2f;
    arcpath.lineCapStyle  = kCGLineCapRound;
    arcpath.lineJoinStyle = kCGLineCapRound;
    
    [arcpath stroke];
    
    CGContextRestoreGState(context);
    // 画第二个圆弧
    CGContextSaveGState(context);
    // CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    //CGContextScaleCTM(context, scale, scale);
    
    
    [[UIColor colorWithRed:  38/255.0 green: 216/255.0 blue: 245/255.0 alpha: 1] set];
    
    
    UIBezierPath* arcpath2 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                        radius:(80+paddingM)*scale
                                                                                    startAngle:3.1415926 * 2/ 3
                                                                                      endAngle:3.1415926  /3
                                                                                     clockwise:YES];
    
    arcpath2.lineWidth     = 2.0f;
    arcpath2.lineCapStyle  = kCGLineCapRound;
    arcpath2.lineJoinStyle = kCGLineCapRound;
    
    [arcpath2 stroke];
    
    CGContextRestoreGState(context);
    /*白色的圆弧*/
    [self drawCustomArc:context Scale:scale CenterPoint:centerPoint startAngle:startAngle1 endAngle:endAngle];
    //  加一个圆弧
    CGContextSaveGState(context);
    // CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    //CGContextScaleCTM(context, scale, scale);
    
    [[UIColor colorWithRed:  17/255.0 green: 82/255.0 blue: 92/255.0 alpha: 1] set];
    
    UIBezierPath* arcpath4 = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                                                        radius:(80+paddingM)*scale
                                                                                    startAngle:3.1415926 / 3
                                                                                      endAngle:3.1415926 * 2 /3
                                                                                     clockwise:YES];
    
    arcpath4.lineWidth     = 2.0f;
    arcpath4.lineCapStyle  = kCGLineCapRound;
    arcpath4.lineJoinStyle = kCGLineCapRound;
    
    [arcpath4 stroke];
    
    CGContextRestoreGState(context);
    
    
    //  画出中心的渐变的圆
    // 绘制颜色渐变的一个圆 由中心想四周进行渐变
    //// 画出边框第9个
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    //10
    UIBezierPath* rimPath9 = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-115, -115, 115*2, 115*2)];
    
    
    UIColor  *startColor =[UIColor colorWithRed:  47/255.0 green: 88/255.0 blue: 94/255.0 alpha: 1];
    UIColor *endColor=[UIColor colorWithRed:  0/255.0 green: 0/255.0 blue: 0/255.0 alpha: 1];
    // 调用方法 画渐变的方法
    [self  drawRadialGradient:context path:rimPath9.CGPath startColor:startColor.CGColor endColor:endColor.CGColor];
    CGContextRestoreGState(context);
    
    //    // 绘制中心的文字
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    CGContextScaleCTM(context, scale, scale);
    
    CGRect text12Rect = CGRectMake(-50, -50, 100, 100);
  
    {
    NSString* textContent ; //对值进行强转
    if ([isFormat isEqualToString:@"0.0"]) {
      textContent=[NSString stringWithFormat:@"%0.1f",isvalue];
    }else{
      textContent = [NSString stringWithFormat:@"%0.0f",isvalue];
    }
        
        NSMutableParagraphStyle* text12Style = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        text12Style.alignment = NSTextAlignmentCenter;
        
        NSDictionary* text12FontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size:48], NSForegroundColorAttributeName: [UIColor colorWithRed:  255/255.0 green: 255/255.0 blue: 255/255.0 alpha: 1], NSParagraphStyleAttributeName: text12Style};
        
        [textContent drawInRect: CGRectOffset(text12Rect, 0, (CGRectGetHeight(text12Rect) - [textContent boundingRectWithSize: text12Rect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: text12FontAttributes context: nil].size.height) / 2) withAttributes: text12FontAttributes];
      }
    
    CGContextRestoreGState(context);
    // 绘制温度的单位 下面的
    
    // 绘制右边的单位
    if ([isunitDirection isEqualToString:@"bottom"]) {
        [self setupUnitTextBottom:context Scale:scale CenterPoint:centerPoint];
      }
  
    if ([isunitDirection isEqualToString:@"right"]) {
        [self  setupUnitTextRight:context Scale:scale CenterPoint:centerPoint];
        
      }
   
    if (sectionNumber==5) {
        // 画出小刻度盘
        [self drawCustomDialBigandSmall:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle1];
        // 画出小的刻度盘
        [self  drawCustomDialSmallandSamall:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle2];
       
    if (_startAngule==270) {
      [self drawCustomScaleValueAndSmallWithHeng:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle3];
    }else{
      
      // 画出刻度值
          [self drawCustomScaleValueAndSmall:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle3];
      
    }
      }else{
      
      //画出大的刻度盘
          [self  drawCustomDialBig:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle1];
          //画出小的刻度盘
          [self drawCustomDialSmall:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle2];
          // 画出刻度的值
          [self drawCustomScaleValue:context Scale:scale CenterPoint:centerPoint sweepAngle:sweepAngle3] ;
    }
  
   repect3=0;
   repect2=0;
   repect1=0;
    repect=0;    // 是否显示中间旋转的图片
    if (_startAngule==135) {
        if (repect==0) {
            // 添加旋转的图片
            [self setupPointer:context Scale:scale CenterPoint:centerPoint];
            repect++;
          }
      }
  

  //只被调用一次
  repect3=sectionNumber;
  if(_startAngule==180){
    if (repect1==0) {
            // 添加旋转的图片
            [self setupPointer:context Scale:scale CenterPoint:centerPoint];
            repect1++;
          }
  }

    
    if(_startAngule==270){
      
      if (repect2==0) {
        [self setupPointer:context Scale:scale CenterPoint:centerPoint];
        repect2++;
      }
    
  }
  
  
  
  
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  [self setNeedsDisplay];
  NSLog(@"调用了重汇的方法");
  
}
int repect3=0;
int repect2=0;
int repect1=0;
int repect=0;
//让绘制图片的方法只调用一次设置中间显示
-(void) setupPointer :(CGContextRef )context  Scale : (CGFloat)scale CenterPoint:(CGPoint) centerPoint {
    UIImageView  *imgage= [[UIImageView alloc] init];
    UIImage  *origImage= [UIImage imageNamed:@"pointer"];
    CGFloat orWeigth= origImage.size.width;
    CGFloat orHeight= origImage.size.height;
    origImage=[self imageCompressWithSimple:origImage scale:scale];
    imgage.image= origImage;
    
    
    imgage.layer.bounds=CGRectMake(0, 0, orWeigth, orHeight);
    
    imgage.layer.anchorPoint = CGPointMake(0.5*scale, 1.1*scale);
    //imgage.layer.anchorPoint = CGPointMake(0.5*scale*scaleImage, 1.05*scale*scaleImage+(scaleImage!=1? 0.15:0));
    imgage.layer.position = CGPointMake(centerPoint.x, centerPoint.y);
  if(self.layer.sublayers.count>0)
    self.layer.sublayers[0].removeFromSuperlayer;
  NSLog(@"xxxxxlll=%d",self.layer.sublayers.count);
    [self.layer addSublayer:imgage.layer];
    _image= imgage;
  if(sectionNumber==5){
    _angle = DEGREES_TO_RADIANS(180+90); // 角度转弧度
    // 获取到蓝牙数据的值
        self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
    
    if(_startAngule==270){
      _angle = DEGREES_TO_RADIANS(180+90+90); // 角度转弧度
      // 获取到蓝牙数据的值
          self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
    }
  }else{
    
    _angle = DEGREES_TO_RADIANS(180+45); // 角度转弧度
    // 获取到蓝牙数据的值
        self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
  }
    if(sectionNumber==5){
     [self valueRefesh];
  }else{
     [self valueRefesh];
    
    
  }
    
   }

 // 将保存好的imageview  进行反复的操作(_startAngule+90)
-(void )valueRefesh{
    if (self.image!=nil) {
      
    /*最大值和最小值的差  除以  270度 等于每个值占了多少度数 */
    CGFloat ge= (float)_sweepAngle/(maxValue-minValue);// 每个值间隔的度数
  
    NSLog(@"ge=jiange输出间隔%f",_sweepAngle);
    //当前值减去最小值 算出一共有多少个间隔
    CGFloat  jiange=    isvalue-minValue;
    NSLog(@"jiange输出间隔%f",jiange);
    //  算出一共宽了多少度
    CGFloat total= ge* jiange;
    NSLog(@"输出间隔=======%f",total);
    _angle=DEGREES_TO_RADIANS((_startAngule+90)+total);
    self.image.layer.transform= CATransform3DMakeRotation(_angle, 0, 0, 1);
      }
    
}
//  图片的等比例缩放

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
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

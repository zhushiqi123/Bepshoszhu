//
//  CurveChartBGXIBView.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/21.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveChartBGXIBView : UIView
{
@private
    int box_Side_width;
    int box_Side_height;
    
    int Drawing_arry_type;
    
    float PowerView_X;
    float PowerView_Y;
    float PowerView_Width;
    float PowerView_Height;
    
    float Drawing_Width;
    float Drawing_Height;
    
    BOOL start_touch_Bool;
}

@property (nonatomic, assign)CGPoint point_start;
@property (nonatomic, assign)CGPoint point_end;
//回调数据
typedef void (^CCTCurveDataBack)(int CCT_x,int CCT_y);
@property(nonatomic,copy) CCTCurveDataBack CCTCurveData;

//数据坐标数组
@property(nonatomic,retain) NSMutableArray *array_CCT;

//初始化设置
- (id)initWithFrame:(CGRect)frame :(int)box_width :(int)box_height :(int)arry_type :(NSMutableArray *)setArrys;

//刷新界面
-(void)refreshUI:(int)arry_type :(NSMutableArray *)setArrys;

//获取曲线数据
-(NSMutableArray *)getCCTData;

@end

//
//  TempCurveViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@class SaveTabBarView;
@class TempCurveTitleView;
@class CurveChartBGXIBView;

@interface TempCurveViewController : DelegateViewController

@property(nonatomic,retain) TempCurveTitleView *tempCurveTitleView;
@property(nonatomic,retain) CurveChartBGXIBView *curveChartBGView;
@end

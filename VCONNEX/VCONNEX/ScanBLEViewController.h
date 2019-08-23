//
//  ScanBLEViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXRadarView;
@class YXRadarIndictorView;

@interface ScanBLEViewController : UIViewController

@property (nonatomic, weak) YXRadarView *radarView;
@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,retain)UIButton *btn_button_retry;
@property (nonatomic,retain)UIButton *btn_button_Cancle;

@end

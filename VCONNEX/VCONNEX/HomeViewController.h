//
//  HomeViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@class PowerVolumeBar;
@class TempVolumeBar;
@class ModeChooseXibView;
@class TempTypeChooseXibView;
@class TCRChooseXibView;
@class UIWeiget;

@interface HomeViewController : DelegateViewController

//上方两个切换按钮
@property (nonatomic,retain)ModeChooseXibView *ModeView;

//主视图背景视图
@property (nonatomic,retain) TempVolumeBar *Bar_uiViewTemp;
@property (nonatomic,retain) PowerVolumeBar *Bar_uiViewPower;

//温度切换视图
@property (nonatomic,retain)TempTypeChooseXibView *TempTypeChooseView;

//下方三个视图
@property (nonatomic,retain)UIWeiget *UIWeiget01;
@property (nonatomic,retain)UIWeiget *UIWeiget02;
@property (nonatomic,retain)UIWeiget *UIWeiget03;

//底部两个按钮
@property (nonatomic,retain)TCRChooseXibView *TCRChooseView;

@end

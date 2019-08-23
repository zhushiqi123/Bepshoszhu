//
//  TCRSettingViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@class TCRTitleView;
@class TCRDataView;
@class SaveTabBarView;

@interface TCRSettingViewController : DelegateViewController

@property (nonatomic,retain) TCRDataView *tcrDataViewCell01;
@property (nonatomic,retain) TCRDataView *tcrDataViewCell02;
@property (nonatomic,retain) TCRDataView *tcrDataViewCell03;
@property (nonatomic,retain) TCRDataView *tcrDataViewCell04;

@end

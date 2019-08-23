//
//  AppDelegateViewController.h
//  Vapesoul
//
//  Created by tyz on 17/7/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegateViewController : UIViewController

@property (nonatomic,retain) UIView *headview;
@property (nonatomic,retain) UILabel *headLableView;
@property (nonatomic,retain) UIImageView *rebackImageView;

-(void)setRebackImageViewHiden: (Boolean)hiden;

@end

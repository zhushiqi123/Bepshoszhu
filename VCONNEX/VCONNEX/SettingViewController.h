//
//  SettingViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/13.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@interface SettingViewController : DelegateViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *tableview;

@end

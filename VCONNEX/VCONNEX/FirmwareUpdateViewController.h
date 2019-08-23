//
//  FirmwareUpdateViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"

@interface FirmwareUpdateViewController : DelegateViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) UITableView *tableview;

@property (nonatomic,retain) UILabel *errorLableView;

@property (nonatomic,assign) int deviceVersion;

@end

//
//  BindingViewController.h
//  Vapesoul
//
//  Created by tyz on 17/7/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegateViewController.h"

@interface BindingViewController : AppDelegateViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *tableview;

@end

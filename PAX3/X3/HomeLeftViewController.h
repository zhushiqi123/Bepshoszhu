//
//  HomeLeftViewController.h
//  PAX3
//
//  Created by tyz on 17/5/3.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeLeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *temp_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

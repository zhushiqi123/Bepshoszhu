//
//  ViewController.h
//  PAX3
//
//  Created by tyz on 17/5/2.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *endView;

//返回按钮
@property (weak, nonatomic) IBOutlet UIButton *back_btn;


@end


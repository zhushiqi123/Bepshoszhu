//
//  APViewController.h
//  aspire商城
//
//  Created by tyz on 16/1/8.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btn_Alipay;
@end
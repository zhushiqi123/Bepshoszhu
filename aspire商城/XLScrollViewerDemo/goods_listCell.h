//
//  goods_listCell.h
//  aspire商城
//
//  Created by tyz on 15/12/24.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goods_listCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

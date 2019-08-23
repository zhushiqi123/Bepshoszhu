//
//  OrderCell.h
//  aspire商城
//
//  Created by tyz on 15/12/21.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_id;
@property (weak, nonatomic) IBOutlet UILabel *order_name;
@property (weak, nonatomic) IBOutlet UILabel *order_price;
@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *order_time;
@property (weak, nonatomic) IBOutlet UILabel *order_state;

@end

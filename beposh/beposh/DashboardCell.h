//
//  DashboardCell.h
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *title_lable;

@property (weak, nonatomic) IBOutlet UIButton *switch_cell;


@property (weak, nonatomic) IBOutlet UILabel *lable_big;
@property (weak, nonatomic) IBOutlet UILabel *lable_small;
@property (weak, nonatomic) IBOutlet UIButton *btn_onclick;

@end

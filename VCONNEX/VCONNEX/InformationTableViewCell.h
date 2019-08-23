//
//  InformationTableViewCell.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/14.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_time;
@property (weak, nonatomic) IBOutlet UIImageView *news_images;
@property (weak, nonatomic) IBOutlet UILabel *lable_name;
@property (weak, nonatomic) IBOutlet UILabel *lable_more;
@property (weak, nonatomic) IBOutlet UIView *cellBackground;

@end

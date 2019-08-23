//
//  HomeACell.h
//  aspire商城
//
//  Created by tyz on 15/12/7.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeACell : UITableViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_HomeA;
@property (weak, nonatomic) IBOutlet UILabel *lable_HomeA;
@property (weak, nonatomic) IBOutlet UIPageControl *page_HomeA;
@property (nonatomic,strong) NSTimer *timer;

-(void)removeTimer;

@end

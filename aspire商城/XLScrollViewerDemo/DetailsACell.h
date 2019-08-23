//
//  DetailsACell.h
//  aspire商城
//
//  Created by tyz on 15/12/26.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsACell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *detailsPage;
@property (weak, nonatomic) IBOutlet UIPageControl *detailsNum;

@end

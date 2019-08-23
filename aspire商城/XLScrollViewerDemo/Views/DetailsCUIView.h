//
//  DetailsCUIView.h
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsCUIView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) UITableView * tableView;

@end

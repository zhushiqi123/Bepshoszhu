//
//  DetailsACellTableC.h
//  aspire商城
//
//  Created by tyz on 16/1/6.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsACellTableC : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

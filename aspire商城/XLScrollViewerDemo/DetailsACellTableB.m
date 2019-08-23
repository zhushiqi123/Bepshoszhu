//
//  DetailsACellTableB.m
//  aspire商城
//
//  Created by tyz on 16/1/6.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import "DetailsACellTableB.h"
#import "DetailsACellF.h"
#import "Session.h"
@interface DetailsACellTableB()
{
    int box;
}
@end
@implementation DetailsACellTableB

- (void)awakeFromNib
{
    // Initialization code
    box = 0;
    [Session sharedInstance].details_typeListB_num = box;
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.rowHeight = 25;
    _tableview.separatorStyle = NO;
    self.tableview.scrollEnabled =NO; //设置tableview 不能滚动
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [Session sharedInstance].details_typeListB.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"DetailsACellF";
    DetailsACellF *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type.text = [Session sharedInstance].details_typeListB[indexPath.row];
    //默认先给第一行加上选定
    if (indexPath.row == box) {
        [cell.checkBx setBackgroundImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
    }
    return cell;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"被点击了%d",indexPath.row);
    box = indexPath.row;
    [Session sharedInstance].details_typeListB_num = box;
//    NSLog(@"页面刷新。。。。");
    [self.tableview reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

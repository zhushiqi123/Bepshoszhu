//
//  goods_listCell.m
//  aspire商城
//
//  Created by tyz on 15/12/24.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "goods_listCell.h"
#import "shopCartLableCell.h"
#import "Session.h"
@implementation goods_listCell

- (void)awakeFromNib
{
    // Initialization code
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = NO;
    self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    return  [Session sharedInstance].shopCarss.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加可重标示符
    static NSString *ID = @"shopCartLableCell";
    shopCartLableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    //取消cell选中状态颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"*****%@",[Session sharedInstance].shopCarss[indexPath.section]);
    
    NSDictionary *shopDatas = [Session sharedInstance].shopCarss[indexPath.row];
    //dataDetails objectForKey:@"goods_sn"]
    cell.goodsName.text = [shopDatas objectForKey:@"goods_name"];
    cell.goodsprice.text  = [shopDatas objectForKey:@"price"];
    cell.goodsNum.text  = [NSString stringWithFormat:@"%@",[shopDatas objectForKey:@"num"]];
    cell.goodsPrices.text  = [shopDatas objectForKey:@"allPrices"];
    //
    //    // 实例化TableViewCell时，使用initWithStyle方法来进行实例化
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    //    //设置字体颜色
    //
    //    cell.textLabel.text = @"2222";
    //    // 明细信息
    //    cell.detailTextLabel.text = @"1111";
    
    
    //    shopCartLableCell *shopLableCell = self.
    // 实例化TableViewCell时，使用initWithStyle方法来进行实例化
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    //    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


@end

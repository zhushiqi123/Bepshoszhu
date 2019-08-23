//
//  DetailsAUIView.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsAUIView.h"
#import "DetailsACell.h"
#import "DetailsACellB.h"
#import "DetailsACellC.h"
#import "DetailsACellD.h"
#import "DetailsACellTableA.h"
#import "DetailsACellTableB.h"
#import "DetailsACellTableC.h"
#import "DetailsACellTableD.h"
#import "Session.h"
@interface DetailsAUIView()
@property(strong,nonatomic) UITableView * tableView;
@end

@implementation DetailsAUIView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (_tableView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        //在view里面区新建一个tableview最好取得手机屏幕的宽高 [UIScreen mainScreen ].bounds  initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, [UIScreen mainScreen ].bounds.size.height - 108 -25) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    if (indexPath.section == 0)
    {
        return 200;
    }
    else if (indexPath.section == 1)
    {
        return 44;
    }
    else  if (indexPath.section == 2 || indexPath.section == 3)
    {
        return 30;
    }
    else if (indexPath.section == 4)
    {
        return [Session sharedInstance].details_typeListA.count * 25;
    }
    else if (indexPath.section == 5)
    {
        return [Session sharedInstance].details_typeListB.count * 25;
    }
    else if (indexPath.section == 6)
    {
        return [Session sharedInstance].details_typeListC.count * 25;
    }
    else
    {
        return [Session sharedInstance].details_typeListD.count * 25;
    }
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *ID = @"DetailsACell";
        DetailsACell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;

    }//DetailsACellC
    else if(indexPath.section == 1)
    {
        static NSString *ID = @"DetailsACellB";
        DetailsACellB *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 2)
    {
        static NSString *ID = @"DetailsACellC";
        DetailsACellC *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *ID = @"DetailsACellD";
        DetailsACellD *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 4)
    {
        static NSString *ID = @"DetailsACellTableA";
        DetailsACellTableA *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 5)
    {
        static NSString *ID = @"DetailsACellTableB";
        DetailsACellTableB *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else if(indexPath.section == 6)
    {
        static NSString *ID = @"DetailsACellTableC";
        DetailsACellTableC *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        static NSString *ID = @"DetailsACellTableD";
        DetailsACellTableD *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

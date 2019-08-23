//
//  View1.m
//  XLScrollViewerDemo
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
//

#import "Home.h"
#import "ViewController.h"
#import "HomeACell.h"
#import "HomeBCell.h"
#import "HomeCCell.h"
#import "Session.h"
#import "UIImageView+WebCache.h"

//屏幕适配
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface Home()

@property(strong,nonatomic) UITableView * tableView;
@end

@implementation Home

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
//    if (self)
//    {
////        self.backgroundColor =[UIColor whiteColor];
//    }
//    return self;
    if (_tableView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        //在view里面区新建一个tableview最好取得手机屏幕的宽高 [UIScreen mainScreen ].bounds  initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen ].bounds.size.width, [UIScreen mainScreen ].bounds.size.height - 76) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.rowHeight = 200;
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
    return 7;
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


//行高
- (CGFloat)tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath
{
    if (indexPath.section == 0)
    {
        return 180;
    }
    else
    {
        return 200;
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
        static NSString *ID = @"HomeACell";
        HomeACell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;

    }
    
    if (indexPath.section == 1)
    {
        static NSString *ID = @"HomeBCell";
        HomeBCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
        static NSString *ID = @"HomeCCell";
        HomeCCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([Session sharedInstance].homeCCell_name.count > 0)
            {
                int sections = indexPath.section - 2;
                cell.lableC_text2.text = [NSString stringWithFormat:@"￥%@",[Session sharedInstance].homeCCell_price[sections*2]];
                cell.lableC_text3.text = [NSString stringWithFormat:@"￥%@",[Session sharedInstance].homeCCell_price[sections*2+1]];
                
                cell.lableC_text1.text = [Session sharedInstance].homeCCell_name[sections*2];
                cell.lableC_text4.text = [Session sharedInstance].homeCCell_name[sections*2+1];;
                
                NSString *imageList1 = [Session sharedInstance].homeCCell_image[sections*2];
                NSString *imageList2 = [Session sharedInstance].homeCCell_image[sections*2+1];

                NSURL *url1 = [NSURL URLWithString:imageList1];
                NSURL *url2 = [NSURL URLWithString:imageList2];
                
                [cell.imageC_logo1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
                [cell.imageC_logo2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
            }
        }
        return cell;

    }
}
@end


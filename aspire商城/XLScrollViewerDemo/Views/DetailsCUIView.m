//
//  DetailsCUIView.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsCUIView.h"
#import "CommentsCell.h"
#import "Session.h"
#import "Goods.h"
#import "ProgressHUD.h"
@interface DetailsCUIView()
{
    NSMutableArray *add_timeList;
    NSMutableArray *contentList;
    NSMutableArray *comment_rankList;
}
@end
@implementation DetailsCUIView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (_tableView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        [self findComments];
        //在view里面区新建一个tableview最好取得手机屏幕的宽高
    //initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)  [ UIScreen mainScreen ].bounds
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+44+20)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = NO;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - 数据源方法
// 如果没有实现，默认是1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(contentList.count == 0)
    {
        return 1;
    }
    else
    {
        return contentList.count;
    }
}

// 每个分组中的数据总数
// sction：分组的编号
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (contentList.count > 0) {
        // 可重用标示符
        static NSString *ID = @"CommentsCell";
        // 让表格缓冲区查找可重用cell
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
            //设置字体内容
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.comments_A.text = contentList[indexPath.section];
            
            int ranks = [comment_rankList[indexPath.section] intValue];
            switch (ranks)
            {
                case 1:
                    cell.comments_B.text = @"★";
                    break;
                case 2:
                    cell.comments_B.text = @"★★";
                    break;
                case 3:
                    cell.comments_B.text = @"★★★";
                    break;
                case 4:
                    cell.comments_B.text = @"★★★★";
                    break;
                case 5:
                    cell.comments_B.text = @"★★★★★";
                    break;
                    
                default:
                    cell.comments_B.text = @"";
                    break;
            }

            //时间转换器
            int time = [add_timeList[indexPath.section] intValue];
            
            NSDate *timers = [NSDate dateWithTimeIntervalSince1970:time];
            
             NSDateFormatter* formatter1 = [[NSDateFormatter alloc]init];
            [formatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            
            NSString *times = [formatter1 stringFromDate:timers];
            cell.comments_time.text = times;
        }
        return cell;
    }
    else
    {
        // 可重用标示符
        static NSString *ID = @"Cell";
        // 让表格缓冲区查找可重用cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 如果没有找到可重用cell
        if (cell == nil)
        {
            // 实例化cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.textLabel.text = @"暂无评论数据，来抢沙发吧!";
        
        //取消cell选中状态颜色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        return cell;
    }
}

-(void)findComments
{
    if ([Session sharedInstance].details.goods_id > 0) {
        [Goods product_reviews:[Session sharedInstance].details.goods_id success:^(id data)
         {
             NSLog(@"--------->评论数据返回1%@",data);
         }
         failure:^(NSString *message)
         {
             add_timeList = [NSMutableArray array];
             contentList = [NSMutableArray array];
             comment_rankList = [NSMutableArray array];
             
             NSLog(@"--------->评论数据返回2%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             //         NSLog(@"data------>%@",data);
             NSDictionary *datas = [data objectForKey:@"data"];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 //                NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:findData];
                 NSLog(@"datas------>%@",list);
                 
                 for (int i = 0; i<[list count]; i++)
                 {
                     //按数组中的索引取出对应的字典
                     NSDictionary *listdic = [list objectAtIndex:i];
                     //通过字典中的key取出对应value，并且强制转化为NSString类型
                     NSString *add_time = (NSString *)[listdic objectForKey:@"add_time"];
                     NSString *content = (NSString *)[listdic objectForKey:@"content"];
                     NSString *comment_rank = [listdic objectForKey:@"comment_rank"];
                     //将获取的value值放到数组容器中
                     if (![content isEqualToString:@""])
                     {
                         [add_timeList addObject:add_time];
                         [contentList addObject:content];
                         [comment_rankList addObject:comment_rank];
                     }
                 }
                 if (contentList.count >0)
                 {
                     //刷新列表
                     [ProgressHUD dismiss];
                     [self.tableView reloadData];
                 }
                 else
                 {
                     [ProgressHUD dismiss];
                     //                 [ProgressHUD showError:@"没有ch相关产品"];
                 }
             }
         }];

    }
}

//点击cell方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"点击了%d",indexPath.row);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

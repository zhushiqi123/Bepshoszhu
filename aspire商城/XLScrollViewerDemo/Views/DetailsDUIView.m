//
//  DetailsDUIView.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsDUIView.h"
#import "fiandGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "ProgressHUD.h"
#import "Goods.h"
#import "Session.h"
#import "DetailsViewController.h"
#import "StwClient.h"

@interface DetailsDUIView()
{
    NSMutableArray *textLabelList;
    NSMutableArray *detailTextLabelList;
    NSMutableArray *imageList;
    NSMutableArray *goodsIdList;
    NSMutableArray *goodsSnList;
}
@end

@implementation DetailsDUIView

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (_tableView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        [self performSelector:@selector(cleanViews) withObject:nil afterDelay:0.5f];
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
    return textLabelList.count;
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
    // 可重用标示符
    static NSString *ID = @"fiandGoodsCell";
    fiandGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //异步加载网络图片
        NSURL *url = [NSURL URLWithString:[imageList objectAtIndex:indexPath.section]];
        [cell.findGoodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        
        //        NSLog(@"图片网址--->%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageList objectAtIndex:indexPath.row]]]);
        
        cell.findGoodsName.text = [NSString stringWithFormat:@"%@",[textLabelList objectAtIndex:indexPath.section]];
        cell.findGoodsPrices.text = [NSString stringWithFormat:@"￥%@",[detailTextLabelList objectAtIndex:indexPath.section]];;
    }
    return cell;
}

-(void)cleanViews
{
    [self performSelectorInBackground:@selector(findGoods) withObject:nil];
}

-(void)findGoods
{
    @autoreleasepool
    {
        NSLog(@"开始搜索");
        NSString *names;
        if([Session sharedInstance].details_name)
        {
            names = [[Session sharedInstance].details_name substringWithRange:NSMakeRange(6,3)];
            NSLog(@"names=====>%@",names);
        }
        else
        {
            names = @"电池";
        }
        NSLog(@"names=====>%@",names);
    //    [ProgressHUD show:nil];
        if (names)
        {
            [Goods product_search:names success:^(id data)
             {
                 //         NSLog(@"商品查询返回数据1--->%@",data);
                 [ProgressHUD dismiss];
             }
                          failure:^(NSString *message)
             {
                 textLabelList = [[NSMutableArray alloc]init];
                 detailTextLabelList = [[NSMutableArray alloc]init];
                 imageList = [[NSMutableArray alloc]init];
                 goodsIdList = [[NSMutableArray alloc]init];
                 goodsSnList = [[NSMutableArray alloc]init];
                 
                 //         NSLog(@"商品查询返回数据2--->%@",message);
                 
                 //         [ProgressHUD dismiss];
                 NSDictionary *data = [StwClient jsonParsing:message];
                 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
                 //         NSLog(@"data------>%@",data);
                 NSDictionary *datas = [data objectForKey:@"data"];
                 if ([check_code isEqualToString:@"0"])
                 {
                     NSArray *list = [datas objectForKey:@"list"];
                     //                NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:findData];
                     NSLog(@"datas------>%@",list);
                     [ProgressHUD showSuccess:nil];
                     for (int i = 0; i<[list count]; i++)
                     {
                         //按数组中的索引取出对应的字典
                         NSDictionary *listdic = [list objectAtIndex:i];
                         //通过字典中的key取出对应value，并且强制转化为NSString类型
                         NSString *labelList = (NSString *)[listdic objectForKey:@"goods_name"];
                         NSString *detailList = (NSString *)[listdic objectForKey:@"shop_price"];
                         NSString *goodsId = [listdic objectForKey:@"goods_id"];
                         NSString *imageUrlList = (NSString *)[listdic objectForKey:@"goods_image_140"];
                          NSString *goodsn = (NSString *)[listdic objectForKey:@"goods_sn"];
                         //将获取的value值放到数组容器中
                         if (![labelList isEqualToString:@""] && ![imageUrlList isEqualToString:@""])
                         {
                             [textLabelList addObject:labelList];
                             [detailTextLabelList addObject:detailList];
                             [goodsIdList addObject:goodsId];
                             [imageList addObject:imageUrlList];
                             [goodsSnList addObject:goodsn];
                         }
                     }
                     if (textLabelList.count >0)
                     {
                         //刷新列表
                         //                 [ProgressHUD dismiss];
                         [self.tableView reloadData];
                     }
                     else
                     {
                         //                 [ProgressHUD dismiss];
                         //                 [ProgressHUD showError:@"没有ch相关产品"];
                     }
                 }
             }];
        }
    }
}

//点击cell方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%ld",(long)indexPath.section);
    
    [Session sharedInstance].details.goods_id = [goodsIdList[indexPath.section] intValue];
    [Session sharedInstance].details.goods_name = textLabelList[indexPath.section];
//    [Session sharedInstance].details.price = detailTextLabelList[indexPath.row];
    [Session sharedInstance].details_name = textLabelList[indexPath.section];
    [Session sharedInstance].homeACell_price = detailTextLabelList[indexPath.section];
    [Session sharedInstance].details.goods_sn = goodsSnList[indexPath.section];
    
    if([Session sharedInstance].details.goods_id&&[Session sharedInstance].details.goods_name&&[Session sharedInstance].details.goods_sn)
    {
            //获取商品详情
        //    [StwClient getGoodsDetial];

            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            DetailsViewController *detailsViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
            [navigationController pushViewController:detailsViewController animated:YES];
    }
    else
    {
        [ProgressHUD showError:@"暂未发售"];
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

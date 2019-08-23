//
//  findGoodsViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/2.
//  Copyright © 2015年 stw. All rights reserved.
//

#import "findGoodsViewController.h"
#import "Goods.h"
#import "ProgressHUD.h"
#import "fiandGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "DetailsViewController.h"
#import "Session.h"

@interface findGoodsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *textLabelList;
    NSMutableArray *detailTextLabelList;
    NSMutableArray *imageList;
    NSMutableArray *goodsIdList;
    NSMutableArray *goodsSnList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *findGoods_search;

@end

@implementation findGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品查询";
    self.findGoods_search.delegate = self;
    self.tableview.delegate  = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 80;

    // Do any additional setup after loading the view.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"开始搜索");
    [ProgressHUD show:nil];
    [Goods product_search:self.findGoods_search.text success:^(id data)
    {
        NSLog(@"商品查询返回数据1--->%@",data);
        [ProgressHUD dismiss];
    }
    failure:^(NSString *message)
    {
        NSLog(@"商品查询返回数据2--->%@",message);
        [ProgressHUD dismiss];
        NSDictionary *data = [StwClient jsonParsing:message];
        NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
        NSLog(@"data------>%@",data);
        NSDictionary *datas = [data objectForKey:@"data"];
        if ([check_code isEqualToString:@"0"])
        {
            textLabelList = [[NSMutableArray alloc]init];
            detailTextLabelList = [[NSMutableArray alloc]init];
            imageList = [[NSMutableArray alloc]init];
            goodsIdList = [[NSMutableArray alloc]init];
            goodsSnList = [[NSMutableArray alloc]init];
            
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
                NSString *imageUrlList = (NSString *)[listdic objectForKey:@"goods_image_100"];
                NSString *goodsn = (NSString *)[listdic objectForKey:@"goods_sn"];
                //将获取的value值放到数组容器中
                if (![labelList isEqualToString:@""] && ![imageUrlList isEqualToString:@""]) {
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
                [ProgressHUD dismiss];
                [self.tableview reloadData];
            }
            else
            {
                [ProgressHUD dismiss];
                [ProgressHUD showError:@"没有查询到信息"];
            }
        }
        else
        {
            [ProgressHUD dismiss];
            [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
        }
    }];
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
    return textLabelList.count;
}

// 告诉表格控件，每一行cell单元格的细节
// indexPath
//  @property(nonatomic,readonly) NSInteger section;    分组
//  @property(nonatomic,readonly) NSInteger row;        行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"fiandGoodsCell";
    fiandGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //异步加载网络图片
        NSURL *url = [NSURL URLWithString:[imageList objectAtIndex:indexPath.row]];
        [cell.findGoodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];

//        NSLog(@"图片网址--->%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageList objectAtIndex:indexPath.row]]]);

        cell.findGoodsName.text = [NSString stringWithFormat:@"%@",[textLabelList objectAtIndex:indexPath.row]];
        cell.findGoodsPrices.text = [NSString stringWithFormat:@"￥%@",[detailTextLabelList objectAtIndex:indexPath.row]];;
    }
    return cell;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"被点击了%d",indexPath.row);

    [Session sharedInstance].details.goods_id = [goodsIdList[indexPath.row] intValue];
    [Session sharedInstance].details.goods_name = textLabelList[indexPath.row];
    [Session sharedInstance].details.price = detailTextLabelList[indexPath.row];
    [Session sharedInstance].details_name = textLabelList[indexPath.row];
    [Session sharedInstance].homeACell_price = detailTextLabelList[indexPath.row];
    [Session sharedInstance].details.goods_sn = goodsSnList[indexPath.row];
    if([Session sharedInstance].details.goods_id&&[Session sharedInstance].details.goods_name&&[Session sharedInstance].details.goods_sn)
    {
         UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailsViewController *detailsViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
    else
    {
        [ProgressHUD showError:@"暂未发售"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

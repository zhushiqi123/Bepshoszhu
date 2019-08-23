//
//  HomeACell.m
//  aspire商城
//
//  Created by tyz on 15/12/7.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "HomeACell.h"
#import "Session.h"
#import "UIImageView+WebCache.h"
#import "DetailsViewController.h"
#import "ProgressHUD.h"
#import "Home.h"

#define HAWidth [UIScreen mainScreen].bounds.size.width

////屏幕适配
//#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HomeACell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@end

@implementation HomeACell

- (void)awakeFromNib
{
    //图片的宽
    CGFloat imageW = HAWidth;
    //CGFloat imageW = 300;
    // 图片高
    CGFloat imageH = 180;

//    CGFloat imageH = 200;
    //图片的Y
    CGFloat imageY = 0;
    //图片中数
    NSInteger totalCount = 5;
    //1.添加5张图片
    for (int i = 0; i < totalCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        //图片X
        CGFloat imageX = i * imageW;
        //设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //设置图片
//         NSString *name = [NSString stringWithFormat:@"img%d",i%2];
//               imageView.image = [UIImage imageNamed:name];
        
        //异步加载网络图片
        if ([Session  sharedInstance].homeAGoodsImage.count > 0)
        {
            NSString *imageList = [Session sharedInstance].homeAGoodsImage[i];
            NSURL *url = [NSURL URLWithString:imageList];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d",i%2]];
        }
        //隐藏指示条
         self.scroll_HomeA.showsHorizontalScrollIndicator = NO;
        
        [self.scroll_HomeA addSubview:imageView];
    }
    //    2.设置scrollview的滚动范围
         CGFloat contentW = totalCount*imageW;
    
    //不允许在垂直方向上进行滚动
         self.scroll_HomeA.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
         self.scroll_HomeA.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
         self.scroll_HomeA.delegate = self;
    
    //添加点按击手势监听器
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView:)];
    //设置手势属性
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired=1;
    //设置点按次数，默认为1，注意在iOS中很少用双击操作
    tapGesture.numberOfTouchesRequired=1;
    //点按的手指数
    [self.scroll_HomeA addGestureRecognizer:tapGesture];
    
    [self addTimer];
}

- (void)nextImage
{
    int page = (int)self.page_HomeA.currentPage;
    NSLog(@"page=======>%d",page);
    if(page == 4)
    {
        page = 0;
    }
    else
    {
        page++;
    }
   //  滚动scrollview
      CGFloat x = page * HAWidth;
      self.scroll_HomeA.contentOffset = CGPointMake(x, 0);
}

 // scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"滚动中");
    //    计算页码
  //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.page_HomeA.currentPage = page;
    //显示图片介绍
    if ([Session sharedInstance].homeAGoodsName.count > 0)
    {
        NSString *goodsName = [Session sharedInstance].homeAGoodsName[self.page_HomeA.currentPage];
        self.lable_HomeA.text = [NSString stringWithFormat:@"%@◎",goodsName];
    }
    else
    {
        self.lable_HomeA.text = @"连接网络跟新数据";
    }
   
}

 // 开始拖拽的时候调用
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
 //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
 //    [self.timer invalidate];
    [self removeTimer];
}
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 //    开启定时器
     [self addTimer];
}

/**
*  开启定时器
*/
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:44444 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
 }
/**
     *  关闭定时器
     */
-(void)removeTimer
{
    [self.timer invalidate];
}

-(void)tapUiscrollView:(id)sender
{
    NSLog(@"可以点击=====》%d",self.page_HomeA.currentPage);
    int goods_num = self.page_HomeA.currentPage;
    [Session sharedInstance].details.goods_id = [[Session sharedInstance].homeAGoodsId[goods_num] intValue];
    [Session sharedInstance].details.goods_name = [Session sharedInstance].homeAGoodsName[goods_num];
    [Session sharedInstance].details_name = [Session sharedInstance].homeAGoodsName[goods_num];
    [Session sharedInstance].details.goods_sn = [Session sharedInstance].homeAGoodsSn[goods_num];
    [Session sharedInstance].homeACell_price = [Session sharedInstance].homeAGoodsPrice[goods_num];
     if([Session sharedInstance].details.goods_id&&[Session sharedInstance].details.goods_name&&[Session sharedInstance].details.goods_sn)
     {
          UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
          DetailsViewController *detailsViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
          [navigationController pushViewController:detailsViewController animated:YES];
     }
     else
     {
         [ProgressHUD showError:@"数据参数有误!请检查网络设置"];
     }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DetailsACell.m
//  aspire商城
//
//  Created by tyz on 15/12/26.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsACell.h"
#import "Session.h"
#import "UIImageView+WebCache.h"

#define HAWidth 200

@implementation DetailsACell

- (void)awakeFromNib {
    //图片的宽
    CGFloat imageW = HAWidth;
    //CGFloat imageW = 300;
    // 图片高
    CGFloat imageH = 200;
    //图片的Y
    CGFloat imageY = 0;
    //图片中数
    NSInteger totalCount = 3;
    //1.添加3张图片
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
//        NSLog(@"加载页面个数>>>>%d",[Session  sharedInstance].details_imagesList.count);
        if ([Session  sharedInstance].details_imagesList.count >= 3)
        {
//            NSLog(@"需要加载的图片--->%@",[Session sharedInstance].details_imagesList[i]);
            NSString *imageList = [Session sharedInstance].details_imagesList[i];
            NSURL *url = [NSURL URLWithString:imageList];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        }
        else  if ([Session  sharedInstance].details_imagesList.count == 2)
        {
            if (i < 2) {
                NSLog(@"需要加载的图片--->%@",[Session sharedInstance].details_imagesList[i]);
                NSString *imageList = [Session sharedInstance].details_imagesList[i];
                NSURL *url = [NSURL URLWithString:imageList];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
            }
           else
           {
//               NSLog(@"需要加载的图片--->%@",[Session sharedInstance].details_imagesList[0]);
               NSString *imageList = [Session sharedInstance].details_imagesList[0];
               NSURL *url = [NSURL URLWithString:imageList];
               [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
           }
        }
        else  if ([Session  sharedInstance].details_imagesList.count == 1)
        {
//            NSLog(@"需要加载的图片--->%@",[Session sharedInstance].details_imagesList[0]);
            NSString *imageList = [Session sharedInstance].details_imagesList[0];
            NSURL *url = [NSURL URLWithString:imageList];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"listviewitemimg"]];
        }
        //隐藏指示条
        self.detailsPage.showsHorizontalScrollIndicator = NO;
        
        [self.detailsPage addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount*imageW;
    
    //不允许在垂直方向上进行滚动
    self.detailsPage.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    self.detailsPage.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
    self.detailsPage.delegate = self;
//
//    [self addTimer];
}

- (void)nextImage
{
    int page = (int)self.detailsNum.currentPage;
    NSLog(@"page=======>%d",page);
    if(page == 2)
    {
        page = 0;
    }
    else
    {
        page++;
    }
    //  滚动scrollview
    CGFloat x = page * HAWidth;
    self.detailsPage.contentOffset = CGPointMake(x, 0);
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
    self.detailsNum.currentPage = page;
}

//// 开始拖拽的时候调用
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
//    //    [self.timer invalidate];
//    [self removeTimer];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    //    开启定时器
//    [self addTimer];
//}
//
///**
// *  开启定时器
// */
//- (void)addTimer
//{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:44444 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
//}
///**
// *  关闭定时器
// */
//-(void)removeTimer
//{
//    [self.timer invalidate];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

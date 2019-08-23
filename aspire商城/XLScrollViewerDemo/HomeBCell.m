//
//  HomeBCell.m
//  aspire商城
//
//  Created by tyz on 15/12/7.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "HomeBCell.h"
#import "UIImageView+WebCache.h"
#import "Session.h"
#import "DetailsViewController.h"
#import "ProgressHUD.h"

@implementation HomeBCell

- (void)awakeFromNib
{
    // Initialization code
    if([Session sharedInstance].homeBCell_name.count > 0)
    {
        self.lableB_text12.text = [Session sharedInstance].homeBCell_name[0];
        self.lableB_text11.text = [NSString stringWithFormat:@"￥%@",[Session sharedInstance].homeBCell_price[0]];
        
        self.lableB_text22.text = [Session sharedInstance].homeBCell_name[1];
        self.lableB_text21.text = [NSString stringWithFormat:@"￥%@",[Session sharedInstance].homeBCell_price[1]];
        
        self.lableB_text32.text = [Session sharedInstance].homeBCell_name[2];
        self.lableB_text31.text = [NSString stringWithFormat:@"￥%@",[Session sharedInstance].homeBCell_price[2]];
        
        NSString *imageList1 = [Session sharedInstance].homeBCell_image[0];
        NSString *imageList2 = [Session sharedInstance].homeBCell_image[1];
        NSString *imageList3 = [Session sharedInstance].homeBCell_image[2];
        
        NSURL *url1 = [NSURL URLWithString:imageList1];
        NSURL *url2 = [NSURL URLWithString:imageList2];
        NSURL *url3 = [NSURL URLWithString:imageList3];
        
        [self.imageB_logo1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        [self.imageB_logo2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        [self.imageB_logo3 sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"listviewitemimg"]];
        
        self.imageB_logo1.userInteractionEnabled = YES;
        self.imageB_logo2.userInteractionEnabled = YES;
        self.imageB_logo3.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage1)];
        UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage2)];
        UITapGestureRecognizer *singleTap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage3)];
        
        [_imageB_logo1 addGestureRecognizer:singleTap1];
        [_imageB_logo2 addGestureRecognizer:singleTap2];
        [_imageB_logo3 addGestureRecognizer:singleTap3];
    }
}

-(void)onClickImage1
{
    NSLog(@"点击点击1");
    [self detials:0];
}

-(void)onClickImage2
{
    NSLog(@"点击点击2");
    [self detials:1];
}

-(void)onClickImage3
{
    NSLog(@"点击点击3");
    [self detials:2];
}

-(void)detials:(int)num
{
    int goods_num = num;
    [Session sharedInstance].details.goods_id = [[Session sharedInstance].homeBCell_id[goods_num] intValue];
    [Session sharedInstance].details.goods_name = [Session sharedInstance].homeBCell_name[goods_num];
    [Session sharedInstance].details_name = [Session sharedInstance].homeBCell_name[goods_num];
    [Session sharedInstance].homeACell_price = [Session sharedInstance].homeBCell_price[goods_num];
    [Session sharedInstance].details.goods_sn = [Session sharedInstance].homeBCell_sn[goods_num];
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

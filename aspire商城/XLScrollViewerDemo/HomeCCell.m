//
//  HomeCCell.m
//  aspire商城
//
//  Created by tyz on 15/12/7.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "HomeCCell.h"
#import "Session.h"
#import "DetailsViewController.h"
#import "ProgressHUD.h"

@implementation HomeCCell

- (void)awakeFromNib {
    // Initialization code
    self.imageC_logo1.userInteractionEnabled = YES;
    self.imageC_logo2.userInteractionEnabled = YES;

    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage1)];
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage2)];

    [_imageC_logo1 addGestureRecognizer:singleTap1];
    [_imageC_logo2 addGestureRecognizer:singleTap2];

}

-(void)onClickImage1
{
    NSLog(@"点击了1");
    [self check:self.lableC_text1.text :self.lableC_text2.text];
}

-(void)onClickImage2
{
    NSLog(@"点击了2");
    [self check:self.lableC_text4.text :self.lableC_text3.text];
}

-(void)check:(NSString *)name :(NSString *)price
{
//    NSLog(@"%@%@",name,price);
    for (int i = 0;i < [Session sharedInstance].homeCCell_id.count;i++)
    {
        if ([[Session sharedInstance].homeCCell_name[i] isEqualToString:name])
        {
//            NSLog(@"===>%@",[Session sharedInstance].homeCCell_id[i]);
            [Session sharedInstance].details.goods_id = [[Session sharedInstance].homeCCell_id[i] intValue];
            [Session sharedInstance].details.goods_name = [Session sharedInstance].homeCCell_name[i];
            [Session sharedInstance].homeACell_price = [Session sharedInstance].homeCCell_price[i];
            [Session sharedInstance].details_name = [Session sharedInstance].homeCCell_name[i];
            [Session sharedInstance].details.goods_sn = [Session sharedInstance].homeCCell_sn[i];
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
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

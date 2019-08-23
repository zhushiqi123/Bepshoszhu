//
//  View2.m
//  XLScrollViewerDemo

//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.


#import "HomeTier.h"
#import "MultilevelMenu.h"
#import "DetailsViewController.h"
#import "Session.h"
#import "Goods.h"
#import "StwClient.h"
#import "ProgressHUD.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation HomeTier

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        
        NSMutableArray * lis=[NSMutableArray array];
        /**
         *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
         */
        NSArray *titleName =@[@"套装",@"雾化器",@"电池",@"雾化芯",@"配件"];
        NSInteger countMax;
        if ([Session sharedInstance].tierAList_name.count > 0)
        {
            countMax =[Session sharedInstance].tierAList_name.count;
        }
        else
        {
            countMax = 5;
        }
      
        for (int i=0; i<countMax; i++)
        {
            rightMeun * meun=[[rightMeun alloc] init];
            rightMeun * meun1=[[rightMeun alloc] init];
            int counts = 1;
            
            NSMutableArray *lists_goodsName = [NSMutableArray array];
            NSMutableArray *lists_price = [NSMutableArray array];
            NSMutableArray *lists_Image = [NSMutableArray array];
            NSMutableArray *lists_Id = [NSMutableArray array];
             NSMutableArray *lists_sn = [NSMutableArray array];
            
            if ([Session sharedInstance].tierAList_name.count > 0)
            {
                meun.meunName=[NSString stringWithFormat:@"%@",[Session sharedInstance].tierAList_name[i]];
                meun1.meunName=[NSString stringWithFormat:@"%@",[Session sharedInstance].tierAList_name[i]];
                //数据分离
                //            NSMutableArray *arrys = [Session sharedInstance].tierCList_catId;
                for (int j=0;j<[Session sharedInstance].tierBList_cat_id.count;j++)
                {
                    for(int n = 0;n<[Session sharedInstance].tierCList_catId.count;n++)
                    {
                        if([[Session sharedInstance].tierCList_catId[n] isEqualToString:[Session sharedInstance].tierBList_cat_id[j]])
                        {
                            if([[Session sharedInstance].tierAList_cat_id[i] isEqualToString:[Session sharedInstance].tierBList_parent_id[j]])
                            {
                                [lists_goodsName addObject:[Session sharedInstance].tierCList_Name[n]];
                                [lists_price addObject:[Session sharedInstance].tierCList_Price[n]];
                                [lists_Image addObject:[Session sharedInstance].tierCList_Image[n]];
                                [lists_Id addObject:[Session sharedInstance].tierCList_Id[n]];
                                [lists_sn addObject:[Session sharedInstance].tierCList_Sn[n]];
                            }
                        }
                    }
                }
                counts = lists_goodsName.count;
            }
            else
            {
                meun.meunName=[NSString stringWithFormat:@"Aspire-%@",titleName[i]];
                meun1.meunName=[NSString stringWithFormat:@"Aspire-%@",titleName[i]];
                counts = 1;
            }
           
            NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
            [sub addObject:meun1];
            

//            NSLog(@"==========lists=========%@",lists_goodsName);
            
//                meun.meunNumber=2;
            //显示商品列表最多为十个，一般为网络获取 z是为动态赋值
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int z=0; z < counts; z++)
            {
                rightMeun * meun2=[[rightMeun alloc] init];
                if ([Session sharedInstance].tierAList_name.count > 0)
                {
                    meun2.meunName = [NSString stringWithFormat:@"%@",lists_goodsName[z]];
                    meun2.price = [NSString stringWithFormat:@"%@",lists_price[z]];
                    meun2.urlName = [NSString stringWithFormat:@"%@",lists_Image[z]];
                    meun2.ID = [NSString stringWithFormat:@"%@",lists_Id[z]];
                    meun2.sn = [NSString stringWithFormat:@"%@",lists_sn[z]];
                }
                [zList addObject:meun2];
            }
            
            meun1.nextArray=zList;
            meun.nextArray=sub;
            [lis addObject:meun];
        }
        
        /**
         默认是 选中第一行
         
         :returns: <#return value description#>
         */
        MultilevelMenu * view = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info)
        {
            NSLog(@"点击的 商品ID-->%@",info.ID);
            
//            NSLog(@"info------>%@,%@,%@",info.ID,info.meunName,info.sn);
            
            [Session sharedInstance].details.goods_id = [info.ID intValue];
            [Session sharedInstance].details.goods_name = info.meunName;
            [Session sharedInstance].details_name = info.meunName;
            [Session sharedInstance].details.goods_sn = info.sn;
            [Session sharedInstance].homeACell_price = info.price;
           if([Session sharedInstance].details.goods_id > 0 && [Session sharedInstance].details.goods_name && [Session sharedInstance].details.goods_sn)
            {
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                DetailsViewController *detailsViewController = [navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
                [navigationController pushViewController:detailsViewController animated:YES];
            }
            else
            {
                [ProgressHUD showError:@"此商品暂未发售!"];
            }
        }];
    
        view.needToScorllerIndex=0;
        
        view.isRecordLastScroll=YES;
        [self addSubview:view];
    }
    return self;
}

@end

//
//  AppDelegate.m
//  XLScrollViewerDemo
//
//  Created by stw 01 on 15/12/02.
//  演示APP 没做详细处理
//  Copyright (c) 2015年 stw All rights reserved.
//

#import "AppDelegate.h"
#import "StwClient.h"
#import "HomeACell.h"
#import "Keys.h"
#import "Session.h"
#import "Goods.h"
#import "MBProgressHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Reachability.h"
#import "ProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //程序初始化网络访问
    [StwClient initInstance:@"http://www.aspirecig.cn/api/index.php/"];
//    [[StwClient sharedInstance] setUserID:0];
    
    //获取当前时间作为刷新的要求
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSLog(@"timeString------>%@",timeString);
    
    //获取accesskey
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"aspireAccesskey"]) {
        [Session sharedInstance].user.accesskey = [def objectForKey:@"aspireAccesskey"];
    }
    
    //取出和购物车数据
    NSMutableArray *shopData = [def objectForKey:@"data_shopCarss"];
    NSString *aspireNetWorkCheck = [def objectForKey:@"aspireNetWorkCheck"];
//    NSLog(@"ssssssssss%@",shopData);
    if (shopData.count > 0) {
        for (int i = 0; i < shopData.count;i++) {
            [[Session sharedInstance].shopCarss addObject:shopData[i]];
        }
    }
    
    if([self isConnectionAvailable])
    {
        if (!aspireNetWorkCheck)
        {
            //有网络数据开启线程初始化商品数据
            [self performSelectorInBackground:@selector(getGoodsAList) withObject:nil];
            [self performSelectorInBackground:@selector(getGoodsCList) withObject:nil];
            [self performSelectorInBackground:@selector(getHomeACellData) withObject:nil];
            [self performSelectorInBackground:@selector(getHomeBCellData) withObject:nil];
            [self performSelectorInBackground:@selector(getHomeCCellData) withObject:nil];
        }
    }
    else
    {
        NSLog(@"网络访问失败请检查您的网络设置");
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    HomeACell *HomeACells;
    [HomeACells removeTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    HomeACell *HomeACells;
    [HomeACells removeTimer];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"ali--->result = %@",resultDic);
    }];
    return YES;
}

//检测网络状态
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.aspirecig.cn"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}


-(void)getGoodsAList
{
    @autoreleasepool
    {
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        //获取分类商品列表A B
        [Goods category_index:^(id data)
         {
             NSLog(@"返回的商品数据1-------->%@",data);
         }
         failure:^(NSString *message)
         {
    //         NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//             NSLog(@"返回的商品数据2BBBBA-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0)
                 {
                     for (int i = 0; i<[list count]; i++)
                     {
                         //按数组中的索引取出对应的字典
                         NSDictionary *listdic = [list objectAtIndex:i];
                         //通过字典中的key取出对应value，并且强制转化为NSString类型
                         NSString *parent_id = (NSString *)[listdic objectForKey:@"parent_id"];
                         NSString *cat_id = (NSString *)[listdic objectForKey:@"cat_id"];
                         //将获取的value值放到数组容器中
                         if ([parent_id isEqualToString:@"0"])
                         {
                             NSString *name = (NSString *)[listdic objectForKey:@"cat_name"];
                             if (![name isEqualToString:@""] && name)
                             {
                                 [[Session sharedInstance].tierAList_name addObject:name];
                                 [[Session sharedInstance].tierAList_cat_id addObject:cat_id];
                                 [[Session sharedInstance].tierAList_parent_id addObject:parent_id];
                             }
                         }
                         else
                         {
                             if (![parent_id isEqualToString:@""] && parent_id) {
                                 [[Session sharedInstance].tierBList_cat_id addObject:cat_id];
                                 [[Session sharedInstance].tierBList_parent_id addObject:parent_id];
                             }
                         }
                     }
                     //持久化保存数据
    //                 if ([Session sharedInstance].tierAList_name.count > 0) {
    //                     [def setObject:[Session sharedInstance].tierAList_name forKey:@"tierAList_name"];
    //                     [def setObject:[Session sharedInstance].tierAList_cat_id forKey:@"tierAList_cat_id"];
    //                     [def setObject:[Session sharedInstance].tierAList_parent_id forKey:@"tierAList_parent_id"];
    //                     [def setObject:[Session sharedInstance].tierBList_cat_id forKey:@"tierBList_cat_id"];
    //                     [def setObject:[Session sharedInstance].tierBList_parent_id forKey:@"tierBList_parent_id"];
    //                 }
                 }
             }
         }];
    }
}

-(void)getGoodsCList
{
    @autoreleasepool
    {
        //获取分类商品列表C
        [Goods product_index:^(id data)
         {
             NSLog(@"返回的商品数据1-------->%@",data);
         }
         failure:^(NSString *message)
         {
    //         NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//             NSLog(@"返回的商品数据2222BBBBBB-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0) {
                     for (int i = 0; i<[list count]; i++)
                     {
                         //按数组中的索引取出对应的字典
                         NSDictionary *listdic = [list objectAtIndex:i];
                         //通过字典中的key取出对应value，并且强制转化为NSString类型
                         NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
                         if (![image isEqualToString:@""])
                         {
                             NSString *cat_id = [listdic objectForKey:@"cat_id"];
                             NSString *name = [listdic objectForKey:@"goods_name"];
                             NSString *goods_id = [listdic objectForKey:@"goods_id"];
                             NSString *price = [listdic objectForKey:@"shop_price"];
                             NSString *sn = [listdic objectForKey:@"goods_sn"];
                             //将获取的value值放到数组容器中
                             if (![cat_id isEqualToString:@""] && cat_id)
                             {
                                 [[Session sharedInstance].tierCList_Name addObject:name];
                                 [[Session sharedInstance].tierCList_catId addObject:cat_id];
                                 [[Session sharedInstance].tierCList_Id addObject:goods_id];
                                 [[Session sharedInstance].tierCList_Image addObject:image];
                                 [[Session sharedInstance].tierCList_Price addObject:price];
                                 [[Session sharedInstance].tierCList_Sn addObject:sn];
                             }
                         }
                     }
                     //持久化保存数据
    //                 if ([Session sharedInstance].tierCList_Name.count > 0)
    //                 {
    //                     [def setObject:[Session sharedInstance].tierCList_Name forKey:@"tierCList_Name"];
    //                     [def setObject:[Session sharedInstance].tierCList_catId forKey:@"tierCList_catId"];
    //                     [def setObject:[Session sharedInstance].tierCList_Id forKey:@"tierCList_Id"];
    //                     [def setObject:[Session sharedInstance].tierCList_Image forKey:@"tierCList_Image"];
    //                     [def setObject:[Session sharedInstance].tierCList_Price forKey:@"tierCList_Price"];
    //                     [def setObject:[Session sharedInstance].tierCList_Sn forKey:@"tierCList_Sn"];
    //                 }
                 }
              }
         }];
    }
}

-(void)getHomeACellData          //获取滚动信息
{
    @autoreleasepool
    {
        [Goods banner_index:^(id data)
        {
            NSLog(@"返回的商品数据1-------->%@",data);
        }
        failure:^(NSString *message)
        {
    //        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//            NSLog(@"返回的商品数据2rrr-------->%@",message);
            NSDictionary *data = [StwClient jsonParsing:message];
            NSDictionary *datas = [data objectForKey:@"data"];
            NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
            if ([check_code isEqualToString:@"0"])
            {
                NSArray *list = [datas objectForKey:@"list"];
                if (list > 0) {
                    for (int i = 0; i<[list count]; i++)
                    {
                        //按数组中的索引取出对应的字典
                        NSDictionary *listdic = [list objectAtIndex:i];
                        //通过字典中的key取出对应value，并且强制转化为NSString类型
                        NSString *image = (NSString *)[listdic objectForKey:@"image"];
                        NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
                        NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
                        NSString *goods_sn = (NSString *)[listdic objectForKey:@"goods_sn"];
                        NSString *goods_price = (NSString *)[listdic objectForKey:@"shop_price"];
                        //将获取的value值放到数组容器中
                        if (![image isEqualToString:@""] && image) {
                            [[Session sharedInstance].homeAGoodsName addObject:name];
                            [[Session sharedInstance].homeAGoodsId addObject:goods_id];
                            [[Session sharedInstance].homeAGoodsImage addObject:image];
                            [[Session sharedInstance].homeAGoodsSn addObject:goods_sn];
                            [[Session sharedInstance].homeAGoodsPrice addObject:goods_price];
                        }
                    }
                    //持久化保存数据
    //                if ([Session sharedInstance].homeAGoodsName.count > 0) {
    //                    [def setObject:[Session sharedInstance].homeAGoodsName forKey:@"homeAGoodsName"];
    //                    [def setObject:[Session sharedInstance].homeAGoodsId forKey:@"homeAGoodsId"];
    //                    [def setObject:[Session sharedInstance].homeAGoodsImage forKey:@"homeAGoodsImage"];
    //                    [def setObject:[Session sharedInstance].homeAGoodsSn forKey:@"homeAGoodsSn"];
    //                    [def setObject:[Session sharedInstance].homeAGoodsPrice forKey:@"homeAGoodsPrice"];
    //                }
                }
            }
        }];
    }
}

-(void)getHomeBCellData     //获取主页热卖信息
{
    @autoreleasepool
    {
        [Goods product_category:^(id data)
        {
            NSLog(@"返回的商品数据1-------->%@",data);
        }
        failure:^(NSString *message)
        {
    //        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //        NSLog(@"返回的商品数据2-------->%@",message);
            NSDictionary *data = [StwClient jsonParsing:message];
            NSDictionary *datas = [data objectForKey:@"data"];
            NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
            if ([check_code isEqualToString:@"0"])
            {
                NSArray *list = [datas objectForKey:@"list"];
                if (list.count > 0) {
                    for (int i = 0; i<[list count]; i++)
                    {
                        //按数组中的索引取出对应的字典
                        NSDictionary *listdic = [list objectAtIndex:i];
                        //通过字典中的key取出对应value，并且强制转化为NSString类型
                        NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
                        NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
                        NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
                        NSString *price = (NSString *)[listdic objectForKey:@"shop_price"];
                        NSString *sn = (NSString *)[listdic objectForKey:@"goods_sn"];
                        //将获取的value值放到数组容器中
                        if (![image isEqualToString:@""] && image)
                        {
                            [[Session sharedInstance].homeBCell_name addObject:name];
                            [[Session sharedInstance].homeBCell_id addObject:goods_id];
                            [[Session sharedInstance].homeBCell_image addObject:image];
                            [[Session sharedInstance].homeBCell_price addObject:price];
                            [[Session sharedInstance].homeBCell_sn addObject:sn];
                        }
                    }
                    //持久化保存数据
    //                if ([Session sharedInstance].homeBCell_name.count >0) {
    //                    [def setObject:[Session sharedInstance].homeBCell_name forKey:@"homeBCell_name"];
    //                    [def setObject:[Session sharedInstance].homeBCell_id forKey:@"homeBCell_id"];
    //                    [def setObject:[Session sharedInstance].homeBCell_image forKey:@"homeBCell_image"];
    //                    [def setObject:[Session sharedInstance].homeBCell_price forKey:@"homeBCell_price"];
    //                    [def setObject:[Session sharedInstance].homeBCell_sn forKey:@"homeBCell_sn"];
    //                }
                }
            }
        }];
    }
}

-(void)getHomeCCellData   //获取主页推荐商品信息
{
    @autoreleasepool
    {
        [Goods product_category2:^(id data)
         {
             NSLog(@"返回的商品数据1-------->%@",data);
         }
         failure:^(NSString *message)
         {
    //         NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//             NSLog(@"返回的商品数据2-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0) {
                     for (int i = 0; i<[list count]; i++)
                     {
                         //按数组中的索引取出对应的字典
                         NSDictionary *listdic = [list objectAtIndex:i];
                         //通过字典中的key取出对应value，并且强制转化为NSString类型
                         NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
                         NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
                         NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
                         NSString *price = (NSString *)[listdic objectForKey:@"shop_price"];
                         NSString *sn = (NSString *)[listdic objectForKey:@"goods_sn"];
                         //将获取的value值放到数组容器中
                         if (![image isEqualToString:@""] && image) {
                             [[Session sharedInstance].homeCCell_name addObject:name];
                             [[Session sharedInstance].homeCCell_id addObject:goods_id];
                             [[Session sharedInstance].homeCCell_image addObject:image];
                             [[Session sharedInstance].homeCCell_price addObject:price];
                             [[Session sharedInstance].homeCCell_sn addObject:sn];
                         }
                         
                     }
                     //持久化保存数据
    //                 if ([Session sharedInstance].homeCCell_name.count > 0) {
    //                     [def setObject:[Session sharedInstance].homeCCell_name forKey:@"homeCCell_name"];
    //                     [def setObject:[Session sharedInstance].homeCCell_id forKey:@"homeCCell_id"];
    //                     [def setObject:[Session sharedInstance].homeCCell_image forKey:@"homeCCell_image"];
    //                     [def setObject:[Session sharedInstance].homeCCell_price forKey:@"homeCCell_price"];
    //                     [def setObject:[Session sharedInstance].homeCCell_sn forKey:@"homeCCell_sn"];
    //                 }
                 }
             }
         }];
    }
}
/**
 -(void)getGoodsAList
 {
 //获取分类商品列表A B
 [Goods category_index:^(id data)
 {
 NSLog(@"返回的商品数据1-------->%@",data);
 }
 failure:^(NSString *message)
 {
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSLog(@"返回的商品数据2-------->%@",message);
 NSDictionary *data = [StwClient jsonParsing:message];
 NSDictionary *datas = [data objectForKey:@"data"];
 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
 if ([check_code isEqualToString:@"0"])
 {
 NSMutableArray *tierAList_name = [NSMutableArray array];
 NSMutableArray *tierAList_cat_id = [NSMutableArray array];
 NSMutableArray *tierAList_parent_id = [NSMutableArray array];
 NSMutableArray *tierBList_cat_id = [NSMutableArray array];
 NSMutableArray *tierBList_parent_id = [NSMutableArray array];
 
 NSArray *list = [datas objectForKey:@"list"];
 for (int i = 0; i<[list count]; i++)
 {
 //按数组中的索引取出对应的字典
 NSDictionary *listdic = [list objectAtIndex:i];
 //通过字典中的key取出对应value，并且强制转化为NSString类型
 NSString *parent_id = (NSString *)[listdic objectForKey:@"parent_id"];
 NSString *cat_id = (NSString *)[listdic objectForKey:@"cat_id"];
 //将获取的value值放到数组容器中
 if ([parent_id isEqualToString:@"0"])
 {
 NSString *name = (NSString *)[listdic objectForKey:@"cat_name"];
 [tierAList_name addObject:name];
 [tierAList_cat_id addObject:cat_id];
 [tierAList_parent_id addObject:parent_id];
 }
 else
 {
 [tierBList_cat_id addObject:cat_id];
 [tierBList_parent_id addObject:parent_id];
 }
 }
 //持久化保存数据
 [def setObject:tierAList_name forKey:@"tierAList_name"];
 [def setObject:tierAList_cat_id forKey:@"tierAList_cat_id"];
 [def setObject:tierAList_parent_id forKey:@"tierAList_parent_id"];
 [def setObject:tierBList_cat_id forKey:@"tierBList_cat_id"];
 [def setObject:tierBList_parent_id forKey:@"tierBList_parent_id"];
 }
 }];
 }
 
 -(void)getGoodsCList
 {
 //获取分类商品列表C
 [Goods product_index:^(id data)
 {
 NSLog(@"返回的商品数据1-------->%@",data);
 }
 failure:^(NSString *message)
 {
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSLog(@"返回的商品数据2-------->%@",message);
 NSDictionary *data = [StwClient jsonParsing:message];
 NSDictionary *datas = [data objectForKey:@"data"];
 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
 if ([check_code isEqualToString:@"0"])
 {
 NSMutableArray *tierCList_Name = [NSMutableArray array];
 NSMutableArray *tierCList_catId = [NSMutableArray array];
 NSMutableArray *tierCList_Id = [NSMutableArray array];
 NSMutableArray *tierCList_Image = [NSMutableArray array];
 NSMutableArray *tierCList_Price = [NSMutableArray array];
 
 NSArray *list = [datas objectForKey:@"list"];
 for (int i = 0; i<[list count]; i++)
 {
 //按数组中的索引取出对应的字典
 NSDictionary *listdic = [list objectAtIndex:i];
 //通过字典中的key取出对应value，并且强制转化为NSString类型
 NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
 if (![image isEqualToString:@""])
 {
 NSString *cat_id = (NSString *)[listdic objectForKey:@"cat_id"];
 NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
 NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
 NSString *price = (NSString *)[listdic objectForKey:@"shop_price"];
 //将获取的value值放到数组容器中
 [tierCList_Name addObject:name];
 [tierCList_catId addObject:cat_id];
 [tierCList_Id addObject:goods_id];
 [tierCList_Image addObject:image];
 [tierCList_Price addObject:price];
 }
 }
 //持久化保存数据
 [def setObject:tierCList_Name forKey:@"tierCList_Name"];
 [def setObject:tierCList_catId forKey:@"tierCList_catId"];
 [def setObject:tierCList_Id forKey:@"tierCList_Id"];
 [def setObject:tierCList_Image forKey:@"tierCList_Image"];
 [def setObject:tierCList_Price forKey:@"tierCList_Price"];
 }
 }];
 }
 
 -(void)getHomeACellData
 {
 [Goods banner_index:^(id data)
 {
 NSLog(@"返回的商品数据1-------->%@",data);
 }
 failure:^(NSString *message)
 {
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 //        NSLog(@"返回的商品数据2-------->%@",message);
 NSDictionary *data = [StwClient jsonParsing:message];
 NSDictionary *datas = [data objectForKey:@"data"];
 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
 if ([check_code isEqualToString:@"0"])
 {
 NSMutableArray *homeAGoodsName = [NSMutableArray array];
 NSMutableArray *homeAGoodsId = [NSMutableArray array];
 NSMutableArray *homeAGoodsImage = [NSMutableArray array];
 NSArray *list = [datas objectForKey:@"list"];
 for (int i = 0; i<[list count]; i++)
 {
 //按数组中的索引取出对应的字典
 NSDictionary *listdic = [list objectAtIndex:i];
 //通过字典中的key取出对应value，并且强制转化为NSString类型
 NSString *image = (NSString *)[listdic objectForKey:@"image"];
 NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
 NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
 //将获取的value值放到数组容器中
 [homeAGoodsName addObject:name];
 [homeAGoodsId addObject:goods_id];
 [homeAGoodsImage addObject:image];
 }
 //持久化保存数据
 [def setObject:homeAGoodsName forKey:@"homeAGoodsName"];
 [def setObject:homeAGoodsId forKey:@"homeAGoodsId"];
 [def setObject:homeAGoodsImage forKey:@"homeAGoodsImage"];
 }
 
 }];
 }
 
 -(void)getHomeBCellData
 {
 [Goods product_category:^(id data)
 {
 NSLog(@"返回的商品数据1-------->%@",data);
 }
 failure:^(NSString *message)
 {
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 //        NSLog(@"返回的商品数据2-------->%@",message);
 NSDictionary *data = [StwClient jsonParsing:message];
 NSDictionary *datas = [data objectForKey:@"data"];
 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
 if ([check_code isEqualToString:@"0"])
 {
 NSMutableArray *homeBCell_name = [NSMutableArray array];
 NSMutableArray *homeBCell_id = [NSMutableArray array];
 NSMutableArray *homeBCell_image = [NSMutableArray array];
 NSMutableArray *homeBCell_price = [NSMutableArray array];
 
 NSArray *list = [datas objectForKey:@"list"];
 for (int i = 0; i<[list count]; i++)
 {
 //按数组中的索引取出对应的字典
 NSDictionary *listdic = [list objectAtIndex:i];
 //通过字典中的key取出对应value，并且强制转化为NSString类型
 NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
 NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
 NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
 NSString *price = (NSString *)[listdic objectForKey:@"shop_price"];
 //将获取的value值放到数组容器中
 [homeBCell_name addObject:name];
 [homeBCell_id addObject:goods_id];
 [homeBCell_image addObject:image];
 [homeBCell_price addObject:price];
 }
 //持久化保存数据
 [def setObject:homeBCell_name forKey:@"homeBCell_name"];
 [def setObject:homeBCell_id forKey:@"homeBCell_id"];
 [def setObject:homeBCell_image forKey:@"homeBCell_image"];
 [def setObject:homeBCell_price forKey:@"homeBCell_price"];
 }
 }];
 }
 
 -(void)getHomeCCellData
 {
 [Goods product_category2:^(id data)
 {
 NSLog(@"返回的商品数据1-------->%@",data);
 }
 failure:^(NSString *message)
 {
 NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
 NSLog(@"返回的商品数据2-------->%@",message);
 NSDictionary *data = [StwClient jsonParsing:message];
 NSDictionary *datas = [data objectForKey:@"data"];
 NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
 if ([check_code isEqualToString:@"0"])
 {
 NSMutableArray *homeCCell_name = [NSMutableArray array];
 NSMutableArray *homeCCell_id = [NSMutableArray array];
 NSMutableArray *homeCCell_image = [NSMutableArray array];
 NSMutableArray *homeCCell_price = [NSMutableArray array];
 NSArray *list = [datas objectForKey:@"list"];
 for (int i = 0; i<[list count]; i++)
 {
 //按数组中的索引取出对应的字典
 NSDictionary *listdic = [list objectAtIndex:i];
 //通过字典中的key取出对应value，并且强制转化为NSString类型
 NSString *image = (NSString *)[listdic objectForKey:@"goods_image_140"];
 NSString *name = (NSString *)[listdic objectForKey:@"goods_name"];
 NSString *goods_id = (NSString *)[listdic objectForKey:@"goods_id"];
 NSString *price = (NSString *)[listdic objectForKey:@"shop_price"];
 //将获取的value值放到数组容器中
 [homeCCell_name addObject:name];
 [homeCCell_id addObject:goods_id];
 [homeCCell_image addObject:image];
 [homeCCell_price addObject:price];
 }
 //持久化保存数据
 [def setObject:homeCCell_name forKey:@"homeCCell_name"];
 [def setObject:homeCCell_id forKey:@"homeCCell_id"];
 [def setObject:homeCCell_image forKey:@"homeCCell_image"];
 [def setObject:homeCCell_price forKey:@"homeCCell_price"];
 }
 }];
 }
 
 //本地数据获取
 -(void)getLocalData
 {
     //取出存储本地数据
     NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
     
     [Session sharedInstance].tierAList_name = [def objectForKey:@"tierAList_name"];
     [Session sharedInstance].tierAList_cat_id = [def objectForKey:@"tierAList_cat_id"];
     [Session sharedInstance].tierAList_parent_id = [def objectForKey:@"tierAList_parent_id"];
     [Session sharedInstance].tierBList_cat_id = [def objectForKey:@"tierBList_cat_id"];
     [Session sharedInstance].tierBList_parent_id = [def objectForKey:@"tierBList_parent_id"];
     
     [Session sharedInstance].tierCList_Name = [def objectForKey:@"tierCList_Name"];
     [Session sharedInstance].tierCList_catId = [def objectForKey:@"tierCList_catId"];
     [Session sharedInstance].tierCList_Id = [def objectForKey:@"tierCList_Id"];
     [Session sharedInstance].tierCList_Image = [def objectForKey:@"tierCList_Image"];
     [Session sharedInstance].tierCList_Price = [def objectForKey:@"tierCList_Price"];
     
     [Session sharedInstance].homeAGoodsName = [def objectForKey:@"homeAGoodsName"];
     [Session sharedInstance].homeAGoodsId = [def objectForKey:@"homeAGoodsId"];
     [Session sharedInstance].homeAGoodsImage = [def objectForKey:@"homeAGoodsImage"];
     
     [Session sharedInstance].homeBCell_name = [def objectForKey:@"homeBCell_name"];
     [Session sharedInstance].homeBCell_id = [def objectForKey:@"homeBCell_id"];
     [Session sharedInstance].homeBCell_image = [def objectForKey:@"homeBCell_image"];
     [Session sharedInstance].homeBCell_price = [def objectForKey:@"homeBCell_price"];
     
     [Session sharedInstance].homeBCell_name = [def objectForKey:@"homeBCell_name"];
     [Session sharedInstance].homeBCell_id = [def objectForKey:@"homeBCell_id"];
     [Session sharedInstance].homeBCell_image = [def objectForKey:@"homeBCell_image"];
     [Session sharedInstance].homeBCell_price = [def objectForKey:@"homeBCell_price"];
 }
 */
@end

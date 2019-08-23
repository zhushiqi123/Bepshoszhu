//
//  ViewController.m
//  XLScrollViewerDemo
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.

#import "ViewController.h"
#import "Home.h"
#import "HomeTier.h"
#import "HomeMy.h"
#import "Session.h"
#import "Goods.h"
#import "ProgressHUD.h"
#import "Reachability.h"

@interface ViewController()
{
    NSTimer *timer;
    int show;
}
@property (weak, nonatomic) IBOutlet UIButton *btn_findGoods;
@property (weak, nonatomic) IBOutlet UIButton *btn_cart;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化计数，弹出提示只弹出一次
    show = 0;
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 115, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageview];
    imageview.image = [UIImage imageNamed:@"aspirelogo"];
    //设置背景图片
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commonhead"]];
    
    //设置查询商品按钮
    self.btn_findGoods.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_inport_normal"]];
    //设置购物车按钮
    self.btn_cart.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gwc"]];
    
    [ProgressHUD show:@"加载中..."];
    [self performSelector:@selector(getUIviews) withObject:nil afterDelay:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUIviews
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *aspireNetWorkCheck = [def objectForKey:@"aspireNetWorkCheck"];
    if([Session sharedInstance].tierBList_cat_id.count<1||[Session sharedInstance].tierAList_name.count < 1||[Session sharedInstance].homeAGoodsImage.count <1 ||[Session sharedInstance].homeBCell_price.count < 1 || [Session sharedInstance].homeCCell_image.count <1)
    {
        if (aspireNetWorkCheck)
        {
            if([self isConnectionAvailable])
            {
                NSLog(@"联网状态获取网络数据");
                [self getNetWork];
                [self performSelector:@selector(getUIviews) withObject:nil afterDelay:2.0f];
            }
            else
            {
                NSLog(@"非联网状态获取本地缓存数据");
//                [ProgressHUD showError:@"无网络状态!"];
                 //获取本地数据
                [self getLocalData];
                [self performSelector:@selector(getViews) withObject:nil afterDelay:1.0f];
            }
        }
        else
        {
            show++;
            if (show == 0)
            {
                [ProgressHUD showError:@"网络访问失败请检查您的网络设置"];
            }
            //创建定时器  repeats:YES标示循环执行检测网络状态
            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            //开启计时器
            [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
    }
    else
    {
        [ProgressHUD dismiss];
        [self dataBaseLoad];
        [self getViews];
    }
}

-(void)getViews
{
    [ProgressHUD showSuccess:nil];
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //    self.title =@"效果演示";
    CGRect frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64);//如果没有导航栏，则去掉64
    
    //对应填写两个数组
    NSArray *views =@[[Home new],[HomeTier new],[HomeMy new]];
    NSArray *names =@[@"首页",@"分类",@"我的"];
    //创建使用
    self.scroll =[XLScrollViewer scrollWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:111];//三种动画都选择
    
    //自定义各种属性
    self.scroll.xl_topBackColor =[UIColor whiteColor];
    self.scroll.xl_sliderColor =[UIColor orangeColor];
    self.scroll.xl_buttonColorNormal =[UIColor blackColor];
    self.scroll.xl_buttonColorSelected =[UIColor whiteColor];
    self.scroll.xl_buttonFont =16;
    self.scroll.xl_buttonToSlider =20;
    self.scroll.xl_sliderHeight =20;
    self.scroll.xl_topHeight =20;
    self.scroll.xl_isSliderCorner =YES;
    
    [ProgressHUD dismiss];
    //加入控制器视图
    [self.view addSubview:self.scroll];
}

//防止数据出错初始化赋值
//-(void)addDataNSMutableArray
//{
//    [[Session sharedInstance].tierAList_name addObject:[NSNull null]];
//    [[Session sharedInstance].tierAList_cat_id addObject:[NSNull null]];
//    [[Session sharedInstance].tierAList_parent_id addObject:[NSNull null]];
//    [[Session sharedInstance].tierBList_cat_id addObject:[NSNull null]];
//    [[Session sharedInstance].tierBList_parent_id addObject:[NSNull null]];
//    [[Session sharedInstance].tierCList_Name addObject:[NSNull null]];
//    [[Session sharedInstance].tierCList_catId addObject:[NSNull null]];
//    [[Session sharedInstance].tierCList_Id addObject:[NSNull null]];
//    [[Session sharedInstance].tierCList_Image addObject:[NSNull null]];
//    [[Session sharedInstance].tierCList_Price addObject:[NSNull null]];
//    [[Session sharedInstance].homeAGoodsName addObject:[NSNull null]];
//    [[Session sharedInstance].homeAGoodsId addObject:[NSNull null]];
//    [[Session sharedInstance].homeAGoodsImage addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_name addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_id addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_image addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_price addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_name addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_id addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_image addObject:[NSNull null]];
//    [[Session sharedInstance].homeBCell_price addObject:[NSNull null]];
//}

//本地数据获取
-(void)getLocalData
{
    //初始化
//    [self addDataNSMutableArray];
//    取出存储本地数据
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

    [Session sharedInstance].tierAList_name = [def objectForKey:@"tierAList_name"];
//    NSLog(@"====tierAList_name====%@",[Session sharedInstance].tierAList_name[1]);
    
    [Session sharedInstance].tierAList_cat_id = [def objectForKey:@"tierAList_cat_id"];
//    NSLog(@"====tierAList_name====%@",[Session sharedInstance].tierAList_cat_id);
    
    [Session sharedInstance].tierAList_parent_id = [def objectForKey:@"tierAList_parent_id"];
//    NSLog(@"====tierAList_name====%@",[Session sharedInstance].tierAList_parent_id);
    
    [Session sharedInstance].tierBList_cat_id = [def objectForKey:@"tierBList_cat_id"];
//    NSLog(@"====tierAList_name====%@",[Session sharedInstance].tierBList_cat_id);
    
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

    [Session sharedInstance].homeCCell_name = [def objectForKey:@"homeCCell_name"];
    
    [Session sharedInstance].homeCCell_id = [def objectForKey:@"homeCCell_id"];
    
    [Session sharedInstance].homeCCell_image = [def objectForKey:@"homeCCell_image"];
    
    [Session sharedInstance].homeCCell_price = [def objectForKey:@"homeCCell_price"];
    
    [Session sharedInstance].tierCList_Sn = [def objectForKey:@"tierCList_Sn"];
    
    [Session sharedInstance].homeAGoodsSn  = [def objectForKey:@"homeAGoodsSn"];
    
    [Session sharedInstance].homeAGoodsPrice  = [def objectForKey:@"homeAGoodsPrice"];
    
    [Session sharedInstance].homeBCell_sn  = [def objectForKey:@"homeBCell_sn"];
    
    [Session sharedInstance].homeCCell_sn  = [def objectForKey:@"homeCCell_sn"];
}

//数据持久化
-(void)dataBaseLoad
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"aspire" forKey:@"aspireNetWorkCheck"];
    //持久化保存数据
    if ([Session sharedInstance].tierAList_name.count > 0)
    {   
        [def setObject:[Session sharedInstance].tierAList_name forKey:@"tierAList_name"];
        [def setObject:[Session sharedInstance].tierAList_cat_id forKey:@"tierAList_cat_id"];
        [def setObject:[Session sharedInstance].tierAList_parent_id forKey:@"tierAList_parent_id"];
        [def setObject:[Session sharedInstance].tierBList_cat_id forKey:@"tierBList_cat_id"];
        [def setObject:[Session sharedInstance].tierBList_parent_id forKey:@"tierBList_parent_id"];
    }

    //持久化保存数据
    if ([Session sharedInstance].tierCList_Name.count > 0)
    {
        [def setObject:[Session sharedInstance].tierCList_Name forKey:@"tierCList_Name"];
        [def setObject:[Session sharedInstance].tierCList_catId forKey:@"tierCList_catId"];
        [def setObject:[Session sharedInstance].tierCList_Id forKey:@"tierCList_Id"];
        [def setObject:[Session sharedInstance].tierCList_Image forKey:@"tierCList_Image"];
        [def setObject:[Session sharedInstance].tierCList_Price forKey:@"tierCList_Price"];
        [def setObject:[Session sharedInstance].tierCList_Sn forKey:@"tierCList_Sn"];
    }
    
    
    
    //持久化保存数据
    if ([Session sharedInstance].homeAGoodsName.count > 0) {
        [def setObject:[Session sharedInstance].homeAGoodsName forKey:@"homeAGoodsName"];
        [def setObject:[Session sharedInstance].homeAGoodsId forKey:@"homeAGoodsId"];
        [def setObject:[Session sharedInstance].homeAGoodsImage forKey:@"homeAGoodsImage"];
        [def setObject:[Session sharedInstance].homeAGoodsSn forKey:@"homeAGoodsSn"];
        [def setObject:[Session sharedInstance].homeAGoodsPrice forKey:@"homeAGoodsPrice"];
    }
    
    
    //持久化保存数据
    if ([Session sharedInstance].homeBCell_name.count >0) {
        [def setObject:[Session sharedInstance].homeBCell_name forKey:@"homeBCell_name"];
        [def setObject:[Session sharedInstance].homeBCell_id forKey:@"homeBCell_id"];
        [def setObject:[Session sharedInstance].homeBCell_image forKey:@"homeBCell_image"];
        [def setObject:[Session sharedInstance].homeBCell_price forKey:@"homeBCell_price"];
        [def setObject:[Session sharedInstance].homeBCell_sn forKey:@"homeBCell_sn"];
    }
    
    //持久化保存数据
    if ([Session sharedInstance].homeCCell_name.count > 0) {
        [def setObject:[Session sharedInstance].homeCCell_name forKey:@"homeCCell_name"];
        [def setObject:[Session sharedInstance].homeCCell_id forKey:@"homeCCell_id"];
        [def setObject:[Session sharedInstance].homeCCell_image forKey:@"homeCCell_image"];
        [def setObject:[Session sharedInstance].homeCCell_price forKey:@"homeCCell_price"];
        [def setObject:[Session sharedInstance].homeCCell_sn forKey:@"homeCCell_sn"];
    }
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

//检测网络状态改变
-(void)timerFired
{
    NSLog(@"检测网络状态");
    if([self isConnectionAvailable])
    {
        //取消定时器
        [timer invalidate];
         timer = nil;
        //有网络数据开启线程初始化商品数据
        [self getNetWork];
        [self performSelector:@selector(getUIviews) withObject:nil afterDelay:2.0f];
    }
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
//             NSLog(@"返回的商品数据2-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0)
                 {
                     [Session sharedInstance].tierAList_name = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierAList_cat_id = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierAList_parent_id = [[NSMutableArray alloc] init];
                     
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
//             NSLog(@"返回的商品数据2222-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0)
                 {
                     [Session sharedInstance].tierCList_Name = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierCList_catId = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierCList_Id = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierCList_Image = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierCList_Price = [[NSMutableArray alloc] init];
                     [Session sharedInstance].tierCList_Sn = [[NSMutableArray alloc] init];
                     
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

-(void)getHomeACellData
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
//             NSLog(@"返回的商品数据2rrr-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list > 0)
                 {
                     [Session sharedInstance].homeAGoodsName = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeAGoodsId = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeAGoodsImage = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeAGoodsSn = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeAGoodsPrice = [[NSMutableArray alloc] init];

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
                         if (![image isEqualToString:@""] && image)
                         {
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

-(void)getHomeBCellData
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
//                     NSLog(@"返回的商品数据2BBBB-------->%@",message);
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0)
                 {
                     
                     [Session sharedInstance].homeBCell_name = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeBCell_id = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeBCell_image = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeBCell_price = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeBCell_sn = [[NSMutableArray alloc] init];
                     
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

-(void)getHomeCCellData
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
//             NSLog(@"返回的商品数据2-------->%@",message)
             NSDictionary *data = [StwClient jsonParsing:message];
             NSDictionary *datas = [data objectForKey:@"data"];
             NSString *check_code = [NSString stringWithFormat:@"%@",[data objectForKey:@"ret"]];
             if ([check_code isEqualToString:@"0"])
             {
                 NSArray *list = [datas objectForKey:@"list"];
                 if (list.count > 0)
                 {
                     [Session sharedInstance].homeCCell_name = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeCCell_id = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeCCell_image = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeCCell_price = [[NSMutableArray alloc] init];
                     [Session sharedInstance].homeCCell_sn = [[NSMutableArray alloc] init];
                     
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

-(void)getNetWork
{
    [self performSelectorInBackground:@selector(getGoodsAList) withObject:nil];
    [self performSelectorInBackground:@selector(getGoodsCList) withObject:nil];
    [self performSelectorInBackground:@selector(getHomeACellData) withObject:nil];
    [self performSelectorInBackground:@selector(getHomeBCellData) withObject:nil];
    [self performSelectorInBackground:@selector(getHomeCCellData) withObject:nil];
}

@end

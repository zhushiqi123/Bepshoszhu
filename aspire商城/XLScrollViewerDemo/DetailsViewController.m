//
//  DetailsViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsViewController.h"
#import "XLScrollViewer.h"
#import "DetailsAUIView.h"
#import "DetailsBUIView.h"
#import "DetailsCUIView.h"
#import "DetailsDUIView.h"
#import "shopCartViewController.h"
#import "Session.h"
#import "StwClient.h"
#import "ProgressHUD.h"
#import "StwClient.h"
#import "ShopCars.h"
#import "Reachability.h"
@interface DetailsViewController ()
{
    Details *detailsView;
}

@property (weak, nonatomic) IBOutlet UIButton *btn_share;
@property (weak, nonatomic) IBOutlet UIButton *addCar;
@property (weak, nonatomic) IBOutlet UITextField *goods_num;

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //导航栏个性化
//    //设置左边图片
//    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 115, 32)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageview];
//    imageview.image = [UIImage imageNamed:@"listviewitemimg"];
    
    //设置背景图片
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commonhead"]];
    
    self.goods_num.text = @"1";
    
//    //设置查询商品按钮
//    self.btn_findGoods.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_inport_normal"]];
    //设置分享按钮
    self.btn_share.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share"]];
    
    self.title =@"详情";
    self.addCar.layer.cornerRadius = 10;
    
    detailsView = [[Details alloc] init];

    [ProgressHUD show:nil];
    if ([self isConnectionAvailable] && [Session sharedInstance].details.goods_id > 0)
    {
        [StwClient getGoodsDetial];
        [self performSelector:@selector(addView) withObject:nil afterDelay:1.0f];
    }
    else
    {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"数据获取失败!请检查网络设置"];
    }
}

-(void)addView
{
    [ProgressHUD dismiss];
    if ([Session sharedInstance].details.goods_id < 1)
    {
        [ProgressHUD showError:@"网络连接失败"];
    }
    else
    {
        CGRect frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -(64+44));//如果没有导航栏，则去掉64 购物添加 44
        
        //对应填写两个数组
        NSArray *views =@[[DetailsAUIView new],[DetailsBUIView new],[DetailsCUIView new],[DetailsDUIView new]];
        NSArray *names =@[@"基本信息",@"图文描述",@"评价评论",@"相关产品"];
        //创建使用
        self.scroll =[XLScrollViewer scrollWithFrame:frame withViews:views withButtonNames:names withThreeAnimation:212];//三种动画都不选择
        
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
        
        //加入控制器视图
        [self.view addSubview:self.scroll];
    }
}

//减少
- (IBAction)onclickMinus:(id)sender
{
    NSLog(@"减少");
    int intString = [self.goods_num.text intValue];
    if(intString == 1)
    {
        intString = 2;
    }
    self.goods_num.text = [NSString stringWithFormat:@"%d",--intString];
}

//增加
- (IBAction)onclickPlus:(id)sender {
    NSLog(@"增加");
    int intString = [self.goods_num.text intValue];
    self.goods_num.text = [NSString stringWithFormat:@"%d",++intString];
}

//添加购物车
- (IBAction)onclickAddCar:(id)sender
{
    NSLog(@"添加到购物车");
    if ([self.goods_num.text isEqualToString:@"0"])
    {
        self.goods_num.text = @"1";
    }
    ShopCars *shopCar = [[ShopCars alloc] init];
    shopCar.num = [self.goods_num.text intValue];
    shopCar.goods_name = [Session sharedInstance].details_name;
    
    if ([Session sharedInstance].details_typeListB.count > 0)
    {
        int num = [Session sharedInstance].details_typeListB_num;
        if (shopCar.attribute_id)
        {
            shopCar.attribute_id = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_id,[Session sharedInstance].details_typeListB_attrId[num]];
            shopCar.attribute_price = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_price,[Session sharedInstance].details_typeListB_attrPrice[num]];
        }
        else
        {
            shopCar.attribute_id = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListB_attrId[num]];
            shopCar.attribute_price = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListB_attrPrice[num]];
        }
    }
    if ([Session sharedInstance].details_typeListC.count > 0)
    {
        if (shopCar.attribute_id)
        {
            int num = [Session sharedInstance].details_typeListC_num;
            shopCar.attribute_id = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_id,[Session sharedInstance].details_typeListC_attrId[num]];
            shopCar.attribute_price = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_price,[Session sharedInstance].details_typeListC_attrPrice[num]];
        }
        else
        {
            int num = [Session sharedInstance].details_typeListC_num;
            shopCar.attribute_id = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListC_attrId[num]];
            shopCar.attribute_price = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListC_attrPrice[num]];
        }
    }
    if ([Session sharedInstance].details_typeListD.count > 0)
    {
        for (int i = 0;i < [Session sharedInstance].details_typeListD.count; i++)
        {
            if (shopCar.attribute_id)
            {
                shopCar.attribute_id = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_id,[Session sharedInstance].details_typeListD_attrId[i]];
                shopCar.attribute_price = [NSString stringWithFormat:@"%@,%@",shopCar.attribute_price,[Session sharedInstance].details_typeListD_attrPrice[i]];
            }
            else
            {
                shopCar.attribute_id = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListD_attrId[i]];
                shopCar.attribute_price = [NSString stringWithFormat:@"%@",[Session sharedInstance].details_typeListD_attrPrice[i]];
            }
        }
    }
    
    shopCar.attribute_price = [shopCar.attribute_price stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    //取出价格
    NSArray *array = [shopCar.attribute_price componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
    float pricess = 0;
    for (int i = 0; i < array.count ; i++)
    {
//        NSLog(@"shopCar id-->%f",[array[i] floatValue]);
        pricess = pricess + [array[i] floatValue];
    }

    if(!shopCar.attribute_price)
    {
        shopCar.attribute_id = @"";
        shopCar.attribute_price = @"";
    }
    NSLog(@"shopCar id---->%@",shopCar.attribute_id);
    NSLog(@"shopCar id---->%@",shopCar.attribute_price);
    NSLog(@"shopCar id---->%.2f",pricess);

    if (shopCar.goods_name)
    {
        shopCar.price = [Session sharedInstance].homeACell_price;
        shopCar.goods_id = [Session sharedInstance].details.goods_id;
        float good_price = [shopCar.price floatValue];
        shopCar.allPrices = [NSString stringWithFormat:@"%.2f",shopCar.num * (good_price + pricess)];
        NSLog(@"goods====>%@",shopCar.allPrices);
        
        NSDictionary *shopCarData = [StwClient getObjectData:shopCar];
        
        [[Session sharedInstance].shopCarss addObject:shopCarData];
        NSLog(@"[Session sharedInstance].shopCarss%@",[Session sharedInstance].shopCarss);
        //本地化存储购物车数据
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[Session sharedInstance].shopCarss forKey:@"data_shopCarss"];
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

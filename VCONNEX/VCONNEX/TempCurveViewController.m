//
//  TempCurveViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TempCurveViewController.h"
#import "STW_BLE_SDK.h"
#import "CCTPoint.h"
#import "UIView+MJAlertView.h"

#import "SaveTabBarView.h"
#import "TempCurveTitleView.h"
#import "CurveChartBGXIBView.h"


@interface TempCurveViewController ()

@end

@implementation TempCurveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Temperature curve";
    
    //设置标题 Position
    [self addTitleView];
    //添加图表部分头部
    [self addCurveChartTitleTop];
    //添加图表部分底部
    [self addCurveChartTitleEnd];
    //保存视图
    [self addSaveView];
    //X轴视图
    [self addCurveChart_x];
    //Y轴视图
    [self addCurveChart_y];
    //手动画曲线部分
    [self addCurveChart];
}

//添加头部
-(void)addTitleView
{
    TempCurveTitleView *tempCurveTitleXIB = [[[NSBundle mainBundle]loadNibNamed:@"TempCurveTitleView" owner:self options:nil]lastObject];
    CGRect tempCurveTitleView_Frame = tempCurveTitleXIB.frame;
    
    tempCurveTitleView_Frame.origin.x = 50.0f;
    tempCurveTitleView_Frame.origin.y = 10.0f + 64.0f;
    
    tempCurveTitleView_Frame.size.width = SCREEN_WIDTH - 100.0f;
    tempCurveTitleView_Frame.size.height = 44.0f;
    
    tempCurveTitleXIB.frame = tempCurveTitleView_Frame;
    
    [self.view addSubview:tempCurveTitleXIB];
    
    _tempCurveTitleView = tempCurveTitleXIB;
}

//添加图表部分头部
-(void)addCurveChartTitleTop
{
    UILabel *titleTop = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, (10.0f + 64.0f + 44.0f), SCREEN_WIDTH - 20, 20)];
    titleTop.text = @"Temperature percent(%)";
    [titleTop setFont:[UIFont systemFontOfSize:14]];
    titleTop.textColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
    titleTop.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleTop];
}

//添加图表部分x
-(void)addCurveChart_x
{
//    float drawing_width = SCREEN_WIDTH - 30.0f - 20.0f;
    float drawing_height = SCREEN_HEIGHT - (10.0f + 64.0f + 44.0f + 20.0f + 60.0f + 30.0f + 20.0f) - 10.0f;
    
//    int box_widh_x = (drawing_width - 10) / 10;
    int box_height_y = (drawing_height - 10) / 20;
    
    float box_width = 30.0f;
    float box_height = 20.0f;
    
    float box_y = (10.0f + 64.0f + 44.0f + 20.0f) + 10.0f;
    
    for (int i = 0; i < 5; i++)
    {
        //Lable- 80
        UILabel *lable_x = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, box_width, box_height)];
        
        lable_x.center = CGPointMake(15.0f, box_y + (drawing_height - 10.f) - (box_height_y * (2 + i * 4)));
        
        lable_x.text = [NSString stringWithFormat:@"%d",(-80 + (i * 40))];
        
        lable_x.textColor = RGBCOLOR(0x74, 0x74, 0x74);
        [lable_x setFont:[UIFont systemFontOfSize:15.0f]];
        [lable_x setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:lable_x];
    }
}

//添加图表部分x
-(void)addCurveChart_y
{
    float height_y = (SCREEN_HEIGHT - 60.0f - 30.0f - 20.0f);
    
    float box_width = 30.0f;
    float box_height = 20.0f;
    
    float drawing_width = SCREEN_WIDTH - 30.0f - 20.0f;
    
    int box_widh_x = (drawing_width - 10) / 10;

    for (int i = 0; i < 3; i++)
    {
        UILabel *lable_y = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, box_width, box_height)];
        
        lable_y.center = CGPointMake(30.0f + (box_widh_x * i * 5) + 10.f, height_y + 10.0f);
        
        lable_y.text = [NSString stringWithFormat:@"%d.0",(0 + (i * 5))];
        
        lable_y.textColor = RGBCOLOR(0x74, 0x74, 0x74);
        
        [lable_y setFont:[UIFont systemFontOfSize:15.0f]];
        
        [lable_y setTextAlignment:NSTextAlignmentCenter];
        
        [self.view addSubview:lable_y];
    }
    
}

//添加图表部分  #dbf0f0  淡绿色  #00bea4  蓝色数据点   #747474  坐标轴灰色   #f4f4f4  虚线白色
-(void)addCurveChart
{
    float drawing_width = SCREEN_WIDTH - 30.0f - 20.0f;
    float drawing_height = SCREEN_HEIGHT - (10.0f + 64.0f + 44.0f + 20.0f + 60.0f + 30.0f + 20.0f) - 10.0f;
    
    float drawing_x = 30.0f;
    float drawing_y = (10.0f + 64.0f + 44.0f + 20.0f) + 10.0f;
    
    int box_widh_x = (drawing_width - 10) / 10;
    int box_height_y = (drawing_height - 10) / 20;
    
    //绘制背景颜色
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(drawing_x + 12.0f, drawing_y - 5.0f,box_widh_x * 10 + 10.f,drawing_height - 5.0f)];
    bgview.backgroundColor = RGBCOLOR(0xdb, 0xf0, 0xf0);
    [self.view addSubview:bgview];
    
    NSMutableArray *arrys = [NSMutableArray array];
    
//    NSLog(@"[STW_BLE_SDK STW_SDK].cctArrys.count - %d",(int)[STW_BLE_SDK STW_SDK].cctArrys.count);
    
    if ([STW_BLE_SDK STW_SDK].cctArrys.count == 11)
    {
        CCTPoint *point01 = [[STW_BLE_SDK STW_SDK].cctArrys objectAtIndex:5];
        
        [self SetCCTCurveDataBackfreshUI:5 :20 - point01.point_y];
        
        arrys = [STW_BLE_SDK STW_SDK].cctArrys;
    }
 
    CGRect framebg = CGRectMake(drawing_x,drawing_y - 5.0f,drawing_width + 10.0f,drawing_height + 5.0f);
    
    CurveChartBGXIBView *curveChartBGXIB = [[CurveChartBGXIBView alloc]initWithFrame:framebg :box_widh_x :box_height_y :5 :arrys];
    
    //设置回调
    curveChartBGXIB.CCTCurveData = ^(int CCT_x,int CCT_y)
    {
        [self SetCCTCurveDataBackfreshUI:CCT_x :CCT_y];
    };
    
    [self.view addSubview:curveChartBGXIB];
    
    _curveChartBGView = curveChartBGXIB;
}

-(void)SetCCTCurveDataBackfreshUI:(int)CCT_x  :(int)CCT_y
{
    _tempCurveTitleView.lable_position.text = [NSString stringWithFormat:@"Position:%ds",CCT_x];
    _tempCurveTitleView.lable_data.text = [NSString stringWithFormat:@"%d%%",(10 - CCT_y)*10];
}

//添加图表部分底部
-(void)addCurveChartTitleEnd
{
    UILabel *titleEnd = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, (SCREEN_HEIGHT - 60.0f - 30.0f), SCREEN_WIDTH - 20, 20)];
    titleEnd.text = @"Time(s)";
    [titleEnd setFont:[UIFont systemFontOfSize:14]];
    titleEnd.textColor = RGBCOLOR(0x9d, 0x9d, 0x9d);
    [titleEnd setTextAlignment:NSTextAlignmentRight];
    titleEnd.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleEnd];
}

//添加底部保存按钮
-(void)addSaveView
{
    SaveTabBarView *saveTabtarView = [[[NSBundle mainBundle]loadNibNamed:@"SaveTabBarView" owner:self options:nil]lastObject];
    CGRect saveTabtarView_Frame = saveTabtarView.frame;
    
    saveTabtarView_Frame.origin.x = 0;
    saveTabtarView_Frame.origin.y = SCREEN_HEIGHT - 60.0f;
    
    saveTabtarView_Frame.size.width = SCREEN_WIDTH;
    saveTabtarView_Frame.size.height = 60.0f;
    
    saveTabtarView.frame = saveTabtarView_Frame;
    
    //设置按钮的圆角半径不会被遮挡
    [saveTabtarView.btn_default.layer setMasksToBounds:YES];
    [saveTabtarView.btn_default.layer setCornerRadius:4];
    
    //设置按钮的圆角半径不会被遮挡
    [saveTabtarView.btn_last.layer setMasksToBounds:YES];
    [saveTabtarView.btn_last.layer setCornerRadius:4];
    
    //设置按钮的圆角半径不会被遮挡
    [saveTabtarView.btn_save.layer setMasksToBounds:YES];
    [saveTabtarView.btn_save.layer setCornerRadius:4];
    
    //设置边界的宽度
    [saveTabtarView.btn_default.layer setBorderWidth:1];
    [saveTabtarView.btn_default.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //设置边界的宽度
    [saveTabtarView.btn_last.layer setBorderWidth:1];
    [saveTabtarView.btn_last.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //设置边界的宽度
    [saveTabtarView.btn_save.layer setBorderWidth:1];
    [saveTabtarView.btn_save.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //添加按钮点击事件
    [saveTabtarView.btn_default addTarget:self action:@selector(onClick_btn_default) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮点击事件
    [saveTabtarView.btn_last addTarget:self action:@selector(onClick_btn_last) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮点击事件
    [saveTabtarView.btn_save addTarget:self action:@selector(onClick_btn_save) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveTabtarView];
}

//默认事件
-(void)onClick_btn_default
{
    //默认数值
    [STW_BLE_SDK STW_SDK].cctArrys = [NSMutableArray array];
    
    [UIView addMJNotifierWithText:@"Default" dismissAutomatically:YES];
    
    for (int i = 0; i < 11; i++)
    {
        CCTPoint *chosePoint = [[CCTPoint alloc]init];
        
        chosePoint.point_x = i;
        
        chosePoint.point_y = 10;
        
        [[STW_BLE_SDK STW_SDK].cctArrys addObject:chosePoint];
    }
    
    [self SetCCTCurveDataBackfreshUI:5 :10];
    
    [_curveChartBGView refreshUI:5 :[STW_BLE_SDK STW_SDK].cctArrys];
}

//上一步事件
-(void)onClick_btn_last
{
    //进行查询
    [STW_BLE_Protocol the_find_CCTData];
    [UIView addMJNotifierWithText:@"Last" dismissAutomatically:YES];
    //注册回调
    [self the_find_CCTData_back_02];
}

-(void)the_find_CCTData_back_02
{
    [STW_BLEService sharedInstance].Service_CCTData = ^(NSMutableArray *CCTArrys)
    {
        if (CCTArrys.count == 11)
        {
            [STW_BLE_SDK STW_SDK].cctArrys = [NSMutableArray array];
            
            [STW_BLE_SDK STW_SDK].cctArrys = CCTArrys;
            
            CCTPoint *point01 = [[STW_BLE_SDK STW_SDK].cctArrys objectAtIndex:5];
            
            [self SetCCTCurveDataBackfreshUI:5 :20 - point01.point_y];
            
            [_curveChartBGView refreshUI:5 :[STW_BLE_SDK STW_SDK].cctArrys];
        }
        else
        {
            [UIView addMJNotifierWithText:@"Save Success" dismissAutomatically:YES];
        }
    };
}

//保存事件
-(void)onClick_btn_save
{
    //设置数据
    [STW_BLE_Protocol the_set_CCTData:_curveChartBGView.getCCTData];
    //注册回调
    [self the_find_CCTData_back_02];
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

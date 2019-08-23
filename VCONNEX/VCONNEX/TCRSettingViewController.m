//
//  TCRSettingViewController.m
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/19.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "TCRSettingViewController.h"
#import "STW_BLE_SDK.h"
#import "UIView+MJAlertView.h"

#import "TCRTitleView.h"
#import "TCRDataView.h"
#import "SaveTabBarView.h"

#define Times_Btn 0.2f

@interface TCRSettingViewController ()
{
    int RateChange_01;
    int RateChange_02;
    int RateChange_03;
    int RateChange_04;
    
    NSTimer *bianhuaTimer;
}

@end

@implementation TCRSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Temperature coefficient";
    
    bianhuaTimer = [[NSTimer alloc]init];
    
    if ([STW_BLE_SDK STW_SDK].tcrArrys.count == 4)
    {
        RateChange_01 = [[[STW_BLE_SDK STW_SDK].tcrArrys objectAtIndex:0] intValue];
        RateChange_02 = [[[STW_BLE_SDK STW_SDK].tcrArrys objectAtIndex:1] intValue];
        RateChange_03 = [[[STW_BLE_SDK STW_SDK].tcrArrys objectAtIndex:2] intValue];
        RateChange_04 = [[[STW_BLE_SDK STW_SDK].tcrArrys objectAtIndex:3] intValue];
    }
    else
    {
        RateChange_01 = 65;
        RateChange_02 = 15;
        RateChange_03 = 45;
        RateChange_04 = 45;
    }

    //添加列表头部信息
    [self addLableTitle];
    //添加列表数据部分
    [self addLableData];
    //添加底部保存视图
    [self addSaveView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //注册回调
    [self the_find_atomizer_back];
}

//添加列表标题
-(void)addLableTitle
{
    TCRTitleView *tcrTitleView = [[[NSBundle mainBundle]loadNibNamed:@"TCRTitleView" owner:self options:nil]lastObject];
    CGRect tcrTitleView_Frame = tcrTitleView.frame;
    
    tcrTitleView_Frame.origin.x = 8.0f;
    tcrTitleView_Frame.origin.y = 8.0f + 64.0f;
    
    tcrTitleView_Frame.size.width = SCREEN_WIDTH - 16.0f;
    tcrTitleView_Frame.size.height = 44.0f;
    
    tcrTitleView.frame = tcrTitleView_Frame;
    
//    tcrTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tcrTitleView];
}

//添加数据部分
-(void)addLableData
{
    /*-------------------------Ni200-----------------------------*/
    TCRDataView *tcrDataView01 = [[[NSBundle mainBundle]loadNibNamed:@"TCRDataView" owner:self options:nil]lastObject];
    CGRect tcrDataView_Frame01 = tcrDataView01.frame;
    
    tcrDataView_Frame01.origin.x = 8.0f;
    tcrDataView_Frame01.origin.y = 44.0f + 8.0f  + 64.0f;
    
    tcrDataView_Frame01.size.width = SCREEN_WIDTH - 16;
    tcrDataView_Frame01.size.height = 44.0f;
    
    tcrDataView01.frame = tcrDataView_Frame01;
    
    tcrDataView01.lable_type.text = @"Ni200";
    
    [self.view addSubview:tcrDataView01];
    
    /*-------------------------Ss316-----------------------------*/
    TCRDataView *tcrDataView02 = [[[NSBundle mainBundle]loadNibNamed:@"TCRDataView" owner:self options:nil]lastObject];
    CGRect tcrDataView_Frame02 = tcrDataView02.frame;
    
    tcrDataView_Frame02.origin.x = 8.0f;
    tcrDataView_Frame02.origin.y = 44.0f + 8.0f  + 64.0f + 44.0f;
    
    tcrDataView_Frame02.size.width = SCREEN_WIDTH - 16;
    tcrDataView_Frame02.size.height = 44.0f;
    
    tcrDataView02.frame = tcrDataView_Frame02;
    
    tcrDataView02.lable_type.text = @"Ss316";
    
    [self.view addSubview:tcrDataView02];
    
    /*-------------------------Ti-----------------------------*/
    TCRDataView *tcrDataView03 = [[[NSBundle mainBundle]loadNibNamed:@"TCRDataView" owner:self options:nil]lastObject];
    CGRect tcrDataView_Frame03 = tcrDataView03.frame;
    
    tcrDataView_Frame03.origin.x = 8.0f;
    tcrDataView_Frame03.origin.y = 44.0f + 8.0f  + 64.0f  + 44.0f  + 44.0f;
    
    tcrDataView_Frame03.size.width = SCREEN_WIDTH - 16;
    tcrDataView_Frame03.size.height = 44.0f;
    
    tcrDataView03.frame = tcrDataView_Frame03;
    
    tcrDataView03.lable_type.text = @"Ti";
    
    [self.view addSubview:tcrDataView03];

    /*-------------------------TCR-----------------------------*/
    TCRDataView *tcrDataView04 = [[[NSBundle mainBundle]loadNibNamed:@"TCRDataView" owner:self options:nil]lastObject];
    CGRect tcrDataView_Frame04 = tcrDataView04.frame;
    
    tcrDataView_Frame04.origin.x = 8.0f;
    tcrDataView_Frame04.origin.y = 44.0f + 8.0f  + 64.0f  + 44.0f + 44.0f + 44.0f;
    
    tcrDataView_Frame04.size.width = SCREEN_WIDTH - 16;
    tcrDataView_Frame04.size.height = 44.0f;
    
    tcrDataView04.frame = tcrDataView_Frame04;
    
    tcrDataView04.lable_type.text = @"TCR";
    
    [self.view addSubview:tcrDataView04];
    
    self.tcrDataViewCell01 = tcrDataView01;
    self.tcrDataViewCell02 = tcrDataView02;
    self.tcrDataViewCell03 = tcrDataView03;
    self.tcrDataViewCell04 = tcrDataView04;
    
    [self refreshUI:RateChange_01 :RateChange_02 :RateChange_03 :RateChange_04];
    
    /*--------------------添加点击事件--------------------*/
    //Ni +按钮
    [self.tcrDataViewCell01.btn_add addTarget:self action:@selector(NiAdd00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell01.btn_add addTarget:self action:@selector(NiAdd01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell01.btn_add addTarget:self action:@selector(NiAdd01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Ni -按钮
    [self.tcrDataViewCell01.btn_low addTarget:self action:@selector(NiLow00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell01.btn_low addTarget:self action:@selector(NiLow01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell01.btn_low addTarget:self action:@selector(NiLow01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Ss +按钮
    [self.tcrDataViewCell02.btn_add addTarget:self action:@selector(SsAdd00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell02.btn_add addTarget:self action:@selector(SsAdd01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell02.btn_add addTarget:self action:@selector(SsAdd01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Ss -按钮
    [self.tcrDataViewCell02.btn_low addTarget:self action:@selector(SsLow00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell02.btn_low addTarget:self action:@selector(SsLow01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell02.btn_low addTarget:self action:@selector(SsLow01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Ti +按钮
    [self.tcrDataViewCell03.btn_add addTarget:self action:@selector(TiAdd00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell03.btn_add addTarget:self action:@selector(TiAdd01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell03.btn_add addTarget:self action:@selector(TiAdd01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Ti -按钮
    [self.tcrDataViewCell03.btn_low addTarget:self action:@selector(TiLow00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell03.btn_low addTarget:self action:@selector(TiLow01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell03.btn_low addTarget:self action:@selector(TiLow01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Tcr +按钮
    [self.tcrDataViewCell04.btn_add addTarget:self action:@selector(TcrAdd00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell04.btn_add addTarget:self action:@selector(TcrAdd01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell04.btn_add addTarget:self action:@selector(TcrAdd01) forControlEvents:UIControlEventTouchDragOutside];
    
    //Tcr -按钮
    [self.tcrDataViewCell04.btn_low addTarget:self action:@selector(TcrLow00) forControlEvents:UIControlEventTouchDown];
    [self.tcrDataViewCell04.btn_low addTarget:self action:@selector(TcrLow01) forControlEvents:UIControlEventTouchUpInside];
    [self.tcrDataViewCell04.btn_low addTarget:self action:@selector(TcrLow01) forControlEvents:UIControlEventTouchDragOutside];
    
    /*--------------------添加修改事件--------------------*/
    [self.tcrDataViewCell01.text_Coefficient addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tcrDataViewCell02.text_Coefficient addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tcrDataViewCell03.text_Coefficient addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tcrDataViewCell04.text_Coefficient addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    
    /*--------------------添加修改结束事件--------------------*/
    [self.tcrDataViewCell01.text_Coefficient addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tcrDataViewCell02.text_Coefficient addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tcrDataViewCell03.text_Coefficient addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.tcrDataViewCell04.text_Coefficient addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
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
    
    [self.view addSubview:saveTabtarView];
    
    //添加按钮点击事件
    [saveTabtarView.btn_default addTarget:self action:@selector(onClick_btn_default) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮点击事件
    [saveTabtarView.btn_last addTarget:self action:@selector(onClick_btn_last) forControlEvents:UIControlEventTouchUpInside];
    //添加按钮点击事件
    [saveTabtarView.btn_save addTarget:self action:@selector(onClick_btn_save) forControlEvents:UIControlEventTouchUpInside];
}

//默认事件
-(void)onClick_btn_default
{
    RateChange_01 = 65;
    RateChange_02 = 15;
    RateChange_03 = 45;
    RateChange_04 = 45;
    
    [UIView addMJNotifierWithText:@"Default" dismissAutomatically:YES];
    
    //默认数值
    [self refreshUI:RateChange_01 :RateChange_02 :RateChange_03 :RateChange_04];
}

//上一步事件
-(void)onClick_btn_last
{
    [UIView addMJNotifierWithText:@"Last" dismissAutomatically:YES];
    //进行查询
    [STW_BLE_Protocol the_find_atomizer];
}

//保存事件
-(void)onClick_btn_save
{
    //发送数据
    [STW_BLE_Protocol the_set_atomizer:RateChange_01 :RateChange_02 :RateChange_03 :RateChange_04];
}

//查询TCR回调
-(void)the_find_atomizer_back
{
    [STW_BLEService sharedInstance].Service_TCRData = ^(int ChangeRate_Ni,int ChangeRate_Ss,int ChangeRate_Ti,int ChangeRate_TCR)
    {
        if (ChangeRate_Ni == -1 && ChangeRate_Ss == -1 && ChangeRate_Ti == -1 && ChangeRate_TCR == -1)
        {
            [UIView addMJNotifierWithText:@"Save Success" dismissAutomatically:YES];
        }
        else
        {
            [STW_BLE_SDK STW_SDK].tcrArrys = [NSMutableArray array];
            
            [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ni]];
            [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ss]];
            [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_Ti]];
            [[STW_BLE_SDK STW_SDK].tcrArrys addObject:[NSString stringWithFormat:@"%d",ChangeRate_TCR]];
            
            RateChange_01 = ChangeRate_Ni;
            RateChange_02 = ChangeRate_Ss;
            RateChange_03 = ChangeRate_Ti;
            RateChange_04 = ChangeRate_TCR;
            //默认数值
            [self refreshUI:RateChange_01 :RateChange_02 :RateChange_03 :RateChange_04];
        }
    };
}

//刷新UI
-(void)refreshUI:(int)RateChange01 :(int)RateChange02  :(int)RateChange03  :(int)RateChange04
{
    self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange01/10000.0f];
    self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange02/10000.0f];
    self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange03/10000.0f];
    self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange04/10000.0f];
}

//Ni Add 00
-(void)NiAdd00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self NiAdd00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(NiAdd00Fun) userInfo:nil repeats:YES];
}

//Ni Add 01
-(void)NiAdd01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ni Low 00
-(void)NiLow00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    [self NiLow00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(NiLow00Fun) userInfo:nil repeats:YES];
}

//Ni Low 01
-(void)NiLow01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ss Add 00
-(void)SsAdd00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self SsAdd00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(SsAdd00Fun) userInfo:nil repeats:YES];
}

//Ss Add 01
-(void)SsAdd01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ss Low 00
-(void)SsLow00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self SsLow00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(SsLow00Fun) userInfo:nil repeats:YES];
}

//Ss Low 01
-(void)SsLow01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ti Add 00
-(void)TiAdd00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self TiAdd00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(TiAdd00Fun) userInfo:nil repeats:YES];
}

//Ti Add 01
-(void)TiAdd01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ti Low 00
-(void)TiLow00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self TiLow00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(TiLow00Fun) userInfo:nil repeats:YES];
}

//Ti Low 01
-(void)TiLow01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Tcr Add 00
-(void)TcrAdd00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self TcrAdd00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(TcrAdd00Fun) userInfo:nil repeats:YES];
}

//Tcr Add 01
-(void)TcrAdd01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Tcr Low 00
-(void)TcrLow00
{
    if (bianhuaTimer)
    {
        [bianhuaTimer invalidate];
        bianhuaTimer = nil;
    }
    
    [self TcrLow00Fun];
    bianhuaTimer = [NSTimer scheduledTimerWithTimeInterval:Times_Btn target:self selector:@selector(TcrLow00Fun) userInfo:nil repeats:YES];
}

//Tcr Low 01
-(void)TcrLow01
{
    [bianhuaTimer invalidate];
    bianhuaTimer = nil;
}

//Ni增加
-(void)NiAdd00Fun
{
    int nums1 = RateChange_01;
    
    if (nums1 >= 0 && nums1 < 10000)
    {
        self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 + 1)/10000.0f];
        RateChange_01 = nums1 + 1;
    }
}

//Ni减小
-(void)NiLow00Fun
{
    int nums1 = RateChange_01;
    
    if (nums1 > 0 && nums1 <= 10000)
    {
        self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 - 1)/10000.0f];
        RateChange_01 = nums1 - 1;
    }
}

//Ss增加
-(void)SsAdd00Fun
{
    int nums1 = RateChange_02;
    
    if (nums1 >= 0 && nums1 < 10000)
    {
        self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 + 1)/10000.0f];
        RateChange_02 = nums1 + 1;
    }
}

//Ss减小
-(void)SsLow00Fun
{
    int nums1 = RateChange_02;
    
    if (nums1 > 0 && nums1 <= 10000)
    {
        self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 - 1)/10000.0f];
        RateChange_02 = nums1 - 1;
    }
}

//Ti增加
-(void)TiAdd00Fun
{
    int nums1 = RateChange_03;
    
    if (nums1 >= 0 && nums1 < 10000)
    {
        self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 + 1)/10000.0f];
        RateChange_03 = nums1 + 1;
    }
}

//Ti减小
-(void)TiLow00Fun
{
    int nums1 = RateChange_03;
    
    if (nums1 > 0 && nums1 <= 10000)
    {
        self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 - 1)/10000.0f];
        RateChange_03 = nums1 - 1;
    }
}

//Tcr增加
-(void)TcrAdd00Fun
{
    int nums1 = RateChange_04;
    
    if (nums1 >= 0 && nums1 < 10000)
    {
        self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 + 1)/10000.0f];
        RateChange_04 = nums1 + 1;
    }
}

//Tcr减小
-(void)TcrLow00Fun
{
    int nums1 = RateChange_04;
    
    if (nums1 > 0 && nums1 <= 10000)
    {
        self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",(nums1 - 1)/10000.0f];
        RateChange_04 = nums1 - 1;
    }
}

//输入框正在改变
- (void)tfChange:(UITextField *)sender
{
    if ([sender isEqual:self.tcrDataViewCell01.text_Coefficient])
    {
        if ([self.tcrDataViewCell01.text_Coefficient.text isEqualToString:@""])
        {
            RateChange_01 = 0;
            self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_01/10000.0f];
        }
        else
        {
            float nus01 = [self.tcrDataViewCell01.text_Coefficient.text floatValue];
            
            if (nus01 > 1)
            {
                RateChange_01 = 10000;
                self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_01/10000.0f];
            }
            else
            {
                RateChange_01 = nus01 * 10000;
                
                if (self.tcrDataViewCell01.text_Coefficient.text.length > 6)
                {
                    self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_01/10000.0f];
                }
            }
        }
    }
    else if ([sender isEqual:self.tcrDataViewCell02.text_Coefficient])
    {
        if ([self.tcrDataViewCell02.text_Coefficient.text isEqualToString:@""])
        {
            RateChange_02 = 0;
            self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_02/10000.0f];
        }
        else
        {
            float nus02 = [self.tcrDataViewCell02.text_Coefficient.text floatValue];
            
            if (nus02 > 1)
            {
                RateChange_02 = 10000;
                self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_02/10000.0f];
            }
            else
            {
                RateChange_02 = nus02 * 10000;
                
                if (self.tcrDataViewCell02.text_Coefficient.text.length > 6)
                {
                    self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_02/10000.0f];
                }
            }
        }
    }
    else if ([sender isEqual:self.tcrDataViewCell03.text_Coefficient])
    {
        if ([self.tcrDataViewCell03.text_Coefficient.text isEqualToString:@""])
        {
            RateChange_03 = 0;
            self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_03/10000.0f];
        }
        else
        {
            float nus03 = [self.tcrDataViewCell03.text_Coefficient.text floatValue];
            
            if (nus03 > 1)
            {
                RateChange_03 = 10000;
                self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_03/10000.0f];
            }
            else
            {
                RateChange_03 = nus03 * 10000;
                
                if (self.tcrDataViewCell03.text_Coefficient.text.length > 6)
                {
                    self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_03/10000.0f];
                }
            }
        }
    }
    else if ([sender isEqual:self.tcrDataViewCell04.text_Coefficient])
    {
        if ([self.tcrDataViewCell04.text_Coefficient.text isEqualToString:@""])
        {
            RateChange_04 = 0;
            self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_04/10000.0f];
        }
        else
        {
            float nus04 = [self.tcrDataViewCell04.text_Coefficient.text floatValue];
            
            if (nus04 > 1)
            {
                RateChange_04 = 10000;
                self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_04/10000.0f];
            }
            else
            {
                RateChange_04 = nus04 * 10000;
                
                if (self.tcrDataViewCell04.text_Coefficient.text.length > 6)
                {
                    self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_04/10000.0f];
                }
            }
        }
    }
}

//输入框结束改变
- (void)tfEnd:(UITextField *)sender
{
    if ([sender isEqual:self.tcrDataViewCell01.text_Coefficient])
    {
        self.tcrDataViewCell01.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_01/10000.0f];
    }
    else if ([sender isEqual:self.tcrDataViewCell02.text_Coefficient])
    {
        self.tcrDataViewCell02.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_02/10000.0f];
    }
    else if ([sender isEqual:self.tcrDataViewCell03.text_Coefficient])
    {
        self.tcrDataViewCell03.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_03/10000.0f];
    }
    else if ([sender isEqual:self.tcrDataViewCell04.text_Coefficient])
    {
        self.tcrDataViewCell04.text_Coefficient.text = [NSString stringWithFormat:@"%.4f",RateChange_04/10000.0f];
    }
}

//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.tcrDataViewCell01.text_Coefficient resignFirstResponder];
    [self.tcrDataViewCell02.text_Coefficient resignFirstResponder];
    [self.tcrDataViewCell03.text_Coefficient resignFirstResponder];
    [self.tcrDataViewCell04.text_Coefficient resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
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

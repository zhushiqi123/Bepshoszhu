//
//  HomeViewController.m
//  PAX3
//
//  Created by tyz on 17/5/3.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeLeftViewController.h"
#import "CLPresent.h"
#import "HXCardSwitchView.h"
#import "BLEHomeViewController.h"
#import "STW_BLE.h"
#import "STW_Data_Plist.h"
#import "STW_PAXChooseViewModel.h"
#import "AlertViewNewAtomizer.h"
#import "ChooseViewController.h"

@interface HomeViewController ()
{
    int index_path_row;
    
    BOOL Modal_status;
    
    //是否已经进入侧边栏
    BOOL scan_bool;
    
    //提示是否是新的雾化器
    AlertViewNewAtomizer* alertViewDeleteDevice;
}

//滚动视图
@property (nonatomic,strong) HXCardSwitchView *cardSwitchView;
//设备列表
@property (nonatomic,strong) NSMutableArray *dicAry;

//蓝牙扫描时间控制
@property (strong, nonatomic) NSTimer *scan_timer;
//需要删除的列表
@property (nonatomic,assign) int delect_nums;
//是否弹出删除界面
@property (nonatomic,assign) Boolean delect_device_bool;

@end

@implementation HomeViewController

//页面即将出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([STW_BLE_SDK sharedInstance].stw_isBLEType == STW_BLE_IsBLETypeOff)
    {
        //开始动画
        if(_scan_timer)
        {
            [_scan_timer invalidate];
            _scan_timer = nil;
        }
        
        //主动延时
        double delayInSeconds = 1.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           //延时方法
                           [self scan_timer_func];
                           //4秒之后再次执行
                           _scan_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scan_timer_func) userInfo:nil repeats:YES];
                       });
    }
}

//页面即将隐藏
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //结束动画
    if(_scan_timer)
    {
        [_scan_timer invalidate];
        _scan_timer=nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _delect_device_bool = YES;
    
    //初始化时间
    _scan_timer = nil;
    Modal_status = NO;
    scan_bool = NO;
    // Do any additional setup after loading the view.
    //注册接收数据的回调
    [self scanDeviceListen];
    
    //初始化页面
    self->index_path_row = 0;

    //从数据库读取已经绑定设备的数据
    _dicAry = [self getDeviceArry];

    //滑动视图
    [self addFelicityView];
}

-(void)scanDeviceListen
{
    //扫描到蓝牙设备的回调
    [STW_BLE_SDK sharedInstance].BLEServiceScanHandler = ^(STW_BLE_Device *device)
    {
        //        NSLog(@"device - %@",device.deviceName);
        if ([STW_BLE_SDK sharedInstance].bindingDevices.count > 0) {
            BOOL isDevice = NO;
            //判断是否已经存在此设备
            for (STW_DeviceData *deviceData in [STW_BLE_SDK sharedInstance].bindingDevices) {
                if ([deviceData.device_mac isEqualToString:device.deviceMac]) {
                    isDevice = YES;
                    break;
                }
            }
            
            if (isDevice) {
                //存在设备开始进行连接
                [[STW_BLE_SDK sharedInstance] connect:device];
            }
        }
    };
    
    //获取所有信息的回调
    [STW_BLE_SDK sharedInstance].BLEServiceAllDatas = ^(int work_model,int tmp_model,int tmp_max,int tmp_now,int lamp_model,int brightness_value,int game_model,int boot_status,int vibration_value,int pax_color,int pax_battery){
        [STW_BLE_SDK sharedInstance].device.deviceColor = pax_color;
        [STW_BLE_SDK sharedInstance].deviceData = [STW_BLE_Model STW_BLE_ModelInit:work_model tmp_model:tmp_model tmp_max:tmp_max tmp_now:tmp_now lamp_model:lamp_model brightness_value:brightness_value game_model:game_model boot_status:boot_status vibration_value:vibration_value pax_color:pax_color pax_battery:pax_battery];
        
        //获取所有信息
        NSLog(@"获取所有的信息");
    };
    
    //蓝牙连接成功的回调
    [STW_BLE_SDK sharedInstance].BLEServiceDiscoverCharacteristicsForServiceHandler = ^(int deviceColor)
    {
        //停止蓝牙扫描
        if(_scan_timer)
        {
            [_scan_timer invalidate];
            _scan_timer = nil;
        }
        
        if(!Modal_status)
        {
            Modal_status = YES;
            
            [STW_BLE_SDK sharedInstance].deviceData.pax_color = deviceColor;
            
            //刷新列表
            NSMutableArray *deviceArrys = [NSMutableArray array];
            
            for (STW_PAXChooseViewModel *deviceDataModel in _dicAry) {
                if ([deviceDataModel.device_mac isEqualToString:[STW_BLE_SDK sharedInstance].device.deviceMac]) {
                    deviceDataModel.connectStatus = YES;
                }
                [deviceArrys addObject:deviceDataModel];
            }
            
            _dicAry = deviceArrys;
            
            //需要进行刷新页面的操作
            [self refresh_views];
        }
    };
    
    //蓝牙断开连接的操作
    [STW_BLE_SDK sharedInstance].BLEServiceDisconnectHandler = ^()
    {
        //刷新列表
        NSMutableArray *deviceArrys = [NSMutableArray array];
        
        for (STW_PAXChooseViewModel *deviceDataModel in _dicAry) {
            if ([deviceDataModel.device_mac isEqualToString:[STW_BLE_SDK sharedInstance].device.deviceMac]) {
                deviceDataModel.connectStatus = NO;
            }
            [deviceArrys addObject:deviceDataModel];
        }
        
        _dicAry = deviceArrys;
        
        //清空所有连接信息
        [STW_BLE_SDK sharedInstance].device = nil;
        [STW_BLE_SDK sharedInstance].deviceData = nil;
        
        //需要进行刷新页面的操作
        [self refresh_views];
        
        //延时方法
        [self scan_timer_func];
        //4秒之后再次执行
        _scan_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scan_timer_func) userInfo:nil repeats:YES];
        //重新启动扫描
        Modal_status = NO;
    };
}

-(NSMutableArray *)getDeviceArry
{
    NSMutableArray *devcieArry = [STW_Data_Plist GetDeviceData];
    NSMutableArray *devcieArry_view = [NSMutableArray array];
    
    for (STW_DeviceData *deviceData in devcieArry) {
        //初始化数据
        STW_PAXChooseViewModel *deviceModel = [[STW_PAXChooseViewModel alloc] init];
        //封装数据
        deviceModel.imageStr = [self getImageName:deviceData.pax_color];
        deviceModel.deviceName = deviceData.device_name;
        deviceModel.device_mac = deviceData.device_mac;
        deviceModel.connectStatus = NO;
        deviceModel.device_model = deviceData.device_model;
        
        //添加到数组
        [devcieArry_view addObject:deviceModel];
    }
    
    return devcieArry_view;
}

- (void)addFelicityView {
    _cardSwitchView = [[HXCardSwitchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 214.0f)];
    [_cardSwitchView setCardSwitchViewAry:[self ittemsCardSwitchViewAry] delegate:self];
    [self.PaxDeviceScollView addSubview:_cardSwitchView];
}

-(NSString *)getImageName:(int)key_num
{
    NSString *image_str;
    switch (key_num) {
        case 0:
            image_str = @"pax3_silver";
            break;
        case 1:
            image_str = @"pax3_black";
            break;
        case 2:
            image_str = @"pax3_blue";
            break;
        case 3:
            image_str = @"pax3_gold";
            break;
        case 4:
            image_str = @"pax3_red";
            break;
        case 5:
            image_str = @"pax3_rose";
            break;
            
        default:
            image_str = @"pax3_silver";
            break;
    }
    return image_str;
}

/**
 *  准备添加到卡片切换View上的View数组
 */
- (NSArray *)ittemsCardSwitchViewAry
{
    float view_height = SCREEN_HEIGHT - 214.0f;
    float view_width = SCREEN_WIDTH/2.0f;
    
    NSMutableArray *ary = [NSMutableArray new];
    
    for (STW_PAXChooseViewModel *felicityDic in _dicAry) {
        NSInteger index = [_dicAry indexOfObject:felicityDic];
        
        NSString *imageStr = felicityDic.imageStr;
        NSString *deviceName = felicityDic.deviceName;
        BOOL connectStatus = felicityDic.connectStatus;
        
        UIView *backImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
        backImageView.backgroundColor = [UIColor whiteColor];
        backImageView.tag = index;
    
        //设备视图
        float imageView_height = backImageView.frame.size.height - 50.0f;
        float imageView_width = (imageView_height * 382.0f)/1042.0f;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView_width, imageView_height)];
        imageView.center = CGPointMake(backImageView.frame.size.width/2, imageView_height/2.0f);
        imageView.image = [UIImage imageNamed:imageStr];
        [backImageView addSubview:imageView];
        
        //给设备视图添加点击事件
        imageView.userInteractionEnabled=YES;
        imageView.tag = index;
        UITapGestureRecognizer *onclick_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageView_onclick_function:)];
        //UITapGestureRecognizer是没有tag属性，但他有UIView的属性，我们可以通过给UIView添加tag属性，从而标记UITapGestureRecognizer
        [onclick_view view].tag = index;
        [imageView addGestureRecognizer:onclick_view];
        
        //添加长按事件
        UILongPressGestureRecognizer *onclick_view_long =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imageView_onclick_function_long:)];
        //UITapGestureRecognizer是没有tag属性，但他有UIView的属性，我们可以通过给UIView添加tag属性，从而标记UITapGestureRecognizer
        [onclick_view_long view].tag = index;
        [imageView addGestureRecognizer:onclick_view_long];
        
        //设备名称
        UILabel *device_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView_height, backImageView.frame.size.width, 25.0f)];
        device_lable.textAlignment = NSTextAlignmentCenter;
        device_lable.font = [UIFont boldSystemFontOfSize:18.0f];
        device_lable.textColor = [UIColor blackColor];
        device_lable.backgroundColor = [UIColor whiteColor];
        device_lable.text = deviceName;
        [backImageView addSubview:device_lable];
        
        //设备状态
        UILabel *status_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView_height + 25.0f, backImageView.frame.size.width, 25.0f)];
        status_lable.textAlignment = NSTextAlignmentCenter;
        status_lable.font = [UIFont systemFontOfSize:15.0f];
        status_lable.textColor = [UIColor grayColor];
        
        status_lable.backgroundColor = [UIColor whiteColor];
        status_lable.text = connectStatus ? @"Connecting" : @"Disconnect";
        [backImageView addSubview:status_lable];
        
        [ary addObject:backImageView];
    }
    return ary;
}

-(void)imageView_onclick_function:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    int index_num = (int)[singleTap view].tag;
    if (index_num == self->index_path_row) {
//        NSLog(@"index_num - %d - 跳转",index_num);
        STW_PAXChooseViewModel *device_view = _dicAry[self->index_path_row];
        _delect_nums = self->index_path_row;
        if (device_view.connectStatus && [STW_BLE_SDK sharedInstance].BLE_Status) {
            //Modal跳转 AddDeviceViewController
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BLEHomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"BLEHomeViewController"];
            [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:view animated:YES completion:nil];
        }
    }
}

-(void)imageView_onclick_function_long:(id)sender
{
    UILongPressGestureRecognizer *singleTap = (UILongPressGestureRecognizer *)sender;
    int index_num = (int)[singleTap view].tag;
    if (index_num == self->index_path_row) {
//        NSLog(@"index_num - %d - 跳转",index_num);
        STW_PAXChooseViewModel *device_view = _dicAry[self->index_path_row];
        _delect_nums = self->index_path_row;
        if (device_view.connectStatus && [STW_BLE_SDK sharedInstance].BLE_Status) {
            //Modal跳转 AddDeviceViewController
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BLEHomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"BLEHomeViewController"];
            [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:view animated:YES completion:nil];
        }
        else
        {
            if (_delect_device_bool) {
                _delect_device_bool = NO;
                //弹出选择框
                alertViewDeleteDevice = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewNewAtomizer" owner:self options:nil] lastObject];
                
                //造成回调循环引用警告，只需要避免强引用到self，用__weak把self重新引用一下就行了
                __weak __typeof(self) weakSelf = self;
                
                //设置回调
                alertViewDeleteDevice.yes_no_func = ^(int new_old_Atomizer)
                {
                    _delect_device_bool = YES;
                    if (new_old_Atomizer == 0x01)
                    {
                        [weakSelf update_home_listView:YES];
                    }
                    else
                    {
                        [weakSelf update_home_listView:NO];
                    }
                };
                
                [alertViewDeleteDevice showViewWith:@"Are you sure want to delte this device?" :@"YES" :@"NO"];
            }
        }
    }
}


-(void)update_home_listView:(Boolean)key_num
{
    if (key_num) {
        //删除当前的设备
        NSMutableArray *arrysFile = [STW_BLE_SDK sharedInstance].bindingDevices;

        if (arrysFile && arrysFile.count > 1) {
            [arrysFile removeObjectAtIndex:key_num];
        }
        else
        {
            //清空
            [arrysFile removeAllObjects];
        }
        
        [STW_BLE_SDK sharedInstance].bindingDevices = [NSMutableArray array];
        [STW_BLE_SDK sharedInstance].bindingDevices = arrysFile;
    
        //重新将数据写入列表
        [STW_Data_Plist SaveDeviceData:arrysFile];
        
        //断开蓝牙连接
        [[STW_BLE_SDK sharedInstance] disconnect];
        
        if (arrysFile!=NULL && arrysFile.count >0) {
            
            NSLog(@"更新页面 - %d",_delect_nums);
            //从数据库读取已经绑定设备的数据
            _dicAry = [self getDeviceArry];
            //需要进行刷新页面的操作
            [self refresh_views];
        }
        else
        {
            //返回绑定界面
            UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ChooseViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
            [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:view animated:YES completion:nil];
        }
    }
}

#pragma mark HXCardSwitchViewDelegate
- (void)cardSwitchViewDidScroll:(HXCardSwitchView *)cardSwitchView index:(NSInteger)index {
    self->index_path_row = (int)index;
}

//打开侧边栏
- (IBAction)btn_leftView_onclick:(id)sender {
    
    scan_bool = YES;
    
    //结束动画
    if(_scan_timer)
    {
        [_scan_timer invalidate];
        _scan_timer=nil;
    }
    
    //断开蓝牙连接
    [[STW_BLE_SDK sharedInstance] disconnect];
    
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeLeftViewController *setVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeLeftViewController"];
    
    CLPresent *present = CLPresent.sharedCLPresent;
    present.leftAndRight = true;
    setVC.transitioningDelegate = present;
    setVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:setVC animated:YES completion:nil];
    
    present.HomeViewLeftBool = ^()
    {
        NSLog(@"回调");
        scan_bool = NO;
        //延时方法
        [self scan_timer_func];
        //4秒之后再次执行
        _scan_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(scan_timer_func) userInfo:nil repeats:YES];
    };
}

//开始扫描蓝牙设备
-(void)scan_timer_func
{
    if (scan_bool) {
//        NSLog(@"终止扫描");
        if(_scan_timer)
        {
            [_scan_timer invalidate];
            _scan_timer=nil;
        }
    }
    else
    {
//        NSLog(@"时间 - HomeView");
        if ([STW_BLE_SDK sharedInstance].stw_isBLEType == STW_BLE_IsBLETypeOff) {
            NSLog(@"手动扫描蓝牙 - HomeView");
            //开始扫描蓝牙
            [[STW_BLE_SDK sharedInstance] scanStart];
        }
        else
        {
//            NSLog(@"终止扫描");
            [_scan_timer invalidate];
            _scan_timer=nil;
        }
    }
}

//刷新View的逻辑
-(void)refresh_views
{
    self->index_path_row = 0;
    
    //删除掉视图重新建立
    [_cardSwitchView removeFromSuperview];
    //重新建立视图
    [self addFelicityView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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

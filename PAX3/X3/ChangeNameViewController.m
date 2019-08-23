//
//  ChangeNameViewController.m
//  PAX3
//
//  Created by tyz on 17/5/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "STW_BLE.h"
#import "HomeViewController.h"
#import "STW_DeviceData.h"
#import "STW_Data_Plist.h"

@interface ChangeNameViewController ()
{
    UIImageView *paxImageView;
    UITextField *name_textView;
    
    float paxshakView_height;
    float paxView_height;
    float paxView_width;
    
    CGPoint paxView_center;
}

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    paxshakView_height = (SCREEN_HEIGHT - 234.0f);
    paxView_height = paxshakView_height - 16.0f;
    paxView_width = (paxView_height * 382.0f)/1042.0f;
    paxView_center = CGPointMake((SCREEN_WIDTH - 16.0f)/2.0f, (SCREEN_HEIGHT - 250.0f)/2.0f);
    
    //添加PAX视图
    [self add_paxView];
    
    //添加名字视图 - 点击可以进行名字修改
    [self add_changeName_lable];
}

-(void)add_changeName_lable
{
    name_textView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    name_textView.center = CGPointMake(SCREEN_WIDTH/2.0f + 5.0f, 80.0f);
    name_textView.textAlignment = NSTextAlignmentCenter;
    name_textView.text = [STW_BLE_SDK sharedInstance].device.deviceName;
    
    name_textView.font = [UIFont systemFontOfSize:18];
    
    name_textView.attributedText = [self getAttributedString:name_textView.attributedText isUnderline:YES];
    
    [name_textView addTarget:self action:@selector(tfChange:) forControlEvents:UIControlEventEditingChanged];
    [name_textView addTarget:self action:@selector(tfEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.lable_name_view addSubview:name_textView];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//开始输入
- (void)tfChange:(UITextField *)sender
{
    if(name_textView.text.length > 16)
    {
        name_textView.text = @"PAX3";
    }
}

//停止输入
- (void)tfEnd:(UITextField *)sender
{
    if(name_textView.text.length > 16 || name_textView.text.length == 0)
    {
        name_textView.text = @"PAX3";
    }
    else
    {
        //发送设置名称
        [[STW_BLE_SDK sharedInstance] the_set_device_name:name_textView.text];
        [STW_BLE_SDK sharedInstance].device.deviceName = name_textView.text;
    }
}

//退出键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [name_textView resignFirstResponder];
}

//添加下划线
-(NSAttributedString*) getAttributedString:(NSAttributedString*) attributedString isUnderline:(BOOL) isUnderline
{
    NSNumber *valuUnderline = [NSNumber numberWithBool:isUnderline];
    NSRange rangeAll = NSMakeRange(0, attributedString.string.length);
    
    NSMutableAttributedString *as = [attributedString mutableCopy];
    [as beginEditing];
    [as addAttribute:NSUnderlineStyleAttributeName value:valuUnderline range:rangeAll];
    [as addAttribute:NSBackgroundColorAttributeName value:RGBCOLOR(14, 150, 118) range:rangeAll];
    [as endEditing];
    return as;
}

//添加摇晃视图
-(void)add_paxView
{
    paxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, paxView_width, paxView_height)];
    paxImageView.center = CGPointMake(paxView_center.x, paxView_center.y);
    //绑定的时候修改颜色
//    NSLog(@"机身颜色 -- %d",[STW_BLE_SDK sharedInstance].deviceData.pax_color);
    NSString *image_str = [self getImageName:_color_device];
    paxImageView.image = [UIImage imageNamed:image_str];
    [self.pax_image_view addSubview:paxImageView];
}

-(NSString *)getImageName:(int)key_num
{
    NSString *image_str;
    switch (key_num) {
        case 1:
            image_str = @"pax3_silver";
            break;
        case 2:
            image_str = @"pax3_black";
            break;
        case 3:
            image_str = @"pax3_blue";
            break;
        case 4:
            image_str = @"pax3_gold";
            break;
        case 5:
            image_str = @"pax3_red";
            break;
        case 6:
            image_str = @"pax3_rose";
            break;
            
        default:
            image_str = @"pax3_silver";
            break;
    }
    return image_str;
}

//按钮事件
- (IBAction)go_btn_onclick:(id)sender {
    //将设备加入到plist文件中保存
    STW_DeviceData *stwDeviceData = [STW_DeviceData STW_DeviceDataInit:[STW_BLE_SDK sharedInstance].device.deviceMac device_name:[STW_BLE_SDK sharedInstance].device.deviceName pax_color:[STW_BLE_SDK sharedInstance].device.deviceColor device_model:[STW_BLE_SDK sharedInstance].device.deviceModel];
    //保存
    NSMutableArray *arrysFile = [NSMutableArray array];
    if ([STW_BLE_SDK sharedInstance].bindingDevices.count > 0) {
        arrysFile = [STW_BLE_SDK sharedInstance].bindingDevices;
    }
    [arrysFile addObject:stwDeviceData];
    
    //重新将数据写入列表
    [STW_BLE_SDK sharedInstance].bindingDevices = [NSMutableArray array];
    [STW_BLE_SDK sharedInstance].bindingDevices = arrysFile;
    
    [STW_Data_Plist SaveDeviceData:arrysFile];
    
    //断开蓝牙连接
    [[STW_BLE_SDK sharedInstance] disconnect];
    
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *homeViewController = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentViewController:homeViewController animated:YES completion:nil];
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

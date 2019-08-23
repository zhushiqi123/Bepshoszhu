//
//  HomeLeftViewController.m
//  PAX3
//
//  Created by tyz on 17/5/3.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "HomeLeftViewController.h"
#import "HomeLeftTableViewCell.h"
#import "ChooseViewController.h"
#import "STW_BLE.h"
#import "STW_Data_Plist.h"

@interface HomeLeftViewController ()
{
    NSArray *image_arry;
    NSArray *lable_arry;
}

@end

@implementation HomeLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色为白色
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.temp_btn.layer.borderWidth = 1.5f;
    self.temp_btn.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.temp_btn.layer.cornerRadius = 15.0f;
    [self.temp_btn.layer setMasksToBounds:YES];
    
    lable_arry = @[@"ADD A PAX",@"SHOP",@"FIND A STORE",@"SUPPORT"];
    image_arry = @[@"add_a_pax",@"shop",@"find_a_store",@"support"];
    
    //在设置UItableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=[[UIView alloc]init];//关键语句
    //无分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //设置温度按钮
    [self.temp_btn setTitle:[self temp_string:[STW_BLE_SDK sharedInstance].STW_BLE_Temp_model] forState:UIControlStateNormal];
}

-(NSString *)temp_string:(int)key_num
{
    NSString *temp_str;
    
    if (key_num == 0) {
        temp_str = @"Centigrade";
    }
    else
    {
        temp_str = @"Fahrenheit";
    }
    
    return temp_str;
}

#pragma tyz - Table View
//[tableview reloadData];   //刷新列表
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return image_arry.count;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"HomeLeftTableViewCell";
    HomeLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:Cell owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.imageViews.image = [UIImage imageNamed:image_arry[row]];
    cell.lable_text.text = lable_arry[row];

    return cell;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int view_num = (int)indexPath.row;
    if(view_num == 0)
    {
        //Modal跳转
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChooseViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ChooseViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    }
}

//切换温度单位
- (IBAction)change_tmpBtn_onclick:(id)sender {
    NSLog(@"切换温度单位");
    if ([STW_BLE_SDK sharedInstance].STW_BLE_Temp_model == 0) {
        [STW_BLE_SDK sharedInstance].STW_BLE_Temp_model = 1;
        [STW_Data_Plist SaveTempModelData:1];
         [self.temp_btn setTitle:[self temp_string:1] forState:UIControlStateNormal];
    }
    else
    {
        [STW_BLE_SDK sharedInstance].STW_BLE_Temp_model = 0;
        [STW_Data_Plist SaveTempModelData:0];
         [self.temp_btn setTitle:[self temp_string:0] forState:UIControlStateNormal];
    }
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

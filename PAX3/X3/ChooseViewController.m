//
//  ViewController.m
//  PAX3
//
//  Created by tyz on 17/5/2.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseViewTableViewCell.h"
#import "AddDeviceViewController.h"
#import "HomeViewController.h"
#import "UIView+MJAlertView.h"
#import "STW_BLE.h"

@interface ChooseViewController ()
{
    NSArray *image_arrry;
}

@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //返回按钮
    if ([STW_BLE_SDK sharedInstance].bindingDevices != NULL && [STW_BLE_SDK sharedInstance].bindingDevices.count > 0) {
        //按钮显示
        self.back_btn.hidden = NO;
    }
    else
    {
        //按钮隐藏
        self.back_btn.hidden = YES;
    }
    
    image_arrry = @[@"deviceselect_era",@"deviceselect_pax3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //添加按钮
    [self addpaxButton];
}

-(void)addpaxButton
{
    UIButton *paxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220.0f,50.0f)];
    paxButton.backgroundColor = [UIColor whiteColor];
    paxButton.center = CGPointMake(SCREEN_WIDTH/2.0f, self.endView.frame.size.height/2);
    [paxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [paxButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    
    paxButton.layer.borderWidth = 1.5f;
    paxButton.layer.borderColor = [[UIColor blackColor] CGColor];
    
    paxButton.layer.cornerRadius = 5.0f;
    [paxButton.layer setMasksToBounds:YES];
    
    [paxButton setTitle:@"Don't hava a PAX?" forState:UIControlStateNormal];
    [paxButton addTarget:self action:@selector(paxButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.endView addSubview:paxButton];

}

-(void)paxButtonClick
{
//    NSLog(@"paxButtonClick");
    //Modal跳转 AddDeviceViewController
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:view animated:YES completion:nil];
    
//    [UIView addMJNotifierWithText:@"Frist,Make a PAX?" dismissAutomatically:YES];
}

#pragma tyz - Table View
//[tableview reloadData];   //刷新列表
//设置一共有多少个Sessiion，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//设置每个Cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return image_arrry.count;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"ChooseViewTableViewCell";
    ChooseViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (!cell)
    {
        //从xlb加载内容
        cell = [[[NSBundle mainBundle] loadNibNamed:Cell owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.imagesViews.image = [UIImage imageNamed:image_arrry[row]];

    return cell;
}

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self cellOnclick:(int)indexPath.row];
}

-(void)cellOnclick:(int)numCode
{
    //storyboard跳转pax3绑定界面
    if (numCode == 1) {
        //Modal跳转 AddDeviceViewController
        UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddDeviceViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"AddDeviceViewController"];
        [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:view animated:YES completion:nil];
    }
}

//回到主界面
- (IBAction)go_home_onclick:(id)sender {
    //去主界面
    //跳转Home界面
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:view animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

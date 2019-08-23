//
//  BindingViewController.m
//  Vapesoul
//
//  Created by tyz on 17/7/10.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import "BindingViewController.h"
#import "DeviceInfoViewController.h"

@interface BindingViewController ()

@end

@implementation BindingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //给按钮添加点击返回的事件
    [self setRebackOnclick];
    //添加可用设备标签栏
    [self addUseTitleView];
    //设置TbaleView
    [self addTableView];
}

//添加可用设备标签栏
-(void)addUseTitleView
{
    float devieListTitleLabel_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    float devieListTitleLabel_width = SCREEN_WIDTH - 14.0f;
    
    float devieListTitleLabel_y = (SCREEN_HEIGHT * 9.5f)/100.0f;
    
    UILabel *devieListTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 14.0f, devieListTitleLabel_y, devieListTitleLabel_width, devieListTitleLabel_height)];
    
    devieListTitleLabel.text = @"可用设备:";
    devieListTitleLabel.backgroundColor = [UIColor clearColor];
    devieListTitleLabel.textColor = RGBCOLOR(51, 51, 51);
    devieListTitleLabel.font = [UIFont systemFontOfSize:(devieListTitleLabel_height*0.4)];
    
    [self.view addSubview:devieListTitleLabel];
}

//设置TbaleView
-(void)addTableView
{
    float tableview_height = (SCREEN_HEIGHT * 83.5f)/100.0f;
    float tableview_width = SCREEN_WIDTH;
    
    float tableview_y = (SCREEN_HEIGHT * 16.5f)/100.0f;

    [self.tableview setBackgroundColor:[UIColor redColor]];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, tableview_y, tableview_width, tableview_height) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableview];
    
    //在设置UItableView
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView=[[UIView alloc]init];//关键语句
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
    float cell_height = (SCREEN_HEIGHT * 7.0f)/100.0f;
    //44.0f
    return cell_height;
}

//设置一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

//TableView数据加载执行的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //显示向右的箭头
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        //设置文本
        cell.textLabel.font = [UIFont systemFontOfSize:(cell.frame.size.height * 0.3)];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row == 0) {
            //放置一张图片
            float cell_width = SCREEN_WIDTH;
            UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 12)];
            statusImageView.center = CGPointMake((cell_width - 45.0f), (cell.frame.size.height/2.0f));
            statusImageView.image = [UIImage imageNamed:@"icon_yes"];
            [cell addSubview:statusImageView];
        }
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Vapesoule_V%d",(int)indexPath.row];
    return cell;
}

/******************分割线对齐左右两端*****************/
-(void)viewDidLayoutSubviews {
    
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
/*************************************************/

//点击某个CEll执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell被点击之后效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Modal跳转
    UIStoryboard *MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceInfoViewController *view = [MainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceInfoViewController"];
    [view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:view animated:YES completion:nil];
}

//给按钮添加点击返回的事件
-(void)setRebackOnclick
{
    //给设备视图添加点击事件
    self.rebackImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *onclick_view =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclick_function:)];
    [self.rebackImageView addGestureRecognizer:onclick_view];
}

//点击事件
-(void)onclick_function:(id)sender
{
    //返回事件
    [self dismissViewControllerAnimated:YES completion:NULL];
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

//
//  JKAlertDialog.m
//  JKAlertDialog
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
//
#define AlertPadding 10
#define MenuHeight 44

#define AlertHeight 130
#define AlertWidth 270

#import "JKAlertDialog.h"
#import "addressCell.h"
#import "User.h"
#import "Session.h"
#import "StwClient.h"
#import "ProgressHUD.h"

@interface JKAlertDialog()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *address_id_List;
    NSMutableArray *username_List;
    NSMutableArray *phone_List;
    NSMutableArray *address_list;
    NSMutableArray *addressAA_list;
    NSString *check;
}
@property(strong,nonatomic) UITableView *tableView;
@end

@implementation JKAlertDialogItem
@end

@implementation JKAlertDialog
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message checkPopList:(NSString *)checkPopList{
    
    check = checkPopList;
    if (self)
    {
        self = [super init];

        _items = [[NSMutableArray alloc] init];
        _title  = title;
        _message = message;
        [self buildViews];
    }
    return self;
}
-(void)buildViews
{
    self.frame = [self screenBounds];
     _coverView = [[UIView alloc]initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_coverView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AlertWidth, AlertHeight)];
    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor orangeColor];
    
//    _alertView.backgroundColor = [UIColor redColor];
    if ([check isEqualToString:@"address"])
    {
        [self getWebData];
    }
    if (_tableView == nil)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 1000) style:UITableViewStylePlain];
        self.contentView =_tableView;
    }
    
    [self addSubview:_alertView];
  
    //title
    CGFloat labelHeigh = [self heightWithString:_title fontSize:30 width:AlertWidth-2*AlertPadding];
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding,0, AlertWidth-2*AlertPadding, labelHeigh)];
//    _labelTitle.backgroundColor = [UIColor redColor];
    _labelTitle.font = [UIFont boldSystemFontOfSize:17];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.numberOfLines = 0;
    _labelTitle.text = _title;
    _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [_alertView addSubview:_labelTitle];
    
    //message
    CGFloat messageHeigh = [self heightWithString:_message fontSize:14 width:AlertWidth-2*AlertPadding];

    _labelmessage =  [[UILabel alloc]initWithFrame:CGRectMake(AlertPadding, _labelTitle.frame.origin.y+_labelTitle.frame.size.height, AlertWidth-2*AlertPadding, messageHeigh+2*AlertPadding)];
    _labelmessage.font = [UIFont systemFontOfSize:14];
    _labelmessage.textColor = [UIColor blackColor];
    _labelmessage.textAlignment = NSTextAlignmentCenter;
    _labelmessage.text = _message;
    _labelmessage.numberOfLines = 0;
    _labelmessage.lineBreakMode = NSLineBreakByCharWrapping;
    [_alertView addSubview:_labelmessage];
    
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [_alertView addSubview:_contentScrollView];

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}
- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)layoutSubviews
{
    _buttonScrollView.frame = CGRectMake(0, _alertView.frame.size.height-MenuHeight,_alertView.frame.size.width, MenuHeight);
    _contentScrollView.frame = CGRectMake(0, _labelTitle.frame.origin.y+_labelTitle.frame.size.height, _alertView.frame.size.width, _alertView.frame.size.height-MenuHeight);
    self.contentView.frame = CGRectMake(0,0,self.contentView.frame.size.width, self.contentView.frame.size.height);
    _contentScrollView.contentSize = self.contentView.frame.size;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self addButtonItem];
    [_contentScrollView addSubview:self.contentView];
    [self reLayout];
}
-(void)reLayout
{
    CGFloat plus;
    if (self.contentView)
    {
        plus = self.contentView.frame.size.height-(_alertView.frame.size.height-MenuHeight);
    }
    else
    {
        plus = _labelmessage.frame.origin.y+_labelmessage.frame.size.height -(_alertView.frame.size.height-MenuHeight);
    }
    plus = MAX(0, plus);
    CGFloat height =  MIN([self screenBounds].size.height-MenuHeight,_alertView.frame.size.height+plus);
    
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, AlertWidth, height);
    _alertView.center = self.center;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}
- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}
#pragma mark - add item

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    JKAlertDialogItem *item = [[JKAlertDialogItem alloc] init];
    item.title = title;
    item.action =  ^(JKAlertDialogItem *item) {
        NSLog(@"no action");
    };
    item.type = Button_OK;
    [_items addObject:item];
    return [_items indexOfObject:title];
}
- (void)addButton:(ButtonType)type withTitle:(NSString *)title handler:(JKAlertDialogHandler)handler
{
    JKAlertDialogItem *item = [[JKAlertDialogItem alloc] init];
    item.title = title;
    item.action = handler;
    item.type = type;
    [_items addObject:item];
    item.tag = [_items indexOfObject:item];
}
- (void)addButtonItem
{
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _alertView.frame.size.height- MenuHeight,AlertWidth, MenuHeight)];
    _buttonScrollView.bounces = NO;
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    _buttonScrollView.showsVerticalScrollIndicator =  NO;
    CGFloat  width;
    if(self.buttonWidth)
    {
        width = self.buttonWidth;
        _buttonScrollView.contentSize = CGSizeMake(width, MenuHeight);

//        _buttonScrollView.contentSize = CGSizeMake(width*[_items count], MenuHeight);
    }
    else
    {
//       width = _alertView.frame.size.width/[_items count];
        width = _alertView.frame.size.width;
    }
    [_items enumerateObjectsUsingBlock:^(JKAlertDialogItem *item, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.frame = CGRectMake(idx*width, 1, width, MenuHeight);
        //seperator
        button.backgroundColor = [UIColor whiteColor];
        button.layer.shadowColor = [[UIColor grayColor] CGColor];
        button.layer.shadowRadius = 0.5;
        button.layer.shadowOpacity = 1;
        button.layer.shadowOffset = CGSizeZero;
        button.layer.masksToBounds = NO;
        button.tag = 90000+ idx;
        // title
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
        
        // action
        [button addTarget:self
                    action:@selector(buttonTouched:)
          forControlEvents:UIControlEventTouchUpInside];

        [_buttonScrollView addSubview:button];
    }];
    [_alertView addSubview:_buttonScrollView];
    
}

- (void)buttonTouched:(UIButton*)button{
    JKAlertDialogItem *item = _items[button.tag-90000];
    if (item.action) {
        item.action(item);
    }
    [self dismiss];
}
#pragma mark - show and dismiss
-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}
- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;

    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)dismiss {
    [self hideAnimation];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self removeFromSuperview];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];

    
}


#pragma mark - Handle device orientation changes
// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    //    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.frame = [self screenBounds];
    //NSLog(@"self.frame%@",NSStringFromCGRect(self.frame));
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self reLayout];
                     }
                     completion:nil
     ];
  

}
- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0,44, screenWidth, (screenHeight*2)/3);
}

#pragma --mark table
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([check isEqualToString:@"address"])
    {
        return username_List.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([check isEqualToString:@"address"])
    {
        //添加可重标示符
        static NSString *ID = @"addressCell";
        addressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell)
        {
            //从xlb加载内容
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.address_name.text = username_List[indexPath.row];
        cell.address_phone.text = phone_List[indexPath.row];
        cell.address.text = address_list[indexPath.row];

        return cell;
    }
    else
    {
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //logistics
        if ([check isEqualToString:@"logistics"])
        {
            cell.textLabel.text = @"顺丰速运";
        }
        else if ([check isEqualToString:@"payWay"])
        {
            cell.textLabel.text = @"支付宝";
        }
        else
        {
             cell.textLabel.text = @"数据获取失败";
        }
        
        //config the cell
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------%d",indexPath.row);
}

-(void)getWebData
{
    [ProgressHUD show:@"正在获取收货人信息"];
    [User address_index:[Session sharedInstance].user.accesskey success:^(NSString *data)
     {
         [ProgressHUD dismiss];
         NSLog(@"data==>%@",data);
     }
     failure:^(NSString *message)
     {
         [ProgressHUD dismiss];
         NSLog(@"message===>%@",message);
         address_id_List= [NSMutableArray array];
         username_List = [NSMutableArray array];
         phone_List = [NSMutableArray array];
         address_list = [NSMutableArray array];
         addressAA_list = [NSMutableArray array];
         //
         //         //        NSLog(@"message==>%@",message);
         //
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
                     NSString *address_id = (NSString *)[listdic objectForKey:@"address_id"];  //地址列表id
                     NSString *consignee = (NSString *)[listdic objectForKey:@"consignee"];   //收件人姓名
                     NSString *mobile = (NSString *)[listdic objectForKey:@"mobile"];      //收件人电话
                     NSString *country = (NSString *)[listdic objectForKey:@"country"];
                     NSString *province = (NSString *)[listdic objectForKey:@"province"];
                     NSString *city = (NSString *)[listdic objectForKey:@"city"];
                     NSString *district = (NSString *)[listdic objectForKey:@"district"];
                     NSString *address = (NSString *)[listdic objectForKey:@"address"];
                     //将获取的value值放到数组容器中
                     if (![address_id isEqualToString:@""] && address_id)
                     {
                         [address_id_List addObject:address_id];
                         [username_List addObject:consignee];
                         [phone_List addObject:mobile];
                         [address_list addObject:[NSString stringWithFormat:@"%@%@%@%@%@",country,province,city,district,address]];
                         [addressAA_list addObject:[NSString stringWithFormat:@"%@%@%@%@",country,province,city,district]];
                     }
                 }
                 [ProgressHUD dismiss];
                 [self.tableView reloadData];
             }
         }
         else
         {
             //            NSLog(@"message-->%@",message);
             [ProgressHUD dismiss];
             [ProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"msg"]]];
         }
     }];
}

@end

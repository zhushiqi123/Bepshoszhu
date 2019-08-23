//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionView.h"

static NSString *const kAppVersion = @"appVersion";

@interface LaunchIntroductionView ()<UIScrollViewDelegate>
{
    UIScrollView  *launchScrollView;
    UIPageControl *page;
}

@end

@implementation LaunchIntroductionView
NSArray *images;
NSArray *titleString_arry;
NSArray *lableString_arry;
BOOL isScrollOut;//在最后一页再次滑动是否隐藏引导页
NSString *enterBtnImage;
static LaunchIntroductionView *launch = nil;
NSString *storyboard;

#pragma mark - 用storyboard创建的项目时调用
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames buttonString:(NSString *)buttonString titleString:(NSArray *)titleString lableString:(NSArray *)lableString{
    //图片列表
    images = imageNames;
    
    //storyboard
    storyboard = storyboardName;
    
    //按钮图片
    enterBtnImage = buttonString;
    
    //title string
    titleString_arry = titleString;
    
    //lable string
    lableString_arry = lableString;
    
    isScrollOut = NO;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            [self addImages];
        }else{
            [self removeFromSuperview];
        }
    }
    return self;
}
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch
{
    return YES;
}
#pragma mark - 添加引导页图片
-(void)addImages{
    [self createScrollView];
}
#pragma mark - 创建滚动视图
-(void)createScrollView{
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreen_width * images.count, kScreen_height);
    [self addSubview:launchScrollView];
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height)];
        imageView.image = [UIImage imageNamed:images[i]];
        [launchScrollView addSubview:imageView];
        
        //添加Title
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, kScreen_width, 60)];
        [titleView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25.0f]];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.textColor = [UIColor whiteColor];
        titleView.text = titleString_arry[i];
        titleView.backgroundColor = [UIColor clearColor];
        [imageView addSubview:titleView];

        //添加Lable
        UILabel *lableView = [[UILabel alloc] initWithFrame:CGRectMake(50, 104, kScreen_width - 100, 100)];
        [lableView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
        lableView.numberOfLines = 6;
        lableView.textAlignment = NSTextAlignmentCenter;
        lableView.textColor = [UIColor whiteColor];
        lableView.text = lableString_arry[i];
        lableView.backgroundColor = [UIColor clearColor];
        [imageView addSubview:lableView];
        
        //添加Button
        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180,50)];
        enterButton.backgroundColor = RGBCOLOR(50, 243, 90);
        enterButton.center = CGPointMake(kScreen_width/2.0f, kScreen_height - 100.0f);
        [enterButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
        [enterButton setTitle:enterBtnImage forState:UIControlStateNormal];
        enterButton.layer.cornerRadius = 25.0f;
        [enterButton.layer setMasksToBounds:YES];
        [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:enterButton];
        imageView.userInteractionEnabled = YES;
    }
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreen_height - 50, kScreen_width, 30)];
    page.numberOfPages = images.count;
    page.backgroundColor = [UIColor clearColor];
    page.currentPage = 0;
    page.defersCurrentPageDisplay = YES;
    [self addSubview:page];
}
#pragma mark - 进入按钮
-(void)enterBtnClick{
    [self hideGuidView];
}
#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}
#pragma mark - scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
    if (cuttentIndex == images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        page.currentPage = cuttentIndex;
    }
}
#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - KVO监测值的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
        page.currentPageIndicatorTintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
        page.pageIndicatorTintColor = self.nomalColor;
    }
}

@end

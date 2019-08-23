//
//  ShopViewController.h
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

typedef enum
{
    URL_load = 0,
    HTML_load,
    Data_load,
    Fiel_load,
}WkwebLoadType;

@interface ShopViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;

// 加载type
@property(nonatomic,assign) NSInteger  IntegerType;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *ProgressView;

@property (weak, nonatomic) IBOutlet UIView *topBarView;

@end

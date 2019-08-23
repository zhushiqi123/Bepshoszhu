//
//  URLWebViewController.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/31.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

typedef enum
{
    URL_load = 0,
    HTML_load,
    Data_load,
    Fiel_load,
}WkwebLoadType;

@interface URLWebViewController : DelegateViewController<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,copy) NSString *lable_title;
@property (retain,nonatomic) NSNumber *id;
@property(nonatomic,strong)WKWebView *webView;

// 加载type
@property(nonatomic,assign) NSInteger  IntegerType;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *  ProgressView;

@end

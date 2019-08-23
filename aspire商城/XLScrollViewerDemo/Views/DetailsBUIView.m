//
//  DetailsBUIView.m
//  aspire商城
//
//  Created by tyz on 15/12/14.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "DetailsBUIView.h"
#import "Session.h"
@implementation DetailsBUIView
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    //设置自动作坊网页自适应屏幕
    self.webView.scalesPageToFit = YES;
    
    //设置委托
    self.webView.delegate = self;
    
    if (_webView == nil)
    {
        self.backgroundColor =[UIColor whiteColor];
        //在view里面区新建一个tableview最好取得手机屏幕的宽高
        //initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)  [ UIScreen mainScreen ].bounds
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(64+44+20))];
        NSString *content = [Session sharedInstance].goods_content;
        
        //替换错误字符
        content = [content stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"<"];
        content = [content stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@">"];
        content = [content stringByReplacingOccurrencesOfString:@"&amp;quot;" withString:@"\""];
        content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"amp" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"nbsp" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@",,,," withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@";;" withString:@""];
        NSLog(@"content-->%@",content);
        
        NSMutableString *sb = [[NSMutableString alloc] init];
        [sb appendString:@"<html>"];
//        [sb appendString:@"页面详情"];
        [sb appendString:content];
        [sb appendString:@"</html>"];
        [self.webView loadHTMLString:sb baseURL:nil];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.aspirecig.cn"]];
//        [self.webView loadRequest:request];
        
        [self addSubview:_webView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

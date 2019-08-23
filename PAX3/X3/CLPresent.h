//
//  SKCashPay.h
//  Budayang
//
//  Created by darren on 16/3/28.
//  Copyright © 2016年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLPresent : NSObject<UIViewControllerTransitioningDelegate>

+ (CLPresent *)sharedCLPresent;

@property (assign,nonatomic) BOOL leftAndRight;

//设置一个回调方法
typedef void (^HomeViewLeftBool)();
@property(nonatomic,copy) HomeViewLeftBool HomeViewLeftBool;

@end

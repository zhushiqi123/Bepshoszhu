//
//  IndentViewController.h
//  aspire商城
//
//  Created by tyz on 15/12/2.
//  Copyright © 2015年 stw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTableAlert.h"

@interface IndentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btn_price;
@property (strong, nonatomic) IBOutlet UIButton *btn_freight;
@property (strong, nonatomic) IBOutlet UIButton *btn_getClose;
@property (strong, nonatomic) MLTableAlert *alert;

@end

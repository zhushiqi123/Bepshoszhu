//
//  KeyNumInPutView.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/25.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyNumInPutView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lable_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_low;
@property (weak, nonatomic) IBOutlet UITextField *input_text;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;

@end

//
//  EvaluateViewController.h
//  aspire商城
//
//  Created by tyz on 16/1/11.
//  Copyright © 2016年 Stw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btn_Evaluate;

@property (weak, nonatomic) IBOutlet UIButton *evaluate_btn_1;
@property (weak, nonatomic) IBOutlet UIButton *evaluate_btn_2;
@property (weak, nonatomic) IBOutlet UIButton *evaluate_btn_3;
@property (weak, nonatomic) IBOutlet UIButton *evaluate_btn_4;
@property (weak, nonatomic) IBOutlet UIButton *evaluate_btn_5;
@property (weak, nonatomic) IBOutlet UITextView *assessmentText;

@end

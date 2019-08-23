//
//  AfterSalesViewController.m
//  aspire商城
//
//  Created by tyz on 15/12/5.
//  Copyright © 2015年 Stw. All rights reserved.
//

#import "AfterSalesViewController.h"

@interface AfterSalesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textview;

@end

@implementation AfterSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textview.editable = NO;
    self.title = @"售后政策";
    // Do any additional setup after loading the view.
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

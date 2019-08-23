//
//  FlavourViewController.m
//  beposh
//
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//
//  *I do not quite understand of this view,So you can migrate your view.
//  *I'm ready for you a method to TYZ_BLE/TYZ_BLE_Protocol.h
//

#import "FlavourViewController.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Service.h"

@interface FlavourViewController ()
{
    NSArray *arry_text1;
    NSArray *arry_text2;
}

@end

@implementation FlavourViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    arry_text1 = [NSArray arrayWithObjects:@"",@"TOBACCO",@"MENTHOL",@"ENERGY",@"APPLE",@"MELON",@"PEACH",@"VANILLA",@"SMOOTH TOBACCO", nil];
    arry_text2 = [NSArray arrayWithObjects:@"",@"NICOTINE:0",@"NICOTINE:8",@"NICOTINE:16",nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_navigationbar"]]];
}

- (IBAction)btn_home_onclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Back");
    }];
}

- (IBAction)btn_default_onclick:(id)sender
{
    self.title1_text.text = arry_text1[0];
    self.title2_text.text = arry_text2[0];
    
    [self.btn1_1 setBackgroundImage:[UIImage imageNamed:@"clr-1"] forState:UIControlStateNormal];
    [self.btn1_2 setBackgroundImage:[UIImage imageNamed:@"clr-2"] forState:UIControlStateNormal];
    [self.btn1_3 setBackgroundImage:[UIImage imageNamed:@"clr-3"] forState:UIControlStateNormal];
    [self.btn1_4 setBackgroundImage:[UIImage imageNamed:@"clr-4"] forState:UIControlStateNormal];
    [self.btn1_5 setBackgroundImage:[UIImage imageNamed:@"clr-5"] forState:UIControlStateNormal];
    [self.btn1_6 setBackgroundImage:[UIImage imageNamed:@"clr-6"] forState:UIControlStateNormal];
    [self.btn1_7 setBackgroundImage:[UIImage imageNamed:@"clr-7"] forState:UIControlStateNormal];
    [self.btn1_8 setBackgroundImage:[UIImage imageNamed:@"clr-8"] forState:UIControlStateNormal];
    
    [self.btn2_1 setBackgroundImage:[UIImage imageNamed:@"0unavailable"] forState:UIControlStateNormal];
    [self.btn2_2 setBackgroundImage:[UIImage imageNamed:@"8unavailable"] forState:UIControlStateNormal];
    [self.btn2_3 setBackgroundImage:[UIImage imageNamed:@"16unavailable"] forState:UIControlStateNormal];
}

//SAVE
- (IBAction)btn_save_onclick:(id)sender {
    NSLog(@"btn_save_onclick");
}

- (IBAction)btn_onclick1_1:(id)sender{
    [self setBtn1Background:1];
}

- (IBAction)btn_onclick1_2:(id)sender {
    [self setBtn1Background:2];
}

- (IBAction)btn_onclick1_3:(id)sender {
    [self setBtn1Background:3];
}

- (IBAction)btn_onclick1_4:(id)sender {
    [self setBtn1Background:4];
}

- (IBAction)btn_onclick1_5:(id)sender {
    [self setBtn1Background:5];
}

- (IBAction)btn_onclick1_6:(id)sender {
    [self setBtn1Background:6];
}

- (IBAction)btn_onclick1_7:(id)sender {
    [self setBtn1Background:7];
}

- (IBAction)btn_onclick1_8:(id)sender {
    [self setBtn1Background:8];}

- (IBAction)btn_onclick2_1:(id)sender
{
    [self setBtn1Background2:1];
}

- (IBAction)btn_onclick2_2:(id)sender
{
    [self setBtn1Background2:2];
}

- (IBAction)btn_onclick2_3:(id)sender
{
    [self setBtn1Background2:3];
}

- (void)setBtn1Background:(int)num
{
    [self.btn1_1 setBackgroundImage:[UIImage imageNamed:@"clr-1"] forState:UIControlStateNormal];
    [self.btn1_2 setBackgroundImage:[UIImage imageNamed:@"clr-2"] forState:UIControlStateNormal];
    [self.btn1_3 setBackgroundImage:[UIImage imageNamed:@"clr-3"] forState:UIControlStateNormal];
    [self.btn1_4 setBackgroundImage:[UIImage imageNamed:@"clr-4"] forState:UIControlStateNormal];
    [self.btn1_5 setBackgroundImage:[UIImage imageNamed:@"clr-5"] forState:UIControlStateNormal];
    [self.btn1_6 setBackgroundImage:[UIImage imageNamed:@"clr-6"] forState:UIControlStateNormal];
    [self.btn1_7 setBackgroundImage:[UIImage imageNamed:@"clr-7"] forState:UIControlStateNormal];
    [self.btn1_8 setBackgroundImage:[UIImage imageNamed:@"clr-8"] forState:UIControlStateNormal];
    
    switch (num)
    {
        case 1:
            self.title1_text.text = arry_text1[1];
            [self.btn1_1 setBackgroundImage:[UIImage imageNamed:@"color_1"] forState:UIControlStateNormal];
            break;
        case 2:
            self.title1_text.text = arry_text1[2];
            [self.btn1_2 setBackgroundImage:[UIImage imageNamed:@"color_2"] forState:UIControlStateNormal];
            break;
        case 3:
            self.title1_text.text = arry_text1[3];;
            [self.btn1_3 setBackgroundImage:[UIImage imageNamed:@"color_3"] forState:UIControlStateNormal];
            break;
        case 4:
            self.title1_text.text = arry_text1[4];;
            [self.btn1_4 setBackgroundImage:[UIImage imageNamed:@"color_4"] forState:UIControlStateNormal];
            break;
        case 5:
            self.title1_text.text = arry_text1[5];
            [self.btn1_5 setBackgroundImage:[UIImage imageNamed:@"color_5"] forState:UIControlStateNormal];
            break;
        case 6:
            self.title1_text.text = arry_text1[6];;
            [self.btn1_6 setBackgroundImage:[UIImage imageNamed:@"color_6"] forState:UIControlStateNormal];
            break;
        case 7:
            self.title1_text.text = arry_text1[7];;
            [self.btn1_7 setBackgroundImage:[UIImage imageNamed:@"color_7"] forState:UIControlStateNormal];
            break;
        case 8:
            self.title1_text.text = arry_text1[8];;
            [self.btn1_8 setBackgroundImage:[UIImage imageNamed:@"color_8"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)setBtn1Background2:(int)num
{
    [self.btn2_1 setBackgroundImage:[UIImage imageNamed:@"0unavailable"] forState:UIControlStateNormal];
    [self.btn2_2 setBackgroundImage:[UIImage imageNamed:@"8unavailable"] forState:UIControlStateNormal];
    [self.btn2_3 setBackgroundImage:[UIImage imageNamed:@"16unavailable"] forState:UIControlStateNormal];
    
    switch (num) {
        case 1:
            self.title2_text.text = arry_text2[1];
            [self.btn2_1 setBackgroundImage:[UIImage imageNamed:@"0available"] forState:UIControlStateNormal];
            break;
        case 2:
            self.title2_text.text = arry_text2[2];
            [self.btn2_2 setBackgroundImage:[UIImage imageNamed:@"8available"] forState:UIControlStateNormal];
            break;
        case 3:
            self.title2_text.text = arry_text2[3];
            [self.btn2_3 setBackgroundImage:[UIImage imageNamed:@"16available"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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

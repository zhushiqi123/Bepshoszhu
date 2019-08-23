//
//  CCViewController.m
//  Created by 田阳柱 on 16/7/23.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import "CCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CCProgressView.h"
#import "IOPowerSources.h"
#import "IOPSKeys.h"
#import <CoreMotion/CoreMotion.h>
#import "UICountingLabel.h"
#import "UIDevice+ProcessesAdditions.h"
#import "TYZ_Session.h"
#import "TYZ_BLE_Service.h"
#define EPSILON     1e-6
#define kDuration 1.0
@interface CCViewController ()
{
    UICountingLabel *_titleLabel;
    UIImageView *batteryImage;
    UILabel *lable_end;
    
}
@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic, strong) CADisplayLink* motionDisplayLink;
@property (nonatomic) float motionLastYaw;

@end

@implementation CCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.userInteractionEnabled=YES;
    int height_circleChart = (ViewHeight/2) - ((ViewWidth/2)-30);
    _circleChart = [[CCProgressView alloc] initWithFrame:CGRectMake(30, height_circleChart, ViewWidth-30*2,ViewWidth-30*2)];
    _circleChart.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_circleChart];
    
    r=_circleChart.frame.size.height;
    
    _titleLabel=[[UICountingLabel alloc]initWithFrame:CGRectMake(_circleChart.frame.origin.y, _circleChart.frame.origin.x, _circleChart.frame.size.height, _circleChart.frame.size.width)];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:88.0f]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    _titleLabel.method = UILabelCountingMethodEaseInOut;
    [self.view addSubview:_titleLabel];
    [_titleLabel setHidden:YES];
    
    [self addBatteryOnImage];
    
    [self addLable_end];
    
    [TYZ_BLE_Service sharedInstance].notifyHandlerD3 = ^(int battery,int battery_status)
    {
        NSLog(@"电池电量 - CCView - >battery - %d,battery_status - %d",battery,battery_status);
        if([TYZ_Session sharedInstance].battery_status != battery_status || battery != [TYZ_Session sharedInstance].battery)
        {
            [TYZ_Session sharedInstance].battery = battery;
            [TYZ_Session sharedInstance].battery_status = battery_status;
            
            [self batteryLevel];
            [self startGravity];
        }
    };
    
    [self batteryLevel];
    
    [self startGravity];
    
    currentTransform=_circleChart.transform;
}

-(void)addBatteryOnImage
{
    batteryImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    batteryImage.image = [UIImage imageNamed:@"icon_battery_on"];
    batteryImage.center = CGPointMake(ViewWidth/2,ViewHeight-50);
    [self.view addSubview:batteryImage];
    
    batteryImage.hidden = YES;
}

-(void)addLable_end
{
    //Keep on cruising
    lable_end = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,ViewWidth, 30)];
    lable_end.center = CGPointMake(ViewWidth/2,ViewHeight-20);
    
    lable_end.textColor = [UIColor whiteColor];
    lable_end.textAlignment = NSTextAlignmentCenter;
    lable_end.adjustsFontSizeToFitWidth = YES;
    
    lable_end.text = @"Keep on cruising";
    
    [self.view addSubview:lable_end];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double) batteryLevel
{
    double percent;

    if ([TYZ_Session sharedInstance].battery >= 0 && [TYZ_Session sharedInstance].battery_status != 2)
    {
//        percent = (([TYZ_Session sharedInstance].battery * 1.0f)/42) * 100.0f;
        percent = [TYZ_Session sharedInstance].battery * 1.0f;
    }
    else
    {
        percent = 100.0f;
    }
    
    if ([TYZ_Session sharedInstance].battery_status == 0x01)
    {
        batteryImage.hidden = NO;
        
        lable_end.hidden = YES;
    }
    else
    {
        batteryImage.hidden = YES;
        
        lable_end.hidden = NO;
    }

    [_circleChart setProgress:percent/100 animated:YES];
    [_titleLabel setHidden:NO];
    _titleLabel.frame=CGRectMake(0, 0, r, r);
    _titleLabel.text=[NSString stringWithFormat:@"%.0f%%",percent];
    float lines = (_circleChart.frame.size.width)/2;
    [_titleLabel setCenter:CGPointMake(_circleChart.frame.origin.x + lines,_circleChart.frame.origin.y + lines)];
    //        return percent;
    //    }
    return -1.0f;
}
- (BOOL)isGravityActive
{
    return self.motionDisplayLink != nil;
}

- (void)startGravity
{
    if ( ! [self isGravityActive]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval =0.1;// 0.02; // 50 Hz
        
        self.motionLastYaw = 0;
        _theTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(motionRefresh:) userInfo:nil repeats:YES];
    }
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    }
}
- (void)motionRefresh:(id)sender
{
    CMQuaternion quat = self.motionManager.deviceMotion.attitude.quaternion;
    double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
    
    yaw *= -1;
    
    if (self.motionLastYaw == 0) {
        self.motionLastYaw = yaw;
    }
    
    static float q = 0.1;   // process noise
    static float s = 0.1;   // sensor noise
    static float p = 0.1;   // estimated error
    static float k = 0.5;   // kalman filter gain
    
    float x = self.motionLastYaw;
    p = p + q;
    k = p / (p + s);
    x = x + k*(yaw - x);
    p = (1 - k)*p;
    
    newTransform=CGAffineTransformRotate(currentTransform,-x);
    _circleChart.transform=newTransform;
    // }
    
    self.motionLastYaw = x;
}

- (void)stopGravity
{
    if ([self isGravityActive]) {
        [self.motionDisplayLink invalidate];
        self.motionDisplayLink = nil;
        self.motionLastYaw = 0;
        [_theTimer invalidate];
        _theTimer=nil;
        
        self.motionManager = nil;
    }
    if ([self.motionManager isDeviceMotionActive])
        [self.motionManager stopDeviceMotionUpdates];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}


@end

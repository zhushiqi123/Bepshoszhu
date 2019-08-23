//
//  AnimMeterViewManager.h
//  s6
//
//  Created by 朱世琦 on 17/12/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <React/RCTViewManager.h>
#import "Animation Panel.h"
#import "RCTConvert+Animation.h"
@interface AnimMeterViewManager : RCTViewManager
@property (nonatomic ,strong)Animation_Panel * ap;
@end

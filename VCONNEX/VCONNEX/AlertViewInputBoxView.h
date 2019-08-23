//
//  AlertViewInputBoxView.h
//  uVapour
//
//  Created by 田阳柱 on 16/10/6.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyNumInPutView.h"

@interface AlertViewInputBoxView : UIView

@property(nonatomic,retain)KeyNumInPutView *KeyinpuBoxView;
@property(nonatomic,assign)int keyNums;

- (void)showViewWith:(int)keyNums;

- (void)remove;

typedef void (^KeyInputBack)(int keyNum);
@property(nonatomic,copy) KeyInputBack keyInput;

@end

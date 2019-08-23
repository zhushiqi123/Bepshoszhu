//
//  TYZUIScrollerView.h
//  PAX3
//
//  Created by tyz on 17/5/5.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYZUITouchStausDelegate <NSObject>

- (void)TYZTouchStausFuc:(int)TouchStatus;

@end

@interface TYZUIScrollerView : UIScrollView

@property (nonatomic, assign) id<TYZUITouchStausDelegate> TYZTouch_delegate;

@end

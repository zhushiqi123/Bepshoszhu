//
//  ChooseModelViewCards.h
//  PAX3
//
//  Created by tyz on 17/5/5.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYZUIScrollerView.h"

#define HXUIColorWithHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]

@class ChooseModelViewCards;

@protocol ChooseModelViewCardsDelegate <NSObject>

- (void)cardSwitchViewDidScroll:(ChooseModelViewCards *)cardSwitchView index:(NSInteger)index;

- (void)changeAplaToLable :(int)viewNum;

- (void)changeArcNums :(int)viewNum;

@end

@interface ChooseModelViewCards : UIView <UIScrollViewDelegate,TYZUITouchStausDelegate>

@property (nonatomic,assign) id<ChooseModelViewCardsDelegate> delegate;

@property (nonatomic,strong) TYZUIScrollerView *cardSwitchScrollView;

@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int currentIndex_moved;
@property (nonatomic,assign) int currentIndex_end;

@property (nonatomic,assign) float viewWidths;

@property (nonatomic,assign) int scollNum;

@property (nonatomic,assign) int TouchType;

//刷新当前View
-(void)SetChooviewNum:(int)key_num;

- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry delegate:(id)delegate;

@end

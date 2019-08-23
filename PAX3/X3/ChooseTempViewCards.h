//
//  ChooseTempViewCards.h
//  X3
//
//  Created by tyz on 17/6/9.
//  Copyright © 2017年 tyz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HXUIColorWithHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]

@class ChooseTempViewCards;

@protocol ChooseTempViewCardsDelegate <NSObject>

- (void)cardSwitchViewDidScroll:(ChooseTempViewCards *)cardSwitchView index:(NSInteger)index;

- (void)changeAplaToLable :(int)viewNum;

- (void)changeArcNums :(int)viewNum;

@end

@interface ChooseTempViewCards : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) id<ChooseTempViewCardsDelegate> delegate;

@property (nonatomic,strong) UIScrollView *cardSwitchScrollView;

@property (nonatomic,assign) int currentIndex;
@property (nonatomic,assign) int currentIndex_moved;
@property (nonatomic,assign) int currentIndex_end;
//是否需要回调
@property (nonatomic,assign) int scrollerView_status;

@property (nonatomic,assign) float viewWidths;

@property (nonatomic,assign) int scollNum;

@property (nonatomic,assign) int TouchType;

//刷新当前View
-(void)SetChooviewNum:(int)key_num;

- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry delegate:(id)delegate :(float)viewWidth;

@end

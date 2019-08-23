//
//  JSDownloadView.h
//  JSDownloadView
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define XNColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//#define UPDATECOLOR RGBCOLOR(0x00, 0xbe, 0xa4)

#define UPDATECOLOR RGBCOLOR(0x00, 0xde, 0xc0)

@protocol JSDownloadAnimationDelegate <NSObject>

@required
- (void)animationStart;

@optional
- (void)animationSuspend;

- (void)animationEnd;

@end

@interface JSDownloadView : UIView
/**
 *  进度:0~1
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  进度宽
 */
@property (nonatomic, assign) CGFloat progressWidth;
/**
 *  是否下载成功
 */
@property (nonatomic, assign) BOOL isSuccess;
/**
 *  委托代理
 */
@property (nonatomic, weak) id<JSDownloadAnimationDelegate> delegate;

/**
 *  开始下载
 */
- (void)showDownSoftAnimation;
@end

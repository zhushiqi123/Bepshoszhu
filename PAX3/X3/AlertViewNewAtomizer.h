//
//  AlertViewNewAtomizer.h
//  VCONNEX
//
//  Created by 田阳柱 on 16/10/29.
//  Copyright © 2016年 TYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewAtomizerXIB;

@interface AlertViewNewAtomizer : UIView

@property(nonatomic,retain)NewAtomizerXIB *NewAtomizerBoxView;

- (void)showViewWith:(NSString *)message :(NSString *)btn_yes_str :(NSString *)btn_no_str;

- (void)remove;

typedef void (^NewAtomizerBox)(int new_old_Atomizer);
@property(nonatomic,copy) NewAtomizerBox yes_no_func;

@end

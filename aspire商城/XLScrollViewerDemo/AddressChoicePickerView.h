//
//  AddressChoicePickerView.h
//  Wujiang
//
//  Created by stw 01 on 15/12/02.
//  Copyright (c) 2015年 stw All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
@class AddressChoicePickerView;
typedef void (^AddressChoicePickerViewBlock)(AddressChoicePickerView *view,UIButton *btn,AreaObject *locate);
@interface AddressChoicePickerView : UIView

@property (copy, nonatomic)AddressChoicePickerViewBlock block;

- (void)show;
@end

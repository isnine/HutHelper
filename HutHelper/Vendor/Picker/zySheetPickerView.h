//
//  zySheetPickerView.h
//  ZYSheetPicker
//
//  Created by Corki on 16/6/20.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <UIKit/UIKit.h>


@class zySheetPickerView;
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^zySheetPickerViewBlock)(zySheetPickerView *pickerView,NSString *choiceString);
@interface zySheetPickerView : UIView
@property (nonatomic,copy)zySheetPickerViewBlock callBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;


//------单条选择器
+(instancetype)ZYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(zySheetPickerViewBlock)callBack;
//显示
-(void)show;
//销毁类
-(void)dismissPicker;

@end






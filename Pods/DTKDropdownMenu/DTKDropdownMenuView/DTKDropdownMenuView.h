//
//  DTKDropdownMenuView.h
//  duiTiKu
//
//  Created by 吴哲 on 15/11/10.
//  Copyright © 2015年 wu.zhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dropMenuCallBack)(NSUInteger index,id info);

typedef enum : NSUInteger {
    dropDownTypeTitle = 0,//navBar的titleView
    dropDownTypeLeftItem = 1,//leftBarItem
    dropDownTypeRightItem = 2,//rightBarItem
} DTKDropDownType;

@interface DTKDropdownMenuView : UIView

+ (instancetype)dropdownMenuViewWithType:(DTKDropDownType)dropDownType frame:(CGRect)frame dropdownItems:(NSArray *)dropdownItems icon:(NSString *)icon;
+ (instancetype)dropdownMenuViewForNavbarTitleViewWithFrame:(CGRect )frame dropdownItems:(NSArray *)dropdownItems isBlack:(BOOL)isBlackColor;
+ (instancetype)dropdownMenuViewForNavbarTitleViewWithFrame:(CGRect )frame dropdownItems:(NSArray *)dropdownItems;

/// 当前Nav导航栏  
@property(weak ,nonatomic) UINavigationController *currentNav;
/// 当前选中index 默认是0
@property (assign ,nonatomic) NSUInteger selectedIndex;
/// titleColor 标题字体颜色  默认 白色
@property (strong, nonatomic) UIColor *titleColor;
/// titleFont  标题字体  默认 system 17
@property (strong, nonatomic) UIFont  *titleFont;
/// 下拉菜单的宽度  默认80.f
@property (assign, nonatomic) CGFloat dropWidth;
/// 下拉菜单 cell 颜色  默认 白色
@property (strong, nonatomic) UIColor *cellColor;
/// 下拉菜单 cell 字体颜色 默认 白色
@property (strong, nonatomic) UIColor *textColor;
/// 下拉菜单 cell 字体大小 默认 system 17.f
@property (strong, nonatomic) UIFont  *textFont;
/// 下拉菜单 cell seprator color 默认 白色
@property (strong, nonatomic) UIColor *cellSeparatorColor;
/// 下拉菜单 cell accessory check mark color 默认 默认白色
@property (strong, nonatomic) UIColor *cellAccessoryCheckmarkColor;
/// 下拉菜单 cell 高度 默认 40.f
@property (assign, nonatomic) CGFloat cellHeight;
/// 下拉菜单 弹出动画执行时间 默认 0.4s
@property (assign, nonatomic) CGFloat animationDuration;
/// 下拉菜单 cell 是否显示选中按钮  默认 NO
@property (assign, nonatomic) BOOL    showAccessoryCheckmark;
/// 默认幕布透明度 opacity 默认 0.3f
@property (assign, nonatomic) CGFloat backgroundAlpha;
/**下拉ico颜色*/
@property (assign, nonatomic) BOOL    isBlackColor;
-(void)setArrow;
@end

@interface DTKDropdownItem : NSObject
/// 回调 callBack
@property (nonatomic, copy) dropMenuCallBack callBack;
/// title
@property (copy, nonatomic) NSString *title;
/// icon
@property (copy, nonatomic) NSString *iconName;
/// selected
/// info 自定义参数
@property (strong, nonatomic) id info;

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName callBack:(dropMenuCallBack)callBack;
+ (instancetype)itemWithTitle:(NSString *)title callBack:(dropMenuCallBack)callBack;

+ (instancetype)Item;

@end

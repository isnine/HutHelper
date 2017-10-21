//
//  UserInfoCell.h
//  JSHeaderView
//
//  Created by 雷亮 on 16/8/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEXCOLOR(hexValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface UserInfoCell : UITableViewCell

@end

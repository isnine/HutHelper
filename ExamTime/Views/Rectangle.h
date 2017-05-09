//
//  Rectangle.h
//  HutHelper
//
//  Created by Nine on 2017/5/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rectangle : UIView
@property(nonatomic,copy)NSString *day;
- (id)initWithFrame:(CGRect)frame withDay:(NSString*)day;
@end

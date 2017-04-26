//
//  UIColor+SubClass.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/18.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "UIColor+SubClass.h"

@implementation UIColor (SubClass)

+(instancetype)colorWithR:(CGFloat )r g:(CGFloat)g b:(CGFloat)b{
    
    return [self colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

@end

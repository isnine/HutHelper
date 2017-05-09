//
//  Rectangle.m
//  HutHelper
//
//  Created by Nine on 2017/5/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
    }
    
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    //将rect添加到图形上下文中
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    
    //设定颜色
    [[UIColor redColor] setFill];
    [[UIColor yellowColor] setStroke];
    CGContextSetLineWidth(context, 3);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end

//
//  LineUIView.m
//  HutHelper
//
//  Created by Nine on 2017/7/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LineUIView.h"

@implementation LineUIView

- (void)drawRect:(CGRect)rect { // 可以通过 setNeedsDisplay 方法调用 drawRect:
    // Drawing code
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 0.5);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 0, 15.0);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {2,3};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, 350.0,15.0);
    // 绘制
    CGContextStrokePath(context);
    
    // 关闭图像
    CGContextClosePath(context);
    
    
    
}

@end

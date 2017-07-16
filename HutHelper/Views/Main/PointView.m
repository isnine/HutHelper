//
//  PointView.m
//  HutHelper
//
//  Created by Nine on 2017/7/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "PointView.h"

@implementation PointView
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    self.backgroundColor=[UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context =UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, SYReal(10),SYReal(10), SYReal(3), 0,SYReal(3)*3.14, 0); //添加一个圆
    
    CGContextSetFillColorWithColor(context,  [UIColor whiteColor].CGColor);//填充颜色
    CGContextDrawPath(context, kCGPathFill);//绘制填充

}


@end

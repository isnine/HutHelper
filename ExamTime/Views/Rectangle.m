//
//  Rectangle.m
//  HutHelper
//
//  Created by Nine on 2017/5/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Rectangle.h"

@implementation Rectangle

- (id)initWithFrame:(CGRect)frame withDay:(NSString*)day{
    _day=day;
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    //将rect添加到图形上下文中
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    //设定颜色
    [RGB(0,220,224,1) setFill];
    [RGB(0,220,224,1) setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextDrawPath(context, kCGPathFillStroke);
    //还剩
    NSString *text = @"还剩";
    UIFont *textFont = [UIFont systemFontOfSize:SYReal(12)];
    UIColor *textColor = [UIColor whiteColor];
    NSDictionary *attr = @{NSFontAttributeName : textFont,
                           NSForegroundColorAttributeName : textColor};
    [text drawInRect:CGRectMake(rect.origin.x+rect.size.width*1/4,rect.origin.y+SYReal(5),rect.size.width,rect.size.height) withAttributes:attr];
    //day
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height)];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.textColor=[UIColor whiteColor];
    dayLabel.font=[UIFont systemFontOfSize:SYReal(24)];
    dayLabel.text=_day;
    [self addSubview:dayLabel];
    //天
    NSString *text2 = @"天";
    [text2 drawInRect:CGRectMake(rect.origin.x+rect.size.width*3/8,rect.origin.y+rect.size.height*3/4,rect.size.width,rect.size.height) withAttributes:attr];
}


@end

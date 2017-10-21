//
//  WQCalendarDay.m
//  WQCalendar
//
//  Created by Jason Lee on 14-3-4.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayModel.h"

@implementation CalendarDayModel


//公共的方法
+ (CalendarDayModel *)calendarDayWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day
{
    CalendarDayModel *calendarDay = [[CalendarDayModel alloc] init];//初始化自身
    calendarDay.year = year;//年
    calendarDay.month = month;//月
    calendarDay.day = day;//日

    return calendarDay;
}


//返回当前天的NSDate对象
- (NSDate *)date
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
}

//返回当前天的NSString对象
- (NSString *)toString
{
    NSDate *date = [self date];
    NSString *string = [date stringFromDate:date];
    return string;
}


//返回星期
- (NSString *)getWeek
{

    NSDate *date = [self date];
    
    NSString *week_str = [date compareIfTodayWithDate];

    return week_str;
}

//判断是不是同一天
- (BOOL)isEqualTo:(CalendarDayModel *)day
{
    BOOL isEqual = (self.year == day.year) && (self.month == day.month) && (self.day == day.day);
    return isEqual;
}

@end

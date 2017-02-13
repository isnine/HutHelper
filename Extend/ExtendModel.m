//
//  ExtendModel.m
//  HutHelper
//
//  Created by nine on 2017/2/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ExtendModel.h"
#import "Math.h"
@implementation ExtendModel
int startyear                       = 2016;
int startmonth                      = 8;
int startday                        = 29;
+(NSString*)setDay{
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 =(short) [dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    
    return [NSString stringWithFormat:@"%d月%d日 第%d周 星期%@",month,day,[self CountWeeks:year m:month d:day],[self getweek:year m:month d:day]];
}

+(int) CountDays:(int)year m:(int)month d:(int)day{
    //返回当前是本年的第几天，year,month,day 表示现在的年月日，整数。
    int a[12]                                 = {31,0,31,30,31,30,31,31,30,31,30,31};
    int s                                     = 0;
    for(int i           = 0; i < month-1; i++) {s   += a[i];
    }
    if(month > 2) {
        if(year % (year % 100 ? 4 : 400 ) ? 0 : 1)s                                         += 29;
        else
            s                                         += 28;
    }
    return (s + day);
} 
/**
 返回当前是本学期第几周
 
 @param nowyear 现在年份
 @param nowmonth 现在月份
 @param nowday 现在日期
 @return 当前是本学期第几周
 */
+(int) CountWeeks:(int)nowyear m:(int)nowmonth d:(int)nowday {
    //返回当前是本学期第几周，nowyear,nowmonth,nowday 表示现在的年月日，整数。
    int ans                                   = 0;
    if (nowyear == startyear) {
        ans            = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:nowyear m:nowmonth d:nowday] + 1;
        printf("%d\n", ans);
    } else {
        ans         = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:nowyear m:1 d:1] + 1;
        printf("%d\n", ans);
        ans        += [self CountDays:startyear m:12 d:31] - [self CountDays:startyear m:startmonth d:startday]+1;
        printf("%d\n", ans);
    }
    return (ans + 6) / 7;
} //当前第几周


/**
 获得当前是星期几
 
 @param y 年
 @param m 月
 @param d 日
 @return 星期几
 */
+(NSString*) getweek:(int)y m:(int)m d:(int)d{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    switch (iWeek) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"日";
            break;
            
        default:
            return @"";
            break;
    }
}

+(int)getweek_num:(int)y m:(int)m d:(int)d{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
    
}

+(int)getWeek_solution{
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int y                                 = (short)[dateComponent year];//年
    int m                                 =(short) [dateComponent month];//月
    int d                                  = (short)[dateComponent day];//日
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
}
+(Boolean) IfWeeks:(int) dsz  qsz:(int)qsz  jsz:(int) jsz {
    /** nowweek 为的周数，整数
     dsz 为课程是单周上，还是双周上，1为单周，2为双周，0为每周都要上，整数
     qsz 为课程开始的周数，整数
     jsz 为课程结束的周数，整数 **/
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 =(short) [dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    
    int nowweek=[self CountWeeks:year m:month d:day];
    NSLog(@"现在第:%d周",nowweek);
    if (nowweek > jsz)
        return 0;
    if (nowweek < qsz)
        return 0;
    if (dsz == 0)
        return 1;
    return ((nowweek + dsz) % 2 == 0);
}


@end

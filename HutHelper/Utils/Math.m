//
//  Math.m
//  HutHelper
//
//  Created by nine on 2017/1/24.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Math.h"
#import <CommonCrypto/CommonDigest.h>
@implementation Math
int startyear                       = 2017;
int startmonth                      = 9;
int startday                        = 4;
#pragma mark - 日期
/** 返回本年第几天*/
+(int) CountDays:(int)year m:(int)month d:(int)day{
    //返回当前是本年的第几天，year,month,day 表示现在的年月日，整数。
    int a[12]                                 = {31,0,31,30,31,30,31,31,30,31,30,31};
    int s                                     = 0;
    for(int i           = 0; i < month-1; i++) {
        s   += a[i];
    }
    if(month > 2) {
        if(year % (year % 100 ? 4 : 400 ) ? 0 : 1)s                                         += 29;
        else
            s                                         += 28;
    }
    return (s + day);
}  //当前星期几

/**返回当前是本学期第几周 */
+(int) getWeek:(int)nowyear m:(int)nowmonth d:(int)nowday {
    int ans                                   = 0;
    if (nowyear == 2017) {
        ans     = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:startyear m:startmonth d:startday] + 1;
    } else {
        ans         = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:nowyear m:1 d:1] + 1;
        ans        += [self CountDays:2017 m:12 d:31] - [self CountDays:startyear m:startmonth d:startday]+1;
    }
    if ((ans + 6) / 7 <=0) {
        return 1;
    }
    return (ans + 6) / 7;
}
+(int) getWeek{
    NSDate *now                                  = [NSDate date];
    NSCalendar *calendar                         = [NSCalendar currentCalendar];
    NSUInteger unitFlags                         = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent              = [calendar components:unitFlags fromDate:now];
    int y                                     = (short)[dateComponent year];//年
    int m                                    = (short)[dateComponent month];//月
    int d                                      = (short)[dateComponent day];//日
    return [self getWeek:y m:m d:d];
}
/** 获得当前是星期几 */
+(int) getWeekDay:(int)y m:(int)m d:(int)d{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
}
/** 得到当前为几号 */
+(int) getDayOfWeek:(int)week d:(int)day {
    day=[self CountDays:2017 m:9 d:4]+(week-1)*7+day;
    int year=startyear;
    int d=0,m,leap,i;
    int Month[12]={31,28,31,30,31,30,31,31,30,31,30,31};
    
    if( (year%4!=0) ||( (year%100==0)&& (year%400!=0)))
        leap=0;//不是闰年
    else
        leap=1;//是闰年
    
    if(leap==1)
        Month[1]=29;//闰年二月29天
    m=1;
    for(i=0;i<12;i++)
    {
        d=day-Month[i];
        if(d>0)
        {
            day=d;
            m++;//月数加1
        }
        
        else
        {
            d = d+Month[i];
            break;
        }
    }
    return  d;
}
+(int)getWeekDay{
    NSDate *now                                  = [NSDate date];
    NSCalendar *calendar                         = [NSCalendar currentCalendar];
    NSUInteger unitFlags                         = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent              = [calendar components:unitFlags fromDate:now];
    int y                                     = (short)[dateComponent year];//年
    int m                                    = (short)[dateComponent month];//月
    int d                                      = (short)[dateComponent day];//日
    return [self getWeekDay:y m:m d:d];
}

/**返回是否是本周课程*/
+(BOOL)IfWeeks:(int)nowweek  dsz:(int)dsz  qsz:(int)qsz jsz:(int)jsz {
    /** nowweek 为的周数，整数
     dsz 为课程是单周上，还是双周上，1为单周，2为双周，0为每周都要上，整数
     qsz 为课程开始的周数，整数
     jsz 为课程结束的周数，整数 **/
    if (nowweek > jsz)
        return 0;
    if (nowweek < qsz)
        return 0;
    if (dsz == 0)
        return 1;
    return ((nowweek + dsz) % 2 == 0);
}
+(NSString*)transforDay:(int)day{
    switch (day) {
        case 1:
            return @"一";
        case 2:
            return @"二";
        case 3:
            return @"三";
        case 4:
            return @"四";
        case 5:
            return @"五";
        case 6:
            return @"六";
        case 7:
            return @"日";
        default:
            return @"*";
            break;
    }
}
/**返回是两个日期之间天数*/
+(int)getDateDiff:(int)y2 m:(int)m2 d:(int)d2
{
    NSDate *now                                  = [NSDate date];
    NSCalendar *calendar                         = [NSCalendar currentCalendar];
    NSUInteger unitFlags                         = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent              = [calendar components:unitFlags fromDate:now];
    int y                                     = (short)[dateComponent year];//年
    int m                                    = (short)[dateComponent month];//月
    int d                                      = (short)[dateComponent day];//日
    
    struct tm ptr1;
    ptr1.tm_sec=10;
    ptr1.tm_min=10;
    ptr1.tm_hour=10;
    ptr1.tm_mday=d;
    ptr1.tm_mon=m-1;
    ptr1.tm_year=y-1900;
    time_t st1=mktime(&ptr1);
    struct tm ptr2;
    ptr2.tm_sec=10;
    ptr2.tm_min=10;
    ptr2.tm_hour=10;
    ptr2.tm_mday=d2;
    ptr2.tm_mon=m2-1;
    ptr2.tm_year=y2-1900;
    time_t st2=mktime(&ptr2);
    return (int)((st2-st1)/3600/24);
}
@end

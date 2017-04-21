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
int startmonth                      = 2;
int startday                        = 20;
#pragma mark - 加密
+ (NSString*)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
+(NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}
#pragma mark - 日期
/**
 返回本年第几天
 */
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
}  //当前星期几

/**
 返回当前是本学期第几周
 */
+(int) getWeek:(int)nowyear m:(int)nowmonth d:(int)nowday {
    int ans                                   = 0;
    if (nowyear == 2017) {
        ans     = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:2017 m:2 d:20] + 1;
    } else {
        ans         = [self CountDays:nowyear m:nowmonth d:nowday] - [self CountDays:nowyear m:1 d:1] + 1;
        ans        += [self CountDays:2017 m:12 d:31] - [self CountDays:2017 m:2 d:20]+1;
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
/**
 获得当前是星期几
 */
+(int) getWeekDay:(int)y m:(int)m d:(int)d{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
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

/**
 返回是否是本周课程
 */
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
            return @"七";
        default:
            return @"*";
            break;
    }
}
@end

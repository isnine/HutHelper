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
#pragma mark -加密
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

#pragma mark -日期
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
+(int) getweek:(int)y m:(int)m d:(int)d{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
}

@end

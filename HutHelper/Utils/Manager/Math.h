//
//  Math.h
//  HutHelper
//
//  Created by nine on 2017/1/24.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject
/**加密*/
+ (NSString*)sha1:(NSString *)input;
+ (NSString *)md5:(NSString *)input;
/**时间*/
+ (int) getWeek:(int)nowyear m:(int)nowmonth d:(int)nowday;
+ (int) getWeek;
+ (int) CountDays:(int)year m:(int)month d:(int)day;

+ (int) getWeekDay:(int)y m:(int)m d:(int)d;
+ (int) getWeekDay;

+ (BOOL)IfWeeks:(int)nowweek  dsz:(int)dsz  qsz:(int)qsz jsz:(int)jsz;

@end

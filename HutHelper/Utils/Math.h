//
//  Math.h
//  HutHelper
//
//  Created by nine on 2017/1/24.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject
/**时间*/
+ (int) getWeek:(int)nowyear m:(int)nowmonth d:(int)nowday;
+ (int) getWeek;
+ (int) CountDays:(int)year m:(int)month d:(int)day;

+(int) getDayOfWeek:(int)week d:(int)day;
+ (int) getWeekDay:(int)y m:(int)m d:(int)d;
+ (int) getWeekDay;

+ (BOOL)IfWeeks:(int)nowweek  dsz:(int)dsz  qsz:(int)qsz jsz:(int)jsz;
/**字符串*/
+(NSString*)transforDay:(int)day;
+(int)getDateDiff:(int)y2 m:(int)m2 d:(int)d2;
@end

//
//  Math.h
//  HutHelper
//
//  Created by nine on 2017/1/24.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject
+(int) CountWeeks:(int)nowyear m:(int)nowmonth d:(int)nowday;
+(int) CountDays:(int)year m:(int)month d:(int)day;
+(int) getweek:(int)y m:(int)m d:(int)d;
+ (NSString*)sha1:(NSString *)input;
@end

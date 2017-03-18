//
//  ExtendModel.h
//  HutHelper
//
//  Created by nine on 2017/2/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtendModel : NSObject
+(NSString*)setDay;
+(int)getWeekDay_num:(int)y m:(int)m d:(int)d;
+(Boolean) IfWeeks:(int) dsz  qsz:(int)qsz  jsz:(int) jsz ;
+(int)getWeekDay_solution;
@end

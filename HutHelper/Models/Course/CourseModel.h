//
//  CourseModel.h
//  CourseList
//
//  Created by GanWenPeng on 15/12/4.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

/**
 不一定非得用这个模型，只要模型遵守Course协议即可
 
 */
#import <Foundation/Foundation.h>
#import "GWPCourseListView.h"


@interface CourseModel : NSObject<Course>
/** 课程名 */
@property (nonatomic, copy)   NSString   *courseName;
/** 课程显示时的文字属性，用来控制颜色、大小等 */
@property (nonatomic, strong) NSDictionary *nameAttribute;
/** 一周中的第几天？即周几 */
@property (nonatomic, assign) NSUInteger dayIndex;
/** 开始时间(第几节开始) */
@property (nonatomic, assign) NSUInteger startCourseIndex;
/** 结束时间(第几节结束) */
@property (nonatomic, assign) NSUInteger endCourseIndex;
/** 位置Index */
@property (nonatomic, assign) NSUInteger sortIndex;


+ (instancetype)courseWithName:(NSString *)name
                      dayIndex:(NSUInteger)dayIndex
              startCourseIndex:(NSUInteger)startCourseIndex
                endCourseIndex:(NSUInteger)endCourseIndex;

+ (instancetype)courseWithName:(NSString *)name
                 nameAttribute:(NSDictionary*)nameAttribute
                      dayIndex:(NSUInteger)dayIndex
              startCourseIndex:(NSUInteger)startCourseIndex
                endCourseIndex:(NSUInteger)endCourseIndex;
@end

//
//  CourseModel.m
//  CourseList
//
//  Created by GanWenPeng on 15/12/4.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel
+ (instancetype)courseTeacher:(NSString *)teacher
                   courseRoom:(NSString *)room
               courseWithName:(NSString *)name
                     dayIndex:(NSUInteger)dayIndex
             startCourseIndex:(NSUInteger)startCourseIndex
               endCourseIndex:(NSUInteger)endCourseIndex
                   courseWeek:(NSArray*)courseWeek{
    CourseModel *model = [[self alloc] init];
    model.courseTeacher = teacher;
    model.courseRoom = room;
    model.courseName = name;
    model.dayIndex = dayIndex;
    model.startCourseIndex = startCourseIndex;
    model.endCourseIndex = endCourseIndex;
    model.courseWeek = courseWeek;
    model.sortIndex = 0;
    return model;
}

+ (instancetype)courseTeacher:(NSString *)teacher
                   courseRoom:(NSString *)room
               courseWithName:(NSString *)name
                nameAttribute:(NSDictionary *)nameAttribute
                     dayIndex:(NSUInteger)dayIndex
             startCourseIndex:(NSUInteger)startCourseIndex
               endCourseIndex:(NSUInteger)endCourseIndex
                   courseWeek:(NSArray *)courseWeek{
    CourseModel *model = [CourseModel courseTeacher:teacher courseRoom:room courseWithName:name dayIndex:dayIndex startCourseIndex:startCourseIndex endCourseIndex:endCourseIndex courseWeek:courseWeek];
    //CourseModel *model = [CourseModel  courseWithName:name dayIndex:dayIndex startCourseIndex:startCourseIndex endCourseIndex:endCourseIndex];
    model.nameAttribute = nameAttribute;
    
    return model;
}
@end

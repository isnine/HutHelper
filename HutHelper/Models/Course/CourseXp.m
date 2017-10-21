//
//  CourseXp.m
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CourseXp.h"

@implementation CourseXp
-(instancetype)initWithDic:(NSDictionary*)dic{
    self=[super init];
    if (self) {
        self.lesson=dic[@"lesson"];
        self.lesson_no=dic[@"lesson_no"];
        self.locate=dic[@"locate"];
        self.obj=dic[@"obj"];
        self.period=dic[@"period"];
        self.real_time=dic[@"real_time"];
        self.teacher=dic[@"teacher"];
        self.week=dic[@"week"];
        self.weeks_no=dic[@"weeks_no"];
    }
    return self;
}
@end

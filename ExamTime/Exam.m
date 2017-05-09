//
//  Exam.m
//  HutHelper
//
//  Created by nine on 2017/5/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Exam.h"

@implementation Exam
-(instancetype)initWithDic:(NSDictionary*)Dic{
    self=[super init];
    if (self) {
        NSString *RoomName=Dic[@"RoomName"];//考试教室
        NSString *CourseName=Dic[@"CourseName"];//考试名称
        NSString *Starttime=Dic[@"Starttime"];//开始时间
        NSString *isset=Dic[@"isset"];//考试状态
        NSString *EndTime=Dic[@"EndTime"];//结束时间
        /**避免信息为NULL的情况*/
        if ([RoomName isEqual:[NSNull null]])   RoomName  = @"-";//起始周
        if ([CourseName isEqual:[NSNull null]])  CourseName= @"-";
        if ([Starttime isEqual:[NSNull null]])   Starttime = @"-";
        if ([EndTime isEqual:[NSNull null]])   EndTime = @"-";
        if ([isset isEqual:[NSNull null]])        isset   = @"-";
        self.CourseName=CourseName;
        self.EndTime=EndTime;
        self.RoomName=RoomName;
        self.Starttime=Starttime;
        self.isset=isset;
    }
    return  self;
}
-(instancetype)initWithCXDic:(NSDictionary*)Dic{
    self=[super init];
    if (self) {
        NSString *RoomName=Dic[@"RoomName"];//考试教室
        NSString *CourseName=Dic[@"CourseName"];//考试名称
        NSString *Starttime=Dic[@"Starttime"];//开始时间
        NSString *isset=Dic[@"isset"];//考试状态
        NSString *EndTime=Dic[@"EndTime"];//结束时间
        /**避免信息为NULL的情况*/
        if ([RoomName isEqual:[NSNull null]])   RoomName  = @"-";//起始周
        if ([CourseName isEqual:[NSNull null]])  CourseName= @"-";
        if ([Starttime isEqual:[NSNull null]])   Starttime = @"-";
        if ([EndTime isEqual:[NSNull null]])   EndTime = @"-";
        if ([isset isEqual:[NSNull null]])        isset   = @"-";
        self.CourseName=[NSString stringWithFormat:@"【重修】%@",CourseName];
        self.EndTime=EndTime;
        self.RoomName=RoomName;
        self.Starttime=Starttime;
        self.isset=isset;
    }
    return  self;
}


@end

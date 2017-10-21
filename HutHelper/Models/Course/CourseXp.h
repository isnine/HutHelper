//
//  CourseXp.h
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseXp : NSObject
-(instancetype)initWithDic:(NSDictionary*)dic;

@property(nonatomic,strong)NSString* lesson;      //课程内容
@property(nonatomic,strong)NSString* lesson_no;   //第几节
@property(nonatomic,strong)NSString* locate;      //地点
@property(nonatomic,strong)NSString* obj;         //具体内容
@property(nonatomic,strong)NSString* period;      //节数
@property(nonatomic,strong)NSString* real_time;   //开始时间
@property(nonatomic,strong)NSString* teacher;     //老师
@property(nonatomic,strong)NSString* week;        //周次
@property(nonatomic,strong)NSString* weeks_no;    //周数
@end

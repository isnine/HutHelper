//
//  CourseXpTableViewCell.m
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CourseXpTableViewCell.h"
#import "CourseXp.h"
@implementation CourseXpTableViewCell
static const int kTextSizeLabel=14;

static const int kLeftLabel = 15;
static const int kLeftShowLabel = 100;
static const int kLengthShowLabel = 299;

static const int kTopLabel = 10;
static const int kTopCourseNameDataLabel = kTopLabel+25;
static const int kTopObjLabel = kTopCourseNameDataLabel+25;
static const int kTopBackgroundImageView = kTopObjLabel+25;
static const int kTopCourseTimeLabel = kTopBackgroundImageView+10;
static const int kTopBackgroundImageView2 = kTopCourseTimeLabel+25;
static const int kTopCourseTeacher = kTopBackgroundImageView2+10;
static const int kTopBackgroundImageView3 = kTopCourseTeacher+25;
static const int kTopCourseLocation = kTopBackgroundImageView3+10;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)draw{
    //课程名称
    UILabel *courseName=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopLabel), SYReal(80), SYReal(20))];
    courseName.text=@"课程名称";
    courseName.font=[UIFont systemFontOfSize:kTextSizeLabel];
    courseName.textColor=RGB(190, 190, 190, 1);
    [self addSubview:courseName];
    //课程名称数据
    UILabel *courseNameData=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopCourseNameDataLabel), SYReal(230), SYReal(20))];
    courseNameData.text=_data.lesson;
    courseNameData.font=[UIFont systemFontOfSize:15];
    [self addSubview:courseNameData];
    //课程具体名称数据
    UILabel *objData=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopObjLabel), SYReal(230), SYReal(20))];
    objData.text=_data.obj;
    objData.textColor=RGB(115, 221, 221, 1);
    objData.font=[UIFont systemFontOfSize:15];
    [self addSubview:objData];
    //灰色背景
    UIImageView *background=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopBackgroundImageView), SYReal(384), SYReal(1))];
    background.backgroundColor=RGB(224, 224, 224, 1);
    [self addSubview:background];
    //课程时间
    UILabel *courseTime=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopCourseTimeLabel), SYReal(80), SYReal(20))];
    courseTime.text=@"课程名称";
    courseTime.font=[UIFont systemFontOfSize:kTextSizeLabel];
    courseTime.textColor=RGB(190, 190, 190, 1);
    [self addSubview:courseTime];
    //课程时间数据
    UILabel *courseTimeData=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftShowLabel), SYReal(kTopCourseTimeLabel), SYReal(kLengthShowLabel), SYReal(20))];
    courseTimeData.text=[NSString stringWithFormat:@"%@周-星期%@ %@",_data.weeks_no,_data.week,_data.real_time];
    courseTimeData.textAlignment = NSTextAlignmentRight;
    courseTimeData.font=[UIFont systemFontOfSize:15];
    [self addSubview:courseTimeData];
    //灰色背景
    UIImageView *background2=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopBackgroundImageView2), SYReal(384), SYReal(1))];
    background2.backgroundColor=RGB(224, 224, 224, 1);
    [self addSubview:background2];
    //教师
    UILabel *courseTeacher=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopCourseTeacher), SYReal(80), SYReal(20))];
    courseTeacher.text=@"教师";
    courseTeacher.font=[UIFont systemFontOfSize:kTextSizeLabel];
    courseTeacher.textColor=RGB(190, 190, 190, 1);
    [self addSubview:courseTeacher];
    //教师数据
    UILabel *courseTeacherData=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftShowLabel), SYReal(kTopCourseTeacher), SYReal(kLengthShowLabel), SYReal(20))];
    courseTeacherData.text=_data.teacher;
    courseTeacherData.textAlignment = NSTextAlignmentRight;
    courseTeacherData.font=[UIFont systemFontOfSize:15];
    [self addSubview:courseTeacherData];
    //灰色背景
    UIImageView *background3=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopBackgroundImageView3), SYReal(384), SYReal(1))];
    background3.backgroundColor=RGB(224, 224, 224, 1);
    [self addSubview:background3];
    //地点
    UILabel *courseLocation=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftLabel), SYReal(kTopCourseLocation), SYReal(80), SYReal(20))];
    courseLocation.text=@"教师";
    courseLocation.font=[UIFont systemFontOfSize:kTextSizeLabel];
    courseLocation.textColor=RGB(190, 190, 190, 1);
    [self addSubview:courseLocation];
    //地点数据
    UILabel *courseLocationData=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLeftShowLabel), SYReal(kTopCourseLocation), SYReal(kLengthShowLabel), SYReal(20))];
    courseLocationData.text=_data.locate;
    courseLocationData.textAlignment = NSTextAlignmentRight;
    courseLocationData.font=[UIFont systemFontOfSize:15];
    [self addSubview:courseLocationData];
    
}
@end

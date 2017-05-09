//
//  TodayViewController.m
//  ExamTime
//
//  Created by nine on 2017/5/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JSONKit.h"
#import "Exam.h"
#import "Rectangle.h"
@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *arraycx;
@property (nonatomic, retain) NSMutableArray *arrayExam;
@end

@implementation TodayViewController
static const int kLabelLeft=20;//距左
static const int kLabel_CourseName_Top=23;//距上
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayExam=[[NSMutableArray alloc]init];
    [self addExam];
    [self showLabel];
}
-(void)addExam{
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    if (defaults&&([defaults objectForKey:@"kCourse"]!=NULL)) {
        NSDictionary *Class_Data=[defaults objectForKey:@"Exam"];
        [self loadData:[Class_Data objectForKey:@"exam"]];
        [self loadCXData:[Class_Data objectForKey:@"cxexam"]];
        
        NSLog(@"%@",_arrayExam[0]);
    }
}
-(void)showLabel{
    Exam *exam=_arrayExam[0];
    /**课程名称*/
    UILabel *courseName=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabelLeft),SYReal(kLabel_CourseName_Top), SYReal(374), SYReal(20))];
    courseName.text=exam.CourseName;
    courseName.font =[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:courseName];
    /**课程时间*/
    UILabel *courseTime=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabelLeft+15),SYReal(kLabel_CourseName_Top+23), SYReal(394), SYReal(20))];
    courseTime.text=exam.Starttime;
    courseTime.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:courseTime];
    /**课程地点*/
    UILabel *courseRoom=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabelLeft+15),SYReal(kLabel_CourseName_Top+46), SYReal(394), SYReal(20))];
    courseRoom.text=exam.RoomName;
    courseRoom.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:courseRoom];
    
    Rectangle *a=[[Rectangle alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    [self.view addSubview:a];

    
}
-(void)loadData:(NSMutableArray*)array{
    for (NSDictionary *Dic in array) {
        Exam *exam=[[Exam alloc]initWithDic:Dic];
        if ([self getTime:exam.Starttime]>=0) {
            [_arrayExam addObject:exam];
        }
    }
}
-(void)loadCXData:(NSMutableArray*)array{
    for (NSDictionary *Dic in array) {
        Exam *exam=[[Exam alloc]initWithCXDic:Dic];
        if ([self getTime:exam.Starttime]>=0) {
            [_arrayExam addObject:exam];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}
int datediff(int y1,int m1,int d1,int y2,int m2,int d2)
{
    struct tm ptr1;
    ptr1.tm_sec=10;
    ptr1.tm_min=10;
    ptr1.tm_hour=10;
    ptr1.tm_mday=d1;
    ptr1.tm_mon=m1-1;
    ptr1.tm_year=y1-1900;
    time_t st1=mktime(&ptr1);
    struct tm ptr2;
    ptr2.tm_sec=10;
    ptr2.tm_min=10;
    ptr2.tm_hour=10;
    ptr2.tm_mday=d2;
    ptr2.tm_mon=m2-1;
    ptr2.tm_year=y2-1900;
    time_t st2=mktime(&ptr2);
    return (int)((st2-st1)/3600/24);
}
-(int)getTime:(NSString*)starttime{
    /**计算倒计时*/
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 = (short)[dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    int Year=[[starttime substringWithRange:NSMakeRange(0,4)] intValue];
    int Mouth=[[starttime substringWithRange:NSMakeRange(5,2)] intValue];
    int Day=[[starttime substringWithRange:NSMakeRange(8,2)] intValue];
    return datediff(year, month, day, Year, Mouth, Day);
}
-(NSString*)getTimeString:(int)Time{
    if (Time>0&&Time<500) {
        return [[NSString alloc]initWithFormat:@"倒计时%d天",Time];
    }
    else if (Time<0){
        return @"已结束";
    }
    else if (Time==0){
        return @"今天考试";
    }else{
        return @"-";
    }
}
- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = (width + height) * 0.05;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextDrawPath(context, kCGPathFill);
}


@end

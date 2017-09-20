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
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayExam=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    if (defaults&&([defaults objectForKey:@"Exam"]!=NULL)) {
        [self addExam];
        if(_arrayExam.count>0){
            [self showLabel:(23) withArray:0];
        }else{
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake((10),(30),SYReal(370), (20))];
            notice.text=@"所有考试已结束";
            notice.textColor=[UIColor darkGrayColor];
            notice.textAlignment = NSTextAlignmentCenter;
            notice.font =[UIFont systemFontOfSize:SYReal(21)];
            [self.view addSubview:notice];
        }
    }else{
        UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake((10),(30),SYReal(370), (20))];
        notice.text=@"没有考试数据";
        notice.textColor=[UIColor darkGrayColor];
        notice.textAlignment = NSTextAlignmentCenter;
        notice.font =[UIFont systemFontOfSize:SYReal(21)];
        [self.view addSubview:notice];
        UILabel *notice2=[[UILabel alloc]initWithFrame:CGRectMake((10),(60),SYReal(370), (20))];
        notice2.textAlignment = NSTextAlignmentCenter;
        notice2.textColor=[UIColor darkGrayColor];
        notice2.text=@"打开工大助手的考试计划来获取数据";
        notice2.font =[UIFont systemFontOfSize:SYReal(19)];
        [self.view addSubview:notice2];
    }
}
-(void)addExam{
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    if (defaults&&([defaults objectForKey:@"Exam"]!=NULL)) {
        NSDictionary *Class_Data=[defaults objectForKey:@"Exam"];
        [self loadData:[Class_Data objectForKey:@"exam"]];
        [self loadCXData:[Class_Data objectForKey:@"cxexam"]];
    }
}
-(void)showLabel:(int)kLabel_CourseName_Top withArray:(int)num{
    Exam *exam=_arrayExam[num];
    /**课程名称*/
    UILabel *courseName=[[UILabel alloc]initWithFrame:CGRectMake((kLabelLeft),(kLabel_CourseName_Top),SYReal(300), (20))];
    courseName.text=exam.CourseName;
    courseName.font =[UIFont boldSystemFontOfSize:16];
    [self.view addSubview:courseName];
    /**课程时间*/
    UIImageView *icoTime=[[UIImageView alloc]initWithFrame:CGRectMake((kLabelLeft),(kLabel_CourseName_Top+27), (13), (13))];
    icoTime.image=[UIImage imageNamed:@"ico_widget_time"];
    [self.view addSubview:icoTime];
    UILabel *courseTime=[[UILabel alloc]initWithFrame:CGRectMake((kLabelLeft+15),(kLabel_CourseName_Top+23), (394), (20))];
    courseTime.text=exam.Starttime;
    courseTime.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:courseTime];
    /**课程地点*/
    UIImageView *icoLocation=[[UIImageView alloc]initWithFrame:CGRectMake((kLabelLeft),(kLabel_CourseName_Top+49), (13), (13))];
    icoLocation.image=[UIImage imageNamed:@"ico_widget_location"];
    [self.view addSubview:icoLocation];
    
    UILabel *courseRoom=[[UILabel alloc]initWithFrame:CGRectMake((kLabelLeft+15),(kLabel_CourseName_Top+46), (394), (20))];
    courseRoom.text=exam.RoomName;
    courseRoom.font =[UIFont systemFontOfSize:13];
    [self.view addSubview:courseRoom];
    /**矩形框*/
    Rectangle *rectangle;
    if ([exam.Starttime isEqualToString:@"-"]){
        rectangle=[[Rectangle alloc]initWithFrame:CGRectMake(SYReal(330),(kLabel_CourseName_Top),SYReal(50), SYReal(65)) withDay:@"-"];
    }else{
        rectangle=[[Rectangle alloc]initWithFrame:CGRectMake(SYReal(330),(kLabel_CourseName_Top),SYReal(50), SYReal(65)) withDay:[self getTimeString:[self getTime:exam.Starttime]]];
    }
    
    [self.view addSubview:rectangle];
}
#pragma mark - 添加数据
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,(110));
    }else{
        if (_arrayExam.count>=3) {
            self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,(280));
            [self showLabel:(115) withArray:1];
            [self showLabel:(200) withArray:2];
        }else if(_arrayExam.count==2){
            self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,(190));
            [self showLabel:(115) withArray:1];
        }else{
            
        }
    }
    
}
#pragma mark - 计算倒计时
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
        return [[NSString alloc]initWithFormat:@"%d",Time];
    }else{
        return @"-";
    }
}

@end

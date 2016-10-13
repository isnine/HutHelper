//
//  ClassViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/11.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ClassViewController.h"
#import "GWPCourseListView.h"
#import "CourseModel.h"
#import "JSONKit.h"

@interface ClassViewController ()<GWPCourseListViewDataSource, GWPCourseListViewDelegate>
@property (weak, nonatomic) IBOutlet GWPCourseListView *courseListView;
@property (nonatomic, strong) NSArray<CourseModel*> *courseArr;

@end

@implementation ClassViewController

const int startyear = 2016;
const int startmonth = 8;
const int startday = 29;

int CountDays(int year, int month, int day) {
    //返回当前是本年的第几天，year,month,day 表示现在的年月日，整数。
    int a[12] = {31,0,31,30,31,30,31,31,30,31,30,31};
    int s = 0;
    for(int i = 0; i < month-1; i++) {
        s += a[i];
    }
    if(month > 2) {
        if(year % (year % 100 ? 4 : 400 ) ? 0 : 1)
            s += 29;
        else
            s += 28;
    }
    return (s + day);
}

int CountWeeks(int nowyear, int nowmonth, int nowday) {
    //返回当前是本学期第几周，nowyear,nowmonth,nowday 表示现在的年月日，整数。
    int ans = 0;
    if (nowyear == startyear) {
        ans = CountDays(nowyear, nowmonth, nowday) - CountDays(startyear, startmonth, startday) + 1;
        printf("%d\n", ans);
    } else {
        ans = CountDays(nowyear, nowmonth, nowday) - CountDays(nowyear, 1, 1) + 1;
        printf("%d\n", ans);
        ans += (CountDays(startyear, 12, 31) - CountDays(startyear, startmonth, startday) + 1);
        printf("%d\n", ans);
    }
    return (ans + 6) / 7;
}

_Bool IfWeeks(int nowweek, int dsz, int qsz, int jsz) {
    /** nowweek 为的周数，整数
     dsz 为课程是单周上，还是双周上，1为单周，2为双周，0为每周都要上，整数
     qsz 为课程开始的周数，整数
     jsz 为课程结束的周数，整数 **/
    if (nowweek > jsz)
        return 0;
    if (nowweek < qsz)
        return 0;
    if (dsz == 0)
        return 1;
    return ((nowweek + dsz) % 2 == 0);
}

- (NSArray<CourseModel *> *)courseArr{
    //-------判断第几周---------//
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year]; //年
    int month = [dateComponent month]; //月
    int day = [dateComponent day];  //日
    //判断完毕//
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"array"];
    
 
    int i;
    
    CourseModel *a1 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a2 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a3 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a4 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a5 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a6 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a7 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a8 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a9 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a10 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a11 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a12 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a13 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a14 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a15 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a16 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a17 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a18 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a19 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a20 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a21 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a22 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a23 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a24 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a25 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a26 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a27 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];

    int day1=1,day2=1,day3=1,day4=1,day5=1,day6=1;
   for (i=0; i<=(array.count-1); i++) {
        NSDictionary *dict1 = array[i];
        NSString *ClassName = [dict1 objectForKey:@"name"];  //课名
        NSString *dsz = [dict1 objectForKey:@"dsz"];  //单双周
        NSInteger *dsz_num= [dsz intValue];
        if ([dsz isEqualToString: @"单"])
            dsz_num=1;
        else if([dsz isEqualToString: @"双"])
            dsz_num=2;
        else
            dsz_num=0;
        NSString *StartClass = [dict1 objectForKey:@"djj"]; //第几节
        NSInteger *StartClass_num= [StartClass intValue];
        NSString *EndWeek = [dict1 objectForKey:@"jsz"];  //结束周
        NSInteger *EndWeek_num= [EndWeek intValue];
        NSString *StartWeek = [dict1 objectForKey:@"qsz"];  //起始周
        NSInteger *StartWeek_num= [StartWeek intValue];
        NSString *Room = [dict1 objectForKey:@"room"];  //教室
        NSString *Teacher = [dict1 objectForKey:@"teacher"];  //老师
        NSString *WeekDay = [dict1 objectForKey:@"xqj"];  //第几天
        NSInteger *WeekDay_num= [WeekDay intValue];
    NSInteger *ab=1;

       NSInteger *EndClass= (short)StartClass_num + 1;

        NSInteger *noweeks=CountWeeks(year,month,day);
        IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num);
        

       ClassName=[ClassName stringByAppendingString:@"\n@"];
       ClassName=[ClassName stringByAppendingString:Room];

       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)){
           if(StartClass_num==1){
               switch (day1) {
                   case 1:
                      a1 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day1++;
                    break;
                   case 2:
                       a2 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day1++;
                       break;
                   case 3:
                       a3 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day1++;
                       break;
                   case 4:
                       a4 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day1++;
                       break;
                   case 5:
                       a5 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day1++;
                       break;
                   default:
                       break;
               }

           }
           if(StartClass_num==3){
               switch (day2) {
                   case 1:
                       a6 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day2++;
                       break;
                   case 2:
                       a7 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day2++;
                       break;
                   case 3:
                       a8 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day2++;
                       break;
                   case 4:
                       a9 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day2++;
                       break;
                   case 5:
                       a10 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day2++;
                       break;
                   default:
                       break;
               }
               
           }
           if(StartClass_num==5){
               switch (day3) {
                   case 1:
                       a11 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day3++;
                       break;
                   case 2:
                       a12 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day3++;
                       break;
                   case 3:
                       a13 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day3++;
                       break;
                   case 4:
                       a14 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day3++;
                       break;
                   case 5:
                       a15 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day3++;
                       break;
                   default:
                       break;
               }
               
           }
           if(StartClass_num==7){
               switch (day4) {
                   case 1:
                       a16 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day4++;
                       break;
                   case 2:
                       a17 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day4++;
                       break;
                   case 3:
                       a18 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day4++;
                       break;
                   case 4:
                       a19 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day4++;
                       break;
                   case 5:
                       a20 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day4++;
                       break;
                   default:
                       break;
               }
               
           }
           if(StartClass_num==9){
               switch (day5) {
                   case 1:
                       a21 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day5++;
                       break;
                   case 2:
                       a22 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day5++;
                       break;
                   case 3:
                       a23 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day5++;
                       break;
                   case 4:
                       a24 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day5++;
                       break;
                   case 5:
                       a25 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                       day5++;
                       break;
                   default:
                       break;
               }
               
           }
       }
    }
    _courseArr = @[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25];

    return _courseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //-------判断第几周---------//
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year]; //年
    int month = [dateComponent month]; //月
    int day = [dateComponent day];  //日
    NSLog(@"%d",CountWeeks(year,month,day));
    NSString *nowweek=@"第";
    NSString *now2=[NSString stringWithFormat:@"%d",CountWeeks(year,month,day)];
    nowweek=[nowweek stringByAppendingString:now2];
    nowweek=[nowweek stringByAppendingString:@"周"];
    //-------判断第几周OVER---------//
   self.navigationItem.title = nowweek;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GWPCourseListViewDataSource
- (NSArray<id<Course>> *)courseForCourseListView:(GWPCourseListView *)courseListView{
    return self.courseArr;
}

#pragma mark - GWPCourseListViewDelegate
- (void)courseListView:(GWPCourseListView *)courseListView didSelectedCourse:(id<Course>)course{
    
}
@end

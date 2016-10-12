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
    NSString *studentKH=[defaults objectForKey:@"studentKH"];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
    NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/lessons/";
    NSString *Url_String_2=@"/";
    
    NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:studentKH];
    NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
    NSString *Url_String=[Url_String_1_U_2 stringByAppendingString:remember_code_app];
    /*地址完毕*/
    NSURL *url = [NSURL URLWithString: Url_String]; //接口地址
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *Class_All = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *Class_Data=[Class_All objectForKey:@"data"];
    NSString *name=[Class_All objectForKey:@"data"];
    
    NSArray *array = [Class_All objectForKey:@"data"];
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
    CourseModel *a28 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a29 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a30 = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
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
        
        NSLog(@"课程名:%@",ClassName);
       ClassName=[ClassName stringByAppendingString:@"@"];
       ClassName=[ClassName stringByAppendingString:Room];
        NSLog(@"教室:%@",Room);
        NSLog(@"第几天:%@",WeekDay);
        NSLog(@"第几节:%d",StartClass_num);
    NSLog(@"结束:%d",EndClass);
        NSLog(@"起始周%@",StartWeek);
        NSLog(@"结束周:%@",EndWeek);
        NSLog(@"单双周:%d",dsz_num);
        NSLog(@"老师:%@",Teacher);
        NSLog(@"该课程，当前是否为本周:%d",IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num));
       

     if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==0){
         a1 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
         }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==1){
           a2 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==2){
           a3 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==3){
           a4 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==4){
           a5 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==5){
           a6 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==6){
           a7 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==7){
           a8 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==8){
           a9 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==9){
           a10 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==10){
           a11 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==11){
           a12 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==12){
           a13 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==13){
           a14 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==14){
           a15 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==15){
           a16 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==16){
           a17 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==17){
           a18 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==18){
           a19 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==19){
           a20 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==20){
           a21 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==21){
           a22 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==22){
           a23 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==23){
           a24 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==24){
           a25 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==25){
           a26 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==26){
           a27 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==27){
           a28 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==28){
           a29 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
       if(IfWeeks(CountWeeks(year,month,day),dsz_num,StartWeek_num,EndWeek_num)&&i==29){
           a30 = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
       }
    }
    _courseArr = @[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30];

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

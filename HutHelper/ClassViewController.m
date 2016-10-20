//
//  ViewController.m
//  CourseList
//
//  Created by GanWenPeng on 15/12/3.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

#import "ClassViewController.h"
#import "GWPCourseListView.h"
#import "CourseModel.h"
#import "LGPlusButtonsView.h"
#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"

@interface ClassViewController ()<GWPCourseListViewDataSource, GWPCourseListViewDelegate>
@property (weak, nonatomic) IBOutlet GWPCourseListView *courseListView;
@property (nonatomic, strong) NSMutableArray<CourseModel*> *courseArr;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIView            *exampleView;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewNavBar;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewExample;
@end

@implementation ClassViewController

int getweekday(){
    NSDate *now                                  = [NSDate date];
    NSCalendar *calendar                         = [NSCalendar currentCalendar];
    NSUInteger unitFlags                         = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent              = [calendar components:unitFlags fromDate:now];
    int y                                     = [dateComponent year];//年
    int m                                    = [dateComponent month];//月
    int d                                      = [dateComponent day];//日
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    return iWeek;
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

int now_week;
int now_xp=0;
- (NSMutableArray<CourseModel *> *)courseArr{
    
    if (!_courseArr) {
      
    }
    return _courseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题//
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
  now_week=[defaults integerForKey:@"TrueWeek"];
    NSString *nowweek_string=@"第";
    NSString *now2=[NSString stringWithFormat:@"%d",now_week];
    nowweek_string=[nowweek_string stringByAppendingString:now2];
    nowweek_string=[nowweek_string stringByAppendingString:@"周"];
    //标题结束//
    self.navigationItem.title                    = nowweek_string;
    [self addCourse];
}

- (void)addCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger *nowweek                           = [defaults integerForKey:@"NowWeek"];
    NSArray *array                               = [defaults objectForKey:@"array"];
    
    CourseModel *a1  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a2  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a3  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a4  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a5  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a6  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a7  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a8  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a9  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
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
    
    int day1 = 1,day2=1,day3=1,day4=1,day5=1,day6=1;
    NSLog(@"加载课程");
    for (int i= 0; i<=(array.count-1); i++) {
        NSDictionary *dict1       = array[i];
        NSString *ClassName       = [dict1 objectForKey:@"name"];//课名
        NSString *dsz             = [dict1 objectForKey:@"dsz"];//单双周
        NSInteger *dsz_num        = [dsz intValue];
        if ([dsz isEqualToString: @"单"])
            dsz_num                   = 1;
        else if([dsz isEqualToString: @"双"])
            dsz_num                   = 2;
        else
            dsz_num                   = 0;
        NSString *StartClass      = [dict1 objectForKey:@"djj"];//第几节
        NSInteger *StartClass_num = [StartClass intValue];
        NSString *EndWeek         = [dict1 objectForKey:@"jsz"];//结束周
        NSInteger *EndWeek_num    = [EndWeek intValue];
        NSString *StartWeek       = [dict1 objectForKey:@"qsz"];//起始周
        NSInteger *StartWeek_num  = [StartWeek intValue];
        NSString *Room            = [dict1 objectForKey:@"room"];//教室
        NSString *Teacher         = [dict1 objectForKey:@"teacher"];//老师
        NSString *WeekDay         = [dict1 objectForKey:@"xqj"];//第几天
        NSInteger *WeekDay_num    = [WeekDay intValue];
        NSInteger *ab             = 1;
        
        NSInteger *EndClass       = (short)StartClass_num + 1;
        
        
        ClassName=[ClassName stringByAppendingString:@"\n@"];
        ClassName=[ClassName stringByAppendingString:Room];
       
        if(IfWeeks(now_week,dsz_num,StartWeek_num,EndWeek_num)){
            if(StartClass_num==1){
                switch (day1) {
                    case 1:
                        a1  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 2:
                        a2  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 3:
                        a3  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 4:
                        a4  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 5:
                        a5  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_num==3){
                switch (day2) {
                    case 1:
                        a6  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 2:
                        a7  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 3:
                        a8  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 4:
                        a9  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
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
                } }
        }//swifth结束
    }
    _courseArr = [NSMutableArray arrayWithArray:@[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25]];

    
    [self.courseListView reloadData];
}

- (void)addXpCourse{
NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
NSArray *array_xp                            = [defaults objectForKey:@"array_xp"];
    CourseModel *a1  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a2  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a3  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a4  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a5  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a6  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a7  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a8  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
    CourseModel *a9  = [CourseModel courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3];
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
int day1                                     = 1,day2=1,day3=1,day4=1,day5=1,day6=1;
  
    for (int ixp                                 = 0; ixp<array_xp.count; ixp++) {
        NSDictionary *dict1_xp                       = array_xp[ixp];
        NSString *ClassName_xp                       = [dict1_xp objectForKey:@"lesson"];//第几节
        NSString *StartClass_xp                      = [dict1_xp objectForKey:@"lesson_no"];//第几节
        NSInteger *StartClass_xp_num                 = [StartClass_xp intValue];
        NSInteger *StartClass_xp_num_now             = (short)StartClass_xp_num*2-1;
        NSString *Time_xp                            = [dict1_xp objectForKey:@"period"];//用时
        NSInteger *Time_xp_num                       = [Time_xp intValue];
        NSInteger *EndClass_xp                       = (short)StartClass_xp_num_now+(short)Time_xp_num-1;
        NSString *StartWeek_xp                       = [dict1_xp objectForKey:@"weeks_no"];//起始周
        NSInteger *StartWeek_xp_num                  = [StartWeek_xp intValue];
        NSString *Room_xp                            = [dict1_xp objectForKey:@"locate"];//教室
        NSString *WeekDay_xp                         = [dict1_xp objectForKey:@"week"];//第几天
        NSInteger *WeekDay_xp_num                    = [WeekDay_xp intValue];
        
 
        
        ClassName_xp=[ClassName_xp stringByAppendingString:@"\n@"];
        ClassName_xp=[ClassName_xp stringByAppendingString:Room_xp];
        
        
        NSString *ClassName                          = ClassName_xp;
        NSInteger *WeekDay_num                       = WeekDay_xp_num;
        NSInteger *StartClass_num                    = StartClass_xp_num_now;
        NSInteger *EndClass                          = EndClass_xp;
        
        if(StartWeek_xp_num==now_week){
            if(StartClass_xp_num==1){
                switch (day1) {
                    case 1:
                        
                        a1  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        
                        day1++;
                        break;
                    case 2:
                        a2  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 3:
                        a3  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 4:
                        a4  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    case 5:
                        a5  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day1++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_xp_num==2){
                switch (day2) {
                    case 1:
                        a6  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 2:
                        a7  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 3:
                        a8  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
                        day2++;
                        break;
                    case 4:
                        a9  = [CourseModel courseWithName:ClassName dayIndex:WeekDay_num startCourseIndex:StartClass_num endCourseIndex:EndClass];
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
            if(StartClass_xp_num==3){
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
            if(StartClass_xp_num==4){
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
            if(StartClass_xp_num==5){
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
                
            }}}
        
    _courseArr = [NSMutableArray arrayWithArray:@[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25]];
    
    [self.courseListView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GWPCourseListViewDataSource
- (NSArray<id<Course>> *)courseForCourseListView:(GWPCourseListView *)courseListView{
    return self.courseArr;
}

/** 课程单元背景色自定义 */
- (UIColor *)courseListView:(GWPCourseListView *)courseListView courseTitleBackgroundColorForCourse:(id<Course>)course{
    //    if ([course isEqual:[self.courseArr firstObject]]) {    // 第一个，返回自定义颜色
    //        return [UIColor blueColor];
    //    }
    
    // 其他返回默认的随机色
    return nil;
}

/** 设置选项卡的title的文字属性，如果实现该方法，该方法返回的attribute将会是attributeString的属性 */
- (NSDictionary*)courseListView:(GWPCourseListView *)courseListView titleAttributesInTopbarAtIndex:(NSInteger)index{
    if (index==getweekday()-1) {
          UIColor *newblueColor                        = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:216/255.0 alpha:1];
        return @{NSForegroundColorAttributeName:newblueColor, NSFontAttributeName:[UIFont systemFontOfSize:18]};
    }
    
    return nil;
}
/** 设置选项卡的title的背景颜色，默认白色 */
- (UIColor*)courseListView:(GWPCourseListView *)courseListView

titleBackgroundColorInTopbarAtIndex:(NSInteger)index{
    if (index==getweekday()-1) {
        UIColor *greyColor                        = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        return greyColor;
    }
    
    return nil;
}

#pragma mark - GWPCourseListViewDelegate
/** 选中(点击)某一个课程单元之后的回调 */
- (void)courseListView:(GWPCourseListView *)courseListView didSelectedCourse:(id<Course>)course{
    
}
/////////////按钮////////////
- (instancetype)init
{
    self                                         = [super init];
    if (self)
    {
        self.title                                   = @"LGPlusButtonsView";
        
        self.navigationItem.rightBarButtonItem       = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showHideButtonsAction)];
        
        // -----
        
        _scrollView                                  = [UIScrollView new];
        _scrollView.backgroundColor                  = [UIColor lightGrayColor];
        _scrollView.alwaysBounceVertical             = YES;
        [self.view addSubview:_scrollView];
        
        _exampleView                                 = [UIView new];
        _exampleView.backgroundColor                 = [UIColor colorWithWhite:0.f alpha:0.1];
        [_scrollView addSubview:_exampleView];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"课表查询"];//("PageOne"为页面名称，可自定义)
    _plusButtonsViewMain                         = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4
                                                                                 firstButtonIsPlusButton:YES
                                                                                           showAfterInit:YES
                                                                                           actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                                                    {
                                                        NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                                        if (index == 0)
                                                            [_plusButtonsViewNavBar hideAnimated:YES completionHandler:nil];
                                                        
                                                        if (index == 1) {//实验课表
                                                            if(now_xp==0){
                                                                now_xp=1;
                            [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"平时课表", @"下一周", @"上一周"]];
                                                                [_plusButtonsViewMain setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Books"], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
                                                                                              forState:UIControlStateNormal
                                                                                        forOrientation:LGPlusButtonsViewOrientationAll];
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周实验课表"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addXpCourse];
                                                            }
                                                            else   if(now_xp==1){
                                                                now_xp=0;
                                                                [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"实验课表", @"下一周", @"上一周"]];
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addCourse];
                                                            }
                                                            
                                                        }
                                                        if (index == 2) //下一周
                                                        {
                                                            if (now_week<=20) {
                                                                 now_week++;
                                                            }
                                                            if(now_xp==1){
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周实验课表"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addXpCourse];
                                                            }
                                                            else{
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addCourse];
                                                            }
                                                        }
                                                        if (index == 3){ //上一周{
                                                            if (now_week>1) {
                                                                now_week--;
                                                            }
                                                            if(now_xp==1){
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周实验课表"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addXpCourse];
                                                              
                                                            }
                                                            else {
                                                                NSString *nowweek_string=@"第";
                                                                NSString *now2=[NSString stringWithFormat:@"%d",now_week];
                                                                nowweek_string=[nowweek_string stringByAppendingString:now2];
                                                                nowweek_string=[nowweek_string stringByAppendingString:@"周"];
                                                                //标题结束//
                                                                self.navigationItem.title                    = nowweek_string;
                                                                [self addCourse];
                                                            
                                                            }
                                                            
                                                            
                                                        }
                                                    }];
    
    _plusButtonsViewMain.observedScrollView      = self.scrollView;
    _plusButtonsViewMain.coverColor              = [UIColor colorWithWhite:1.f alpha:0.7];
    _plusButtonsViewMain.position                = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [_plusButtonsViewMain setButtonsTitles:@[@"+", @"", @"", @""] forState:UIControlStateNormal];
    [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"实验课表", @"下一周", @"上一周"]];
    [_plusButtonsViewMain setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Camera"], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
                                  forState:UIControlStateNormal
                            forOrientation:LGPlusButtonsViewOrientationAll];
    
    [_plusButtonsViewMain setButtonsAdjustsImageWhenHighlighted:NO];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    [_plusButtonsViewMain setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewMain setButtonsLayerShadowOpacity:0.5];
    [_plusButtonsViewMain setButtonsLayerShadowRadius:3.f];
    [_plusButtonsViewMain setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    [_plusButtonsViewMain setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.f blue:0.5 alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:1.f green:0.2 blue:0.6 alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    [_plusButtonsViewMain setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [_plusButtonsViewMain setDescriptionsTextColor:[UIColor blackColor]];
    [_plusButtonsViewMain setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewMain setDescriptionsLayerShadowOpacity:0.25];
    [_plusButtonsViewMain setDescriptionsLayerShadowRadius:1.f];
    [_plusButtonsViewMain setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [_plusButtonsViewMain setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i                            = 1; i<=3; i++)
        [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, 0.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    [self.navigationController.view addSubview:_plusButtonsViewMain];
    
    
    
    if([self.navigationController.viewControllers count]>=3){
        [_plusButtonsViewMain removeFromSuperview];
    }
    
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"%s [Line %d]", __PRETTY_FUNCTION__, __LINE__);
}

#pragma mark - Appearing

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _scrollView.frame                            = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    UIEdgeInsets contentInsets                   = _scrollView.contentInset;
    contentInsets.top                            = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    _scrollView.contentInset                     = contentInsets;
    _scrollView.scrollIndicatorInsets            = contentInsets;
    
    _scrollView.contentSize                      = CGSizeMake(self.view.frame.size.width, 2000.f);
    
    // -----
    
    _exampleView.frame                           = CGRectMake(0.f, 0.f, _scrollView.frame.size.width, 400.f);
}

#pragma mark -

- (void)showHideButtonsAction
{
    if (_plusButtonsViewNavBar.isShowing)
        [_plusButtonsViewNavBar hideAnimated:YES completionHandler:nil];
    else
        [_plusButtonsViewNavBar showAnimated:YES completionHandler:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"课表查询"];
    [_plusButtonsViewMain removeFromSuperview];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:[defaults integerForKey:@"TrueWeek"] forKey:@"NowWeek"];
    
}


@end

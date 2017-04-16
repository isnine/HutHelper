//
//  ViewController.m
//  CourseList
//
//  Created by GanWenPeng on 15/12/3.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

#import "CourseViewController.h"
#import "GWPCourseListView.h"
#import "CourseModel.h"
#import "LGPlusButtonsView.h"
#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
 
#import "YCXMenu.h"
#import "NSData+CRC32.h"
@interface CourseViewController ()<GWPCourseListViewDataSource, GWPCourseListViewDelegate>
@property (weak, nonatomic) IBOutlet GWPCourseListView *courseListView;
@property (nonatomic, strong) NSMutableArray<CourseModel*> *courseArr;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) UIView            *exampleView;
@property (nonatomic , strong) NSMutableArray *items;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewNavBar;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewExample;
@property (nonatomic , copy) NSMutableArray *selectCourse;
@end

@implementation CourseViewController
@synthesize items = _items;
int selects[260];
int selectss=1;

int now_week;
int now_xp=0;
NSString *show_xp;
- (NSMutableArray<CourseModel *> *)courseArr{
    if (!_courseArr) {
        
    }
    return _courseArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题//
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    now_week=(short)[defaults integerForKey:@"TrueWeek"];
    show_xp=[defaults objectForKey:@"show_xp"];
    NSString *nowweek_string=@"第";
    NSString *now2=[NSString stringWithFormat:@"%d",now_week];
    nowweek_string=[nowweek_string stringByAppendingString:now2];
    nowweek_string=[nowweek_string stringByAppendingString:@"周"];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //标题结束//
    self.navigationItem.title                    = nowweek_string;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    now_xp=0;
    [self addCourse];
    if ([Config getIs]==1) {
        [self isxp];
    }
    selectss=1;
}

- (void)addCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
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
    
    if ([defaults objectForKey:@"kCourse"]!=NULL) {
        NSArray *array                               = [defaults objectForKey:@"kCourse"];
        int day1 = 1,day2=1,day3=1,day4=1,day5=1,day6=1;
        
        for (int i= 0; i<=(array.count-1); i++) {
            NSDictionary *dict1       = array[i];
            NSString *ClassName       = [dict1 objectForKey:@"name"];//课名
            NSString *dsz             = [dict1 objectForKey:@"dsz"];//单双周
            int dsz_num        = [dsz intValue];
            if ([dsz isEqualToString: @"单"])
                dsz_num                   = 1;
            else if([dsz isEqualToString: @"双"])
                dsz_num                   = 2;
            else
                dsz_num                   = 0;
            NSString *StartClass      = [dict1 objectForKey:@"djj"];//第几节
            int StartClass_num = [StartClass intValue];
            NSString *EndWeek         = [dict1 objectForKey:@"jsz"];//结束周
            int EndWeek_num    = [EndWeek intValue];
            NSString *StartWeek       = [dict1 objectForKey:@"qsz"];//起始周
            int StartWeek_num  = [StartWeek intValue];
            NSString *Room            = [dict1 objectForKey:@"room"];//教室
            NSString *Teacher         = [dict1 objectForKey:@"teacher"];//老师
            NSString *WeekDay         = [dict1 objectForKey:@"xqj"];//第几天
            int WeekDay_num    = [WeekDay intValue];
            int ab             = 1;
            
            int EndClass       = (short)StartClass_num + 1;
            ClassName=[ClassName stringByAppendingString:@"\n@"];
            ClassName=[ClassName stringByAppendingString:Room];
            if([Math IfWeeks:now_week dsz:dsz_num qsz:StartWeek_num jsz:EndWeek_num]){
                if(StartClass_num==1){
                    switch (day1) {
                        case 1:
                            a1  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 2:
                            a2  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 3:
                            a3  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 4:
                            a4  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 5:
                            a5  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_num==3){
                    switch (day2) {
                        case 1:
                            a6  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 2:
                            a7  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 3:
                            a8  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 4:
                            a9  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 5:
                            a10 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_num==5){
                    switch (day3) {
                        case 1:
                            a11 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 2:
                            a12 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 3:
                            a13 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 4:
                            a14 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 5:
                            a15 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_num==7){
                    switch (day4) {
                        case 1:
                            a16 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 2:
                            a17 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 3:
                            a18 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 4:
                            a19 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 5:
                            a20 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_num==9){
                    switch (day5) {
                        case 1:
                            a21 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 2:
                            a22 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 3:
                            a23 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 4:
                            a24 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 5:
                            a25 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        default:
                            break;
                    } }
            }//swifth结束
        }
    }
    _courseArr = [NSMutableArray arrayWithArray:@[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25]];
    [self.courseListView reloadData];
    if([show_xp isEqualToString:@"打开"]){
        [self xp];
    }
    
}

- (void)addXpCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
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
    
    if([defaults objectForKey:@"kCourseXp"]!=NULL){
        NSArray *ClassXP                            = [defaults objectForKey:@"kCourseXp"];
        
        int day1                                     = 1,day2=1,day3=1,day4=1,day5=1,day6=1;
        
        for (int ixp                                 = 0; ixp<ClassXP.count; ixp++) {
            NSDictionary *dict1_xp                       = ClassXP[ixp];
            NSString *ClassName_xp                       = [dict1_xp objectForKey:@"lesson"];//第几节
            NSString *StartClass_xp                      = [dict1_xp objectForKey:@"lesson_no"];//第几节
            int StartClass_xp_num                 = [StartClass_xp intValue];
            int StartClass_xp_num_now             = (short)StartClass_xp_num*2-1;
            NSString *Time_xp                            = [dict1_xp objectForKey:@"period"];//用时
            int Time_xp_num                       = [Time_xp intValue];
            int EndClass_xp                       = (short)StartClass_xp_num_now+(short)Time_xp_num-1;
            NSString *StartWeek_xp                       = [dict1_xp objectForKey:@"weeks_no"];//起始周
            int StartWeek_xp_num                  = [StartWeek_xp intValue];
            NSString *Room_xp                            = [dict1_xp objectForKey:@"locate"];//教室
            NSString *WeekDay_xp                         = [dict1_xp objectForKey:@"week"];//第几天
            int WeekDay_xp_num                    = [WeekDay_xp intValue];
            
            
            
            ClassName_xp=[ClassName_xp stringByAppendingString:@"\n@"];
            ClassName_xp=[ClassName_xp stringByAppendingString:Room_xp];
            
            
            NSString *ClassName                          = ClassName_xp;
            int WeekDay_num                       = WeekDay_xp_num;
            int StartClass_num                    = StartClass_xp_num_now;
            int EndClass                          = EndClass_xp;
            
            if(StartWeek_xp_num==now_week){
                if(StartClass_xp_num==1){
                    switch (day1) {
                        case 1:
                            
                            a1  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            
                            day1++;
                            break;
                        case 2:
                            a2  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 3:
                            a3  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 4:
                            a4  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        case 5:
                            a5  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day1++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_xp_num==2){
                    switch (day2) {
                        case 1:
                            a6  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 2:
                            a7  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 3:
                            a8  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 4:
                            a9  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        case 5:
                            a10 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day2++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_xp_num==3){
                    switch (day3) {
                        case 1:
                            a11 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 2:
                            a12 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 3:
                            a13 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 4:
                            a14 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        case 5:
                            a15 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day3++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_xp_num==4){
                    switch (day4) {
                        case 1:
                            a16 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 2:
                            a17 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 3:
                            a18 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 4:
                            a19 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        case 5:
                            a20 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day4++;
                            break;
                        default:
                            break;
                    }
                    
                }
                if(StartClass_xp_num==5){
                    switch (day5) {
                        case 1:
                            a21 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 2:
                            a22 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 3:
                            a23 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 4:
                            a24 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        case 5:
                            a25 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                            day5++;
                            break;
                        default:
                            break;
                    }
                    
                }}}  }
    _courseArr = [NSMutableArray arrayWithArray:@[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25]];
    [self.courseListView reloadData];
}

- (void)xp{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *ClassXP                            = [defaults objectForKey:@"kCourseXp"];
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
    
    for (int ixp                                 = 0; ixp<ClassXP.count; ixp++) {
        NSDictionary *dict1_xp                       = ClassXP[ixp];
        NSString *ClassName_xp                       = [dict1_xp objectForKey:@"lesson"];//第几节
        NSString *StartClass_xp                      = [dict1_xp objectForKey:@"lesson_no"];//第几节
        int StartClass_xp_num                 = [StartClass_xp intValue];
        int StartClass_xp_num_now             = (short)StartClass_xp_num*2-1;
        NSString *Time_xp                            = [dict1_xp objectForKey:@"period"];//用时
        int Time_xp_num                       = [Time_xp intValue];
        int EndClass_xp                       = (short)StartClass_xp_num_now+(short)Time_xp_num-1;
        NSString *StartWeek_xp                       = [dict1_xp objectForKey:@"weeks_no"];//起始周
        int StartWeek_xp_num                  = [StartWeek_xp intValue];
        NSString *Room_xp                            = [dict1_xp objectForKey:@"locate"];//教室
        NSString *WeekDay_xp                         = [dict1_xp objectForKey:@"week"];//第几天
        int WeekDay_xp_num                    = [WeekDay_xp intValue];
        ClassName_xp=[@"【实验】" stringByAppendingString:ClassName_xp];
        ClassName_xp=[ClassName_xp stringByAppendingString:@"\n@"];
        ClassName_xp=[ClassName_xp stringByAppendingString:Room_xp];
        
        
        NSString *ClassName                          = ClassName_xp;
        int WeekDay_num                       = WeekDay_xp_num;
        int StartClass_num                    = StartClass_xp_num_now;
        int EndClass                          = EndClass_xp;
        int day1                                     = 1,day2=1,day3=1,day4=1,day5=1,day6=1;
        if(StartWeek_xp_num==now_week){
            if(StartClass_xp_num==1){
                switch (day1) {
                    case 1:
                        a1  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a1];
                        day1++;
                        break;
                    case 2:
                        a2  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a2];
                        day1++;
                        break;
                    case 3:
                        a3  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a3];
                        day1++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_xp_num==2){
                switch (day2) {
                    case 1:
                        a4  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a4];
                        day2++;
                        break;
                    case 2:
                        a5  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a5];
                        day2++;
                        break;
                    case 3:
                        a6  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a6];
                        day2++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_xp_num==3){
                switch (day3) {
                    case 1:
                        a7 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a7];
                        day3++;
                        break;
                    case 2:
                        a8 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a8];
                        day3++;
                        break;
                    case 3:
                        a9 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a9];
                        day3++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_xp_num==4){
                switch (day4) {
                    case 1:
                        a10 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a10];
                        day4++;
                        break;
                    case 2:
                        a11 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a11];
                        day4++;
                        break;
                    case 3:
                        a12 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a12];
                        day4++;
                        break;
                    default:
                        break;
                }
                
            }
            if(StartClass_xp_num==5){
                switch (day5) {
                    case 1:
                        a13 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a13];
                        day5++;
                        break;
                    case 2:
                        a14 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a14];
                        day5++;
                        break;
                    case 3:
                        a15 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                        [self.courseArr addObject:a15];
                        day5++;
                        break;
                    default:
                        break;
                }
                
            }}
        
    }
    // a3  = [CourseModel courseWithName:@"物联网移动应用开发*\n@计通楼213" nameAttribute:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : [UIColor darkGrayColor]} dayIndex:3 startCourseIndex:7 endCourseIndex:8];
    
    [self.courseListView reloadData];
    
}

-(void)isxp{
    NSString *nowweek_string=@"第";
    NSString *now2=[NSString stringWithFormat:@"%d",now_week];
    nowweek_string=[nowweek_string stringByAppendingString:now2];
    nowweek_string=[nowweek_string stringByAppendingString:@"周实验课表"];
    //标题结束//
    self.navigationItem.title                    = nowweek_string;
    now_xp=1;
    [self addXpCourse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadcourse {
    /**拼接地址*/
    [MBProgressHUD showMessage:@"刷新中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_CLASS,Config.getStudentKH,Config.getRememberCodeApp];
    NSLog(@"平时课表地址:%@",Url_String);
    NSString *UrlXP_String=[NSString stringWithFormat:API_CLASSXP,Config.getStudentKH,Config.getRememberCodeApp];
    NSLog(@"实验课表地址:%@",UrlXP_String);
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 9.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Class_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSArray *arrayCourse               = [Class_All objectForKey:@"data"];
                 [Config saveWidgetCourse:arrayCourse];
                 
                 /**请求实验课表*/
                 [manager GET:UrlXP_String parameters:nil progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSDictionary *ClassXP_All = [NSDictionary dictionaryWithDictionary:responseObject];
                          NSString *Msg=[ClassXP_All objectForKey:@"msg"];
                          if ([Msg isEqualToString:@"ok"]) {
                              NSArray *arrayCourseXp               = [ClassXP_All objectForKey:@"data"];
                              [Config saveWidgetCourseXp:arrayCourseXp];
                              HideAllHUD
                              [MBProgressHUD showSuccess:@"刷新成功"];
                              if(now_xp==0){
                                  [self addCourse];
                              }
                              else{
                                  [self addXpCourse];
                              }
                          }
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          HideAllHUD
                          [MBProgressHUD showError:@"网络错误，实验课表查询失败"];
                      }];
             }
             else if([Msg isEqualToString:@"令牌错误"]){
                 HideAllHUD
                 [MBProgressHUD showError:@"登录过期,请重新登录"];
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:@"查询失败"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HideAllHUD
             [MBProgressHUD showError:@"网络错误，平时课表查询失败"];
         }];
    
    
}

-(void)toSet{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Set"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}

#pragma mark - GWPCourseListViewDataSource
- (NSArray<id<Course>> *)courseForCourseListView:(GWPCourseListView *)courseListView{
    return self.courseArr;
}
/** 课程单元背景色自定义 */
- (UIColor *)courseListView:(GWPCourseListView *)courseListView courseTitleBackgroundColorForCourse:(id<Course>)course{
    NSArray *lightColorArr = @[
                               RGB(39, 201, 155, 1),
                               RGB(250, 194, 97, 1),
                               RGB(50, 218,210, 1),
                               RGB(163, 232,102, 1),
                               RGB(78, 221, 166, 1),
                               RGB(247, 125, 138, 1),
                               RGB(120, 192, 246, 1),
                               RGB(254, 141, 65, 1),
                               RGB(2, 179, 237, 1),
                               RGB(110, 159, 245, 1),
                               RGB(17, 202, 154, 1),
                               RGB(228, 119, 195, 1),
                               RGB(147, 299, 3, 1),
                               ];
    
    if (course.courseName) {           NSRange range=[course.courseName rangeOfString:@"\n"];
        NSData *sendData = [[course.courseName substringToIndex:range.location] dataUsingEncoding:NSUTF8StringEncoding];
        int checksum = abs([sendData crc32])%256;
        if (selectss+1>lightColorArr.count) {//超过配色数量，随机颜色
            return nil;
        }
        if (selects[checksum]==0) {//第一次配色，设置颜色
            selects[checksum]=selectss++;
            return lightColorArr[selects[checksum]];
        }else{//第二次配色，取之前颜色
            return lightColorArr[selects[checksum]];
        }
    }
    return nil;
}
/** 设置选项卡的title的文字属性，如果实现该方法，该方法返回的attribute将会是attributeString的属性 */
- (NSDictionary*)courseListView:(GWPCourseListView *)courseListView titleAttributesInTopbarAtIndex:(NSInteger)index{
    if (index==[Math getWeekDay]-1) {
        UIColor *newblueColor                        = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:216/255.0 alpha:1];
        return @{NSForegroundColorAttributeName:newblueColor, NSFontAttributeName:[UIFont systemFontOfSize:18]};
    }
    
    return nil;
}
/** 设置选项卡的title的背景颜色，默认白色 */
- (UIColor*)courseListView:(GWPCourseListView *)courseListView titleBackgroundColorInTopbarAtIndex:(NSInteger)index{
    if (index==[Math getWeekDay]-1) {
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
    
    [MobClick beginLogPageView:@"课表查询"];
    _plusButtonsViewMain                         = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4
                                                                                 firstButtonIsPlusButton:YES
                                                                                           showAfterInit:YES
                                                                                           actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                                                    {
                                                        
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
    
}

#pragma mark - 菜单
-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    //    [YCXMenu setTitleFont:[UIFont systemFontOfSize:19.0]];
    //    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
        }];
    }
    
}

- (NSMutableArray *)items {
    if (!_items) {
        
        //        // set title
        //        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"添加失物" WithIcon:nil];
        //        menuTitle.foreColor = [UIColor whiteColor];
        //        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"课表刷新" image:[UIImage imageNamed:@"reload"] target:self action:@selector(reloadcourse)];
        menuTitle.foreColor = [UIColor blackColor];
        menuTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"课表设置" image:[UIImage imageNamed:@"set_black"] target:self action:@selector(toSet)];
        logoutItem.foreColor = [UIColor blackColor];
        logoutItem.alignment = NSTextAlignmentCenter;
        
        //        //set item
        _items = [@[menuTitle,
                    logoutItem
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

@end

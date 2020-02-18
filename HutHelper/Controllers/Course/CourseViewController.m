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
#import "DetailsCourseViewController.h"

#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "DTKDropdownMenuView.h"
#import "YCXMenu.h"
#import "NSData+CRC32.h"
#import "Config.h"
@import EachNavigationBar_Objc;

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

@property (nonatomic , copy) DTKDropdownMenuView *menuView;
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
    self.navigation_item.title                    = nowweek_string;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYReal(25), SYReal(25))];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(5), 0, SYReal(25), SYReal(25))];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(reloadcourse) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigation_item.rightBarButtonItem = rightCunstomButtonView;
    self.navigation_bar.isShadowHidden = true;
    self.navigation_bar.alpha = 0;
    /**按钮*/
    UIView *rightButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    
    mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    [rightButtonView1 addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView1];
    self.navigation_item.leftBarButtonItem  = rightCunstomButtonView1;
    
    //self.navigation_bar.alpha = 0;

    //self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    /**刷新课程表*/
    [self addCourse];
    selectss=1;
    /**选择周次*/
    [self addTitleMenu];
    [self addSome];
    
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTitleMenu
{
    DTKDropdownItem *item1,*item2,*item3,*item4,*item5,*item6,*item7,*item8,*item9,*item10,*item11,*item12,*item13,*item14,*item15,*item16,*item17,*item18,*item19,*item20;
    item1 = [DTKDropdownItem itemWithTitle:@"第1周" callBack:^(NSUInteger index, id info) {
        now_week=1;
        [self addCourse];
    }];
    item2 = [DTKDropdownItem itemWithTitle:@"第2周" callBack:^(NSUInteger index, id info) {
        now_week=2;
        [self addCourse];
    }];
    item3 = [DTKDropdownItem itemWithTitle:@"第3周" callBack:^(NSUInteger index, id info) {
        now_week=3;
        [self addCourse];
    }];
    item4 = [DTKDropdownItem itemWithTitle:@"第4周" callBack:^(NSUInteger index, id info) {
        now_week=4;
        [self addCourse];
    }];
    item5 = [DTKDropdownItem itemWithTitle:@"第5周" callBack:^(NSUInteger index, id info) {
        now_week=5;
        [self addCourse];
    }];
    item6 = [DTKDropdownItem itemWithTitle:@"第6周" callBack:^(NSUInteger index, id info) {
        now_week=6;
        [self addCourse];
    }];
    item7 = [DTKDropdownItem itemWithTitle:@"第7周" callBack:^(NSUInteger index, id info) {
        now_week=7;
        [self addCourse];
    }];
    item8 = [DTKDropdownItem itemWithTitle:@"第8周" callBack:^(NSUInteger index, id info) {
        now_week=8;
        [self addCourse];
    }];
    item9 = [DTKDropdownItem itemWithTitle:@"第9周" callBack:^(NSUInteger index, id info) {
        now_week=9;
        [self addCourse];
    }];
    item10 = [DTKDropdownItem itemWithTitle:@"第10周" callBack:^(NSUInteger index, id info) {
        now_week=10;
        [self addCourse];
    }];
    item11 = [DTKDropdownItem itemWithTitle:@"第11周" callBack:^(NSUInteger index, id info) {
        now_week=11;
        [self addCourse];
    }];
    item12 = [DTKDropdownItem itemWithTitle:@"第12周" callBack:^(NSUInteger index, id info) {
        now_week=12;
        [self addCourse];
    }];
    item13 = [DTKDropdownItem itemWithTitle:@"第13周" callBack:^(NSUInteger index, id info) {
        now_week=13;
        [self addCourse];
    }];
    item14 = [DTKDropdownItem itemWithTitle:@"第14周" callBack:^(NSUInteger index, id info) {
        now_week=14;
        [self addCourse];
    }];
    item15 = [DTKDropdownItem itemWithTitle:@"第15周" callBack:^(NSUInteger index, id info) {
        now_week=15;
        [self addCourse];
    }];
    item16 = [DTKDropdownItem itemWithTitle:@"第16周" callBack:^(NSUInteger index, id info) {
        now_week=16;
        [self addCourse];
    }];
    item17 = [DTKDropdownItem itemWithTitle:@"第17周" callBack:^(NSUInteger index, id info) {
        now_week=17;
        [self addCourse];
    }];
    item18 = [DTKDropdownItem itemWithTitle:@"第18周" callBack:^(NSUInteger index, id info) {
        now_week=18;
        [self addCourse];
    }];
    item19 = [DTKDropdownItem itemWithTitle:@"第19周" callBack:^(NSUInteger index, id info) {
        now_week=19;
        [self addCourse];
    }];
    item20 = [DTKDropdownItem itemWithTitle:@"第20周" callBack:^(NSUInteger index, id info) {
        now_week=20;
        [self addCourse];
    }];
    _menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(SYReal(123.0), 0, SYReal(200.f), SYReal(44.f)) dropdownItems:@[item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16,item17,item18,item19,item20]];
    _menuView.currentNav = self.navigationController;
    _menuView.dropWidth = SYReal(150.f);
    _menuView.titleFont = [UIFont systemFontOfSize:18.f];
    _menuView.textColor = [UIColor blackColor];//每栏颜色
    _menuView.textFont = [UIFont systemFontOfSize:13.f];
    _menuView.textFont = [UIFont systemFontOfSize:14.f];
    _menuView.animationDuration = 0.2f;
    if (now_week>20) {
        now_week=20;
    }
    _menuView.selectedIndex = now_week-1;
    _menuView.cellSeparatorColor = [UIColor whiteColor];
    _menuView.titleColor=[UIColor blackColor];//标题颜色
    [_menuView setArrow];
    self.navigation_item.titleView = _menuView;
}
- (void)addCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSArray *array = [[NSArray alloc] init];
    CourseModel *a1 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a2 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a3 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a4 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a5 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a6 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a7 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a8 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a9 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a10 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a11 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a12 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a13 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a14 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a15 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a16 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a17 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a18 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a19 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a20 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a21 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a22 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a23 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a24 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a25 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a26 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a27 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a28 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a29 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a30 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a31 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a32 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a33 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a34 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    CourseModel *a35 = [CourseModel courseTeacher:@"NULL" courseRoom:@"NULL" courseWithName:@"NULL" dayIndex:0 startCourseIndex:3 endCourseIndex:3 courseWeek:array];
    
    if ([defaults objectForKey:@"kCourse"]!=NULL) {
        NSArray *array                               = [defaults objectForKey:@"kCourse"];
        int day1 = 1,day2=1,day3=1,day4=1,day5=1,day6=1,day7=1;
        
        for (int i= 0; i<=(array.count-1); i++) {
            NSDictionary *dict1       = array[i];
            
            NSString *className       = [dict1 objectForKey:@"name"];
            // 判断体育课
            NSArray *CourseWeek = [dict1 objectForKey:@"zs"];
            NSString *ClassName       = [dict1 objectForKey:@"name"];//课名
            //            NSString *dsz             = [dict1 objectForKey:@"dsz"];//单双周
            int dsz_num        = [[dict1 objectForKey:@"dsz"] intValue];
            //            if ([[dict1 objectForKey:@"dsz"] isEqual: @1])
            //                dsz_num                   = 1;
            //            else if([[dict1 objectForKey:@"dsz"] isEqual: @2])
            //                dsz_num                   = 2;
            //            else
            //                dsz_num                   = 0;
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
            NSString *PE =[className substringToIndex:2];
            if([PE isEqualToString:@"体育"]){
                NSLog(@"%s","体育课处理");
            }else {
                
                if([Math IfWeeks:now_week dsz:dsz_num qsz:StartWeek_num jsz:EndWeek_num]){
                    if(StartClass_num==1){
                        switch (day1) {
                            case 1:
                                a1 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a1  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 2:
                                a2 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a2  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 3:
                                a3 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                // a3  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 4:
                                a4 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a4  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 5:
                                a5 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                // a5  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 6:
                                a26 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a26  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            case 7:
                                a27 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a27  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day1++;
                                break;
                            default:
                                break;
                        }
                        
                    }
                    if(StartClass_num==3){
                        switch (day2) {
                            case 1:
                                a6 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a6  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 2:
                                a7 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a7  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 3:
                                a8 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a8  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 4:
                                a9 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a9  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 5:
                                a10 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a10 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 6:
                                a28 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a28  = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            case 7:
                                a29 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a29 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day2++;
                                break;
                            default:
                                break;
                        }
                        
                    }
                    if(StartClass_num==5){
                        switch (day3) {
                            case 1:
                                a11 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                // a11 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 2:
                                a12 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a12 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 3:
                                a13 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a13 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 4:
                                a14 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a14 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 5:
                                a15 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a15 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 6:
                                a30 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a30 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            case 7:
                                a31 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a31 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day3++;
                                break;
                            default:
                                break;
                        }
                        
                    }
                    if(StartClass_num==7){
                        switch (day4) {
                            case 1:
                                a16 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a16 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 2:
                                a17 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a17 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 3:
                                a18 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a18 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 4:
                                a19 =  [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a19 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 5:
                                a20 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a20 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 6:
                                a32 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a32 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            case 7:
                                a33 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a33 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day4++;
                                break;
                            default:
                                break;
                        }
                        
                    }
                    if(StartClass_num==9){
                        switch (day5) {
                            case 1:
                                a21 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a21 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 2:
                                a22 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a22 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 3:
                                a23 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a23 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 4:
                                a24 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a24 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 5:
                                a25 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                // a25 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 6:
                                a34 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a34 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            case 7:
                                a35 = [CourseModel courseTeacher:Teacher courseRoom:Room courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass courseWeek:CourseWeek];
                                //a35 = [CourseModel courseWithName:ClassName dayIndex:(short)WeekDay_num startCourseIndex:(short)StartClass_num endCourseIndex:(short)EndClass];
                                day5++;
                                break;
                            default:
                                break;
                        } }
                }//swifth结束
            }
        }
    }
    _courseArr = [NSMutableArray arrayWithArray:@[a1,a2,a3,a4,a5,a26,a27,a6,a7,a8,a9,a10,a28,a29,a11,a12,a13,a14,a15,a30,a31,a16,a17,a18,a19,a20,a32,a33,a21,a22,a23,a24,a25,a34,a35]];
    self.courseListView.weekIndex=now_week;
    for (int i=0 ; i<7; i++) {
        UILabel *dayLab=(UILabel *)[self.courseListView viewWithTag:(101+i)];
        UILabel *weekLab=(UILabel *)[self.courseListView viewWithTag:(201+i)];
        [dayLab removeFromSuperview];
        [weekLab removeFromSuperview];
    }
    [self.courseListView reloadData];
}

// some 
- (void) addSome {
    if ([[Config getStudentKH] isEqualToString:@"17408002037"] &&[[Config getTrueName ] isEqualToString:@"张驰"])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-150, UIScreen.mainScreen.bounds.size.height/2-150, SYReal(300), SYReal(300))];
        img.image = [UIImage imageNamed:@"lovass"];
        [img setAlpha:0.4];
        [self.view addSubview:img];
    }
    if ([[Config getStudentKH] isEqualToString:@"17403001035"] && [[Config getTrueName] isEqualToString:@"游子欣"])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-150, UIScreen.mainScreen.bounds.size.height/2-150, SYReal(300), SYReal(300))];
        img.image = [UIImage imageNamed:@"lovass"];
        [img setAlpha:0.4];
        [self.view addSubview:img];
    }
    if ([[Config getStudentKH] isEqualToString:@"17407900222"] && [[Config getTrueName] isEqualToString:@"李佳琪"])
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-150, UIScreen.mainScreen.bounds.size.height/2-150, SYReal(300), SYReal(300))];
        img.image = [UIImage imageNamed:@"lovass"];
        [img setAlpha:0.4];
        [self.view addSubview:img];
    }
}


- (void)reloadcourse {
    /**拼接地址*/
    [MBProgressHUD showMessage:@"刷新中" toView:self.view];
    /**请求平时课表*/
    [APIRequest GET:Config.getApiClass parameters:nil success:^(id responseObject) {
        HideAllHUD
        NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *Msg=[Class_All objectForKey:@"code"];
        if ([Msg isEqual:@200]) {
            NSArray *arrayCourse               = [Class_All objectForKey:@"data"];
            NSLog(@"%@",[Config getApiClass]);
            [Config saveWidgetCourse:arrayCourse];
            [Config saveCourse:arrayCourse];
            [self addCourse];
            [MBProgressHUD showSuccess:@"刷新成功" toView:self.view];
        }else{
            NSString* errorStr=responseObject[@"msg"];
            [MBProgressHUD showError:errorStr toView:self.view];
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络错误，平时课表查询失败" toView:self.view];
    }];
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
    
    if(course!=nil){
        DetailsCourseViewController *Dcv = [[DetailsCourseViewController alloc]init];
        //分割courseName
        NSArray *arr = [course.courseName componentsSeparatedByString:@"\n"];
        Dcv.name = arr[0];
        /** 上课时间拼接 */
        NSString *time0 = [NSString stringWithFormat: @"%lu", (unsigned long)course.dayIndex];
        NSString *time1 = [NSString stringWithFormat: @"%lu", (unsigned long)course.startCourseIndex];
        NSString *time2 = [NSString stringWithFormat: @"%lu", (unsigned long)(course.startCourseIndex+1)];
        
        
        Dcv.time = [NSString stringWithFormat:@"星期%@ 第%@、%@节",time0,time1,time2];
        Dcv.room = course.courseRoom;
        Dcv.room = course.courseRoom;
        Dcv.teacher = course.courseTeacher;
        NSString *courseWeek = [[course.courseWeek
                                 valueForKey:@"description"] componentsJoinedByString:@" "];
        Dcv.Week = courseWeek;
        [self.navigationController pushViewController:Dcv animated:YES];
    }
    
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

-(void)removeYCXMenuBlind{
    UIView *blindView=[[[UIApplication  sharedApplication]  keyWindow] viewWithTag:99];
    [blindView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    _plusButtonsViewMain                         = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:3
                                                                                 firstButtonIsPlusButton:YES
                                                                                           showAfterInit:YES
                                                                                           actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                                                    {
                                                        
                                                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                                        if (index == 0){
                                                            [_plusButtonsViewNavBar hideAnimated:YES completionHandler:nil];
                                                        }
                                                        else if (index == 1) {//实验课表
                                                            if (now_week<20)
                                                                now_week++;
                                                            [self addCourse];
                                                            _menuView.selectedIndex=now_week-1;
                                                        }else if (index == 2) {
                                                            if (now_week>1)
                                                                now_week--;
                                                            [self addCourse];
                                                            _menuView.selectedIndex=now_week-1;
                                                        }
                                                    }];
    
    _plusButtonsViewMain.observedScrollView      = self.scrollView;
    _plusButtonsViewMain.coverColor              = [UIColor colorWithWhite:1.f alpha:0.7];
    _plusButtonsViewMain.position                = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [_plusButtonsViewMain setButtonsTitles:@[@"+", @"", @""] forState:UIControlStateNormal];
    [_plusButtonsViewMain setDescriptionsTexts:@[@"",  @"下一周", @"上一周"]];
    [_plusButtonsViewMain setButtonsImages:@[[NSNull new], [UIImage imageNamed:@"Picture"], [UIImage imageNamed:@"Message"]]
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
    
    [_plusButtonsViewMain setButtonAtIndex:0 size:CGSizeMake(40.f, 40.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 layerCornerRadius:40.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:30.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:1 size:CGSizeMake(36.f, 36.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:1 layerCornerRadius:36.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:2 size:CGSizeMake(36.f, 36.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:2 layerCornerRadius:36.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.5 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:1.f green:0.6 blue:0.2 alpha:1.f] forState:UIControlStateHighlighted];
    //    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.7 blue:0.f alpha:1.f] forState:UIControlStateNormal];
    //    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    [_plusButtonsViewMain setDescriptionsBackgroundColor:[UIColor whiteColor]];
    [_plusButtonsViewMain setDescriptionsTextColor:[UIColor blackColor]];
    [_plusButtonsViewMain setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewMain setDescriptionsLayerShadowOpacity:0.25];
    [_plusButtonsViewMain setDescriptionsLayerShadowRadius:1.f];
    [_plusButtonsViewMain setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [_plusButtonsViewMain setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i                            = 1; i<=2; i++)
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YCXMenuWillDisappearNotification" object:nil];
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
    [_plusButtonsViewMain removeFromSuperview];
    
}


@end

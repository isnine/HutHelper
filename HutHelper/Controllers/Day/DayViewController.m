//
//  DayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "DayViewController.h"
 

#import "DayCalendarViewController.h"
@import EachNavigationBar_Objc;
@interface DayViewController ()

@end

@implementation DayViewController
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    super.calendarMonth = [self getMonthArrayOfDayNumber:365 ToDateforString:nil];
    [super.collectionView reloadData];//刷新
    //返回箭头
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //按钮
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_day_day"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(day) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigation_item.rightBarButtonItem = rightCunstomButtonView;
    // Do any additional setup after loading the view from its nib.
        [self setTitle];
            
    }

    - (void) setTitle{
            /**按钮*/
            UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(5), 0, SYReal(25), SYReal(25))];
            UIView *rightButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
            
            mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
            [rightButtonView1 addSubview:mainAndSearchBtn];
            [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
            [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightCunstomButtonView1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView1];
            self.navigation_item.leftBarButtonItem  = rightCunstomButtonView1;
        }
    // 返回按钮按下
    - (void)backBtnClicked:(UIButton *)sender{
            [self.navigationController popViewControllerAnimated:YES];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)day{
    DayCalendarViewController *dayCalendarViewController=[[DayCalendarViewController alloc]init];
    [self.navigationController pushViewController:dayCalendarViewController animated:YES];
    //[Config pushViewController:@"DayCalendar"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"日历"];
    self.navigationItem.title = @"日历";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];


}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}


@end

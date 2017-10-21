//
//  DayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "DayViewController.h"
#import "UMMobClick/MobClick.h"
#import "DayCalendarViewController.h"
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
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    // Do any additional setup after loading the view from its nib.
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

    [MobClick beginLogPageView:@"校历"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"校历"];
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

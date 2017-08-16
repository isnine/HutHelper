//
//  DayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "DayViewController.h"
#import "UMMobClick/MobClick.h"
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

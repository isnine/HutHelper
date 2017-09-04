//
//  DayCalendarViewController.m
//  HutHelper
//
//  Created by nine on 2017/9/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "DayCalendarViewController.h"

@interface DayCalendarViewController ()

@end

@implementation DayCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校历";
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *calendar=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(100), SYReal(414), SYReal(559))];
    calendar.image=[UIImage imageNamed:@"img_day_calendar"];
    [self.view addSubview:calendar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

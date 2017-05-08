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
@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *arraycx;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addExam];
    // Do any additional setup after loading the view from its nib.
}
-(void)addExam{
    NSLog(@"%f %f",DeviceMaxHeight,DeviceMaxWidth);
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    if (defaults&&([defaults objectForKey:@"kCourse"]!=NULL)) {
        NSDictionary *Class_Data=[defaults objectForKey:@"Exam"];
        _array  = [Class_Data objectForKey:@"exam"];
        _arraycx = [Class_Data objectForKey:@"cxexam"];
        UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(20),SYReal(20), SYReal(150), SYReal(30))];
        a.text=[_array[0] objectForKey:@"CourseName"];
        [self.view addSubview:a];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end

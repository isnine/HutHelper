//
//  TodayViewController.m
//  Extend
//
//  Created by nine on 2017/2/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "TodayViewController.h"
#import "ExtendModel.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *Day;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Name2;
@property (weak, nonatomic) IBOutlet UILabel *Time2;
@property (weak, nonatomic) IBOutlet UILabel *Name3;
@property (weak, nonatomic) IBOutlet UILabel *Time3;
@property (weak, nonatomic) IBOutlet UILabel *Name4;
@property (weak, nonatomic) IBOutlet UILabel *Time4;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Day.text=[ExtendModel setDay];
    [self addCourse];
}
-(void)addCourse{
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    NSMutableArray *classSolution=[[NSMutableArray alloc]init];
    if ([defaults objectForKey:@"Class"]!=NULL) {
        NSArray *array          = [defaults objectForKey:@"Class"];
        NSLog(@"%@",array[1]);
        for (int i= 0; i<=(array.count-1); i++) {
            NSDictionary *dict1       = array[i];
            NSString *name       = [dict1 objectForKey:@"name"];//课名
            NSString *dsz             = [dict1 objectForKey:@"dsz"];//单双周
            int dsz_num        = [dsz intValue];
            if ([dsz isEqualToString: @"单"])
                dsz_num                   = 1;
            else if([dsz isEqualToString: @"双"])
                dsz_num                   = 2;
            else
                dsz_num                   = 0;
            NSString *startClass      = [dict1 objectForKey:@"djj"];//第几节
            int StartClass_num = [startClass intValue];
            NSString *endWeek         = [dict1 objectForKey:@"jsz"];//结束周
            int endWeek_num    = [endWeek intValue];
            NSString *startWeek       = [dict1 objectForKey:@"qsz"];//起始周
            int startWeek_num  = [startWeek intValue];
            NSString *room            = [dict1 objectForKey:@"room"];//教室
            NSString *teacher         = [dict1 objectForKey:@"teacher"];//老师
            NSString *weekDay         = [dict1 objectForKey:@"xqj"];//第几天
            int weekDay_num  = [weekDay intValue];
            if ([ExtendModel IfWeeks:dsz_num qsz:startWeek_num jsz:endWeek_num]&&[ExtendModel getWeek_solution]-2==weekDay_num) {
                if(classSolution.count!=0){
                    for (int j=0; j<classSolution.count; j++) {
                        if ([[array[i] objectForKey:@"djj"] intValue]<[[classSolution[j] objectForKey:@"djj"] intValue]) {
                            [classSolution insertObject:array[i] atIndex:j];
                            break;
                        }else if(j==(short)classSolution.count-1){
                            [classSolution addObject:array[i]];
                            break;
                        }
                    
                    }
                    
                }else{
                    [classSolution addObject:array[i]];
                }
               
            }
        }
        switch (classSolution.count) {
            case 1:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[classSolution[0] objectForKey:@"room"]];
                break;
            case 2:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[classSolution[1] objectForKey:@"room"]];
                break;
            case 3:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[classSolution[1] objectForKey:@"room"]];
                _Name3.text=[classSolution[2] objectForKey:@"name"];
                _Time3.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[2] objectForKey:@"djj"],[[classSolution[2] objectForKey:@"djj"] intValue]+1,[classSolution[2] objectForKey:@"room"]];
                break;
            case 4:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[classSolution[1] objectForKey:@"room"]];
                _Name3.text=[classSolution[2] objectForKey:@"name"];
                _Time3.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[2] objectForKey:@"djj"],[[classSolution[2] objectForKey:@"djj"] intValue]+1,[classSolution[2] objectForKey:@"room"]];
                _Name4.text=[classSolution[3] objectForKey:@"name"];
                _Time4.text=[NSString stringWithFormat:@"第%@-%d节 @%@",[classSolution[3] objectForKey:@"djj"],[[classSolution[3] objectForKey:@"djj"] intValue]+1,[classSolution[3] objectForKey:@"room"]];
                break;
            default:
                break;
        }

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    //    if (self.extensionContext.widgetLargestAvailableDisplayMode == NCWidgetDisplayModeCompact) {
    //        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    //    } else
    //    {
    //        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    //    }
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
    } else
    {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
    }
}
@end

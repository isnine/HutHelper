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
@property (weak, nonatomic) IBOutlet UIImageView *Ico1;
@property (weak, nonatomic) IBOutlet UIImageView *Ico2;
@property (weak, nonatomic) IBOutlet UIImageView *Ico3;
@property (weak, nonatomic) IBOutlet UIImageView *Ico4;
@property (weak, nonatomic) IBOutlet UIImageView *Ico5;
@property (weak, nonatomic) IBOutlet UIImageView *Ico6;
@property (weak, nonatomic) IBOutlet UIImageView *Ico7;
@property (weak, nonatomic) IBOutlet UIImageView *Ico8;
@property (weak, nonatomic) IBOutlet UIImageView *Xian1;
@property (weak, nonatomic) IBOutlet UIImageView *Xian2;
@property (weak, nonatomic) IBOutlet UIImageView *Xian3;
@property int classnum;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _classnum=0;
    _Day.text=[ExtendModel setDay];
    [self addCourse];
}
-(void)addCourse{
    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    if (defaults) {
    NSMutableArray *classSolution=[[NSMutableArray alloc]init];
    if ([defaults objectForKey:@"kCourse"]!=NULL) {
        NSArray *array          = [defaults objectForKey:@"kCourse"];
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
            if ([ExtendModel IfWeeks:dsz_num qsz:startWeek_num jsz:endWeek_num]&&[ExtendModel getWeekDay_solution]==weekDay_num) {
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
            _classnum=classSolution.count;
        switch (classSolution.count) {
            case 1:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[0] objectForKey:@"djj"] intValue]],[classSolution[0] objectForKey:@"room"]];
                _Ico1.hidden=false;
                _Ico5.hidden=false;
                break;
            case 2:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[0] objectForKey:@"djj"] intValue]],[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[1] objectForKey:@"djj"] intValue]],[classSolution[1] objectForKey:@"room"]];
                _Ico1.hidden=false;
                _Ico2.hidden=false;
                _Ico5.hidden=false;
                _Ico6.hidden=false;
                break;
            case 3:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[0] objectForKey:@"djj"] intValue]],[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[1] objectForKey:@"djj"] intValue]],[classSolution[1] objectForKey:@"room"]];
                _Name3.text=[classSolution[2] objectForKey:@"name"];
                _Time3.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[2] objectForKey:@"djj"],[[classSolution[2] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[2] objectForKey:@"djj"] intValue]],[classSolution[2] objectForKey:@"room"]];
                _Ico1.hidden=false;
                _Ico2.hidden=false;
                _Ico3.hidden=false;
                _Ico5.hidden=false;
                _Ico6.hidden=false;
                _Ico7.hidden=false;
                break;
            case 4:
                _Name.text=[classSolution[0] objectForKey:@"name"];
                _Time.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[0] objectForKey:@"djj"],[[classSolution[0] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[0] objectForKey:@"djj"] intValue]],[classSolution[0] objectForKey:@"room"]];
                _Name2.text=[classSolution[1] objectForKey:@"name"];
                _Time2.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[1] objectForKey:@"djj"],[[classSolution[1] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[1] objectForKey:@"djj"] intValue]],[classSolution[1] objectForKey:@"room"]];
                _Name3.text=[classSolution[2] objectForKey:@"name"];
                _Time3.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[2] objectForKey:@"djj"],[[classSolution[2] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[2] objectForKey:@"djj"] intValue]],[classSolution[2] objectForKey:@"room"]];
                _Name4.text=[classSolution[3] objectForKey:@"name"];
                _Time4.text=[NSString stringWithFormat:@"第%@-%d节 %@   %@",[classSolution[3] objectForKey:@"djj"],[[classSolution[3] objectForKey:@"djj"] intValue]+1,[self getTime:[[classSolution[3] objectForKey:@"djj"] intValue]],[classSolution[3] objectForKey:@"room"]];
                _Ico1.hidden=false;
                _Ico2.hidden=false;
                _Ico3.hidden=false;
                _Ico4.hidden=false;
                _Ico5.hidden=false;
                _Ico6.hidden=false;
                _Ico7.hidden=false;
                _Ico8.hidden=false;
                break;
            default:
                break;
        }
 }
    }
}

-(NSString*)getTime:(int)time{
    switch (time) {
        case 1:
            return @"8:00-9:40";
            break;
        case 3:
            return @"10:00-11:40";
            break;
        case 5:
            return @"14:00-15:40";
            break;
        case 7:
            return @"16:00-17:40";
            break;
        case 9:
            return @"19:00-20:40";
            break;
        default:
            return @"";
            break;
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
}
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
        _Xian1.hidden=true;
        _Xian2.hidden=true;
        _Xian3.hidden=true;
    } else{
        switch (_classnum) {
            case 1:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
                break;
            case 2:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 180);
                _Xian1.hidden=false;
                break;
            case 3:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 240);
                _Xian1.hidden=false;
                _Xian2.hidden=false;
                break;
            case 4:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);
                _Xian1.hidden=false;
                _Xian2.hidden=false;
                _Xian3.hidden=false;
                break;
            case 5:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 360);
                _Xian1.hidden=false;
                _Xian2.hidden=false;
                _Xian3.hidden=false;
                break;
            default:
                self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
                break;
        }

    }
}
@end

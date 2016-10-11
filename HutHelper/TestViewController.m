//
//  TestViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/11.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "TestViewController.h"
#import "JSONKit.h"
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UITextView *Show;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Run:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *studentKH=[defaults objectForKey:@"studentKH"];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
    NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/lessons/";
    NSString *Url_String_2=@"/";
    
    NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:studentKH];
    NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
    NSString *Url_String=[Url_String_1_U_2 stringByAppendingString:remember_code_app];
    
    /*地址完毕*/
    
    NSURL *url = [NSURL URLWithString: Url_String]; //接口地址
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *Class_All = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *Class_Data=[Class_All objectForKey:@"data"];
    NSString *name=[Class_All objectForKey:@"data"];
//    NSString *strJson = @"[{\"Id\": 1,\"BrandName\": \"爱马仕\" },{\"Id\": 2,\"BrandName\": \"安娜苏\"}]";
//    NSArray *arrlist=[strJson objectFromJSONString];
//    NSLog(@"%d",[arrlist count]);
//    NSLog(@"1%@",Class_Data);
    
    NSArray *array = [Class_All objectForKey:@"data"];
     NSDictionary *dict1 = array[9];
    NSString *ClassName = [dict1 objectForKey:@"name"];  //课名
    NSString *dsz = [dict1 objectForKey:@"dsz"];  //单双周
    NSInteger *dsz_num=2;
    if ([dsz isEqualToString: @"单"])
        dsz_num=1;
    else
        dsz_num=2;
    
    NSString *StartClass = [dict1 objectForKey:@"djj"]; //第几节
    NSInteger *StartClass_num= [StartClass intValue];
    NSString *EndWeek = [dict1 objectForKey:@"jsz"];  //结束周
    NSInteger *EndWeek_num= [EndWeek intValue];
    NSString *StartWeek = [dict1 objectForKey:@"qsz"];  //起始周
    NSInteger *StartWeek_num= [StartWeek intValue];
    NSString *Room = [dict1 objectForKey:@"room"];  //教室
    NSString *Teacher = [dict1 objectForKey:@"teacher"];  //老师
    NSString *WeekDay = [dict1 objectForKey:@"xqj"];  //第几天
    NSInteger *WeekDay_num= [WeekDay intValue];
    
    NSString *tmp=@"10";
    NSInteger i=[tmp intValue];
    
    NSLog(@"课程名:%@",ClassName);
    NSLog(@"教室:%@",Room);
    NSLog(@"第几天:%@",WeekDay);
    NSLog(@"第几节:%d",StartClass_num);
    NSLog(@"起始周%@",StartWeek);
    NSLog(@"结束周:%@",EndWeek);
    NSLog(@"单双周:%d",dsz_num);
     NSLog(@"老师:%@",Teacher);
    
    //    NSArray* dictArr = [NSJSONSerialization JSONObjectWithData:@"这段json的NSData形式" options:NSJSONReadingMutableContainers error:nil];
    //   NSString* titleStrr = dictArr[0][@"item"][index][@"title"];  //其中index⋲[0,item数-1]
    
    
    //当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
     NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        int year = [dateComponent year]; //年
        int month = [dateComponent month]; //月
        int day = [dateComponent day];  //日
    //

    
}

- (IBAction)Test:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"one",@"2",@"two",@"3",@"three",@"2015-4-23",@"today",@"xiaohong",@"name",@"2015-4-23",@"date", nil];
    NSLog(@"dict:%@",dict);
    
}


@end

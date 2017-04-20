//
//  ExamViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/7.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ExamViewController.h"
#import "UMMobClick/MobClick.h"

#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ExamCell.h"
#import "JSONKit.h"
#include <stdio.h>
#include <time.h>
#import<CommonCrypto/CommonDigest.h>
#import "MJRefresh.h"
@interface ExamViewController ()

@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *arraycx;
@end
@implementation NSString (MMD5)
- (id)MMD5
{
    const char *cStr           = [self UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    // This is the md5 call
    NSMutableString *output    = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i                  = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
@implementation ExamViewController

int datediff(int y1,int m1,int d1,int y2,int m2,int d2)
{
    struct tm ptr1;
    ptr1.tm_sec=10;
    ptr1.tm_min=10;
    ptr1.tm_hour=10;
    ptr1.tm_mday=d1;
    ptr1.tm_mon=m1-1;
    ptr1.tm_year=y1-1900;
    time_t st1=mktime(&ptr1);
    struct tm ptr2;
    ptr2.tm_sec=10;
    ptr2.tm_min=10;
    ptr2.tm_hour=10;
    ptr2.tm_mday=d2;
    ptr2.tm_mon=m2-1;
    ptr2.tm_year=y2-1900;
    time_t st2=mktime(&ptr2);
    return (int)((st2-st1)/3600/24);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"考试查询";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadexam)];
    //获得考试信息
    [self getexam];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - "设置表格代理"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _array.count+_arraycx.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamCell *cell=[ExamCell tableViewCell];
    NSDictionary *dict1;
    NSString *CourseName       ;
    NSString *RoomName        ;
    NSString *Starttime       ;
    NSString *isset           ;
    NSString *EndTime           ;
    NSString *Exam_Time;//拆分后的时间
    NSString *Week_Num;
    int i;
    /**考试数据*/
    if (indexPath.section<_array.count)
        dict1=_array[indexPath.section];
    else if(indexPath.section<_arraycx.count+_array.count)
        dict1=_arraycx[indexPath.section-_array.count];
    /**考试信息*/
    RoomName         = [dict1 objectForKey:@"RoomName"];//考试教室
    CourseName       = [dict1 objectForKey:@"CourseName"];//考试名称
    Starttime        = [dict1 objectForKey:@"Starttime"];//开始时间
    isset            = [dict1 objectForKey:@"isset"];//考试状态
    EndTime         = [dict1 objectForKey:@"EndTime"];//结束时间
    Week_Num= [dict1 objectForKey:@"Week_Num"];//第几周
    /**避免信息为NULL的情况*/
    if ([RoomName isEqual:[NSNull null]])   RoomName  = @"-";//起始周
    if ([CourseName isEqual:[NSNull null]])  CourseName= @"-";
    if ([Starttime isEqual:[NSNull null]])   Starttime = @"-";
    if ([EndTime isEqual:[NSNull null]])   EndTime = @"-";
    if ([isset isEqual:[NSNull null]])        isset   = @"-";
    /**添加重修标志*/
    if (indexPath.section>=_array.count&&indexPath.section<_arraycx.count+_array.count)
        CourseName=[@"【重修】" stringByAppendingString:CourseName];
    /**计算考试时间*/
    int Year,Mouth,Day,Hour,Minutes,End_Hour,End_Minutes=0;
    if (![EndTime isEqual:@"-"]) {
        End_Hour=[[Starttime substringWithRange:NSMakeRange(11,2)] intValue];
        End_Minutes=[[Starttime substringWithRange:NSMakeRange(14,2)] intValue];
    }
    if (![Starttime isEqual:@"-"]) {
        Year=[[Starttime substringWithRange:NSMakeRange(0,4)] intValue];
        Mouth=[[Starttime substringWithRange:NSMakeRange(5,2)] intValue];
        Day=[[Starttime substringWithRange:NSMakeRange(8,2)] intValue];
        Hour=[[Starttime substringWithRange:NSMakeRange(11,2)] intValue];
        Minutes=[[Starttime substringWithRange:NSMakeRange(14,2)] intValue];
    }
    if (![EndTime isEqual:@"-"]&&![Starttime isEqual:@"-"]) {
        NSString *String_Minutes,*String_End_Minutes;
        if (Minutes==0)
            String_Minutes=@"00";
        else
            String_Minutes=[NSString stringWithFormat:@"%d",Minutes];
        if (End_Minutes==0)
            String_End_Minutes=@"00";
        else
            String_End_Minutes=[NSString stringWithFormat:@"%d",End_Minutes];
        
        Exam_Time=[NSString stringWithFormat:@"%@周/%d.%d.%d/%d:%@-%d:%@",Week_Num,Year,Mouth,Day,Hour,String_Minutes,End_Hour,String_End_Minutes];
    }
    else
        Exam_Time=@"-";
    NSLog(@"%@",Exam_Time);
    /**计算倒计时*/
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 = (short)[dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    NSString *lastime;
    if (datediff(year,month,day,Year,Mouth,Day)>0&&datediff(year,month,day,Year,Mouth,Day)<500) {
        lastime=[[NSString alloc]initWithFormat:@"倒计时%d天",datediff(year,month,day,Year,Mouth,Day)];
    }
    else if (datediff(year,month,day,Year,Mouth,Day)<0){
        lastime=@"已结束";
    }
    else if (datediff(year,month,day,Year,Mouth,Day)==0){
        lastime=@"今天考试";
    }
    else lastime=@"-";
    /**考试状态*/
    if ([isset isEqualToString:@"1"]) {
        isset=@"已执行";
    }
    else if([isset isEqualToString:@"0"]){
        isset=@"计划中";
    }
    else{
        isset=@"-";
    }
    cell.userInteractionEnabled=NO;
    cell.Label_ExamName.text=CourseName;
    cell.Label_ExamRoom.text=RoomName;
    cell.Label_ExamTime.text=Exam_Time;
    cell.Label_ExamIsset.text=isset;
    cell.Label_ExamLast.text=lastime;
    
    //  NSLog(@"%@",dict1);
    return cell;
}
#pragma mark - "读取考试信息"
-(void)getexam{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *jsonData=[defaults objectForKey:@"Exam"];
    NSDictionary *User_All     = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *Class_Data=[User_All objectForKey:@"res"];
    _array  = [Class_Data objectForKey:@"exam"];
    _arraycx = [Class_Data objectForKey:@"cxexam"];
}
-(void)reloadexam{
    /**拼接地址*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *ss=[Config.getStudentKH stringByAppendingString:@"apiforapp!"];
    ss=[ss MMD5];
    NSString *Url_String=[NSString stringWithFormat:API_EXAM,Config.getStudentKH,ss];
    NSLog(@"考试地址:%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Exam_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSData *Exam_data =    [NSJSONSerialization dataWithJSONObject:Exam_All options:NSJSONWritingPrettyPrinted error:nil];
             NSString *status=[Exam_All objectForKey:@"status"];
             if([status isEqualToString:@"success"]){
                 NSDictionary *Class_Data=[Exam_All objectForKey:@"res"];
                 NSMutableArray *array             = [Class_Data objectForKey:@"exam"];
                 [Config saveExam:Exam_data];
                 if(array.count!=0){
                     [self.tableView reloadData];
                     [self.tableView.mj_header endRefreshing];
                 }
                 else{
                     [MBProgressHUD showError:@"计划表上暂无考试"];
                 }
             }
             else{
                 
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             [self.tableView.mj_header endRefreshing];
         }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"考试计划"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"考试计划"];
}

@end

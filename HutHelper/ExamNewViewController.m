//
//  ExamNewViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/7.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ExamNewViewController.h"
#import "ExamCell.h"
#import "JSONKit.h"
#include <stdio.h>
#include <time.h>
@interface ExamNewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *arraycx;
@end

@implementation ExamNewViewController

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
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(reloadexam) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    //获得考试信息
    [self getexam];

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
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
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
 NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    
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

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
#import "MJRefresh.h"
#import "APIRequest.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ExamViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, retain) NSMutableArray *arraycx;
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
    self.navigationItem.title = @"考试计划";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //获得考试信息
    [self getexam];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(50))];
    UIImageView *noticeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(40))];
    noticeImgView.image=[UIImage imageNamed:@"img_exam_notice"];
    [headView addSubview:noticeImgView];
    self.tableView.tableHeaderView=headView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadexam)];
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    [self.tableView.mj_header beginRefreshing];

    /**让黑线消失的方法*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
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
    if (section==0) {
        return 0;
    }
    return 1;
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
    if (indexPath.section>=_array.count&&indexPath.section<_arraycx.count+_array.count){
        if (![CourseName isEqualToString:@"尔雅网络课程"]) {
            CourseName=[@"【重修】" stringByAppendingString:CourseName];
        }
    }
    /**计算考试时间*/
    int Year=0,Mouth=0,Day=0,Hour=0,Minutes = 0,End_Hour=0,End_Minutes=0;
    if (![EndTime isEqual:@"-"]) {
        End_Hour=[[EndTime substringWithRange:NSMakeRange(11,2)] intValue];
        End_Minutes=[[EndTime substringWithRange:NSMakeRange(14,2)] intValue];
    }
    if (![Starttime isEqual:@"-"]) {
        Year=[[Starttime substringWithRange:NSMakeRange(0,4)] intValue];
        Mouth=[[Starttime substringWithRange:NSMakeRange(5,2)] intValue];
        Day=[[Starttime substringWithRange:NSMakeRange(8,2)] intValue];
        Hour=[[Starttime substringWithRange:NSMakeRange(11,2)] intValue];
        Minutes=[[Starttime substringWithRange:NSMakeRange(14,2)] intValue];
    }
    if (![EndTime isEqual:@"-"]&&![Starttime isEqual:@"-"]) {
        NSString *String_Minutes;
        NSString *String_End_Minutes;
        if (Minutes==0){
            String_Minutes=@"00";
        }else{
            String_Minutes=[NSString stringWithFormat:@"%d",Minutes];
        }
        if (End_Minutes==0){
            String_End_Minutes=@"00";
        }else{
            String_End_Minutes=[NSString stringWithFormat:@"%d",End_Minutes];
        }
        Exam_Time=[NSString stringWithFormat:@"(周%@ %d:%@-%d:%@)",[Math transforDay:[Math getWeekDay:Year m:Mouth d:Day]],Hour,String_Minutes,End_Hour,String_End_Minutes];
    }
    else{
        Exam_Time=@"-";
    }
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
        lastime=[[NSString alloc]initWithFormat:@"剩余%d天",datediff(year,month,day,Year,Mouth,Day)];
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
    NSString *mouthString;
    if (Mouth<10) {
        mouthString=[NSString stringWithFormat:@"0%d",Mouth];
    }else{
        mouthString=[NSString stringWithFormat:@"%d",Mouth];
    }
    
    cell.examDayLabel.text=[NSString stringWithFormat:@"%@月%d日",mouthString,Day];
    cell.Label_ExamName.text=CourseName;
    cell.examDayLabel.font=[UIFont systemFontOfSize:SYReal(29)];
    cell.Label_ExamRoom.text=RoomName;
    cell.Label_ExamTime.text=Exam_Time;
 //   cell.Label_ExamIsset.text=isset;
    cell.Label_ExamLast.text=lastime;
    cell.Label_ExamLast.font=[UIFont systemFontOfSize:SYReal(15)];
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

    [APIRequest GET:Config.getApiExam parameters:nil success:^(id responseObject) {
        NSDictionary *Exam_All = [NSDictionary dictionaryWithDictionary:responseObject];
        NSData *Exam_data =    [NSJSONSerialization dataWithJSONObject:Exam_All options:NSJSONWritingPrettyPrinted error:nil];
        NSString *status=[Exam_All objectForKey:@"status"];
        if([status isEqualToString:@"success"]){
            NSDictionary *Class_Data=[Exam_All objectForKey:@"res"];
            NSMutableArray *array             = [Class_Data objectForKey:@"exam"];
            [Config saveExam:Exam_data];
            [Config saveWidgetExam:Class_Data];
            _array  = [Class_Data objectForKey:@"exam"];
            _arraycx = [Class_Data objectForKey:@"cxexam"];
            if(array.count!=0){
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            else{
                [MBProgressHUD showError:@"计划表上暂无考试" toView:self.view];
            }
        }
        else{
            
            [MBProgressHUD showError:@"超时,显示本地数据" toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"可能刚开学没有考试哦~" toView:self.view];
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
#pragma mark - 空白状态代理
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ui_tableview_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关内容";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"请检查网络并重试";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(238, 239, 240, 1);
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    [self.tableView.mj_header beginRefreshing];
}
@end

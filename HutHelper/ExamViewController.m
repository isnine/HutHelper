//
//  ExamViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/15.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ExamViewController.h"
#import "MyView.h"
#import "MsgModel.h"
#import "JSONKit.h"
#import "UMMobClick/MobClick.h"
#include <stdio.h>
#include <time.h>
@interface ExamViewController (){
   UIScrollView * scrollView;
   MyView * myView;
   UIView * dataPiker;
}
@end
@implementation NSString (MD5)
 - (id)MD5
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
    self.title=@"考试计划";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    MsgModel * mode0=[[MsgModel alloc]init];
    MsgModel * mode1=[[MsgModel alloc]init];
    MsgModel * mode2=[[MsgModel alloc]init];
    MsgModel * mode3=[[MsgModel alloc]init];
    MsgModel * mode4=[[MsgModel alloc]init];
    MsgModel * mode5=[[MsgModel alloc]init];
    MsgModel * mode6=[[MsgModel alloc]init];
    MsgModel * mode7=[[MsgModel alloc]init];
    MsgModel * mode8=[[MsgModel alloc]init];
    MsgModel * mode9=[[MsgModel alloc]init];
    MsgModel * mode10=[[MsgModel alloc]init];
    MsgModel * mode11=[[MsgModel alloc]init];
    MsgModel * mode12=[[MsgModel alloc]init];

    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //历史浏览按钮
    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 50, 50)];
    [rightButtonView addSubview:historyBtn];
    [historyBtn setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(times) forControlEvents:UIControlEventTouchUpInside];
#pragma mark >>>>>主页搜索按钮
    //主页搜索按钮
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    

    
    NSData *jsonData=[defaults objectForKey:@"data_exam"];
    NSDictionary *User_All     = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *Class_Data=[User_All objectForKey:@"res"];
    NSArray *array             = [Class_Data objectForKey:@"exam"];
     int k;
    for(k                      = 0;k<array.count;k++){
    NSDictionary *dict1        = array[k];

        NSString *CourseName       ;
    
        NSString *RoomName        ;//起始周
        NSString *Starttime       ;

        NSString *isset            ;
   

RoomName         = [dict1 objectForKey:@"RoomName"];//起始周
CourseName       = [dict1 objectForKey:@"CourseName"];
Starttime        = [dict1 objectForKey:@"Starttime"];//起始周
isset            = [dict1 objectForKey:@"isset"];//起始周
        if ([RoomName isEqual:[NSNull null]]) {
            RoomName  = @"-";//起始周
        }
        if ([CourseName isEqual:[NSNull null]]) {
           CourseName       = @"-";
        }
        if ([Starttime isEqual:[NSNull null]]) {
            Starttime        = @"";//起始周

        }
        if ([isset isEqual:[NSNull null]]) {
            isset            = 0;//起始周
        }
        
        
        /**计算倒计时天数*/
        int Year;
        int Mouth;
        int Day;
        if (![Starttime isEqual:@""]) {
        Starttime=[Starttime substringToIndex:16];
        Year=[[Starttime substringWithRange:NSMakeRange(0,4)] intValue];
       Mouth=[[Starttime substringWithRange:NSMakeRange(5,2)] intValue];
         Day=[[Starttime substringWithRange:NSMakeRange(8,2)] intValue];
             }
        NSLog(@"%d年%d月%d日",Year,Mouth,Day);
        NSDate *now                               = [NSDate date];
        NSCalendar *calendar                      = [NSCalendar currentCalendar];
        NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
        int year                                  = [dateComponent year];//年
        int month                                 = [dateComponent month];//月
        int day                                   = [dateComponent day];//日
        
        NSLog(@"还有%d天考%@",datediff(year,month,day,Year,Mouth,Day),CourseName);
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *time=[defaults objectForKey:@"lasttime"];
        if ([time isEqualToString:@"打开"]&&(datediff(year,month,day,Year,Mouth,Day)>0)) {
            Starttime=[[NSString alloc]initWithFormat:@"倒计时%d天",datediff(year,month,day,Year,Mouth,Day)];
        }
        else if ([time isEqualToString:@"打开"]&&(datediff(year,month,day,Year,Mouth,Day)<0)){
            Starttime=@"已结束";
        }
        else if ([time isEqualToString:@"打开"]&&(datediff(year,month,day,Year,Mouth,Day)==0)){
            Starttime=@"今天考试";
        }
            switch (k) {
                case 0:
    mode0.address              = CourseName;
    mode0.motive               = RoomName;
    mode0.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode0.color=[UIColor redColor];
                    }
                    else
                        mode0.color=[UIColor greenColor];
                    break;
                case 1:
                 
    mode1.address              = CourseName;
    mode1.motive               = RoomName;
    mode1.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode1.color=[UIColor redColor];
                    }
                    else
                        mode1.color=[UIColor greenColor];
                    break;
                case 2:
                    
    mode2.address              = CourseName;
    mode2.motive               = RoomName;
    mode2.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode2.color=[UIColor redColor];
                    }
                    else
                        mode2.color=[UIColor greenColor];
                    break;
                case 3:
    mode3.address              = CourseName;
    mode3.motive               = RoomName;
    mode3.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode3.color=[UIColor redColor];
                    }
                    else
                        mode3.color=[UIColor greenColor];
                    break;
                case 4:
    mode4.address              = CourseName;
    mode4.motive               = RoomName;
    mode4.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode4.color=[UIColor redColor];
                    }
                    else
                        mode4.color=[UIColor greenColor];
                    break;
                case 5:
    mode5.address              = CourseName;
    mode5.motive               = RoomName;
    mode5.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode5.color=[UIColor redColor];
                    }
                    else
                        mode5.color=[UIColor greenColor];
                    break;
                case 6:
    mode6.address              = CourseName;
    mode6.motive               = RoomName;
    mode6.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode6.color=[UIColor redColor];
                    }
                    else
                        mode6.color=[UIColor greenColor];
                    break;
                case 7:
    mode7.address              = CourseName;
    mode7.motive               = RoomName;
    mode7.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode7.color=[UIColor redColor];
                    }
                    else
                        mode7.color=[UIColor greenColor];
                    break;
                case 8:
    mode8.address              = CourseName;
    mode8.motive               = RoomName;
    mode8.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode8.color=[UIColor redColor];
                    }
                    else
                        mode8.color=[UIColor greenColor];
                    break;
                case 9:
    mode9.address              = CourseName;
    mode9.motive               = RoomName;
    mode9.date                 = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode9.color=[UIColor redColor];
                    }
                    else
                        mode9.color=[UIColor greenColor];
                    break;
                case 10:
    mode10.address             = CourseName;
    mode10.motive              = RoomName;
    mode10.date                = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode10.color=[UIColor redColor];
                    }
                    else
                        mode10.color=[UIColor greenColor];
                    break;
                case 11:
    mode11.address             = CourseName;
    mode11.motive              = RoomName;
    mode11.date                = Starttime;
                    if ([isset isEqualToString:@"0"]) {
                        mode11.color=[UIColor redColor];
                    }
                    else
                        mode11.color=[UIColor greenColor];
                    break;
                default:
                    break;
            }

    


        
    }
   
  
    myView=[[MyView alloc]init];
    MsgModel * model=[[MsgModel alloc]init];

    switch (array.count) {
        case 0:{
    UIAlertView *alertView1    = [[UIAlertView alloc] initWithTitle:@"暂无考试"
                                                                message:@"计划表上暂时没有考试"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView1 show];
            break;
        }
        case 1:
            myView.msgModelArray=@[mode0];
            break;
        case 2:
            myView.msgModelArray=@[mode0,mode1];
            break;
        case 3:
            myView.msgModelArray=@[mode0,mode1,mode2];
            break;
        case 4:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3];
            break;
        case 5:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4];
            break;
        case 6:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5];
            break;
        case 7:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6];
            break;
        case 8:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7];
            break;
        case 9:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8];
            break;
        case 10:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9];
            break;
        case 11:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10];
            break;
        default:
            break;
    }
   
    NSLog(@"相差天%d",datediff(2016,12,30,2016,12,30));

}

-(void)times{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *time=[defaults objectForKey:@"lasttime"];
    if ([time isEqualToString:@"打开"]) {
        [defaults setObject:@"关闭" forKey:@"lasttime"];
        [defaults synchronize];
    }
    else
    {
        [defaults setObject:@"打开" forKey:@"lasttime"];
        [defaults synchronize];
    }
    myView=[[MyView alloc]init];
    MsgModel * model=[[MsgModel alloc]init];
    MsgModel * mode0=[[MsgModel alloc]init];

    mode0.address              = @"1";
    mode0.motive               = @"2";
    mode0.date                 = @"3";
    myView.msgModelArray=@[mode0];
}

- (void)help{
    UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                           message:@"【红灯】代表考试正在计划中\n【绿灯】代表考试正在执行中,时间不再变动"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                                 otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"考试计划"];//("PageOne"为页面名称，可自定义)
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
    dataPiker=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, SP_W(60))];
    myView.frame               = CGRectMake(0,SP_W(0), WIDTH, SP_W(60)*myView.msgModelArray.count+65);
    scrollView.contentSize     = CGSizeMake(0, SP_W(60)*(myView.msgModelArray.count+2)+SP_W(30));
    [scrollView addSubview:dataPiker];
    [scrollView addSubview:myView];
    [self.view addSubview:scrollView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"考试计划"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

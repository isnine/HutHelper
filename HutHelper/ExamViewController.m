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
#import "AppDelegate.h"
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
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
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
    MsgModel * mode13=[[MsgModel alloc]init];
    MsgModel * mode14=[[MsgModel alloc]init];
    MsgModel * mode15=[[MsgModel alloc]init];
    MsgModel * mode16=[[MsgModel alloc]init];
    MsgModel * mode17=[[MsgModel alloc]init];
    MsgModel * mode18=[[MsgModel alloc]init];
    MsgModel * mode19=[[MsgModel alloc]init];
    MsgModel * mode20=[[MsgModel alloc]init];
    MsgModel * mode21=[[MsgModel alloc]init];
    //右侧按钮
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //历史浏览按钮
    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 50, 50)];
    [rightButtonView addSubview:historyBtn];
    [historyBtn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
#pragma mark >>>>>主页搜索按钮
    //主页搜索按钮
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    //----添加按钮


    
    NSData *jsonData=[defaults objectForKey:@"data_exam"];
    NSDictionary *User_All     = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *Class_Data=[User_All objectForKey:@"res"];
    NSMutableArray *array  = [Class_Data objectForKey:@"exam"];
  NSMutableArray *arraycx = [Class_Data objectForKey:@"cxexam"];
   
    int newexam=0;
    NSString *examcet=[defaults objectForKey:@"examcet"];
    if ([examcet isEqualToString:@"打开"]) {
        newexam=1;
    }
    else{
        newexam=0;
    }
    
    NSLog(@"考试%d",array.count+arraycx.count);
     int k;
    int kcx=0;
    for(k      = 0;k<array.count+arraycx.count+newexam;k++){
        NSDictionary *dict1;
        
        
        NSString *CourseName       ;
        
        NSString *RoomName        ;//起始周
        NSString *Starttime       ;
        
        NSString *isset            ;
        
       // NSLog(@"正常考试数目:%d,重修考试数目:%d",array.count,arraycx.count);
       if(k<array.count){
            dict1        = array[k];
            RoomName         = [dict1 objectForKey:@"RoomName"];//起始周
            CourseName       = [dict1 objectForKey:@"CourseName"];
            Starttime        = [dict1 objectForKey:@"Starttime"];//起始周
            isset            = [dict1 objectForKey:@"isset"];//起始周

        }
        else if(k>=array.count&&k<array.count+arraycx.count){
            dict1        = arraycx[kcx];
            RoomName         = [dict1 objectForKey:@"RoomName"];//起始周
            CourseName       = [dict1 objectForKey:@"CourseName"];
            Starttime        = [dict1 objectForKey:@"Starttime"];//起始d周
            isset            = [dict1 objectForKey:@"isset"];//起始周
            NSLog(@"【】课程:%@，序列:%d",CourseName,kcx);
            NSLog(@"%@",dict1);
            kcx=kcx+1;
            
           // NSLog(@"【2】k的值为%d三个判断值为%d %d %d",k,array.count,array.count+arraycx.codunt,array.count+arraycx.count+newexam);
        }
        else if(k>=array.count+arraycx.count){
            RoomName         = @"-";//起始周
            CourseName       = @"英语四六级考试";
            Starttime        = @"2017-06-17";//起始周
            isset            = @"1";//起始周
           // NSLog(@"【3】k的值为%d三个判断值为%d %d %d",k,array.count,array.count+arraycx.count,array.count+arraycx.count+newexam);
        }
        else{
            RoomName         = @"-";//起始周
            CourseName       = @"-";
            Starttime        = @"-";//起始周
            isset            = @"0";//起始周
        }
    
        
        
        
        
        if ([RoomName isEqual:[NSNull null]]) {
            RoomName  = @"-";//起始周
        }
        if ([CourseName isEqual:[NSNull null]]) {
           CourseName       = @"-";
        }
        if ([Starttime isEqual:[NSNull null]]) {
            Starttime        = @"-";//起始周

        }
        if ([isset isEqual:[NSNull null]]) {
            isset            = 0;//起始周
        }
        
        if (k>=array.count) {
            CourseName  = [@"*" stringByAppendingString:CourseName];
        }

      // NSLog(@"%@年%@月%@日",[Starttime substringWithRange:NSMakeRange(0,4)],[Starttime substringWithRange:NSMakeRange(5,2)],[Starttime substringWithRange:NSMakeRange(8,2)]);
        
        /**计算倒计时天数*/
        int Year;
        int Mouth;
        int Day;
        if (![Starttime isEqual:@"-"]) {
        Year=[[Starttime substringWithRange:NSMakeRange(0,4)] intValue];
       Mouth=[[Starttime substringWithRange:NSMakeRange(5,2)] intValue];
         Day=[[Starttime substringWithRange:NSMakeRange(8,2)] intValue];
             }
     //   NSLog(@"%d年%d月%d日",Year,Mouth,Day);
        NSDate *now                               = [NSDate date];
        NSCalendar *calendar                      = [NSCalendar currentCalendar];
        NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
        int year                                  = [dateComponent year];//年
        int month                                 = [dateComponent month];//月
        int day                                   = [dateComponent day];//日
        NSString *lastime;
        NSLog(@"还有%d天考%@",datediff(year,month,day,Year,Mouth,Day),CourseName);
        
        if (datediff(year,month,day,Year,Mouth,Day)>0) {
                  lastime=[[NSString alloc]initWithFormat:@"倒计时%d天",datediff(year,month,day,Year,Mouth,Day)];
        }
        else if (datediff(year,month,day,Year,Mouth,Day)<0){
            lastime=@"已结束";
        }
        else if (datediff(year,month,day,Year,Mouth,Day)==0){
            lastime=@"今天考试";
        }

            switch (k) {
                case 0:
    mode0.address              = CourseName;
    mode0.motive               = RoomName;
    mode0.date                 = Starttime;
    mode0.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode0.color=[UIColor redColor];
                    }
                    else
                        mode0.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode0.color=[UIColor greenColor];
                    break;
                case 1:
                 
    mode1.address              = CourseName;
    mode1.motive               = RoomName;
    mode1.date                 = Starttime;
       mode1.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode1.color=[UIColor redColor];
                    }
                    else
                        mode1.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode1.color=[UIColor greenColor];
                    break;
                case 2:
                    
    mode2.address              = CourseName;
    mode2.motive               = RoomName;
    mode2.date                 = Starttime;
                        mode2.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode2.color=[UIColor redColor];
                    }
                    else
                        mode2.color=[UIColor yellowColor];
                    
                    if([lastime isEqualToString:@"已结束"])
                        mode2.color=[UIColor greenColor];
                    break;
                case 3:
    mode3.address              = CourseName;
    mode3.motive               = RoomName;
    mode3.date                 = Starttime;
                        mode3.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode3.color=[UIColor redColor];
                    }
                    else
                        mode3.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode3.color=[UIColor greenColor];
                    break;
                case 4:
    mode4.address              = CourseName;
    mode4.motive               = RoomName;
    mode4.date                 = Starttime;
                        mode4.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode4.color=[UIColor redColor];
                    }
                    else
                        mode4.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode4.color=[UIColor greenColor];
                    break;
                case 5:
    mode5.address              = CourseName;
    mode5.motive               = RoomName;
    mode5.date                 = Starttime;
                        mode5.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode5.color=[UIColor redColor];
                    }
                    else
                        mode5.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode5.color=[UIColor greenColor];
                    break;
                case 6:
    mode6.address              = CourseName;
    mode6.motive               = RoomName;
    mode6.date                 = Starttime;
                        mode6.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode6.color=[UIColor redColor];
                    }
                    else
                        mode6.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode6.color=[UIColor greenColor];
                    break;
                case 7:
    mode7.address              = CourseName;
    mode7.motive               = RoomName;
    mode7.date                 = Starttime;
                        mode7.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode7.color=[UIColor redColor];
                    }
                    else
                        mode7.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode7.color=[UIColor greenColor];
                    break;
                case 8:
    mode8.address              = CourseName;
    mode8.motive               = RoomName;
    mode8.date                 = Starttime;
                        mode8.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode8.color=[UIColor redColor];
                    }
                    else
                        mode8.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode8.color=[UIColor greenColor];
                    break;
                case 9:
    mode9.address              = CourseName;
    mode9.motive               = RoomName;
    mode9.date                 = Starttime;
                        mode9.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode9.color=[UIColor redColor];
                    }
                    else
                        mode9.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode9.color=[UIColor greenColor];
                    break;
                case 10:
    mode10.address             = CourseName;
    mode10.motive              = RoomName;
    mode10.date                = Starttime;
                        mode10.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode10.color=[UIColor redColor];
                    }
                    else
                        mode10.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode10.color=[UIColor greenColor];
                    break;
                case 11:
    mode11.address             = CourseName;
    mode11.motive              = RoomName;
    mode11.date                = Starttime;
                        mode11.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode11.color=[UIColor redColor];
                    }
                    else
                        mode11.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode11.color=[UIColor greenColor];
                    break;
                case 12:
                    mode12.address             = CourseName;
                    mode12.motive              = RoomName;
                    mode12.date                = Starttime;
                    mode12.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode12.color=[UIColor redColor];
                    }
                    else
                        mode12.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode12.color=[UIColor greenColor];
                    break;
                case 13:
                    mode13.address             = CourseName;
                    mode13.motive              = RoomName;
                    mode13.date                = Starttime;
                    mode13.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode13.color=[UIColor redColor];
                    }
                    else
                        mode13.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode13.color=[UIColor greenColor];
                    break;
                case 14:
                    mode14.address             = CourseName;
                    mode14.motive              = RoomName;
                    mode14.date                = Starttime;
                    mode14.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode14.color=[UIColor redColor];
                    }
                    else
                        mode14.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode14.color=[UIColor greenColor];
                    break;
                case 15:
                    mode15.address             = CourseName;
                    mode15.motive              = RoomName;
                    mode15.date                = Starttime;
                    mode15.last                 =lastime;
                    if ([isset isEqualToString:@"0"]) {
                        mode15.color=[UIColor redColor];
                    }
                    else
                        mode15.color=[UIColor yellowColor];
                    if([lastime isEqualToString:@"已结束"])
                        mode15.color=[UIColor greenColor];
                    break;
                default:
                    break;
            }     
    }
   
  
    myView=[[MyView alloc]init];
    MsgModel * model=[[MsgModel alloc]init];

    switch (array.count+arraycx.count+newexam) {
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
        case 12:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10,mode11];
            break;
        case 13:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10,mode11,mode12];
            break;
        case 14:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10,mode11,mode12,mode13];
            break;
        case 15:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10,mode11,mode12,mode13,mode14];
            break;
        case 16:
            myView.msgModelArray=@[mode0,mode1,mode2,mode3,mode4,mode5,mode6,mode7,mode8,mode9,mode10,mode11,mode12,mode13,mode14,mode15];
            break;
        default:
            break;
    }
   
  

}

-(void)add{
            UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ExamViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"examadd"];
            AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}

- (void)help{
    UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                           message:@"绿灯 - 已完成\n黄灯 - 执行中，时间地点不会变化\n红灯 - 计划中，时间地点可能变化"
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

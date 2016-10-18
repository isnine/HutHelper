//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "HomeWorkViewController.h"
#import "ClassViewController.h"
#import "PowerViewController.h"
#import "LibraryViewController.h"
#import "NoticeViewController.h"
#import "SchoolsayViewController.h"
#import "SchoolHandViewController.h"
#import "DayViewController.h"
#import "ExamViewController.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import "FirstLoginViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "ScoreViewController.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Scontent;


@end

@implementation MainPageViewController
const int startyear                       = 2016;
const int startmonth                      = 8;
const int startday                        = 29;


int CountDays(int year, int month, int day) {
    //返回当前是本年的第几天，year,month,day 表示现在的年月日，整数。
int a[12]                                 = {31,0,31,30,31,30,31,31,30,31,30,31};
int s                                     = 0;
for(int i                                 = 0; i < month-1; i++) {
s                                         += a[i];
    }
    if(month > 2) {
        if(year % (year % 100 ? 4 : 400 ) ? 0 : 1)
s                                         += 29;
        else
s                                         += 28;
    }

    return (s + day);
}


int CountWeeks(int nowyear, int nowmonth, int nowday) {
    //返回当前是本学期第几周，nowyear,nowmonth,nowday 表示现在的年月日，整数。
int ans                                   = 0;
    if (nowyear == startyear) {
ans                                       = CountDays(nowyear, nowmonth, nowday) - CountDays(startyear, startmonth, startday) + 1;
        printf("%d\n", ans);
    } else {
ans                                       = CountDays(nowyear, nowmonth, nowday) - CountDays(nowyear, 1, 1) + 1;
        printf("%d\n", ans);
ans                                       += (CountDays(startyear, 12, 31) - CountDays(startyear, startmonth, startday) + 1);
        printf("%d\n", ans);
    }
    return (ans + 6) / 7;
}

- (NSString *) SHA:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ScoreViewController *Score      = [[ScoreViewController alloc] init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Score animated:NO];
    //测试
self.navigationItem.title                 = @"主界面";
UIColor *greyColor                        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
self.view.backgroundColor                 = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];   //标题字体颜色
Class cls                                 = NSClassFromString(@"UMANUtil");
SEL deviceIDSelector                      = @selector(openUDIDString);
NSString *deviceID                        = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
deviceID                                  = [cls performSelector:deviceIDSelector];
    }
NSData* jsonData                          = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];

    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);



UIButton *menuBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
menuBtn.frame                             = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];


    //-------判断第几周---------//
NSDate *now                               = [NSDate date];
NSCalendar *calendar                      = [NSCalendar currentCalendar];
NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
int year                                  = [dateComponent year];//年
int month                                 = [dateComponent month];//月
int day                                   = [dateComponent day];//日
        [defaults setInteger:CountWeeks(year, month, day) forKey:@"NowWeek"];
    //判断完毕//
    

    //-----是否打开课程表----//
    

    NSString *studentKH                       = [defaults objectForKey:@"studentKH"];
    if(studentKH==NULL){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FirstLoginViewController *firstlogin                = [[FirstLoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    


NSArray *array                            = [defaults objectForKey:@"array"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    //-----是否打开课程表----//

NSString *name_tag                        = [defaults objectForKey:@"TrueName"];
NSString *class_name                      = [defaults objectForKey:@"class_name"];
NSString *dep_name                        = [defaults objectForKey:@"dep_name"];
    if(name_tag!=NULL){
        [UMessage addTag:name_tag
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    //add your codes
                }];
        [MobClick profileSignInWithPUID:@"name_tag"];
    }
    if(class_name!=NULL){
            [UMessage addTag:class_name
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        //add your codes
                    }];}
    if(dep_name!=NULL){
                [UMessage addTag:dep_name
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            //add your codes
                        }];}

    [UMessage addTag:@"版本1.1.5"
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    //add your codes
                }];
        //---标签添加---//

        [defaults setInteger:0 forKey:@"xp_on"];
        //课表数据归元//

NSString *ifarray_xp                      = [defaults objectForKey:@"array_xp"];
        if(studentKH!=NULL&&ifarray_xp==NULL)
        {
         NSString *Remember_code_app=[defaults objectForKey:@"remember_code_app"];
            NSString *Url_String_xp_1=@"http://218.75.197.121:8888/api/v1/get/lessonsexp/";
            NSString *Url_String_xp_1_U=[Url_String_xp_1 stringByAppendingString:studentKH];
            NSString *Url_String_xp_1_U_2=[Url_String_xp_1_U stringByAppendingString:@"/"];
            NSString *Url_String_xp=[Url_String_xp_1_U_2 stringByAppendingString:Remember_code_app];
            //地址//
NSURLRequest *request                     = [NSURLRequest requestWithURL:[NSURL URLWithString:Url_String_xp]];
NSData *response                          = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
NSError *error                            = nil;
NSDictionary *jsonDataxp                  = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            NSString *msg=[jsonDataxp objectForKey:@"msg"];
            if([msg isEqualToString:@"ok"]){

NSArray *array_xp                         = [jsonDataxp objectForKey:@"data"];

            //----------------实验课表数据缓存---------------//
            [defaults setObject:array_xp forKey:@"array_xp"];
            //强制让数据立刻保存
            [defaults synchronize];
            }
            else{
UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"登录过期"
                                                                    message:@"请重新登录"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil];
                [alertView show];
            }
    }
    

    
}

- (void) openOrCloseLeftList
{
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];

    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];

    //    LoginViewController *vb = [[LoginViewController alloc] init];
    //    [tempAppDelegate.mainNavigationController pushViewController:vb animated:NO];
    //-------判断第几周---------//
       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
NSDate *now                               = [NSDate date];
NSCalendar *calendar                      = [NSCalendar currentCalendar];
NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
int year                                  = [dateComponent year];//年
int month                                 = [dateComponent month];//月
int day                                   = [dateComponent day];//日
    [defaults setInteger:CountWeeks(year, month, day) forKey:@"NowWeek"];
    [defaults setInteger:CountWeeks(year, month, day) forKey:@"TrueWeek"];
    //判断完毕//
}



- (IBAction)ClassFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
NSArray *array                            = [defaults objectForKey:@"array"];
    if(array!=NULL){
UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    else{
UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}

- (IBAction)HomeWork:(id)sender { //作业界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];


HomeWorkViewController *vc                = [[HomeWorkViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(remember_code_app!=NULL){    //判断是否已登录
         [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    }
    else{
UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }



}
- (IBAction)Power:(id)sender {
PowerViewController *Power                = [[PowerViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.mainNavigationController pushViewController:Power animated:NO];
}
- (IBAction)SchoolSay:(id)sender {
SchoolsayViewController *Schoolsay        = [[SchoolsayViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Schoolsay animated:NO];
}

- (IBAction)SchoolHand:(id)sender {
SchoolHandViewController *SchoolHand      = [[SchoolHandViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:SchoolHand animated:NO];
}
- (IBAction)Score:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
    
    if(remember_code_app!=NULL){    //判断是否已登录
        //获得地址//
        NSString *Url_String_score=@"http://218.75.197.121:8888/api/v1/get/scores/";
        NSString *studentKH                       = [defaults objectForKey:@"studentKH"];
        Url_String_score=[Url_String_score stringByAppendingString:studentKH];
        Url_String_score=[Url_String_score stringByAppendingString:@"/"];
        Url_String_score=[Url_String_score stringByAppendingString:remember_code_app];
        Url_String_score=[Url_String_score stringByAppendingString:@"/"];
        
        NSString *sha_string=[studentKH stringByAppendingString:remember_code_app];
        sha_string=[sha_string stringByAppendingString:@"f$Z@%"];
        NSString *shaok=[self SHA:sha_string];
        Url_String_score=[Url_String_score stringByAppendingString:shaok];
       
        //地址得到完毕//
        //开始存入字典//
        NSURL *url                 = [NSURL URLWithString: Url_String_score];//接口地址
        NSError *error             = nil;
        NSString *ScoreString       = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* ScoreData           = [ScoreString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
        //存入完毕
        NSString *Msg=[Score_All objectForKey:@"msg"];
        if ([Msg isEqualToString:@"ok"]) {
            NSArray *array_score             = [Score_All objectForKey:@"data"];
            [defaults setObject:Url_String_score forKey:@"string_score"];
            [defaults synchronize];
            ScoreViewController *Score      = [[ScoreViewController alloc] init];
            AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.mainNavigationController pushViewController:Score animated:NO];
            
        }
        else{
            UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"登陆过期"
                                                                                   message:@"请点击切换用户,重新登录"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"取消"
                                                                         otherButtonTitles:@"确定", nil];
            [alertView show];
            NSLog(@"%@",Url_String_score);
        }
    }

}


- (IBAction)Day:(id)sender {
DayViewController *day                    = [[DayViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:day animated:NO];

}

- (IBAction)Library:(id)sender {
LibraryViewController *library            = [[LibraryViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         [tempAppDelegate.mainNavigationController pushViewController:library animated:NO];

}
- (IBAction)Exam:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
NSArray *studentKH                        = [defaults objectForKey:@"studentKH"];


    if(studentKH!=NULL){
NSInteger *exam_on                        = [defaults integerForKey:@"exam_on"];
        if(exam_on!=1){
UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"考试序号后的红灯代表考试正在计划中\n绿灯代表考试正在执行中,时间不再变动"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
                [defaults setInteger:1 forKey:@"exam_on"];
        }

ExamViewController *exam                  = [[ExamViewController alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:exam animated:NO];
    }
    else{
UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}




@end

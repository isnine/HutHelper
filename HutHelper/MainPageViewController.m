//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MainPageViewController.h"
#import "MainPageViewController2.h"
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
#import "MBProgressHUD.h"
#import "RootViewController.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Scontent;


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

@implementation MainPageViewController
const int startyear                       = 2016;
const int startmonth                      = 8;
const int startday                        = 29;


int CountDays(int year, int month, int day) {
    //返回当前是本年的第几天，year,month,day 表示现在的年月日，整数。
int a[12]                                 = {31,0,31,30,31,30,31,31,30,31,30,31};
int s                                     = 0;
for(int i           = 0; i < month-1; i++) {s   += a[i];
    }
    if(month > 2) {
        if(year % (year % 100 ? 4 : 400 ) ? 0 : 1)s                                         += 29;
        else
s                                         += 28;
    }

    return (s + day);
}  //当前星期几

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
} //当前第几周

- (NSString *) SHA:(NSString *)input //SHA1计算函数
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
    /**标题文字*/
    self.navigationItem.title                 = @"主界面";
    UIColor *greyColor                        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor                 = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];   //标题字体颜色
    /**友盟统计*/
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
    /**主界面*/
    UIButton *menuBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame                             = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
   [self isAppFirstRun];
    /**  首次登陆 */
    NSString *studentKH    = [defaults objectForKey:@"studentKH"];
    if(studentKH==NULL){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FirstLoginViewController *firstlogin                = [[FirstLoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    
    /**   判断第几周 */
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = [dateComponent year];//年
    int month                                 = [dateComponent month];//月
    int day                                   = [dateComponent day];//日
    [defaults setInteger:CountWeeks(year, month, day) forKey:@"NowWeek"];
    
    NSArray *array                            = [defaults objectForKey:@"array_class"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    /**  是否自动打开课程表  */
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    /** 添加标签 */
    NSString *class_name                      = [defaults objectForKey:@"class_name"];
    NSString *dep_name                        = [defaults objectForKey:@"dep_name"];
    

    [UMessage addTag:class_name
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                      
                    }];//班级
    [UMessage addTag:dep_name
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            //add your codes
                        }];  //学院
    /** 添加别名*/
    [UMessage addAlias:studentKH type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
        
    }];

  /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
   
}

- (void) openOrCloseLeftList  //侧栏滑动
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
     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
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
     NSArray *array_class                            = [defaults objectForKey:@"array_class"];
     NSArray *array_xp                            = [defaults objectForKey:@"array_xp"];
    if(array_class==NULL&&array_xp==NULL){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"查询中";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *studentKH=[defaults objectForKey:@"studentKH"];
        NSString *Remember_code_app=[defaults objectForKey:@"remember_code_app"];
        /**课表数据缓存*/
        NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/lessons/";
        NSString *Url_String_2=@"/";
        NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:studentKH];
        NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
        NSString *Url_String=[Url_String_1_U_2 stringByAppendingString:Remember_code_app];
        NSURL *url                   = [NSURL URLWithString: Url_String];//接口地址
        NSError *error               = nil;
        NSString *jsonString         = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* jsonData             = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *Class_All      = [jsonData objectFromJSONData];//数据 -> 字典
        NSString *msg_class          = [Class_All objectForKey:@"msg"];//得到数据情况
            if ([msg_class isEqualToString:@"ok"]) {
                NSArray *array               = [Class_All objectForKey:@"data"];
                [defaults setObject:array forKey:@"array_class"];
                [defaults synchronize];
            }
            NSLog(@"平时课表地址:%@",url);
        /**实验课表数据缓存*/
        NSString *Url_String_xp_1=@"http://218.75.197.121:8888/api/v1/get/lessonsexp/";
        NSString *Url_String_xp_1_U=[Url_String_xp_1 stringByAppendingString:studentKH];
        NSString *Url_String_xp_1_U_2=[Url_String_xp_1_U stringByAppendingString:@"/"];
        NSString *Url_String_xp=[Url_String_xp_1_U_2 stringByAppendingString:Remember_code_app];
        NSURL *url_xp                = [NSURL URLWithString: Url_String_xp];//接口地址
            NSLog(@"实验课表地址:%@",Url_String_xp);
           //自带库解析实验课
        NSURLRequest *request        = [NSURLRequest requestWithURL:[NSURL URLWithString:Url_String_xp]];
        NSData *response             = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *jsonDataxp     = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            NSString *msg_xp          = [jsonDataxp objectForKey:@"msg"];//得到数据情况
            if ([msg_xp isEqualToString:@"ok"]) {
                NSArray *array_xp            = [jsonDataxp objectForKey:@"data"];
                [defaults setObject:array_xp forKey:@"array_xp"];
                [defaults synchronize];
            }
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
    else{
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }

} //课程表

- (IBAction)HomeWork:(id)sender { //作业界面
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeWork"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //网上作业

- (IBAction)Power:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Power"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //电费查询

- (IBAction)SchoolSay:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Schoolsay"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //校园说说

- (IBAction)SchoolHand:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Schoolhand"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //二手市场

- (IBAction)Score:(id)sender {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSData* ScoreData           = [defaults objectForKey:@"data_score"];
        if(ScoreData==NULL){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"查询中";
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             /**拼接地址*/
            NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
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
            /**加载JSON数据*/
            NSURL *url                 = [NSURL URLWithString: Url_String_score];//接口地址
            NSError *error             = nil;
            NSString *ScoreString       = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
            NSData* ScoreData           = [ScoreString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
            NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
            NSLog(@"成绩查询地址:%@",url);
            NSString *Msg=[Score_All objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"]) {
                NSArray *array_score             = [Score_All objectForKey:@"data"];
                [defaults setObject:ScoreData forKey:@"data_score"];
                [defaults synchronize];
                RootViewController *Score      = [[RootViewController alloc] init];
                AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
                
            }
            else{
                UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"登陆过期或网络异常"
                                                                                       message:@"请点击切换用户,重新登录"
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"取消"
                                                                             otherButtonTitles:@"确定", nil];
                [alertView show];
                NSLog(@"%@",Url_String_score);
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        }
        else{
            RootViewController *Score      = [[RootViewController alloc] init];
            AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.mainNavigationController pushViewController:Score animated:NO];
        }

} //成绩查询

- (IBAction)Day:(id)sender {
MainPageViewController2 *other= [[MainPageViewController2 alloc] init];
AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:other animated:YES];

} //其他

- (IBAction)Library:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Library"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];

} //图书馆

- (IBAction)Exam:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"查询中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        /**拼接地址*/
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *studentKH        = [defaults objectForKey:@"studentKH"];
        NSString *Url_String=@"http://218.75.197.124:84/api/exam/";
        Url_String=[Url_String stringByAppendingString:studentKH];
        Url_String=[Url_String stringByAppendingString:@"/key/"];
        NSString *ss=[studentKH stringByAppendingString:@"apiforapp!"];
        NSString *ssmd5=[ss MD5];
        Url_String=[Url_String stringByAppendingString:ssmd5];
        NSURL *url                 = [NSURL URLWithString: Url_String];//接口地址
        NSLog(@"考试地址:%@",url);
        /**加载JSON数据*/
        NSError *error             = nil;
        NSString *jsonString       = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* jsonData           = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *User_All     = [jsonData objectFromJSONData];//数据 -> 字典
        NSString *message=[User_All objectForKey:@"message"];
        NSString *status=[User_All objectForKey:@"status"];
        if([status isEqualToString:@"success"]){
            NSDictionary *Class_Data=[User_All objectForKey:@"res"];
            
            NSMutableArray *array             = [Class_Data objectForKey:@"exam"];
            NSMutableArray *arraycx             = [Class_Data objectForKey:@"cxexam"];
            NSLog(@"重修:%d",arraycx.count);
            
            [defaults setObject:jsonData forKey:@"data_exam"];
            [defaults synchronize];
            NSInteger *exam_on                        = [defaults integerForKey:@"exam_on"];
            if(exam_on!=1){
                UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                                       message:@"绿灯 - 已完成\n黄灯 - 执行中，时间地点不会变化\n红灯 - 计划中，时间地点可能变化"
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"取消"
                                                                             otherButtonTitles:@"确定", nil];
                [alertView show];
                [defaults setInteger:1 forKey:@"exam_on"];
            }
            if(array.count!=0){
                ExamViewController *exam                  = [[ExamViewController alloc] init];
                AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [tempAppDelegate.mainNavigationController pushViewController:exam animated:YES];
            }
            else{
                UIAlertView *alertView1    = [[UIAlertView alloc] initWithTitle:@"暂无考试"
                                                                        message:@"计划表上暂时没有考试"
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确定", nil];
                [alertView1 show];
            }
        }
        else{
            ExamViewController *exam                  = [[ExamViewController alloc] init];
            AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.mainNavigationController pushViewController:exam animated:YES];

            NSLog(@"查询失败");
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
} //考试计划

- (void) isAppFirstRun{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunKey = [defaults objectForKey:@"last_run_version_key"];
    NSLog(@"当前版本%@",currentVersion);
    NSLog(@"上个版本%@",lastRunKey);
    if (lastRunKey==NULL) {
        NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        NSLog(@"没有记录");
        
    }
    else if (![lastRunKey isEqualToString:currentVersion]) {
        NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        NSLog(@"记录不匹配");
    }
    
}



@end

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
#import "DayViewController.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import "FirstLoginViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "UINavigationBar+Awesome.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "SayViewController.h"
#import "HandTableViewController.h"
#import "ScoreShowViewController.h"
#import "Math.h"
#import "LeftSortsViewController.h"
#import "Config.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Scontent;
@property (weak, nonatomic) IBOutlet UILabel *Time;


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
int class_error_;

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 预留方法 */
    [self jspath];
    /**设置标题*/
    [self setTitle];
    /**友盟统计*/
    [self setUMeng];
    /**主界面*/
    [self isAppFirstRun];
    /**设置第几周*/
    [self setTime];
    /**  首次登陆以及判断是否打开课程表 */
    [self loadSet];
    /**设置友盟标签&别名*/
    [self setAlias];
    /**时间Label*/
    [self SetTimeLabel];
}

#pragma mark - 各按钮事件
- (IBAction)ClassFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Class                            = [defaults objectForKey:@"Class"];
    NSArray *ClassXP                            = [defaults objectForKey:@"ClassXP"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(Class==NULL&&ClassXP==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=[NSString stringWithFormat:API_CLASS,user.studentKH,[defaults objectForKey:@"remember_code_app"]];
        NSLog(@"平时课表地址:%@",Url_String);
        NSString *UrlXP_String=[NSString stringWithFormat:API_CLASSXP,user.studentKH,[defaults objectForKey:@"remember_code_app"]];
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置4秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 4.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *Msg=[Class_All objectForKey:@"msg"];
                 if ([Msg isEqualToString:@"ok"]) {
                     NSArray *array               = [Class_All objectForKey:@"data"];
                     [defaults setObject:array forKey:@"Class"];
                     [defaults synchronize];
                     NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
                     [shared setObject:array forKey:@"Class"];
                     [shared synchronize];
                     /**请求实验课表*/
                     
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *ClassXP_All = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *Msg=[ClassXP_All objectForKey:@"msg"];
                              if ([Msg isEqualToString:@"ok"]) {
                                  NSArray *array               = [ClassXP_All objectForKey:@"data"];
                                  [defaults setObject:array forKey:@"ClassXP"];
                                  [defaults synchronize];
                                  NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
                                  [shared setObject:array forKey:@"ClassXP"];
                                  [shared synchronize];
                                  HideAllHUD
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                              else{
                                  HideAllHUD
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                                  HideAllHUD
                                  [MBProgressHUD showError:Msg];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              HideAllHUD
                              [MBProgressHUD showError:@"网络错误，实验课表查询失败"];
                          }];
                     
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:Msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络错误，平时课表查询失败"];
             }];
    }
    else{
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    
    
} //课程表

- (IBAction)ClassXPFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Class                            = [defaults objectForKey:@"Class"];
    NSArray *ClassXP                            = [defaults objectForKey:@"ClassXP"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(Class==NULL&&ClassXP==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=[NSString stringWithFormat:API_CLASS,user.studentKH,[defaults objectForKey:@"remember_code_app"]];
        NSLog(@"平时课表地址:%@",Url_String);
        NSString *UrlXP_String=[NSString stringWithFormat:API_CLASSXP,user.studentKH,[defaults objectForKey:@"remember_code_app"]];
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 4.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *Msg=[Class_All objectForKey:@"msg"];
                 if ([Msg isEqualToString:@"ok"]) {
                     NSArray *array               = [Class_All objectForKey:@"data"];
                     [defaults setObject:array forKey:@"Class"];
                     [defaults synchronize];
                     /**请求实验课表*/
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *ClassXP_All = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *Msg=[ClassXP_All objectForKey:@"msg"];
                              if ([Msg isEqualToString:@"ok"]) {
                                  NSArray *array               = [ClassXP_All objectForKey:@"data"];
                                  [defaults setObject:array forKey:@"ClassXP"];
                                  [defaults synchronize];
                                  HideAllHUD
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                              else{
                                  HideAllHUD
                                  [MBProgressHUD showError:Msg];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              HideAllHUD
                              [MBProgressHUD showError:@"网络错误，实验课表查询失败"];
                          }];
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:Msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络错误，平时课表查询失败"];
             }];
    }
    else{
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    
    
    
} //实验课表

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
    /**设置不缓存*/
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,1];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     [defaults synchronize];
                     HideAllHUD
                     SayViewController *Say      = [[SayViewController alloc] init];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                     
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             HideAllHUD
         }];
    
    
    
    
    
    
} //校园说说

- (IBAction)SchoolHand:(id)sender {
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_GOODS,1];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
             NSArray *Hand           = [dic1 objectForKey:@""];
             [defaults setObject:Hand forKey:@"Hand"];
             [defaults synchronize];
             HideAllHUD
             HandTableViewController *hand=[[HandTableViewController alloc]init];
             AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             HideAllHUD
         }];
} //二手市场

- (IBAction)Score:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"Score"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(ScoreData==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *SHA_String=[user.studentKH stringByAppendingString:[defaults objectForKey:@"remember_code_app"]];
        SHA_String=[SHA_String stringByAppendingString:@"f$Z@%"];
        SHA_String=[Math sha1:SHA_String];
        NSString *Url_String=[NSString stringWithFormat:API_SCORES,user.studentKH,[defaults objectForKey:@"remember_code_app"],SHA_String];
        NSLog(@"成绩查询地址:%@",Url_String);
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Score_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSData *Score_Data =    [NSJSONSerialization dataWithJSONObject:Score_All options:NSJSONWritingPrettyPrinted error:nil];
                 
                 NSString *Msg=[Score_All objectForKey:@"msg"];
                 if([Msg isEqualToString:@"ok"]){
                     [defaults setObject:Score_Data forKey:@"Score"];
                     [defaults synchronize];
                     //                     RootViewController *Score      = [[RootViewController alloc] init];
                     UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     ScoreShowViewController *Score      = [main instantiateViewControllerWithIdentifier:@"ScoreShow"];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
                     HideAllHUD
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:Msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"请检查网络或者重新登录"];
             }];
    }else{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScoreShowViewController *Score      = [main instantiateViewControllerWithIdentifier:@"ScoreShow"];
        //   RootViewController *Score      = [[RootViewController alloc] init];
        
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
    }
    
    
} //成绩查询

- (IBAction)Library:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Library"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
    
} //图书馆

- (IBAction)Exam:(id)sender {
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    /**拼接地址*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *ss=[user.studentKH stringByAppendingString:@"apiforapp!"];
    ss=[ss MD5];
    NSString *Url_String=[NSString stringWithFormat:API_EXAM,user.studentKH,ss];
    NSLog(@"考试地址:%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Exam_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSDictionary *Exam_Data=[Exam_All objectForKey:@"data"];//All字典 -> Data字典
             NSData *Exam_data =    [NSJSONSerialization dataWithJSONObject:Exam_All options:NSJSONWritingPrettyPrinted error:nil];
             NSString *message=[Exam_All objectForKey:@"message"];
             NSString *status=[Exam_All objectForKey:@"status"];
             if([status isEqualToString:@"success"]){
                 NSDictionary *Class_Data=[Exam_All objectForKey:@"res"];
                 NSMutableArray *array             = [Class_Data objectForKey:@"exam"];
                 NSMutableArray *arraycx             = [Class_Data objectForKey:@"cxexam"];
                 [defaults setObject:Exam_data forKey:@"Exam"];
                 [defaults synchronize];
                 NSInteger *exam_on                        = [defaults integerForKey:@"exam_on"];
                 if(array.count!=0){
                     [self EnterExam];
                     HideAllHUD
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"计划表上暂无考试"];
                 }
             }
             else{
                 [self EnterExam];
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([defaults objectForKey:@"Exam"]!=NULL) {
                 [self EnterExam];
                 HideAllHUD
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:@"网络错误"];
             }
         }];
} //考试计划

- (IBAction)Day:(id)sender {  //校历
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Day"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}  //校历

- (IBAction)Lost:(id)sender {
    /**设置不缓存*/
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_LOST,1];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Lost"];
                     [defaults synchronize];
                     HideAllHUD
                     UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LostShow"];
                     AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:[Say_All objectForKey:@"msg"]]];
             }             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             HideAllHUD
         }];
}  //失物招领

- (IBAction)Notice:(id)sender {
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NoticeViewController *View      = [main instantiateViewControllerWithIdentifier:@"Notice"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:View animated:YES];
} //通知界面

#pragma mark - 其他方法
-(void)jspath{
    
}
-(void)SetTimeLabel{
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    
    int y                                     = (short)[dateComponent year];//年
    int m                                    =(short) [dateComponent month];//月
    int mou                                    = (short)[dateComponent month];//月
    NSLog(@"%d月",m);
    int d                                      = (short)[dateComponent day];//日
    int day                                      = (short)[dateComponent day];//日
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    NSString *Week;
    switch (iWeek) {
        case 1:
            Week=@"一";
            break;
        case 2:
            Week=@"二";
            break;
        case 3:
            Week=@"三";
            break;
        case 4:
            Week=@"四";
            break;
        case 5:
            Week=@"五";
            break;
        case 6:
            Week=@"六";
            break;
        case 7:
            Week=@"日";
            break;
        default:
            Week=@"";
            break;
    }
    _Time.text=[NSString stringWithFormat:@"%d月%d日 星期%@",mou,day,Week];
}
-(void)EnterExam{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ExamNew"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
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
    UIColor *ownColor                = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor: ownColor];  //颜色
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 = (short)[dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"NowWeek"];
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"TrueWeek"];
    //判断完毕//
    /**导航栏变为透明*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    /**设置通知*/
    [self setNotice];
}
#pragma mark - 设置方法
-(void)setNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *notice=[defaults objectForKey:@"Notice"];
    _body.text=[notice[0] objectForKey:@"body"];
    _noticetitle.text=[notice[0] objectForKey:@"title"];
    _noticetime.text=[[notice[0] objectForKey:@"time"] substringWithRange:NSMakeRange(5,5)];
}
-(void)loadSet{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_All=[defaults objectForKey:@"User"];
    if(User_All==NULL){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FirstLoginViewController *firstlogin                = [[FirstLoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    
    NSArray *array                            = [defaults objectForKey:@"Class"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    /**  是否自动打开课程表  */
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
}
-(void)setTime{
    /**   判断第几周 */
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 =(short) [dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"NowWeek"];
}
-(void)setUMeng{
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
}
-(void)setTitle{
    /**标题文字*/
    //  self.navigationItem.title                 = @"主界面";
    UIColor *greyColor                        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor                 = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];   //标题字体颜色
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    /**按钮*/
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    UIButton *menuBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame                             = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1];
}
-(void)setAlias{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    /** 友盟统计账号 */
    [MobClick profileSignInWithPUID:user.studentKH];
    /** 添加标签 */
    [UMessage addTag:user.class_name
            response:^(id responseObject, NSInteger remain, NSError *error) {
            }];//班级
    [UMessage addTag:user.dep_name
            response:^(id responseObject, NSInteger remain, NSError *error) {
            }];  //学院
    /** 添加别名*/
    [UMessage addAlias:user.studentKH type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
    }];
}
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

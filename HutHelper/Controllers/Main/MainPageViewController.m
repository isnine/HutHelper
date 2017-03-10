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

#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HandTableViewController.h"
#import "ScoreShowViewController.h"
#import "Math.h"
#import "LeftSortsViewController.h"
#import "MomentsViewController.h"
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
    /**时间Label*/
    [self SetTimeLabel];
}

#pragma mark - 各按钮事件
- (IBAction)ClassFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Class                            = [defaults objectForKey:@"kCourse"];
    NSArray *ClassXP                            = [defaults objectForKey:@"kCourseXp"];
    if((!Class)&&(!ClassXP)){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=[NSString stringWithFormat:API_CLASS,Config.getStudentKH,Config.getRememberCodeApp];
        NSString *UrlXP_String=[NSString stringWithFormat:API_CLASSXP,Config.getStudentKH,Config.getRememberCodeApp];
        NSLog(@"平时课表地址:%@",Url_String);
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 6.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *classAll = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *msg=[classAll objectForKey:@"msg"];
                 if ([msg isEqualToString:@"ok"]) {
                     NSArray *arrayCourse = [classAll objectForKey:@"data"];
                     [Config saveCourse:arrayCourse];
                     [Config saveWidgetCourse:arrayCourse];
                     /**请求实验课表*/
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *classXpAll = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *msg=[classXpAll objectForKey:@"msg"];
                              if ([msg isEqualToString:@"ok"]) {
                                  NSArray *arrayCourseXp= [classXpAll objectForKey:@"data"];
                                  [Config saveCourseXp:arrayCourseXp];
                                  [Config saveWidgetCourseXp:arrayCourseXp];
                                  [Config setIs:0];
                                  HideAllHUD
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                              else{
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                                  HideAllHUD
                                  [MBProgressHUD showError:msg];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              HideAllHUD
                              [MBProgressHUD showError:@"网络超时，实验课表查询失败"];
                          }];
                     
                 }
                 else if([msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络超时，平时课表查询失败"];
             }];
    }
    else{
        [Config setIs:0];
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    
    
} //课程表

- (IBAction)ClassXPFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Class                            = [defaults objectForKey:@"kCourse"];
    NSArray *ClassXP                            = [defaults objectForKey:@"kCourseXp"];
    if((!Class)&&(!ClassXP)){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=[NSString stringWithFormat:API_CLASS,Config.getStudentKH,Config.getRememberCodeApp];
        NSString *UrlXP_String=[NSString stringWithFormat:API_CLASSXP,Config.getStudentKH,Config.getRememberCodeApp];
        NSLog(@"平时课表地址:%@",Url_String);
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 6.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *classAll = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *msg=[classAll objectForKey:@"msg"];
                 if ([msg isEqualToString:@"ok"]) {
                     NSArray *arrayCourse = [classAll objectForKey:@"data"];
                     [Config saveCourse:arrayCourse];
                     [Config saveWidgetCourse:arrayCourse];
                     /**请求实验课表*/
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *classXpAll = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *msg=[classXpAll objectForKey:@"msg"];
                              if ([msg isEqualToString:@"ok"]) {
                                  NSArray *arrayCourseXp= [classXpAll objectForKey:@"data"];
                                  [Config saveCourseXp:arrayCourseXp];
                                  [Config saveWidgetCourse:arrayCourseXp];
                                  [Config setIs:1];
                                  HideAllHUD
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                              else{
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                                  HideAllHUD
                                  [MBProgressHUD showError:msg];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              HideAllHUD
                              [MBProgressHUD showError:@"网络超时，实验课表查询失败"];
                          }];
                     
                 }
                 else if([msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络超时，平时课表查询失败"];
             }];
    }
    else{
        [Config setIs:1];
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
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,1];
    NSString *likesDataString=[NSString stringWithFormat:API_MOMENTS_LIKES_SHOW,Config.getStudentKH,Config.getRememberCodeApp];
    NSLog(@"说说请求地址:%@",Url_String);
    /**设置超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 6.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *sayData=[Say_All objectForKey:@"data"];
                 NSDictionary *sayContent=[sayData objectForKey:@"posts"];//加载该页数据
                 if (sayContent) {
                     [Config saveSay:sayContent];
                     [Config setIs:0];
                     [manager GET:likesDataString parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *likesAll = [NSDictionary dictionaryWithDictionary:responseObject];
                              [Config saveSayLikes:likesAll];
                              MomentsViewController *Say      = [[MomentsViewController alloc] init];
                              AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                              [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                              HideAllHUD
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              
                          }];
                 }else{
                     HideAllHUD
                     [MBProgressHUD showError:@"数据错误"];
                 }
             }else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络超时"];
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
    /**设置超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
             NSArray *handArray           = [dic1 objectForKey:@""];
             [Config saveHand:handArray];
             [Config setIs:0];
             HandTableViewController *hand=[[HandTableViewController alloc]init];
             AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络超时，请检查网络并重试"];
             HideAllHUD
         }];
} //二手市场

- (IBAction)Score:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* scoreData           = [defaults objectForKey:@"Score"];
    if(!scoreData){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *SHA_String=[Config.getStudentKH stringByAppendingString:Config.getRememberCodeApp];
        SHA_String=[SHA_String stringByAppendingString:@"f$Z@%"];
        SHA_String=[Math sha1:SHA_String];
        NSString *Url_String=[NSString stringWithFormat:API_SCORES,Config.getStudentKH,Config.getRememberCodeApp,SHA_String];
        NSLog(@"成绩查询地址:%@",Url_String);
        /**设置超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *scoreAll = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSData *scoreData =    [NSJSONSerialization dataWithJSONObject:scoreAll options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *msg=[scoreAll objectForKey:@"msg"];
                 if([msg isEqualToString:@"ok"]){
                     [Config saveScore:scoreData];
                     UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     ScoreShowViewController *Score      = [main instantiateViewControllerWithIdentifier:@"ScoreShow"];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
                     HideAllHUD
                 }
                 else if([msg isEqualToString:@"令牌错误"]){
                     HideAllHUD
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络超时，请检查网络并重试"];
             }];
    }else{
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScoreShowViewController *Score      = [main instantiateViewControllerWithIdentifier:@"ScoreShow"];
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
    NSString *ss=[Config.getStudentKH stringByAppendingString:@"apiforapp!"];
    ss=[ss MD5];
    NSString *Url_String=[NSString stringWithFormat:API_EXAM,Config.getStudentKH,ss];
    NSLog(@"考试地址:%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
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
                     [self EnterExam];
                     HideAllHUD
                 } else{
                     HideAllHUD
                     [MBProgressHUD showError:@"计划表上暂无考试"];
                 }
             }else{
                 if ([defaults objectForKey:@"Exam"]!=NULL) {
                     [self EnterExam];
                     [MBProgressHUD showError:@"超时,显示本地数据"];
                 }else{
                     [MBProgressHUD showError:[Exam_All objectForKey:@"message"]];
                 }
                 HideAllHUD
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([defaults objectForKey:@"Exam"]!=NULL) {
                 [self EnterExam];
                 HideAllHUD
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }else{
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
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *sayData=[Say_All objectForKey:@"data"];
                 NSArray *sayContent=[sayData objectForKey:@"posts"];//加载该页数据
                 if (sayContent!=NULL) {
                     [Config saveLost:sayContent];
                     UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LostShow"];
                     AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                     HideAllHUD
                 }else{
                     HideAllHUD
                     [MBProgressHUD showError:@"数据错误"];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:[Say_All objectForKey:@"msg"]]];
             }             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络超时，请检查网络并重试"];
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
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = (short)[dateComponent year];//年
    int month                                 = (short)[dateComponent month];//月
    int day                                   = (short)[dateComponent day];//日
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"NowWeek"];
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"TrueWeek"];
    //判断完毕//
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
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
    NSDictionary *User_All=[defaults objectForKey:@"kUser"];
    if(User_All==NULL){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FirstLoginViewController *firstlogin                = [[FirstLoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    
    NSArray *array                            = [defaults objectForKey:@"kCourse"];
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
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
    else if ([lastRunKey isEqualToString:@"1.9.5"]||[lastRunKey isEqualToString:@"1.9.6"]||[lastRunKey isEqualToString:@"1.9.7"]){
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        [Config addNotice];
    }
    else if (![lastRunKey isEqualToString:currentVersion]) {
        NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        NSLog(@"记录不匹配");
    }
    
    
    
    
}
@end

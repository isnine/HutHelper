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
#import "CourseViewController.h"
#import "PowerViewController.h"
#import "LibraryViewController.h"
#import "NoticeViewController.h"
#import "DayViewController.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import "LoginViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "UINavigationBar+Awesome.h"

#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HandTableViewController.h"
#import "ScoreShowViewController.h"

#import "LeftSortsViewController.h"
#import "MomentsViewController.h"
#import "APIRequest.h"
#import "VedioPlayViewController.h"

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
#define ERROR_MSG_INVALID @"登录过期,请重新登录"

@interface MainPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Scontent;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@end

@implementation MainPageViewController
int class_error_;
- (void)viewDidLoad {
    [super viewDidLoad];
    /**设置标题*/
    [self setTitle];
    /**友盟统计*/
    [self setUMeng];
    /**主界面*/
    [Config isAppFirstRun];
    /**设置第几周*/
    [Config saveNowWeek:[Math getWeek]];
    /**  首次登陆以及判断是否打开课程表 */
    [self loadSet];
    /**时间Label*/
    [self SetTimeLabel];
}
#pragma mark - 各按钮事件
- (IBAction)ClassFind:(id)sender {  //课表界面
    if(([Config getCourse]==nil)||([Config getCourseXp]==nil)){
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *urlString=Config.getApiClass;
        NSString *urlXpString=Config.getApiClassXP;
        /**平时课表*/
        [APIRequest GET:urlString parameters:nil success:^(id responseObject) {
            NSString *msg=responseObject[@"msg"];
            if ([msg isEqualToString:@"ok"]) {
                NSArray *arrayCourse = responseObject[@"data"];
                [Config saveCourse:arrayCourse];
                [Config saveWidgetCourse:arrayCourse];
                /**实验课表*/
                {
                    [APIRequest GET:urlXpString parameters:nil success:^(id responseObject) {
                        NSString *msg=responseObject[@"msg"];
                        if ([msg isEqualToString:@"ok"]) {
                            NSArray *arrayCourseXp= responseObject[@"data"];
                            [Config saveCourseXp:arrayCourseXp];
                            [Config saveWidgetCourseXp:arrayCourseXp];
                            [Config setIs:0];
                            [Config pushViewController:@"Class"];
                        }
                        else{
                            [Config pushViewController:@"Class"];
                            [MBProgressHUD showError:msg];
                        }
                        HideAllHUD
                    } failure:^(NSError *error) {
                        [MBProgressHUD showError:@"网络超时，实验课表查询失败"];
                        HideAllHUD
                    }];
                }
            }else if([msg isEqualToString:@"令牌错误"]){
                [MBProgressHUD showError:ERROR_MSG_INVALID];
                HideAllHUD
            }
            else{
                [MBProgressHUD showError:msg];
                HideAllHUD
            }
        } failure:^(NSError *error) {
            HideAllHUD
            [MBProgressHUD showError:@"网络超时，平时课表查询失败"];
        }];
    }else{
        [Config setIs:0];
        [Config pushViewController:@"Class"];
    }
} //课程表
- (IBAction)ClassXPFind:(id)sender {  //实验课表
     [Config pushViewController:@"ClassXp"];    
    
} //实验课表
- (IBAction)HomeWork:(id)sender {
    [Config pushViewController:@"HomeWork"];
} //网上作业
- (IBAction)Power:(id)sender {
    [Config pushViewController:@"Power"];
} //电费查询
- (IBAction)SchoolSay:(id)sender {
    [Config setIs:0];
    MomentsViewController *Say      = [[MomentsViewController alloc] init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
} //校园说说
- (IBAction)SchoolHand:(id)sender {
    [Config setIs:0];
    HandTableViewController *hand=[[HandTableViewController alloc]init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
} //二手市场
- (IBAction)Score:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if((![defaults objectForKey:@"Score"])||(![defaults objectForKey:@"ScoreRank"])){
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *urlString=Config.getApiScores;
        [APIRequest GET:urlString parameters:nil timeout:8.0 success:^(id responseObject){
            NSData *scoreData =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *msg=responseObject[@"msg"];
            if([msg isEqualToString:@"ok"]){
                [Config saveScore:scoreData];
                NSString *urlRankString=Config.getApiRank;
                [APIRequest GET:urlRankString parameters:nil timeout:8.0 success:^(id responseObject) {
                    if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
                        [Config saveScoreRank:responseObject];
                        [Config pushViewController:@"ScoreShow"];
                        HideAllHUD
                    }else{
                        [MBProgressHUD showError:@"排名查询错误"];
                        HideAllHUD
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"网络超时"];
                    HideAllHUD
                }];
                
            }else if([msg isEqualToString:@"令牌错误"]){
                [MBProgressHUD showError:ERROR_MSG_INVALID];
                HideAllHUD
            }else{
                [MBProgressHUD showError:msg];
                HideAllHUD
            }
            
        }failure:^(NSError *error){
            [MBProgressHUD showError:@"网络超时"];
            HideAllHUD
        }];
    }else{
        [Config pushViewController:@"ScoreShow"];
        
    }
} //成绩查询
- (IBAction)Library:(id)sender {
    [Config pushViewController:@"Library"];
} //图书馆
- (IBAction)Exam:(id)sender {
     [Config pushViewController:@"Exam"];

} //考试计划
- (IBAction)Day:(id)sender {
    [Config pushViewController:@"Day"];
}  //校历
- (IBAction)Lost:(id)sender {
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [APIRequest GET:[Config getApiLost:1] parameters:nil success:^(id responseObject) {
        if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
            NSArray *sayContent=responseObject[@"data"][@"posts"];//加载该页数据
            if (sayContent) {
                [Config saveLost:sayContent];
                [Config pushViewController:@"LostShow"];
            }else{
                [MBProgressHUD showError:@"数据错误"];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        HideAllHUD
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络超时"];
        HideAllHUD
    }];
}  //失物招领
- (IBAction)Notice:(id)sender {
    [Config pushViewController:@"Notice"];
} //通知界面
- (IBAction)Vedio:(id)sender { //视频专栏
    [Config pushViewController:@"Vedio"];
} //视频专栏
#pragma mark - 其他方法
- (void)SetTimeLabel{
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int y                                     = (short)[dateComponent year];//年
    int m                                    =(short) [dateComponent month];//月
    int mou                                    = (short)[dateComponent month];//月
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
- (void) openOrCloseLeftList{
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
        
    }else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}  //侧栏滑动
- (void)viewWillDisappear:(BOOL)animated{
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
    [defaults setInteger:[Math getWeek:year m:month d:day] forKey:@"TrueWeek"];
    //判断完毕//
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    /**导航栏变为透明*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    /**设置通知*/
    [self setNotice];
    [_leftSortsViewController.tableview reloadData];
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
        LoginViewController *firstlogin                = [[LoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    NSArray *array                            = [defaults objectForKey:@"kCourse"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    /**  是否自动打开课程表  */
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CourseViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
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

@end

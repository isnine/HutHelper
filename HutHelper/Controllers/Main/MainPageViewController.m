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

#import <RongIMKit/RongIMKit.h>
#import "PointView.h"
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
    
//    [[RCIM sharedRCIM] connectWithToken:@"YourTestUserToken"     success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%d", status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];
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
    //时间
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    _Time.text=[NSString stringWithFormat:@"%d月%d日 星期%@",(short) [dateComponent month],(short)[dateComponent day],[Math transforDay:[Math getWeekDay]]];
    
    //倒计时
    if ([Config getCalendar]) {
        [self drawCalendar:[Config getCalendar]];
    }
    [APIRequest GET:[Config getApiCalendar] parameters:nil success:^(id responseObject) {
        NSArray *calendarArray=responseObject;
        [Config saveCalendar:calendarArray];
        [self drawCalendar:calendarArray];

    } failure:^(NSError *error) {
        NSLog(@"倒计时加载失败");
    }];
    
}
-(void)drawCalendar:(NSArray*)calendarArray{
    int yearInt,mouthInt,dayInt,countDown = 0;
    int xSum=0;//当前X的累加
    int xfirstSum=0;//第一个label的x值
    int xAdd=0;//每次增加X多少
    int invalidNum=0;
    NSString *countStr;
    for (int i=0,j=0; i<calendarArray.count&&j<4; i++) {
        NSString *dateStr=calendarArray[i][@"date"];
        //字符串是否可以解析
        if (dateStr.length==10) {
            yearInt=[[dateStr substringWithRange:NSMakeRange(0,4)] intValue];
            mouthInt=[[dateStr substringWithRange:NSMakeRange(5,2)] intValue];
            dayInt=[[dateStr substringWithRange:NSMakeRange(8,2)] intValue];
            countDown=[Math getDateDiff:yearInt m:mouthInt d:dayInt];
            countStr=[NSString stringWithFormat:@"%@ %d天",calendarArray[i][@"name"],countDown];
        }else{
            countStr=[NSString stringWithFormat:@"%@",calendarArray[i][@"name"]];
        }
        //如果倒计时过期
        if (countDown<0) {
            invalidNum++;
            continue;
        }
        //计算x
        switch (calendarArray.count-invalidNum) {
            case 3:
                xAdd=130;
                break;
            case 2:
                xfirstSum=50;
                xAdd=170;
                break;
            case 1:
                xfirstSum=115;
                break;
            default:
                xAdd=90;
                break;
        }
        //绘制图形
        PointView *pointView=[[PointView alloc]initWithFrame:CGRectMake(SYReal(80+xSum+xfirstSum), SYReal(225), SYReal(30), SYReal(30))];
        [self.view addSubview:pointView];
        UILabel *calendarTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(60+xSum+xfirstSum), SYReal(210), SYReal(100), SYReal(20))];
        calendarTimeLabel.textColor=[UIColor whiteColor];
        calendarTimeLabel.font=[UIFont fontWithName:@"Apple SD Gothic Neo"  size:12];
        calendarTimeLabel.text=calendarArray[i][@"date"];
        [self.view addSubview:calendarTimeLabel];
        UILabel *calendarNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(60+xSum+xfirstSum), SYReal(243), SYReal(100), SYReal(20))];
        calendarNameLabel.textColor=[UIColor whiteColor];
        calendarNameLabel.font=[UIFont fontWithName:@"Apple SD Gothic Neo"  size:12];
        calendarNameLabel.text=countStr;
        [self.view addSubview:calendarNameLabel];
        NSLog(@"%@",countStr);
        xSum+=xAdd;
    }

    
    
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
    //状态栏恢复黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

  
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
    /**导航栏变为透明*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    /**设置通知*/
    [self setNotice];
    [_leftSortsViewController.tableview reloadData];
    //状态栏白色
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

}
#pragma mark - 设置方法
-(void)setNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *notice=[defaults objectForKey:@"Notice"];
    _body.text=[notice[0] objectForKey:@"body"];
   // _noticetitle.text=[notice[0] objectForKey:@"title"];
    //_noticetime.text=[[notice[0] objectForKey:@"time"] substringWithRange:NSMakeRange(5,5)];
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

    UIButton *menuBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame                             = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    /**让黑线消失的方法*/
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;

}
// 寻找导航栏下的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end

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
#import "LostViewController.h"
#import "ChatListViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "CalendarHomeViewController.h"
#import "LineUIView.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
#define ERROR_MSG_INVALID @"登录过期,请重新登录"
@interface MainPageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgView;
@property (weak, nonatomic) IBOutlet UILabel *Scontent;
@property (weak, nonatomic) IBOutlet LineUIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@end

@implementation MainPageViewController
int class_error_;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    [self setTitle];
    //友盟统计
    [self setUMeng];
    //主界面
    [Config isAppFirstRun];
    //设置第几周
    [Config saveNowWeek:[Math getWeek]];
    //首次登陆以及判断是否打开课程表
    [self loadSet];
    //时间Label
    [self SetTimeLabel] ;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //侧栏关闭
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    //关闭隐藏标题栏
    UIColor *ownColor                = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor: ownColor];  //颜色
    [self.navigationController.navigationBar lt_reset];
    //状态栏恢复黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)unreadNotificationAction{
    //通知数目
    RCIMClient *test=[RCIMClient sharedRCIMClient];
    [test addObserver:self forKeyPath:@"totalUnreadCount" options:NSKeyValueObservingOptionNew context:nil];
//    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount]>0) {
//        self.navigationItem.rightBarButtonItem.badgeValue = @" ";
//        [self.navigationItem.rightBarButtonItem setBadgeOriginY:SYReal(13)];
//    }else if([[RCIMClient sharedRCIMClient] getTotalUnreadCount]==0){
//        self.navigationItem.rightBarButtonItem.badgeValue = @"";
//    }
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount]>=0) {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%d",[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
        [self.navigationItem.rightBarButtonItem setBadgeOriginY:SYReal(3)];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //更新未读消息
    [self unreadNotificationAction];
    //侧栏开启
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    //保存当前周次
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    [defaults setInteger:[Math getWeek:(short)[dateComponent year] m:(short)[dateComponent month] d:(short)[dateComponent day]] forKey:@"TrueWeek"];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    //设置通知
    [self setNotice];
    [_leftSortsViewController.tableview reloadData];
    //状态栏白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //返回栏主题色
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    /**让黑线消失的方法*/
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;

}
#pragma mark - 各按钮事件

- (IBAction)ClassFind:(id)sender {
    if([Config getCourse]!=nil){
        [Config setIs:0];
        [Config pushViewController:@"Class"];
        return;
    }
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    if([Config getCourse]==nil){
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *urlString=Config.getApiClass;
        NSString *urlXpString=Config.getApiClassXP;
        __block ClassStatus status=ClassOK;
        __block NSString *errorStr;
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
        //平时课表队列请求
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);
            [APIRequest GET:urlString parameters:nil success:^(id responseObject) {
                NSString *msg=responseObject[@"msg"];
                if ([msg isEqualToString:@"ok"]) {
                    NSArray *arrayCourse = responseObject[@"data"];
                    [Config saveCourse:arrayCourse];
                    [Config saveWidgetCourse:arrayCourse];
                }else if([msg isEqualToString:@"令牌错误"]){
                    status=status+2;
                    errorStr=ERROR_MSG_INVALID;
                }else{
                    status=status+2;
                    errorStr=msg;
                }
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                status=status+2;
                dispatch_group_leave(group);
                errorStr=@"网络超时，平时课表查询失败";
            }];
        });
        
//        //实验课表队列请求
//        dispatch_group_async(group, q, ^{
//            dispatch_group_enter(group);
//            [APIRequest GET:urlXpString parameters:nil success:^(id responseObject) {
//                NSString *msg=responseObject[@"msg"];
//                if ([msg isEqualToString:@"ok"]) {
//                    NSArray *arrayCourseXp= responseObject[@"data"];
//                    [Config saveCourseXp:arrayCourseXp];
//                    [Config saveWidgetCourseXp:arrayCourseXp];
//                }else if([msg isEqualToString:@"令牌错误"]){
//                    status=status+1;
//                    errorStr=ERROR_MSG_INVALID;
//                }else{
//                    status=status+1;
//                    errorStr=msg;
//                }
//                HideAllHUD
//                dispatch_group_leave(group);
//            } failure:^(NSError *error) {
//                status=status+1;
//                 errorStr=@"网络超时，实验课表查询失败";
//                dispatch_group_leave(group);
//            }];
//        });
        
        //两个队列都完成后
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            HideAllHUD
            if (status==ClassOK||status==ClassXpError) {
                [Config setIs:0];
                [Config pushViewController:@"Class"];
            }else{
                [MBProgressHUD showError:errorStr toView:self.view];
            }
        });
    }
}//课程表
- (IBAction)ClassXPFind:(id)sender {  //实验课表
     if ([Config isTourist]) {
         [MBProgressHUD showError:@"游客请登录" toView:self.view];
         return;
     }
    [Config pushViewController:@"ClassXp"];
} //实验课表
- (IBAction)HomeWork:(id)sender {
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
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
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //如果没有缓存数据
    if((![defaults objectForKey:@"Score"])||(![defaults objectForKey:@"ScoreRank"])){
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t q = dispatch_get_global_queue(0, 0);
        __block ScoreStatus scoreStatus=ScoreOK;
        __block NSString *errorStr;
        //分数队列请求
        [MBProgressHUD showMessage:@"加载中" toView:self.view];
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);
            [APIRequest GET:Config.getApiScores parameters:nil timeout:8.0 success:^(id responseObject){
                NSData *scoreData =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *msg=responseObject[@"msg"];
                if([msg isEqualToString:@"ok"]){
                    [Config saveScore:scoreData];
                }else if([msg isEqualToString:@"令牌错误"]){
                    errorStr=ERROR_MSG_INVALID;
                    scoreStatus=scoreStatus+1;
                }else{
                    errorStr=msg;
                    scoreStatus=scoreStatus+1;
                }
                HideAllHUD
                dispatch_group_leave(group);
                
            }failure:^(NSError *error){
                HideAllHUD
                errorStr=@"网络超时";
                scoreStatus=scoreStatus+1;
                dispatch_group_leave(group);
            }];
        });
        
        //排名队列请求
        dispatch_group_async(group, q, ^{
            dispatch_group_enter(group);
            [APIRequest GET:Config.getApiRank parameters:nil timeout:8.0 success:^(id responseObject) {
                if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
                    [Config saveScoreRank:responseObject];
                }else if([responseObject[@"msg"] isEqualToString:@"令牌错误"]){
                    errorStr=ERROR_MSG_INVALID;
                    scoreStatus=scoreStatus+2;
                }else{
                    scoreStatus=scoreStatus+2;
                    errorStr=@"排名查询错误";
                }
                HideAllHUD
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                HideAllHUD
                scoreStatus=scoreStatus+2;
                errorStr=@"网络超时";
                dispatch_group_leave(group);
            }];
        });
        
        //两个队列请求完毕
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            HideAllHUD
            switch (scoreStatus) {
                case ScoreOK:
                    [Config pushViewController:@"ScoreShow"];
                    break;
//                case ScoreRankError:
//                    [MBProgressHUD showError:@"排名查询错误" toView:self.view];
//                    break;
//                case ScoreError:
//                    [MBProgressHUD showError:@"分数查询错误" toView:self.view];
//                    break;
//                case ScoreAndScoreRankError:
//                    [MBProgressHUD showError:@"排名和分数查询错误" toView:self.view];
//                    break;
                default:
                     [MBProgressHUD showError:errorStr toView:self.view];
                    break;
            }

            
        });
    }else{
        [Config pushViewController:@"ScoreShow"];
        
    }
} //成绩查询
- (IBAction)Library:(id)sender {
    [Config pushViewController:@"Library"];
} //图书馆
- (IBAction)Exam:(id)sender {
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [Config pushViewController:@"Exam"];
} //考试计划
- (IBAction)Day:(id)sender {
    DayViewController *chvc = [[DayViewController alloc]init];
  [self.navigationController pushViewController:chvc animated:YES];
}  //校历
- (IBAction)Lost:(id)sender {
    LostViewController *lostViewController=[[LostViewController alloc]init];
    [self.navigationController pushViewController:lostViewController animated:YES];
    
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
    _Time.text=[NSString stringWithFormat:@"第%d周 星期%@",[Math getWeek],[Math transforDay:[Math getWeekDay]]];
    //倒计时
    if ([Config getCalendar]) {
        [self drawCalendar:[Config getCalendar]];
    }
    [APIRequest GET:[Config getApiCalendar] parameters:nil
            success:^(id responseObject) {
                if (![Config getCalendar]) {
                    [self drawCalendar:responseObject];
                }
                [Config saveCalendar:responseObject];
            } failure:^(NSError *error) {
                NSLog(@"倒计时加载失败");
            }];
    [APIRequest GET:[Config getApiVersioniOS] parameters:nil
            success:^(id responseObject) {
            } failure:^(NSError *error) {
                NSLog(@"版本接口调用失败");
            }];
    [APIRequest GET:[Config getApiWeather] parameters:nil
            success:^(id responseObject) {
                NSDictionary *result=[NSDictionary dictionaryWithDictionary:responseObject];
                NSArray *nowAry=result[@"results"];
                NSDictionary *nowDic=[nowAry[0] objectForKey:@"now"];
                NSLog(@"%@",nowDic);
                UILabel *weatherLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(322), SYReal(55), SYReal(150), SYReal(60))];
                weatherLab.text=[NSString stringWithFormat:@"%@℃",nowDic[@"temperature"]];
                weatherLab.textColor=[UIColor whiteColor];
                weatherLab.font=[UIFont fontWithName:@"AvenirNext-Regular" size:SYReal(26)];
                [self.view addSubview:weatherLab];
                UILabel *weatherTextLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(322), SYReal(81), SYReal(150), SYReal(60))];
                weatherTextLab.text=[NSString stringWithFormat:@"株洲|%@",nowDic[@"text"]];
                weatherTextLab.textColor=[UIColor whiteColor];
                weatherTextLab.font=[UIFont fontWithName:@"AvenirNext-Regular" size:SYReal(17)];
                [self.view addSubview:weatherTextLab];
            } failure:^(NSError *error) {
                NSLog(@"天气接口调用失败");
            }];
    
}
//绘制日历
-(void)drawCalendar:(NSArray*)calendarArray{
    _lineView.hidden=false;
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

#pragma mark - 设置方法
//设置通知栏显示内容
-(void)setNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *notice=[defaults objectForKey:@"Notice"];
    _body.text=[notice[0] objectForKey:@"body"];
    _body.font=[UIFont systemFontOfSize:SYReal(16)];
    // _noticetitle.text=[notice[0] objectForKey:@"title"];
    //_noticetime.text=[[notice[0] objectForKey:@"time"] substringWithRange:NSMakeRange(5,5)];
}
//加载设置内容
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
//友盟统计
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
//设置标题栏
-(void)setTitle{
    /**标题文字*/
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
    //按钮
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_notice"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(notice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    //轮番图和手势更换图片
  if ([Config getBanner]) {
        UIImage *Img=[UIImage imageWithData:[Config getBanner]];
        _bannerImgView.image=Img;
   }
     UITapGestureRecognizer *tapBanner = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBanner)];
    tapBanner.numberOfTapsRequired =1;
    [_bannerImgView addGestureRecognizer:tapBanner];
}
#pragma mark -- <UIImagePickerControllerDelegate>--
- (void)touchBanner
{

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        // 2. 创建图片选择控制器
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        // 3. 设置打开照片相册类型(显示所有相簿)
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:ipc animated:YES completion:nil];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:camera];
    [self presentViewController:alertVc animated:YES completion:nil];
}

// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* img ;
    [picker dismissViewControllerAnimated:YES completion:nil];
    img = info[UIImagePickerControllerEditedImage]; //获得修改后
    // img = [info objectForKey:UIImagePickerControllerOriginalImage];   //获得原图
    NSData *imageData = UIImageJPEGRepresentation(img,1.0);
    [Config saveBannerImg:imageData];
    _bannerImgView.image=img;
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

-(void)notice{
    if ([Config isTourist]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游客请登录" message:@"需要学校账号才可使用私信" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ChatListViewController *chatList = [[ChatListViewController alloc] init];
    [tempAppDelegate.mainNavigationController pushViewController:chatList animated:YES];
}


@end

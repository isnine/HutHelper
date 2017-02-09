//
//  AppDelegate.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "NoticeViewController.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import <UMSocialCore/UMSocialCore.h>
#import <JSPatchPlatform/JSPatch.h>
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /**友盟推送*/
    [UMessage startWithAppkey:@"57fe13d867e58e0e59000ca1" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    UNAuthorizationOptions types10   = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    [UMessage setLogEnabled:YES];//打开日志，方便调试
    /**友盟统计*/
    UMConfigInstance.appKey          = @"57fe13d867e58e0e59000ca1";
    UMConfigInstance.ChannelId       = @"App Store";
    UMConfigInstance.eSType          = E_UM_GAME;//仅适用于游戏场景，应用统计不用设置
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    /**设置初始界面*/
    self.window                      = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor      = [UIColor whiteColor];//设置通用背景颜色
    [self.window makeKeyAndVisible];
    MainPageViewController *mainVC   = [[MainPageViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.mainNavigationController    = [[UINavigationController alloc] initWithRootViewController:mainVC];
    LeftSortsViewController *leftVC  = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC                 = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController   = self.LeftSlideVC;
    UIColor *ownColor                = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor: ownColor];  //颜色
    /**友盟分享*/
    [[UMSocialManager defaultManager] openLog:NO]; //打开调试日志
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57fe13d867e58e0e59000ca1"];//设置友盟appkey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105703863"  appSecret:@"y7n6BRLtnH9mrFT3" redirectURL:@"http://mobile.umeng.com/social"];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1046968355"  appSecret:@"ba2997aaab6a1602406fc94247dc072d" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*热更新**/
    [JSPatch startWithAppKey:@"bd9208bd34ab8197"];
    [JSPatch setupDevelopment];
    [JSPatch sync];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo          = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableArray *notice;
        NSArray *array;
        if (![defaults objectForKey:@"Notice"])
            notice=[[NSMutableArray alloc]init];
        else{
            array=[defaults objectForKey:@"Notice"];
            notice=[array mutableCopy];
        }
        //变为可变字典以便加入时间
        NSMutableDictionary *noticeDictionary=[NSMutableDictionary dictionaryWithDictionary:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
        //获得时间
        NSDate * senddate=[NSDate date];
        NSDateFormatter *day=[[NSDateFormatter alloc] init];
        [day setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *time=[NSString stringWithFormat:@"%@",[day stringFromDate:senddate]];
        [noticeDictionary setValue:time forKey:@"time"];
        [notice insertObject:noticeDictionary atIndex:0];
        array = [NSArray arrayWithArray:notice];
        [defaults setObject:array forKey:@"Notice"];//通知列表
        [defaults setObject:noticeDictionary forKey:@"NoticeShow"];//通知详情
        [defaults synchronize];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NoticeViewController *View      = [main instantiateViewControllerWithIdentifier:@"NoticeShow"];//跳转通知详情界面
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:View animated:YES];
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo          = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSMutableArray *notice;
        NSArray *array;
        if (![defaults objectForKey:@"Notice"])
            notice=[[NSMutableArray alloc]init];
        else{
            array=[defaults objectForKey:@"Notice"];
            notice=[array mutableCopy];
        }
        //变为可变字典以便加入时间
        NSMutableDictionary *noticeDictionary=[NSMutableDictionary dictionaryWithDictionary:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
        //获得时间
        NSDate * senddate=[NSDate date];
        NSDateFormatter *day=[[NSDateFormatter alloc] init];
        [day setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *time=[NSString stringWithFormat:@"%@",[day stringFromDate:senddate]];
        [noticeDictionary setValue:time forKey:@"time"];
        [notice insertObject:noticeDictionary atIndex:0];
        array = [NSArray arrayWithArray:notice];
        [defaults setObject:array forKey:@"Notice"];//通知列表
        [defaults setObject:noticeDictionary forKey:@"NoticeShow"];//通知详情
        [defaults synchronize];
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NoticeViewController *View      = [main instantiateViewControllerWithIdentifier:@"NoticeShow"];//跳转通知详情界面
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:View animated:YES];
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

@end

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
#import "UMessage.h"
#import "ScoreViewController.h"
#import "UMMobClick/MobClick.h"
#import <UMSocialCore/UMSocialCore.h>
#import <JSPatchPlatform/JSPatch.h>
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //------------推送--------------------//
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"57fe13d867e58e0e59000ca1" launchOptions:launchOptions];


    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];

    //iOS10必须加下面这段代码。
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
    //打开日志，方便调试
    [UMessage setLogEnabled:NO];
//统计------//
    UMConfigInstance.appKey          = @"57fe13d867e58e0e59000ca1";
    UMConfigInstance.ChannelId       = @"App Store";
    UMConfigInstance.eSType          = E_UM_GAME;//仅适用于游戏场景，应用统计不用设置

    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    ///

    self.window                      = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor      = [UIColor whiteColor];//设置通用背景颜色
    [self.window makeKeyAndVisible];

    //    MainPageViewController *mainVC = [[MainPageViewController alloc] init]; //代码界面
    MainPageViewController *mainVC   = [[MainPageViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.mainNavigationController    = [[UINavigationController alloc] initWithRootViewController:mainVC];

    LeftSortsViewController *leftVC  = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC                 = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController   = self.LeftSlideVC;



    UIColor *ownColor                = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor: ownColor];  //颜色
    
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
    }];
    
    /**分享*/
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57fe13d867e58e0e59000ca1"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105703863"  appSecret:@"y7n6BRLtnH9mrFT3" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1046968355"  appSecret:@"ba2997aaab6a1602406fc94247dc072d" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    /**上传版本信息*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     NSString *studentKH    = [defaults objectForKey:@"studentKH"];
        NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    float app_Version2=[app_Version floatValue];
    app_Version2=app_Version2*100;
    NSString *b = [app_Version substringFromIndex:app_Version.length-1];
    int b_2=[b intValue];
    app_Version2=app_Version2+b_2;
    if(studentKH!=NULL){

//     NSURLRequest *request=[NSURLRequest requestWithURL:url];
 //    NSLog(@"%@",urlStr);
        //第一步，创建url
        NSString *urlStr=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/get/versionios/%@/%.0lf",studentKH,app_Version2];
        NSURL *url=[NSURL URLWithString:urlStr];
        //第二步，创建请求
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //第三步，连接服务器
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    }
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        NSLog(@"前台介绍通知");
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
        NSLog(@"后台介绍通知");
        [UMessage didReceiveRemoteNotification:userInfo];

    }else{
        //应用处于后台时的本地推送接受
    }

}

@end

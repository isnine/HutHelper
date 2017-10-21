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
#import "iVersion.h"
#import <RongIMKit/RongIMKit.h>
#import "ChatListViewController.h"
@interface AppDelegate ()<RCIMUserInfoDataSource>{
    
}

@property (copy  , nonatomic) NSString *userId;
@property (copy  , nonatomic) NSString *token;
@end

@implementation AppDelegate

#pragma mark - 生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟推送
    [UMessage startWithAppkey:APPKEY_UMESSAGE launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    UNAuthorizationOptions types10   = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            
        }
    }];
    [UMessage setLogEnabled:YES];//打开日志，方便调试
    //友盟统计
    UMConfigInstance.appKey = APPKEY_UMESSAGE;
    [MobClick setAppVersion:[Config getCurrentVersion]];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    //设置初始界面
    self.window.backgroundColor      = [UIColor whiteColor];//设置通用背景颜色
    [self.window makeKeyAndVisible];
    MainPageViewController *mainVC   = [[MainPageViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.mainNavigationController    = [[UINavigationController alloc] initWithRootViewController:mainVC];
    LeftSortsViewController *leftVC  = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC                 = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    mainVC.leftSortsViewController=leftVC;
    self.window.rootViewController   = self.LeftSlideVC;
    //标题栏颜色
    self.mainNavigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //返回箭头颜色
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    //友盟分享
    [[UMSocialManager defaultManager] openLog:NO]; //打开调试日志
    [[UMSocialManager defaultManager] setUmSocialAppkey:APPKEY_UMESSAGE];//设置友盟appkey
    [self configUSharePlatforms];
    //热更新
        [JSPatch startWithAppKey:APPKEY_JSPATCH];
  //      [JSPatch setupDevelopment];
        [JSPatch setupRSAPublicKey:RSA_JSPATCH];
        [JSPatch sync];
    //IM
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_APPKEY];
    //IM登录
    if ([Config getImToken]) {
        NSLog(@"执行融云登录");
        [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
        [RCIM sharedRCIM].enablePersistentUserInfoCache=YES;
        [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
        [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
        [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =@[@(ConversationType_PRIVATE)];
        [RCIM sharedRCIM].enableTypingStatus=YES;
        [RCIM sharedRCIM].enableSyncReadStatus=YES;
        [RCIM sharedRCIM].globalNavigationBarTintColor=[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1];
        [[RCIM sharedRCIM] connectWithToken:[Config getImToken]
                                    success:^(NSString *userId) {
                                        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[RCIM sharedRCIM]setUserInfoDataSource:self];
                                        });
                                    } error:^(RCConnectErrorCode status) {
                                        NSLog(@"登陆的错误码为:%d", status);
                                    } tokenIncorrect:^{
                                        NSLog(@"token错误");
                                    }];
    }
    //融云推送
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    //设置返回按钮
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    UIImage *image = [UIImage imageNamed:@"ico_menu_back"];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
#ifdef DEBUG//因为这个是私有的api，一定要保证上线时的包中不包含这段代码！
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id debugClass = NSClassFromString(@"UIDebuggingInformationOverlay");//获得对象
    [debugClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];//开启调试模式
#pragma clang diagnostic pop
#endif
    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


//注册用户通知设置
- (void)application:(UIApplication *)application
        didRegisterUserNotificationSettings:
            (UIUserNotificationSettings *)notificationSettings {
        // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];

    NSLog(@"Token:%@",token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"前台通知收到");
    //友盟推送
    NSDictionary * userInfo          = notification.request.content.userInfo;
 //   if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
     //如果是聊天信息，跳转私信
    if ([userInfo objectForKey:@"aps"] ==NULL) {
        ChatListViewController *chatList = [[ChatListViewController alloc] init];
        [self.mainNavigationController pushViewController:chatList animated:YES];
    }else{
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
        NSMutableDictionary *noticeDictionary=[NSMutableDictionary dictionaryWithDictionary:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
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
        [Config pushViewController:@"NoticeShow"];
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
     NSLog(@"后台通知收到");
    NSDictionary * userInfo          = response.notification.request.content.userInfo;
    //如果是聊天信息，跳转私信
    if ([userInfo objectForKey:@"aps"]==NULL) {
        ChatListViewController *chatList = [[ChatListViewController alloc] init];
        [self.mainNavigationController pushViewController:chatList animated:YES];
        return;
    }
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
        NSMutableDictionary *noticeDictionary=[[NSMutableDictionary alloc]init];
        NSLog(@"值%@ 值%@",[userInfo objectForKey:@"aps"],[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        noticeDictionary=[NSMutableDictionary dictionaryWithDictionary:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
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
        [Config pushViewController:@"NoticeShow"];
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
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
        NSMutableDictionary *noticeDictionary=[NSMutableDictionary
                                               dictionaryWithDictionary:
                                               [[userInfo objectForKey:@"aps"]objectForKey:@"alert"]
                                               ];
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
        [Config pushViewController:@"NoticeShow"];
        [UMessage didReceiveRemoteNotification:userInfo];
    }
}
#pragma mark - 其他
//融云获取用户头像
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    [APIRequest GET:[Config getApiImUserInfo:userId] parameters:nil
            success:^(id responseObject) {
                RCUserInfo *userInfo=[[RCUserInfo alloc]init];
                NSLog(@"全局他人:%@",responseObject[@"data"][@"TrueName"]);
                userInfo.userId=userId;
                userInfo.name=responseObject[@"data"][@"TrueName"];
                userInfo.portraitUri=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,responseObject[@"data"][@"head_pic_thumb"]];
                return completion(userInfo);
            } failure:^(NSError *error) {
                NSLog(@"全局他人失败");
                return completion(nil);
            }];
}
//友盟分析平台设置
- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105703863"  appSecret:APPKEY_QQ_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1046968355"  appSecret:APPKEY_SINA_SECRET redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx944eb9ae391a7c2b" appSecret:APPKEY_WECHAT_SECRET redirectURL:@"http://mobile.umeng.com/social"];
}
//检查app更新
+ (void)initialize
{
    [iVersion sharedInstance].appStoreID = APPSTORE_ID;
}




@end

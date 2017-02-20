//
//  MobClick.h
//  Analytics
//
//  Copyright (C) 2010-2016 Umeng.com . All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
typedef void(^CallbackBlock)();

/**
  REALTIME只在“集成测试”设备的DEBUG模式下有效，其它情况下的REALTIME会改为使用BATCH策略。
 */
typedef enum {
    REALTIME = 0,       //实时发送              (只在“集成测试”设备的DEBUG模式下有效)
    BATCH = 1,          //启动发送
    SEND_INTERVAL = 6,  //最小间隔发送           ([90-86400]s, default 90s)
    SMART_POLICY = 8,
} ReportPolicy;

/**
 统计的场景类别，默认为普通统计；若使用游戏统计API，则需选择游戏场景类别，如E_UM_GAME。
 */
typedef NS_ENUM (NSUInteger, eScenarioType)
{
    E_UM_NORMAL = 0,    // default value
    E_UM_GAME = 1,      // game
};

/** @brief 统计SDK的配置实例，具体参照该类成员的参数定义
 * 示例代码: UMConfigInstance.appKey = @"xxxxxxxxxxxxxx...";
 *         UMConfigInstance.token = @"yyyyyyyy....";
 *         [MobClick startWithConfigure:UMConfigInstance];
 */
#define UMConfigInstance [UMAnalyticsConfig sharedInstance]
@interface UMAnalyticsConfig : NSObject
/** required:  appkey string */
@property(nonatomic, copy) NSString *appKey;
/** optional:  default: nil*/
@property(nonatomic, copy) NSString *secret;
/** optional:  default: "App Store"*/
@property(nonatomic, copy) NSString *channelId;
/** optional:  default: YES */
@property(nonatomic) BOOL  bCrashReportEnabled;
/** optional:  default: BATCH */
@property(nonatomic) ReportPolicy   ePolicy;
/** optional:  default: E_UM_NORMAL */
@property(nonatomic) eScenarioType  eSType;

+ (instancetype)sharedInstance;
@end

@class CLLocation;
@interface MobClick : NSObject <UIAlertViewDelegate>

#pragma mark basics
///---------------------------------------------------------------------------------------
/// @name  初始化统计
///---------------------------------------------------------------------------------------


+ (void) startWithConfigure:(UMAnalyticsConfig *)configure;

///---------------------------------------------------------------------------------------
/// @name  设置
///---------------------------------------------------------------------------------------


+ (void)setAppVersion:(NSString *)appVersion;


+ (void)setCrashReportEnabled:(BOOL)value;


+ (void)setLogEnabled:(BOOL)value;

/** 设置是否开启background模式, 默认YES.
 @param value 为YES,SDK会确保在app进入后台的短暂时间保存日志信息的完整性，对于已支持background模式和一般app不会有影响.
        如果该模式影响某些App在切换到后台的功能，也可将该值设置为NO.

 */
+ (void)setBackgroundTaskEnabled:(BOOL)value;

/** 设置是否对日志信息进行加密, 默认NO(不加密).
 @param value 设置为YES, umeng SDK 会将日志信息做加密处理
 */
+ (void)setEncryptEnabled:(BOOL)value;

/** 当reportPolicy == SEND_INTERVAL 时设定log发送间隔
 @param second 单位为秒,最小90秒,最大86400秒(24hour).
*/
+ (void)setLogSendInterval:(double)second;



#pragma mark event logs
///---------------------------------------------------------------------------------------
/// @name  页面计时
///---------------------------------------------------------------------------------------


+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;


+ (void)beginLogPageView:(NSString *)pageName;


+ (void)endLogPageView:(NSString *)pageName;


///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------

+ (void)event:(NSArray *)keyPath value:(int)value label:(NSString *)label;


+ (void)event:(NSString *)eventId; //等同于 event:eventId label:eventId;

+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;


+ (void)beginEvent:(NSString *)eventId;

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId;

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId label:(NSString *)label;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId durations:(int)millisecond;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond;


#pragma mark - user methods

+ (void)profileSignInWithPUID:(NSString *)puid;
+ (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider;

/** active user sign-off.
 停止sign-in PUID的统计
 @return void.
 */
+ (void)profileSignOff;


+ (void)setLatitude:(double)latitude longitude:(double)longitude;


+ (void)setLocation:(CLLocation *)location;

///---------------------------------------------------------------------------------------
/// @name Utility函数
///---------------------------------------------------------------------------------------

/** 判断设备是否越狱，依据是否存在apt和Cydia.app
 */
+ (BOOL)isJailbroken;

/** 判断App是否被破解
 */
+ (BOOL)isPirated;

#pragma mark DEPRECATED
/** 友盟模块启动
 [MobClick startWithConfigure:]通常在application:didFinishLaunchingWithOptions:里被调用监听App启动和退出事件，
 如果开发者无法在此处添加友盟的[MobClick startWithConfigure:]方法，App的启动事件可能会无法监听，此时需要手动调用[MobClick startSession:nil]来启动友盟的session。
 上述情况通常发生在某些第三方框架生成的app里，普通app不用关注该API.
 */
+ (void)startSession:(NSNotification *)notification;

+ (void)setCrashCBBlock:(CallbackBlock)cbBlock;
@end

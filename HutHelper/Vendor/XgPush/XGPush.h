//
//  信鸽核心接口
//  XG-SDK
//
//  Created by xiangchen on 13-10-18.
//  Update by uweiyuan on 4/08/17.
//  Copyright (c) 2013年 XG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLLocation;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/**
 @brief 点击行为对象的属性配置
 
 - XGNotificationActionOptionNone: 无
 - XGNotificationActionOptionAuthenticationRequired: 需要认证的选项
 - XGNotificationActionOptionDestructive: 具有破坏意义的选项
 - XGNotificationActionOptionForeground: 打开应用的选项
 */
typedef NS_ENUM(NSUInteger, XGNotificationActionOptions) {
	XGNotificationActionOptionNone = (0),
	XGNotificationActionOptionAuthenticationRequired = (1 << 0),
	XGNotificationActionOptionDestructive = (1 << 1),
	XGNotificationActionOptionForeground = (1 << 2)
};

/**
 * @brief 定义了一个可以在通知栏中点击的事件对象
 */
@interface XGNotificationAction : NSObject

/**
 @brief 在通知消息中创建一个可以点击的事件行为

 @param identifier 行为唯一标识
 @param title 行为名称
 @param options 行为支持的选项
 @return 行为对象
 @note 通知栏带有点击事件的特性，只有在iOS8+以上支持，iOS 8 or earlier的版本，此方法返回空
 */
+ (nullable id)actionWithIdentifier:(nonnull NSString *)identifier title:(nonnull NSString *)title options:(XGNotificationActionOptions)options;

/**
 @brief 点击行为的标识
 */
@property (nullable, nonatomic, copy, readonly) NSString *identifier;

/**
 @brief 点击行为的标题
 */
@property (nullable, nonatomic, copy, readonly) NSString *title;

/**
 @brief 点击行为的特性
 */
@property (readonly, nonatomic) XGNotificationActionOptions options;

@end


/**
 @brief 分类对象的属性配置

 - XGNotificationCategoryOptionNone: 无
 - XGNotificationCategoryOptionCustomDismissAction: 发送消失事件给UNUserNotificationCenter(iOS 10 or later)对象
 - XGNotificationCategoryOptionAllowInCarPlay: 允许CarPlay展示此类型的消息
 */
typedef NS_OPTIONS(NSUInteger, XGNotificationCategoryOptions) {
	XGNotificationCategoryOptionNone = (0),
	XGNotificationCategoryOptionCustomDismissAction = (1 << 0),
	XGNotificationCategoryOptionAllowInCarPlay = (1 << 1)
};


/**
 * 通知栏中消息指定的分类，分类主要用来管理一组关联的Action，以实现不同分类对应不同的Actions
 */
@interface XGNotificationCategory : NSObject


/**
 @brief 创建分类对象，用以管理通知栏的Action对象

 @param identifier 分类对象的标识
 @param actions 当前分类拥有的行为对象组
 @param intentIdentifiers 用以表明可以通过Siri识别的标识
 @param options 分类的特性
 @return 管理点击行为的分类对象
 @note 通知栏带有点击事件的特性，只有在iOS8+以上支持，iOS 8 or earlier的版本，此方法返回空
 */
+ (nullable id)categoryWithIdentifier:(nonnull NSString *)identifier actions:(nullable NSArray<XGNotificationAction *> *)actions intentIdentifiers:(nullable NSArray<NSString *> *)intentIdentifiers options:(XGNotificationCategoryOptions)options;

/**
 @brief 分类对象的标识
 */
@property (nonnull, readonly, copy, nonatomic) NSString *identifier;

/**
 @brief 分类对象拥有的点击行为组
 */
@property (nonnull, readonly, copy, nonatomic) NSArray<XGNotificationAction *> *actions;

/**
 @brief 可用以Siri意图的标识组
 */
@property (nullable, readonly, copy, nonatomic) NSArray<NSString *> *intentIdentifiers;

/**
 @brief 分类的特性
 */
@property (readonly, nonatomic) XGNotificationCategoryOptions options;

@end

/**
 @brief 注册通知支持的类型

 - XGUserNotificationTypeNone: 无
 - XGUserNotificationTypeBadge: 支持应用角标
 - XGUserNotificationTypeSound: 支持铃声
 - XGUserNotificationTypeAlert: 支持弹框
 - XGUserNotificationTypeCarPlay: 支持CarPlay
 - XGUserNotificationTypeNewsstandContentAvailability: 支持Newsstand
 */
typedef NS_OPTIONS(NSUInteger, XGUserNotificationTypes) {
	XGUserNotificationTypeNone = (0),
	XGUserNotificationTypeBadge = (1 << 0),
	XGUserNotificationTypeSound = (1 << 1),
	XGUserNotificationTypeAlert = (1 << 2),
	XGUserNotificationTypeCarPlay = (1 << 3),
	XGUserNotificationTypeNewsstandContentAvailability = (1 << 4) // iOS 8 以下版本支持
};

/**
 @brief 管理推送消息通知栏的样式和特性
 */
@interface XGNotificationConfigure : NSObject

/**
 @brief 配置通知栏对象，主要是为了配置消息通知的样式和行为特性

 @param categories 通知栏中支持的分类集合
 @param types 注册通知的样式
 @return 配置对象
 */
+ (nullable instancetype)configureNotificationWithCategories:(nullable NSSet<XGNotificationCategory *> *)categories types:(XGUserNotificationTypes)types;


/**
 @brief 返回消息通知栏配置对象
 */
@property (readonly, nullable, strong, nonatomic) NSSet<XGNotificationCategory *> *categories;


/**
 @brief 返回注册推送的样式类型
 */
@property (readonly, nonatomic) XGUserNotificationTypes types;

/**
 @brief 默认的注册推送的样式类型
 */
@property (readonly, nonatomic) XGUserNotificationTypes defaultTypes;

- (nullable instancetype)init NS_UNAVAILABLE;

@end


/**
 @brief 设备token绑定的类型，绑定指定类型之后，就可以在信鸽前端按照指定的类型进行指定范围的推送

 - XGPushTokenBindTypeNone: 当前设备token不绑定任何类型，可以使用token单推，或者是全量推送
 - XGPushTokenBindTypeAccount: 当前设备token与账号绑定之后，可以使用账号推送
 - XGPushTokenBindTypeTag: 当前设备token与指定标签绑定之后，可以使用标签推送
 */
typedef NS_ENUM(NSUInteger, XGPushTokenBindType) {
	XGPushTokenBindTypeNone = (0),
	XGPushTokenBindTypeAccount = (1 << 0),
	XGPushTokenBindTypeTag = (1 << 1)
};

/**
 @brief 定义了一组关于设备token绑定，解绑账号和标签的回调方法，用以监控绑定和解绑的情况
 */
@protocol XGPushTokenManagerDelegate <NSObject>

@optional

/**
 @brief 监控token对象绑定的情况

 @param identifier token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidBindWithIdentifier:(nullable NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error;


/**
 @brief 监控token对象解绑的情况

 @param identifier token对象绑定的标识
 @param type token对象绑定的类型
 @param error token对象绑定的结果信息
 */
- (void)xgPushDidUnbindWithIdentifier:(nullable NSString *)identifier type:(XGPushTokenBindType)type error:(nullable NSError *)error;


@end

@interface XGPushTokenManager : NSObject

/**
 @brief 创建设备token的管理对象，用来管理token的绑定与解绑操作
 
 @return 设备token管理对象
 */

+ (nonnull instancetype)defaultTokenManager;

- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 @brief 将接收到的设备token注册给token管理对象

 @param deviceToken 设备的token，这个参数来来源于Application delegate 的didRegisterForRemoteNotificationsWithDeviceToken:方法中
 @note 此方法是必须在上述回调中调用，否则将导致信鸽服务无法推送消息到指定的设备, 3.0中此方法可以不需要手动在didRegisterForRemoteNotificationsWithDeviceToken调用，SDK内部处理
 */
- (void)registerDeviceToken:(nonnull NSData *)deviceToken;

/**
 @brief 设备token管理操作的代理对象
 */
@property (weak, nonatomic, nullable) id<XGPushTokenManagerDelegate> delegatge;

/**
 @brief 返回当前设备token的字符串
 */
@property (copy, nonatomic, nullable, readonly) NSString *deviceTokenString;

/**
 @brief 为token对象设置绑定类型和标识

 @param identifier 指定绑定标识
 @param type 指定绑定类型
 @note  对于账号类型的绑定，信鸽服务只会绑定最新账号，重复设置账号会导致之前的账号失效
 */
- (void)bindWithIdentifier:(nullable NSString *)identifier type:(XGPushTokenBindType)type;

/**
 @brief 为token对象解除绑定类型和标识

 @param identifier 指定绑定标识
 @param type 指定绑定类型
 */
- (void)unbindWithIdentifer:(nullable NSString *)identifier type:(XGPushTokenBindType)type;

/**
 @brief 根据指定类型查询当前token对象绑定的标识

 @param type 指定绑定类型
 @return 当前token对象绑定的标识
 */
- (nullable NSArray<NSString *> *)identifiersWithType:(XGPushTokenBindType)type;

@end


/**
 @brief 监控信鸽服务启动和设备token注册的一组方法
 */
@protocol XGPushDelegate <NSObject>

@optional

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
/**
 处理iOS 10 UNUserNotification.framework的对应的方法

 @param center [UNUserNotificationCenter currentNotificationCenter]
 @param notification 通知对象
 @param completionHandler 回调对象，必须调用
 */
- (void)xgPushUserNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nullable UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0);


/**
 处理iOS 10 UNUserNotification.framework的对应的方法

 @param center [UNUserNotificationCenter currentNotificationCenter]
 @param response 用户对通知消息的响应对象
 @param completionHandler 回调对象，必须调用
 */
- (void)xgPushUserNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nullable UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler __IOS_AVAILABLE(10.0);

#endif

/**
 @brief 监控信鸽推送服务地启动情况

 @param isSuccess 信鸽推送是否启动成功
 @param error 信鸽推送启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error;

/**
 @brief 监控信鸽服务的终止情况

 @param isSuccess 信鸽推送是否终止
 @param error 信鸽推动终止错误的信息
 */
- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(nullable NSError *)error;


/**
 @brief 监控信鸽服务上报推送消息的情况

 @param isSuccess 上报是否成功
 @param error 上报失败的信息
 */
- (void)xgPushDidReportNotification:(BOOL)isSuccess error:(nullable NSError *)error;


/**
 @brief 监控设置信鸽服务器下发角标的情况

 @param isSuccess isSuccess 上报是否成功
 @param error 设置失败的信息
 */
- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(nullable NSError *)error;

@end

/**
 @brief 管理信鸽推送服务的对象，负责注册推送权限、消息的管理、调试模式的开关设置等
 */
@interface XGPush : NSObject

#pragma mark - 初始化相关

/**
 @brief 获取信鸽推送管理的单例对象

 @return 信鸽推送对象
 */
+ (nonnull instancetype)defaultManager;

/**
 @brief 关于信鸽推送SDK接口协议的对象
 */
@property (weak, nonatomic, nullable, readonly) id<XGPushDelegate> delegate;


/**
 @brief 信鸽推送管理对象，管理推送的配置选项，例如，注册推送的样式
 */
@property (nullable, strong, nonatomic) XGNotificationConfigure *notificationConfigure;


/**
 @brief 这个开关表明是否打印信鸽SDK的日志信息
 */
@property (assign, getter=isEnableDebug) BOOL enableDebug;

/**
 @brief 返回信鸽推送服务的状态
 */
@property (assign, readonly) BOOL xgNotificationStatus;

/**
 @brief 管理应用角标
 */
@property (nonatomic) NSInteger xgApplicationBadgeNumber;

/**
 @brief 通过使用在信鸽官网注册的应用的信息，启动信鸽推送服务

 @param appID 通过前台申请的应用ID
 @param appKey 通过前台申请的appKey
 @param delegate 回调对象
 @note 接口所需参数必须要正确填写，反之信鸽服务将不能正确为应用推送消息
 */
- (void)startXGWithAppID:(uint32_t)appID appKey:(nonnull NSString *)appKey delegate:(nullable id<XGPushDelegate>)delegate;

/**
 @brief 停止信鸽推送服务
 @note 调用此方法将导致当前设备不再接受信鸽服务推送的消息.如果再次需要接收信鸽服务的消息推送，则必须需要再次调用startXG:withAppKey:delegate:方法重启信鸽推送服务
 */
- (void)stopXGNotification;

/**
 @brief 上报应用收到的推送信息，以便信鸽服务能够统计相关数据，包括但不限于：1.推送消息被点击的次数，2.消息曝光的次数

 @param info 应用接收到的推送消息对象的内容
 @note 请在实现application delegate 的 application:didFinishLaunchingWithOptions:或者application:didReceiveRemoteNotification:的方法中调用此接口，参数就使用这两个方法中的NSDictionaryl类型的参数即可，从而完成推送消息的数据统计
 */
- (void)reportXGNotificationInfo:(nonnull NSDictionary *)info;

/**
 @brief 上报地理位置信息

 @param latitude 纬度
 @param longitude 经度
 */
- (void)reportLocationWithLatitude:(double)latitude longitude:(double)longitude;

/**
 @brief 上报当前App角标数到信鸽服务器

 @param badgeNumber 应用的角标数
 @note (后台维护中)此接口是为了实现角标+1的功能，服务器会在这个数值基础上进行角标数新增的操作，调用成功之后，会覆盖之前值。
 */
- (void)setBadge:(NSInteger)badgeNumber;

/**
 @brief 查询设备通知权限是否被用户允许

 @param handler 查询结果的返回方法
 @note iOS 10 or later 回调是异步地执行
 */
- (void)deviceNotificationIsAllowed:(nonnull void (^)(BOOL isAllowed))handler;

/**
 查看SDK的版本

 @return sdk版本号
 */
- (nonnull NSString *)sdkVersion;

@end

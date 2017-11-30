//
//  MTAConfig.h
//  TA-SDK
//
//  Originally created by WQY on 12-11-5.
//  Updated and maintained by xiangchen and tyzualtang.
//

#import <Foundation/Foundation.h>

/**
 上报策略枚举值
 */
typedef enum {
	/**
	 实时上报
	 */
	MTA_STRATEGY_INSTANT = 1,

	/**
	 批量上报，达到缓存临界值时触发发送
	 */
	MTA_STRATEGY_BATCH = 2,

	/**
	 应用启动时发送
	 */
	MTA_STRATEGY_APP_LAUNCH = 3,

	/**
	 仅在WIFI网络下发送
	 */
	MTA_STRATEGY_ONLY_WIFI = 4,

	/**
	 每间隔一定最小时间发送，默认24小时
	 */
	MTA_STRATEGY_PERIOD = 5,

	/**
	 开发者在代码中主动调用发送行为
	 */
	MTA_STRATEGY_DEVELOPER = 6,

	/**
	 仅在WIFI网络下发送, 发送失败以及非WIFI网络情况下不缓存数据
	 */
	MTA_STRATEGY_ONLY_WIFI_NO_CACHE = 7,

	/*
     不缓存数据，批量上报+间隔上报组合。适用于上报特别频繁的场景。
     */
	MTA_STRATEGY_NO_CACHE_BATCH_PERIOD = 8

} MTAStatReportStrategy;

@interface MTAConfig : NSObject

#pragma mark - 常规配置项

/**
 取得MTA配置的共享实例
 修改实例的属性必须在调用MTA启动函数之前执行

 @return MTAConfig的共享实例
 */
+ (instancetype)getInstance;

/**
 debug开关
 开以后，终端会输出debug日志，默认关闭
 */
@property BOOL debugEnable;

/**
 Session过期时间，默认30秒
 */
@property uint32_t sessionTimeoutSecs;

/**
 上报策略
 */
@property (nonatomic) MTAStatReportStrategy reportStrategy;


/**
 是否自动统计整个APP的使用时长，默认打开
 */
@property BOOL autoTM;

/**
 若打开此项，MTA会在ViewController的
 viewDidAppear和viewWillDisappear
 方法中，自动统计页面时长。
 默认打开

 注：若您自行实现了ViewController中
 的viewDidAppear和viewWillDisappear
 这两个方法。请在这两个方法中分别调用父类
 的对应方法。否则此功能可能无法正常工作。
 */
@property BOOL autoTrackPage;

/**
 应用的统计AppKey
 */
@property (nonatomic, copy) NSString *appkey;

/**
 渠道名，默认为"appstore"
 */
@property (nonatomic, copy) NSString *channel;


/**
 最大缓存的未发送的统计消息，默认1024条
 */
@property uint32_t maxStoreEventCount;

/**
 一次最大加载未发送的缓存消息，默认30条
 */
@property uint32_t maxLoadEventCount;

/**
 统计上报策略为BATCH时，触发上报时最小缓存消息数，默认30条
 */
@property uint32_t minBatchReportCount;

/**
 发送失败最大重试数，默认3次
 */
@property uint32_t maxSendRetryCount;

/**
 上报策略为PERIOD时发送间隔，单位分钟，默认一天（1440分钟）
 */
@property uint32_t sendPeriodMinutes;

/**
 允许同时统计的时长事件数，默认1024条
 */
@property uint32_t maxParallelTimingEvents;

/**
 智能上报
 开启以后设备接入WIFI会实时上报
 否则按照全局策略上报
 默认打开
 */
@property BOOL smartReporting;

/**
 是否启动MTA的崩溃报告功能
 默认为YES
 */
@property BOOL autoExceptionCaught;

/**
 最大上报的单条event长度，超过不上报
 单位Byte
 默认4096，即4KB
 */
@property uint32_t maxReportEventLength;

/**
 MTA是否启动
 */
@property BOOL statEnable;

/**
 设备的idfa，建议有广告权限的app设置此字段
 默认为空
 */
@property (nonatomic, copy) NSString *ifa;

/**
 用户自定义的App版本
 默认为空
 若设置了这个字段，SDK会取这个字段作为APP版本上报
 若没设置，则取工程配置文件中的‘Bundle versions string, short’字段作为APP版本上报
 若没没设置‘Bundle versions string, short’字段，则取‘Bundle version’字段上报
 */
@property (nonatomic, copy) NSString *customerAppVersion;

/**
 一个Session内允许上报的最大事件数
 传入-1表示无限制
 不建议修改这个字段
 默认无限制
 */
@property int32_t maxSessionStatReportCount;

/**
 获取在MTA前端控制台配置的参数
 调用这个函数前需要在MTA前端控制台中‘应用配置管理项’下的‘自定义参数’中配置才能生效
 首次配置或者更改参数配置后，需要3-5分钟才能生效

 @param key 参数的key
 @param v 没取到参数时返回的默认值
 @return 参数的值或者默认值
 */
- (NSString *)getCustomProperty:(NSString *)key default:(NSString *)v;

#pragma mark - 高级配置项，具体配置方法请咨询客服

@property (nonatomic, copy) NSString *statReportURL;
@property (nonatomic, copy) NSString *pushDeviceToken;
@property (nonatomic, copy) NSString *op;
@property (nonatomic, copy) NSString *cn;

#pragma mark - 废弃API，建议替换
@property (nonatomic, copy) NSString *customerUserID DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *account DEPRECATED_ATTRIBUTE;
@property int8_t accountType DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *accountExt DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *qq DEPRECATED_ATTRIBUTE;

//typedef void (^crashCallback) (void);
//@property (nonatomic,copy) crashCallback atCrashCallback; // 崩溃发生时候的回调，将在崩溃发生时候调用
@end

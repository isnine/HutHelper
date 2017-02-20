//
//  UMComPlatformProviderManager.h
//  UMSocialSDK
//
//  Created by 张军华 on 16/8/5.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialPlatformProvider.h"
#import "UMSocialGlobal.h"
@class UMSocialMessageObject;
@interface UMSocialManager : NSObject

+(instancetype)defaultManager;

//友盟自己的appkey(暂时写成属性)
@property(nonatomic,strong)NSString* umSocialAppkey;
@property(nonatomic,strong)NSString* umSocialAppSecret;
@property(nonatomic,readonly,strong) NSMutableArray * platformTypeArray;


/**
 *  打开日志
 *
 *  @param isOpen YES代表打开，No代表关闭
 */
-(void) openLog:(BOOL)isOpen;


- (BOOL)setPlaform:(UMSocialPlatformType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;



- (void)shareToPlatform:(UMSocialPlatformType)platformType
          messageObject:(UMSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(UMSocialRequestCompletionHandler)completion;


- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType
                    completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  获取用户信息
 *  @param currentViewController 用于弹出类似邮件分享、短信分享等这样的系统页面
 *  @param completion   回调
 */
- (void)getUserInfoWithPlatform:(UMSocialPlatformType)platformType
          currentViewController:(id)currentViewController
                     completion:(UMSocialRequestCompletionHandler)completion;

/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
-(BOOL)handleOpenURL:(NSURL *)url;



-(BOOL)addAddUserDefinePlatformProvider:(id<UMSocialPlatformProvider>)userDefinePlatformProvider
             withUserDefinePlatformType:(UMSocialPlatformType)platformType;


/**
 *  获得对应的平台类型platformType的PlatformProvider
 *
 *  @param platformType @see platformType
 *
 *  @return 返回继承UMSocialPlatformProvider的handle
 */
-(id<UMSocialPlatformProvider>)platformProviderWithPlatformType:(UMSocialPlatformType)platformType;



/**
 *  动态的删除不想显示的平台，不管是预定义还是用户自定义的
 *
 *  @param platformTypeArray 平台类型数组
 */
-(void) removePlatformProviderWithPlatformTypes:(NSArray *)platformTypeArray;


-(void) removePlatformProviderWithPlatformType:(UMSocialPlatformType)platformType;


-(BOOL) isInstall:(UMSocialPlatformType)platformType;

-(BOOL) isSupport:(UMSocialPlatformType)platformType;


#pragma mark - DEPRECATED METHOD

- (void)authWithPlatform:(UMSocialPlatformType)platformType
   currentViewController:(id)currentViewController
              completion:(UMSocialRequestCompletionHandler)completion __attribute__((deprecated));

@end


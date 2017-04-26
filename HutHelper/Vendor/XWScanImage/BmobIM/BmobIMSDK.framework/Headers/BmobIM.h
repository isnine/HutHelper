//
//  BIMManager.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/12.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobIMConversation.h"


@protocol BmobIMDelegate ;

@interface BmobIM : NSObject

@property (weak, nonatomic) id <BmobIMDelegate> delegate;

+(instancetype)sharedBmobIM;

/**
 *  设置应用的appKey 即后台上面的application ID
 *
 *  @param appKey 应用的appKey
 */
-(void)registerWithAppKey:(NSString *)appKey;

/**
 *  设置应用下的设备的token
 *
 *  @param token deviceToken
 */
-(void)setupDeviceToken:(NSString *)token;

/**
 *  设置IM的用户标识，用户的objectId
 *
 *  @param belongId 用户的objectId
 */
-(void)setupBelongId:(NSString *)belongId;

/**
 *  连接服务器,需要已经设置了appkey和belongId之后调用
 */
-(void)connect;

/**
 *  断开连接
 */
-(void)disconnect;

/**
 *  是否连接中
 *
 *  @return 是否连接中
 */
-(BOOL)isConnected;


/**
 *  查询本地存储的会话列表
 *
 *  @return 会话列表数组
 */
-(NSArray <BmobIMConversation *>*)queryRecentConversation;

#pragma mark - 用户信息
/**
 *  保存用户信息
 *
 *  @param userInfo 用户信息
 *
 *  @return 保存成功与否的结果
 */
-(void)saveUserInfo:(BmobIMUserInfo *)userInfo;

/**
 *  保存用户
 *
 *  @param array 用户信息数组
 *
 *  @return 保存的结果
 */
-(void)saveUserInfos:(NSArray *)array;


/**
 *  查找本地保存的用户的objectId
 *
 *  @return 所有用户的objectId
 */
-(NSArray *)allUsersIds;


/**
 *  查找本地保存的用户的信息
 *
 *  @return 所有用户的信息
 */
-(NSArray *)allUserInfos;


/**
 *  查找会话表中的所有聊天对象的objectId
 *
 *  @return 所有用户的objectId
 */
-(NSArray *)allConversationUsersIds;

/**
 *  查找本地数据库指定的用户信息
 *
 *  @param userId 用户的objectId
 *
 *  @return 指定用户信息
 */
-(BmobIMUserInfo *)userInfoWithUserId:(NSString *)userId;

@end


@protocol BmobIMDelegate <NSObject>
@optional
/**
 *  接收到新信息
 */
-(void)didRecieveMessage:(BmobIMMessage *)message withIM:(BmobIM *)im;

/**
 *  获取到离线消息
 *
 *  @param array 离线消息数组
 *  @param im    BmobIM对象
 */
-(void)didGetOfflineMessagesWithIM:(BmobIM *)im;
@end
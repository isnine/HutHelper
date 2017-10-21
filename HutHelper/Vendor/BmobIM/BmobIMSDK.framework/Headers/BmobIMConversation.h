//
//  BIMRecent.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/16.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobIMUserInfo.h"
#import "BmobIMMessage.h"
#import "BmobIMConfig.h"


/**
 *  会话
 */
@interface BmobIMConversation : NSObject

/**
 *  会话类型
 */
@property (assign, nonatomic) BmobIMConversationType         conversationType;

/**
 *  目标会话ID
 */
@property (copy,   nonatomic) NSString                       *conversationId;

/**
 *  会话的标题
 */
@property (copy,   nonatomic) NSString                       *conversationTitle;

/**
 *  会话的头像
 */
@property (copy,   nonatomic) NSString                       *conversationIcon;


/**
 *  会话的最后消息的内容
 */
@property (copy,   nonatomic) NSString                       *conversationDetail;

/**
 *  会话中的未读消息数量
 */
@property (assign, nonatomic) int                            unreadCount;

/**
 *  是否置顶
 */
@property (assign, nonatomic) BOOL                           isTop;


/**
 *   精确到毫秒
 */
@property (assign, nonatomic) uint64_t                           updatedTime;

/**
 *  接收状态
 */
@property (assign, nonatomic) BmobIMReceivedStatus           receiveStatus;

/**
 *  发送状态
 */
@property (assign, nonatomic) BmobIMSendStatus               sendStatus;


/**
 *  创建会话对象
 *
 *  @param conversationId 会话Id
 *  @param type           会话类型
 *
 *  @return 创建会话对象
 */
+(instancetype)conversationWithId:(NSString *)conversationId
                 conversationType:(BmobIMConversationType)type;

/**
 *  发送消息,消息类型目前:包括文本（content为文本的内容），图片，语音（content为图片、语音的url），都需要设置msg的toId
 *
 *  @param msg 消息的实例
 */
-(void)sendMessage:(BmobIMMessage *)msg completion:(BmobIMBooleanResultBlock)block;


/**
 *  重发消息
 *
 *  @param msg   消息
 *  @param block 操作的结果
 */
-(void)resendMessage:(BmobIMMessage *)msg completion:(BmobIMBooleanResultBlock)block;

/**
 *  获取某个人的对话
 *
 *
 *  @param 返回的条数   默认10条
 *
 *  @return 聊天记录
 */
-(NSArray *)queryMessagesWithMessage:(BmobIMMessage *)message  limit:(int)limit;




/**
 *  删除某人的信息
 *
 *  @param del    是否会话列表的内容也要清空
 *  @param time   更新时间
 */
-(void)deleteMessageWithdeleteMessageListOrNot:(BOOL)del
                                    updateTime:(uint64_t)time;
/**
 *  更新本地的这条记录和将这个会话下的消息设置为已读
 */
-(void)updateLocalCache;



@end

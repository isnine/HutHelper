//
//  BIMMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/12.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BmobIMConfig.h"
#import "BmobIMStatusDefine.h"



@interface BmobIMMessage : NSObject <NSCopying>

/**
 *  是否保存在本地时定义的key
 */
extern NSString* const KEY_IS_TRANSIENT;

/**
 *  文件类型的信息放在这里，图片@{KEY_METADATA:@{KEY_HEIGHT:@(h),KEY_WIDTH:@(w)}} 声音@{KEY_METADATA:@{KEY_DURATION:@(t)}}
 */
extern NSString* const KEY_METADATA ;

/**
 *  时长
 */
extern NSString* const KEY_DURATION ;

extern NSString* const KEY_LATITUDE ;

extern NSString* const KEY_LONGITUDE;

/**
 *  宽度
 */
extern NSString* const KEY_WIDTH    ;

/**
 *  高度
 */
extern NSString* const KEY_HEIGHT   ;
/**
 *  消息来源者
 */
@property (copy, nonatomic  ) NSString        *fromId;

/**
 *  消息接收者
 */
@property (copy, nonatomic  ) NSString        *toId;

/**
 *  消息内容
 */
@property (copy, nonatomic  ) NSString        *content;


/**
 *  消息类型
 */
@property (copy, nonatomic  ) NSString        *msgType;

/**
 *   精确到毫秒
 */
@property (assign, nonatomic) uint64_t        createdTime;


/**
 *   精确到毫秒
 */
@property (assign, nonatomic) uint64_t        updatedTime;


/**
 *  会话Id
 */
@property (strong, nonatomic) NSString        *conversationId;

/**
 *  传递额外的信息,如果不需要保存消息到本地，请在额外信息传入@{KEY_IS_TRANSIENT:@(YES)....}
 */
@property (strong, nonatomic) NSDictionary    *extra;

/**
 *  是否已读
 */
@property (assign, nonatomic) BmobIMReceivedStatus        receiveStatus;

/**
 *  消息的状态，是否已发送等
 */
@property (assign, nonatomic) BmobIMSendStatus            sendStatus;

/**
 *  消息是单聊还是群聊
 */
@property (assign, nonatomic) BmobIMConversationType      conversationType;


@end

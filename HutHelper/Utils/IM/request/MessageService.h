//
//  MessageService.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "SysMessage.h"
#import <BmobIMSDK/BmobIMSDK.h>


typedef void(^uploadBlock)(id resule ,NSError *error);

@interface MessageService : NSObject

/**
 *  查找某个用户的通知信息
 *
 *  @param date  当前时间
 *  @param block 信息数组
 */
+(void)inviteMessages:(NSDate *)date completion:(BmobObjectArrayResultBlock)block;


/**
 *  发送图片
 *
 *  @param image
 *  @param block         上传的结果
 *  @param progressBlock 上传进度
 *
 *  @return 
 */
+(void)uploadImage:(UIImage *)image
        completion:(uploadBlock)block
          progress:(BmobProgressBlock)progressBlock;

/**
 *  发送语音
 *
 *  @param data          amr数据
 *  @param duration      时长
 *  @param block         上传的结果
 *  @param progressBlock 上传进度
 *
 *  @return
 */
+(void)uploadAudio:(NSData *)data
                          duration:(CGFloat)duration
                        completion:(uploadBlock)block
                          progress:(BmobProgressBlock)progressBlock;
@end

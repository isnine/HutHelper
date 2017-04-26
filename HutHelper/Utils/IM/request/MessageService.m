//
//  MessageService.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "MessageService.h"
#import "CommonUtil.h"


@implementation MessageService








/**
 *  查找某个用户的通知信息
 *
 *  @param date  当前时间
 *  @param block 信息数组
 */
+(void)inviteMessages:(NSDate *)date completion:(BmobObjectArrayResultBlock)block{
    BmobQuery *query = [BmobQuery queryWithClassName:kInviteMessageTable];
    [query whereKey:@"toUser" equalTo:[BmobUser getCurrentUser]];
//    [query whereKey:@"type" equalTo:[NSNumber numberWithInteger:SystemMessageContactAdd]];
    [query includeKey:@"fromUser,toUser"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            if (block) {
                block(nil,error);
            }
        }else{
            NSMutableArray *result = [NSMutableArray array];
            for (BmobObject *obj in array) {
                SysMessage *msg = [[SysMessage alloc] initFromBmobObject:obj];
                msg.fromUser = [obj objectForKey:@"fromUser"];
                msg.toUser = [obj objectForKey:@"toUser"];
            
                [result addObject:msg];
            }
            if (block) {
                block(result,nil);
            }
        }
    }];
}


+(void)uploadImage:(UIImage *)image
        completion:(uploadBlock)block
          progress:(BmobProgressBlock)progressBlock
                          {
    BmobFile *file = [[BmobFile alloc] initWithFileName:[NSString stringWithFormat:@"%.0f.png",[[NSDate date] timeIntervalSinceReferenceDate] ] withFileData:UIImagePNGRepresentation(image)];
    
    [file saveInBackgroundByDataSharding:^(BOOL isSuccessful, NSError *error) {
        BmobIMImageMessage *message = nil;
        if (!error) {
          message = [BmobIMImageMessage messageWithUrl:file.url attributes:@{KEY_METADATA:@{KEY_HEIGHT:@(image.size.height),KEY_WIDTH:@(image.size.width)}}];
            message.conversationType = BmobIMConversationTypeSingle;
            message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
            message.updatedTime = message.createdTime;
            
        }
        if (block) {
            block(message,error);
        }
    } progressBlock:^(CGFloat progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }];
    
    
    
    
}


+(void)uploadAudio:(NSData *)data
                          duration:(CGFloat)duration
                        completion:(uploadBlock)block
                          progress:(BmobProgressBlock)progressBlock
                           {
    //保存在本地
    NSString *filename = [NSString stringWithFormat:@"%.0f.amr",[NSDate timeIntervalSinceReferenceDate]];
    NSString *path = [[CommonUtil audioCacheDirectory] stringByAppendingPathComponent:filename];
    [data writeToFile:path options:NSDataWritingAtomic error:nil];
    

    
    BmobFile *file = [[BmobFile alloc] initWithFileName:filename withFileData:data];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
         BmobIMAudioMessage *message = nil;
        if (!error) {
            message = [BmobIMAudioMessage messageWithUrl:file.url attributes:@{KEY_METADATA:@{KEY_DURATION:@(duration)}}];
            message.conversationType = BmobIMConversationTypeSingle;
            message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
            message.updatedTime = message.createdTime;
            message.localPath   = [path stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@""];
        }
        if (block) {
            block(message,error);
        }
    } withProgressBlock:^(CGFloat progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    }];
    
    
}


@end

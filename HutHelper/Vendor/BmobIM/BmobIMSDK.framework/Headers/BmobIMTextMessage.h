//
//  BmobIMTextMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/30.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobIMMessage.h"

@interface BmobIMTextMessage : BmobIMMessage

/**
 *  创建文本消息
 *
 *  @param text       消息文本
 *  @param attributes 用户自定义属性
 *
 *  @return 文本消息
 */
+ (instancetype)messageWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes;

@end

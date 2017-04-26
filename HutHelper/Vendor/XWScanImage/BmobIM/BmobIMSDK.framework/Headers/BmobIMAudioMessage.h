//
//  BmobIMAudioMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/30.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "BmobIMFileMessage.h"

@interface BmobIMAudioMessage : BmobIMFileMessage


@property (readonly, nonatomic) NSTimeInterval duration;

/**
 *  创建音频消息
 *
 *  @param url        音频文件的url
 *  @param attributes 用户自定义的属性
 *
 *  @return 图片信息
 */
+(instancetype)messageWithUrl:(NSString *)url
                   attributes:(NSDictionary *)attributes;

@end

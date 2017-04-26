//
//  BmobIMLocationMessage.h
//  BmobIMSDK
//
//  Created by Bmob on 16/3/8.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "BmobIMMessage.h"

@interface BmobIMLocationMessage : BmobIMMessage

/**
 *  经度
 */
@property (readonly, nonatomic) CGFloat longitude;

/**
 *  纬度
 */
@property (readonly, nonatomic) CGFloat latitude;



/**
 *  创建一个对象
 *
 *  @param address    地址
 *  @param attributes 额外信息 格式@{KEY_METADATA:@{KEY_LONGITUDE:@(x),KEY_LATITUDE:@(y)}}
 *
 *  @return BmobIMLocationMessage 对象
 */
+(instancetype)messageWithAddress:(NSString *)address
                       attributes:(NSDictionary *)attributes;

@end

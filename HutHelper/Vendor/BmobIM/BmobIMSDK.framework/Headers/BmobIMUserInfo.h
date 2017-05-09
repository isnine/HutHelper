//
//  BIMUserInfo.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/16.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BmobIMUserInfo : NSObject

/**
 *  用户的objectId
 */
@property (copy, nonatomic) NSString *userId;

/**
 *  用户名
 */
@property (copy, nonatomic) NSString *name;


/**
 *  头像
 */
@property (copy, nonatomic) NSString *avatar;



/**
 *  生成一个BmobIMUserInfo 对象
 *
 *  @param userId   用户的objectId
 *  @param username 用户名
 *  @param avatar   用户头像
 *
 *  @return 生成一个BmobIMUserInfo 对象
 */
+(instancetype)userInfoWithUserId:(NSString *)userId
                         username:(NSString *)username
                           avatar:(NSString *)avatar;



@end

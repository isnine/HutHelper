//
//  APIRequest.h
//  HutHelper
//
//  Created by Nine on 2017/3/18.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequest : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的基本url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    timeout:(double)time
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
/**
 *  发送post请求
 *
 *  @param URLString  请求的基本url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;
@end

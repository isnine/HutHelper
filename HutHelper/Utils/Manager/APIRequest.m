//
//  APIRequest.m
//  HutHelper
//
//  Created by Nine on 2017/3/18.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "APIRequest.h"
#import "AFNetworking.h"
@implementation APIRequest
#define GET_TIMEOUT 6.f
#define POST_TIMEOUT 10.f
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSLog(@"请求地址:%@",URLString);
    /**设置超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = GET_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:URLString parameters:parameters progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 failure(error);
             }
         }];
}
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = POST_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

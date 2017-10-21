//
//  APIRequest.m
//  HutHelper
//
//  Created by Nine on 2017/3/18.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "APIRequest.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation APIRequest
#define GET_TIMEOUT 8.f
#define POST_TIMEOUT 10.f
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [Config setNoSharedCache];
    [self GET:URLString parameters:parameters timeout:3.f success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters
    timeout:(double)time
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    NSLog(@"请求地址:%@",URLString);
    [Config setNoSharedCache];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = time;
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

+ (void)POST:(NSString *)URLString parameters:(id)parameters
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure
{
    NSLog(@"请求地址:%@",URLString);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = POST_TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

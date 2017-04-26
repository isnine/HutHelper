//
//  CommonUtil.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/4.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+(NSString *)cachePath{
    NSArray *paths       = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath  = [paths objectAtIndex:0];
    return cachePath;
}

+(NSString *)audioCacheDirectory{
    NSString *path = [NSString stringWithFormat:@"%@/Audio",[self cachePath]];
    BOOL idDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&idDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

@end

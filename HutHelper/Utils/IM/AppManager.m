//
//  AppManager.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/26.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager


+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static AppManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[AppManager alloc] init];
    });
    return manager;
}


-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    }
    
    return _dateFormatter;
}

@end

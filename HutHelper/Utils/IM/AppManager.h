//
//  AppManager.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/26.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


+(instancetype)defaultManager;

@end

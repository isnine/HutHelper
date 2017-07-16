//
//  Config+Set.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Set)
+(void)removeUserDefaults:(NSString*)key;
+(void)removeUserDefaults;
+(void)setNoSharedCache;
+ (void)isAppFirstRun;
+(void)pushViewController:(NSString*)controller;
+(NSString*)getCurrentVersion;
@end

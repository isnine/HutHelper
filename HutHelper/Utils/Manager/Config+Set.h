//
//  Config+Set.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Set)
+(void)removeUmeng;
+(void)removeUserDefaults:(NSString*)key;
+(void)removeUserDefaults;
+(void)setNoSharedCache;
+(void)removeBmob;
+(void)pushViewController:(NSString*)controller;

@end

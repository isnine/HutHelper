//
//  Config+Set.m
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//
#import "Config+Set.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "AppDelegate.h"
@implementation Config (Set)
+(void)setNoSharedCache{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

+(void)removeUserDefaults{
    NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
+(void)removeUserDefaults:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+(void)removeBmob{
    if ([BmobUser getCurrentUser]) {
        [BmobUser logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
    }
}
+(void)pushViewController:(NSString*)controller{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:controller];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}
+ (void)isAppFirstRun{
    NSString *currentVersion = Config.getCurrentVersion;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunKey = [defaults objectForKey:@"last_run_version_key"];
    NSLog(@"当前版本%@",currentVersion);
    NSLog(@"上个版本%@",lastRunKey);
    if (lastRunKey==NULL) {
        [Config removeUserDefaults];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        NSLog(@"没有记录");
    }else if ([lastRunKey isEqualToString:@"1.9.9"]||
              [lastRunKey isEqualToString:@"2.0.0"]||
              [lastRunKey isEqualToString:@"2.1.0"]||
              [lastRunKey isEqualToString:@"2.2.0"]||
              [lastRunKey isEqualToString:@"2.3.0"]||
              [lastRunKey isEqualToString:@"2.3.1"]){
        [Config removeUserDefaults:@"ScoreRank"];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        [Config removeUmeng];
        [Config addNotice];
    }else if (![lastRunKey isEqualToString:currentVersion]) {
        [Config removeUserDefaults];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"];
        NSLog(@"记录不匹配");
    }
}
+(NSString*)getCurrentVersion{
   return  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
}

@end

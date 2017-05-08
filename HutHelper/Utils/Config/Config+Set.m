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
+(void)removeUmeng{
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {//删除友盟标签缓存
    }];
    [UMessage removeAlias:[Config getStudentKH] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
    }];
}
/**删除本地数据缓存*/
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
@end

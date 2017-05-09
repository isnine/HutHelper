//
//  BmobIMUserInfo+BmobUser.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/30.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "BmobIMUserInfo+BmobUser.h"

@implementation BmobIMUserInfo (BmobUser)
+(instancetype)userInfoWithBmobUser:(BmobUser *)user{
    BmobIMUserInfo *info  = [[BmobIMUserInfo alloc] init];
    info.userId = user.objectId;
    info.name = user.username;
    info.avatar = [user objectForKey:@"avatar"];
    return info;
}
@end

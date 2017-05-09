//
//  BmobIMUserInfo+BmobUser.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/30.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <BmobIMSDK/BmobIMSDK.h>
#import <BmobSDK/Bmob.h>
@interface BmobIMUserInfo (BmobUser)

+(instancetype)userInfoWithBmobUser:(BmobUser *)user;

@end

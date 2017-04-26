//
//  BmobIMSDK.h
//  BmobIMSDK
//
//  Created by Bmob on 15/12/30.
//  Copyright © 2015年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BmobIMSDK.
//FOUNDATION_EXPORT double BmobIMSDKVersionNumber;

//! Project version string for BmobIMSDK.
//FOUNDATION_EXPORT const unsigned char BmobIMSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BmobIMSDK/PublicHeader.h>

#import <BmobIMSDK/BmobIM.h>
#import <BmobIMSDK/BmobIMConfig.h>
#import <BmobIMSDK/BmobIMUserInfo.h>
#import <BmobIMSDK/BmobIMConversation.h>
#import <BmobIMSDK/BmobIM.h>
#import <BmobIMSDK/BmobIMStatusDefine.h>
#import <BmobIMSDK/BmobIMMessage.h>
#import <BmobIMSDK/BmobIMFileMessage.h>
#import <BmobIMSDK/BmobIMTextMessage.h>
#import <BmobIMSDK/BmobIMImageMessage.h>
#import <BmobIMSDK/BmobIMAudioMessage.h>
#import <BmobIMSDK/BmobIMLocationMessage.h>

UIKIT_STATIC_INLINE NSString* BmobIMVersion()
{
    return @"2.0.2";
}
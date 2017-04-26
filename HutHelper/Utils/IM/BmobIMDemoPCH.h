//
//  BmobIMDemoPCH.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/18.
//  Copyright © 2016年 bmob. All rights reserved.
//

#ifndef BmobIMDemoPCH_h
#define BmobIMDemoPCH_h

#import "UIColor+SubClass.h"

typedef NS_ENUM(int,SystemMessageContact){
    SystemMessageContactAdd = 0,
    SystemMessageContactAgree,
    SystemMessageContactRefuse
};









#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kInviteMessageTable      @"InviteMessage"
#define kFriendTable             @"Friend"
#define kNewMessagesNotifacation @"NewMessagesNotifacation"
#define kNewMessageFromer        @"NewMessageFromer"

#define kDefaultViewBackgroundColor [UIColor colorWithR:241 g:242 b:246]

#endif /* BmobIMDemoPCH_h */


//
//  Header.h
//  BmobIMSDK
//
//  Created by Bmob on 16/1/29.
//  Copyright © 2016年 bmob. All rights reserved.
//

#ifndef Header_h
#define Header_h
typedef NS_ENUM(int,BmobIMReceivedStatus) {
    BmobIMReceivedStatus_UNREAD = 0,    //未读
    BmobIMReceivedStatus_READED = 1,    //已读
    BmobIMReceivedStatus_DOWNLOADED     //已下载
    
};

typedef NS_ENUM(int,BmobIMSendStatus){
    BmobIMSendStatus_SENDING = 0,   //发送中
    BmobIMSendStatus_FAILED,        //发送失败
    BmobIMSendStatus_SENT           //发送成功
};




typedef NS_ENUM(int,BmobIMConversationType) {
    BmobIMConversationTypeSingle = 1,    //单聊
    BmobIMConversationTypeGroup          //群聊
};

#define kMessageTypeText     @"txt"
#define kMessageTypeImage    @"image"
#define kMessageTypeSound    @"sound"
#define kMessageTypeLocation @"location"



#endif /* Header_h */

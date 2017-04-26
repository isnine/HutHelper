//
//  BmobIMMessage+SubClass.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/8.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "BmobIMMessage+SubClass.h"

@implementation BmobIMMessage (SubClass)

-(instancetype)initWithMessage:(BmobIMMessage *)message;{
    self = [self init];
    if (self) {
        self.fromId         = message.fromId;
        self.toId           = message.toId;
        self.content        = message.content;
        self.msgType        = message.msgType;
        self.createdTime    = message.createdTime;
        self.updatedTime    = message.updatedTime;
        self.conversationId = message.conversationId;
        self.extra          = message.extra;
        self.receiveStatus  = message.receiveStatus;
        self.sendStatus     = message.sendStatus;
    }
    return self;
    
}

@end

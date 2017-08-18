//
//  ChatUser.m
//  HutHelper
//
//  Created by nine on 2017/8/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ChatUser.h"

@implementation ChatUser
-(instancetype)initWithDic:(NSDictionary*)Dic{
    self = [super init];
    if (self) {
        self.TrueName=Dic[@"TrueName"];
        self.class_name=Dic[@"class_name"];
        self.dep_name=Dic[@"dep_name"];
        self.head_pic=Dic[@"head_pic"];
        self.head_pic_thumb=Dic[@"head_pic_thumb"];
        self.last_use=Dic[@"last_use"];
        self.user_id=Dic[@"id"];
        self.sex=Dic[@"sex"];
    }
    return self;
}
@end

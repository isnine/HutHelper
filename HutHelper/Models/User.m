//
//  User.m
//  HutHelper
//
//  Created by nine on 2017/1/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "User.h"
#import "YYModel.h"
@implementation User

-(instancetype)initWithDic:(NSDictionary*)Dic{
    self = [super init];
    if (self) {
        self.TrueName=Dic[@"Dic"];
        self.address=Dic[@"address"];
        self.class_name=Dic[@"class_name"];
        self.dep_name=Dic[@"dep_name"];
        self.head_pic=Dic[@"head_pic"];
        self.head_pic_thumb=Dic[@"head_pic_thumb"];
        self.last_login=Dic[@"last_login"];
        self.studentKH=Dic[@"studentKH"];
        self.username=Dic[@"username"];
        self.user_id=Dic[@"user_id"];
    }
    return self;
}
@end

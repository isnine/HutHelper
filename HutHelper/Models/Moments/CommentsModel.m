//
//  CommentsModel.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        self.comment=dic[@"comment"];
        self.created_on=[dic[@"created_on"]substringWithRange:NSMakeRange(5,11)];
        self.comment_id=dic[@"id"];
        self.user_id=dic[@"user_id"];
        self.username=dic[@"username"];
    }
    return self;
}
@end

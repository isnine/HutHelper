//
//  MomentsModel.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsModel.h"
#import "CommentsModel.h"
@implementation MomentsModel
-(NSMutableArray *)commentsModelArray{
    if (!_commentsModelArray) {
        _commentsModelArray = [NSMutableArray array];
    }
    return _commentsModelArray;
}

-(NSMutableArray *)head_pic_thumb{
    if (!_head_pic_thumb) {
        _head_pic_thumb = [NSMutableArray array];
    }
    return _head_pic_thumb;
}

-(NSMutableArray *)head_pic{
    if (!_head_pic) {
        _head_pic = [NSMutableArray array];
    }
    return _head_pic;
}

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.content                = dic[@"content"];
        self.created_on         = dic[@"created_on"];
        self.likes            = dic[@"likes"];
        self.moments_id            = dic[@"id"];
        self.head_pic_thumb       = dic[@"head_pic_thumb"];
        self.head_pic             = dic[@"head_pic"];
        self.username              = dic[@"username"];
        self.user_id   = dic[@"user_id"];
        self.dep_name     = dic[@"dep_name"];
        
        for (NSDictionary *eachDic in dic[@"comments"] ) {
            CommentsModel *commentsModel = [[CommentsModel alloc] initWithDic:eachDic];
            [self.commentsModelArray addObject:commentsModel];
        }
    }
    return self;
}
@end

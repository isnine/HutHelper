//
//  MomentsModel.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsModel.h"
#import "CommentsModel.h"
#import "UILabel+LXAdd.h"
 
@implementation MomentsModel{
    UILabel *contentLabel;
}
-(NSMutableArray *)commentsModelArray{
    if (!_commentsModelArray) {
        _commentsModelArray = [NSMutableArray array];
    }
    return _commentsModelArray;
}


-(NSMutableArray *)pics{
    if (!_pics) {
        _pics = [NSMutableArray array];
    }
    return _pics;
}

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.content                = dic[@"content"];
        self.created_on         = dic[@"created_on"];
        self.likes            = dic[@"likes"];
        self.moments_id            = dic[@"id"];
        self.head_pic_thumb       = dic[@"head_pic_thumb"];
        self.head_pic       = dic[@"head_pic"];
        self.pics             = dic[@"pics"];
        self.username              = dic[@"username"];
        self.user_id   = dic[@"user_id"];
        self.dep_name     = dic[@"dep_name"];
        /**计算文本高度并加入*/
        contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines=0;
        contentLabel.font=[UIFont systemFontOfSize:15];
        contentLabel.text=self.content;
        self.textHeight=[contentLabel getLableSizeWithMaxWidth:SYReal(380)].height;
        self.textWidth=[contentLabel getLableSizeWithMaxWidth:SYReal(380)].width;
        /**计算图片高度并加入*/
        if (self.pics.count==1||self.pics.count==2) {
            self.photoHeight=SYReal(150);
        }else if (self.pics.count==3||self.pics.count==4){
            self.photoHeight=SYReal(300);
        }else{
            self.photoHeight=0.0;
        }
        self.commentsHeight=0.0;
        for (NSDictionary *eachDic in dic[@"comments"] ) {
            CommentsModel *commentsModel = [[CommentsModel alloc] initWithDic:eachDic];
            contentLabel = [[UILabel alloc] init];
            contentLabel.numberOfLines=0;
            contentLabel.font=[UIFont systemFontOfSize:13];
            contentLabel.text=commentsModel.comment;
            commentsModel.commentsHeight=[contentLabel getLableSizeWithMaxWidth:SYReal(COMMENTS_WEIGHT)].height;
            commentsModel.commentsWidth=[contentLabel getLableSizeWithMaxWidth:SYReal(COMMENTS_WEIGHT)].width;
            self.commentsHeight+=commentsModel.commentsHeight;
            self.commentsHeight+=SYReal(28);
            [self.commentsModelArray addObject:commentsModel];
        }
    }
    return self;
}
@end

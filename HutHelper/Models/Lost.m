//
//  Lost.m
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Lost.h"
#import "UILabel+LXAdd.h"

@implementation Lost{
    UILabel *contentLabel;
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.content       = dic[@"content"];
        self.tit         = dic[@"tit"];
        self.created_on            = dic[@"created_on"];
        self.time            = dic[@"time"];
        self.locate            = dic[@"locate"];
        self.phone       = dic[@"phone"];
        self.username              = dic[@"username"];
        self.user_id   = dic[@"user_id"];
        self.id   = dic[@"id"];
         self.pics             = dic[@"pics"];
        self.dep_name   = dic[@"dep_name"];
        self.head_pic             = dic[@"head_pic"];
        self.blackColor=arc4random() % 4;
        /**计算图片高度并加入*/
        if (self.pics.count==1||self.pics.count==2) {
            self.photoHeight=SYReal(75);
        }else if (self.pics.count==3||self.pics.count==4){
            self.photoHeight=SYReal(160);
        }else{
            self.photoHeight=0;
        }
        /**计算文本高度并加入*/
        contentLabel = [[UILabel alloc] init];
        contentLabel.numberOfLines=0;
        contentLabel.font=[UIFont systemFontOfSize:15];
        contentLabel.text=self.content;
        self.textHeight=[contentLabel getLableSizeWithMaxWidth:SYReal(175)].height;
        self.textWidth=[contentLabel getLableSizeWithMaxWidth:SYReal(175)].width;
    }
     return self;
}

@end

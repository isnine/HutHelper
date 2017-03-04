//
//  MomentsModel.h
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MomentsModel : NSObject
///说说的内容
@property(nonatomic,copy)NSString *content;
///发布说说的时间
@property(nonatomic,copy)NSString *created_on;
///说说的赞数
@property(nonatomic,copy)NSString *likes;
///说说的id
@property(nonatomic,copy)NSString *moments_id;
///说说的小图
@property(nonatomic,copy)NSMutableArray *head_pic_thumb;
///说说的大图
@property(nonatomic,copy)NSMutableArray *head_pic;
///说说的评论相关的所有信息
@property(nonatomic,copy)NSMutableArray *commentsModelArray;
///发布说说的user昵称
@property(nonatomic,copy)NSString *username;
///发布说说的user_id
@property(nonatomic,copy)NSString *user_id;
///发布说说的user学院
@property(nonatomic,copy)NSString *dep_name;
///文本高度
@property(nonatomic,assign)double textHeight;
///文本高度
@property(nonatomic,assign)double textWidth;
///照片高度
@property(nonatomic,assign)double photoCGSize;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end

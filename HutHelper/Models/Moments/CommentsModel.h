//
//  CommentsModel.h
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CommentsModel : NSObject
///评论内容
@property(nonatomic,copy)NSString *comment;
///发布时间
@property(nonatomic,copy)NSString *created_on;
///评论id
@property(nonatomic,copy)NSString *comment_id;
///评论者id
@property(nonatomic,copy)NSString *user_id;
///评论者昵称
@property(nonatomic,copy)NSString *username;
///评论高度
@property(nonatomic,assign)double commentsHeight;
///评论宽度
@property(nonatomic,assign)double commentsWidth;
-(instancetype)initWithDic:(NSDictionary *)dic;

@end

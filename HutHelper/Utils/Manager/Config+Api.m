//
//  Config+Api.m
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config+Api.h"

@implementation Config (Api)
#pragma mark - 课表查询
+(NSString*)getApiClass{
    return @"http://218.75.197.121:8888/api/v1/get/lessons";
}
+(NSString*)getApiClassXP{
    return @"http://218.75.197.121:8888/api/v1/get/lessonsexp";
}
#pragma mark - 考试查询
+(NSString*)getApiExam{
    return @"http://218.75.197.122:84/api/exam";
}
#pragma mark - 成绩查询
+(NSString*)getApiScores{
    return @"http://218.75.197.121:8888/api/v1/get/scores";
}
+(NSString*)getApiRank{
    return @"http://218.75.197.121:8888/api/v1/get/ranking";
}
#pragma mark - 登录界面
+(NSString*)getApiLogin{
    return @"http://218.75.197.121:8888/api/v1/get/login";
}
+(NSString*)getApiLoginReset{
    return @"http://218.75.197.121:8888/auth/resetPass";
}
#pragma mark - 用户界面
+(NSString*)getApiProfileUser{
    return @"http://218.75.197.121:8888/api/v1/set/profile";
}
+(NSString*)getApiProfileAvatar{
    return @"http://218.75.197.121:8888/api/v1/set/avatar";
}
#pragma mark - 网上作业
+(NSString*)getApiHomeWork{
    return @"http://218.75.197.121:8888/api/v1/get/myhomework";
}
#pragma mark - 电费查询
+(NSString*)getApiPower{
    return @"http://218.75.197.121:8888/api/v1/get/power";
}
#pragma mark - 二手市场
+(NSString*)getApiGoods{
    return @"http://218.75.197.121:8888/api/v1/stuff/goods";
}
+(NSString*)getApiGoodsUser{
    return @"http://218.75.197.121:8888/api/v1/stuff/own1";
}
+(NSString*)getApiGoodsCreate{
    return @"http://218.75.197.121:8888/api/v1/stuff/create";
}
+(NSString*)getApiGoodsImgUpload{
    return @"http://218.75.197.121:8888/api/v1/stuff/upload";
}
+(NSString*)getApiGoodsShow{
    return @"http://218.75.197.121:8888/api/v1/stuff/detail";
}
#pragma mark - 失物招领
+(NSString*)getApiLost{
    return @"http://218.75.197.121:8888/api/v1/loses/posts";
}
+(NSString*)getApiLostUser{
    return @"http://218.75.197.121:8888/api/v1/loses/posts/page";
}
+(NSString*)getApiLostCreate{
    return @"http://218.75.197.121:8888/api/v1/loses/create";
}
+(NSString*)getApiLostImgUpload{
    return @"http://218.75.197.121:8888/api/v1/loses/upload";
}
#pragma mark - 校园说说
+(NSString*)getApiMoments{
    return @"http://218.75.197.121:8888/api/v1/moments/posts";
}
+(NSString*)getApiMomentsUser{
    return @"http://218.75.197.121:8888/api/v1/moments/posts/page";
}
+(NSString*)getApiMomentsCreate{
    return @"http://218.75.197.121:8888/api/v1/moments/create";
}
+(NSString*)getApiMomentsImgUpload{
    return @"http://218.75.197.121:8888/api/v1/moments/upload";
}
+(NSString*)getApiMomentsDelete{
    return @"http://218.75.197.121:8888/api/v1/moments/delete";
}
+(NSString*)getApiMomentsCommentDelete{
    return @"http://218.75.197.121:8888/api/v1/moments/deletec";
}
+(NSString*)getApiMomentsCreateComment{
    return @"http://218.75.197.121:8888/api/v1/moments/comment";
}
+(NSString*)getApiMomentsLikesCreate{
    return @"http://218.75.197.121:8888/api/v1/moments/like";
}
+(NSString*)getApiMomentsLikesShow{
    return @"http://218.75.197.121:8888/api/v1/moments/like";
}
#pragma mark - 视频专栏
+(NSString*)getApiVedioShow{
    return @"http://vedio.wxz.name/api/vedio.html";
}
#pragma mark - 反馈
+(NSString*)getApiFeedback{
    return @"http://218.75.197.121:8888/home/msg/0";
}
#pragma mark - 其他
+(NSString*)getApiImg{
    return @"http://218.75.197.121:8888";
}
+(NSString*)getApiIndex{
    return @"http://218.75.197.121:8888/";
}
@end

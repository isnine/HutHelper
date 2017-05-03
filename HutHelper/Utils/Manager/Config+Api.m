//
//  Config+Api.m
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config+Api.h"

@implementation Config (Api)
+(NSString*)getApiClass{
    return @"http://218.75.197.121:8888/api/v1/get/lessons";
}
+(NSString*)getApiClassXP{
    return @"http://218.75.197.121:8888/api/v1/get/lessonsexp";
}
+(NSString*)getApiExam{
    return @"http://218.75.197.122:84/api/exam";
}
+(NSString*)getApiScores{
    return @"http://218.75.197.121:8888/api/v1/get/scores";
}
+(NSString*)getApiRank{
    return @"http://218.75.197.121:8888/api/v1/get/ranking";
}
+(NSString*)getApiLogin{
    return @"http://218.75.197.121:8888/api/v1/get/login";
}
+(NSString*)getApiLoginReset{
    return @"http://218.75.197.121:8888/auth/resetPass";
}
+(NSString*)getApiProfileUser{
    return @"http://218.75.197.121:8888/api/v1/set/profile";
}
+(NSString*)getApiProfileAvatar{
    return @"http://218.75.197.121:8888/api/v1/set/avatar";
}
+(NSString*)getApiHomeWork{
    return @"http://218.75.197.121:8888/api/v1/get/myhomework";
}
+(NSString*)getApiPower{
    return @"http://218.75.197.121:8888/api/v1/get/power";
}
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

+(NSString*)getApiVedioShow{
    return @"http://vedio.wxz.name/api/vedio.html";
}
+(NSString*)getApiFeedback{
    return @"http://218.75.197.121:8888/home/msg/0";
}
+(NSString*)getApiImg{
    return @"http://218.75.197.121:8888";
}
@end

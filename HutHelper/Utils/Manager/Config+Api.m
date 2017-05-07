//
//  Config+Api.m
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config+Api.h"
#include <stdio.h>
#include <time.h>
#import<CommonCrypto/CommonDigest.h>
@implementation NSString (MMD5)
- (id)MMD5
{
    const char *cStr           = [self UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    // This is the md5 call
    NSMutableString *output    = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i                  = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end

@implementation Config (Api)
#pragma mark - 课表查询
+(NSString*)getApiClass{
    return [NSString stringWithFormat:@"%@/api/v1/get/lessons/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiClassXP{
    return [NSString stringWithFormat:@"%@/api/v1/get/lessonsexp/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 考试查询
+(NSString*)getApiExam{
    NSString *ss=[Config.getStudentKH stringByAppendingString:@"apiforapp!"];
    ss=[ss MMD5];
    return [NSString stringWithFormat:@"http://218.75.197.122:84/api/exam/%@/key/%@",Config.getStudentKH,ss];
}
#pragma mark - 成绩查询
+(NSString*)getApiScores{
    NSString *shaString=[Math sha1:[NSString stringWithFormat:@"%@%@%@",Config.getStudentKH,Config.getRememberCodeApp,@"f$Z@%"]];
    return [NSString stringWithFormat:@"%@/api/v1/get/scores/%@/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp,shaString];
}
+(NSString*)getApiRank{
    return [NSString stringWithFormat:@"%@/api/v1/get/ranking/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 登录界面
+(NSString*)getApiLogin{
    return [NSString stringWithFormat:@"%@/api/v1/get/login",Config.apiIndex];
}
+(NSString*)getApiLoginReset{
    return [NSString stringWithFormat:@"%@/auth/resetPass",Config.apiIndex];
}
#pragma mark - 用户界面
+(NSString*)getApiProfileUser{
    return [NSString stringWithFormat:@"%@/api/v1/set/profile/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiProfileAvatar{
    return [NSString stringWithFormat:@"%@/api/v1/set/avatar/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 网上作业
+(NSString*)getApiHomeWork{
    return [NSString stringWithFormat:@"%@/api/v1/get/myhomework/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 电费查询
+(NSString*)getApiPower{
    return [NSString stringWithFormat:@"%@/api/v1/get/power",Config.apiIndex];
}
#pragma mark - 二手市场
+(NSString*)getApiGoods{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/goods",Config.apiIndex];
}
+(NSString*)getApiGoodsUser{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/own1/%@/%@/1",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiGoodsCreate{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiGoodsImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/upload",Config.apiIndex];
}
+(NSString*)getApiGoodsShow{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/detail",Config.apiIndex];
}
#pragma mark - 失物招领
+(NSString*)getApiLost{
    return [NSString stringWithFormat:@"%@/api/v1/loses/posts",Config.apiIndex];
}
+(NSString*)getApiLostUser{
    return [NSString stringWithFormat:@"%@/api/v1/loses/posts/page/%@",Config.apiIndex,Config.getUserId];
}
+(NSString*)getApiLostCreate{
    return [NSString stringWithFormat:@"%@/api/v1/loses/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiLostImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/loses/upload",Config.apiIndex];
}
#pragma mark - 校园说说
+(NSString*)getApiMoments{
    return [NSString stringWithFormat:@"%@/api/v1/moments/posts",Config.apiIndex];
}
+(NSString*)getApiMomentsUser{
    return [NSString stringWithFormat:@"%@/api/v1/moments/posts/page",Config.apiIndex];
}
+(NSString*)getApiMomentsCreate{
    return [NSString stringWithFormat:@"%@/api/v1/moments/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiMomentsImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/moments/upload",Config.apiIndex];
}
+(NSString*)getApiMomentsDelete{
    return [NSString stringWithFormat:@"%@/api/v1/moments/delete",Config.apiIndex];
}
+(NSString*)getApiMomentsCommentDelete{
    return [NSString stringWithFormat:@"%@/api/v1/moments/deletec",Config.apiIndex];
}
+(NSString*)getApiMomentsCreateComment{
    return [NSString stringWithFormat:@"%@/api/v1/moments/comment",Config.apiIndex];
}
+(NSString*)getApiMomentsLikesCreate{
    return [NSString stringWithFormat:@"%@/api/v1/moments/like",Config.apiIndex];
}
+(NSString*)getApiMomentsLikesShow{
    return [NSString stringWithFormat:@"%@/api/v1/moments/like/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}

#pragma mark - 反馈
+(NSString*)getApiFeedback{
    return [NSString stringWithFormat:@"%@/home/msg/0",Config.apiIndex];
}
#pragma mark - 其他
+(NSString*)getApiImg{
    return [NSString stringWithFormat:@"%@",Config.apiIndex];
}
#pragma mark - 视频专栏
+(NSString*)getApiVedioShow{
    return @"http://vedio.wxz.name/api/vedio.html";
}
+(NSString*)apiIndex{
    return @"http://www.hugongda.com:8888";
}
@end

//
//  Config+Api.m
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config+Api.h"
#import "NSString+Common.h"

@implementation Config (Api)
#pragma mark - 课表查询
+(NSString*)getApiClass{
    return [NSString stringWithFormat:@"%@/api/v1/get/lessons/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiClassXP{
    //    return [NSString stringWithFormat:@"%@/api/v1/get/lessonsexp/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
    return [NSString stringWithFormat:@"%@/api/v3/Home/lessonsExp/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 考试查询
+(NSString*)getApiExam{
    return [NSString stringWithFormat:@"http://218.75.197.122:84/api/exam/%@/key/%@",Config.getStudentKH,[[Config.getStudentKH stringByAppendingString:@"apiforapp!"] md5Str]];
}
#pragma mark - 成绩查询
+(NSString*)getApiScores{
//    return [NSString stringWithFormat:@"%@/api/v1/get/scores/%@/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp,[[NSString stringWithFormat:@"%@%@%@",Config.getStudentKH,Config.getRememberCodeApp,@"f$Z@%"] sha1Str]];
    return [NSString stringWithFormat:@"%@/api/v3/Home/scores/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiRank{
  //  return [NSString stringWithFormat:@"%@/api/v1/get/ranking/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
    return [NSString stringWithFormat:@"%@/api/v3/Home/ranking/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 登录界面
+(NSString*)getApiLogin:(NSString*)userName passWord:(NSString*)passWord{
    return [NSString stringWithFormat:@"%@/api/v1/get/login/%@/%@/1",Config.apiIndex,userName,passWord];
}
+(NSString*)getApiLoginReset{
    return [NSString stringWithFormat:@"%@/auth/resetPass",Config.apiIndex];
}
#pragma mark - 用户界面
+(NSString*)getApiProfileUser{
    return [NSString stringWithFormat:@"%@/api/v1/set/profile/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiProfileAvatar{
    return [NSString stringWithFormat:@"%@/api/v1/set/avatar/%@/%@",Config.getApiImg,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 网上作业
+(NSString*)getApiHomeWork{
    //return [NSString stringWithFormat:@"%@/api/v1/get/myhomework/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
    return [NSString stringWithFormat:@"%@/api/v3/Home/myHomeWork/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 电费查询
+(NSString*)getApiPower:(NSString*)build room:(NSString*)room{
    return [NSString stringWithFormat:@"%@/api/v1/get/power/%@/%@",Config.apiIndex,build,room];
}
+(NSString*)getApiPowerAirCondition{
    return [NSString stringWithFormat:@"%@/api/v1/set/schema/%@/%@/1",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiPowerAirConditionCreate:(int)opt{
    return [NSString stringWithFormat:@"%@/api/v1/set/schema/%@/%@/1/%d",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp,opt];
}
#pragma mark - 二手市场
+(NSString*)getApiGoods:(int)num{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/goods/%d",Config.apiIndex,num];
}
+(NSString*)getApiOtherGoods:(int)num withId:(NSString*)user_id{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/goods/%d/%@",Config.apiIndex,num,user_id];
}
+(NSString*)getApiGoodsUser{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/own1/%@/%@/1",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}

+(NSString*)getApiGoodsCreate{
    return [NSString stringWithFormat:@"%@/api/v2/trade/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiGoodsImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/upload",Config.getApiImg];
}
+(NSString*)getApiGoodsShow{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/detail",Config.apiIndex];
}
+(NSString*)getApiGoodsDelect:(NSString*)goodID{
    return [NSString stringWithFormat:@"%@/api/v1/stuff/delete/%@/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp,goodID];
}
#pragma mark - 失物招领
+(NSString*)getApiLost:(int)num{
    return [NSString stringWithFormat:@"%@/api/v1/loses/posts/%d",Config.apiIndex,num];
}
+(NSString*)getApiLostUser{
    return [NSString stringWithFormat:@"%@/api/v1/loses/posts/page/%@",Config.apiIndex,Config.getUserId];
}
+(NSString*)getApiLostUserOther:(NSString*)user_id{
    return [NSString stringWithFormat:@"%@/api/v1/loses/posts/page/%@",Config.apiIndex,user_id];
}
+(NSString*)getApiLostCreate{
    return [NSString stringWithFormat:@"%@/api/v1/loses/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiLostImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/loses/upload",Config.getApiImg];
}
#pragma mark - 校园说说
+(NSString*)getApiMoments:(int)num{
    return [NSString stringWithFormat:@"%@/api/v1/moments/posts/%d",Config.apiIndex,num];
}
+(NSString*)getApiMomentsUser{
    return [NSString stringWithFormat:@"%@/api/v1/moments/posts/page",Config.apiIndex];
}
+(NSString*)getApiMomentsCreate{
    return [NSString stringWithFormat:@"%@/api/v1/moments/create/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
+(NSString*)getApiMomentsImgUpload{
    return [NSString stringWithFormat:@"%@/api/v1/moments/upload",Config.getApiImg];
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
+(NSString*)getApiMomentsLikesCreate:(NSString*)momentsID{
    return [NSString stringWithFormat:@"%@/api/v1/moments/like/%@/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp,momentsID];
}

+(NSString*)getApiMomentsLikesShow{
    return [NSString stringWithFormat:@"%@/api/v1/moments/like/%@/%@",Config.apiIndex,Config.getStudentKH,Config.getRememberCodeApp];
}
#pragma mark - 反馈
+(NSString*)getApiFeedback{
    return [NSString stringWithFormat:@"%@/home/msg/0",Config.apiIndex];
}
#pragma mark - 图书馆
+(NSString*)getApiLibrary{
    return @"http://218.75.197.121:8889/opac/m/index";
}
#pragma mark - 其他

+(NSString*)getApiCalendar{
    return [NSString stringWithFormat:@"%@/api/v1/get/calendar",Config.apiIndex];
}
+(NSString*)getApiVersioniOS{
    return [NSString stringWithFormat:@"%@/api/v1/get/versionIos/%@/%@",Config.apiIndex,Config.getStudentKH,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}
#pragma mark - 视频专栏
+(NSString*)getApiVedioShow{
    return @"http://vedio.wxz.name/api/vedio.html";
}

#pragma mark - 私信
+(NSString*)getApiImToken{
    return [NSString stringWithFormat:@"%@/api/v1/im/getToken",Config.apiIndexHttps];
}

+(NSString*)getApiImUserInfo:(NSString*)User_id{
    return [NSString stringWithFormat:@"%@/api/v2/im/get_studentinfo/%@",Config.apiIndex,User_id];
}

+(NSString*)getApiImStudent{
    return [NSString stringWithFormat:@"%@/api/v2/Im/get_students",Config.apiIndex];
}

#pragma mark - 全局
+(NSString*)getApiImg{
    return @"http://images.tutuweb.cn:8888";
}//images.tutuweb.cn

+(NSString*)apiIndex{
    return @"https://api.tutuweb.cn";
   // return @"https://hut.wxz.name";
}//api.tutuweb.cn

+(NSString*)apiIndexHttps{
    return @"https://hut.wxz.name";
}
@end

//
//  Config+Api.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Api)

#define RONGCLOUD_APPKEY @""
#define APPKEY_UMESSAGE @""
#define APPKEY_QQ_SECRET @""
#define APPKEY_SINA_SECRET @""
#define APPKEY_WECHAT_SECRET @""
#define APPKEY_BMOB @""
#define APPKEY_JSPATCH @""
#define APPSTORE_ID 1164848835
#define RSA_JSPATCH @""

+(NSString*)getApiVedioShow;
+(NSString*)getApiClass;
+(NSString*)getApiClassXP;
+(NSString*)getApiExam;
+(NSString*)getApiScores;
+(NSString*)getApiRank;
+(NSString*)getApiLogin:(NSString*)userName passWord:(NSString*)passWord;
+(NSString*)getApiLoginReset;
+(NSString*)getApiProfileUser;
+(NSString*)getApiProfileAvatar;
+(NSString*)getApiHomeWork;
+(NSString*)getApiPower:(NSString*)build room:(NSString*)room;
+(NSString*)getApiPowerAirCondition;
+(NSString*)getApiPowerAirConditionCreate:(int)opt;

+(NSString*)getApiGoods:(int)num;
+(NSString*)getApiOtherGoods:(int)num withId:(NSString*)user_id;
+(NSString*)getApiGoodsUser;
+(NSString*)getApiGoodsCreate;
+(NSString*)getApiGoodsImgUpload;
+(NSString*)getApiGoodsShow;
+(NSString*)getApiGoodsDelect:(NSString*)goodID;
+(NSString*)getApiUserIsTrue;

+(NSString*)getApiLost:(int)num;
+(NSString*)getApiLostUserOther:(NSString*)user_id;
+(NSString*)getApiLostUser;
+(NSString*)getApiLostCreate;
+(NSString*)getApiLostImgUpload;
+(NSString*)getApiLostDelect:(NSString*)lostID;

+(NSString*)getApiMoments:(int)num;
+(NSString*)getApiMomentsUser;
+(NSString*)getApiMomentsCreate;
+(NSString*)getApiMomentsImgUpload;
+(NSString*)getApiMomentsDelete;
+(NSString*)getApiMomentsCommentDelete;
+(NSString*)getApiMomentsCreateComment;
+(NSString*)getApiMomentsLikesCreate:(NSString*)momentsID;
+(NSString*)getApiMomentsLikesShow;


+(NSString*)getApiFeedback;
+(NSString*)getApiLibrary;
+(NSString*)getApiImg;

+(NSString*)getApiImToken;
+(NSString*)getApiImUserInfo:(NSString*)User_id;
+(NSString*)getApiImStudent;

+(NSString*)getApiVersioniOS;
+(NSString*)getApiWeather;
+(NSString*)getApiCalendar;
+(NSString*)apiIndex;
@end


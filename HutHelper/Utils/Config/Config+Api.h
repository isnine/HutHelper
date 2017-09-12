//
//  Config+Api.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Api)

#define RONGCLOUD_APPKEY @"x4vkb1qpx05kk"
#define APPKEY_UMESSAGE @"57fe13d867e58e0e59000ca1"
#define APPKEY_QQ_SECRET @"y7n6BRLtnH9mrFT3"
#define APPKEY_SINA_SECRET @"ba2997aaab6a1602406fc94247dc072d"
#define APPKEY_WECHAT_SECRET @"8bb26c6a577e61f0bbee160dde7e79af"
#define APPKEY_BMOB @"bb96c4df7fd649cc2eec6357242f9cc4"
#define APPKEY_JSPATCH @"bd9208bd34ab8197"
#define APPSTORE_ID 1164848835
#define RSA_JSPATCH @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCi/XcpS7/lnAf0YEta273pubUy\niZGGy+xNOL2cV4XLpV0OmhCWunAdBuFSV7nn2HWcZWsTuRMt1gFUbO5gtFw6m2JH\niGvfK2YlQvRo91lGsbczad3SCe738lq6MiYNjyaoiCAW9U9+WxvX8DVUxzNhrlba\nwH1UzhSy5A8zWi8bMwIDAQAB\n-----END PUBLIC KEY-----"

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

+(NSString*)getApiLost:(int)num;
+(NSString*)getApiLostUserOther:(NSString*)user_id;
+(NSString*)getApiLostUser;
+(NSString*)getApiLostCreate;
+(NSString*)getApiLostImgUpload;

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

+(NSString*)getApiCalendar;
+(NSString*)apiIndex;
@end

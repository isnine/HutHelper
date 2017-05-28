//
//  Config+Api.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Api)
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

+(NSString*)getApiGoods;
+(NSString*)getApiGoodsUser;
+(NSString*)getApiGoodsCreate;
+(NSString*)getApiGoodsImgUpload;
+(NSString*)getApiGoodsShow;

+(NSString*)getApiLost:(int)num;
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

+(NSString*)apiIndex;
@end

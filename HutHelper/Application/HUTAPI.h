//
//  HUTAPI.h
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#ifndef HUTAPI_h
#define HUTAPI_h

#define INDEX @"http://218.75.197.121:8888/"
/**课表查询*/
#define API_CLASS @"%@/%@/%@",Config.getApiClass,Config.getStudentKH,Config.getRememberCodeApp
#define API_CLASSXP @"%@/%@/%@",Config.getApiClassXP,Config.getStudentKH,Config.getRememberCodeApp
/**考试查询*/
#define API_EXAM @"%@/%@/key/%@",Config.getApiExam
/**成绩查询*/
#define API_SCORES @"%@/%@/%@/%@",Config.getApiScores
#define API_RANK @"%@/%@/%@",Config.getApiRank

/**登录界面*/
#define API_LOGIN @"%@/%@/%@/1",Config.getApiLogin
#define API_LOGIN_RESET Config.getApiLoginReset
/**用户界面*/
#define API_PROFILE_USER @"%@/%@/%@",Config.getApiProfileUser
#define API_PROFILE_AVATAR @"%@/%@/%@",Config.getApiProfileAvatar
/**网上作业*/
#define API_HOMEWORK @"%@/%@/%@",Config.getApiHomeWork
/**电费查询*/
#define API_POWER @"%@/%@/%@",Config.getApiPower
/**二手市场*/
#define API_GOODS @"%@/%d",Config.getApiGoods
#define API_GOODS_USER @"%@/%@/%@/1",Config.getApiGoodsUser
#define API_GOODS_CREATE @"%@/%@/%@",Config.getApiGoodsCreate
#define API_GOODS_IMG_UPLOAD Config.getApiGoodsImgUpload
#define API_GOODS_SHOW @"%@/%@/%@/%@",Config.getApiGoodsShow
/**失物招领*/
#define API_LOST @"%@/%d",Config.getApiLost
#define API_LOST_USER @"%@/%@",Config.getApiLostUser
#define API_LOSES_CREATE @"%@/%@/%@",Config.getApiLostCreate
#define API_LOSES_IMG_UPLOAD Config.getApiLostImgUpload
/**校园说说*/
#define API_MOMENTS @"%@/%d",Config.getApiMoments
#define API_MOMENTS_USER @"%@/%@",Config.getApiMomentsUser
#define API_MOMENTS_CREATE @"%@/%@/%@",Config.getApiMomentsCreate
#define API_MOMENTS_IMG_UPLOAD @"%@",Config.getApiMomentsImgUpload
#define API_MOMENTS_DELETE @"%@/%@/%@/%@",Config.getApiMomentsDelete
#define API_MOMENTS_COMMENT_DELETE @"%@/%@/%@/%@",Config.getApiMomentsCommentDelete
#define API_MOMENTS_CREATE_COMMENT @"%@/%@/%@/%@",Config.getApiMomentsCreateComment
#define API_MOMENTS_LIKES_CREATE @"%@/%@/%@/%@",Config.getApiMomentsLikesCreate
#define API_MOMENTS_LIKES_SHOW @"%@/%@/%@",Config.getApiMomentsLikesShow
/**视频专栏*/
#define API_VEDIO_SHOW Config.getApiVedioShow
/**反馈*/
#define API_FEEDBACK Config.getApiFeedback
/**其他*/
#define API_IMG @"%@/%@",Config.getApiImg

/**AppKey*/
#define APPKEY_UMESSAGE @"57fe13d867e58e0e59000ca1"
#define APPKEY_QQ_SECRET @"y7n6BRLtnH9mrFT3"
#define APPKEY_SINA_SECRET @"ba2997aaab6a1602406fc94247dc072d" 
#define APPKEY_WECHAT_SECRET @"8bb26c6a577e61f0bbee160dde7e79af"

#endif /* HUTAPI_h */

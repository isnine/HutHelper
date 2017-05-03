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
#define API_CLASS @"%@/%@/%@",Config.getApiClass
#define API_CLASSXP @"%@/%@/%@",Config.getApiClassXP
/**考试查询*/
#define API_EXAM @"%@/%@/key/%@",Config.getApiExam
/**成绩查询*/
#define API_SCORES @"%@/%@/%@/%@"
#define API_RANK @"%@/%@/%@"

/**登录界面*/
#define API_LOGIN @"%@/%@/%@/1"
#define API_LOGIN_RESET @"%@"
/**用户界面*/
#define API_PROFILE_USER @"%@/%@/%@"
#define API_PROFILE_AVATAR @"%@/%@/%@"
/**网上作业*/
#define API_HOMEWORK @"%@/%@/%@"
/**电费查询*/
#define API_POWER @"%@/%@/%@"
/**二手市场*/
#define API_GOODS @"%@/%d"
#define API_GOODS_USER @"%@/%@/%@/1"
#define API_GOODS_CREATE @"%@/%@/%@"
#define API_GOODS_IMG_UPLOAD @"%@"
#define API_GOODS_SHOW @"%@/%@/%@/%@"
/**失物招领*/
#define API_LOST @"%@/%d"
#define API_LOST_USER @"%@/%@"
#define API_LOSES_CREATE @"%@/%@/%@"
#define API_LOSES_IMG_UPLOAD @"%@"
/**校园说说*/
#define API_MOMENTS @"%@/%d"
#define API_MOMENTS_USER @"%@/%@"
#define API_MOMENTS_CREATE @"%@/%@/%@"
#define API_MOMENTS_IMG_UPLOAD @"%@"
#define API_MOMENTS_DELETE @"%@/%@/%@/%@"
#define API_MOMENTS_COMMENT_DELETE @"%@/%@/%@/%@"
#define API_MOMENTS_CREATE_COMMENT @"%@/%@/%@/%@"
#define API_MOMENTS_LIKES_CREATE @"%@/%@/%@/%@"
#define API_MOMENTS_LIKES_SHOW @"%@/%@/%@"
/**视频专栏*/
#define API_VEDIO_SHOW @"%@"
/**反馈*/
#define API_FEEDBACK @"%@"
/**其他*/
#define API_IMG @"%@/%@"

/**AppKey*/
#define APPKEY_UMESSAGE @"57fe13d867e58e0e59000ca1"
#define APPKEY_QQ_SECRET @"y7n6BRLtnH9mrFT3"
#define APPKEY_SINA_SECRET @"ba2997aaab6a1602406fc94247dc072d" 
#define APPKEY_WECHAT_SECRET @"8bb26c6a577e61f0bbee160dde7e79af"

#endif /* HUTAPI_h */

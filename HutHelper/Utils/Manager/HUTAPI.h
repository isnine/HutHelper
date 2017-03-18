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
#define API_CLASS @"http://218.75.197.121:8888/api/v1/get/lessons/%@/%@"
#define API_CLASSXP @"http://218.75.197.121:8888/api/v1/get/lessonsexp/%@/%@"
/**成绩查询*/
#define API_SCORES @"http://218.75.197.121:8888/api/v1/get/scores/%@/%@/%@"
#define API_EXAM @"http://218.75.197.124:84/api/exam/%@/key/%@"
/**登录界面*/
#define API_LOGIN @"http://218.75.197.121:8888/api/v1/get/login/%@/%@/1"
#define API_LOGIN_RESET @"http://218.75.197.121:8888/auth/resetPass"
/**用户界面*/
#define API_PROFILE_USER @"http://218.75.197.121:8888/api/v1/set/profile/%@/%@"
#define API_PROFILE_AVATAR @"http://218.75.197.121:8888/api/v1/set/avatar/%@/%@"
/**网上作业*/
#define API_HOMEWORK @"http://218.75.197.121:8888/api/v1/get/myhomework/%@/%@"
/**电费查询*/
#define API_POWER @"http://218.75.197.121:8888/api/v1/get/power/%@/%@"
/**二手市场*/
#define API_GOODS @"http://218.75.197.121:8888/api/v1/stuff/goods/%d"
#define API_GOODS_USER @"http://218.75.197.121:8888/api/v1/stuff/own1/%@/%@/1"
#define API_GOODS_CREATE @"http://218.75.197.121:8888/api/v1/stuff/create/%@/%@"
#define API_GOODS_IMG_UPLOAD @"http://218.75.197.121:8888/api/v1/stuff/upload"
#define API_GOODS_SHOW @"http://218.75.197.121:8888/api/v1/stuff/detail/%@/%@/%@"
/**失物招领*/
#define API_LOST @"http://218.75.197.121:8888/api/v1/loses/posts/%d"
#define API_LOST_USER @"http://218.75.197.121:8888/api/v1/loses/posts/page/%@"
#define API_LOSES_CREATE @"http://218.75.197.121:8888/api/v1/loses/create/%@/%@"
#define API_LOSES_IMG_UPLOAD @"http://218.75.197.121:8888/api/v1/loses/upload"
/**校园说说*/
#define API_MOMENTS @"http://218.75.197.121:8888/api/v1/moments/posts/%d"
#define API_MOMENTS_USER @"http://218.75.197.121:8888/api/v1/moments/posts/page/%@"
#define API_MOMENTS_CREATE @"http://218.75.197.121:8888/api/v1/moments/create/%@/%@"
#define API_MOMENTS_IMG_UPLOAD @"http://218.75.197.121:8888/api/v1/moments/upload"
#define API_MOMENTS_DELETE @"http://218.75.197.121:8888/api/v1/moments/delete/%@/%@/%@"
#define API_MOMENTS_COMMENT_DELETE @"http://218.75.197.121:8888/api/v1/moments/deletec/%@/%@/%@"
#define API_MOMENTS_CREATE_COMMENT @"http://218.75.197.121:8888/api/v1/moments/comment/%@/%@/%@"
#define API_MOMENTS_LIKES_CREATE @"http://218.75.197.121:8888/api/v1/moments/like/%@/%@/%@"
#define API_MOMENTS_LIKES_SHOW @"http://218.75.197.121:8888/api/v1/moments/like/%@/%@"
/**反馈*/
#define API_FEEDBACK @"http://218.75.197.121:8888/home/msg/0"
/**其他*/
#define API_IMG @"http://218.75.197.121:8888/%@"

/**AppKey*/
#define APPKEY_UMESSAGE @"57fe13d867e58e0e59000ca1"
#define APPKEY_QQ_SECRET @"y7n6BRLtnH9mrFT3"
#define APPKEY_SINA_SECRET @"ba2997aaab6a1602406fc94247dc072d" 
#define APPKEY_WECHAT_SECRET @"8bb26c6a577e61f0bbee160dde7e79af"

#endif /* HUTAPI_h */
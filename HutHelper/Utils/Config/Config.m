//
//  Config.m
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//


#import "User.h"
#import "Config.h"
  
#import "MTA.h"
#import "MTAConfig.h"
#import <StoreKit/StoreKit.h>
#import "XGPush.h"
static int Is ;

@implementation Config
#pragma mark - 特殊设置
+ (void)setIs:(int )bools
{
    Is = bools;
}
+ (int )getIs
{
    return Is;
}
#pragma mark - 用户信息
+(User*)getUser{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *userData=[defaults objectForKey:@"kUser"];
    User *user=[[User alloc ]initWithDic:userData];
    NSLog(@"%@",user.class_name);
    return user;
}
+(NSString*)getStudentKH{
    User *user=self.getUser;
    return user.studentKH;
}
+(NSString*)getUserName{
    User *user=self.getUser;
    return user.username;
}
+(NSString*)getTrueName{
    User *user=self.getUser;
    return user.TrueName;
}
+(NSString*)getAddress{
    User *user=self.getUser;
    return user.address;
}
+(NSString*)getClassName{
    User *user=self.getUser;
    return user.class_name;
}
+(NSString*)getDepName{
    User *user=self.getUser;
    return user.dep_name;
}
+(NSString*)getHeadPicThumb{
    User *user=self.getUser;
    return user.head_pic_thumb;
}
+(NSString*)getLastLogin{
    User *user=self.getUser;
    return user.last_use;
}
+(NSString*)getSex{
    User *user=self.getUser;
    return user.active;
}
+(NSString*)getUserId{
    User *user=self.getUser;
    return user.user_id;
}

+(NSString*)getImToken{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kImToken"];
}
+(NSString*)getRememberCodeApp{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults objectForKey:@"remember_code_app"]);
    return [defaults objectForKey:@"remember_code_app"];
}
#pragma mark - 持续化存储

+(void)saveAllClasses:(NSDictionary*)allClasses{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:allClasses forKey:@"allClasses"];
    [defaults synchronize];
}
+(void)saveUser:(NSDictionary*)userData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:@"kUser"];
    [defaults synchronize];
}
+(void)saveRememberCodeApp:(NSString*)rememberCodeApp{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:rememberCodeApp forKey:@"remember_code_app"];
    [defaults synchronize];
}
+(void)saveCourse:(NSArray*)course{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:course forKey:@"kCourse"];
    [defaults synchronize];
}
+(void)saveCourseXp:(NSArray*)course{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:course forKey:@"kCourseXp"];
    [defaults synchronize];
}
+(void)saveWidgetCourse:(NSArray*)course{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    [shared setObject:course forKey:@"kCourse"];
    [shared synchronize];
}
+(void)saveWidgetCourseXp:(NSArray*)course{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    [shared setObject:course forKey:@"kCourseXp"];
    [shared synchronize];
}
+(void)saveSay:(NSDictionary*)sayData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:sayData forKey:@"Say"];
    [defaults synchronize];
}
+(void)saveSayLikes:(NSDictionary*)sayLikesData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:sayLikesData forKey:@"SayLikes"];
    [defaults synchronize];
}
+(void)saveHand:(NSArray*)handData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:handData forKey:@"Hand"];
    [defaults synchronize];
}
+(void)saveScore:(NSData*)scoreData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:scoreData forKey:@"Score"];
    [defaults synchronize];
}
+(void)saveScoreRank:(NSDictionary*)examRank{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:examRank forKey:@"ScoreRank"];
    [defaults synchronize];
}
+(void)saveExam:(NSData*)examData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:examData forKey:@"Exam"];
    [defaults synchronize];
}
+(void)saveWidgetExam:(NSDictionary*)examDic{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.HutHelper"];
    [shared setObject:examDic forKey:@"Exam"];
    [shared synchronize];
}
+(void)saveLost:(NSArray*)lostData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:lostData forKey:@"kLost"];
    [defaults synchronize];
}
+(void)saveNowWeek:(int)nowWeek{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:nowWeek forKey:@"NowWeek"];
    [defaults synchronize];
}
+(void)saveVedio:(NSDictionary*)vedioData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:vedioData forKey:@"Vedio"];
    [defaults synchronize];
}
+(void)saveVedio480p:(NSString*)vedioString{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:vedioString forKey:@"Vedio480p"];
    [defaults synchronize];
}
+(void)saveVedio720p:(NSString*)vedioString{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:vedioString forKey:@"Vedio720p"];
    [defaults synchronize];
}
+(void)saveVedio1080p:(NSString*)vedioString{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:vedioString forKey:@"Vedio1080p"];
    [defaults synchronize];
}
+(void)saveCalendar:(NSArray*)calendarArray{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:calendarArray forKey:@"kCalendar"];
    [defaults synchronize];
}
+(void)saveImToken:(NSString*)token{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"kImToken"];
    [defaults synchronize];
}
+(void)saveBannerImg:(NSData*)imgData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:imgData forKey:@"kBannerImg"];
    [defaults synchronize];
}
+(void)saveCacheImg:(NSData*)data{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"head_img"];
    [defaults synchronize];
}
#pragma mark - 获得存储数据
+ (NSDictionary*)getAllClasses{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"allClasses"];
}
+(NSArray*)getCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kCourse"];
}
+(NSArray*)getCourseXp{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kCourseXp"];
}
+(NSDictionary*)getSay{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Say"];
 }
+(NSArray*)getLost{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kLost"];
}
+(NSDictionary*)getSayLike{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"SayLikes"];
}
+(NSData*)getExam{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Exam"];
}
+(NSArray*)getScoreRank{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"ScoreRank"];
}
+(NSArray*)getHand{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Hand"];
}
+(NSArray*)getOtherHand{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"otherHand"];
}
+(NSDictionary*)getVedio{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Vedio"];
}
+(NSString*)getVedio480p{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Vedio480p"];
}
+(NSString*)getVedio720p{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Vedio720p"];
}
+(NSString*)getVedio1080p{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Vedio1080p"];
}
+(NSArray*)getCalendar{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kCalendar"];
}
+(NSData*)getBanner{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kBannerImg"];
}
+(NSData*)getCacheImg{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"head_img"];
}
+(BOOL)isTourist{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"KisTourist"];
}
#pragma mark - 版本信息
+(void)saveCurrentVersion:(NSString*)currentVersion{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:currentVersion forKey:@"last_run_version_key"];
    [defaults synchronize];
}
#pragma mark - 是否为游客
+(void)saveTourist:(BOOL)isTourist{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:isTourist forKey:@"KisTourist"];
    [defaults synchronize];
}
#pragma mark - 通知
+(void)addNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *noticeDictionary=@{@"time":@"2017-10-20 08:00",
                                     @"title":@"工大助手",
                                     @"body":@"助手更新啦~"
                                     };
    
    NSDictionary *noticeDictionary1=@{@"time":@"2017-08-14 08:00",
                                      @"title":@"私信功能的使用",
                                      @"body":@"您可以点击侧栏-私信-右上角搜索按钮。\n输入你想要聊天的对象姓名。即可开始聊天。"
                                      };
    NSDictionary *noticeDictionary2=@{@"time":@"2020-3-11 08:00",
                                      @"title":@"私信红点提示",
                                      @"body":@"左上角私信红点提示,点击打开侧边栏私信查看"
                                      };
    NSArray *array = @[noticeDictionary,noticeDictionary2];
    [defaults setObject:array forKey:@"Notice"];//通知列表
    [defaults synchronize];
}
+(void)saveUmeng{
    [MTA setAccount:[self getUser].studentKH type:AT_OTH];
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:[self getUser].dep_name type:XGPushTokenBindTypeTag];
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:[self getUser].studentKH type:XGPushTokenBindTypeAccount];
}
+(void)removeUmeng{
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:[self getUser].dep_name type:XGPushTokenBindTypeTag];
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:[self getUser].studentKH type:XGPushTokenBindTypeAccount];
}
+(void)showAppStore{
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
        [SKStoreReviewController requestReview];
    }else{
        NSString *str = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1164848835&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


+(void)saveUrl:(NSString*)url{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:@"kUrl"];
    [defaults synchronize];
}
+(void)saveEducationSchool:(NSString*)school{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:school forKey:@"kSchool"];
    [defaults synchronize];
}
+(void)saveEducationUserName:(NSString*)userName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"kUserName"];
    [defaults synchronize];
}
+(void)savePassWord:(NSString*)passWord{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:passWord forKey:@"kPassWord"];
    [defaults synchronize];
}
+(NSString*)getEducationUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kUserName"];
}
+(NSString*)getEducationPassWord{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kPassWord"];
}
+(NSString*)getUrl{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kUrl"];
}
+(NSString*)getSchool{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kSchool"];
}
+(void) getClass {
    NSString *urlString=Config.getApiClass;
    NSString *urlXpString=Config.getApiClassXP;
    __block ClassStatus1 status=ClassOK1;
    __block NSString *errorStr;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    //平时课表队列请求
    dispatch_group_async(group, q, ^{
        dispatch_group_enter(group);
        [APIRequest GET:urlString parameters:nil success:^(id responseObject) {
            if ([responseObject[@"code"] isEqual: @200]) {
                NSArray *arrayCourse = responseObject[@"data"];
                [Config saveCourse:arrayCourse];
                [Config saveWidgetCourse:arrayCourse];
            }else{
                status=status+2;
                errorStr=responseObject[@"msg"];
            }
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            status=status+2;
            dispatch_group_leave(group);
            errorStr=@"网络超时，平时课表查询失败";
        }];
    });
    //两个队列都完成后
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (status==ClassOK1||status==ClassXpError1) {
            [Config setIs:0];
            [Config pushViewController:@"Class"];
        }
    });
}
@end


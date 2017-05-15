//
//  Config.m
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//


#import "User.h"
#import "Config.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
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
    return user.last_login;
}
+(NSString*)getSex{
    User *user=self.getUser;
    return user.sex;
}
+(NSString*)getUserId{
    User *user=self.getUser;
    return user.user_id;
}

+(NSString*)getRememberCodeApp{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"remember_code_app"];
}
#pragma mark - 持续化存储
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
    [defaults setObject:lostData forKey:@"Lost"];
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
#pragma mark - 获得存储数据
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

#pragma mark - 版本信息
+(void)saveCurrentVersion:(NSString*)currentVersion{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:currentVersion forKey:@"last_run_version_key"];
    [defaults synchronize];
}
#pragma mark - 通知
+(void)addNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *noticeDictionary=@{@"time":@"2017-05-15 08:00",
                                     @"title":@"工大助手",
                                     @"body":@"工大助手V2.3.2更新日志\n\n- 修复了考试计划相关问题\n- 改进了校园说说/考试计划第一次打开时界面\n\n如果您对App有任何建议或者发现了Bug\n可以在侧栏-反馈中告诉我们，我向您保证每个Bug都会尽快修复，每个意见都会得到回复，另外在AppStore中求个好评🙏"
                                     };
    
    NSDictionary *noticeDictionary1=@{@"time":@"2017-05-15 08:00",
                                      @"title":@"考试计划Widget使用",
                                      @"body":@"临近期末，为了方便掌握考试时间\n您可以在主界面滑到最左边，点击下方的编辑添加【工大助手·考试倒计时】"
                                      };
    NSDictionary *noticeDictionary2=@{@"time":@"2017-05-15 08:00",
                                      @"title":@"工大助手iOS端内测邀请",
                                      @"body":@"校园交友，老乡查找，社团活动\n这些一系列的功能想不想抢先尝试？\nApp功能太少，我有更多的想法\n想不想直接和开发者沟通？\n发现了新的Bug，不满意，要吐槽一番？\n\n现在即可加入到工大助手iOS端的内测中\nQQ群:245057396\n验证信息:姓名+学号。"
                                      };
    NSArray *array = @[noticeDictionary,noticeDictionary1,noticeDictionary2];
    [defaults setObject:array forKey:@"Notice"];//通知列表
    [defaults synchronize];
}
+(void)saveUmeng{
    [MobClick profileSignInWithPUID:[self getUser].studentKH];
    [UMessage addTag:[self getUser].dep_name
            response:^(id responseObject, NSInteger remain, NSError *error) {
                NSLog(@"学院信息保存成功/n");
            }];  //学院
    [UMessage addAlias:[self getUser].studentKH type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
        NSLog(@"学号信息保存成功/n");
    }];
}
+(void)removeUmeng{
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {//删除友盟标签缓存
    }];
    [UMessage removeAlias:[Config getStudentKH] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
    }];
}
@end


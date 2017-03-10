//
//  Config.m
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"
#import "User.h"

static int Is ;

@implementation Config
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
+(void)saveExam:(NSData*)examData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:examData forKey:@"Exam"];
    [defaults synchronize];
}
+(void)saveLost:(NSArray*)lostData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:lostData forKey:@"Lost"];
    [defaults synchronize];
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
    NSMutableDictionary *noticeDictionary=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *noticeDictionary2=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *noticeDictionary3=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *noticeDictionary4=[[NSMutableDictionary alloc]init];
    NSMutableArray *notice=[[NSMutableArray alloc]init];
    [noticeDictionary setObject:@"2017-03-05 24:00" forKey:@"time"];
    [noticeDictionary setObject:@"工大助手" forKey:@"title"];
    [noticeDictionary setObject:@"工大助手V1.9.8更新日志\n\n- 重构了校园说说，流畅度提升160%\n- 修复了二手市场虚拟键盘问题\n- 修复了反馈界面虚拟键盘的问题\n- 修复了Widget周次问题 \n- 修改了分享界面 \n\n如果您对App有任何建议或者发现了Bug\n可以在侧栏-反馈中告诉我们，我向您保证每个Bug都会尽快修复，每个意见都会得到回复，另外在AppStore中求个好评🙏" forKey:@"body"];
    [notice insertObject:noticeDictionary atIndex:0];
    [noticeDictionary3 setObject:@"2017-02-20 08:00" forKey:@"time"];
    [noticeDictionary3 setObject:@"开发者的一些话" forKey:@"title"];
    [noticeDictionary3 setObject:@"首先感谢你在新的学期里继续使用工大助手,由于团队每个人的分工不同，整个iOS端仅由我一个人的负责开发。对此，如果之前版本App有给你带来不便的地方，希望您能够理解。\n\n在新的版本中，我修改了大量的界面并对程序进行了优化。如果您还发现有任何Bug，可以通过【左滑菜单-反馈】向我反馈，我向您保证，您反馈的每一个Bug我都会修复，提的每一个建议，我们都会认真考虑。\n\n同时如果App给您有带来了便利，希望您可以在【左滑菜单-关于-去AppStore评分】给App进行评分，对一个整天码代码的程序猿来说，这是最好的鼓励了🙏\n" forKey:@"body"];
    [notice insertObject:noticeDictionary3 atIndex:1];
    
    [noticeDictionary2 setObject:@"2017-02-20 08:00" forKey:@"time"];
    [noticeDictionary2 setObject:@"部分新功能的使用" forKey:@"title"];
    [noticeDictionary2 setObject:@"在新的版本中,我们支持了用户自定义昵称和修改头像。\n【设置昵称】左滑菜单-个人中心-修改昵称\n【设置头像】左滑菜单-个人中心-点击头像\n\n\n\n【打开Widget】系统主界面-滑动屏幕到最左边-编辑-添加工大助手\n添加后您可以在不打开App的情况下查询课表" forKey:@"body"];
    [notice insertObject:noticeDictionary2 atIndex:2];
    NSArray *array = [NSArray arrayWithArray:notice];
    [defaults setObject:array forKey:@"Notice"];//通知列表
    [defaults synchronize];
}
@end

//
//  Config.h
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface Config : NSObject

+ (void)setIs:(int )Is;
+ (int )getIs;
+(void)addNotice;
#pragma mark - 可持续存储
+(void)saveUser:(NSDictionary*)userData;
+(void)saveRememberCodeApp:(NSString*)rememberCodeApp;
+(void)saveCurrentVersion:(NSString*)currentVersion;
+(void)saveCourseXp:(NSArray*)course;
+(void)saveCourse:(NSArray*)course;
+(void)saveWidgetCourse:(NSArray*)course;
+(void)saveWidgetCourseXp:(NSArray*)course;
+(void)saveSay:(NSDictionary*)sayData;
+(void)saveSayLikes:(NSDictionary*)sayLikesData;
+(void)saveHand:(NSArray*)handData;
+(void)saveScore:(NSData*)scoreData;
+(void)saveExam:(NSData*)examData;
+(void)saveLost:(NSArray*)lostData;
+(void)saveNowWeek:(int)nowWeek;
#pragma mark - 获得存储数据
+(NSArray*)getCourse;
+(NSArray*)getCourseXp;
#pragma mark - 获得用户数据
+(User*)getUser;
+(NSString*)getStudentKH;
+(NSString*)getUserName;
+(NSString*)getTrueName;
+(NSString*)getAddress;
+(NSString*)getClassName;
+(NSString*)getDepName;
+(NSString*)getHeadPicThumb;
+(NSString*)getLastLogin;
+(NSString*)getSex;
+(NSString*)getUserId;
+(NSString*)getRememberCodeApp;
#pragma mark - 设置
+(void)setNoSharedCache;
+(void)pushViewController:(NSString*)controller;
@end

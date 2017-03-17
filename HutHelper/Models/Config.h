//
//  Config.h
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUTAPI.h"
@class User;
#define HideAllHUD  [MBProgressHUD hideHUDForView:self.view animated:YES];
#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define SYReal(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width)
#define RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...)
#endif

@interface Config : NSObject

+ (void)setIs:(int )Is;
+ (int )getIs;
+(void)addNotice;

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
@end

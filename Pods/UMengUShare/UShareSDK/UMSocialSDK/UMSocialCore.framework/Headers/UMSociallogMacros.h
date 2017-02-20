//
//  UMSociallogMacros.h
//  UMSocialCore
//
//  Created by 张军华 on 16/9/7.
//  Copyright © 2016年 张军华. All rights reserved.
//

#import <Foundation/Foundation.h>



FOUNDATION_EXPORT void setGlobalLogLevelString(NSString* levelString);
FOUNDATION_EXPORT NSString* getGlobalLogLevelString();

FOUNDATION_EXPORT NSString* const UMSocialLogClosedLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogErrorLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogWarnLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogInfoLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogDebugLevelString;
FOUNDATION_EXPORT NSString* const UMSocialLogVerboseLevelString;



FOUNDATION_EXPORT void UMSocialLog(NSString* flagString,const char* file,const char* function,NSUInteger line,NSString *format, ...) NS_FORMAT_FUNCTION(5,6);

FOUNDATION_EXPORT NSString* const UMSocialLogErrorFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogWarnFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogInfoFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogDebugFlagString;
FOUNDATION_EXPORT NSString* const UMSocialLogVerboseFlagString;

//简易函数类似于系统的NSLog函数,线程安全
#define UMSocialLogError(format, ...)   UMSocialLog(UMSocialLogErrorFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogWarn(format, ...)    UMSocialLog(UMSocialLogWarnFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogInfo(format, ...)    UMSocialLog(UMSocialLogInfoFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogDebug(format, ...)   UMSocialLog(UMSocialLogDebugFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)
#define UMSocialLogVerbose(format, ...) UMSocialLog(UMSocialLogVerboseFlagString,__FILE__,__PRETTY_FUNCTION__,__LINE__,format,##__VA_ARGS__)


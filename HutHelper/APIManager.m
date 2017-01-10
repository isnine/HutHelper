//
//  APIManager.m
//  HutHelper
//
//  Created by nine on 2017/1/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "APIManager.h"
#import "JSONKit.h"
#import "UMessage.h"
@implementation APIManager


-(NSString*)Login:(NSString*)UserName_String With:(NSString*)Password_String{
    //----------拼接地址 RUN
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/get/login/%@/%@/1",UserName_String,Password_String];
    //----------拼接地址 END
    NSURL *url                   = [NSURL URLWithString: Url_String];//接口地址
    NSError *error               = nil;
    NSString *jsonString         = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData             = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *User_All       = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
    NSString *Msg=[User_All objectForKey:@"msg"];
    //--------登录中
    if ([Msg isEqualToString: @"ok"])
    {
        NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        //   NSLog(@"正确:%@",Msg);// 调出Data字典中TrueName
        NSString *Remember_code_app=[User_All objectForKey:@"remember_code_app"]; //令牌
        
        NSString *TrueName=[User_Data objectForKey:@"TrueName"]; //真实姓名
        NSString *studentKH=[User_Data objectForKey:@"studentKH"]; //学号
        NSString *dep_name=[User_Data objectForKey:@"dep_name"]; //学院
        NSString *class_name=[User_Data objectForKey:@"class_name"];  //班级
        NSString *sex=[User_Data objectForKey:@"sex"];  //班级
        NSString *username=[User_Data objectForKey:@"username"];
        NSString *head_pic_thumb=[User_Data objectForKey:@"head_pic_thumb"];
        if(username == NULL ||[username isEqual:[NSNull null]]){
            username=@"(无名氏)";
        }
        NSString *last_login=[User_Data objectForKey:@"last_login"];  //班级
        //--------保存用户信息
        [defaults setObject:Remember_code_app forKey:@"remember_code_app"];
        [defaults setObject:TrueName forKey:@"TrueName"];
        [defaults setObject:studentKH forKey:@"studentKH"];
        [defaults setObject:dep_name forKey:@"dep_name"];
        [defaults setObject:class_name forKey:@"class_name"];
        [defaults setObject:sex forKey:@"sex"];
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:last_login forKey:@"last_login"];
        [defaults setObject:head_pic_thumb forKey:@"head_pic_thumb"];
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleShortVersionString"];
        [defaults setObject:currentVersion forKey:@"last_run_version_key"]; //保存版本信息
        [defaults synchronize];
        //  NSLog(@"用户：%@，学号：%@,令牌:%@",TrueName,studentKH,Remember_code_app);
        //--------保存用户信息
        //---------推送标签
        [UMessage addTag:dep_name
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    //add your codes
                }];
        [UMessage addTag:class_name
                response:^(id responseObject, NSInteger remain, NSError *error) {
                    //add your codes
                }];
        //--------推送标签完毕
       
    }
     return Msg;
}
@end

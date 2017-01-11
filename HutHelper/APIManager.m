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

-(NSString*)GetClass{
    int class_error_=0;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *studentKH=[defaults objectForKey:@"studentKH"];
    NSString *Remember_code_app=[defaults objectForKey:@"remember_code_app"];
    /**课表数据缓存*/
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/get/lessons/%@/%@",studentKH,Remember_code_app];
    NSURL *url                   = [NSURL URLWithString: Url_String];//接口地址
    NSError *error               = nil;
    NSString *jsonString         = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData             = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *Class_All      = [jsonData objectFromJSONData];//数据 -> 字典
    NSString *msg_class          = [Class_All objectForKey:@"msg"];//得到数据情况
    if ([msg_class isEqualToString:@"ok"]) {
        NSArray *array               = [Class_All objectForKey:@"data"];
        [defaults setObject:array forKey:@"array_class"];
        [defaults synchronize];
    }
    else{
        class_error_=1;
    }
    NSLog(@"平时课表地址:%@",url);
    /**实验课表数据缓存*/
    NSString *Url_String_xp_1=@"http://218.75.197.121:8888/api/v1/get/lessonsexp/";
    NSString *Url_String_xp_1_U=[Url_String_xp_1 stringByAppendingString:studentKH];
    NSString *Url_String_xp_1_U_2=[Url_String_xp_1_U stringByAppendingString:@"/"];
    NSString *Url_String_xp=[Url_String_xp_1_U_2 stringByAppendingString:Remember_code_app];
    NSURL *url_xp                = [NSURL URLWithString: Url_String_xp];//接口地址
    NSLog(@"实验课表地址:%@",Url_String_xp);
    //自带库解析实验课
    NSURLRequest *request        = [NSURLRequest requestWithURL:[NSURL URLWithString:Url_String_xp]];
    NSData *response             = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (!response==NULL) {
        NSDictionary *jsonDataxp     = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSString *msg_xp          = [jsonDataxp objectForKey:@"msg"];//得到数据情况
        if ([msg_xp isEqualToString:@"ok"]) {
            NSArray *array_xp            = [jsonDataxp objectForKey:@"data"];
            [defaults setObject:array_xp forKey:@"array_xp"];
            [defaults synchronize];
        }
        else{
            class_error_=class_error_+2;
        }
    }
    else{
        class_error_=class_error_+2;
    }
    NSString *show_erro;
    switch (class_error_) {
        case 0:{
            return @"ok";
            break;
        }
        case 1:{
            return @"没有找到平时课表";
            break;}
        case 2:{
            return @"没有找到实验课表";
            break;
        }
        case 3:{
            return @"请点击切换用户，重新登录";
            break;}
        default:
            break;
    }
    return @"请点击切换用户，重新登录";
}
@end

//
//  LoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/8.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LoginViewController.h"
#import "Login2ViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;



@end

@implementation LoginViewController

- (IBAction)Login:(id)sender {
    APIManager *API_Request=[[APIManager alloc]init];
        NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
        NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
        /**请求地址*/
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/get/login/%@/%@/1",UserName_String,Password_String];
        /**请求*/
        [MBProgressHUD showMessage:@"登录中" toView:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"成功%@" ,responseObject);
                 NSDictionary *User_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 //       NSDictionary *User_All       = [responseObject objectFromJSONData];//数据 -> 字典
                 NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
                 NSString *Msg=[User_All objectForKey:@"msg"];
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
                     if(username == NULL ||[username isEqual:[NSNull null]]) username=@"(无名氏)";
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
                     NSLog(@"用户：%@，学号：%@,令牌:%@",TrueName,studentKH,Remember_code_app);
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }
                 else {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:Msg];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"网络错误"];
             }];
}


- (IBAction)Didend:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *greyColor           = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor    = greyColor;
    self.title                   = @"切换用户";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _UserName.placeholder=@"学号";
    _Password.placeholder=@"密码";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

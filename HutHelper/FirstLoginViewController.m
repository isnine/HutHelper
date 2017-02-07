//
//  FirstLoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/17.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FirstLoginViewController.h"
#import "Login2ViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MainPageViewController.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "User.h"
#import "YYModel.h"

@interface FirstLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@end

@implementation FirstLoginViewController

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (IBAction)Login:(id)sender {
    NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
    NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
    /**请求地址*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/get/login/%@/%@/1",UserName_String,Password_String];
    /**请求*/
    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *User_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
             NSString *Msg=[User_All objectForKey:@"msg"];
             if ([Msg isEqualToString: @"ok"])
             {
                 [defaults setObject:User_Data forKey:@"User"];
                 [defaults setObject:[User_All objectForKey:@"remember_code_app"] forKey:@"remember_code_app"];
                 NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                             objectForKey:@"CFBundleShortVersionString"];
                 [defaults setObject:currentVersion forKey:@"last_run_version_key"]; //保存版本信息
                 [defaults synchronize];
                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             else {
                 NSString *Show_Msg=[Msg stringByAppendingString:@",默认密码身份证后六位"];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showError:Show_Msg];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"网络错误或超时"];
         }];
}



- (IBAction)End:(id)sender {
    [sender resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _UserName.placeholder=@"学号";
    [_UserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Password.placeholder=@"密码";
    [_Password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Login2ViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

-(void)sein{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Login2ViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end


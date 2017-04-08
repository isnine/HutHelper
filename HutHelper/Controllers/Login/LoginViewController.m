//
//  LoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/17.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPassWordViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MainPageViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "User.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@end

@implementation LoginViewController

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
    NSString *Url_String=[NSString stringWithFormat:API_LOGIN,UserName_String,Password_String];
    NSLog(@"登录地址:%@",Url_String);
    /**请求*/
    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置超时*/
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 9.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *userAll = [NSDictionary dictionaryWithDictionary:responseObject];
             NSDictionary *userData=[userAll objectForKey:@"data"];//All字典 -> Data字典
             NSString *msg=[userAll objectForKey:@"msg"];
             if ([msg isEqualToString: @"ok"])
             {
                 [Config saveUser:userData];
                 [Config saveRememberCodeApp:[userAll objectForKey:@"remember_code_app"]];
                 [Config saveCurrentVersion:[[[NSBundle mainBundle] infoDictionary]
                                             objectForKey:@"CFBundleShortVersionString"]];
                 [Config addNotice];
                 /**设置友盟标签&别名*/
                 [Config saveUmeng];
                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                 HideAllHUD
             }
             else {
                 NSString *Show_Msg=[msg stringByAppendingString:@",默认密码身份证后六位"];
                 if ([msg isEqualToString:@"多次失败，请稍后再试，或修改密码"]) {
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码多次错误" message:msg preferredStyle:  UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"稍后再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         //点击按钮的响应事件；
                     }]];
                     [alert addAction:[UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          [Config pushViewController:@"Login2"];
                     }]];
                     //弹出提示框；
                     [self presentViewController:alert animated:true completion:nil];
                 } else{
                     [MBProgressHUD showError:Show_Msg];
                 }
                 HideAllHUD
                
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HideAllHUD
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
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
}
- (IBAction)resetpassword:(id)sender {
    [Config pushViewController:@"Login2"];
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


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
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;



@end

@implementation LoginViewController

- (IBAction)Login:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //----------拼接地址 RUN
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
        NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
        NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/login/";
        NSString *Url_String_2=@"/";
        NSString *Url_String_3=@"/1";
        NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:UserName_String];
        NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
        NSString *Url_String_1_U_2_P=[Url_String_1_U_2 stringByAppendingString:Password_String];
        NSString *Url_String=[Url_String_1_U_2_P stringByAppendingString:Url_String_3];
        //----------拼接地址 END
        NSURL *url                   = [NSURL URLWithString: Url_String];//接口地址
        NSError *error               = nil;
        NSString *jsonString         = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* jsonData             = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *User_All       = [jsonData objectFromJSONData];//数据 -> 字典
        NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
        NSString *Msg=[User_All objectForKey:@"msg"];
        NSString *Msg2=@"ok";
        //--------登录中
        if ([Msg isEqualToString: Msg2])
        {
            NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            NSLog(@"正确:%@",Msg);// 调出Data字典中TrueName
            NSString *Remember_code_app=[User_All objectForKey:@"remember_code_app"]; //令牌
            
            NSString *TrueName=[User_Data objectForKey:@"TrueName"]; //真实姓名
            NSString *studentKH=[User_Data objectForKey:@"studentKH"]; //学号
            NSString *dep_name=[User_Data objectForKey:@"dep_name"]; //学院
            NSString *class_name=[User_Data objectForKey:@"class_name"];  //班级
            //--------保存用户信息
            [defaults setObject:Remember_code_app forKey:@"remember_code_app"];
            [defaults setObject:TrueName forKey:@"TrueName"];
            [defaults setObject:studentKH forKey:@"studentKH"];
            [defaults setObject:dep_name forKey:@"dep_name"];
            [defaults setObject:class_name forKey:@"class_name"];
            [defaults synchronize];
            NSLog(@"用户：%@，学号：%@,令牌:%@",TrueName,studentKH,Remember_code_app);
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
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
            
        }
        else
        {
            UIAlertView *alertView       = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                      message:Msg
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });}


- (IBAction)Didend:(id)sender {
    [sender resignFirstResponder];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *greyColor           = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor    = greyColor;
    self.title                   = @"切换用户";
    _UserName.placeholder=@"学号";
    _Password.placeholder=@"密码";


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

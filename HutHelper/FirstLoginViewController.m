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
@interface FirstLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@end

@implementation FirstLoginViewController
- (IBAction)Login:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //       拼接地址 RUN
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
        //       拼接地址 END
        
        NSURL *url                   = [NSURL URLWithString: Url_String];//接口地址
        NSError *error               = nil;
        NSString *jsonString         = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* jsonData             = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *User_All       = [jsonData objectFromJSONData];//数据 -> 字典
        NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
        
        NSString *Msg=[User_All objectForKey:@"msg"];
        NSString *Message=[Msg stringByAppendingString:@"，默认密码为身份证后六位"];
        if ([Msg isEqualToString: @"ok"])
        {
            NSLog(@"正确:%@",Msg);// 调出Data字典中TrueName
            NSString *Remember_code_app=[User_All objectForKey:@"remember_code_app"]; //令牌
            
            NSString *TrueName=[User_Data objectForKey:@"TrueName"]; //真实姓名
            NSString *studentKH=[User_Data objectForKey:@"studentKH"]; //学号
            NSString *dep_name=[User_Data objectForKey:@"dep_name"]; //学院
            NSString *class_name=[User_Data objectForKey:@"class_name"];  //班级
            NSString *sex=[User_Data objectForKey:@"sex"];  //班级
            NSString *username=[User_Data objectForKey:@"username"];
            NSString *last_login=[User_Data objectForKey:@"last_login"];  //班级
            NSString *head_pic_thumb=[User_Data objectForKey:@"head_pic_thumb"]; //头像
            if(username == NULL ||[username isEqual:[NSNull null]]){
                username=@"(无名氏)";
            }
            //保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
            [defaults setObject:Remember_code_app forKey:@"remember_code_app"];
            [defaults setObject:TrueName forKey:@"TrueName"];
            [defaults setObject:studentKH forKey:@"studentKH"];
            [defaults setObject:dep_name forKey:@"dep_name"];
            [defaults setObject:class_name forKey:@"class_name"];
            [defaults setObject:sex forKey:@"sex"];
            [defaults setObject:username forKey:@"username"];
            [defaults setObject:last_login forKey:@"last_login"];
            [defaults setObject:head_pic_thumb forKey:@"head_pic_thumb"];
            //强制让数据立刻保存
            [defaults synchronize];
            NSLog(@"用户：%@，学号：%@,令牌:%@",TrueName,studentKH,Remember_code_app);
            
            [UMessage addTag:dep_name
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        //add your codes
                    }];
            [UMessage addTag:class_name
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        //add your codes
                    }];
            
            //推送标签
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
            
        }
        else
        {
            UIAlertView *alertView       = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                      message:Message
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}



- (IBAction)End:(id)sender {
    [sender resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *greyColor           = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor    = greyColor;
    
    self.title                   = @"登录";
    _UserName.placeholder=@"学号";
    [_UserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Password.placeholder=@"密码";
    [_Password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

-(void)sein{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
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

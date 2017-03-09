//
//  UsernameViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/20.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UsernameViewController.h"
#import "JSONKit.h"

#import "User.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"
@interface UsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Username;

@end

@implementation UsernameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改昵称";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // Do any additional setup after loading the view.
}
- (IBAction)Add:(id)sender {
    [MBProgressHUD showMessage:@"修改中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_PROFILE_USER,Config.getStudentKH,Config.getRememberCodeApp];
    NSURL * url  = [NSURL URLWithString:Url_String];
    NSString *str=@"username=";
    str=[str stringByAppendingString:_Username.text];
    NSString *username_text=_Username.text;
    NSLog(@"地址%@",Url_String);
    NSLog(@"传值%@",str);
    NSMutableURLRequest * request      = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式(默认的是get方式)
    request.HTTPMethod                 = @"POST";//使用大写规范
    //设置请求参数
    request.HTTPBody                   = [str dataUsingEncoding:NSUTF8StringEncoding];
    //创建NSURLConnection 对象用来连接服务器并且发送请求
    NSURLConnection * conn   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *returnData_Dic       = [returnData objectFromJSONData];//数据 -> 字典
    NSString *Msg=[returnData_Dic objectForKey:@"msg"];
    
    if ([Msg isEqualToString:@"ok"]) {
        [defaults setObject:username_text forKey:@"username"];
        HideAllHUD
        [MBProgressHUD showSuccess:@"修改成功"];
          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];  //返回用户
    }
    else if ([Msg isEqualToString:@"令牌错误"]){
        HideAllHUD
        [MBProgressHUD showError:@"登录过期，请重新登录"];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];  //返回Home
    }
    else{
        HideAllHUD
        [MBProgressHUD showError:@"网络错误"];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

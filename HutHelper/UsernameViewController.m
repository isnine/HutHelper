//
//  UsernameViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/20.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UsernameViewController.h"

@interface UsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Username;

@end

@implementation UsernameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改昵称";
    // Do any additional setup after loading the view.
}
- (IBAction)Add:(id)sender {
    
    NSString *url_s=@"http://218.75.197.121:8888/api/v1/set/profile/";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *studentKH=[defaults objectForKey:@"studentKH"];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
    url_s=[url_s stringByAppendingString:studentKH];
    url_s=[url_s stringByAppendingString:@"/"];
    url_s=[url_s stringByAppendingString:remember_code_app];
    NSURL * url  = [NSURL URLWithString:url_s];
    
    NSString *str=@"username=";
    str=[str stringByAppendingString:_Username.text];

    NSLog(@"地址%@",url_s);
    
     NSLog(@"传值%@",str);
    
    NSMutableURLRequest * request      = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式(默认的是get方式)
    request.HTTPMethod                 = @"POST";//使用大写规范
    //设置请求参数
    request.HTTPBody                   = [str dataUsingEncoding:NSUTF8StringEncoding];
    //创建NSURLConnection 对象用来连接服务器并且发送请求
    NSURLConnection * conn   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
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

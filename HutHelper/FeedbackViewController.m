//
//  FeedbackViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Mail;
@property (weak, nonatomic) IBOutlet UITextView *Content;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"反馈";
    UIColor *greyColor= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    
    _Mail.placeholder=@"邮箱";
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Submit:(id)sender {
    NSURL * url = [NSURL URLWithString:@"http://218.75.197.121:8888/home/msg/0"];
    NSString *str1=@"email=";
    NSString *Mail_String=_Mail.text;
    NSString *str2=@"&content=";
    NSString *Content_String=_Content.text;
    
    
    NSString *str1_Mail_String=[str1 stringByAppendingString:Mail_String];
    NSString *str1_Mail_String_str2=[str1_Mail_String stringByAppendingString:str2];
    NSString *str=[str1_Mail_String_str2 stringByAppendingString:Content_String];

        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        //设置请求方式(默认的是get方式)
        request.HTTPMethod = @"POST";//使用大写规范
        //设置请求参数
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        //创建NSURLConnection 对象用来连接服务器并且发送请求
        NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    
        NSLog(@"%@", [NSThread currentThread]);

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功"
                                                        message:@"我们将在一个工作日内联系你"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];

}

@end

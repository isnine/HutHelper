//
//  Login2ViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "Login2ViewController.h"
#import "MBProgressHUD+MJ.h"
@interface Login2ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation Login2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    NSString *Url_String=@"http://218.75.197.121:8888/auth/resetPass";
    
    NSURL *url = [[NSURL alloc]initWithString:Url_String];
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
    _views.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** webView的代理方法*/

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //提示用户正在加载
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络错误"];
}


@end

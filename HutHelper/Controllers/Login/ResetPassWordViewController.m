//
//  ResetPassWordViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "MBProgressHUD+MJ.h"
 
@interface ResetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    NSString *Url_String=Config.getApiLoginReset;
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
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
    
    HideAllHUD
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    HideAllHUD
    [MBProgressHUD showError:@"网络错误"];
}


@end

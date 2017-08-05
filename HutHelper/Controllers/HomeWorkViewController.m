//
//  HomeWorkViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/10.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD+MJ.h"

#import "User.h"
 
@interface HomeWorkViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation HomeWorkViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网上作业";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSString *Url_String=Config.getApiHomeWork;
    NSURL *url                = [[NSURL alloc]initWithString:Url_String];
    _views.delegate=self;
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
    
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 [MobClick beginLogPageView:@"网上作业"];//("PageOne"为页面名称，可自定义)
 }
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 [MobClick endLogPageView:@"网上作业"];
 }
/** webView的代理方法*/
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HideAllHUD
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    HideAllHUD
    [MBProgressHUD showError:@"网络错误" toView:self.view];
}
@end

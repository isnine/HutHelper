//
//  HomeWorkViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/10.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD.h"
@interface HomeWorkViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation HomeWorkViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网上作业";
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *studentKH=[defaults objectForKey:@"studentKH"];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
        NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/myhomework/";
    NSString *Url_String_2=@"/";

    NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:studentKH];
    NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
    NSString *Url_String=[Url_String_1_U_2 stringByAppendingString:remember_code_app];

    NSURL *url                = [[NSURL alloc]initWithString:Url_String];
    _views.delegate=self;
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });

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
- (void)webViewDidStartLoad:(UIWebView *)webView
{

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end

//
//  LibraryViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LibraryViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD.h"
@interface LibraryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图书馆";
    NSString *Url_String=@"http://218.75.197.121:8889/opac/m/index";

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
    [MobClick beginLogPageView:@"图书馆"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图书馆"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end

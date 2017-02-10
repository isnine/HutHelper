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
#import "MBProgressHUD+MJ.h"
#import "Config.h"
@interface LibraryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation LibraryViewController

NSString *Url_String;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetTitle];
    [self SetURL];
    NSURL *url                = [[NSURL alloc]initWithString:Url_String];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _views.delegate=self;
    [_views loadRequest:[NSURLRequest requestWithURL:url]];

}

-(void)SetURL{
    Url_String=@"http://218.75.197.121:8889/opac/m/index";
}

-(void)SetTitle{
    self.navigationItem.title = @"图书馆";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图书馆"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图书馆"];
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

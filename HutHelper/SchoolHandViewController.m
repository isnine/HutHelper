//
//  SchoolHandViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SchoolHandViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD+MJ.h"
#import "DJRefresh.h"

@interface SchoolHandViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;
@property (nonatomic,strong)DJRefresh *refresh;
@end

@implementation SchoolHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园二手";
    
    
    NSURLRequest *url=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://218.75.197.121:8888/trade/goods"]];
    
    [self.Show loadRequest:url];
    
    _refresh=[[DJRefresh alloc] initWithScrollView:self.Show.scrollView];
    
    [_refresh didRefreshCompletionBlock:^(DJRefresh *refresh, DJRefreshDirection direction, NSDictionary *info) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_Show reload];
            [_refresh finishRefreshingDirection:direction animation:YES];
        });
    }];
    
    
    _Show.delegate =self;
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"二手市场"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"二手市场"];
}

/** webView的代理方法*/



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络错误"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *url=webView.request.URL.absoluteString;
    NSLog(@"%@",webView.request.URL.absoluteString);
    
    if([url isEqualToString:@"http://218.75.197.121:8888/"]){
        NSLog(@"首页");
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
    }
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if([url isEqualToString:@"http://218.75.197.121:8888/trade/goods"]){
        _refresh.topEnabled=YES;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.3"];
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
            NSLog(@"IPAD");
        }
    }
    else
    {
        _refresh.topEnabled=NO;
    }
    if(([url rangeOfString:@"http://218.75.197.121:8888/trade/detail/"].location !=NSNotFound)){
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
        }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
            
        }
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];}

@end

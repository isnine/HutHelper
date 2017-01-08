
//  SchoolsayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SchoolsayViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD+MJ.h"
#import "DJRefresh.h"
@interface SchoolsayViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;
@property (nonatomic,strong)DJRefresh *refresh;
@end

@implementation SchoolsayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];

    NSURLRequest *url=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://218.75.197.121:8888/moments"]];
    
    [self.Show loadRequest:url];
    
    _refresh=[[DJRefresh alloc] initWithScrollView:self.Show.scrollView];
    _refresh.topEnabled=YES;
    [_refresh didRefreshCompletionBlock:^(DJRefresh *refresh, DJRefreshDirection direction, NSDictionary *info) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_Show reload];
            [_refresh finishRefreshingDirection:direction animation:YES];
        });
    }];
          _Show.delegate =self;
     [MBProgressHUD showMessage:@"加载中" toView:self.view];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"校园说说"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"校园说说"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    NSString *url=webView.request.URL.absoluteString;
   
    
    //获得地址
    //如果是首页则返回
    if([url isEqualToString:@"http://218.75.197.121:8888/"]){
     
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
    }


    CGSize screenSize = [UIScreen mainScreen].bounds.size;//获得屏幕大小
    if(([url rangeOfString:@"http://218.75.197.121:8888/moments"].location !=NSNotFound)){
        _refresh.topEnabled=YES;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            // 竖屏情况
            if (screenSize.height > screenSize.width) {
                if (screenSize.height == 568) { //iPhone 5/5c/5s iPod Touch5
                [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.385"];
                }else if (screenSize.height == 667) {//iphone6
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.445"];
                }else if (screenSize.height == 736) {//iphone6 plus
                    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.495"];
                
                }else {//iphone4等其他设备
                }
        }
        
    }
        else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.92"];
        
        }
    }
    else
    {
        _refresh.topEnabled=NO;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络错误"];
}
@end

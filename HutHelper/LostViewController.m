//
//  LostViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/15.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LostViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD.h"
@interface LostViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;

@end

@implementation LostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"失物招领";
    NSURL *url                = [[NSURL alloc]initWithString:@"http://218.75.197.121:8888/loses"];
    
    [_Show loadRequest:[NSURLRequest requestWithURL:url]];
    
    _Show.delegate =self;
    
    [self webViewDidFinishLoad:_Show];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"失物招领"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"失物招领"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *url=webView.request.URL.absoluteString;
    NSLog(@"%@",webView.request.URL.absoluteString);
    //获得地址
    //如果是首页则返回
    if([url isEqualToString:@"http://218.75.197.121:8888/"]){
        NSLog(@"首页");
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;//获得屏幕大小
    if([url isEqualToString:@"http://218.75.197.121:8888/loses"]){
        
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
            NSLog(@"IPAD");
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end


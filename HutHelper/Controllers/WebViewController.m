//
//  ResetPassWordViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "WebViewController.h"
#import "MBProgressHUD+MJ.h"
 
@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =self.viewTitle;
    NSString *Url_String=Config.getApiLoginReset;
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSURL *url = [[NSURL alloc]initWithString:self.urlString];
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
    _views.delegate=self;
    _views.scalesPageToFit = YES;
    /**让黑线消失的方法*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
 
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



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //隐藏显示
    HideAllHUD
    [MBProgressHUD showError:@"网络错误" toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HideAllHUD
    NSString *url=webView.request.URL.absoluteString;
    if([url isEqualToString:[NSString stringWithFormat:@"%@/",Config.apiIndex]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
    }
    CGSize screenSize = [UIScreen mainScreen].bounds.size;//获得屏幕大小
    if(([url rangeOfString:[NSString stringWithFormat:@"%@/home/post/39",Config.apiIndex]].location !=NSNotFound)){
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

}
@end

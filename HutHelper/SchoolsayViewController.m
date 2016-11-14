//
//  SchoolsayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SchoolsayViewController.h"
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD.h"
@interface SchoolsayViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;

@end

@implementation SchoolsayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"校园说说";
  NSURL *url                = [[NSURL alloc]initWithString:@"http://218.75.197.121:8888/moments"];


    [_Show loadRequest:[NSURLRequest requestWithURL:url]];
   
      _Show.delegate =self;
    
    [self webViewDidFinishLoad:_Show];
    
   

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*‚‚
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.5"];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end

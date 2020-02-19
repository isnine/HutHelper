//
//  BaseWebViewController.m
//  HutHelper
//
//  Created by 张驰 on 2019/11/14.
//  Copyright © 2019 nine. All rights reserved.
//

#import "BaseWebViewController.h"
 
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "HutHelper-Swift.h"
@interface BaseWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BaseWebViewController{
     UIButton *mainAndSearchBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigation_item.title = _centerTitle;
    NSURL *url                = [[NSURL alloc]initWithString:_url];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self customBackButton];
    _webView.delegate=self;
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

// 自定义返回按钮
- (void)customBackButton{
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    
    mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigation_item.leftBarButtonItem = rightCunstomButtonView;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    if(self.webView.canGoBack){
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = mainAndSearchBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
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
    [MBProgressHUD showError:@"网络错误" toView:self.view];
}

@end

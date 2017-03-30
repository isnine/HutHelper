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
 
@interface LibraryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation LibraryViewController{
    UIButton *mainAndSearchBtn;
    NSString *Url_String;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetTitle];
    [self SetURL];
    NSURL *url                = [[NSURL alloc]initWithString:Url_String];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self customBackButton];
    _views.delegate=self;
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)SetURL{
    Url_String=@"http://218.75.197.121:8889/opac/m/index";
}

-(void)SetTitle{
    self.navigationItem.title = @"图书馆";
}

// 自定义返回按钮
- (void)customBackButton{
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.leftBarButtonItem = rightCunstomButtonView;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    if(self.views.canGoBack){
        [self.views goBack];
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
    [MobClick beginLogPageView:@"图书馆"];
    self.navigationItem.backBarButtonItem = mainAndSearchBtn;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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

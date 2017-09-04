//
//  NoticeShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "NoticeShowViewController.h"
#import "UINavigationBar+Awesome.h"
@interface NoticeShowViewController ()
@property (weak, nonatomic) IBOutlet UIButton *show;
@property (nonatomic,copy) NSDictionary      *noticeShowData;
@end

@implementation NoticeShowViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNoticeShowData];
    [self setBody];
    [self setTitle];
    [self showOther];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNoticeShowData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _noticeShowData=[defaults objectForKey:@"NoticeShow"];
}
-(void)setBody{
    _Title.text=[_noticeShowData objectForKey:@"title"];
    if ([[_noticeShowData objectForKey:@"title"] isEqualToString:@""]) {
        _Title.text=@"通知";
    }
    _Body.text=[_noticeShowData objectForKey:@"body"];
    _Time.text=[_noticeShowData objectForKey:@"time"];
}
-(void)showOther{
   if ([[_noticeShowData objectForKey:@"title"]isEqualToString:@"工大助手"]) {
    [_show setTitle:@"喂程序猿星星吃" forState:UIControlStateNormal];
        [_show addTarget:self action:@selector(showAppStore) forControlEvents:UIControlEventTouchUpInside];
   }else if ([[_noticeShowData objectForKey:@"title"]isEqualToString:@"更新通知"]){
       [_show setTitle:@"去AppStore更新" forState:UIControlStateNormal];
       [_show addTarget:self action:@selector(showUpdate) forControlEvents:UIControlEventTouchUpInside];
   }
}
-(void)showAppStore{
    [Config showAppStore];
}
-(void)showUpdate{
    NSString *str = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1164848835&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)setTitle{
    self.navigationItem.title = @"通知详情";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end

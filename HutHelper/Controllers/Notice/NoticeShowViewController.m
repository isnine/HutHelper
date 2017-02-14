//
//  NoticeShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "NoticeShowViewController.h"

@interface NoticeShowViewController ()
@property (nonatomic,copy) NSDictionary      *noticeShowData;
@end

@implementation NoticeShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNoticeShowData];
    [self setBody];
    [self setTitle];
    
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
    _Body.text=[_noticeShowData objectForKey:@"body"];
    _Time.text=[_noticeShowData objectForKey:@"time"];
}
-(void)setTitle{
    self.navigationItem.title = @"通知详情";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

@end

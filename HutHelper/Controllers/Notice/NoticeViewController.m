//
//  NoticeViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeShowViewController.h"
#import "UMMobClick/MobClick.h"
#import "AppDelegate.h"
@interface NoticeViewController ()
@property (nonatomic,copy) NSArray      *noticeData;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNoticeData];
    [self setTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle{
    self.navigationItem.title = @"通知";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
}

#pragma mark - "设置表格代理"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _noticeData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:_noticeData[indexPath.section] forKey:@"NoticeShow"];
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NoticeShowViewController *View      = [main instantiateViewControllerWithIdentifier:@"NoticeShow"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:View animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeTableViewCell *cell=[NoticeTableViewCell tableViewCell];
    cell.Title.text=[self getTitle:(short)indexPath.section];
    cell.Time.text=[self getTime:(short)indexPath.section];
    cell.Body.text=[self getBody:(short)indexPath.section];
    return cell;
}
#pragma mark - 数据源
-(void)getNoticeData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _noticeData=[defaults objectForKey:@"Notice"];
}
-(NSString*)getTitle:(int)i{
    return [_noticeData[i] objectForKey:@"title"];
}
-(NSString*)getTime:(int)i{
    return [_noticeData[i] objectForKey:@"time"];
}
-(NSString*)getBody:(int)i{
    return [_noticeData[i] objectForKey:@"body"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"通知"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"通知"];
}
@end

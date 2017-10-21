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
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
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

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SYReal(180);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
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
    cell.tag=indexPath.section;
    //cell不可被选中
   [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - 数据源
-(void)getNoticeData{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _noticeData=[defaults objectForKey:@"Notice"];
}
-(NSString*)getTitle:(int)i{
    if ([[_noticeData[i] objectForKey:@"title"] isEqualToString:@""]) {
        return @"通知";
    }
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

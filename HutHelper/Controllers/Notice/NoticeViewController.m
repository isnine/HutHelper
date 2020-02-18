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
 
#import "AppDelegate.h"

@import EachNavigationBar_Objc;
@interface NoticeViewController ()
@property (nonatomic,copy) NSArray      *noticeData;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNoticeData];
    [self setTitle];
    [self setTitle1];
        
}

- (void) setTitle1{
        //self.navigation_bar.isShadowHidden = true;
        //self.navigation_bar.alpha = 0;
        /**按钮*/
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(5), 0, SYReal(25), SYReal(25))];
        UIView *rightButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
        
        mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
        [rightButtonView1 addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView1];
        self.navigation_item.leftBarButtonItem  = rightCunstomButtonView1;
    }
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle{
    self.navigation_item.title = @"通知";
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

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
@end

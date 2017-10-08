//
//  VedioTableViewController.m
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioTableViewController.h"
#import "VedioTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "Vedio.h"
#import "MJRefresh.h"
#import "APIRequest.h"
#import "Config+Api.h"
#import "UIScrollView+EmptyDataSet.h"
@interface VedioTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation VedioTableViewController{
    NSMutableArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"视频专栏";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];


    if (!([[Config getVedio] isEqual:[NSNull null]]||
          [Config getVedio]==nil)) {
        NSDictionary *Dic=[Config getVedio];
        [self loadData:Dic[@"links"]];
        [Config saveVedio480p:Dic[@"480P"]];
        [Config saveVedio720p:Dic[@"720P"]];
        [Config saveVedio1080p:Dic[@"1080P"]];
    }
    //空白状态
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
     MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
    self.tableView.mj_header = header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    


}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
    if (datas.count==0) {
        return 0;
    }
    return (datas.count+2)/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//每块几部分
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
    if (indexPath.section==0) {
        return SYReal(270);
    }else{
        return SYReal(173);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier=@"VedioTableViewCell";
    VedioTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"VedioTableViewCell"];
    if (!cell) {
        cell=[[VedioTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }else{
        while ([cell.contentView.subviews lastObject]) {
            [(UIView*)[cell.contentView.subviews lastObject]removeFromSuperview];
        }
    }
    if (datas.count>=1) {
            [self drawCell:cell withIndexPath:indexPath];
    }
    return cell;
}
-(void)drawCell:(VedioTableViewCell*)cell withIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        cell.dataLeft=datas[0];
        [cell drawTop];
    }else{
        cell.dataLeft=datas[indexPath.section*2-1];
        [cell drawLeft];
        if (datas.count>indexPath.section*2) {
            cell.dataRight=datas[indexPath.section*2];
            [cell drawRight];
        }
    }
}
#pragma mark - 处理数据
-(void)loadData:(NSDictionary*)JSONDic{
    datas=[[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONDic) {
        Vedio *momentsModel=[[Vedio alloc]initWithDic:eachDic];
        [datas addObject:momentsModel];
    }
}
-(void)reload{
    [Config setNoSharedCache];
    [APIRequest GET:Config.getApiVedioShow parameters:nil success:^(id responseObject) {
        [Config saveVedio:responseObject];
        [self loadData:responseObject[@"links"]];
        [Config saveVedio480p:responseObject[@"480P"]];
        [Config saveVedio720p:responseObject[@"720P"]];
        [Config saveVedio1080p:responseObject[@"1080P"]];
        [self loadData:responseObject[@"links"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络错误"toView:self.view];
    }];
}
#pragma mark - 空白状态代理
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ui_tableview_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无相关内容";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"请检查网络并重试";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(238, 239, 240, 1);
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    [self.tableView.mj_header beginRefreshing];
}
@end

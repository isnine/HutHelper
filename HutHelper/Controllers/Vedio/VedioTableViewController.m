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
#import "VedioModel.h"
#import "MJRefresh.h"
#import "APIRequest.h"
#import "Config+Api.h"
@interface VedioTableViewController ()

@end

@implementation VedioTableViewController{
    NSMutableArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"视频专栏";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSDictionary *Dic=[Config getVedio];
    [self loadData:Dic[@"links"]];
    [Config saveVedio480p:Dic[@"480P"]];
    [Config saveVedio720p:Dic[@"720P"]];
    [Config saveVedio1080p:Dic[@"1080P"]];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
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
    [self drawCell:cell withIndexPath:indexPath];
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
        VedioModel *momentsModel=[[VedioModel alloc]initWithDic:eachDic];
        [datas addObject:momentsModel];
    }
}
-(void)reload{
    [Config setNoSharedCache];
    [APIRequest GET:Config.getApiVedioShow parameters:nil success:^(id responseObject) {
        [Config saveVedio:responseObject];
        [self loadData:responseObject[@"links"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
@end

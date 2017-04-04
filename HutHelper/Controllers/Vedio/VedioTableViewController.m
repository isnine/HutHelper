//
//  VedioTableViewController.m
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioTableViewController.h"
#import "VedioTableViewCell.h"
#import "VedioTopTableViewCell.h"
@interface VedioTableViewController ()

@end

@implementation VedioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"视频专栏";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//每块几部分
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
    if (indexPath.section==0) {
        return 228;
    }
    return 143;
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
    if (indexPath.section==0) {
        VedioTopTableViewCell *cellTop=[[VedioTopTableViewCell alloc]init];
        return cellTop;
    }
    VedioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContacterTableCell"];
    if (!cell) {
        cell = (VedioTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"VedioTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

@end

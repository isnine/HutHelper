//
//  UserViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/19.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UserViewController.h"
#import "JSHeaderView.h"
#import "UserInfoCell.h"

static NSString *const kUserInfoCellId = @"kUserInfoCellId";

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JSHeaderView *headerView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView = [[JSHeaderView alloc] initWithImage:[UIImage imageNamed:@"header.jpg"]];
    [self.headerView reloadSizeWithScrollView:self.tableView];
    self.navigationItem.titleView = self.headerView;
    
    [self.headerView handleClickActionWithBlock:^{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您点击了头像" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
    }];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *username=[defaults objectForKey:@"username"]; //昵称
    if([username isEqual:[NSNull null]]){
        username=@"1";
    }
    else{
        username=@"2";
    }
    NSLog(@"%@",username);
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark - tableView protocal methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 183.f;
    }
    return 85.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *TrueName=[defaults objectForKey:@"TrueName"]; //真实姓名
    NSString *studentKH=[defaults objectForKey:@"studentKH"]; //学号
    NSString *dep_name=[defaults objectForKey:@"dep_name"]; //学院
    NSString *class_name=[defaults objectForKey:@"class_name"];  //班级
    NSString *sex=[defaults objectForKey:@"sex"];  //性别
    if(sex ==NULL){
        sex=@"";
    }
    if (indexPath.row == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }
    if(indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@", TrueName];
        return cell;
    }
    if(indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"性别:%@", sex];
        return cell;
    }
    if(indexPath.row == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"学号:%@", studentKH];
        return cell;
    }
    if(indexPath.row == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"学院:%@", dep_name];
        return cell;
    }
    if(indexPath.row == 5){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"班级:%@", class_name];
        return cell;
    }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
return cell;
   // cell.textLabel.text = [NSString stringWithFormat:@"ro %zd", indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
   [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
@end

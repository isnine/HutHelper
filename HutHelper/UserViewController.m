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
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

static NSString *const kUserInfoCellId = @"kUserInfoCellId";

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy)NSString *m_auth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JSHeaderView *headerView;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"head_pic_thumb"]!=NULL) {
        NSString *image_url=[defaults objectForKey:@"head_pic_thumb"];
        image_url=[@"http://218.75.197.121:8888/" stringByAppendingString:image_url];
        NSURL *url                   = [NSURL URLWithString: image_url];//接口地址
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=NULL&&![image_url isEqualToString:@"http://218.75.197.121:8888/"]) {
            self.headerView = [[JSHeaderView alloc] initWithImage:[UIImage imageWithData:data]];
        }
        else{
            self.headerView = [[JSHeaderView alloc] initWithImage:[UIImage imageNamed:@"header.jpg"]];
        }
    }
    else{
        self.headerView = [[JSHeaderView alloc] initWithImage:[UIImage imageNamed:@"header.jpg"]];
    }

    //  image = [UIImage imageWithData:data];
    
    
    [self.headerView reloadSizeWithScrollView:self.tableView];
    self.navigationItem.titleView = self.headerView;
    
    [self.headerView handleClickActionWithBlock:^{
        //        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        UserViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Uploadimage"];
        //        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
  //      [self postimage];
    }];
    NSString *username=[defaults objectForKey:@"username"]; //昵称
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)postimage
{
    NSURL* url = [NSURL URLWithString:@"http://hugongda.com:8888/api/v1/set/avatar/15408500245/c03a85370646b557e27c175ab4b4dc099516de2c"];//此处省略请求url
    UIImage* img = [UIImage imageNamed:@"header.jpg"];
    NSData* data = UIImagePNGRepresentation(img);
    //ASIFormDataRequest请求是post请求，可以查看其源码
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    request.tag = 20;
    request.delegate = self;
    [request setPostValue:self.m_auth forKey:@"m_auth"];
    //    [request setFile:@"tabbar.png" forKey:@"haoyou"];//如果有路径，上传文件
    [request setData:data  withFileName:@"header.jpg" andContentType:@"image/jpg" forKey:@"file"];
    //               数据                文件名,随便起                 文件类型            设置key
    [request startAsynchronous];
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

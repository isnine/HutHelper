//
//  MomentsTableViewController.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "YYFPSLabel.h"
#import "MomentsCell.h"
#import "MomentsModel.h"
#import "AFNetworking.h"
#import "UILabel+LXAdd.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "Config.h"
@interface MomentsTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation MomentsTableViewController{
    NSMutableArray *dataSource;
    NSMutableArray *needLoadArr;
    UILabel *contentLabel;
    int num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    /** FTP */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    
    self.tableView=[[UITableView alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    dataSource = [[NSMutableArray alloc]init];
    needLoadArr = [[NSMutableArray alloc] init];
    /** 加载数据 */
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *JSONDic=[defaults objectForKey:@"Say"];
    [self loadData:JSONDic];
    num=1;
    
    
    if([Config getIs]==0){
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
        //        /**按钮*/
        //        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        //        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        //        [rightButtonView addSubview:mainAndSearchBtn];
        //        [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
        //        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        //        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        //        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        
    }else{
        MomentsModel *momentsModel=dataSource[0];
        if(momentsModel.username){
            self.navigationItem.title = [NSString stringWithFormat:@"%@的说说",momentsModel.username];
        }
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)drawCell:(MomentsCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = [dataSource objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = data;
    [cell draw];
}
#pragma mark - 处理数据
-(void)loadData:(NSDictionary*)JSONDic{
    for (NSDictionary *eachDic in JSONDic) {
        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
        [dataSource addObject:momentsModel];
    }
}
-(void)reLoadData:(NSDictionary*)JSONDic{
    dataSource = [[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONDic) {
        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
        [dataSource addObject:momentsModel];
    }
}
#pragma mark - 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentsModel *momentsModel=dataSource[indexPath.section];
    return SYReal(70)+momentsModel.textHeight+momentsModel.photoHeight+SYReal(30)+momentsModel.commentsHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MomentsCell" ];
    //    if (!cell) {
    cell=[[MomentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MomentsCell"];
    //    }
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}
#pragma mark - 加载方法
-(void)reload{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,num];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [self reLoadData:Say_content];
                     [MBProgressHUD showSuccess:@"刷新成功"];
                     HideAllHUD
                     [self.tableView.mj_header endRefreshing];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.mj_header endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.tableView.mj_header endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.mj_header endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(void)load{
    num++;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,num];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [self loadData:Say_content];
                     HideAllHUD
                     [self.tableView.mj_footer endRefreshing];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.mj_footer endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                     num--;
                 }
             }
             else{
                 [self.tableView.mj_footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
                 num--;
             }
             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.mj_footer endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
             num--;
         }];
}
@end

//
//  HandTableViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandTableViewController.h"
#import "HandTableViewCell.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "HandShowViewController.h"
#import "AppDelegate.h"
#import "AddhandViewController.h"
#import "Config.h"
#import "User.h"
#import "YYModel.h"
#import "YCXMenu.h"
@interface HandTableViewController ()
@property (nonatomic,copy) NSArray      *Hand_content;
@property (nonatomic , strong) NSMutableArray *items;
@property int num;
@end

@implementation HandTableViewController
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**加载数据*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _Hand_content=[defaults objectForKey:@"Hand"];
    if ([Config getIs]==0) {
        /**按钮*/
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        //下拉刷新
        self.navigationItem.title=@"二手市场";
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
        //上拉加载
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
    }else{
        self.navigationItem.title=@"我的发布";
    }
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    _num=1;
    NSLog(@"%@",_Hand_content[1]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
    
    return _Hand_content.count/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//每块几部分
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
        return 240;
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
    HandTableViewCell *cell = [HandTableViewCell tableviewcell];

    cell.price1.text=[self getprize:(short)(indexPath.section+1)*2-1];
    cell.name1.text=[self getName:(short)(indexPath.section+1)*2-1];
    cell.time1.text=[self gettime:(short)(indexPath.section+1)*2-1];
    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)(indexPath.section+1)*2-1]]
                      placeholderImage:[UIImage imageNamed:@"load_img"]];
    if (_Hand_content.count>(indexPath.section+1)*2) {
        cell.price2.text=[self getprize:(short)(indexPath.section+1)*2];
        cell.name2.text=[self getName:(short)(indexPath.section+1)*2];
        cell.time2.text=[self gettime:(short)(indexPath.section+1)*2];
        cell.Button2.hidden=false;
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)(indexPath.section+1)*2]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -"其他"
-(void)addHand{
    UIStoryboard *Main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddhandViewController *Add=[Main instantiateViewControllerWithIdentifier:@"Addhand"];
    AppDelegate *temp=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [temp.mainNavigationController pushViewController:Add animated:YES];
}
-(void)myHand{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary  *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_GOODS_USER,user.studentKH,[defaults objectForKey:@"remember_code_app"]];
    /**设置9秒超时*/
    NSLog(@"%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             NSMutableArray *data;
//             NSArray *array;
//             NSMutableDictionary *dic1=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObject:responseObject forKey:@""]];
             NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
             NSArray *Hand           = [dic1 objectForKey:@""];
             if (Hand.count!=0) {
                 NSMutableArray *data=[[NSMutableArray alloc]init];
                 [data addObject:_Hand_content[0]];
                 [data addObjectsFromArray:Hand];
                 NSArray *Hands = [NSArray arrayWithArray:data];
                 [defaults setObject:Hands forKey:@"Hand"];
                 [defaults synchronize];
                 HideAllHUD
                 [Config setIs:1];
                 HandTableViewController *hand=[[HandTableViewController alloc]init];
                 AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
             }else{
                 HideAllHUD
                 [MBProgressHUD showError:@"您没有发布的商品"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络超时，请检查网络并重试"];
             HideAllHUD
         }];
}
#pragma mark - 菜单
-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    //    [YCXMenu setTitleFont:[UIFont systemFontOfSize:19.0]];
    //    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
        }];
    }
    
}

- (NSMutableArray *)items {
    if (!_items) {
        
        //        // set title
        //        YCXMenuItem *firstTitle = [YCXMenuItem firstTitle:@"添加失物" WithIcon:nil];
        //        firstTitle.foreColor = [UIColor whiteColor];
        //        firstTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        YCXMenuItem *firstTitle = [YCXMenuItem menuItem:@"添加商品" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addHand)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *SecondTitle = [YCXMenuItem menuItem:@"我的发布" image:[UIImage imageNamed:@"mine"] target:self action:@selector(myHand)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        
        //        //set item
        _items = [@[firstTitle,
                    //                    [YCXMenuItem menuItem:@"个人中心"
                    //                                    image:nil
                    //                                      tag:100
                    //                                 userInfo:@{@"title":@"Menu"}],
                    //                    [YCXMenuItem menuItem:@"ACTION 133"
                    //                                    image:nil
                    //                                      tag:101
                    //                                 userInfo:@{@"title":@"Menu"}],
                    //                    [YCXMenuItem menuItem:@"检查更新"
                    //                                    image:nil
                    //                                      tag:102
                    //                                 userInfo:@{@"title":@"Menu"}],
                    SecondTitle
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}
-(NSString*)getPhoto:(int)i{
    NSString *photo=[_Hand_content[i] objectForKey:@"image"];
    NSString *Url=[NSString stringWithFormat:API_IMG,photo];
    return Url;
}
-(UIImage*)getImg:(int)i{
        NSString *Url=[NSString stringWithFormat:API_IMG,[_Hand_content[i] objectForKey:@"image"]];
        NSURL *imageUrl = [NSURL URLWithString:Url];
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
}
-(NSString*)getName:(int)i{
    return [_Hand_content[i] objectForKey:@"title"];
}
-(NSString*)getprize:(int)i{
    return [_Hand_content[i] objectForKey:@"prize"];
}
-(NSString*)gettime:(int)i{
    return [_Hand_content[i] objectForKey:@"created_on"];
}
-(NSNumber*)getMaxPage{
    return [_Hand_content[0] objectForKey:@"page_max"];
}

-(void)reload{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_GOODS,_num];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
             NSArray *Hand           = [dic1 objectForKey:@""];
             [defaults setObject:Hand forKey:@"Hand"];
             [defaults synchronize];
             _Hand_content=Hand;
             [self.tableView reloadData];
             [self.tableView.mj_header endRefreshing];
             [MBProgressHUD showSuccess:@"刷新成功"];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             [self.tableView.mj_header endRefreshing];
             HideAllHUD
         }];
}

-(void)load{
    _num++;
    if (_num<=[[self getMaxPage] intValue]) {
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:0
                                                                    diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        /**拼接地址*/
        NSString *Url_String=[NSString stringWithFormat:API_GOODS,_num];
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 4.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
                 NSArray *Hand           = [dic1 objectForKey:@""];
                 [defaults setObject:Hand forKey:@"Hand"];
                 [defaults synchronize];
                 _Hand_content=Hand;
                 NSString *num_string=[NSString stringWithFormat:@"第%d页",_num];
                 self.navigationItem.title = num_string;
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                 [self.tableView reloadData];
                 [self.tableView.mj_footer endRefreshing];
                 self.tableView.mj_header.hidden = YES;
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD showError:@"网络错误"];
                 _num--;
                 [self.tableView.mj_footer endRefreshing];
                 HideAllHUD
             }];
    }else{
        [MBProgressHUD showError:@"当前已是最大页数"];
        [self.tableView.mj_footer endRefreshing];
    }
  
    
}
@end

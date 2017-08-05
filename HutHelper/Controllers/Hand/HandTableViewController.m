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
#import "AppDelegate.h"
#import "HandAddViewController.h"
#import "User.h"
#import "Hand.h"
#import "YCXMenu.h"
#import "UIScrollView+EmptyDataSet.h"
@interface HandTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,copy) NSArray      *handAllArray;
@property (nonatomic, copy) NSMutableArray      *handArray;
@property (nonatomic , strong) NSMutableArray *items;
@property int num;
@end

@implementation HandTableViewController
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor=RGB(239, 239, 239, 1);
    //加载数据
    if (!_myHandArray) {
        [self reloadData:[Config getHand]];
       // _Hand_content=[Config getHand];
        //按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        //空白状态
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.tableFooterView = [UIView new];
        //下拉刷新
        self.navigationItem.title=@"二手市场";
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
        self.tableView.mj_header = header;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
        [self.tableView.mj_header beginRefreshing];
        //MJRefresh适配iOS11
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
        
    }else{
        [self reloadData:_myHandArray];
        //[self.tableView reloadData];
        self.navigationItem.title=@"我的发布";
    }
    // 标题栏样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    _num=1;

}

#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
    return _handArray.count/2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//每块几部分
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
    return SYReal(250);
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
    HandTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HandTableViewCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"HandTableViewCell" owner:self options:nil]lastObject];
    }else{
        
    }
    cell.tag=indexPath.section;
    Hand *hand=_handArray[(short)(indexPath.section+1)*2-1];
    cell.price1.text=[NSString stringWithFormat:@"¥%@",hand.prize];
    cell.name1.text=hand.title;
    cell.time1.text=hand.created_on;
    cell.img1.contentMode =UIViewContentModeScaleAspectFill;
    cell.img1.clipsToBounds = YES;
    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Config.getApiImg,hand.image]]
                 placeholderImage:[UIImage imageNamed:@"load_img"]];
    if (_handArray.count>(indexPath.section+1)*2) {
        Hand *hand=_handArray[(short)(indexPath.section+1)*2];
        cell.price2.text=[NSString stringWithFormat:@"¥%@",hand.prize];
        cell.name2.text=hand.title;
        cell.time2.text=hand.created_on;
        cell.Button2.hidden=false;
        cell.blackImg2.hidden=false;
        cell.shadowblack2.hidden=false;
        cell.price2.hidden=false;
        cell.img2.contentMode =UIViewContentModeScaleAspectFill;
        cell.img2.clipsToBounds = YES;
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Config.getApiImg,hand.image]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
    }
        cell.handArray=_handArray;
    return cell;
}

#pragma mark - 其他
-(void)addHand{
    HandAddViewController *handAddViewController=[[HandAddViewController alloc]init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:handAddViewController animated:YES];
}
-(void)myHand{
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [APIRequest GET:Config.getApiGoodsUser parameters:nil success:^(id responseObject) {
        HideAllHUD
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
        NSArray *Hand           = [dic1 objectForKey:@""];
        if (Hand.count!=0) {
            NSMutableArray *data=[[NSMutableArray alloc]init];
            [data addObject:_handAllArray[0]];
            [data addObjectsFromArray:Hand];
//            NSArray *Hands = [NSArray arrayWithArray:data];
//            [defaults setObject:Hands forKey:@"otherHand"];
//            [defaults synchronize];
//
//            [Config setIs:1];
            HandTableViewController *hand=[[HandTableViewController alloc]init];
            hand.myHandArray=[data mutableCopy];
            AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
        }else{
           
            [MBProgressHUD showError:@"您没有发布的商品" toView:self.view];
        }
    }failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络超时" toView:self.view];
        HideAllHUD
    }];
}
#pragma mark - 菜单
-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        }];
    }
}

- (NSMutableArray *)items {
    if (!_items) {
        YCXMenuItem *firstTitle = [YCXMenuItem menuItem:@"添加商品" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addHand)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *SecondTitle = [YCXMenuItem menuItem:@"我的发布" image:[UIImage imageNamed:@"mine"] target:self action:@selector(myHand)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        _items = [@[firstTitle,
                    SecondTitle
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}
#pragma mark - 数据

-(void)reloadData:(NSArray*)JSONArray{
    _handArray = [[NSMutableArray alloc]init];
    [_handArray  removeAllObjects];
    for (NSDictionary *eachDic in JSONArray) {
        Hand *handModel=[[Hand alloc]initWithDic:eachDic];
        [self.handArray addObject:handModel];
    }
    
}
-(void)loadData:(NSArray*)JSONArray{
    for (int i=1; i<JSONArray.count; i++) {
        NSDictionary *eachDic=JSONArray[i];
        Hand *handModel=[[Hand alloc]initWithDic:eachDic];
        [self.handArray addObject:handModel];
    }
}

-(void)reload{
    [Config setNoSharedCache];
    [APIRequest GET:[Config getApiGoods:_num] parameters:nil success:^(id responseObject) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
        _handAllArray           = [dic1 objectForKey:@""];
        [Config saveHand:_handAllArray];
        [self reloadData:_handAllArray];
      //  _Hand_content=Hand;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"toView:self.view];
        [self.tableView.mj_header endRefreshing];
        HideAllHUD
    }];
}

-(void)load{
    _num++;
        [Config setNoSharedCache];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        //拼接地址*/
        [APIRequest GET:[Config getApiGoods:_num] parameters:nil success:^(id responseObject) {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
            NSArray *Hand           = [dic1 objectForKey:@""];
            [defaults setObject:Hand forKey:@"Hand"];
            [defaults synchronize];
            [self loadData:Hand];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_header.hidden = YES;
        }failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误"toView:self.view];
            _num--;
            [self.tableView.mj_footer endRefreshing];
            HideAllHUD
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
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
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

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
#import "HandAddViewController.h"
#import "User.h"
#import "YCXMenu.h"
#import "UIScrollView+EmptyDataSet.h"
@interface HandTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
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
    if ([Config getIs]==0) {
        _Hand_content=[Config getHand];
        /**按钮*/
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
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
        [self.tableView.mj_header beginRefreshing];
    }else{
        _Hand_content=[Config getOtherHand];
        self.navigationItem.title=@"我的发布";
    }
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    _num=1;

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
        NSLog(@"被重用了%d",indexPath.section);
    }
    cell.price1.text=[NSString stringWithFormat:@"¥%@",[self getprize:(short)(indexPath.section+1)*2-1]];
    cell.name1.text=[self getName:(short)(indexPath.section+1)*2-1];
    cell.time1.text=[self gettime:(short)(indexPath.section+1)*2-1];
    cell.img1.contentMode =UIViewContentModeScaleAspectFill;
    cell.img1.clipsToBounds = YES;
    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)(indexPath.section+1)*2-1]]
                 placeholderImage:[UIImage imageNamed:@"load_img"]];
    if (_Hand_content.count>(indexPath.section+1)*2) {
        cell.price2.text=[self getprize:(short)(indexPath.section+1)*2];
        cell.name2.text=[self getName:(short)(indexPath.section+1)*2];
        cell.time2.text=[self gettime:(short)(indexPath.section+1)*2];
        cell.Button2.hidden=false;
        cell.img2.contentMode =UIViewContentModeScaleAspectFill;
        cell.img2.clipsToBounds = YES;
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)(indexPath.section+1)*2]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -"其他"
-(void)addHand{
    [Config pushViewController:@"Addhand"];
}
-(void)myHand{
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [APIRequest GET:Config.getApiGoodsUser parameters:nil success:^(id responseObject) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
        NSArray *Hand           = [dic1 objectForKey:@""];
        if (Hand.count!=0) {
            NSMutableArray *data=[[NSMutableArray alloc]init];
            [data addObject:_Hand_content[0]];
            [data addObjectsFromArray:Hand];
            NSArray *Hands = [NSArray arrayWithArray:data];
            [defaults setObject:Hands forKey:@"otherHand"];
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
    }failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络超时"];
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
    NSString *Url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,photo];
    return Url;
}
-(UIImage*)getImg:(int)i{
    NSString *Url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,[_Hand_content[i] objectForKey:@"image"]];
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
    [Config setNoSharedCache];
    NSString *Url_String=[NSString stringWithFormat: @"%@/%d",Config.getApiGoods,_num];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
        NSArray *Hand           = [dic1 objectForKey:@""];
        [Config saveHand:Hand];
        _Hand_content=Hand;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [self.tableView.mj_header endRefreshing];
        HideAllHUD
    }];
}

-(void)load{
    _num++;
    if (_num<=[[self getMaxPage] intValue]) {
        [Config setNoSharedCache];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        /**拼接地址*/
        NSString *Url_String=[NSString stringWithFormat: @"%@/%d",Config.getApiGoods,_num];
        [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
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
        }failure:^(NSError *error) {
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

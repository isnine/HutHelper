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

@import EachNavigationBar_Objc;

@interface HandTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, copy) NSArray *handAllArray;
@property (nonatomic, copy) NSMutableArray *handArray;
@property (nonatomic, strong) NSMutableArray *items;
@property int num;
@end

@implementation HandTableViewController
@synthesize items = _items;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    self.view.backgroundColor = RGB(239, 239, 239, 1);

    self.type = 1;
    //    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    //    [mainAndSearchBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //    self.navigationItem.backBarButtonItem = mainAndSearchBtn;


    //加载数据
    if (_myHandArray) {
        [self reloadData:_myHandArray];
        self.isSelfGoods = YES;
        self.navigation_item.title = @"我的发布";
    } else if (_otherHandArray) {
        _myHandArray = _otherHandArray;
        [self reloadData:_myHandArray];
        self.isSelfGoods = YES;
        self.navigation_item.title = [NSString stringWithFormat:@"%@的发布", self.otherName];
    } else {
        [self reloadData:[Config getHand]];
        //         _Hand_content=[Config getHand];
        //按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigation_item.rightBarButtonItem = rightCunstomButtonView;
        self.navigation_bar.isShadowHidden = YES;
        //self.navigation_bar.alpha = 0;
        //空白状态
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.tableFooterView = [UIView new];
        //下拉刷新
        self.navigation_item.title = @"二手市场";
        MJRefreshNormalHeader *header =
            [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
        self.tableView.mj_header = header;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
        [self.tableView.mj_header beginRefreshing];
        //发布or求购选项
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(38))];
        headView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:250 / 255.0 blue:252 / 255.0 alpha:1];
        UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth / 2, SYReal(38))];
        [publishBtn setTitle:@"出售" forState:UIControlStateNormal];
        [publishBtn setTitleColor:RGB(100, 216, 228, 1) forState:UIControlStateNormal];
        [publishBtn addTarget:self action:@selector(publishBtn) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:publishBtn];
        //        UIImageView *noticeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(40))];
        //        noticeImgView.image=[UIImage imageNamed:@"img_exam_notice"];
        UIButton *needBtn = [[UIButton alloc] initWithFrame:CGRectMake(DeviceMaxWidth / 2, 0, DeviceMaxWidth / 2, SYReal(38))];
        [needBtn setTitleColor:RGB(100, 216, 228, 1) forState:UIControlStateNormal];
        [needBtn addTarget:self action:@selector(needBtn) forControlEvents:UIControlEventTouchUpInside];
        [needBtn setTitle:@"求购" forState:UIControlStateNormal];
        [headView addSubview:needBtn];

        self.tableView.tableHeaderView = headView;
    }
    // 标题栏样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94 / 255.0 green:199 / 255.0 blue:217 / 255.0 alpha:1]];
    _num = 1;
    [self setTitle];
        
}

- (void) setTitle{
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
- (void)publishBtn
{
    self.type = 1;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = false;
}
- (void)needBtn
{
    self.type = 2;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = true;
}
#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{//多少块
    return (_handArray.count + 1) / 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{//每块几部分
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{///每块的高度
    return SYReal(250);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HandTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:self options:nil] lastObject];
    }


    cell.tag = indexPath.section;
    Hand *hand = _handArray[(short)(indexPath.section) * 2];
    cell.price1.text = [NSString stringWithFormat:@"¥%@", hand.prize];
    cell.name1.text = hand.title;
    cell.time1.text = hand.created_on;
    cell.img1.contentMode = UIViewContentModeScaleAspectFill;
    cell.img1.clipsToBounds = YES;
    [cell.img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Config.getApiImg, hand.image]]
                 placeholderImage:[UIImage imageNamed:@"load_img"]];
    if (_handArray.count > (short)(indexPath.section) * 2 + 1) {
        hand = _handArray[(short)(indexPath.section) * 2 + 1];
        cell.price2.text = [NSString stringWithFormat:@"¥%@", hand.prize];
        cell.name2.text = hand.title;
        cell.time2.text = hand.created_on;
        cell.Button2.hidden = false;
        cell.blackImg2.hidden = false;
        cell.shadowblack2.hidden = false;
        cell.price2.hidden = false;
        cell.img2.contentMode = UIViewContentModeScaleAspectFill;
        cell.img2.clipsToBounds = YES;
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Config.getApiImg, hand.image]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
    }


    cell.handArray = _handArray;
    cell.isSelfGoods = self.isSelfGoods;
    return cell;
}

#pragma mark - 其他
- (void)addHand
{
    HandAddViewController *handAddViewController = [[HandAddViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:handAddViewController animated:YES];
}
- (void)addNeedHand
{
    HandAddViewController *handAddViewController = [[HandAddViewController alloc] init];
    handAddViewController.isNeed = TRUE;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:handAddViewController animated:YES];
}
- (void)myHand
{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [APIRequest GET:Config.getApiUserIsTrue
        parameters:nil
        success:^(id responseObject) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([response[@"code"] boolValue] == true) {
                [APIRequest GET:Config.getApiGoodsUser
                    parameters:nil
                    success:^(id responseObject) {
                        HideAllHUD
                            //如果没有发布商品


                            //获取二手数据
                            NSArray *Hand
                            = [responseObject objectForKey:@"goods"];
                        if (Hand.count == 0) {
                            [MBProgressHUD showError:@"您没有发布的商品" toView:self.view];
                            return;
                        }
                        if (Hand.count > 0) {
                            NSMutableArray *data = [[NSMutableArray alloc] init];
                            //                    NSDictionary *a=@{@"page_cur":@"1",
                            //                                      @"page_max":@67
                            //                                      };
                            //                    [data addObject:a];
                            [data addObjectsFromArray:Hand];
                            HandTableViewController *hand = [[HandTableViewController alloc] init];
                            hand.myHandArray = [data mutableCopy];
                            [self.navigationController pushViewController:hand animated:YES];
                        } else {
                            [MBProgressHUD showError:@"您没有发布的商品" toView:self.view];
                        }
                    }
                    failure:^(NSError *error) {
                        [MBProgressHUD showError:@"网络超时" toView:self.view];
                        HideAllHUD
                    }];
            } else {
                HideAllHUD [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
                return;
            }
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
            return;
        }];
}
#pragma mark - 菜单
- (void)menu
{
    [YCXMenu setTintColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]];
    if ([YCXMenu isShow]) {
        [YCXMenu dismissMenu];
    } else {
        UIView *blindView = [[UIView alloc]
            initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        blindView.backgroundColor = [UIColor blackColor];
        blindView.alpha = 0.5;
        blindView.tag = 99;
        [[[UIApplication sharedApplication] keyWindow] addSubview:blindView];

        [YCXMenu showMenuInView:[[UIApplication sharedApplication] keyWindow]
                       fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0)
                      menuItems:self.items
                       selected:^(NSInteger index, YCXMenuItem *item){
                       }];
    }
}

- (NSMutableArray *)items
{
    if (!_items) {
        YCXMenuItem *firstTitle =
            [YCXMenuItem menuItem:@"出售物品" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addHand)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        YCXMenuItem *firstTitle2 =
            [YCXMenuItem menuItem:@"求购物品" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addNeedHand)];
        firstTitle2.foreColor = [UIColor blackColor];
        firstTitle2.alignment = NSTextAlignmentCenter;
        // set logout button
        YCXMenuItem *SecondTitle =
            [YCXMenuItem menuItem:@"我的发布" image:[UIImage imageNamed:@"mine"] target:self action:@selector(myHand)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        _items = [@[ firstTitle, firstTitle2, SecondTitle ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
}
- (id)init
{
    self = [super init];
    if (self != nil) {
        //监听一个通知，当收到通知时，调用notificationAction方法
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeYCXMenuBlind)
                                                     name:@"YCXMenuWillDisappearNotification"
                                                   object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YCXMenuWillDisappearNotification" object:nil];
}
- (void)removeYCXMenuBlind
{
    UIView *blindView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:99];
    [blindView removeFromSuperview];
}
#pragma mark - 数据

- (void)reloadData:(NSArray *)JSONArray
{
    _handArray = [[NSMutableArray alloc] init];
    [_handArray removeAllObjects];
    for (NSDictionary *eachDic in JSONArray) {
        Hand *handModel = [[Hand alloc] initWithDic:eachDic];
        [self.handArray addObject:handModel];
    }
}
- (void)loadData:(NSArray *)JSONArray
{
    for (int i = 0; i < JSONArray.count; i++) {
        NSDictionary *eachDic = JSONArray[i];
        Hand *handModel = [[Hand alloc] initWithDic:eachDic];
        [self.handArray addObject:handModel];
    }
}

- (void)reload
{
    [Config setNoSharedCache];
    [APIRequest GET:[Config getApiGoods:_num type:(short)self.type]
        parameters:nil
        success:^(id responseObject) {
            _handAllArray = responseObject[@"goods"];
            [Config saveHand:_handAllArray];
            [self reloadData:_handAllArray];
            //  _Hand_content=Hand;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误" toView:self.view];
            [self.tableView.mj_header endRefreshing];
            HideAllHUD
        }];
}

- (void)load
{
    _num++;
    [Config setNoSharedCache];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //拼接地址*/
    [APIRequest GET:[Config getApiGoods:_num type:(short)self.type]
        parameters:nil
        success:^(id responseObject) {
            NSArray *Hand = responseObject[@"goods"];
            [defaults setObject:Hand forKey:@"Hand"];
            [defaults synchronize];
            [self loadData:Hand];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_header.hidden = YES;
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误" toView:self.view];
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
    NSDictionary *attributes =
        @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName : [UIColor lightGrayColor] };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请检查网络并重试";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
        NSForegroundColorAttributeName : [UIColor lightGrayColor],
        NSParagraphStyleAttributeName : paragraph
    };
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

//
//  MomentsViewController.m
//  HutHelper
//
//  Created by Nine on 2017/3/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsViewController.h"
#import "MomentsModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "YYFPSLabel.h"
#import "MomentsCell.h"
#import "YCXMenu.h"
#import "User.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MomentsAddViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "LikesModel.h"
#import "HutHelper-Swift.h"

@interface MomentsViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    NSMutableArray *datas;
    LikesModel *likeDatas;
    int num;
}
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end
@implementation MomentsViewController
@synthesize items = _items;

- (void)viewWillAppear:(BOOL)animated{
//        if([Config getIs]==0 && [_keyWord isEqualToString:@""]){
//           [self beginload];
//        }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    //关闭tableview的横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //适配iOS11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    /** FTP */
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    if([Config getIs]==0){
        if ([_keyWord isEqualToString:@""])
        {
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        self.
        //加载缓存数据
        self.JSONDic=[Config getSay];
        self.LikesDic=[Config getSayLike];
        [self reLoadData:self.JSONDic];
        [self loadLikesData:self.LikesDic];
        //下拉刷新
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        // self.tableFooterView = [UIView new];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
        self.tableView.mj_header = header;
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
         // 马上进入刷新状态
       [self beginload];
        num=1;
        }else if([_keyWord isEqualToString:@"./#MyTalk#"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"我的互动"];
         self.tableView.emptyDataSetSource = self;
         self.tableView.emptyDataSetDelegate = self;
         // self.tableFooterView = [UIView new];
         MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reloadSearch))];
         self.tableView.mj_header = header;
         // 设置自动切换透明度(在导航栏下面自动隐藏)
         header.automaticallyChangeAlpha = YES;
         // 隐藏时间
         header.lastUpdatedTimeLabel.hidden = YES;
        // self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadSearch)];
          // 马上进入刷新状态
        [self beginload];
         num=1;
            
        }else if([_keyWord isEqualToString:@"./#hotTalk#"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"热门说说"];
         self.tableView.emptyDataSetSource = self;
         self.tableView.emptyDataSetDelegate = self;
         // self.tableFooterView = [UIView new];
         MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reloadSearch))];
         self.tableView.mj_header = header;
         // 设置自动切换透明度(在导航栏下面自动隐藏)
         header.automaticallyChangeAlpha = YES;
         // 隐藏时间
         header.lastUpdatedTimeLabel.hidden = YES;
        // self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadSearch)];
          // 马上进入刷新状态
        [self beginload];
         num=1;
        }else {
            NSLog(@"调用此方法");
             //加载缓存数据
            self.navigationItem.title = [NSString stringWithFormat:@"关于“%@”",_keyWord];
//             self.JSONDic=[Config getSay];
//             self.LikesDic=[Config getSayLike];
//             [self reLoadData:self.JSONDic];
//             [self loadLikesData:self.LikesDic];
             //下拉刷新
             self.tableView.emptyDataSetSource = self;
             self.tableView.emptyDataSetDelegate = self;
             // self.tableFooterView = [UIView new];
             MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reloadSearch))];
             self.tableView.mj_header = header;
             // 设置自动切换透明度(在导航栏下面自动隐藏)
             header.automaticallyChangeAlpha = YES;
             // 隐藏时间
             header.lastUpdatedTimeLabel.hidden = YES;
             self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadSearch)];
              // 马上进入刷新状态
            [self beginload];
             num=1;
        }
    }
    else{

            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSDictionary *JSONDic=[defaults objectForKey:@"otherSay"];
            [self reLoadData:JSONDic];
            MomentsModel *momentsModel=datas[0];
            if(momentsModel.username){
                self.navigationItem.title = [NSString stringWithFormat:@"%@的说说",momentsModel.username];
                self.JSONDic=[defaults objectForKey:@"otherSay"];
                self.LikesDic=[Config getSayLike];
               // [self loadData:self.JSONDic];
                [self loadLikesData:self.LikesDic];
                
//                [self reload];
//                 momentsTableView = [[MomentsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain withSay:[defaults objectForKey:@"otherSay"] withSayLike:[Config getSayLike]];
//                momentsTableView.HiddenMJ;
            }

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walkVCClick:) name:@"btnCommit" object:nil];
    
}
- (void)walkVCClick:(NSNotification *)noti

{
    [self reload];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers count]==2&&[Config getIs]==1) {
        [Config setIs:0];
    }
}



-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    //    [YCXMenu setTitleFont:[UIFont systemFontOfSize:19.0]];
    //    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        UIView *blindView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        blindView.backgroundColor = [UIColor blackColor];
        blindView.alpha=0.5;
        blindView.tag=99;
        [[[UIApplication  sharedApplication]  keyWindow] addSubview:blindView];
        [YCXMenu showMenuInView:[[UIApplication  sharedApplication]  keyWindow] fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        }];
    }
    
}
- (NSMutableArray *)items {
    if (!_items) {
        YCXMenuItem *firstTitle = [YCXMenuItem menuItem:@"添加说说" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addSay)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *SecondTitle = [YCXMenuItem menuItem:@"我的说说" image:[UIImage imageNamed:@"mine"] target:self action:@selector(mySay)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        
        YCXMenuItem *SearchTitle = [YCXMenuItem menuItem:@"搜索说说" image:[UIImage imageNamed:@"ico_im_find"] target:self action:@selector(search)];
        SearchTitle.foreColor = [UIColor blackColor];
        SearchTitle.alignment = NSTextAlignmentCenter;
        
        YCXMenuItem *interacTitle = [YCXMenuItem menuItem:@"我的互动" image:[UIImage imageNamed:@"menu_talk"] target:self action:@selector(interact)];
        interacTitle.foreColor = [UIColor blackColor];
        interacTitle.alignment = NSTextAlignmentCenter;
        
        YCXMenuItem *hotTitle = [YCXMenuItem menuItem:@"热门说说" image:[UIImage imageNamed:@"set_new"] target:self action:@selector(hot)];
        hotTitle.foreColor = [UIColor blackColor];
        hotTitle.alignment = NSTextAlignmentCenter;
        
        _items = [@[firstTitle,
                    SecondTitle,
                    SearchTitle,
                    interacTitle,
                    hotTitle
                    ] mutableCopy];
    }
    return _items;
}
-(void)hot{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    MomentsViewController *Say      = [[MomentsViewController alloc] init];
    Say.keyWord = @"./#hotTalk#";
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];

}

-(void)interact{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    MomentsViewController *Say      = [[MomentsViewController alloc] init];
    Say.keyWord = @"./#MyTalk#";
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
}

-(void)search{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    
    MomentsSearchViewController *search      = [[MomentsSearchViewController alloc] init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:search animated:YES];
}

-(void)mySay{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@",Config.getApiMomentsUser,Config.getUserId];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
            NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content.count!=0) {
                [defaults setObject:Say_content forKey:@"otherSay"];
                [defaults synchronize];
                HideAllHUD
                [Config setIs:1];
                MomentsViewController *Say      = [[MomentsViewController alloc] init];
                Say.keyWord = @"";
                AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
            }else{
                HideAllHUD
                [MBProgressHUD showError:@"您没有发布的说说" toView:self.view];
            }
        }
        else{
            HideAllHUD
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络超时" toView:self.view];
        
    }];
}
-(void)addSay{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [Config pushViewController:@"AddSay"];
}
- (id) init{
    self = [super init];
    if(self != nil){
        //监听一个通知，当收到通知时，调用notificationAction方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeYCXMenuBlind) name:@"YCXMenuWillDisappearNotification" object:nil];
    }
    return self;
}
- (void)dealloc{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YCXMenuWillDisappearNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)removeYCXMenuBlind{
    UIView *blindView=[[[UIApplication  sharedApplication]  keyWindow] viewWithTag:99];
    [blindView removeFromSuperview];
}

-(void)HiddenMJ{
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_header.hidden = YES;
}
-(void)beginload{
    [self.tableView.mj_header beginRefreshing];
}
- (void)drawCell:(MomentsCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    MomentsModel *data = [datas objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.likesData = likeDatas;
    cell.momentsTable=self.tableView;
    cell.data = data;
    [cell draw];
    [cell loadPhoto];
}

#pragma mark - 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentsModel *momentsModel=datas[indexPath.section];
    return SYReal(70)+momentsModel.textHeight+momentsModel.photoHeight+SYReal(40)+momentsModel.commentsHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
// 40 + 10.fitW + 5.fitW + (20) + 5.fitW +(contentHeight) + 5.fitW + (imgHeight) + 5.fitW + 20 + 5.fit + 1 + 5.fit + (commentHeihgt)

// 65 + 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"MomentsCell";
    MomentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[MomentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    [self drawCell:cell withIndexPath:indexPath];
    
    return cell;
}
#pragma mark - 处理数据
-(void)loadData:(NSDictionary*)JSONDic{
    for (NSDictionary *eachDic in JSONDic) {
        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
        [datas addObject:momentsModel];
    }
}
-(void)reLoadData:(NSDictionary*)JSONDic{
    datas = [[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONDic) {
        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
        [datas addObject:momentsModel];
    }
}
-(void)loadLikesData:(NSDictionary*)JSONDic{
    likeDatas=[[LikesModel alloc]initWithDic:JSONDic];
}
#pragma mark - 加载方法
-(void)reload{
    /**拼接地址*/
    NSString *likesDataString=Config.getApiMomentsLikesShow;
    [Config setNoSharedCache];
    [APIRequest GET:[Config getApiMoments:1] parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
            NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content) {
                [Config saveSay:Say_content];
                [self reLoadData:Say_content];
                [APIRequest GET:likesDataString parameters:nil success:^(id responseObject) {
                    NSDictionary *sayLikesAll = [NSDictionary dictionaryWithDictionary:responseObject];
                    [Config saveSayLikes:responseObject];
                    [self loadLikesData:sayLikesAll];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
                }failure:^(NSError *error) {
                    
                }];
            }
            else{
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD showError:@"网络错误" toView:self.view];
            }
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
        }
    }failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
    }];
}
-(void)reloadSearch{
    /**拼接地址*/
    NSString *likesDataString=Config.getApiMomentsLikesShow;
    [Config setNoSharedCache];
    NSString *url = [[NSString alloc] init];
    if([_keyWord isEqualToString:@"./#MyTalk#"]) {
        url = [Config getApiMyTalk:1];
    }else if([_keyWord isEqualToString:@"./#hotTalk#"]) {
        url = [Config getApiHotTalk:1];
    }
    else {
        url = [Config getApiMomentsSearch:1 key:_keyWord];
    }
    
    [APIRequest GET:url parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if (true) {
            NSDictionary *Say_content=[Say_All objectForKey:@"statement"];
            //NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content) {
                [Config saveSay:Say_content];
                [self reLoadData:Say_content];
//                [APIRequest GET:likesDataString parameters:nil success:^(id responseObject) {
//                    NSDictionary *sayLikesAll = [NSDictionary dictionaryWithDictionary:responseObject];
//                    [Config saveSayLikes:responseObject];
//                    [self loadLikesData:sayLikesAll];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
//                }failure:^(NSError *error) {
//
//                }];
            }
            else{
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD showError:@"网络错误" toView:self.view];
            }
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:[Say_All objectForKey:@"请求错误"]];
        }
    }failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
    }];
}

-(void)load{
    num++;
    /**拼接地址*/
    NSString *url = [[NSString alloc] init];
    if ([_keyWord isEqualToString:@""]) {
        url = [Config getApiMoments:num];
    }else {
        url = [Config getApiMomentsSearch:num key:_keyWord];
        NSLog(@"%@",url);
    }
    [APIRequest GET:[Config getApiMoments:num] parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
            NSNumber *sayMax=[Say_Data[@"info"]objectForKey:@"page_max"];
            NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content!=NULL) {
                [self loadData:Say_content];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
                if (num==[sayMax intValue]) {
                    [MBProgressHUD showSuccess:@"当前为最大页数" toView:self.view];
                    self.tableView.mj_footer.hidden = YES;
                }
                
            }else{
                [self.tableView.mj_footer endRefreshing];
                [MBProgressHUD showError:@"没有找到说说数据" toView:self.view];
                num--;
            }
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
            num--;
        }
        
    }failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
        num--;
    }];
}
-(void)loadSearch{
        num++;
    /**拼接地址*/
    [APIRequest GET:[Config getApiMomentsSearch:num key:_keyWord] parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if (true) {
            [MBProgressHUD showSuccess:@"当前为最大页数" toView:self.view];
            self.tableView.mj_footer.hidden = YES;
            
//            NSDictionary *Say_content=[Say_All objectForKey:@"statement"];
//            NSNumber *sayMax=[Say_Data[@"info"]objectForKey:@"page_max"];
//            NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
//            if (Say_content!=NULL) {
//                [self loadData:Say_content];
//                [self.tableView.mj_footer endRefreshing];
//                [self.tableView reloadData];
//                if (num==[sayMax intValue]) {
//                    [MBProgressHUD showSuccess:@"当前为最大页数" toView:self.view];
//                    self.tableView.mj_footer.hidden = YES;
//                }
//
//            }else{
//                [self.tableView.mj_footer endRefreshing];
//                [MBProgressHUD showError:@"没有找到说说数据" toView:self.view];
//                num--;
//            }
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
            num--;
        }
        
    }failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
        num--;
    }];
}
-(void)loadMyTalk{
        num++;
    /**拼接地址*/
    [APIRequest GET:[Config getApiMyTalk:num] parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if (true) {
            [MBProgressHUD showSuccess:@"当前为最大页数" toView:self.view];
            self.tableView.mj_footer.hidden = YES;
            
            NSDictionary *Say_content=[Say_All objectForKey:@"statement"];
//            NSNumber *sayMax=[Say_Data[@"info"]objectForKey:@"page_max"];
//            NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content!=NULL) {
                [self loadData:Say_content];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
//                if (num==[sayMax intValue]) {
//                    [MBProgressHUD showSuccess:@"当前为最大页数" toView:self.view];
//                    self.tableView.mj_footer.hidden = YES;
//                }

            }else{
                [self.tableView.mj_footer endRefreshing];
                [MBProgressHUD showError:@"没有找到说说数据" toView:self.view];
                num--;
            }
        }
        else{
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
            num--;
        }
        
    }failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
        num--;
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

//
//  LostViewController.m
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostViewController.h"
#import "JRWaterFallLayout.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "LostCell.h"
#import "Lost.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YCXMenuItem.h"
#import "YCXMenu.h"
#import "LostShowViewController.h"
#import "LostAddViewController.h"

@interface LostViewController ()<UICollectionViewDataSource, JRWaterFallLayoutDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,copy) NSMutableArray      *lostData;
@property (nonatomic, copy) NSMutableArray      *lostArray;
//菜单按钮
@property (nonatomic , strong) NSMutableArray *items;
@property(nonatomic,strong)UIView *blindView;
//当前页
@property(nonatomic, assign)  int currentPage;
@end

@implementation LostViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题颜色和返回箭头
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.navigationItem.title=@"失物招领";
    //当前页
    self.currentPage = 1;
    // 创建瀑布流layout
    JRWaterFallLayout *layout = [[JRWaterFallLayout alloc] init];
    // 设置代理
    layout.delegate = self;
    // 创建瀑布流view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    //如果是我的失物界面
    if (self.myLostArray) {
        [self reloadData:self.myLostArray];
        self.navigationItem.title=@"我的失物";
        [self.collectionView reloadData];
    }else if (self.otherLostArray) {//如果是其他人的发布
        self.myLostArray=self.otherLostArray;
        [self reloadData:self.myLostArray];
        self.navigationItem.title=[NSString stringWithFormat:@"%@的失物列表",self.otherName];
        [self.collectionView reloadData];
    }else{
        // 隐藏时间的下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
        self.collectionView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loads)];
        footer.stateLabel.hidden = YES;
        self.collectionView.mj_footer = footer;
        [self.collectionView.mj_header beginRefreshing];
        //按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }
    //空白数据代理
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    //遮挡层
    self.blindView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.blindView.backgroundColor = [UIColor blackColor];
    self.blindView.alpha=0;
}
#pragma mark - 加载数据
-(void)reload{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [APIRequest GET:[Config getApiLost:self.currentPage] parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDic objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *lostDataDic=[responseDic objectForKey:@"data"];
            NSArray *lostDataPostArray=[lostDataDic objectForKey:@"posts"];//加载该页数据
            if (lostDataPostArray!=NULL) {
                [defaults setObject:lostDataPostArray forKey:@"Lost"];
                [self reloadData:lostDataPostArray];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
                self.collectionView.mj_header.hidden = YES;
            }else{
                [self.collectionView.mj_header endRefreshing];
                [MBProgressHUD showError:@"网络错误" toView:self.view];
            }
        }
        else{
            [self.collectionView.mj_header endRefreshing];
            [MBProgressHUD showError:[responseDic objectForKey:@"msg"] toView:self.view];
        }
    }failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
    }];
};
-(void)loads{
    self.currentPage++;
    /**拼接地址*/
    [APIRequest GET:[Config getApiLost:self.currentPage] parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDic objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *lostDataDic=[responseDic objectForKey:@"data"];
            NSArray *lostDataPostArray=[lostDataDic objectForKey:@"posts"];//加载该页数据
            if (lostDataPostArray!=NULL) {
                [self loadData:lostDataPostArray];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
                self.collectionView.mj_header.hidden = YES;
            }
        }
        else{
            [self.collectionView.mj_header endRefreshing];
            [MBProgressHUD showError:[responseDic objectForKey:@"msg"] toView:self.view];
        }
        
    }failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络错误" toView:self.view];
    }];
}
-(void)reloadData:(NSArray*)JSONArray{
    _lostArray = [[NSMutableArray alloc]init];
    [_lostArray  removeAllObjects];
    for (NSDictionary *eachDic in JSONArray) {
        Lost *lostModel=[[Lost alloc]initWithDic:eachDic];
        [self.lostArray addObject:lostModel];
    }
}
-(void)loadData:(NSArray*)JSONArray{
    for (NSDictionary *eachDic in JSONArray) {
        Lost *lostModel=[[Lost alloc]initWithDic:eachDic];
        [self.lostArray addObject:lostModel];
    }
}
#pragma mark - <UICollectionViewDataSource>代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.lostArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell 并且重用
    NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    [collectionView registerClass:[LostCell class] forCellWithReuseIdentifier:identifier];
    LostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // 给cell传递模型
    Lost *lost=self.lostArray[indexPath.item];
    cell.lostModel = lost;
    [cell draw];
    //点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [cell.contentView addGestureRecognizer:tap];
    // 返回cell
    return cell;
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.collectionView];
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    Lost *lost=self.lostArray[indexPath.item];
    _currentIndexPath = indexPath;
    LostShowViewController *lostShowViewController=[[LostShowViewController alloc]init];
    if (self.myLostArray) {
        lostShowViewController.isSelf=true;
    }
    lostShowViewController.lostModel=lost;
 
    self.navigationController.delegate = lostShowViewController;
    [self.navigationController pushViewController:lostShowViewController animated:YES];
}
- (CGFloat)waterFallLayout:(JRWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width
{
    Lost *lost=self.lostArray[index];
    return lost.textHeight+lost.photoHeight+SYReal(40);
}

#pragma mark - 菜单
-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
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
        YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"添加失物" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addLost)];
        menuTitle.foreColor = [UIColor blackColor];
        menuTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"我的发布" image:[UIImage imageNamed:@"mine"] target:self action:@selector(myLost)];
        logoutItem.foreColor = [UIColor blackColor];
        logoutItem.alignment = NSTextAlignmentCenter;
        _items = [@[menuTitle,
                    logoutItem
                    ] mutableCopy];
    }
    return _items;
}
-(void)addLost{
    LostAddViewController *lostAddViewController2=[[LostAddViewController alloc]init];
    [self.navigationController pushViewController:lostAddViewController2 animated:YES];
}
-(void)myLost{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    //发起请求
    [APIRequest GET:Config.getApiLostUser parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDic objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *responseDataDic=[responseDic objectForKey:@"data"];
            NSArray *responseDataPostArray=[responseDataDic objectForKey:@"posts"];//加载该页数据
            if (responseDataPostArray.count!=0) {
                HideAllHUD
                LostViewController *lostViewController=[[LostViewController alloc]init];
                lostViewController.myLostArray=responseDataPostArray;
                [self.navigationController pushViewController:lostViewController animated:YES];
            }else{
                HideAllHUD
                [MBProgressHUD showError:@"您没有发布的失物" toView:self.view];
            }
        }
        else{
            HideAllHUD
            [MBProgressHUD showError:[responseDic objectForKey:@"msg"] toView:self.view];
        }
    }failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络超时" toView:self.view];
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
    [self.collectionView.mj_header beginRefreshing];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YCXMenuWillDisappearNotification" object:nil];
}
-(void)removeYCXMenuBlind{
    UIView *blindView=[[[UIApplication  sharedApplication]  keyWindow] viewWithTag:99];
    [blindView removeFromSuperview];
}

@end

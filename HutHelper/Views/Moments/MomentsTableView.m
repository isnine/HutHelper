//
//  MomentsTableView.m
//  HutHelper
//
//  Created by Nine on 2017/3/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsTableView.h"
#import "MomentsCell.h"
#import "MomentsModel.h"
#import "LikesModel.h"
#import "AFNetworking.h"
#import "UILabel+LXAdd.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
@interface MomentsTableView() <UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end
@implementation MomentsTableView{
    NSMutableArray *datas;
    LikesModel *likeDatas;
    NSMutableArray *needLoadArr;
    BOOL scrollToToping;
    int num;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withSay:(NSDictionary *)JSONDic withSayLike:(NSDictionary *)LikesDic{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        datas = [[NSMutableArray alloc] init];
        needLoadArr = [[NSMutableArray alloc] init];
//        NSDictionary *JSONDic=[Config getSay];
//        NSDictionary *LikesDic=[Config getSayLike];
        [self loadData:JSONDic];
        [self loadLikesData:LikesDic];
        num=1;
        //        [self reloadData];
    }
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
  // self.tableFooterView = [UIView new];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
    self.mj_header = header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];

    
    return self;
}
-(void)HiddenMJ{
    self.mj_footer.hidden = YES;
    self.mj_header.hidden = YES;
}
-(void)beginload{
    [self.mj_header beginRefreshing];
}
- (void)drawCell:(MomentsCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    MomentsModel *data = [datas objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LikesData = likeDatas;
    cell.momentsTable=self;
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
                              [self.mj_header endRefreshing];
                              [self reloadData];
                          }failure:^(NSError *error) {
                              
                          }];
                 }
                 else{
                     [self.mj_header endRefreshing];
                     [MBProgressHUD showError:@"网络错误" toView:self];
                 }
             }
             else{
                 [self.mj_header endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
         }failure:^(NSError *error) {
             [self.mj_header endRefreshing];
             [MBProgressHUD showError:@"网络错误" toView:self];
         }];
}
-(void)load{
    num++;
    /**拼接地址*/
    [APIRequest GET:[Config getApiMoments:num] parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSNumber *sayMax=[Say_Data[@"info"]objectForKey:@"page_max"];
                 NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [self loadData:Say_content];
                     [self.mj_footer endRefreshing];
                     [self reloadData];
                     if (num==[sayMax intValue]) {
                         [MBProgressHUD showSuccess:@"当前为最大页数" toView:self];
                         self.mj_footer.hidden = YES;
                     }
                     
                 }else{
                     [self.mj_footer endRefreshing];
                     [MBProgressHUD showError:@"没有找到说说数据" toView:self];
                     num--;
                 }
             }
             else{
                 [self.mj_footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self];
                 num--;
             }
             
         }failure:^(NSError *error) {
             [self.mj_footer endRefreshing];
             [MBProgressHUD showError:@"网络错误" toView:self];
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
    [self.mj_header beginRefreshing];
}
@end

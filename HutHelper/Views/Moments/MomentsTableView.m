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
 
@interface MomentsTableView() <UITableViewDelegate, UITableViewDataSource>

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
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
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
    return 15;
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
    NSString *Url_String=[NSString stringWithFormat:@"%@/%d",Config.getApiMoments,1];
    NSString *likesDataString=Config.getApiMomentsLikesShow;
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSDictionary *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content) {
                     [Config saveSay:Say_content];
                     [APIRequest GET:likesDataString parameters:nil success:^(id responseObject) {
                              NSDictionary *sayLikesAll = [NSDictionary dictionaryWithDictionary:responseObject];
                              [Config saveSayLikes:responseObject];
                              [self reLoadData:Say_content];
                              [self loadLikesData:sayLikesAll];
                              [self.mj_header endRefreshing];
                              [self reloadData];
                          }failure:^(NSError *error) {
                          }];
                 }
                 else{
                     [self.mj_header endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.mj_header endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
         }failure:^(NSError *error) {
             [self.mj_header endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(void)load{
    num++;
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:@"%@/%d",Config.getApiMoments,num];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
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
                         [MBProgressHUD showSuccess:@"当前为最大页数"];
                         self.mj_footer.hidden = YES;
                     }
                     
                 }else{
                     [self.mj_footer endRefreshing];
                     [MBProgressHUD showError:@"没有找到说说数据"];
                     num--;
                 }
             }
             else{
                 [self.mj_footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
                 num--;
             }
             
         }failure:^(NSError *error) {
             [self.mj_footer endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
             num--;
         }];
}
@end

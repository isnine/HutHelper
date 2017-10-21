//
//  CourseXpTableViewController.m
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CourseXpTableViewController.h"
#import "CourseXpTableViewCell.h"
#import "CourseXp.h"
#import "MJRefresh.h"
#import "APIRequest.h"
#import "MBProgressHUD+MJ.h"
#import "UIScrollView+EmptyDataSet.h"
@interface CourseXpTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation CourseXpTableViewController{
    NSMutableArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实验课表";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //空白状态
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self loadData:[Config getCourseXp]];
    // 隐藏时间的下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector((reload))];
    self.tableView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    //MJRefresh适配iOS11

//    //左滑手势
//    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
}

//- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
//{
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
//        [Config setIs:1];
//        [Config pushViewController:@"Class"];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData:(NSArray*)JSONDic{
    datas=[[NSMutableArray alloc]init];
    NSMutableArray *JSONDicMutableArray=[[NSMutableArray alloc]initWithArray:JSONDic];
    NSMutableArray *JSONDicMutableArrayFinish=[[NSMutableArray alloc]initWithArray:JSONDic];
    //排序
    for (int i=0; i<JSONDicMutableArray.count; i++) {
        for (int j=i; j<JSONDicMutableArray.count; j++) {
            if ([JSONDicMutableArray[i][@"weeks_no"] intValue]*100+[JSONDicMutableArray[i][@"week"] intValue]*10>
                [JSONDicMutableArray[j][@"weeks_no"] intValue]*100+[JSONDicMutableArray[j][@"week"] intValue]*10) {
                [JSONDicMutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
    }
    //添加未完成课表
    for (NSDictionary *eachDic in JSONDicMutableArray) {
        if (!(([Math getWeek]>[eachDic[@"weeks_no"] intValue])
            ||(([Math getWeek]==[eachDic[@"weeks_no"] intValue])
               &&([Math getWeekDay]>[eachDic[@"week"] intValue])))) {
                CourseXp *courseXp=[[CourseXp alloc]initWithDic:eachDic];
                [datas addObject:courseXp];
            }
    }
    //添加已完成课表
    for (NSDictionary *eachDic in JSONDicMutableArray) {
        if (([Math getWeek]>[eachDic[@"weeks_no"] intValue])
            ||(([Math getWeek]==[eachDic[@"weeks_no"] intValue])
             &&([Math getWeekDay]>[eachDic[@"week"] intValue]))) {
                CourseXp *courseXp=[[CourseXp alloc]initWithDic:eachDic];
                [datas addObject:courseXp];
            }
    }
}
-(void)drawCell:(CourseXpTableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    cell.data=datas[indexPath.section];
    [cell draw];
}
-(void)reload{
    NSString *urlXpString=Config.getApiClassXP;
    [Config setNoSharedCache];
    [APIRequest GET:urlXpString parameters:nil success:^(id responseObject) {
        NSString *msg=responseObject[@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            NSArray *arrayCourseXp= responseObject[@"data"];
            [Config saveCourseXp:arrayCourseXp];
            [Config saveWidgetCourseXp:arrayCourseXp];
            [self loadData:[Config getCourseXp]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络超时，实验课表查询失败"toView:self.view];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SYReal(190);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SYReal(15);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"CourseXpCell";
    CourseXpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell=[[CourseXpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    cell.userInteractionEnabled = NO;
    
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
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
